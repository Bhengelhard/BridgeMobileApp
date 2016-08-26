//
//  SignupViewController.swift
//  MyBridgeApp
//
//  Created by Sagar Sinha on 6/16/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4
import FBSDKLoginKit
import CoreData

class SignupViewController:UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    //@IBOutlet weak var main_title: UILabel!
    let mainTitle = UILabel()
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var editImageButton: UIButton!
    @IBOutlet weak var friendshipLabel: UILabel!
    @IBOutlet weak var loveLabel: UILabel!
    @IBOutlet weak var businessLabel: UILabel!
    @IBOutlet weak var businessSwitch: UISwitch!
    @IBOutlet weak var friendshipSwitch: UISwitch!
    @IBOutlet weak var loveSwitch: UISwitch!
    @IBOutlet weak var interestedLabel: UILabel!
    @IBOutlet weak var beginConnectingButton: UIButton!
    let updateLaterLabel = UILabel()
    let businessIcon = UIImageView()
    let loveIcon = UIImageView()
    let friendshipIcon = UIImageView()
    
   
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    let necterYellow = UIColor(red: 255/255, green: 230/255, blue: 57/255, alpha: 1.0)
    let businessBlue = UIColor(red: 36.0/255, green: 123.0/255, blue: 160.0/255, alpha: 1.0)
    let loveRed = UIColor(red: 242.0/255, green: 95.0/255, blue: 92.0/255, alpha: 1.0)
    let friendshipGreen = UIColor(red: 112.0/255, green: 193.0/255, blue: 179.0/255, alpha: 1.0)
    let necterGray = UIColor(red: 80.0/255.0, green: 81.0/255.0, blue: 79.0/255.0, alpha: 1.0)

    
    // globally required as we do not want to re-create them everytime and for persistence
    let imagePicker = UIImagePickerController()
    var editableName:String = ""
    let noNameText = "Click to enter your full name"
    
    
    @IBAction func editImageTapped(sender: AnyObject) {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        //self.picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
        imagePicker.allowsEditing = false

    }
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }else{
            let alert = UIAlertView()
            alert.title = "Warning"
            alert.message = "You don't have camera"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
    }
    func openGallary(){
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    //update the UIImageView once an image has been picked
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            editImageButton.setImage(pickedImage, forState: .Normal)
            if let imageData = UIImageJPEGRepresentation(pickedImage, 1.0){
                let localData = LocalData()
                localData.setMainProfilePicture(imageData)
                localData.synchronize()
                
                //update the user's profile picture in Database
                if let _ = PFUser.currentUser() {
                    let file = PFFile(data:imageData)
                    PFUser.currentUser()!["profile_picture"] = file
                    PFUser.currentUser()?.saveInBackground()
                }
                
            }

            
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    //stopping user from entering name with length greater than 25
    @IBAction func nameTextFieldChanges(sender: AnyObject) {
        if let characterCount = nameTextField.text?.characters.count {
            if characterCount > 25 {
                let aboveMaxBy = characterCount - 25
                let index1 = nameTextField.text!.endIndex.advancedBy(-aboveMaxBy)
                nameTextField.text = nameTextField.text!.substringToIndex(index1)
            }
        }
    }
    // Begin Bridging Button Clicked
    @IBAction func beginBridgingTouched(sender: AnyObject) {
        beginConnectingButton.layer.borderColor = necterYellow.CGColor
        if let _ = PFUser.currentUser() {
            PFUser.currentUser()?["name"] = editableName
            PFUser.currentUser()?["interested_in_business"] = businessSwitch.on
            PFUser.currentUser()?["interested_in_love"] = loveSwitch.on
            PFUser.currentUser()?["interested_in_friendship"] = friendshipSwitch.on
            PFUser.currentUser()?.saveInBackgroundWithBlock({ (success, error) in
                if success {
                    LocalStorageUtility().updateBridgePairingsTable()// remember to uncomment this!
                }
            })
        }
        let localData = LocalData()
        localData.setUsername(editableName)
        localData.synchronize()
    }
    // Switches tapped
    @IBAction func businessSwitchTapped(sender: AnyObject) {
        if businessSwitch.on{
            businessLabel.textColor = businessBlue
            businessIcon.image = UIImage(named: "Business_Icon_Blue")
        }
        else{
            businessLabel.textColor = UIColor.grayColor()
            businessIcon.image = UIImage(named: "Business_Icon_Gray")
        }
    }
    @IBAction func loveSwitchTapped(sender: AnyObject) {
        if loveSwitch.on{
            loveLabel.textColor = loveRed
            loveIcon.image = UIImage(named: "Love_Icon_Red")
        }
        else{
          
            loveLabel.textColor = UIColor.grayColor()
            loveIcon.image = UIImage(named: "Love_Icon_Gray")
        }
    }
    @IBAction func friendshipSwitchTapped(sender: AnyObject) {
        if friendshipSwitch.on{
            friendshipLabel.textColor = friendshipGreen
            friendshipIcon.image = UIImage(named: "Friendship_Icon_Green")
        }
        else{
            friendshipLabel.textColor = UIColor.grayColor()
            friendshipIcon.image = UIImage(named: "Friendship_Icon_Gray")
        }
    }

    

    override func viewDidLoad() {
                super.viewDidLoad()
        
        imagePicker.delegate = self
        nameTextField.delegate = self
        
        let username = LocalData().getUsername()
        
        if let username = username {
            var usernameString = username
            //name with max characters of 25
            if usernameString.characters.count > 25 {
                let aboveMaxBy = usernameString.characters.count - 25
                let index1 = usernameString.endIndex.advancedBy(-aboveMaxBy)
                usernameString = usernameString.substringToIndex(index1)
                /*let localData = LocalData()
                localData.setUsername(usernameString)
                localData.synchronize()*/
            }
            if usernameString != "" {
                editableName = usernameString
                nameTextField.text = usernameString
                mainTitle.attributedText = twoColoredString(editableName+"'s Interests", partLength: 12, start: 12, color: UIColor.blackColor())
            } else{
                editableName = noNameText
                mainTitle.text = noNameText
                mainTitle.textColor = necterYellow
            }
        }
        else{
            editableName = noNameText
            mainTitle.text = noNameText
            mainTitle.textColor = necterYellow
        }
        nameTextField.hidden = true
        mainTitle.userInteractionEnabled = true
        
        
        let aSelector : Selector = #selector(SignupViewController.lblTapped)
        let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
        tapGesture.numberOfTapsRequired = 1
        mainTitle.addGestureRecognizer(tapGesture)
        
        let outSelector : Selector = #selector(SignupViewController.tappedOutside)
        let outsideTapGesture = UITapGestureRecognizer(target: self, action: outSelector)
        outsideTapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(outsideTapGesture)
        
        let mainProfilePicture = LocalData().getMainProfilePicture()
        if let mainProfilePicture = mainProfilePicture {
            let image = UIImage(data:mainProfilePicture,scale:1.0)
            editImageButton.setImage(image, forState: .Normal)
        } else {
            let pfData = PFUser.currentUser()?["profile_picture"] as? PFFile
            if let pfData = pfData {
                pfData.getDataInBackgroundWithBlock({ (data, error) in
                    if error != nil || data == nil {
                        print(error)
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.editImageButton.setImage(UIImage(data: data!, scale: 1.0), forState:  .Normal)
                        })
                    }
                })
            }
            
        }
        if mainTitle.text == noNameText {
            beginConnectingButton.layer.borderColor = UIColor.lightGrayColor().CGColor
            beginConnectingButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
            beginConnectingButton.enabled = false
        } else {
            /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                var i = 1
                while i < 4 {
                    sleep(1)
                    dispatch_async(dispatch_get_main_queue(), {
                        if i == 1 {
                            self.main_title.textColor = UIColor.lightGrayColor()
                            self.main_title.attributedText = self.twoColoredString(self.editableName+"'s Interests", partLength: self.editableName.characters.count, start: (self.editableName.characters.count + 12), color: self.necterYellow)
                        } else if i == 2 {
                            if self.nameTextField.hidden != false {
                            }
                        } else if i == 3 {
                            if self.nameTextField.hidden != false {
                                self.beginConnectingButton.layer.borderColor = self.necterYellow.CGColor
                                self.main_title.textColor = UIColor.lightGrayColor()
                                self.main_title.attributedText = self.twoColoredString(self.editableName+"'s Interests", partLength: 12, start: 12, color: UIColor.blackColor())
                            }
                            self.interestedLabel.textColor = UIColor.blackColor()
                        }
                        i += 1
                    })
                }
                
            }*/
        }
        beginConnectingButton.layer.cornerRadius = 7.0
        beginConnectingButton.layer.borderWidth = 4.0
        beginConnectingButton.clipsToBounds = true
        if editableName == "" || editableName == noNameText {
            beginConnectingButton.layer.borderColor = UIColor.lightGrayColor().CGColor
            beginConnectingButton.enabled = false
        } else {
            beginConnectingButton.layer.borderColor = necterYellow.CGColor
            beginConnectingButton.setTitleColor(necterYellow, forState: .Highlighted)
        }
        
        //label below beginConnecting Button
        updateLaterLabel.textAlignment = NSTextAlignment.Center
        updateLaterLabel.text = "You can always update your interests later"
        updateLaterLabel.font = UIFont(name: "BentonSans", size: 12)
        updateLaterLabel.textColor = UIColor.blackColor()
        updateLaterLabel.numberOfLines = 0
        
        //setting the title to the view
        mainTitle.textAlignment = NSTextAlignment.Center
        mainTitle.font = UIFont(name: "Verdana", size: 22)
        mainTitle.numberOfLines = 2
        //mainTitle.textColor = UIColor.lightGrayColor()
        mainTitle.textColor = UIColor.lightGrayColor()
        mainTitle.attributedText = twoColoredString(mainTitle.text!, partLength: 12, start: 12, color: UIColor.blackColor())
        self.view.addSubview(mainTitle)
        self.view.addSubview(updateLaterLabel)
        
    }
    
    override func viewDidLayoutSubviews() {
        
        let modelName = UIDevice.currentDevice().modelName
        
        
        //setting up elements
        businessLabel.textColor = businessBlue
        loveLabel.textColor = loveRed
        friendshipLabel.textColor = friendshipGreen
        businessIcon.image = UIImage(named: "Business_Icon_Blue")
        loveIcon.image = UIImage(named: "Love_Icon_Red")
        friendshipIcon.image = UIImage(named: "Friendship_Icon_Green")
        
        
        
        
        //placing elements
        if ["iPhone 4", "iPhone 4s", "iPhone 5", "iPhone 5", "iPhone 5c", "iPhone 5s", "Simulator"].contains(modelName) {
        //placing elements on smaller sized iPhones
            mainTitle.frame = CGRect(x:0.05*screenWidth , y:0.05*screenHeight, width:0.9*screenWidth, height:0.15*screenHeight)
            nameTextField.frame = CGRect(x:0.05*screenWidth , y:0.05*screenHeight, width:0.9*screenWidth, height:0.08*screenHeight)
            editImageButton.frame = CGRect(x: 0, y:0.19*screenHeight, width:0.23*screenHeight, height:0.23*screenHeight)
            editImageButton.center.x = self.view.center.x
            editImageButton.layer.cornerRadius = editImageButton.frame.size.width/2
            editImageButton.clipsToBounds = true
            interestedLabel.frame = CGRect(x:0.05*screenWidth , y:0.45*screenHeight, width:0.9*screenWidth, height:0.08*screenHeight)
            businessIcon.frame = CGRect(x:0.125*screenWidth , y:0.55*screenHeight, width:0.1*screenWidth, height:0.1*screenWidth)
            businessLabel.frame = CGRect(x:0.25*screenWidth , y:0, width:0.4*screenWidth, height:0.04*screenHeight)
            businessLabel.center.y = businessIcon.center.y
            businessSwitch.frame = CGRect(x: 0.7*screenWidth, y: 0, width: 0, height: 0)
            businessSwitch.center.y = businessLabel.center.y
            loveIcon.frame = CGRect(x:0.125*screenWidth , y:0.65*screenHeight, width:0.1*screenWidth, height:0.1*screenWidth)
            loveLabel.frame = CGRect(x:0.25*screenWidth , y:0, width:0.4*screenWidth, height:0.04*screenHeight)
            loveLabel.center.y = loveIcon.center.y
            loveSwitch.frame = CGRect(x: 0.7*screenWidth, y: 0, width: 0, height: 0)
            loveSwitch.center.y = loveLabel.center.y
            friendshipIcon.frame = CGRect(x:0.125*screenWidth , y:0.75*screenHeight, width:0.1*screenWidth, height:0.1*screenWidth)
            friendshipLabel.frame = CGRect(x:0.25*screenWidth , y:0, width:0.4*screenWidth, height:0.04*screenHeight)
            friendshipLabel.center.y = friendshipIcon.center.y
            friendshipSwitch.frame = CGRect(x: 0.7*screenWidth, y: 0, width: 0, height: 0)
            friendshipSwitch.center.y = friendshipLabel.center.y
            beginConnectingButton.frame = CGRect(x:0.16*screenWidth, y:0.85*screenHeight, width:0.68*screenWidth, height:0.075*screenHeight)
            updateLaterLabel.frame = CGRectMake(0.05*screenWidth, 0.925*screenHeight, 0.9*screenWidth, 0.05*screenHeight)
            
        } else {
        //placing elements on larger iPhones
            mainTitle.frame = CGRect(x:0.05*screenWidth , y:0.05*screenHeight, width:0.9*screenWidth, height:0.1*screenHeight)
            nameTextField.frame = CGRect(x:0.05*screenWidth , y:0.05*screenHeight, width:0.9*screenWidth, height:0.08*screenHeight)
            editImageButton.frame = CGRect(x: 0, y:0.17*screenHeight, width:0.25*screenHeight, height:0.25*screenHeight)
            editImageButton.center.x = self.view.center.x
            editImageButton.layer.cornerRadius = editImageButton.frame.size.width/2
            editImageButton.clipsToBounds = true
            interestedLabel.frame = CGRect(x:0.05*screenWidth , y:0.45*screenHeight, width:0.9*screenWidth, height:0.1*screenHeight)
            businessIcon.frame = CGRect(x:0.125*screenWidth , y:0.55*screenHeight, width:0.1*screenWidth, height:0.1*screenWidth)
            businessLabel.frame = CGRect(x:0.25*screenWidth , y:0.55*screenHeight, width:0.4*screenWidth, height:0.04*screenHeight)
            businessLabel.center.y = businessIcon.center.y
            businessSwitch.frame = CGRect(x: 0.7*screenWidth, y: 0, width: 0, height: 0)
            businessSwitch.center.y = businessLabel.center.y
            loveIcon.frame = CGRect(x:0.125*screenWidth , y:0.65*screenHeight, width:0.1*screenWidth, height:0.1*screenWidth)
            loveLabel.frame = CGRect(x:0.25*screenWidth , y:0.65*screenHeight, width:0.4*screenWidth, height:0.04*screenHeight)
            loveLabel.center.y = loveIcon.center.y
            loveSwitch.frame = CGRect(x: 0.7*screenWidth, y: 0, width: 0, height: 0)
            loveSwitch.center.y = loveLabel.center.y
            friendshipIcon.frame = CGRect(x:0.125*screenWidth , y:0.75*screenHeight, width:0.1*screenWidth, height:0.1*screenWidth)
            friendshipLabel.frame = CGRect(x:0.25*screenWidth , y:0.75*screenHeight, width:0.4*screenWidth, height:0.04*screenHeight)
            friendshipLabel.center.y = friendshipIcon.center.y
            friendshipSwitch.frame = CGRect(x: 0.7*screenWidth, y: 0, width: 0, height: 0)
            friendshipSwitch.center.y = friendshipLabel.center.y
            beginConnectingButton.frame = CGRect(x:0.16*screenWidth, y:0.85*screenHeight, width:0.68*screenWidth, height:0.075*screenHeight)
            updateLaterLabel.frame = CGRectMake(0.05*screenWidth, 0.925*screenHeight, 0.9*screenWidth, 0.05*screenHeight)
            
        }
        
        view.addSubview(businessIcon)
        view.addSubview(loveIcon)
        view.addSubview(friendshipIcon)
        
        
        
    }
    
    // Utility functions
    // generate a 2-colored string. Used for the title
    func twoColoredString(full:String,partLength: Int, start: Int, color: UIColor)->NSMutableAttributedString{
        let mutableString = NSMutableAttributedString(string: full)
        mutableString.addAttribute(NSForegroundColorAttributeName, value: color, range: NSRange(location:full.characters.count-start, length:partLength))
        return mutableString
        
    }
    
    
    // Username label is tapped. Textfield should appear and replace the label
    func lblTapped(){
        nameTextField.becomeFirstResponder()
        nameTextField.textColor = necterYellow
        mainTitle.hidden = true
        nameTextField.hidden = false
        if editableName != noNameText {
            nameTextField.text = editableName
        }
        beginConnectingButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        beginConnectingButton.enabled = false
    }
    // Tapped anywhere else on the main view. Textfield should be replaced by label
    func tappedOutside(){
        if mainTitle.text == self.noNameText {
            mainTitle.hidden = true
            nameTextField.hidden = false
            nameTextField.becomeFirstResponder()
            nameTextField.attributedPlaceholder = NSAttributedString(string:"Enter your full name", attributes: [NSForegroundColorAttributeName: necterYellow])
        } else {
            beginConnectingButton.layer.borderColor = necterYellow.CGColor
            beginConnectingButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            beginConnectingButton.enabled = true
            beginConnectingButton.setTitleColor(necterYellow, forState: .Highlighted)
            mainTitle.hidden = false
            nameTextField.hidden = true
            self.view.endEditing(true)
        }
        
        if let editableNameTemp = nameTextField.text{
            if editableNameTemp != "" {
                editableName = editableNameTemp
                mainTitle.attributedText = twoColoredString(editableNameTemp+"'s Interests", partLength: 12, start: 12, color: UIColor.blackColor())
            }
        }
        if editableName != "" {
            beginConnectingButton.layer.borderColor = necterYellow.CGColor
            beginConnectingButton.enabled = true
        }
    }
    // User returns after editing
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        nameTextField.hidden = true
        mainTitle.hidden = false
        if let editableNameTemp = nameTextField.text{
            mainTitle.attributedText = twoColoredString(editableNameTemp+"'s Interests", partLength: 12, start: 12, color: UIColor.blackColor())
            editableName = editableNameTemp
        }
        /*let updatedText = nameTextField.text
        if let updatedText = updatedText {
            let localData = LocalData()
            localData.setUsername(updatedText)
            localData.synchronize()
        }*/
        return true
    }

     override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
