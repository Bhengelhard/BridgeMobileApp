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
    @IBOutlet weak var main_title: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    //@IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var editImageButton: UIButton!
    @IBOutlet weak var friendshipLabel: UILabel!
    @IBOutlet weak var loveLabel: UILabel!
    @IBOutlet weak var businessLabel: UILabel!
    @IBOutlet weak var businessSwitch: UISwitch!
    @IBOutlet weak var friendshipSwitch: UISwitch!
    @IBOutlet weak var loveSwitch: UISwitch!
    @IBOutlet weak var interestedLabel: UILabel!
    @IBOutlet weak var beginConnectingButton: UIButton!
   
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    let necterYellow = UIColor(red: 255/255, green: 230/255, blue: 57/255, alpha: 1.0)
    
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
            }

        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
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
                    LocalStorageUtility().getBridgePairings()
                }
            })
        }
    }
    // Switches tapped
    @IBAction func friendshipSwitchTapped(sender: AnyObject) {
        if friendshipSwitch.on{
            friendshipLabel.textColor = UIColor.blackColor()
        }
        else{
            friendshipLabel.textColor = UIColor.grayColor()
        }
    }
    @IBAction func loveSwitchTapped(sender: AnyObject) {
        if loveSwitch.on{
            loveLabel.textColor = UIColor.blackColor()
        }
        else{
          
            loveLabel.textColor = UIColor.grayColor()
        }
    }
    
    @IBAction func businessSwitchTapped(sender: AnyObject) {
        if businessSwitch.on{
            businessLabel.textColor = UIColor.blackColor()
        }
        else{
            businessLabel.textColor = UIColor.grayColor()
        }
    }

    override func viewDidLoad() {
                super.viewDidLoad()
        
        imagePicker.delegate = self
        nameTextField.delegate = self
        
        let username = LocalData().getUsername()
        
        if let username = username {
            if username != "" {
                editableName = username
                nameTextField.text = username
                main_title.attributedText = twoColoredString(editableName+"'s Interests", partLength: 12, start: 12, color: UIColor.blackColor())
            } else{
                editableName = noNameText
                main_title.text = noNameText
                main_title.textColor = necterYellow
            }
        }
        else{
            editableName = noNameText
            main_title.text = noNameText
        }
        nameTextField.hidden = true
        main_title.userInteractionEnabled = true
        
        
        let aSelector : Selector = #selector(SignupViewController.lblTapped)
        let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
        tapGesture.numberOfTapsRequired = 1
        main_title.addGestureRecognizer(tapGesture)
        
        let outSelector : Selector = #selector(SignupViewController.tappedOutside)
        let outsideTapGesture = UITapGestureRecognizer(target: self, action: outSelector)
        outsideTapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(outsideTapGesture)
        
        let mainProfilePicture = LocalData().getMainProfilePicture()
        if let mainProfilePicture = mainProfilePicture {
            let image = UIImage(data:mainProfilePicture,scale:1.0)
            editImageButton.setImage(image, forState: .Normal)
        }
        if main_title.text == noNameText {
            beginConnectingButton.layer.borderColor = UIColor.lightGrayColor().CGColor
            beginConnectingButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
            beginConnectingButton.enabled = false
        } else {
            beginConnectingButton.layer.borderColor = UIColor.lightGrayColor().CGColor
            beginConnectingButton.setTitleColor(necterYellow, forState: .Highlighted)
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                var i = 1
                while i < 4 {
                    sleep(1)
                    dispatch_async(dispatch_get_main_queue(), {
                        if i == 1 {
                            self.main_title.textColor = UIColor.blackColor()
                            self.main_title.attributedText = self.twoColoredString(self.editableName+"'s Interests", partLength: self.editableName.characters.count, start: (self.editableName.characters.count + 12), color: self.necterYellow)
                        } else if i == 2 {
                            self.interestedLabel.textColor = self.necterYellow
                            self.main_title.textColor = UIColor.lightGrayColor()
                            self.main_title.attributedText = self.twoColoredString(self.editableName+"'s Interests", partLength: 12, start: 12, color: UIColor.blackColor())
                        } else if i == 3 {
                            self.beginConnectingButton.layer.borderColor = self.necterYellow.CGColor
                            self.interestedLabel.textColor = UIColor.blackColor()
                        }
                        i += 1
                    })
                }
                
            }
        }
        beginConnectingButton.layer.cornerRadius = 7.0
        beginConnectingButton.layer.borderWidth = 4.0
        beginConnectingButton.clipsToBounds = true
        
    }
    
    override func viewDidLayoutSubviews() {
        
        let modelName = UIDevice.currentDevice().modelName
        
        //placing elements
        if ["iPhone 4", "iPhone 4s", "iPhone 5", "iPhone 5", "iPhone 5c", "iPhone 5s"].contains(modelName) {
        //placing elements on smaller sized iPhones
            main_title.frame = CGRect(x:0.05*screenWidth , y:0.05*screenHeight, width:0.9*screenWidth, height:0.1*screenHeight)
            nameTextField.frame = CGRect(x:0.05*screenWidth , y:0.05*screenHeight, width:0.9*screenWidth, height:0.08*screenHeight)
            editImageButton.layer.borderWidth = 4.0
            editImageButton.layer.borderColor = necterYellow.CGColor
            editImageButton.frame = CGRect(x: 0, y:0.16*screenHeight, width:0.24*screenHeight, height:0.24*screenHeight)
            editImageButton.center.x = self.view.center.x
            editImageButton.layer.cornerRadius = editImageButton.frame.size.width/2
            editImageButton.clipsToBounds = true
            interestedLabel.frame = CGRect(x:0.05*screenWidth , y:0.42*screenHeight, width:0.9*screenWidth, height:0.05*screenHeight)
            businessLabel.frame = CGRect(x:0.125*screenWidth , y:0.5*screenHeight, width:0.4*screenWidth, height:0.04*screenHeight)
            businessSwitch.frame = CGRect(x: 0.7*screenWidth, y: 0, width: 0, height: 0)
            businessSwitch.center.y = businessLabel.center.y
            loveLabel.frame = CGRect(x:0.125*screenWidth , y:0.59*screenHeight, width:0.4*screenWidth, height:0.04*screenHeight)
            loveSwitch.frame = CGRect(x: 0.7*screenWidth, y: 0, width: 0, height: 0)
            loveSwitch.center.y = loveLabel.center.y
            friendshipLabel.frame = CGRect(x:0.125*screenWidth , y:0.68*screenHeight, width:0.4*screenWidth, height:0.04*screenHeight)
            friendshipSwitch.frame = CGRect(x: 0.7*screenWidth, y: 0, width: 0, height: 0)
            friendshipSwitch.center.y = friendshipLabel.center.y
            beginConnectingButton.frame = CGRect(x:0.16*screenWidth, y:0.785*screenHeight, width:0.68*screenWidth, height:0.075*screenHeight)
        } else {
        //placing elements on larger iPhones
            main_title.frame = CGRect(x:0.05*screenWidth , y:0.05*screenHeight, width:0.9*screenWidth, height:0.1*screenHeight)
            nameTextField.frame = CGRect(x:0.05*screenWidth , y:0.05*screenHeight, width:0.9*screenWidth, height:0.08*screenHeight)
            editImageButton.frame = CGRect(x: 0, y:0.17*screenHeight, width:0.25*screenHeight, height:0.25*screenHeight)
            editImageButton.center.x = self.view.center.x
            editImageButton.layer.cornerRadius = editImageButton.frame.size.width/2
            editImageButton.clipsToBounds = true
            interestedLabel.frame = CGRect(x:0.05*screenWidth , y:0.45*screenHeight, width:0.9*screenWidth, height:0.1*screenHeight)
            businessLabel.frame = CGRect(x:0.125*screenWidth , y:0.55*screenHeight, width:0.4*screenWidth, height:0.04*screenHeight)
            businessSwitch.frame = CGRect(x: 0.7*screenWidth, y: 0, width: 0, height: 0)
            businessSwitch.center.y = businessLabel.center.y
            loveLabel.frame = CGRect(x:0.125*screenWidth , y:0.65*screenHeight, width:0.4*screenWidth, height:0.04*screenHeight)
            loveSwitch.frame = CGRect(x: 0.7*screenWidth, y: 0, width: 0, height: 0)
            loveSwitch.center.y = loveLabel.center.y
            friendshipLabel.frame = CGRect(x:0.125*screenWidth , y:0.75*screenHeight, width:0.4*screenWidth, height:0.04*screenHeight)
            friendshipSwitch.frame = CGRect(x: 0.7*screenWidth, y: 0, width: 0, height: 0)
            friendshipSwitch.center.y = friendshipLabel.center.y
            beginConnectingButton.frame = CGRect(x:0.16*screenWidth, y:0.85*screenHeight, width:0.68*screenWidth, height:0.075*screenHeight)
            
        }
        
        
        
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
        main_title.hidden = true
        nameTextField.hidden = false
        if editableName != noNameText {
            nameTextField.text = editableName
        }
    }
    // Tapped anywhere else on the main view. Textfield should be replaced by label
    func tappedOutside(){
        if main_title.text == self.noNameText {
            main_title.hidden = true
            nameTextField.hidden = false
            nameTextField.becomeFirstResponder()
            nameTextField.attributedPlaceholder = NSAttributedString(string:"Enter your full name", attributes: [NSForegroundColorAttributeName: necterYellow])
        } else {
            beginConnectingButton.layer.borderColor = necterYellow.CGColor
            beginConnectingButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            beginConnectingButton.enabled = true
            beginConnectingButton.setTitleColor(necterYellow, forState: .Highlighted)
            main_title.hidden = false
            nameTextField.hidden = true
            self.view.endEditing(true)
        }
        
        if let editableNameTemp = nameTextField.text{
            if editableNameTemp != "" {
                main_title.attributedText = twoColoredString(editableNameTemp+"'s Interests", partLength: 12, start: 12, color: UIColor.blackColor())
                editableName = editableNameTemp
            }
        }
        let updatedText = nameTextField.text
        if let updatedText = updatedText {
            print(updatedText)
            let localData = LocalData()
            localData.setUsername(updatedText)
            localData.synchronize()
        }
    }
    // User returns after editing
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        nameTextField.hidden = true
        main_title.hidden = false
        if let editableNameTemp = nameTextField.text{
            main_title.attributedText = twoColoredString(editableNameTemp+"'s Interests", partLength: 12, start: 12, color: UIColor.blackColor())
            editableName = editableNameTemp
        }
        let updatedText = nameTextField.text
        if let updatedText = updatedText {
            let localData = LocalData()
            localData.setUsername(updatedText)
            localData.synchronize()
        }
        return true
    }

     override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
