//
//  SignupViewController.swift
//  MyBridgeApp
//
//  Created by Sagar Sinha on 6/16/16.
//  Copyright © 2016 BHE Ventures LLC. All rights reserved.
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
    let profilePictureButton = UIButton()
    let profilePictureView = UIImageView()
    //@IBOutlet weak var editImageButton: UIButton!
    //@IBOutlet weak var friendshipLabel: UILabel!
    let friendshipLabel = UILabel()
    let loveLabel = UILabel()
    let businessLabel = UILabel()
    let businessSwitch = UISwitch()
    let friendshipSwitch = UISwitch()
    let loveSwitch = UISwitch()
    let interestedLabel = UILabel()
    let beginConnectingButton = UIButton()
    let updateLaterLabel = UILabel()
    let businessIcon = UIImageView()
    let loveIcon = UIImageView()
    let friendshipIcon = UIImageView()
    
   
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let necterYellow = UIColor(red: 255/255, green: 230/255, blue: 57/255, alpha: 1.0)
    let businessBlue = UIColor(red: 36.0/255, green: 123.0/255, blue: 160.0/255, alpha: 1.0)
    let loveRed = UIColor(red: 242.0/255, green: 95.0/255, blue: 92.0/255, alpha: 1.0)
    let friendshipGreen = UIColor(red: 112.0/255, green: 193.0/255, blue: 179.0/255, alpha: 1.0)
    let necterGray = UIColor(red: 80.0/255.0, green: 81.0/255.0, blue: 79.0/255.0, alpha: 1.0)

    
    // globally required as we do not want to re-create them everytime and for persistence
    let transitionManager = TransitionManager()
    let imagePicker = UIImagePickerController()
    var editableName:String = ""
    let noNameText = "Click to enter your full name"

    func profilePictureTouchDown(_ sender: AnyObject) {
        profilePictureButton.layer.borderColor = necterYellow.cgColor
    }
    func profilePictureTouchDragExit(_ sender: AnyObject) {
        profilePictureButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    func profilePictureTapped(_ sender: AnyObject) {
        profilePictureButton.layer.borderColor = necterYellow.cgColor
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
            self.profilePictureButton.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        // Add the actions
        //self.picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
        imagePicker.allowsEditing = false

    }
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            let alert = UIAlertView()
            alert.title = "Warning"
            alert.message = "You don't have camera"
            alert.addButton(withTitle: "OK")
            alert.show()
        }
    }
    func openGallary(){
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //update the UIImageView once an image has been picked
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let fixedPickedImage = fixOrientation(pickedImage)
            profilePictureView.image = fixedPickedImage
            //profilePictureButton.setBackgroundImage(fixedPickedImage, forState: .Normal)
        }
        profilePictureButton.layer.borderColor = UIColor.lightGray.cgColor
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        profilePictureButton.layer.borderColor = UIColor.lightGray.cgColor
        dismiss(animated: true, completion: nil)
    }
    
    //fix the orientation of the image picked by the ImagePickerController
    func fixOrientation(_ img:UIImage) -> UIImage {
        
        if (img.imageOrientation == UIImageOrientation.up) {
            return img;
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale);
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return normalizedImage;
        
    }
