//
//  NewBridgeStatusViewController.swift
//  MyBridgeApp
//
//  Created by Sagar Sinha on 6/27/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
class NewBridgeStatusViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UINavigationBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let selectTypeLabel = UILabel()
    let optionsTableView = UITableView()
    let cancelButton = UIButton()
    var firstName = String()
    
    let backButton = UIButton()
    let postButton = UIButton()
    let username = UILabel()
    let profilePicture = UIImageView()
    let bridgeStatus = UITextView()
    let screenUnderTop = UIImageView()
    let screenUnderBottom = UIImageView()
    let nameLabel = UILabel()
    let locationLabel = UILabel()
    let leftNecterTypeLine = UIView()
    let rightNecterTypeLine = UIView()
    let necterTypeIcon = UIImageView()
    
    let localData = LocalData()
    let transitionManager = TransitionManager()

    var enablePost = Bool()
    var vc : ProfileViewController? = nil
    
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
    
    
    /*func textView(textView: UITextView, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textView.attributedText.string as? String
            else {
                print ("shouldChangeCharactersInRange")
                return true
            }
        
        print(1)
        var enablePost = false
        if enablePost || bridgeStatus.text?.characters.count == 17 {
            postButton.layer.borderColor = necterYellow.CGColor
            postButton.setTitleColor(necterYellow, forState: .Highlighted)
            postButton.enabled = true
        } else if bridgeStatus.text?.characters.count == 0 {
            enablePost = true
            postButton.layer.borderColor = UIColor(red: 80.0/255.0, green: 81.0/255.0, blue: 79.0/255.0, alpha: 1.0).CGColor
            postButton.enabled = false
        }
        
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 140 
    }*/
    
    /*func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        print(2)
        if bridgeStatus.text! != "" {
            
            //navItem.rightBarButtonItem?.enabled = true
            //navItem.rightBarButtonItem?.tintColor = necterYellow
        }
        return true
    }*/
    
    //resetting view for what it should look like after one of the necter Type Buttons are clicked
    func setPositionsForEnteringStatus() {
        
        backButton.frame = CGRect(x: 0.05*screenWidth, y:0.05*screenHeight, width:0.3*screenWidth, height:0.06*screenHeight)
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
        
        postButton.frame = CGRect(x: 0.65*screenWidth, y:0.05*screenHeight, width:0.3*screenWidth, height:0.06*screenHeight)
        postButton.layer.borderWidth = 4.0
        postButton.layer.borderColor = necterGray.CGColor
        postButton.layer.cornerRadius = 7.0
        postButton.setTitle("Post", forState: .Normal)
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
            let image = UIImage(data:mainProfilePicture,scale:1.0)
            profilePicture.image = image
            print("got image")
        }
        
        profilePicture.layer.cornerRadius = 15
        profilePicture.contentMode = UIViewContentMode.ScaleAspectFill
        profilePicture.clipsToBounds = true
        let profilePictureHeight = 0.3825*self.screenHeight
        let profilePictureWidth = 0.96*self.screenWidth
        let profilePictureY = 0.225*self.screenHeight-0.05*profilePictureWidth // this 0.05 is for the necterTypeIcon to be just at the top of the keyboard
        let profilePictureX = (screenWidth-profilePictureWidth)*0.5
        profilePicture.frame = CGRect(x: profilePictureX
            , y: profilePictureY, width: profilePictureWidth, height: profilePictureHeight)
        profilePicture.alpha = 0
        
        
        //let screenUnderTopFrame = CGRectMake(0,0,cardWidth,0.3*cardHeight)
        //let screenUnderBottomFrame = CGRectMake(0, 0.6*cardHeight, cardWidth, 0.4*cardHeight)

        screenUnderTop.alpha = 0
        screenUnderTop.layer.cornerRadius = 15
        screenUnderTop.clipsToBounds = true
        screenUnderTop.image = UIImage(named: "Screen over Image.png")
        screenUnderTop.frame = CGRect(x: profilePictureX, y: profilePictureY, width: profilePictureWidth, height: 0.3*profilePictureHeight)
        
        screenUnderBottom.alpha = 0
        screenUnderBottom.layer.cornerRadius = 15
        screenUnderBottom.clipsToBounds = true
        screenUnderBottom.image = UIImage(named: "Screen over Image.png")
        screenUnderBottom.frame = CGRect(x: profilePictureX, y: profilePictureY + 0.65*profilePictureHeight, width: profilePictureWidth, height: 0.35*profilePictureHeight)
        
        nameLabel.alpha = 0
        nameLabel.textAlignment = NSTextAlignment.Left
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.font = UIFont(name: "Verdana", size: 20)
        nameLabel.frame = CGRect(x: profilePictureX + 0.05*profilePictureWidth, y: profilePictureY + 0.05*profilePictureHeight, width: 0.8*profilePictureWidth, height: 0.1*profilePictureHeight)
        nameLabel.text = username.text
        
       //CGRectMake(0.05*cardWidth,0.17*cardHeight,0.8*cardWidth,0.10*cardHeight)
        locationLabel.alpha = 0
        locationLabel.frame = CGRect(x: profilePictureX + 0.05*profilePictureWidth, y: profilePictureY + 0.16*profilePictureHeight, width: 0.8*profilePictureWidth, height: 0.1*profilePictureHeight)
        locationLabel.text = "Save location to device"
        locationLabel.textAlignment = NSTextAlignment.Left
        locationLabel.textColor = UIColor.whiteColor()
        locationLabel.font = UIFont(name: "Verdana", size: 16)
        
        bridgeStatus.alpha = 0
        bridgeStatus.textColor = UIColor.whiteColor()
        bridgeStatus.backgroundColor = UIColor.clearColor()
        bridgeStatus.text = "I am looking for "
        bridgeStatus.font = UIFont(name: "BentonSans", size: 20)
        bridgeStatus.frame = CGRect(x: profilePictureX + 0.05*profilePictureWidth, y: 0.65*profilePictureHeight + profilePictureY, width: 0.9*profilePictureWidth, height: 0.3*profilePictureHeight)
        //bridgeStatus.scrollRangeToVisible(NSMakeRange(0,0))
        var statusAttributedString = NSMutableAttributedString()
        
        //line that represents the necter Type and is located between user cards -> half on the current user card in the Status page
        leftNecterTypeLine.alpha = 0
        leftNecterTypeLine.frame = CGRect(x: profilePictureX, y: profilePictureY + profilePictureHeight - 2, width: profilePictureWidth, height: 4)
        
        /*rightNecterTypeLine.alpha = 0
        rightNecterTypeLine.frame = CGRect(x: profilePictureX + 0.5*profilePictureWidth, y: profilePictureY + profilePictureHeight - 2, width: 0.3*profilePictureWidth, height: 4)*/
        
        //icon that represents the necter Type
        necterTypeIcon.alpha = 0
        necterTypeIcon.frame = CGRect(x: profilePictureX + 0.45*profilePictureWidth, y: profilePictureY + profilePictureHeight - 0.05*profilePictureWidth, width: 0.1*profilePictureWidth, height: 0.1*profilePictureWidth)
        necterTypeIcon.contentMode = UIViewContentMode.ScaleAspectFill
        necterTypeIcon.clipsToBounds = true
        
        //setting placeholder text as examples for each type of connection.
        var placeholderText = String()
        if necterType == "Business" {
            placeholderText  = "e.g. I am looking for a graphic design job, I am looking for tech startups to invest in, I am looking for yogis for my new studio, etc."
            leftNecterTypeLine.backgroundColor = businessBlue
            rightNecterTypeLine.backgroundColor = businessBlue
            necterTypeIcon.image = UIImage(named: "Business_Icon_Blue")
        } else if necterType == "Love" {
            placeholderText  = "e.g. I am looking for someone to try a new restaurant with this weekend, I am looking for someone who is smart and pretty, etc."
            leftNecterTypeLine.backgroundColor = loveRed
            rightNecterTypeLine.backgroundColor = loveRed
            necterTypeIcon.image = UIImage(named: "Love_Icon_Red")
        } else if necterType == "Friendship" {
            placeholderText  = "e.g. I am looking for someone to try a new restaurant with this weekend, I am looking for someone who is smart and pretty, etc."
            leftNecterTypeLine.backgroundColor = friendshipGreen
            rightNecterTypeLine.backgroundColor = friendshipGreen
            necterTypeIcon.image = UIImage(named: "Friendship_Icon_Green")
        }
        
        
        statusAttributedString = NSMutableAttributedString(string:placeholderText, attributes: [NSFontAttributeName:UIFont(name: "BentonSans", size: 14.0)!]) // Font
        statusAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range:NSRange(location:0,length:placeholderText.characters.count))    // Color
        //bridgeStatus.attributedPlaceholder = statusAttributedString
        
        view.addSubview(profilePicture)
        view.addSubview(screenUnderTop)
        view.addSubview(screenUnderBottom)
        view.addSubview(nameLabel)
        view.addSubview(locationLabel)
        view.addSubview(bridgeStatus)
        view.addSubview(leftNecterTypeLine)
        view.addSubview(rightNecterTypeLine)
        view.addSubview(necterTypeIcon)
        
        self.optionsTableView.alpha = 0
        self.selectTypeLabel.alpha = 0
        self.selectTypeLabel.frame = CGRect(x: 0.05*self.screenWidth, y: 0.07*self.screenHeight, width: 0.9*self.screenWidth, height: 0.1*self.screenHeight)
        self.cancelButton.alpha = 0
        self.backButton.alpha = 1
        self.postButton.alpha = 1
        
        
        let _ = Timer(interval: 0.3) {i -> Bool in
            //self.selectTypeLabel.attributedText = attributedGreeting.attributedSubstringFromRange(NSRange(location: 0, length: i+1))
            //return i + 1 < attributedGreeting.string.characters.count
            //fade out select necter Type screen
            //using optionTableView.alpha as an indicator that the user has not yet clicked the back button
            UIView.animateWithDuration(0.6, delay: 0, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                if i == 0 && self.optionsTableView.alpha == 0{
                    //intructions pop in
                    self.selectTypeLabel.alpha = 1
                    self.selectTypeLabel.frame = CGRect(x: 0.05*self.screenWidth, y: 0.075*self.screenHeight, width: 0.9*self.screenWidth, height: 0.15*self.screenHeight)
                    let greeting = "Awesome! Now post a status to give your friends more information"
                    let attributedGreeting = NSMutableAttributedString(string: greeting as String, attributes: [NSFontAttributeName: UIFont.init(name: "Verdana", size: 16)!])
                    self.selectTypeLabel.attributedText = attributedGreeting
                } else if i == 1 && self.optionsTableView.alpha == 0 {
                    //fade in post status screen
                    self.bridgeStatus.becomeFirstResponder()
                    self.profilePicture.alpha = 1
                    self.screenUnderBottom.alpha = 1
                    self.screenUnderTop.alpha = 1
                    self.nameLabel.alpha = 1
                    self.locationLabel.alpha = 1
                    self.bridgeStatus.alpha = 1
                    self.leftNecterTypeLine.alpha = 1
                    self.rightNecterTypeLine.alpha = 1
                    self.necterTypeIcon.alpha = 1
                }
            }, completion: nil)
            
            return i < 3
        }
        
        /*UIView.animateWithDuration(0.7) {
            
        }*/
        
    }
    
    func cancelTapped(sender: UIButton ){
        print("cancel selected")
        //presentViewController(vc!, animated: true, completion: nil)
        //navigationController!.popViewControllerAnimated(true)
        //dismissViewControllerAnimated(true, completion: nil)
        performSegueWithIdentifier("showBridgePageFromStatus", sender: self)

    }
    func backTapped(sender: UIButton ){
        
        bridgeStatus.resignFirstResponder()
        
        /*
 let attributedGreeting2 = NSMutableAttributedString(string: greeting as String, attributes: [NSFontAttributeName: UIFont.init(name: "Verdana", size: 22)!])
 let boldedFontAttribute = [NSFontAttributeName: UIFont.init(name: "Verdana-Bold", size: 22) as! AnyObject]
 let lineBreakAttribute = [NSFontAttributeName: UIFont.init(name: "Verdana-Bold", size: 10) as! AnyObject]
 attributedGreeting2.addAttributes(boldedFontAttribute, range: greeting.rangeOfString("Hello \(self.firstName),"))
 attributedGreeting2.addAttributes(lineBreakAttribute, range: greeting.rangeOfString("\n\n"))*/
 
        print("back selected")
        //show previous views setup (i.e. the initial bot question of which connection type the user is looking for)
        let greeting = "Hello \(firstName), \n\nWhat type of connection are you looking for?" as NSString
        //var attributedGreeting = NSMutableAttributedString(string: greeting as String, attributes: [NSFontAttributeName: UIFont.init(name: "Verdana-Bold", size: 22)!])
        var attributedGreeting = NSMutableAttributedString(string: greeting as String, attributes: [NSFontAttributeName: UIFont.init(name: "Verdana", size: 22)!])
        let boldedFontAttribute = [NSFontAttributeName: UIFont.init(name: "Verdana-Bold", size: 22) as! AnyObject]
        let lineBreakAttribute = [NSFontAttributeName: UIFont.init(name: "Verdana-Bold", size: 10) as! AnyObject]
        attributedGreeting.addAttributes(boldedFontAttribute, range: greeting.rangeOfString("Hello \(firstName),"))
        //attributedGreeting2.addAttributes(boldedFontAttribute, range: greeting.rangeOfString("Hello \(firstName),"))
        //print(attributedGreeting2)
        attributedGreeting.addAttributes(lineBreakAttribute, range: greeting.rangeOfString("\n\n"))
        //print(attributedGreeting2)
        selectTypeLabel.attributedText = attributedGreeting

        
        optionsTableView.alpha = 1
        selectTypeLabel.alpha = 1
        selectTypeLabel.frame = CGRect(x: 0.05*screenWidth, y: 0.05*screenHeight, width: 0.9*screenWidth, height: 0.25*screenHeight)
        cancelButton.alpha = 1
        backButton.alpha = 0
        postButton.alpha = 0
        
        profilePicture.alpha = 0
        bridgeStatus.alpha = 0
        screenUnderBottom.alpha = 0
        screenUnderTop.alpha = 0
        nameLabel.alpha = 0
        locationLabel.alpha = 0
        leftNecterTypeLine.alpha = 0
        rightNecterTypeLine.alpha = 0
        necterTypeIcon.alpha = 0
        
    }
    func postTapped(sender: UIButton){
        
        //self.vc?.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        
        self.backButton.alpha = 0
        self.postButton.alpha = 0
        self.selectTypeLabel.alpha = 0
        self.profilePicture.alpha = 0
        self.bridgeStatus.resignFirstResponder()
        self.bridgeStatus.alpha = 0
        screenUnderBottom.alpha = 0
        screenUnderTop.alpha = 0
        nameLabel.alpha = 0
        locationLabel.alpha = 0
        leftNecterTypeLine.alpha = 0
        rightNecterTypeLine.alpha = 0
        necterTypeIcon.alpha = 0
        self.selectTypeLabel.frame = CGRect(x: 0.05*self.screenWidth, y: 0.145*self.screenHeight, width: 0.9*self.screenWidth, height: 0.15*self.screenHeight)
        //displaying confirmation that post was sent out and then segueing back to profile
        let _ = Timer(interval: 0.25) {i -> Bool in
            UIView.animateWithDuration(0.6, delay: 0, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                if i == 0 {
                    //intructions fade and drop in
                    self.selectTypeLabel.alpha = 1
                    self.selectTypeLabel.frame = CGRect(x: 0.05*self.screenWidth, y: 0.15*self.screenHeight, width: 0.9*self.screenWidth, height: 0.15*self.screenHeight)
                    let greeting = "Great! I'll put it out to your community." //Way to give your friends the opportunity to help you.
                    let attributedGreeting = NSMutableAttributedString(string: greeting as String, attributes: [NSFontAttributeName: UIFont.init(name: "Verdana", size: 20)!])
                    self.selectTypeLabel.attributedText = attributedGreeting
                } else if i == 6 {
                    self.selectTypeLabel.alpha = 0
                    self.performSegueWithIdentifier("showBridgePageFromStatus", sender: self)
                    //self.presentViewController(self.vc!, animated: true, completion: nil)
                    //self.navigationController!.popViewControllerAnimated(true)
                }
                
            }, completion: nil)
            
            return i < 6
        }
        
        print("post selected")
        
        let bridgeStatusObject = PFObject(className: "BridgeStatus")
        bridgeStatusObject["bridge_status"] = self.bridgeStatus.text!
        bridgeStatusObject["bridge_type"] = self.necterType
        bridgeStatusObject["userId"] = PFUser.currentUser()?.objectId
        bridgeStatusObject.saveInBackground()
        /*PFCloud.callFunctionInBackground("changeBridgePairingsOnStatusUpdate", withParameters: ["status":self.bridgeStatus.text!, "bridgeType":self.necterType]) {
            (response:AnyObject?, error: NSError?) -> Void in
            if error == nil {
                if let response = response as? String {
                    print(response)
                }
            }
        }*/
        //self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bridgeStatus.delegate = self
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        vc = storyboard!.instantiateViewControllerWithIdentifier("ProfileViewController") as? ProfileViewController
        
        if let name = localData.getUsername() {
            username.text = name
            
            print("got username")
        }
        else {
            username.text = "Enter Name on your Profile"
        }
        username.textColor = UIColor.whiteColor()
        username.font = UIFont(name: "BentonSans", size: 20)
        
        if username.text != "Enter name on your Profile" {
            if let username = username.text {
                firstName = username.componentsSeparatedByString(" ").first!
            }
        }
        
        //setting up instructions and buttons
        selectTypeLabel.frame = CGRect(x: 0.05*screenWidth, y: 0.045*screenHeight, width: 0.9*screenWidth, height: 0.25*screenHeight)
        //setting multi-font label
        var greeting = "Hello \(firstName), \n\nWhat type of connection are you looking for?" as NSString
        var attributedGreeting = NSMutableAttributedString(string: greeting as String, attributes: [NSFontAttributeName: UIFont.init(name: "Verdana-Bold", size: 22)!])
        // Part of string to be bolded
        //self.selectTypeLabel.attributedText = attributedGreeting
        selectTypeLabel.textAlignment = NSTextAlignment.Left
        selectTypeLabel.numberOfLines = 0
        selectTypeLabel.textColor = necterGray
        selectTypeLabel.alpha = 0
        
        view.addSubview(selectTypeLabel)
        
        
        //Bot that fades in and down to speak with you
        let _ = Timer(interval: 0.25) {i -> Bool in

            UIView.animateWithDuration(0.7, delay: 0.2, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                if i == 0 {
                    self.selectTypeLabel.frame = CGRect(x: 0.05*self.screenWidth, y: 0.05*self.screenHeight, width: 0.9*self.screenWidth, height: 0.25*self.screenHeight)
                    let attributedGreeting2 = NSMutableAttributedString(string: greeting as String, attributes: [NSFontAttributeName: UIFont.init(name: "Verdana", size: 22)!])
                    let boldedFontAttribute = [NSFontAttributeName: UIFont.init(name: "Verdana-Bold", size: 22) as! AnyObject]
                    let lineBreakAttribute = [NSFontAttributeName: UIFont.init(name: "Verdana-Bold", size: 10) as! AnyObject]
                    attributedGreeting2.addAttributes(boldedFontAttribute, range: greeting.rangeOfString("Hello \(self.firstName),"))
                    attributedGreeting2.addAttributes(lineBreakAttribute, range: greeting.rangeOfString("\n\n"))
                    self.selectTypeLabel.attributedText = attributedGreeting2
                    self.selectTypeLabel.alpha = 1
                } else if i == 2 {
                    self.optionsTableView.alpha = 1.0
                }
                
              }, completion: nil)
            return i < 4
            }
        
        //Bot that pops in to speak with you
        /*let _ = Timer(interval: 0.5) {i -> Bool in
         if i == 1 {
         self.selectTypeLabel.attributedText = attributedGreeting
         self.selectTypeLabel.alpha = 1.0
         } else if i == 2 {
         greeting = "Hello \(self.firstName), \n\nWhat type of connection are you looking for?"
         let attributedGreeting2 = NSMutableAttributedString(string: greeting as String, attributes: [NSFontAttributeName: UIFont.init(name: "Verdana", size: 22)!])
         let boldedFontAttribute = [NSFontAttributeName: UIFont.init(name: "Verdana-Bold", size: 22) as! AnyObject]
         let lineBreakAttribute = [NSFontAttributeName: UIFont.init(name: "Verdana-Bold", size: 10) as! AnyObject]
         attributedGreeting2.addAttributes(boldedFontAttribute, range: greeting.rangeOfString("Hello \(self.firstName),"))
         print(attributedGreeting)
         attributedGreeting2.addAttributes(lineBreakAttribute, range: greeting.rangeOfString("\n\n"))
         print(attributedGreeting)
         self.selectTypeLabel.attributedText = attributedGreeting2
         } else if i == 3 {
         self.optionsTableView.alpha = 1.0
         }
         print(i)
         return i < 4
         }*/
        

        
        //Bot that types in to speak with you
        /*let _ = Timer(interval: 0.5) {i -> Bool in
         //self.selectTypeLabel.attributedText = attributedGreeting.attributedSubstringFromRange(NSRange(location: 0, length: i+1))
         //return i + 1 < attributedGreeting.string.characters.count
         if i == 1 {
         self.selectTypeLabel.attributedText = attributedGreeting
         self.selectTypeLabel.alpha = 1.0
         } else if i == 2 {
         greeting = "Hello \(self.firstName), \n\nWhat type of connection are you looking for?"
         let attributedGreeting2 = NSMutableAttributedString(string: greeting as String, attributes: [NSFontAttributeName: UIFont.init(name: "Verdana", size: 22)!])
         let boldedFontAttribute = [NSFontAttributeName: UIFont.init(name: "Verdana-Bold", size: 22) as! AnyObject]
         let lineBreakAttribute = [NSFontAttributeName: UIFont.init(name: "Verdana-Bold", size: 10) as! AnyObject]
         attributedGreeting2.addAttributes(boldedFontAttribute, range: greeting.rangeOfString("Hello \(self.firstName),"))
         print(attributedGreeting)
         attributedGreeting2.addAttributes(lineBreakAttribute, range: greeting.rangeOfString("\n\n"))
         print(attributedGreeting)
         self.selectTypeLabel.attributedText = attributedGreeting2
         } else if i == 3 {
         self.optionsTableView.alpha = 1.0
         }
         print(i)
         return i < 4
         }*/
        
        /*let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.optionsTableView.alpha = 1.0
            /*UIView.animateWithDuration(0.3) {
             self.optionsTableView.alpha = 1.0
             }*/
        }*/

        
       
        //adding the optionsTableView
        optionsTableView.registerClass(StatusTableViewCell.self, forCellReuseIdentifier: "cell")
        optionsTableView.frame = CGRect(x: 0, y: 0.3*screenHeight, width: screenWidth, height: 0.6*screenHeight)
        optionsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        optionsTableView.tableFooterView = UIView()
        optionsTableView.rowHeight = optionsTableView.frame.size.height/CGFloat(optionsTableView.numberOfRowsInSection(0))
        optionsTableView.alpha = 0
        view.addSubview(optionsTableView)
        
        
        //adding the cancel button
        cancelButton.frame = CGRect(x: 0, y:0.9*screenHeight, width:0.3*screenWidth, height:0.06*screenHeight)
        cancelButton.center.x = view.center.x
        cancelButton.layer.borderWidth = 4.0
        cancelButton.layer.borderColor = necterGray.CGColor
        cancelButton.layer.cornerRadius = 7.0
        cancelButton.setTitle("cancel", forState: .Normal)
        cancelButton.setTitleColor(necterGray, forState: .Normal)
        cancelButton.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
        cancelButton.titleLabel!.font = UIFont(name: "BentonSans", size: 20)
        cancelButton.addTarget(self, action: #selector(cancelTapped), forControlEvents: .TouchUpInside)
        view.addSubview(cancelButton)
        
        //adding the view elements to the NewBridgeStatusViewController
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        
        if necterType == "" {
            //navigationBar.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 0.11*screenHeight)
            //username.frame = CGRect(x: 0.12*screenWidth, y: 0.7*screenHeight, width: 0.5*screenWidth, height: 0.1*screenHeight)
            //screenOverImage.frame = profilePicture.frame
            //profilePicture.frame = CGRect(x: 0.1*screenWidth, y: 0.5*screenHeight, width: 0.8*screenWidth, height: 0.4*screenHeight)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Setting Up the optionsTable
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return 3
        
    }
    
    // Data to be shown on an individual row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = StatusTableViewCell()//optionsTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! StatusTableViewCell
        cell.cellHeight = optionsTableView.frame.size.height/CGFloat(optionsTableView.numberOfRowsInSection(0))
            //CGRect(x: 0.1*self.frame.width, y: 0, width: 0.2*self.frame.width, height: 0.2*self.frame.width)
        //optionImage.center.y = self.center.y
        //setting the information in the rows of the optionTableView
        if indexPath.row == 0 {
            //cell.optionImage.image = cell.optionImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            cell.optionImage.image = UIImage(named: "Business_Icon_Blue")
            cell.optionLabel.text = "Business"
            cell.optionLabel.textColor = businessBlue
            //cell.backgroundColor = UIColor(red: 144.0/255, green: 207.0/255, blue: 214.0/255, alpha: 1.0)
        } else if indexPath.row == 1 {
            cell.optionImage.image = UIImage(named: "Love_Icon_Red.svg")
            cell.optionLabel.text = "Love"
            cell.optionLabel.textColor = loveRed
            //cell.backgroundColor = UIColor(red: 255.0/255, green: 129.0/255, blue: 125.0/255, alpha: 1.0)
        } else {
            cell.optionImage.image = UIImage(named: "Friendship_Icon_Green.svg")
            cell.optionLabel.text = "Friendship"
            cell.optionLabel.textColor = friendshipGreen
            //cell.backgroundColor = UIColor(red: 139.0/255, green: 217.0/255, blue: 176.0/255, alpha: 1.0)

        }
        
        return cell
        
    }
    // A row is selected
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 {
            necterType = "Business"
            //bridgeStatus.textColor = businessBlue
            //profilePicture.layer.borderColor = businessBlue.CGColor
            //profilePicture.layer.borderWidth = 4
            setPositionsForEnteringStatus()
        } else if indexPath.row == 1 {
            print("Love tapped")
            necterType = "Love"
            //bridgeStatus.textColor = loveRed
            //profilePicture.layer.borderWidth = 4
            //profilePicture.layer.borderColor = loveRed.CGColor
            setPositionsForEnteringStatus()
        } else {
            print("Friendship tapped")
            necterType = "Friendship"
            //bridgeStatus.textColor = friendshipGreen
            //profilePicture.layer.borderWidth = 4
            //profilePicture.layer.borderColor = friendshipGreen.CGColor
            setPositionsForEnteringStatus()

        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController
        let mirror = Mirror(reflecting: vc)
        if mirror.subjectType == BridgeViewController.self {
            self.transitionManager.animationDirection = "Bottom"
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


class Timer {
    typealias TimerFunction = (Int)->Bool
    private var handler: TimerFunction
    private var i = 0
    
    init(interval: NSTimeInterval, handler: TimerFunction) {
        self.handler = handler
        NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: "timerFired:", userInfo: nil, repeats: true)
    }
    
    @objc
    private func timerFired(timer:NSTimer) {
        if !handler(i++) {
            timer.invalidate()
        }
    }
}
