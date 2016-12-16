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

class AccessViewController: UIViewController, CLLocationManagerDelegate {
    
    //User Interface
    let backgroundView = UIImageView()
    let accessTextView = UITextView()
    
    //Loading App
    let transitionManager = TransitionManager()
    var locationManager = CLLocationManager()
    var geoPoint:PFGeoPoint?
    
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
            let localData = LocalData()
            //Updating the user's friends
            self.updateUser()
            if (localData.getUsername() != nil) && ((PFUser.current()!.objectId) != nil){ //remember to change this back to username
                LocalStorageUtility().getUserFriends()
                //LocalStorageUtility().getMainProfilePicture()
                let hasSignedUp:Bool = localData.getHasSignedUp() ?? false
                
                //User has SignedUp before
                if hasSignedUp == true {
                    print("hasSignedUP")
                    //self.performSegue(withIdentifier: "showBridgeFromAccess", sender: self)
                } else {
                    print("hasNotSignedUP")
                    //self.performSegue(withIdentifier: "showSignUpFromAccess", sender: self)
                }
                
            }
            else{
                print("User is not signed In")
                self.displayAccessTextView()
            }
        })
    }
    
    func displayAccessTextView() {
        accessTextView.frame = CGRect(x: 0, y: 0.85*DisplayUtility.screenHeight, width: 0.6*DisplayUtility.screenWidth, height: 0.06822*DisplayUtility.screenHeight)
        accessTextView.center.x = view.center.x
        //Center Text Vertically in Text View
        var topCorrect = (accessTextView.bounds.size.height - accessTextView.contentSize.height * accessTextView.zoomScale) / 2
        topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect;
        accessTextView.contentInset.top = topCorrect
        accessTextView.text = "enter community code"
        accessTextView.textAlignment = NSTextAlignment.center
        let accessTVGradientColor = DisplayUtility.gradientColor(size: accessTextView.frame.size)
        accessTextView.textColor = accessTVGradientColor
        accessTextView.font = UIFont(name: "BentonSans-Light", size: 20.5)
        accessTextView.backgroundColor = DisplayUtility.necterGray
        accessTextView.layer.borderWidth = 1.9
        accessTextView.layer.borderColor = accessTVGradientColor.cgColor
        accessTextView.layer.cornerRadius = 5
        accessTextView.isScrollEnabled = false
        accessTextView.isEditable = false
        accessTextView.keyboardAppearance = .dark
        accessTextView.returnKeyType = .next
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
        accessTextView.text = ""
        accessTextView.textColor = UIColor.white
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
            //set placement of the text
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //Creating observer for when the keyboard shows
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

        //Displaying the backgroundView
        backgroundView.frame = CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight)
        backgroundView.image = #imageLiteral(resourceName: "Access_Background")
        view.addSubview(backgroundView)
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination
        let mirror = Mirror(reflecting: vc)
        if mirror.subjectType == ViewController.self {
            let vc2 = vc as! ViewController
            vc2.geoPoint = self.geoPoint
        }
    }

}
