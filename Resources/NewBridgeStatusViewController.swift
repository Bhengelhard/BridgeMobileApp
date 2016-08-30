//
//  NewBridgeStatusViewController.swift
//  MyBridgeApp
//
//  Created by Sagar Sinha on 6/27/16.
//  Copyright © 2016 Parse. All rights reserved.
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
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    let necterYellow = UIColor(red: 255/255, green: 230/255, blue: 57/255, alpha: 1.0)
    let businessBlue = UIColor(red: 36.0/255, green: 123.0/255, blue: 160.0/255, alpha: 1.0)
    let loveRed = UIColor(red: 242.0/255, green: 95.0/255, blue: 92.0/255, alpha: 1.0)
    let friendshipGreen = UIColor(red: 112.0/255, green: 193.0/255, blue: 179.0/255, alpha: 1.0)
    let necterGray = UIColor(red: 80.0/255.0, green: 81.0/255.0, blue: 79.0/255.0, alpha: 1.0)
    var necterType = ""
    
    
    func textViewDidChange(textView: UITextView) {
        
        if enablePost || bridgeStatus.text?.characters.count == 18 {
            postButton.layer.borderColor = necterYellow.CGColor
            postButton.setTitleColor(necterYellow, forState: .Highlighted)
            postButton.enabled = true
            enablePost = false
        } else if bridgeStatus.text?.characters.count == 0 {
            postButton.layer.borderColor = necterGray.CGColor
            postButton.enabled = false
            enablePost = true
        }
        
        //stopping user from entering bridge status with more than 140 characters
        if let characterCount = bridgeStatus.text?.characters.count {
            if characterCount > 100 {
                let aboveMaxBy = characterCount - 100
                let index1 = bridgeStatus.text!.endIndex.advancedBy(-aboveMaxBy)
                bridgeStatus.text = bridgeStatus.text!.substringToIndex(index1)
            }
        }

    }
    
    func backTapped(sender: UIButton ){
        
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
        
        performSegueWithIdentifier("showOptionsViewFromNewStatus", sender: self)
        
    }
    func postTapped(sender: UIButton){
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
        
        let bridgeStatusObject = PFObject(className: "BridgeStatus")
        bridgeStatusObject["bridge_status"] = self.bridgeStatus.text!
        bridgeStatusObject["bridge_type"] = self.necterType
        bridgeStatusObject["userId"] = PFUser.currentUser()?.objectId
        bridgeStatusObject.saveInBackgroundWithBlock { (success, error) in
            
            
            if error != nil {
                //sends notification to call displayMessageFromBot function
                let userInfo = ["message" : "Your post did not go through. Please wait a minute and try posting again"]
                NSNotificationCenter.defaultCenter().postNotificationName("displayMessageFromBot", object: nil, userInfo: userInfo)
            } else if success {
                //sends notification to call displayMessageFromBot function
                let userInfo = ["message" : "Your post is now being shown to friends so they can connect you!"]
                self.didSendPost = true
                NSNotificationCenter.defaultCenter().postNotificationName("displayMessageFromBot", object: nil, userInfo: userInfo)
            }
        }
        
        PFCloud.callFunctionInBackground("changeBridgePairingsOnStatusUpdate", withParameters: ["status":self.bridgeStatus.text!, "bridgeType":self.necterType]) {
            (response:AnyObject?, error: NSError?) -> Void in
            if error == nil {
                if let response = response as? String {
                    print(response)
                }
            }
        }
        
        performSegueToPriorView()
    }
    
    func performSegueToPriorView() {
        if seguedFrom == "ProfileViewController" {
            performSegueWithIdentifier("showProfilePageFromNewStatusView", sender: self)
        } else if seguedFrom == "BridgeViewController" {
            performSegueWithIdentifier("showBridgePageFromStatus", sender: self)
        } else if seguedFrom == "MessagesViewController" {
            performSegueWithIdentifier("showMessagesViewfromStatus", sender: self)
        } else {
            //default case
            performSegueWithIdentifier("showBridgePageFromStatus", sender: self)
        }
    }
    
    func displayInstructionsFromBot() {
        print("instructions should display")
        let botInstructionsView = UIView()
        botInstructionsView.frame = CGRect(x: 0, y: -0.12*self.screenHeight, width: self.screenWidth, height: 0.12*self.screenHeight)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = botInstructionsView.bounds
        //blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let messageLabel = UILabel(frame: CGRect(x: 0.05*screenWidth, y: 0.01*screenHeight, width: 0.9*screenWidth, height: 0.11*screenHeight))
        messageLabel.text = "Awesome! Now post a status to give your friends more information."
        messageLabel.textColor = UIColor.darkGrayColor()
        messageLabel.font = UIFont(name: "Verdana-Bold", size: 14)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = NSTextAlignment.Center
        
        botInstructionsView.addSubview(messageLabel)
        botInstructionsView.insertSubview(blurEffectView, belowSubview: messageLabel)
        //botNotificationView.alpha = 0
        //botNotificationView.backgroundColor = necterYellow
        view.insertSubview(botInstructionsView, aboveSubview: necterTypeIcon)
        
        //UIView.animateWithDuration(0.7) {
            
        //}
        let _ = Timer(interval: 1) {i -> Bool in
            UIView.animateWithDuration(0.7, animations: {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bridgeStatus.delegate = self
        
        if let name = localData.getUsername() {
            username.text = name
        }
        else {
            username.text = "Enter Name on your Profile"
        }
        username.textColor = UIColor.whiteColor()
        username.font = UIFont(name: "BentonSans", size: 20)

        //backButton.frame = CGRect(x: 0.05*screenWidth, y:0.07*screenHeight, width:0.3*screenWidth, height:0.06*screenHeight)
        backButton.frame = CGRect(x: 0.05*screenWidth, y:0.07*screenHeight, width:0.33*screenWidth, height:0.06*screenHeight)
        backButton.layer.borderWidth = 4.0
        backButton.layer.borderColor = necterGray.CGColor
        backButton.layer.cornerRadius = 7.0
        backButton.setTitle("go back", forState: .Normal)
        backButton.setTitleColor(necterGray, forState: .Normal)
        backButton.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
        backButton.titleLabel!.font = UIFont(name: "BentonSans", size: 20)
        backButton.addTarget(self, action: #selector(backTapped), forControlEvents: .TouchUpInside)
        backButton.alpha = 0
        view.addSubview(backButton)
        
        //postButton.frame = CGRect(x: 0.65*screenWidth, y:0.07*screenHeight, width:0.3*screenWidth, height:0.06*screenHeight)
        postButton.frame = CGRect(x: 0.62*screenWidth, y:0.07*screenHeight, width:0.33*screenWidth, height:0.06*screenHeight)
        postButton.layer.borderWidth = 4.0
        postButton.layer.borderColor = necterGray.CGColor
        postButton.layer.cornerRadius = 7.0
        postButton.setTitle("post", forState: .Normal)
        postButton.setTitleColor(necterGray, forState: .Normal)
        postButton.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
        postButton.titleLabel!.font = UIFont(name: "BentonSans", size: 20)
        postButton.addTarget(self, action: #selector(postTapped), forControlEvents: .TouchUpInside)
        postButton.alpha = 0
        postButton.enabled = false
        view.addSubview(postButton)
        
        //get and set profile picture
        let mainProfilePicture = localData.getMainProfilePicture()
        if let mainProfilePicture = mainProfilePicture {
            
            //applying filter to make the white text more legible
            let beginImage = CIImage(data: mainProfilePicture)
            let edgeDetectFilter = CIFilter(name: "CIVignetteEffect")!
            edgeDetectFilter.setValue(beginImage, forKey: kCIInputImageKey)
            edgeDetectFilter.setValue(0.1, forKey: "inputIntensity")
            edgeDetectFilter.setValue(0.2, forKey: "inputRadius")
            let newImage = UIImage(CIImage: edgeDetectFilter.outputImage!)
            
            //img2.image = newImage
            
            //let image = UIImage(data:mainProfilePicture,scale:1.0)
            profilePicture.image = newImage
        }
        
        profilePicture.layer.cornerRadius = 15
        profilePicture.contentMode = UIViewContentMode.ScaleAspectFill
        profilePicture.clipsToBounds = true
        let profilePictureHeight = 0.3825*self.screenHeight
        let profilePictureWidth = 0.96*self.screenWidth
        let profilePictureY = 0.18*self.screenHeight-0.05*profilePictureWidth // this 0.05 is for the necterTypeIcon to be just at the top of the keyboard
        let profilePictureX = (screenWidth-profilePictureWidth)*0.5
        profilePicture.frame = CGRect(x: profilePictureX
            , y: profilePictureY, width: profilePictureWidth, height: profilePictureHeight)
        profilePicture.alpha = 0
        
        nameLabel.alpha = 0
        nameLabel.textAlignment = NSTextAlignment.Left
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.font = UIFont(name: "Verdana", size: 20)
        nameLabel.frame = CGRect(x: profilePictureX + 0.05*profilePictureWidth, y: profilePictureY + 0.05*profilePictureHeight, width: 0.8*profilePictureWidth, height: 0.12*profilePictureHeight)
        nameLabel.text = username.text
        nameLabel.layer.shadowOpacity = 0.5
        nameLabel.layer.shadowRadius = 0.5
        nameLabel.layer.shadowColor = UIColor.blackColor().CGColor
        nameLabel.layer.shadowOffset = CGSizeMake(0.0, -0.5)
        
        //set users location to the PFUsers stored city and if there is no city stored then set it to ""
        locationLabel.text = PFUser.currentUser()?["city"] as? String ?? ""
        locationLabel.alpha = 0
        locationLabel.frame = CGRect(x: profilePictureX + 0.05*profilePictureWidth, y: profilePictureY + 0.17*profilePictureHeight, width: 0.8*profilePictureWidth, height: 0.075*profilePictureHeight)
        locationLabel.textAlignment = NSTextAlignment.Left
        locationLabel.textColor = UIColor.whiteColor()
        locationLabel.font = UIFont(name: "Verdana", size: 14)
        locationLabel.layer.shadowOpacity = 0.5
        locationLabel.layer.shadowRadius = 0.5
        locationLabel.layer.shadowColor = UIColor.blackColor().CGColor
        locationLabel.layer.shadowOffset = CGSizeMake(0.0, -0.5)
        
        bridgeStatus.alpha = 0
        bridgeStatus.textColor = UIColor.whiteColor()
        bridgeStatus.backgroundColor = UIColor.clearColor()
        bridgeStatus.text = "I am looking for "
        bridgeStatus.font = UIFont(name: "Verdana", size: 14)
        bridgeStatus.frame = CGRect(x: profilePictureX + 0.05*profilePictureWidth, y: 0.65*profilePictureHeight + profilePictureY, width: 0.9*profilePictureWidth, height: 0.3*profilePictureHeight)
        bridgeStatus.textAlignment = NSTextAlignment.Center
        bridgeStatus.layer.shadowOpacity = 0.5
        bridgeStatus.layer.shadowRadius = 0.5
        bridgeStatus.layer.shadowColor = UIColor.blackColor().CGColor
        bridgeStatus.layer.shadowOffset = CGSizeMake(0.0, -0.5)
        
        //line that represents the necter Type and is located between user cards -> half on the current user card in the Status page
        necterTypeLine.alpha = 0
        necterTypeLine.frame = CGRect(x: profilePictureX, y: profilePictureY + profilePictureHeight - 2, width: profilePictureWidth, height: 4)
        
        //icon that represents the necter Type
        necterTypeIcon.alpha = 0
        necterTypeIcon.frame = CGRect(x: profilePictureX + 0.45*profilePictureWidth, y: profilePictureY + profilePictureHeight - 0.08*profilePictureWidth, width: 0.1*profilePictureWidth, height: 0.1*profilePictureWidth)
        necterTypeIcon.contentMode = UIViewContentMode.ScaleAspectFill
        necterTypeIcon.clipsToBounds = true
        
        necterTypeIcon.layer.shadowOpacity = 0.5
        necterTypeIcon.layer.shadowRadius = 0.5
        necterTypeIcon.layer.shadowColor = UIColor.blackColor().CGColor
        necterTypeIcon.layer.shadowOffset = CGSizeMake(0.0, -0.5)
        
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
            UIView.animateWithDuration(0.6, delay: 0, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController
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
