//
//  AccessViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 12/15/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4
import FBSDKLoginKit
import CoreData
import CoreLocation

class AccessViewController: UIViewController, CLLocationManagerDelegate, UITextViewDelegate {
    
    //User Interface
    let backgroundView = UIImageView()
    let accessTextView = UITextView()
    var updatedText = ""
    
    //Loading App
    let transitionManager = TransitionManager()
    var locationManager = CLLocationManager()
    var geoPoint:PFGeoPoint?
    
    var accessCode = ""
    
    //User Interactions
    var tapGestureRecognizer = UITapGestureRecognizer()

    // Do we need this function anymore? Not being called from anywhere. cIgAr 08/18/16
    //right now just updates users Friends
    func updateUser() {
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "friends"])
        graphRequest?.start { (connection, result, error) -> Void in
            if error != nil {
                print(error)
            } else if let result = result as? [String:AnyObject]{
                let friends = result["friends"]! as! NSDictionary
                let friendsData : NSArray = friends.object(forKey: "data") as! NSArray
                var fbFriendIds = [String]()
                for friend in friendsData {
                    let valueDict : NSDictionary = friend as! NSDictionary
                    fbFriendIds.append(valueDict.object(forKey: "id") as! String)
                }
                
                PFUser.current()?["fb_friends"] = fbFriendIds
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    if error != nil {
                        print(error)
                    } else {
                        self.updateFriendList()
                    }
                })
            }
        }
    }
    
    func updateFriendList() {
        //add graph request to update users fb_friends
        //query to find and save fb_friends
        let currentUserFbFriends = PFUser.current()!["fb_friends"] as! NSArray
        let query: PFQuery = PFQuery(className: "_User")
        query.whereKey("fb_id", containedIn: currentUserFbFriends as! [Any])
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if error != nil {
                print(error)
            } else if let objects = objects {
                PFUser.current()?.fetchInBackground(block: { (success, error) in
                    for object in objects {
                        var containedInFriendList = false
                        if let friendList: NSArray = PFUser.current()!["friend_list"] as? NSArray {
                            //This was exchanged for the following in Swift3 migration -> containedInFriendList = friendList.contains {$0 as! String == object.objectId!}
                            containedInFriendList = friendList.contains(object.objectId!)
                        }
                        if containedInFriendList == false {
                            if PFUser.current()!["friend_list"] != nil {
                                let currentFriendList = PFUser.current()!["friend_list"]
                                PFUser.current()!["friend_list"] = currentFriendList as! Array + [object.objectId!]
                            } else {
                                PFUser.current()!["friend_list"] = [object.objectId!]
                            }
                        }
                        PFUser.current()?.saveInBackground()
                    }
                })
            }
        }
    }
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        locationManager.stopUpdatingLocation()
        //print("didUpdateLocations")
        if manager.location != nil {
            geoPoint = PFGeoPoint(latitude: manager.location!.coordinate.latitude, longitude: manager.location!.coordinate.longitude)
            //print("LoadViewController posting a notification")
            //print("\(geoPoint?.latitude),\(geoPoint?.longitude)")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "storeUserLocationOnParse"), object: nil, userInfo:  ["geoPoint":geoPoint!])
        }
    }

    func authenticateUser() {
        
        PFUser.current()?.fetchInBackground(block: { (object, error) in
            
            /*
             print("deleting prof pics")
             user.remove(forKey: "profile_pictures")
             user.saveInBackground()
             */
            if let user = object as? PFUser {
                if user["profile_pictures"] == nil {
                    print("no profile pictures: logging out...")
                    PFUser.logOutInBackground(block: { (error) in
                        if error != nil {
                            print(error)
                        } else {
                            print("log out successful")
                            self.displayLoginWithFacebook()
                        }
                    })
                    return
                }
            }
            
            let localData = LocalData()
            let hasSignedUp:Bool = localData.getHasSignedUp() ?? false
            
            //Updating the user's friends
            self.updateUser()
            if (localData.getUsername() != nil) && ((PFUser.current()!.objectId) != nil){ //remember to change this back to username
                LocalStorageUtility().getUserFriends()
                //LocalStorageUtility().getMainProfilePicture()
                
                
                //User has SignedUp before
                if hasSignedUp {
                    self.performSegue(withIdentifier: "showBridgeViewController", sender: self)
                } else {
                    self.displayAccessTextView()
                }
            }
            else{
                print("User is not signed In")
                if hasSignedUp {
                    self.displayLoginWithFacebook()
                } else {
                    self.displayAccessTextView()
                }
                
            }
            
        })
    }
    
    func displayAccessTextView() {
        accessTextView.frame = CGRect(x: 0, y: 0.8748*DisplayUtility.screenHeight, width: 0.6*DisplayUtility.screenWidth, height: 0.06822*DisplayUtility.screenHeight)
        accessTextView.center.x = view.center.x
        DisplayUtility.centerTextVerticallyInTextView(textView: accessTextView)
        accessTextView.text = "enter community code"
        accessTextView.textAlignment = NSTextAlignment.center
        let accessTVGradientColor = DisplayUtility.gradientColor(size: accessTextView.frame.size)
        accessTextView.textColor = UIColor.white
        accessTextView.font = UIFont(name: "BentonSans-Light", size: 20.5)
        accessTextView.backgroundColor = DisplayUtility.necterGray
        accessTextView.layer.borderWidth = 1.9
        accessTextView.layer.borderColor = accessTVGradientColor.cgColor
        accessTextView.layer.cornerRadius = 5
        accessTextView.isScrollEnabled = false
        accessTextView.isEditable = false
        accessTextView.keyboardAppearance = .dark
        accessTextView.returnKeyType = UIReturnKeyType.join
        accessTextView.autocorrectionType = .no
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(accessTextViewTapped(_:)))
        accessTextView.addGestureRecognizer(tapGestureRecognizer)
        view.addSubview(accessTextView)
    }
    
    func accessTextViewTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        print("tapped")
        accessTextView.removeGestureRecognizer(tapGestureRecognizer)
        accessTextView.isUserInteractionEnabled = true
        accessTextView.isEditable = true
        accessTextView.becomeFirstResponder()
        accessTextView.textColor = UIColor.lightGray
        accessTextView.selectedTextRange = accessTextView.textRange(from: accessTextView.beginningOfDocument, to: accessTextView.beginningOfDocument)
        //DisplayUtility.centerTextVerticallyInTextView(accessTextView)
    }
    
    func displayLoginWithFacebook() {
        let fbLoginButton = UIButton()
        fbLoginButton.frame = CGRect(x: 0, y: 0.8748*DisplayUtility.screenHeight, width: 0.54125*DisplayUtility.screenWidth, height: 0.04093*DisplayUtility.screenHeight)
        fbLoginButton.center.x = view.center.x
        fbLoginButton.setTitle("LOGIN WITH FACEBOOK", for: .normal)
        fbLoginButton.setTitleColor(UIColor.white, for: .normal)
        fbLoginButton.setTitleColor(DisplayUtility.gradientColor(size: (fbLoginButton.titleLabel?.frame.size)!), for: .highlighted)
        fbLoginButton.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 12)
        fbLoginButton.backgroundColor = UIColor(red: 66.0/255.0, green: 103.0/255.0, blue: 178.0/255.0, alpha: 1)
        fbLoginButton.layer.cornerRadius = 8
        //fbLoginButton.showsTouchWhenHighlighted = false
        fbLoginButton.addTarget(self, action: #selector(fbLoginTapped(_:)), for: .touchUpInside)
        view.addSubview(fbLoginButton)
        
        let noPostingLabel = UILabel(frame: CGRect(x: 0, y: 0.93*DisplayUtility.screenHeight, width: 0.9*DisplayUtility.screenWidth, height: 0.02*DisplayUtility.screenHeight))
        noPostingLabel.center.x = view.center.x
        noPostingLabel.textAlignment = NSTextAlignment.center
        noPostingLabel.text = "No need to get sour! We never post to Facebook."
        noPostingLabel.font = UIFont(name: "BentonSans-Light", size: 12)
        noPostingLabel.textColor = UIColor.darkGray
        noPostingLabel.numberOfLines = 1
        noPostingLabel.alpha = 0
        view.addSubview(noPostingLabel)
        
        //Close the keybaord
        accessTextView.resignFirstResponder()
        
        UIView.animate(withDuration: 0.2) {
            self.accessTextView.alpha = 1
            fbLoginButton.alpha = 1
            noPostingLabel.alpha = 1
            self.backgroundView.image = #imageLiteral(resourceName: "Access_Background")
        }
        
        accessTextView.removeFromSuperview()
    }
    
    func fbLoginTapped (_ sender: UIButton) {
        let facebookFunctions = FacebookFunctions()
        facebookFunctions.loginWithFacebook(vc: self)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            UIView.animate(withDuration: 0.2) {
                self.accessTextView.frame.size.width = 0.9339*DisplayUtility.screenWidth
                self.accessTextView.frame.origin.y = DisplayUtility.screenHeight - keyboardHeight - 0.0225*DisplayUtility.screenHeight - self.accessTextView.frame.height
                self.accessTextView.center.x = self.view.center.x
                self.backgroundView.image = #imageLiteral(resourceName: "Access_Background_With_White")
            }
            let gradientColor = DisplayUtility.gradientColor(size: self.accessTextView.frame.size)
            self.accessTextView.textColor = gradientColor
            self.accessTextView.layer.borderColor = gradientColor.cgColor
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //On Click of Join, check access code
        if text == "\n" {
            if accessTextView.text.lowercased() == "shabbat" {
                accessCode = "shabbat"
                
                displayLoginWithFacebook()
            } else if accessTextView.text.lowercased() == "necter community" {
                accessCode = "necter community"
                
                displayLoginWithFacebook()
            } else {
                accessTextView.text = "incorrect community code"
                accessTextView.textColor = UIColor.lightGray
                accessTextView.selectedTextRange = accessTextView.textRange(from: accessTextView.beginningOfDocument, to: accessTextView.beginningOfDocument)
            }
            return false
        }
        
        
        //Combine the textView text and the replacement text to create the updated text string
        let currentText:NSString = textView.text as NSString
        updatedText = currentText.replacingCharacters(in: range, with: text)
        
        //If updated text view will be empty, add the placeholder and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            //setting the placeholder
            accessTextView.text = "enter community code"
            accessTextView.textColor = UIColor.lightGray
            accessTextView.selectedTextRange = accessTextView.textRange(from: accessTextView.beginningOfDocument, to: accessTextView.beginningOfDocument)
            return false
        }
            // else if the text view's placeholder is showing and the length of the replacement string is greater than 0, clear the text veiw and set the color to white to prepare for entry
        else if accessTextView.textColor == UIColor.lightGray && !updatedText.isEmpty && updatedText != "enter community code" && text != "\n"{
            accessTextView.text = nil
            accessTextView.textColor = UIColor.white
        }
        
        return true
        
    }
    
    //Keeping the selection at the beginning when the placeholder is set
    func textViewDidChangeSelection(_ textView: UITextView) {
        if accessTextView.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }

    func storeUserLocationOnParse(_ notification: Notification) {
        print("storeUserLocationOnParse - \((notification as NSNotification).userInfo)")
        let geoPoint = (notification as NSNotification).userInfo!["geoPoint"] as? PFGeoPoint
        if let geoPoint = geoPoint {
            self.geoPoint = geoPoint
            print(geoPoint)
        } else {
            //self.geoPoint = PFGeoPoint.init(latitude: 0.0, longitude: 0.0)
            print("initialize PFGeoPoint at 0,0")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting the delegate
        accessTextView.delegate = self
        
        //Creating observer for when thekeyboard shows
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

        //Displaying the backgroundView
        backgroundView.frame = CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight)
        backgroundView.image = #imageLiteral(resourceName: "Access_Background")
        view.addSubview(backgroundView)
        
        //Listen for a notification from LoadPageViewController when it has got the user's location. cIgaR 08/18/16
        NotificationCenter.default.addObserver(self, selector: #selector(self.storeUserLocationOnParse), name: NSNotification.Name(rawValue: "storeUserLocationOnParse"), object: nil)
        
        //Updating the location of the user and asking for access if the app has not asked yet
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        //Check if the current user has signed in to decide what to display
        authenticateUser()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let vc = segue.destination
//        let mirror = Mirror(reflecting: vc)
//        if mirror.subjectType == ViewController.self {
//            let vc2 = vc as! ViewController
//            vc2.geoPoint = self.geoPoint
//        }
//    }

}
