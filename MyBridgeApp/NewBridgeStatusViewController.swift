//
//  NewBridgeStatusViewController.swift
//  MyBridgeApp
//
//  Created by Sagar Sinha on 6/27/16.
//  Copyright © 2016 BHE Ventures LLC. All rights reserved.
//
// This view allows the user to post a status with the necterType Selected in the OptionsFromBotViewController

import UIKit
import Parse

class NewBridgeStatusViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    let selectTypeLabel = UILabel()
    
    let backButton = UIButton()
    let postButton = UIButton()
    let username = UILabel()
    let profilePicture = UIImageView()
    let bridgeStatus = UITextView()
    let nameLabel = UILabel()
    let locationLabel = UILabel()
    let necterTypeLine = UIView()
    let necterTypeIcon = UIImageView()
    
    let localData = LocalData()
    let transitionManager = TransitionManager()

    var enablePost = Bool()
    var seguedFrom = ""
    var didSendPost = false
    var isFirstPost = true
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let necterYellow = UIColor(red: 255/255, green: 230/255, blue: 57/255, alpha: 1.0)
    let businessBlue = UIColor(red: 36.0/255, green: 123.0/255, blue: 160.0/255, alpha: 1.0)
    let loveRed = UIColor(red: 242.0/255, green: 95.0/255, blue: 92.0/255, alpha: 1.0)
    let friendshipGreen = UIColor(red: 112.0/255, green: 193.0/255, blue: 179.0/255, alpha: 1.0)
    let necterGray = UIColor(red: 80.0/255.0, green: 81.0/255.0, blue: 79.0/255.0, alpha: 1.0)
    var necterType = ""
    
    
    func textViewDidChange(_ textView: UITextView) {
        if isFirstPost {
            let newCharacter = bridgeStatus.text.characters.last
            if newCharacter == " " || newCharacter == "."{
                bridgeStatus.text = "I am looking for "
            } else {
                bridgeStatus.text = "I am looking for \(newCharacter!)"
            }
            
            isFirstPost = false
        } else {
            enablePost = true
        }
        
        if enablePost /*|| bridgeStatus.text?.characters.count == 18*/ {
            postButton.layer.borderColor = necterYellow.cgColor
            postButton.setTitleColor(necterYellow, for: .highlighted)
            postButton.isEnabled = true
            enablePost = false
        } else if bridgeStatus.text?.characters.count == 0 {
            postButton.layer.borderColor = necterGray.cgColor
            postButton.isEnabled = false
            enablePost = true
        }
        
        //stopping user from entering bridge status with more than 140 characters
        if let characterCount = bridgeStatus.text?.characters.count {
            if characterCount > 100 {
                let aboveMaxBy = characterCount - 100
                let index1 = bridgeStatus.text!.characters.index(bridgeStatus.text!.endIndex, offsetBy: -aboveMaxBy)
                bridgeStatus.text = bridgeStatus.text!.substring(to: index1)
            }
        }

    }
    
    func backTapped(_ sender: UIButton ){
        
        bridgeStatus.resignFirstResponder()
        
        /*selectTypeLabel.alpha = 0
        backButton.alpha = 0
        postButton.alpha = 0
        profilePicture.alpha = 0
        bridgeStatus.alpha = 0
        nameLabel.alpha = 0
        locationLabel.alpha = 0
        necterTypeLine.alpha = 0
        necterTypeIcon.alpha = 0*/
        
        performSegue(withIdentifier: "showOptionsViewFromNewStatus", sender: self)
        
    }
    func postTapped(_ sender: UIButton){
        //self.vc?.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        bridgeStatus.resignFirstResponder()
        
        backButton.alpha = 0
        postButton.alpha = 0
        selectTypeLabel.alpha = 0
        profilePicture.alpha = 0
        bridgeStatus.alpha = 0
        nameLabel.alpha = 0
        locationLabel.alpha = 0
        necterTypeLine.alpha = 0
        necterTypeIcon.alpha = 0
        
        /*//displaying confirmation that post was sent out and then segueing back to profile
         self.selectTypeLabel.frame = CGRect(x: 0.05*self.screenWidth, y: 0.145*self.screenHeight, width: 0.9*self.screenWidth, height: 0.15*self.screenHeight)
        let _ = Timer(interval: 0.25) {i -> Bool in
            UIView.animateWithDuration(0.6, delay: 0, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                if i == 0 {
                    //intructions fade and drop in
                    self.selectTypeLabel.alpha = 1
                    self.selectTypeLabel.frame = CGRect(x: 0.05*self.screenWidth, y: 0.15*self.screenHeight, width: 0.9*self.screenWidth, height: 0.15*self.screenHeight)
                    let greeting = "I have put your post in front of your friends! I'll put it out to your community." //Way to give your friends the opportunity to help you.
                    let attributedGreeting = NSMutableAttributedString(string: greeting as String, attributes: [NSFontAttributeName: UIFont.init(name: "Verdana", size: 20)!])
                    self.selectTypeLabel.attributedText = attributedGreeting
                } else if i == 6 {
                    self.selectTypeLabel.alpha = 0
                    self.performSegueWithIdentifier("showBridgePageFromStatus", sender: self)
                }
                
            }, completion: nil)
            
            return i < 6
        }*/
        
        //setting the status to local data
        if necterType == "Business" {
            localData.setBusinessStatus(self.bridgeStatus.text!)
            localData.synchronize()
        } else if necterType == "Love" {
            localData.setLoveStatus(self.bridgeStatus.text!)
            localData.synchronize()
        } else if necterType == "Friendship" {
            localData.setFriendshipStatus(self.bridgeStatus.text!)
            localData.synchronize()
        }
        
        let bridgeStatusObject = PFObject(className: "BridgeStatus")
        bridgeStatusObject["bridge_status"] = self.bridgeStatus.text!
        bridgeStatusObject["bridge_type"] = self.necterType
        bridgeStatusObject["userId"] = PFUser.current()?.objectId
        bridgeStatusObject.saveInBackground { (success, error) in
            
            
            if error != nil {
                //sends notification to call displayMessageFromBot function
                let userInfo = ["message" : "Your post did not go through. Please wait a minute and try posting again"]
                NotificationCenter.default.post(name: Notification.Name(rawValue: "displayMessageFromBot"), object: nil, userInfo: userInfo)
            } else if success {
                //sends notification to call displayMessageFromBot function
                let userInfo = ["message" : "Your post is now being shown to friends so they can connect you!"]
                self.didSendPost = true
                NotificationCenter.default.post(name: Notification.Name(rawValue: "displayMessageFromBot"), object: nil, userInfo: userInfo)
            }
        }
        let pfCloudFunctions = PFCloudFunctions()
        pfCloudFunctions.changeBridgePairingsOnStatusUpdate(parameters: ["status":self.bridgeStatus.text!, "bridgeType":self.necterType])
        performSegueToPriorView()
    }
    
    func performSegueToPriorView() {
        if seguedFrom == "ProfileViewController" {
            performSegue(withIdentifier: "showProfilePageFromNewStatusView", sender: self)
        } else if seguedFrom == "BridgeViewController" {
            performSegue(withIdentifier: "showBridgePageFromStatus", sender: self)
        } else if seguedFrom == "MessagesViewController" {
            performSegue(withIdentifier: "showMessagesViewfromStatus", sender: self)
        } else {
            //default case
            performSegue(withIdentifier: "showBridgePageFromStatus", sender: self)
        }
    }
    
    func displayInstructionsFromBot() {
        print("instructions should display")
        let botInstructionsView = UIView()
        botInstructionsView.frame = CGRect(x: 0, y: -0.12*self.screenHeight, width: self.screenWidth, height: 0.12*self.screenHeight)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = botInstructionsView.bounds
        //blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let messageLabel = UILabel(frame: CGRect(x: 0.05*screenWidth, y: 0.01*screenHeight, width: 0.9*screenWidth, height: 0.11*screenHeight))
        messageLabel.text = "Awesome! Now post a status to give your friends more information."
        messageLabel.textColor = UIColor.darkGray
        messageLabel.font = UIFont(name: "Verdana-Bold", size: 14)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = NSTextAlignment.center
        
        botInstructionsView.addSubview(messageLabel)
        botInstructionsView.insertSubview(blurEffectView, belowSubview: messageLabel)
        //botNotificationView.alpha = 0
        //botNotificationView.backgroundColor = necterYellow
        view.insertSubview(botInstructionsView, aboveSubview: necterTypeIcon)
        
        //UIView.animateWithDuration(0.7) {
            
        //}
        let _ = CustomTimer(interval: 1) {i -> Bool in
            UIView.animate(withDuration: 0.7, animations: {
                if i == 0 {
                    botInstructionsView.frame.origin.y = 0
                } else if i == 4 {
                    botInstructionsView.frame.origin.y = -0.12*self.screenHeight
                    
                } else if i == 5 {
                    botInstructionsView.removeFromSuperview()
                }
            })
            return i < 6
        }
        
    }

    //getting status from the currentUser's most recent status
    func retrieveStatusForType() -> String {
        var necterStatusForType = "I am looking for..."
        if necterType == "Business" {
            if let status = localData.getBusinessStatus() {
                necterStatusForType = status
            } else {
                //query for current user in userId, limit to 1, and find most recently posted "Business" bridge_type
                let query: PFQuery = PFQuery(className: "BridgeStatus")
                query.whereKey("userId", equalTo: (PFUser.current()?.objectId)!)
                query.whereKey("bridge_type", equalTo: "Business")
                query.order(byDescending: "createdAt")
                query.limit = 1
                do {
                    let objects = try query.findObjects()
                    for object in objects {
                        necterStatusForType = object["bridge_status"] as! String
                        localData.setBusinessStatus(necterStatusForType)
                    }
                } catch {
                    print("Error in catch getting status")
                }
            }
        } else if necterType == "Love" {
            if let status = localData.getLoveStatus() {
                necterStatusForType = status
            } else {
                print("got into Love Statuses")
                //query for current user in userId, limit to 1, and find most recently posted "Business" bridge_type
                let query: PFQuery = PFQuery(className: "BridgeStatus")
                query.whereKey("userId", equalTo: (PFUser.current()?.objectId)!)
                query.whereKey("bridge_type", equalTo: "Love")
                query.order(byDescending: "createdAt")
                query.limit = 1
                do {
                    let objects = try query.findObjects()
                    for object in objects {
                        necterStatusForType = object["bridge_status"] as! String
                        localData.setLoveStatus(necterStatusForType)
                    }
                } catch {
                    print("Error in catch getting status")
                }
            }
        } else if necterType == "Friendship" {
            if let status = localData.getFriendshipStatus() {
                necterStatusForType = status
            } else {
                print("got into Friendship Statuses")
                //query for current user in userId, limit to 1, and find most recently posted "Business" bridge_type
                let query: PFQuery = PFQuery(className: "BridgeStatus")
                query.whereKey("userId", equalTo: (PFUser.current()?.objectId)!)
                query.whereKey("bridge_type", equalTo: "Friendship")
                query.order(byDescending: "createdAt")
                query.limit = 1
                do {
                    let objects = try query.findObjects()
                    for object in objects {
                        necterStatusForType = object["bridge_status"] as! String
                        localData.setFriendshipStatus(necterStatusForType)
                    }
                } catch {
                    print("Error in catch getting status")
                }
            }
        }
        if necterStatusForType != "I am looking for..." {
            print("isFirstPost set to \(isFirstPost)")
            isFirstPost = false
        }
        return necterStatusForType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bridgeStatus.delegate = self
        
        if let name = localData.getUsername() {
            username.text = name
        }
        else {
            username.text = "Enter Name on your Profile"
        }
        username.textColor = UIColor.white
        username.font = UIFont(name: "BentonSans", size: 20)

        //backButton.frame = CGRect(x: 0.05*screenWidth, y:0.07*screenHeight, width:0.3*screenWidth, height:0.06*screenHeight)
        backButton.frame = CGRect(x: 0.05*screenWidth, y:0.07*screenHeight, width:0.33*screenWidth, height:0.06*screenHeight)
        backButton.layer.borderWidth = 4.0
        backButton.layer.borderColor = necterGray.cgColor
        backButton.layer.cornerRadius = 7.0
        backButton.setTitle("go back", for: UIControlState())
        backButton.setTitleColor(necterGray, for: UIControlState())
        backButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        backButton.titleLabel!.font = UIFont(name: "BentonSans", size: 20)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backButton.alpha = 0
        view.addSubview(backButton)
        
        //postButton.frame = CGRect(x: 0.65*screenWidth, y:0.07*screenHeight, width:0.3*screenWidth, height:0.06*screenHeight)
        postButton.frame = CGRect(x: 0.62*screenWidth, y:0.07*screenHeight, width:0.33*screenWidth, height:0.06*screenHeight)
        postButton.layer.borderWidth = 4.0
        postButton.layer.borderColor = necterGray.cgColor
        postButton.layer.cornerRadius = 7.0
        postButton.setTitle("post", for: UIControlState())
        postButton.setTitleColor(necterGray, for: UIControlState())
        postButton.setTitleColor(UIColor.lightGray, for: .highlighted)
        postButton.titleLabel!.font = UIFont(name: "BentonSans", size: 20)
        postButton.addTarget(self, action: #selector(postTapped), for: .touchUpInside)
        postButton.alpha = 0
        postButton.isEnabled = false
        view.addSubview(postButton)
        
        //get and set profile picture
        let mainProfilePicture = localData.getMainProfilePicture()
        if let mainProfilePicture = mainProfilePicture {
            
            //applying filter to make the white text more legible
            let beginImage = CIImage(data: mainProfilePicture as Data)
            let edgeDetectFilter = CIFilter(name: "CIVignetteEffect")!
            edgeDetectFilter.setValue(beginImage, forKey: kCIInputImageKey)
            edgeDetectFilter.setValue(0.2, forKey: "inputIntensity")
            edgeDetectFilter.setValue(0.2, forKey: "inputRadius")
            let newCGImage = CIContext(options: nil).createCGImage(edgeDetectFilter.outputImage!, from: (edgeDetectFilter.outputImage?.extent)!)
            let newImage = UIImage(cgImage: newCGImage!)
            profilePicture.image = newImage
        }
        
        profilePicture.layer.cornerRadius = 15
        
        profilePicture.contentMode = UIViewContentMode.scaleAspectFill
        profilePicture.clipsToBounds = true
        
        let profilePictureHeight = 0.3825*self.screenHeight
        let profilePictureWidth = 0.96*self.screenWidth
        let profilePictureY = 0.18*self.screenHeight-0.05*profilePictureWidth // this 0.05 is for the necterTypeIcon to be just at the top of the keyboard
        let profilePictureX = (screenWidth-profilePictureWidth)*0.5
        profilePicture.frame = CGRect(x: profilePictureX
            , y: profilePictureY, width: profilePictureWidth, height: profilePictureHeight)
        profilePicture.alpha = 0
        
        
        
        nameLabel.alpha = 0
        nameLabel.textAlignment = NSTextAlignment.left
        nameLabel.textColor = UIColor.white
        nameLabel.font = UIFont(name: "Verdana", size: 20)
        nameLabel.frame = CGRect(x: profilePictureX + 0.05*profilePictureWidth, y: profilePictureY + 0.05*profilePictureHeight, width: 0.8*profilePictureWidth, height: 0.12*profilePictureHeight)
        nameLabel.text = username.text
        nameLabel.layer.shadowOpacity = 0.5
        nameLabel.layer.shadowRadius = 0.5
        nameLabel.layer.shadowColor = UIColor.black.cgColor
        nameLabel.layer.shadowOffset = CGSize(width: 0.0, height: -0.5)
        
        //set users location to the PFUsers stored city and if there is no city stored then set it to ""
        locationLabel.text = PFUser.current()?["city"] as? String ?? ""
        locationLabel.alpha = 0
        locationLabel.frame = CGRect(x: profilePictureX + 0.05*profilePictureWidth, y: profilePictureY + 0.17*profilePictureHeight, width: 0.8*profilePictureWidth, height: 0.075*profilePictureHeight)
        locationLabel.textAlignment = NSTextAlignment.left
        locationLabel.textColor = UIColor.white
        locationLabel.font = UIFont(name: "Verdana", size: 14)
        locationLabel.layer.shadowOpacity = 0.5
        locationLabel.layer.shadowRadius = 0.5
        locationLabel.layer.shadowColor = UIColor.black.cgColor
        locationLabel.layer.shadowOffset = CGSize(width: 0.0, height: -0.5)
        
        bridgeStatus.alpha = 0
        bridgeStatus.textColor = UIColor.white
        bridgeStatus.backgroundColor = UIColor.clear
        
        bridgeStatus.text = retrieveStatusForType()
        bridgeStatus.font = UIFont(name: "Verdana", size: 14)
        bridgeStatus.frame = CGRect(x: profilePictureX + 0.05*profilePictureWidth, y: 0.65*profilePictureHeight + profilePictureY, width: 0.9*profilePictureWidth, height: 0.3*profilePictureHeight)
        bridgeStatus.textAlignment = NSTextAlignment.center
        bridgeStatus.layer.shadowOpacity = 0.5
        bridgeStatus.layer.shadowRadius = 0.5
        bridgeStatus.layer.shadowColor = UIColor.black.cgColor
        bridgeStatus.layer.shadowOffset = CGSize(width: 0.0, height: -0.5)
        
        //line that represents the necter Type and is located between user cards -> half on the current user card in the Status page
        necterTypeLine.alpha = 0
        necterTypeLine.frame = CGRect(x: profilePictureX, y: profilePictureY + profilePictureHeight - 2, width: profilePictureWidth, height: 4)
        
        //icon that represents the necter Type
        necterTypeIcon.alpha = 0
        necterTypeIcon.frame = CGRect(x: profilePictureX + 0.45*profilePictureWidth, y: profilePictureY + profilePictureHeight - 0.08*profilePictureWidth, width: 0.1*profilePictureWidth, height: 0.1*profilePictureWidth)
        necterTypeIcon.contentMode = UIViewContentMode.scaleAspectFill
        necterTypeIcon.clipsToBounds = true
        
        necterTypeIcon.layer.shadowOpacity = 0.5
        necterTypeIcon.layer.shadowRadius = 0.5
        necterTypeIcon.layer.shadowColor = UIColor.black.cgColor
        necterTypeIcon.layer.shadowOffset = CGSize(width: 0.0, height: -0.5)
        
        ////setting placeholder text as examples for each type of connection.
        //var placeholderText = String()
        if necterType == "Business" {
            //placeholderText  = "e.g. I am looking for a graphic design job, I am looking for tech startups to invest in, I am looking for yogis for my new studio, etc."
            necterTypeLine.backgroundColor = businessBlue
            necterTypeIcon.image = UIImage(named: "Business_Icon_Blue")
        } else if necterType == "Love" {
            //placeholderText  = "e.g. I am looking for someone to try a new restaurant with this weekend, I am looking for someone who is smart and pretty, etc."
            necterTypeLine.backgroundColor = loveRed
            necterTypeIcon.image = UIImage(named: "Love_Icon_Red")
        } else if necterType == "Friendship" {
            //placeholderText  = "e.g. I am looking for someone to try a new restaurant with this weekend, I am looking for someone who is smart and pretty, etc."
            necterTypeLine.backgroundColor = friendshipGreen
            necterTypeIcon.image = UIImage(named: "Friendship_Icon_Green")
        }
        
        view.addSubview(profilePicture)
        view.addSubview(nameLabel)
        view.addSubview(locationLabel)
        view.addSubview(bridgeStatus)
        view.addSubview(necterTypeLine)
        view.addSubview(necterTypeIcon)
        
        self.backButton.alpha = 1
        self.postButton.alpha = 1
        
        //displayInstructionsFromBot()
        
        
        //let _ = Timer(interval: 0.3) {i -> Bool in
            //self.selectTypeLabel.attributedText = attributedGreeting.attributedSubstringFromRange(NSRange(location: 0, length: i+1))
            //return i + 1 < attributedGreeting.string.characters.count
            //fade out select necter Type screen
            //using optionTableView.alpha as an indicator that the user has not yet clicked the back button
        bridgeStatus.autocapitalizationType = UITextAutocapitalizationType.none

        UIView.animate(withDuration: 0.6, delay: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            //fade in post status screen
            self.bridgeStatus.becomeFirstResponder()
            self.profilePicture.alpha = 1
            self.nameLabel.alpha = 1
            self.locationLabel.alpha = 1
            self.bridgeStatus.alpha = 1
            self.necterTypeLine.alpha = 1
            self.necterTypeIcon.alpha = 1
        }, completion: nil)
            
            //return i < 2
        //}

    }
    
    override func viewDidLayoutSubviews() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination
        let mirror = Mirror(reflecting: vc)
        if mirror.subjectType == BridgeViewController.self {
            self.transitionManager.animationDirection = "Bottom"
        } else if mirror.subjectType == ProfileViewController.self {
            self.transitionManager.animationDirection = "Bottom"
        } else if mirror.subjectType == MessagesViewController.self {
            self.transitionManager.animationDirection = "Bottom"
        } else if mirror.subjectType == OptionsFromBotViewController.self {
            self.transitionManager.animationDirection = "Left"
            let vc2 = vc as! OptionsFromBotViewController
            vc2.seguedFrom = seguedFrom
        }
        vc.transitioningDelegate = self.transitionManager
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