/*

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
    }*/
    //stopping user from entering name with length greater than 25
    @IBAction func nameTextFieldChanges(_ sender: AnyObject) {
        if let characterCount = nameTextField.text?.characters.count {
            if characterCount > 25 {
                let aboveMaxBy = characterCount - 25
                let index1 = nameTextField.text!.characters.index(nameTextField.text!.endIndex, offsetBy: -aboveMaxBy)
                nameTextField.text = nameTextField.text!.substring(to: index1)
            }
        }
    }
    
    //Begin Connecting Button Clicked
    func beginConnectingTapped(_ send: UIButton) {
        beginConnectingButton.layer.borderColor = necterYellow.cgColor
        
        if let _ = PFUser.current() {
            PFUser.current()?["name"] = editableName
            PFUser.current()?["interested_in_business"] = businessSwitch.isOn
            PFUser.current()?["interested_in_love"] = loveSwitch.isOn
            PFUser.current()?["interested_in_friendship"] = friendshipSwitch.isOn
            PFUser.current()?.saveInBackground(block: { (success, error) in
                if success {
                    
                    //This was used up until 12/6/2016 to add the currentUser to the BridgePairings table, but wasn't working
                    //let localStorageUtility = LocalStorageUtility()
                    //localStorageUtility.updateBridgePairingsTable()
                    
                    //Adds the current User to the bridgePairings table with the people they have potential to match with
                    let pfCloudFunctions = PFCloudFunctions()
                    pfCloudFunctions.changeBridgePairingsOnInterestedInUpdate(parameters: [:])
                }
            })
        }
        let pickedImage = profilePictureView.image
        
        let localData = LocalData()
        if let imageData = UIImageJPEGRepresentation(pickedImage!, 1.0){
            localData.setMainProfilePicture(imageData)
        }
        localData.setUsername(editableName)
        localData.setHasSignedUp(true)
        localData.synchronize()
        
        performSegue(withIdentifier: "showBridgePageFromSignUpView", sender: self)
    }
    // Switches tapped
    @IBAction func businessSwitchTapped(_ sender: AnyObject) {
        if businessSwitch.isOn{
            businessLabel.textColor = businessBlue
            businessIcon.image = UIImage(named: "Selected_Business_Icon")
        }
        else{
            businessLabel.textColor = UIColor.gray
            businessIcon.image = UIImage(named: "Selected_Business_Icon")
        }
    }
    @IBAction func loveSwitchTapped(_ sender: AnyObject) {
        if loveSwitch.isOn{
            loveLabel.textColor = loveRed
            loveIcon.image = UIImage(named: "Selected_Love_Icon")
        }
        else{
          
            loveLabel.textColor = UIColor.gray
            loveIcon.image = UIImage(named: "Selected_Love_Icon")
        }
    }
    @IBAction func friendshipSwitchTapped(_ sender: AnyObject) {
        if friendshipSwitch.isOn{
            friendshipLabel.textColor = friendshipGreen
            friendshipIcon.image = UIImage(named: "Selected_Friendship_Icon")
        }
        else{
            friendshipLabel.textColor = UIColor.gray
            friendshipIcon.image = UIImage(named: "Selected_Friendship_Icon")
        }
    }

    //get and display the profile picture view and associated button for editing the profile picture
    func displayProfilePictureButton() {
        let mainProfilePicture = LocalData().getMainProfilePicture()
        if let mainProfilePicture = mainProfilePicture {
            let image = UIImage(data:mainProfilePicture as Data,scale:1.0)
            profilePictureView.image = image
        } else {
            let pfData = PFUser.current()?["profile_picture"] as? PFFile
            if let pfData = pfData {
                pfData.getDataInBackground(block: { (data, error) in
                    if error != nil || data == nil {
                        print(error ?? "Threre is an error in SignUpViewController.displayProfilePictureButton()")
                    } else {
                        let image = UIImage(data: data!, scale: 1.0)
                        DispatchQueue.main.async(execute: {
                            self.profilePictureView.image = image
                        })
                    }
                })
            }
            
        }
        
        profilePictureButton.addTarget(self, action: #selector(profilePictureTouchDown(_:)), for: .touchDown)
        profilePictureButton.addTarget(self, action: #selector(profilePictureTouchDragExit(_:)), for: .touchDragExit)
        profilePictureButton.addTarget(self, action: #selector(profilePictureTapped(_:)), for: .touchUpInside)
        profilePictureButton.layer.borderWidth = 4
        profilePictureButton.layer.borderColor = UIColor.lightGray.cgColor
        profilePictureButton.contentMode = UIViewContentMode.scaleAspectFill
        profilePictureButton.backgroundColor = UIColor.clear
        
        profilePictureView.contentMode = UIViewContentMode.scaleAspectFill
        
        self.view.addSubview(profilePictureView)
        self.view.addSubview(profilePictureButton)
    }

    func displayInterests() {
        
        businessLabel.text = "Work"
        loveLabel.text = "Dating"
        friendshipLabel.text = "Friendship"
        interestedLabel.text = "I am interested in being connected for:"
        
        businessLabel.font = UIFont(name: "BentonSans", size: 18)
        loveLabel.font = UIFont(name: "BentonSans", size: 18)
        friendshipLabel.font = UIFont(name: "BentonSans", size: 18)
        interestedLabel.font = UIFont(name: "BentonSans", size: 18)
        
        businessSwitch.onTintColor = businessBlue
        loveSwitch.onTintColor = loveRed
        friendshipSwitch.onTintColor = friendshipGreen
        
        if let businessInterest = PFUser.current()?["interested_in_business"] {
            businessSwitch.isOn = businessInterest as! Bool
        } else {
            businessSwitch.isOn = true
        }
        
        if let loveInterest = PFUser.current()?["interested_in_love"] {
            loveSwitch.isOn = loveInterest as! Bool
        } else {
            loveSwitch.isOn = true
        }
        
        if let friendshipInterest = PFUser.current()?["interested_in_friendship"] {
            friendshipSwitch.isOn = friendshipInterest as! Bool
        } else {
            friendshipSwitch.isOn = true
        }
        
        self.view.addSubview(friendshipLabel)
        self.view.addSubview(loveLabel)
        self.view.addSubview(businessLabel)
        self.view.addSubview(businessSwitch)
        self.view.addSubview(friendshipSwitch)
        self.view.addSubview(loveSwitch)
        self.view.addSubview(interestedLabel)
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
                let index1 = usernameString.characters.index(usernameString.endIndex, offsetBy: -aboveMaxBy)
                usernameString = usernameString.substring(to: index1)
                /*let localData = LocalData()
                localData.setUsername(usernameString)
                localData.synchronize()*/
            }
            if usernameString != "" {
                editableName = usernameString
                nameTextField.text = usernameString
                mainTitle.attributedText = twoColoredString(editableName+"'s Interests", partLength: 12, start: 12, color: UIColor.black)
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
        nameTextField.isHidden = true
        mainTitle.isUserInteractionEnabled = true
        
        
        let aSelector : Selector = #selector(SignupViewController.lblTapped)
        let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
        tapGesture.numberOfTapsRequired = 1
        mainTitle.addGestureRecognizer(tapGesture)
        
        let outSelector : Selector = #selector(SignupViewController.tappedOutside)
        let outsideTapGesture = UITapGestureRecognizer(target: self, action: outSelector)
        outsideTapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(outsideTapGesture)
        
        displayProfilePictureButton()
    
        if mainTitle.text == noNameText {
            beginConnectingButton.layer.borderColor = UIColor.lightGray.cgColor
            beginConnectingButton.setTitleColor(UIColor.gray, for: UIControlState())
            beginConnectingButton.isEnabled = false
        }
        
        beginConnectingButton.setTitle("Begin Connecting", for: UIControlState())
        beginConnectingButton.titleLabel!.font = UIFont(name: "BentonSans", size: 20)
        beginConnectingButton.layer.cornerRadius = 7.0
        beginConnectingButton.layer.borderWidth = 4.0
        beginConnectingButton.clipsToBounds = true
        beginConnectingButton.setTitleColor(UIColor.black, for: UIControlState())
        beginConnectingButton.addTarget(self, action: #selector(beginConnectingTapped(_:)), for: .touchUpInside)
        if editableName == "" || editableName == noNameText {
            beginConnectingButton.layer.borderColor = UIColor.lightGray.cgColor
            beginConnectingButton.isEnabled = false
        } else {
            beginConnectingButton.layer.borderColor = necterYellow.cgColor
            beginConnectingButton.setTitleColor(necterYellow, for: .highlighted)
        }
        
        //label below beginConnecting Button
        updateLaterLabel.textAlignment = NSTextAlignment.center
        updateLaterLabel.text = "You can always update your interests later"
        updateLaterLabel.font = UIFont(name: "BentonSans", size: 12)
        updateLaterLabel.textColor = UIColor.black
        updateLaterLabel.numberOfLines = 0
        
        //setting the title to the view
        mainTitle.textAlignment = NSTextAlignment.center
        mainTitle.font = UIFont(name: "Verdana", size: 22)
        mainTitle.numberOfLines = 2
        //mainTitle.textColor = UIColor.lightGrayColor()
        mainTitle.textColor = UIColor.lightGray
        mainTitle.attributedText = twoColoredString(mainTitle.text!, partLength: 12, start: 12, color: UIColor.black)
        
        displayInterests()
        self.view.addSubview(mainTitle)
        self.view.addSubview(beginConnectingButton)
        self.view.addSubview(updateLaterLabel)
        
    }
    
    override func viewDidLayoutSubviews() {
        
        let modelName = UIDevice.current.modelName
        
        
        //setting up elements
        businessLabel.textColor = businessBlue
        loveLabel.textColor = loveRed
        friendshipLabel.textColor = friendshipGreen
        businessIcon.image = UIImage(named: "Selected_Business_Icon")
        loveIcon.image = UIImage(named: "Selected_Love_Icon")
        friendshipIcon.image = UIImage(named: "Selected_Friendship_Icon")
        
        
        
        
        //placing elements
        if ["iPhone 4", "iPhone 4s", "iPhone 5", "iPhone 5", "iPhone 5c", "iPhone 5s", "Simulator"].contains(modelName) {
        //placing elements on smaller sized iPhones
            mainTitle.frame = CGRect(x:0.05*screenWidth , y:0.05*screenHeight, width:0.9*screenWidth, height:0.15*screenHeight)
            nameTextField.frame = CGRect(x:0.05*screenWidth , y:0.05*screenHeight, width:0.9*screenWidth, height:0.08*screenHeight)
            profilePictureButton.frame = CGRect(x: 0, y:0.19*screenHeight, width:0.23*screenHeight, height:0.23*screenHeight)
            profilePictureButton.center.x = self.view.center.x
            profilePictureButton.layer.cornerRadius = profilePictureButton.frame.size.width/2
            profilePictureButton.clipsToBounds = true
            profilePictureView.frame = CGRect(x: 0, y:0.19*screenHeight, width:0.23*screenHeight, height:0.23*screenHeight)
            profilePictureView.center.x = self.view.center.x
            profilePictureView.layer.cornerRadius = profilePictureView.frame.size.width/2
            profilePictureView.clipsToBounds = true
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
            updateLaterLabel.frame = CGRect(x: 0.05*screenWidth, y: 0.925*screenHeight, width: 0.9*screenWidth, height: 0.05*screenHeight)
            
        } else {
        //placing elements on larger iPhones
            mainTitle.frame = CGRect(x:0.05*screenWidth , y:0.05*screenHeight, width:0.9*screenWidth, height:0.1*screenHeight)
            nameTextField.frame = CGRect(x:0.05*screenWidth , y:0.05*screenHeight, width:0.9*screenWidth, height:0.08*screenHeight)
            profilePictureButton.frame = CGRect(x: 0, y:0.17*screenHeight, width:0.25*screenHeight, height:0.25*screenHeight)
            profilePictureButton.center.x = self.view.center.x
            profilePictureButton.layer.cornerRadius = profilePictureButton.frame.size.width/2
            profilePictureButton.clipsToBounds = true
            profilePictureView.frame = CGRect(x: 0, y:0.17*screenHeight, width:0.25*screenHeight, height:0.25*screenHeight)
            profilePictureView.center.x = self.view.center.x
            profilePictureView.layer.cornerRadius = profilePictureView.frame.size.width/2
            profilePictureView.clipsToBounds = true
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
            updateLaterLabel.frame = CGRect(x: 0.05*screenWidth, y: 0.925*screenHeight, width: 0.9*screenWidth, height: 0.05*screenHeight)
            
        }
        
        view.addSubview(businessIcon)
        view.addSubview(loveIcon)
        view.addSubview(friendshipIcon)
        
        
        
    }
    
    // Utility functions
    // generate a 2-colored string. Used for the title
    func twoColoredString(_ full:String,partLength: Int, start: Int, color: UIColor)->NSMutableAttributedString{
        let mutableString = NSMutableAttributedString(string: full)
        mutableString.addAttribute(NSForegroundColorAttributeName, value: color, range: NSRange(location:full.characters.count-start, length:partLength))
        return mutableString
        
    }
    
    
    // Username label is tapped. Textfield should appear and replace the label
    func lblTapped(){
        nameTextField.becomeFirstResponder()
        nameTextField.textColor = necterYellow
        mainTitle.isHidden = true
        nameTextField.isHidden = false
        if editableName != noNameText {
            nameTextField.text = editableName
        }
        beginConnectingButton.layer.borderColor = UIColor.lightGray.cgColor
        beginConnectingButton.isEnabled = false
    }
    // Tapped anywhere else on the main view. Textfield should be replaced by label
    func tappedOutside(){
        if mainTitle.text == self.noNameText {
            mainTitle.isHidden = true
            nameTextField.isHidden = false
            nameTextField.becomeFirstResponder()
            nameTextField.attributedPlaceholder = NSAttributedString(string:"Enter your full name", attributes: [NSForegroundColorAttributeName: necterYellow])
        } else {
            beginConnectingButton.layer.borderColor = necterYellow.cgColor
            beginConnectingButton.setTitleColor(UIColor.black, for: UIControlState())
            beginConnectingButton.isEnabled = true
            beginConnectingButton.setTitleColor(necterYellow, for: .highlighted)
            mainTitle.isHidden = false
            nameTextField.isHidden = true
            self.view.endEditing(true)
        }
        
        if let editableNameTemp = nameTextField.text{
            if editableNameTemp != "" {
                editableName = editableNameTemp
                mainTitle.attributedText = twoColoredString(editableNameTemp+"'s Interests", partLength: 12, start: 12, color: UIColor.black)
            }
        }
        if editableName != "" {
            beginConnectingButton.layer.borderColor = necterYellow.cgColor
            beginConnectingButton.isEnabled = true
        }
    }
    // User returns after editing
    func textFieldShouldReturn(_ userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        nameTextField.isHidden = true
        mainTitle.isHidden = false
        if let editableNameTemp = nameTextField.text{
            mainTitle.attributedText = twoColoredString(editableNameTemp+"'s Interests", partLength: 12, start: 12, color: UIColor.black)
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

     override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NotificationCenter.default.removeObserver(self)
        let vc = segue.destination
            let mirror = Mirror(reflecting: vc)
            if mirror.subjectType == BridgeViewController.self {
                self.transitionManager.animationDirection = "Bottom"
            }
            vc.transitioningDelegate = self.transitionManager
        }
    
}
