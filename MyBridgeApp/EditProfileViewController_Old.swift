//
//  EditProfileViewController.swift
//  MyBridgeApp
//
//  Created by Blake H. Engelhard on 8/26/16.
//  Copyright © 2016 BHE Ventures LLC. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit

class EditProfileViewController_Old: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //creating the elements on the View
    let rightBarButton = UIButton()
    let profilePictureButton = UIButton()
    let profilePictureView = UIImageView()
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
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let transitionManager = TransitionManager()
    let localData = LocalData()
    var seguedFrom = ""
    var tempSeguedFrom = ""
    
    //necter Colors
    let necterYellow = UIColor(red: 255/255, green: 230/255, blue: 57/255, alpha: 1.0)
    let businessBlue = UIColor(red: 36.0/255, green: 123.0/255, blue: 160.0/255, alpha: 1.0)
    let loveRed = UIColor(red: 242.0/255, green: 95.0/255, blue: 92.0/255, alpha: 1.0)
    let friendshipGreen = UIColor(red: 112.0/255, green: 193.0/255, blue: 179.0/255, alpha: 1.0)
    let necterGray = UIColor(red: 80.0/255.0, green: 81.0/255.0, blue: 79.0/255.0, alpha: 1.0)

    
    // globally required as we do not want to re-create them everytime and for persistence
    let imagePicker = UIImagePickerController()
    
    func profilePictureTouchDown(_ sender: AnyObject) {
        profilePictureButton.layer.borderColor = necterYellow.cgColor
    }
    func profilePictureTouchDragExit(_ sender: AnyObject) {
        profilePictureButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    func profilePictureTapped(_ sender: UIButton) {
        profilePictureButton.layer.borderColor = necterYellow.cgColor
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let facebookProfilePictureAction = UIAlertAction(title: "Facebook Profile Picture", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.getMainProfilePictureFromFacebook()
        }
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
        alert.addAction(facebookProfilePictureAction)
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
        imagePicker.allowsEditing = false
        
    }
    //saves  to LocalDataStorage & Parse
    func getMainProfilePictureFromFacebook(){
        var pagingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        pagingSpinner.color = UIColor.darkGray
        pagingSpinner.hidesWhenStopped = true
        pagingSpinner.center.x = profilePictureButton.center.x
        pagingSpinner.center.y = profilePictureButton.center.y
        view.addSubview(pagingSpinner)
        pagingSpinner.startAnimating()
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name"])
        graphRequest?.start{ (connection, result, error) -> Void in
            if error != nil {
                print(error)
            }
            else if let result = result as? [String: AnyObject]{
                let userId = result["id"]! as! String
                let facebookProfilePictureUrl = "https://graph.facebook.com/" + userId + "/picture?type=large"
                if let fbpicUrl = URL(string: facebookProfilePictureUrl) {
                    if let data = try? Data(contentsOf: fbpicUrl) {
                        DispatchQueue.main.async(execute: {
                            self.profilePictureView.image = UIImage(data: data)
                            //self.profilePictureButton.setBackgroundImage(UIImage(data: data), forState: .Normal)
                            pagingSpinner.stopAnimating()
                            pagingSpinner.removeFromSuperview()
                        })
                    }
                }
            }
        }
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
    
    func rightBarButtonTapped (_ sender: UIBarButtonItem){
//        if tempSeguedFrom == "OptionsFromBotViewController" {
//            performSegue(withIdentifier: "showOptionsViewFromEditProfileView", sender: self)
//        } else {
//            performSegue(withIdentifier: "showProfilePageFromEditProfileView", sender: self)
//        }
        performSegue(withIdentifier: "showMyProfileFromEditProfile", sender: self)
        rightBarButton.isSelected = true
    }
    func displayNavigationBar(){
        let customNavigationBar = CustomNavigationBar()
        rightBarButton.addTarget(self, action: #selector(rightBarButtonTapped(_:)), for: .touchUpInside)
        customNavigationBar.createCustomNavigationBar(view: view, leftBarButtonIcon: nil, leftBarButtonSelectedIcon: nil, leftBarButton: nil, rightBarButtonIcon: "Right_Arrow", rightBarButtonSelectedIcon: "Right_Arrow", rightBarButton: rightBarButton, title: "Edit Profile")
    }
    
    func displayProfilePictureButton() {
        //get profile picture and set to a button
        let mainProfilePicture = localData.getMainProfilePicture()
        if let mainProfilePicture = mainProfilePicture {
            let image = UIImage(data: mainProfilePicture as Data, scale: 1.0)
            originalProfilePicture = image!
            profilePictureView.image = image
            //profilePictureButton.setBackgroundImage(image, forState: .Normal)
        }  else {
            let pfData = PFUser.current()?["profile_picture"] as? PFFile
            if let pfData = pfData {
                pfData.getDataInBackground(block: { (data, error) in
                    if error != nil || data == nil {
                        print(error)
                    } else {
                        let image = UIImage(data: data!, scale: 1.0)
                        self.originalProfilePicture = image!
                        DispatchQueue.main.async(execute: {
                            self.profilePictureView.image = image
                            //self.profilePictureButton.setBackgroundImage(image, forState:  .Normal)
                        })
                    }
                })
            }
            
        }
        
        profilePictureButton.addTarget(self, action: #selector(profilePictureTouchDown(_:)), for: .touchDown)
        profilePictureButton.addTarget(self, action: #selector(profilePictureTouchDragExit(_:)), for: .touchDragExit)
        profilePictureButton.addTarget(self, action: #selector(profilePictureTapped(_:)), for: .touchUpInside)
        
        profilePictureButton.frame = CGRect(x: 0, y:0.12*screenHeight, width:0.25*screenHeight, height:0.25*screenHeight)
        profilePictureButton.center.x = self.view.center.x
        profilePictureButton.layer.cornerRadius = profilePictureButton.frame.size.width/2
        profilePictureButton.layer.borderWidth = 4
        profilePictureButton.layer.borderColor = UIColor.lightGray.cgColor
        profilePictureButton.contentMode = UIViewContentMode.scaleAspectFill
        profilePictureButton.clipsToBounds = true
        profilePictureButton.backgroundColor = UIColor.clear
        
        profilePictureView.frame = profilePictureButton.frame
        profilePictureView.center.x = self.view.center.x
        profilePictureView.layer.cornerRadius = profilePictureView.frame.size.width/2
        profilePictureView.contentMode = UIViewContentMode.scaleAspectFill
        profilePictureView.clipsToBounds = true
        
        view.addSubview(profilePictureView)
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
        
        nameTextField.isHidden = true
        name.isUserInteractionEnabled = true
        
        if let username = username {
            name.text = username
        }
        name.textColor = UIColor.lightGray
        
        let aSelector : Selector = #selector(EditProfileViewController.lblTapped)
        let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
        tapGesture.numberOfTapsRequired = 1
        name.addGestureRecognizer(tapGesture)
        
        name.font = UIFont(name: "Verdana", size: 18)
        name.textAlignment = NSTextAlignment.center
        name.frame = CGRect(x: 0.1*screenWidth, y:0.38*screenHeight, width:0.8*screenWidth, height:0.05*screenHeight)
        
        nameTextField.font = UIFont(name: "Verdana", size: 18)
        nameTextField.textAlignment = NSTextAlignment.center
        nameTextField.frame = CGRect(x: 0.1*screenWidth, y:0.38*screenHeight, width:0.8*screenWidth, height:0.05*screenHeight)
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        view.addSubview(name)
        view.addSubview(nameTextField)
    }
    
    //stopping user from entering name with length greater than 25
    func textFieldDidChange(_ sender: UITextField) {
        if let characterCount = nameTextField.text?.characters.count {
            if characterCount > 25 {
                let aboveMaxBy = characterCount - 25
                let index1 = nameTextField.text!.characters.index(nameTextField.text!.endIndex, offsetBy: -aboveMaxBy)
                nameTextField.text = nameTextField.text!.substring(to: index1)
            }
        }
    }
    
    // Username label is tapped. Textfield should appear and replace the label
    func lblTapped(){
        nameTextField.becomeFirstResponder()
        name.isHidden = true
        nameTextField.isHidden = false
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
        if nameTextField.isFirstResponder {
            nameTextField.endEditing(true)
            name.isHidden = false
            nameTextField.isHidden = true
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
    func textFieldShouldReturn(_ userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        nameTextField.isHidden = true
        name.isHidden = false
        if let editableNameTemp = nameTextField.text{
            name.text = editableNameTemp
            editableName = editableNameTemp
        }
        return true
    }
    
    func saveTapped() {
        
        //setting saveButton to selected for title coloring in UI
        saveButton.isSelected = true
        
        let pickedImage = profilePictureView.image
        saveButton.layer.borderColor = necterYellow.cgColor
        
        var somethingWasUpdated = false
        var interestsUpdated = false
        
        if nameTextField.text == "" {
            nameTextField.text = username
        }
        
        //saving to parse
        if let _ = PFUser.current() {
            //saving the user's name
            if nameTextField.text != username {
                print("new name save")
                PFUser.current()?["name"] = nameTextField.text
                somethingWasUpdated = true
            }
            
            //saving the user's profile picture
            if originalProfilePicture != pickedImage {
                
                if let imageData = UIImageJPEGRepresentation(pickedImage!, 1.0){
                    //update the user's profile picture in Database
                    if let _ = PFUser.current() {
                        let file = PFFile(data:imageData)
                        PFUser.current()!["profile_picture"] = file
                        somethingWasUpdated = true
                    }
                }
            }
            
            //saving the users interests
            if interestedInBusiness != businessSwitch.isOn {
                PFUser.current()?["interested_in_business"] = businessSwitch.isOn
                interestsUpdated = true
            }
            if interestedInLove != loveSwitch.isOn {
                PFUser.current()?["interested_in_love"] = loveSwitch.isOn
                interestsUpdated = true
            }
            if interestedInFriendship != friendshipSwitch.isOn {
                PFUser.current()?["interested_in_friendship"] = friendshipSwitch.isOn
                interestsUpdated = true
            }
            
            if somethingWasUpdated || interestsUpdated {
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    if success {
                        let pfCloudFunctions = PFCloudFunctions()
                        //updating profile picture in bridgePairings Table if the picture was changed
                        if self.originalProfilePicture != pickedImage {
                            pfCloudFunctions.changeBridgePairingsOnProfilePictureUpdate(parameters: [:])
                        }
                        
                        //updating name in BridgePairings, Messages, and SingleMessages tables if the name was changed
                        if self.nameTextField.text != self.username {
                            pfCloudFunctions.changeMessagesTableOnNameUpdate(parameters: [:])
                            pfCloudFunctions.changeSingleMessagesTableOnNameUpdate(parameters: [:])
                            pfCloudFunctions.changeBridgePairingsOnNameUpdate(parameters: [:])
                        }
                        
                        //updated interests in bridgepairings table if the interests were changed
                        if interestsUpdated {
                            print("interestsUpdated")
                            pfCloudFunctions.changeBridgePairingsOnInterestedInUpdate(parameters: [:])
                        }
                    }
                })
            }
            
        }
        
        //saving to local data on the user's device
        //saving the user's name
        if nameTextField.text != username {
            localData.setUsername(nameTextField.text!)
        }
        
        //saving the user's profile picture
        if originalProfilePicture != pickedImage {
            if let imageData = UIImageJPEGRepresentation(pickedImage!, 1.0){
                localData.setMainProfilePicture(imageData)
            }
            
        }
        
        localData.synchronize()
//        if tempSeguedFrom == "OptionsFromBotViewController" {
//            performSegue(withIdentifier: "showOptionsViewFromEditProfileView", sender: self)
//        } else {
//            performSegue(withIdentifier: "showProfilePageFromEditProfileView", sender: self)
//        }
        performSegue(withIdentifier: "showMyProfileFromEditProfile", sender: self)
    }
    
    // Switches tapped
    func businessSwitchTapped(_ sender: UISwitch) {
        if businessSwitch.isOn{
            businessLabel.textColor = businessBlue
            businessIcon.image = UIImage(named: "Selected_Business_Icon")
        }
        else{
            businessLabel.textColor = UIColor.gray
            businessIcon.image = UIImage(named: "Selected_Business_Icon")
        }
    }
    func loveSwitchTapped(_ sender: UISwitch) {
        if loveSwitch.isOn{
            loveLabel.textColor = loveRed
            loveIcon.image = UIImage(named: "Selected_Love_Icon")
        }
        else{
            
            loveLabel.textColor = UIColor.gray
            loveIcon.image = UIImage(named: "Selected_Love_Icon")
        }
    }
    func friendshipSwitchTapped(_ sender: UISwitch) {
        if friendshipSwitch.isOn{
            friendshipLabel.textColor = friendshipGreen
            friendshipIcon.image = UIImage(named: "Selected_Friendship_Icon")
        }
        else{
            friendshipLabel.textColor = UIColor.gray
            friendshipIcon.image = UIImage(named: "Selected_Friendship_Icon")
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
        businessLabel.text = "Work"
        loveLabel.text = "Dating"
        friendshipLabel.text = "Friendship"
        
        //adding Targets for actions to take place when the switches are clicked
        businessSwitch.addTarget(self, action: #selector(businessSwitchTapped(_:)), for: .touchUpInside)
        loveSwitch.addTarget(self, action: #selector(loveSwitchTapped(_:)), for: .touchUpInside)
        friendshipSwitch.addTarget(self, action: #selector(friendshipSwitchTapped(_:)), for: .touchUpInside)
        
        //setting the switches to bool values based on parse and then setting the UI of the corresponding labels, and Icons accoridingly
        //Setting whether the user is interested in business
        if let businessInterest = PFUser.current()?["interested_in_business"] as? Bool {
            businessSwitch.isOn = businessInterest
            interestedInBusiness = businessInterest
        }
        else {
            businessSwitch.isOn = true
        }
        businessSwitch.onTintColor = businessBlue
        if businessSwitch.isOn {
            businessLabel.textColor = businessBlue
            businessIcon.image = UIImage(named: "Selected_Business_Icon")
        } else {
            businessLabel.textColor = UIColor.gray
            businessIcon.image = UIImage(named: "Selected_Friendship_Icon")
        }
        //Setting whether the user is interested in love
        if let loveInterest = PFUser.current()?["interested_in_love"] as? Bool {
            loveSwitch.isOn = loveInterest
            interestedInLove = loveInterest
        }
        else {
            loveSwitch.isOn = true
        }
        loveSwitch.onTintColor = loveRed
        if loveSwitch.isOn{
            loveLabel.textColor = loveRed
            loveIcon.image = UIImage(named: "Selected_Love_Icon")
        }
        else{
            loveLabel.textColor = UIColor.gray
            loveIcon.image = UIImage(named: "Selected_Love_Icon")
        }
        //Setting whether the user is interested in friendship
        if let friendshipInterest = PFUser.current()?["interested_in_friendship"] as? Bool {
            friendshipSwitch.isOn = friendshipInterest
            interestedInFriendship = friendshipInterest
        }
        else {
            friendshipSwitch.isOn = true
        }
        friendshipSwitch.onTintColor = friendshipGreen
        if friendshipSwitch.isOn{
            friendshipLabel.textColor = friendshipGreen
            friendshipIcon.image = UIImage(named: "Selected_Friendship_Icon")
        }
        else{
            friendshipLabel.textColor = UIColor.gray
            friendshipIcon.image = UIImage(named: "Selected_Friendship_Icon")
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
        saveButton.layer.borderColor = necterGray.cgColor
        saveButton.layer.cornerRadius = 7.0
        saveButton.setTitle("save", for: UIControlState())
        saveButton.setTitleColor(necterGray, for: UIControlState())
        saveButton.setTitleColor(necterYellow, for: .highlighted)
        saveButton.setTitleColor(necterYellow, for: .selected)
        saveButton.titleLabel!.font = UIFont(name: "BentonSans", size: 20)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        view.addSubview(saveButton)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = necterYellow.cgColor
        border.frame = CGRect(x: 0, y: nameTextField.frame.size.height - width, width:  nameTextField.frame.size.width, height: nameTextField.frame.size.height)
        
        border.borderWidth = width
        nameTextField.layer.addSublayer(border)
        nameTextField.layer.masksToBounds = true
        
        let nameBorder = CALayer()
        nameBorder.borderColor = UIColor.black.cgColor
        nameBorder.frame = CGRect(x: 0, y: name.frame.size.height - width, width:  name.frame.size.width, height: name.frame.size.height)

        name.layer.addSublayer(nameBorder)
        name.layer.masksToBounds = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let singleMessageVC:SingleMessageViewController = segue.destinationViewController as! SingleMessageViewController
        let vc = segue.destination
        let mirror = Mirror(reflecting: vc)
        if mirror.subjectType == ProfileViewController.self {
            self.transitionManager.animationDirection = "Right"
        } else if mirror.subjectType == OptionsFromBotViewController.self {
            self.transitionManager.animationDirection = "Right"
            let vc2 = vc as! OptionsFromBotViewController
            vc2.seguedFrom = seguedFrom
        }
        else if mirror.subjectType == MyProfileViewController.self {
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
