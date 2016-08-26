//
//  EditProfileViewController.swift
//  MyBridgeApp
//
//  Created by Daniel Fine on 8/26/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit

class EditProfileViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //creating the elements on the View
    let navigationBar = UINavigationBar()
    let cancelButton = UIButton()
    let profilePictureButton = UIButton()
    let name = UILabel()
    let nameTextField = UITextField()
    var editableName:String = ""
    let noNameText = "Click to enter your full name"
    let interestedLabel = UILabel()
    let businessIcon = UIImageView()
    let businessLabel = UILabel()
    let businessSwitch = UISwitch()
    let loveIcon = UIImageView()
    let loveLabel = UILabel()
    let loveSwitch = UISwitch()
    let friendshipIcon = UIImageView()
    let friendshipLabel = UILabel()
    let friendshipSwitch = UISwitch()
    let saveButton = UIButton()
    
    //setting these variables to check if anything on the page changed
    let username = LocalData().getUsername()
    var originalProfilePicture = UIImage()
    var interestedInBusiness = Bool()
    var interestedInLove = Bool()
    var interestedInFriendship = Bool()
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    let transitionManager = TransitionManager()
    let localData = LocalData()
    
    //necter Colors
    let necterYellow = UIColor(red: 255/255, green: 230/255, blue: 57/255, alpha: 1.0)
    let businessBlue = UIColor(red: 36.0/255, green: 123.0/255, blue: 160.0/255, alpha: 1.0)
    let loveRed = UIColor(red: 242.0/255, green: 95.0/255, blue: 92.0/255, alpha: 1.0)
    let friendshipGreen = UIColor(red: 112.0/255, green: 193.0/255, blue: 179.0/255, alpha: 1.0)
    let necterGray = UIColor(red: 80.0/255.0, green: 81.0/255.0, blue: 79.0/255.0, alpha: 1.0)

    
    // globally required as we do not want to re-create them everytime and for persistence
    let imagePicker = UIImagePickerController()
    
    
    func profilePictureTapped(sender: UIButton) {
        profilePictureButton.layer.borderColor = necterYellow.CGColor
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let facebookProfilePictureAction = UIAlertAction(title: "Facebook Profile Picture", style: UIAlertActionStyle.Default)
        {
            UIAlertAction in
            self.getMainProfilePictureFromFacebook()
        }
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
            self.profilePictureButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        }
        
        // Add the actions
        //self.picker.delegate = self
        alert.addAction(facebookProfilePictureAction)
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
        imagePicker.allowsEditing = false
        
    }
    //saves  to LocalDataStorage & Parse
    func getMainProfilePictureFromFacebook(){
        var pagingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        pagingSpinner.color = UIColor.darkGrayColor()
        pagingSpinner.hidesWhenStopped = true
        pagingSpinner.center.x = profilePictureButton.center.x
        pagingSpinner.center.y = profilePictureButton.center.y
        view.addSubview(pagingSpinner)
        pagingSpinner.startAnimating()
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name"])
        graphRequest.startWithCompletionHandler{ (connection, result, error) -> Void in
            if error != nil {
                print(error)
            }
            else if let result = result {
                let userId = result["id"]! as! String
                let facebookProfilePictureUrl = "https://graph.facebook.com/" + userId + "/picture?type=large"
                if let fbpicUrl = NSURL(string: facebookProfilePictureUrl) {
                    if let data = NSData(contentsOfURL: fbpicUrl) {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.profilePictureButton.setImage(UIImage(data: data), forState: .Normal)
                            pagingSpinner.stopAnimating()
                            pagingSpinner.removeFromSuperview()
                        })
                    }
                }
                
            }
        }
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
            profilePictureButton.setImage(pickedImage, forState: .Normal)
        }
        profilePictureButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        profilePictureButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func displayNavigationBar(){
        let navItem = UINavigationItem()
        /*//setting the messagesIcon to the leftBarButtonItem
        messagesButton.setImage(UIImage(named: "Messages_Icon_Gray"), forState: .Normal)
        messagesButton.setImage(UIImage(named: "Messages_Icon_Yellow"), forState: .Selected)
        messagesButton.setImage(UIImage(named: "Messages_Icon_Yellow"), forState: .Highlighted)
        messagesButton.addTarget(self, action: #selector(messagesTapped(_:)), forControlEvents: .TouchUpInside)
        messagesButton.frame = CGRect(x: 0, y: 0, width: 0.085*screenWidth, height: 0.085*screenWidth)
        messagesButton.contentMode = UIViewContentMode.ScaleAspectFill
        messagesButton.clipsToBounds = true
        let leftBarButton = UIBarButtonItem(customView: messagesButton)
        navItem.leftBarButtonItem = leftBarButton*/
        
        //cancel edit bar buton item
        cancelButton.setTitle(">", forState: .Normal)
        cancelButton.setTitleColor(necterGray, forState: .Normal)
        cancelButton.setTitleColor(necterYellow, forState: .Selected)
        cancelButton.setTitleColor(necterYellow, forState: .Highlighted)
        cancelButton.titleLabel!.font = UIFont(name: "Verdana-Bold", size: 24)!
        //leaveConversation.setImage(UIImage(named: "Profile_Icon_Yellow"), forState: .Selected)
        //leaveConversation.setImage(UIImage(named: "Profile_Icon_Yellow"), forState: .Highlighted)
        cancelButton.addTarget(self, action: #selector(cancelTapped(_:)), forControlEvents: .TouchUpInside)
        cancelButton.frame = CGRect(x: 0, y: 0, width: 0.2*screenWidth, height: 0.06*screenHeight)
        let rightBarButtonItem = UIBarButtonItem(customView: cancelButton)
        navItem.rightBarButtonItem = rightBarButtonItem
        
        
        //setting the navBar color and title
        navigationBar.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 0.11*screenHeight)
        navigationBar.setItems([navItem], animated: false)
        navigationBar.topItem?.title = "Edit Profile"
        navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Verdana", size: 24)!, NSForegroundColorAttributeName: necterYellow]
        navigationBar.barStyle = .Black
        navigationBar.barTintColor = UIColor.whiteColor()
        
        self.view.addSubview(navigationBar)
        
    }
    
    func cancelTapped(sender: UIBarButtonItem) {
        cancelButton.selected = true
        performSegueWithIdentifier("showProfilePageFromEditProfileView", sender: self)
    }
    
    func displayProfilePictureButton() {
        //get profile picture and set to a button
        let mainProfilePicture = localData.getMainProfilePicture()
        if let mainProfilePicture = mainProfilePicture {
            print("got main profile picture")
            let image = UIImage(data: mainProfilePicture, scale: 1.0)
            originalProfilePicture = image!
            profilePictureButton.setImage(image, forState: .Normal)
        }  else {
            let pfData = PFUser.currentUser()?["profile_picture"] as? PFFile
            if let pfData = pfData {
                pfData.getDataInBackgroundWithBlock({ (data, error) in
                    if error != nil || data == nil {
                        print(error)
                    } else {
                        let image = UIImage(data: data!, scale: 1.0)
                        self.originalProfilePicture = image!
                        dispatch_async(dispatch_get_main_queue(), {
                            self.profilePictureButton.setImage(image, forState:  .Normal)
                        })
                    }
                })
            }
            
        }
        
        profilePictureButton.addTarget(self, action: #selector(profilePictureTapped(_:)), forControlEvents: .TouchUpInside)
        
        profilePictureButton.frame = CGRect(x: 0, y:0.12*screenHeight, width:0.25*screenHeight, height:0.25*screenHeight)
        profilePictureButton.center.x = self.view.center.x
        profilePictureButton.layer.cornerRadius = profilePictureButton.frame.size.width/2
        profilePictureButton.contentMode = UIViewContentMode.ScaleAspectFill
        profilePictureButton.clipsToBounds = true
        profilePictureButton.layer.borderWidth = 4
        profilePictureButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        view.addSubview(profilePictureButton)
    }
    
    
    func displayName() {
        if let username = username {
            if username != "" {
                editableName = username
                nameTextField.text = username
            } else{
                
                editableName = noNameText
                name.text = noNameText
            }
        }
        else{
            editableName = noNameText
            name.text = noNameText
        }
        
        nameTextField.hidden = true
        name.userInteractionEnabled = true
        
        if let username = username {
            name.text = username
        }
        name.textColor = UIColor.lightGrayColor()
        
        let aSelector : Selector = #selector(EditProfileViewController.lblTapped)
        let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
        tapGesture.numberOfTapsRequired = 1
        name.addGestureRecognizer(tapGesture)
        
        name.font = UIFont(name: "Verdana", size: 18)
        name.textAlignment = NSTextAlignment.Center
        name.frame = CGRect(x: 0.1*screenWidth, y:0.38*screenHeight, width:0.8*screenWidth, height:0.05*screenHeight)
        
        nameTextField.font = UIFont(name: "Verdana", size: 18)
        nameTextField.textAlignment = NSTextAlignment.Center
        nameTextField.frame = CGRect(x: 0.1*screenWidth, y:0.38*screenHeight, width:0.8*screenWidth, height:0.05*screenHeight)
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        view.addSubview(name)
        view.addSubview(nameTextField)
    }
    
    //stopping user from entering name with length greater than 25
    func textFieldDidChange(sender: UITextField) {
        if let characterCount = nameTextField.text?.characters.count {
            if characterCount > 25 {
                let aboveMaxBy = characterCount - 25
                let index1 = nameTextField.text!.endIndex.advancedBy(-aboveMaxBy)
                nameTextField.text = nameTextField.text!.substringToIndex(index1)
            }
        }
    }
    
    // Username label is tapped. Textfield should appear and replace the label
    func lblTapped(){
        nameTextField.becomeFirstResponder()
        name.hidden = true
        nameTextField.hidden = false
        if editableName != noNameText {
            nameTextField.text = editableName
        }
        let outSelector : Selector = #selector(EditProfileViewController.tappedOutside)
        let outsideTapGesture = UITapGestureRecognizer(target: self, action: outSelector)
        outsideTapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(outsideTapGesture)
    }
    // Tapped anywhere else on the main view. Textfield should be replaced by label
    func tappedOutside(){
        if nameTextField.isFirstResponder() {
            nameTextField.endEditing(true)
            name.hidden = false
            nameTextField.hidden = true
            if let editableNameTemp = nameTextField.text{
                if editableNameTemp != "" {
                    name.text = editableNameTemp
                    editableName = editableNameTemp
                }
            }
            if let _ = view.gestureRecognizers {
                for gesture in view.gestureRecognizers! {
                    view.removeGestureRecognizer(gesture)
                }
            }
            
        }
    }
    // User returns after editing
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        nameTextField.hidden = true
        name.hidden = false
        if let editableNameTemp = nameTextField.text{
            name.text = editableNameTemp
            editableName = editableNameTemp
        }
        return true
    }
    
    func saveTapped() {
        //saving the user's profile picture
        let pickedImage = profilePictureButton.currentImage
        saveButton.layer.borderColor = necterYellow.CGColor
        
        var somethingWasUpdated = false
        var interestsUpdated = false
        
        //saving to parse
        if let _ = PFUser.currentUser() {
            //saving the user's name
            if nameTextField.text != username {
                PFUser.currentUser()?["name"] = editableName
                somethingWasUpdated = true
            }
            
            //saving the user's profile picture
            if originalProfilePicture != pickedImage {
                if let imageData = UIImageJPEGRepresentation(pickedImage!, 1.0){
                    //update the user's profile picture in Database
                    if let _ = PFUser.currentUser() {
                        let file = PFFile(data:imageData)
                        PFUser.currentUser()!["profile_picture"] = file
                        somethingWasUpdated = true
                    }
                    
                }
                
            }
            
            //saving the users interests
            print("interestedInBusiness - \(interestedInBusiness)")
            print("businessSwitch.on - \(businessSwitch.on)")
            if interestedInBusiness != businessSwitch.on {
                PFUser.currentUser()?["interested_in_business"] = businessSwitch.on
                interestsUpdated = true
            }
            if interestedInLove != loveSwitch.on {
                PFUser.currentUser()?["interested_in_love"] = loveSwitch.on
                interestsUpdated = true
            }
            if interestedInFriendship != friendshipSwitch.on {
                PFUser.currentUser()?["interested_in_friendship"] = friendshipSwitch.on
                interestsUpdated = true
            }
            
            print("somethingWasUpdated - \(somethingWasUpdated)")
            print("interestsUpdated - \(interestsUpdated)")
            if somethingWasUpdated || interestsUpdated {
                PFUser.currentUser()?.saveInBackgroundWithBlock({ (success, error) in
                    if success {
                        
                        if interestsUpdated {
                            PFCloud.callFunctionInBackground("changeBridgePairingsOnInterestedInUpdate", withParameters: [:]) {
                                (response:AnyObject?, error: NSError?) -> Void in
                                if error == nil {
                                    if let response = response as? String {
                                        print(response)
                                    }
                                }
                            }
                        }
                    }
                })
            }
            
        }
        
        //saving to local data on the user's device
        //saving the user's name
        if nameTextField.text != username {
            localData.setUsername(editableName)
        }
        
        //saving the user's profile picture
        if originalProfilePicture != pickedImage {
            if let imageData = UIImageJPEGRepresentation(pickedImage!, 1.0){
                localData.setMainProfilePicture(imageData)
                
            }
            
        }
        
        localData.synchronize()
        performSegueWithIdentifier("showProfilePageFromEditProfileView", sender: self)
    }
    
    // Switches tapped
    func businessSwitchTapped(sender: UISwitch) {
        if businessSwitch.on{
            businessLabel.textColor = businessBlue
            businessIcon.image = UIImage(named: "Business_Icon_Blue")
        }
        else{
            businessLabel.textColor = UIColor.grayColor()
            businessIcon.image = UIImage(named: "Business_Icon_Gray")
        }
    }
    func loveSwitchTapped(sender: UISwitch) {
        if loveSwitch.on{
            loveLabel.textColor = loveRed
            loveIcon.image = UIImage(named: "Love_Icon_Red")
        }
        else{
            
            loveLabel.textColor = UIColor.grayColor()
            loveIcon.image = UIImage(named: "Love_Icon_Gray")
        }
    }
    func friendshipSwitchTapped(sender: UISwitch) {
        if friendshipSwitch.on{
            friendshipLabel.textColor = friendshipGreen
            friendshipIcon.image = UIImage(named: "Friendship_Icon_Green")
        }
        else{
            friendshipLabel.textColor = UIColor.grayColor()
            friendshipIcon.image = UIImage(named: "Friendship_Icon_Gray")
        }
    }

    
    func displayInterests() {
        //adding the interested label to provide instructions for the user
        interestedLabel.frame = CGRect(x:0.05*screenWidth , y:0.45*screenHeight, width:0.9*screenWidth, height:0.08*screenHeight)
        interestedLabel.text = "I am interested in being connected for:"
        interestedLabel.font = UIFont(name: "BentonSans", size: 18)
        interestedLabel.numberOfLines = 2
        view.addSubview(interestedLabel)
        
        
        
        //settings the frames for the interested icons, labels, and switches
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
        
        //setting the texts of the labels
        businessLabel.text = "Business"
        loveLabel.text = "Love"
        friendshipLabel.text = "Friendship"
        
        //adding Targets for actions to take place when the switches are clicked
        businessSwitch.addTarget(self, action: #selector(businessSwitchTapped(_:)), forControlEvents: .TouchUpInside)
        loveSwitch.addTarget(self, action: #selector(loveSwitchTapped(_:)), forControlEvents: .TouchUpInside)
        friendshipSwitch.addTarget(self, action: #selector(friendshipSwitchTapped(_:)), forControlEvents: .TouchUpInside)
        
        //setting the switches to bool values based on parse and then setting the UI of the corresponding labels, and Icons accoridingly
        //Setting whether the user is interested in business
        if let businessInterest = PFUser.currentUser()?["interested_in_business"] as? Bool {
            businessSwitch.on = businessInterest
            interestedInBusiness = businessInterest
        }
        else {
            businessSwitch.on = true
        }
        businessSwitch.onTintColor = businessBlue
        if businessSwitch.on {
            businessLabel.textColor = businessBlue
            businessIcon.image = UIImage(named: "Business_Icon_Blue")
        } else {
            businessLabel.textColor = UIColor.grayColor()
            businessIcon.image = UIImage(named: "Business_Icon_Gray")
        }
        //Setting whether the user is interested in love
        if let loveInterest = PFUser.currentUser()?["interested_in_love"] as? Bool {
            loveSwitch.on = loveInterest
            interestedInLove = loveInterest
        }
        else {
            loveSwitch.on = true
        }
        loveSwitch.onTintColor = loveRed
        if loveSwitch.on{
            loveLabel.textColor = loveRed
            loveIcon.image = UIImage(named: "Love_Icon_Red")
        }
        else{
            loveLabel.textColor = UIColor.grayColor()
            loveIcon.image = UIImage(named: "Love_Icon_Gray")
        }
        //Setting whether the user is interested in friendship
        if let friendshipInterest = PFUser.currentUser()?["interested_in_friendship"] as? Bool {
            friendshipSwitch.on = friendshipInterest
            interestedInFriendship = friendshipInterest
        }
        else {
            friendshipSwitch.on = true
        }
        friendshipSwitch.onTintColor = friendshipGreen
        if friendshipSwitch.on{
            friendshipLabel.textColor = friendshipGreen
            friendshipIcon.image = UIImage(named: "Friendship_Icon_Green")
        }
        else{
            friendshipLabel.textColor = UIColor.grayColor()
            friendshipIcon.image = UIImage(named: "Friendship_Icon_Gray")
        }
        
        view.addSubview(businessIcon)
        view.addSubview(businessLabel)
        view.addSubview(businessSwitch)
        view.addSubview(loveIcon)
        view.addSubview(loveLabel)
        view.addSubview(loveSwitch)
        view.addSubview(friendshipIcon)
        view.addSubview(friendshipLabel)
        view.addSubview(friendshipSwitch)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        nameTextField.delegate = self
        
        displayNavigationBar()
        displayProfilePictureButton()
        displayName()
        displayInterests()
        
        //adding the save button
        saveButton.frame = CGRect(x: 0, y:0.9*screenHeight, width:0.3*screenWidth, height:0.06*screenHeight)
        saveButton.center.x = view.center.x
        saveButton.layer.borderWidth = 4.0
        saveButton.layer.borderColor = necterGray.CGColor
        saveButton.layer.cornerRadius = 7.0
        saveButton.setTitle("Save", forState: .Normal)
        saveButton.setTitleColor(necterGray, forState: .Normal)
        saveButton.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
        saveButton.titleLabel!.font = UIFont(name: "BentonSans", size: 20)
        saveButton.addTarget(self, action: #selector(saveTapped), forControlEvents: .TouchUpInside)
        view.addSubview(saveButton)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = necterYellow.CGColor
        border.frame = CGRect(x: 0, y: nameTextField.frame.size.height - width, width:  nameTextField.frame.size.width, height: nameTextField.frame.size.height)
        
        border.borderWidth = width
        nameTextField.layer.addSublayer(border)
        nameTextField.layer.masksToBounds = true
        
        
        let nameBorder = CALayer()
        nameBorder.borderColor = UIColor.blackColor().CGColor
        nameBorder.frame = CGRect(x: 0, y: name.frame.size.height - width, width:  name.frame.size.width, height: name.frame.size.height)

        name.layer.addSublayer(nameBorder)
        name.layer.masksToBounds = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //let singleMessageVC:SingleMessageViewController = segue.destinationViewController as! SingleMessageViewController
        let vc = segue.destinationViewController
        let mirror = Mirror(reflecting: vc)
        if mirror.subjectType == ProfileViewController.self {
            self.transitionManager.animationDirection = "Right"
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
