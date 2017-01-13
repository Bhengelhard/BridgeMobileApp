//
//  UserSettingsViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 1/12/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse
import MessageUI

class UserSettingsViewController: UIViewController {
    
    let localData = LocalData()
    let transitionManager = TransitionManager()
    let messageComposer = MessageComposer()
    
    //CheckMarkIcons
    let selectedCheckmark = #imageLiteral(resourceName: "Selected_Gray_Circle")
    let unselectedCheckmark = #imageLiteral(resourceName: "Unselected_Gray_Circle")
    
    //Initializing Gender global objects
    let maleGenderCheckmarkIcon = UIImageView()
    let maleGenderButton = UIButton()
    let femaleGenderCheckmarkIcon = UIImageView()
    let femaleGenderButton = UIButton()
    let otherGenderCheckmarkIcon = UIImageView()
    let otherGenderButton = UIButton()
    let otherGenderTextField = UITextField()

    //Initializing Interested In global objects
    let maleInterestedInCheckmarkIcon = UIImageView()
    let maleInterestedInButton = UIButton()
    let femaleInterestedInCheckmarkIcon = UIImageView()
    let femaleInterestedInButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting Background Color
        view.backgroundColor = UIColor.white
        
        //Getting User's Settings for Gender and InterestedIn Values
        getUserSettings()
        
        //Initialize Navigation Bar
        displayNavigationBar()
        
        //Initialize My Gender
        displayMyGender()
        
        //Display Interested In
        displayInterestedIn()
        
        //Display My Necter
        displayMyNecterButtons()
        
        
    }
    
    //----Data Retrieval Functions----
    //Getting User's Settings from local Data if it is saved and if not checking _User table in DB and then saving to device
    func getUserSettings() {
        //Getting Interested In from local Data
        var interestedInSaved = false
        if let interestedIn = localData.getInterestedIn() {
            updateInterestedIn(interestedIn: interestedIn.lowercased())
            interestedInSaved = true
        }
        
        //Getting myGender from local Data
        var myGenderSaved = false
        if let myGender = localData.getMyGender() {
            updateMyGender(myGender: myGender.lowercased())
            myGenderSaved = true
        }
        
        //Getting myGender or interestedIn from Database if one of them has not yet been saved to the device
        if !myGenderSaved || !interestedInSaved {
            if let user = PFUser.current() {
                if let userObjectId = user.objectId {
                    let query = PFQuery(className: "_User")
                    query.getObjectInBackground(withId: userObjectId, block: { (result, error) in
                        if error != nil {
                            print(error ?? "Found error in UserSettingsViewController getUserSettings when retrieving interestedIn")
                        } else {
                            if let result = result {
                                //Retriving Settings from Database
                                //Retrieving interestedIn from Database when it is not yet saved to device
                                if !interestedInSaved {
                                    if let interestedIn = result["interested_in"] as? String {
                                        //Setting UI to reflected retrieved settings for myGender and interestedIn
                                        DispatchQueue.main.async(execute: {
                                            self.updateInterestedIn(interestedIn: interestedIn)
                                        })
                                        self.localData.setInterestedIn(interestedIn)
                                        
                                    }
                                    interestedInSaved = true
                                }
                                
                                //Retrieving interestedIn from Database when it is not yet saved to device
                                if !myGenderSaved {
                                    //Retrieving myGender from Databaseand myGender
                                    if let myGender = result["gender"] as? String {
                                        DispatchQueue.main.async(execute: {
                                            self.updateMyGender(myGender: myGender)
                                        })
                                        self.localData.setMyGender(myGender)
                                    }
                                }
                                
                                //Synchronizing Saved Data
                                self.localData.synchronize()
                                
                            } else {
                                print("Found error in result from UserSettingsViewController getUserSettings when retrieving interestedIn")
                            }
                        }
                    })
                }
            }
        }
    }
    
    //Updating the settings to the specified data for myGender
    func updateMyGender(myGender: String) {
        if myGender.lowercased() == "male" {
            //Set male myGender Checkmark Icon and Button to selected
            maleGenderCheckmarkIcon.image = selectedCheckmark
            maleGenderButton.isSelected = true
            
            //Set female myGender Checkmark Icon and button to unselected
            femaleGenderCheckmarkIcon.image = unselectedCheckmark
            femaleGenderButton.isSelected = false
            
            //Set Other myGender Checkmark Icon and button to unselected
            otherGenderCheckmarkIcon.image = unselectedCheckmark
            otherGenderButton.isSelected = false
            otherGenderTextField.isUserInteractionEnabled = false

        } else if myGender.lowercased() == "female" {
            //Set female myGender Checkmark Icon and button to selected
            femaleGenderCheckmarkIcon.image = selectedCheckmark
            femaleGenderButton.isSelected = true
            
            //Set male myGender Checkmark Icon and Button to unselected
            maleGenderCheckmarkIcon.image = unselectedCheckmark
            maleGenderButton.isSelected = false
            
            //Set Other myGender Checkmark Icon and button to unselected
            otherGenderCheckmarkIcon.image = unselectedCheckmark
            otherGenderButton.isSelected = false
            otherGenderTextField.isUserInteractionEnabled = false
            
        } else if myGender.lowercased() == "other" {
            //Set Other myGender Checkmark Icon and button to selected
            otherGenderCheckmarkIcon.image = selectedCheckmark
            otherGenderButton.isSelected = true
            otherGenderTextField.isUserInteractionEnabled = true
            otherGenderTextField.becomeFirstResponder()
            
            //Set male myGender Checkmark Icon and Button to unselected
            maleGenderCheckmarkIcon.image = unselectedCheckmark
            maleGenderButton.isSelected = false
            
            //Set female myGender Checkmark Icon and button to unselected
            femaleGenderCheckmarkIcon.image = unselectedCheckmark
            femaleGenderButton.isSelected = false
            
        } else {
            //The user should never have no settings set up, but if there is an error, then all the objects will set to unselected
            //Set Other myGender Checkmark Icon and button to unselected
            otherGenderCheckmarkIcon.image = unselectedCheckmark
            otherGenderButton.isSelected = false
            otherGenderTextField.isUserInteractionEnabled = false
            
            //Set male myGender Checkmark Icon and Button to unselected
            maleGenderCheckmarkIcon.image = unselectedCheckmark
            maleGenderButton.isSelected = false
            
            //Set female myGender Checkmark Icon and button to unselected
            femaleGenderCheckmarkIcon.image = unselectedCheckmark
            femaleGenderButton.isSelected = false
        }
    }
    
    //Updating the settings to the specified data for interestedIn
    func updateInterestedIn(interestedIn: String) {
        if interestedIn.lowercased() == "male" {
            //Set male Interested In Checkmark Icon and Button to selected
            maleInterestedInCheckmarkIcon.image = selectedCheckmark
            maleInterestedInButton.isSelected = true
            
            //Set female Interested In Checkmark Icon and button to unselected
            femaleInterestedInCheckmarkIcon.image = unselectedCheckmark
            femaleInterestedInButton.isSelected = false
        } else if interestedIn.lowercased() == "female" {
            //Set female Checkmark Icon and Button to selected
            femaleInterestedInCheckmarkIcon.image = selectedCheckmark
            femaleInterestedInButton.isSelected = true
            
            //Set male checkmark Icon and Button to unselected
            maleInterestedInCheckmarkIcon.image = unselectedCheckmark
            maleInterestedInButton.isSelected = false
        } else {
            //Set male checkmark Icon and Button to unselected
            maleInterestedInCheckmarkIcon.image = unselectedCheckmark
            maleInterestedInButton.isSelected = false
            
            //Set female checkmark Icon and Button to unselected
            femaleInterestedInCheckmarkIcon.image = unselectedCheckmark
            femaleInterestedInButton.isSelected = false
        }
    }
    
    //----Initialization Functions----
    //Initializing the navigation Bar
    func displayNavigationBar() {
        //Initializing left bar button item
        //Left Bar Button Icon
        let cancelIcon = UIImageView()
        cancelIcon.frame = CGRect(x: 0.03848*DisplayUtility.screenWidth, y: 0.04916*DisplayUtility.screenHeight, width: 0.01972*DisplayUtility.screenHeight, height: 0.01972*DisplayUtility.screenHeight)
        cancelIcon.image = #imageLiteral(resourceName: "Black_X")
        view.addSubview(cancelIcon)
        
        //Left Bar Button Clickable Space
        let cancelButton = UIButton()
        cancelButton.frame = CGRect(x: 0.02525*DisplayUtility.screenWidth, y: 0.04633*DisplayUtility.screenHeight, width: 0.15*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenWidth)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        cancelButton.adjustsImageWhenHighlighted = false
        view.addSubview(cancelButton)
        
        
        //Initializing right bar button item
        //Right Bar Button Icon
        let saveIcon = UIImageView()
        saveIcon.frame = CGRect(x: 0.90593*DisplayUtility.screenWidth, y: 0.05115*DisplayUtility.screenHeight, width: 0.05188*DisplayUtility.screenWidth, height: 0.02079*DisplayUtility.screenHeight)
        saveIcon.image = #imageLiteral(resourceName: "Gradient_Check")
        view.addSubview(saveIcon)
        
        //Right Bar Button Clickable Space
        let saveButton = UIButton()
        saveButton.frame = CGRect(x: 0.87475*DisplayUtility.screenWidth, y: 0.04633*DisplayUtility.screenHeight, width: 0.15*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenWidth)
        saveButton.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
        saveButton.adjustsImageWhenHighlighted = false
        view.addSubview(saveButton)
        
        //Initializing Dividing line
        let dividingLine = UIImageView()
        dividingLine.frame = CGRect(x: 0, y: 0.11882*DisplayUtility.screenHeight, width: DisplayUtility.screenHeight, height: 1)
        dividingLine.image = #imageLiteral(resourceName: "Nav_Bar_Divider")
        view.addSubview(dividingLine)
        
        //Initializing Title
        let title = UILabel()
        title.frame = CGRect(x: 0, y: 0.07969*DisplayUtility.screenHeight, width: 0.5*DisplayUtility.screenWidth, height: 0.04*DisplayUtility.screenHeight)
        title.center.x = view.center.x
        title.text = "User Settings"
        title.font = UIFont(name: "BentonSans-Light", size: 23)
        title.textAlignment = NSTextAlignment.center
        title.textColor = UIColor.lightGray
        view.addSubview(title)
        
        //Initializing Header
        let header = UILabel()
        header.frame = CGRect(x: 0, y: 0.12411*DisplayUtility.screenHeight, width: 0.5*DisplayUtility.screenWidth, height: 0.04*DisplayUtility.screenHeight)
        header.center.x = view.center.x
        header.textAlignment = NSTextAlignment.center
        header.font = UIFont(name: "BentonSans-Light", size: 12)
        //Getting CurrentUser's first name capitalized
        var capitalizedFirstName = ""
        if let userName = localData.getUsername() {
            if let firstName = userName.components(separatedBy: " ").first {
                capitalizedFirstName = firstName.uppercased()
            }
        }
        //Setting header text with error checking in case first name was not retrieved
        if capitalizedFirstName.isEmpty {
            header.text = "ACCOUNT"
        } else {
            header.text = "\(capitalizedFirstName)'S ACCOUNT"
        }
        view.addSubview(header)
    }

    //Initialize My Gender
    func displayMyGender() {
        //Initializing MY GENDER title
        setUpTitleText(originY: 0.20778*DisplayUtility.screenHeight, text: "MY GENDER")
        
        //Finding User's Gender
        
        //Initializing options to select
        //Initializing Male Gender label, checkmark, and button
        let maleFrameOrigin = CGPoint(x: 0.1496*DisplayUtility.screenWidth, y: 0.25787*DisplayUtility.screenHeight)
        setUpSelectableOption(button: maleGenderButton, checkmarkIcon: maleGenderCheckmarkIcon, origin: maleFrameOrigin, text: "MALE")
        maleGenderButton.addTarget(self, action: #selector(myGenderButtonTapped(_:)), for: .touchUpInside)
        
        //Initializing Female Gender label, checkmark, and button
        let femaleFrameOrigin = CGPoint(x: 0.5689*DisplayUtility.screenWidth, y: 0.25787*DisplayUtility.screenHeight)
        setUpSelectableOption(button: femaleGenderButton, checkmarkIcon: femaleGenderCheckmarkIcon, origin: femaleFrameOrigin, text: "FEMALE")
        femaleGenderButton.addTarget(self, action: #selector(myGenderButtonTapped(_:)), for: .touchUpInside)
        
        //Initializing Female Gender label, checkmark, and button
        let otherFrameOrigin = CGPoint(x: 0.1496*DisplayUtility.screenWidth, y: 0.32346*DisplayUtility.screenHeight)
        setUpSelectableOption(button: otherGenderButton, checkmarkIcon: otherGenderCheckmarkIcon, origin: otherFrameOrigin, text: "OTHER:")
        otherGenderButton.addTarget(self, action: #selector(myGenderButtonTapped(_:)), for: .touchUpInside)
        
        let otherGenderBottomLine = UIView()
        otherGenderBottomLine.frame.origin.y = otherGenderTextField.frame.maxY
        otherGenderBottomLine.frame.origin.x = otherGenderTextField.frame.minX
        otherGenderBottomLine.frame.size.width = otherGenderTextField.frame.width
        otherGenderBottomLine.frame.size.height = 1
        otherGenderBottomLine.backgroundColor = UIColor.gray
        view.addSubview(otherGenderBottomLine)
    }
    
    //Initialize Interested In
    func displayInterestedIn() {
        //Initializing INTERESTED IN title
        setUpTitleText(originY: 0.43766*DisplayUtility.screenHeight, text: "INTERESTED IN")
        
        //Initializing Options to select
        //Initializing Male interested in label, checkmark, and button
        let maleFrameOrigin = CGPoint(x: 0.1496*DisplayUtility.screenWidth, y: 0.49063*DisplayUtility.screenHeight)
        setUpSelectableOption(button: maleInterestedInButton, checkmarkIcon: maleInterestedInCheckmarkIcon, origin: maleFrameOrigin, text: "MALE")
        maleInterestedInButton.addTarget(self, action: #selector(interestedInButtonTapped(_:)), for: .touchUpInside)
        
        //Initializing Female interested in label, checkmark, and button
        let femaleFrameOrigin = CGPoint(x: 0.5689*DisplayUtility.screenWidth, y: 0.49063*DisplayUtility.screenHeight)
        setUpSelectableOption(button: femaleInterestedInButton, checkmarkIcon: femaleInterestedInCheckmarkIcon, origin: femaleFrameOrigin, text: "FEMALE")
        femaleInterestedInButton.addTarget(self, action: #selector(interestedInButtonTapped(_:)), for: .touchUpInside)
    }
    
    //Initialize My Necter Buttons
    func displayMyNecterButtons() {
        //Initializing MY NECTER title
        setUpTitleText(originY: 0.6093*DisplayUtility.screenHeight, text: "MY NECTER")
        
        //Button Constraints
        let gradientButtonWidth = 0.34666*DisplayUtility.screenWidth
        let gradientButtonsHeight = 0.04048*DisplayUtility.screenHeight
        //Column X Origin Values
        let leftColumnOriginX = 0.09824*DisplayUtility.screenWidth
        let rightColumnOriginX = 0.5409*DisplayUtility.screenWidth
        //Row Origin Values
        let firstRowOriginY = 0.66004*DisplayUtility.screenHeight
        let secondRowOriginY = 0.71327*DisplayUtility.screenHeight
        let thirdRowOriginY = 0.82271*DisplayUtility.screenHeight
        //Gradient button font size
        let fontSize : CGFloat = 12
        
        
        //Initializing Give Feedback Button in the first row of the left column
        let giveFeedbackFrame = CGRect(x: leftColumnOriginX, y: firstRowOriginY, width:gradientButtonWidth , height: gradientButtonsHeight)
        let giveFeedbackButton = DisplayUtility.gradientButton(frame: giveFeedbackFrame, text: "GIVE FEEDBACK", textColor: UIColor.black, fontSize: fontSize)
        giveFeedbackButton.addTarget(self, action: #selector(myNecterButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(giveFeedbackButton)
        
        //Initializing Terms of Use Button
        let termsOfUseFrame = CGRect(x: rightColumnOriginX, y: firstRowOriginY, width:gradientButtonWidth , height: gradientButtonsHeight)
        let termsOfUseButton = DisplayUtility.gradientButton(frame: termsOfUseFrame, text: "TERMS OF USE", textColor: UIColor.black, fontSize: fontSize)
        termsOfUseButton.addTarget(self, action: #selector(myNecterButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(termsOfUseButton)
        
        //Initializing Share Necter Button
        let shareNecterFrame = CGRect(x: leftColumnOriginX, y: secondRowOriginY, width:gradientButtonWidth , height: gradientButtonsHeight)
        let shareNecterButton = DisplayUtility.gradientButton(frame: shareNecterFrame, text: "SHARE NECTER", textColor: UIColor.black, fontSize: fontSize)
        shareNecterButton.addTarget(self, action: #selector(myNecterButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(shareNecterButton)
        
        //Initializing Privacy Policy Button
        let privacyPolicyFrame = CGRect(x: rightColumnOriginX, y: secondRowOriginY, width:gradientButtonWidth , height: gradientButtonsHeight)
        let privacyPolicyButton = DisplayUtility.gradientButton(frame: privacyPolicyFrame, text: "PRIVACY POLICY", textColor: UIColor.black, fontSize: fontSize)
        privacyPolicyButton.addTarget(self, action: #selector(myNecterButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(privacyPolicyButton)
        
        //Initializing Divider
        let divider = UIView()
        divider.frame.size = CGSize(width: termsOfUseFrame.maxX - giveFeedbackFrame.minX, height: 1)
        divider.frame.origin.y = 0.79198*DisplayUtility.screenHeight
        divider.center.x = view.center.x
        divider.backgroundColor = UIColor.gray
        view.addSubview(divider)
        
        //Initializing Logout Button
        let logoutFrame = CGRect(x: leftColumnOriginX, y: thirdRowOriginY, width:gradientButtonWidth , height: gradientButtonsHeight)
        let logoutButton = DisplayUtility.gradientButton(frame: logoutFrame, text: "LOGOUT", textColor: UIColor.black, fontSize: fontSize)
        logoutButton.addTarget(self, action: #selector(myNecterButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(logoutButton)
        
        //Initializing Delete Profile Button
        let deleteProfileFrame = CGRect(x: rightColumnOriginX, y: thirdRowOriginY, width:gradientButtonWidth , height: gradientButtonsHeight)
        let deleteProfileButton = UIButton()
        deleteProfileButton.frame = deleteProfileFrame
        deleteProfileButton.setTitle("DELETE PROFILE", for: .normal)
        deleteProfileButton.setTitleColor(UIColor.gray, for: .normal)
        deleteProfileButton.setTitleColor(UIColor.red, for: .highlighted)
        deleteProfileButton.setTitleColor(UIColor.red, for: .selected)
        deleteProfileButton.titleLabel?.font = UIFont(name: "BentonSans-Light", size: fontSize)
        deleteProfileButton.titleLabel?.adjustsFontSizeToFitWidth = true
        deleteProfileButton.layer.cornerRadius = 0.2*deleteProfileButton.frame.height
        deleteProfileButton.layer.borderColor = UIColor.gray.cgColor
        deleteProfileButton.layer.borderWidth = 1
        deleteProfileButton.clipsToBounds = true
        deleteProfileButton.addTarget(self, action: #selector(myNecterButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(deleteProfileButton)
        
        //Initializing website label
        let websiteLabel = UILabel()
        websiteLabel.frame.origin.y = 0.94*DisplayUtility.screenHeight
        websiteLabel.frame.size = CGSize(width: 0.8*DisplayUtility.screenWidth, height: 0.05*DisplayUtility.screenHeight)
        websiteLabel.center.x = view.center.x
        websiteLabel.text = "WWW.NECTER.SOCIAL"
        websiteLabel.textAlignment = NSTextAlignment.center
        websiteLabel.font = UIFont(name: "BentonSans-Light", size: 12)
        view.addSubview(websiteLabel)
    }
    
    //----Functions to create Repeated objects----
    //Creating Title Texts for MY GENDER, INTERESTED IN, and MY NECTER
    func setUpTitleText(originY: CGFloat, text: String) {
        let optionTitleFont = UIFont(name: "BentonSans-Light", size: 12)

        let title = UILabel()
        title.frame = CGRect(x: 0, y: originY, width: 0.5*DisplayUtility.screenWidth, height: 0.05*DisplayUtility.screenHeight)
        title.center.x = view.center.x
        title.text = text
        title.textAlignment = NSTextAlignment.center
        title.font = optionTitleFont
        view.addSubview(title)
    }
    
    //Creating RadioButtons with text next to them
    func setUpSelectableOption(button: UIButton, checkmarkIcon: UIImageView, origin: CGPoint, text: String) {
        let optionCircleDiameter = 0.05*DisplayUtility.screenHeight
        checkmarkIcon.frame.origin = origin
        checkmarkIcon.frame.size = CGSize(width: optionCircleDiameter, height: optionCircleDiameter)
        //checkmarkIcon.image = unselectedCheckmark
        view.addSubview(checkmarkIcon)
        
        let optionLabelSize = CGSize(width: 0.2*DisplayUtility.screenWidth, height: 0.05*DisplayUtility.screenHeight)
        let optionTextFont = UIFont(name: "BentonSans-Light", size: 16)
        let genderLabel = UILabel()
        genderLabel.frame.origin.x = checkmarkIcon.frame.maxX + 0.025*DisplayUtility.screenWidth
        genderLabel.frame.size = optionLabelSize
        genderLabel.center.y = checkmarkIcon.center.y
        genderLabel.text = text
        genderLabel.font = optionTextFont
        genderLabel.textAlignment = NSTextAlignment.left
        view.addSubview(genderLabel)
        
        button.frame.origin.y = checkmarkIcon.frame.minY
        button.frame.origin.x = checkmarkIcon.frame.minX
        button.frame.size.height = checkmarkIcon.frame.height
        button.frame.size.width = genderLabel.frame.maxX - checkmarkIcon.frame.minX
        view.addSubview(button)
        
        if text == "OTHER:" {
            otherGenderTextField.frame = CGRect(x: otherGenderButton.frame.maxX + 0.025*DisplayUtility.screenWidth, y: 0, width: 0.4*DisplayUtility.screenWidth, height: 0.05*DisplayUtility.screenHeight)
            otherGenderTextField.center.y = otherGenderCheckmarkIcon.center.y
            otherGenderTextField.textAlignment = NSTextAlignment.left
            otherGenderTextField.font = optionTextFont
            //otherGenderTextField.isUserInteractionEnabled = false
            view.addSubview(otherGenderTextField)
        }
    }
    
    
    //----Targets----
    //Left Bar Button Target
    func cancelButtonTapped(_ sender: UIButton) {
        print("cancelButtonTapped")
        //dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "showMyProfile", sender: self)
    }
    
    //Right Bar Button Target
    func saveButtonTapped(_ sender: UIButton) {
        print("saveButtonTapped and not yet saving")
        performSegue(withIdentifier: "showMyProfile", sender: self)
    }
    
    //My Gender Button Target - Changing My Gender Radio Button to Selected Button
    func myGenderButtonTapped(_ sender: UIButton) {
        
        //Updating MaleGenderButton to new selection
        if sender == maleGenderButton && !sender.isSelected {
            updateMyGender(myGender: "male")
        }
        //Updating FemaleGenderButton to new selection
        else if sender == femaleGenderButton && !sender.isSelected {
            updateMyGender(myGender: "female")
        }
        //Updating OtherGenderButton to new selection
        else if sender == otherGenderButton && !sender.isSelected {
            updateMyGender(myGender: "other")
        }
        //The user should never have no settings set up, but if there is an error, then all the objects will set to unselected
        else {
            updateMyGender(myGender: "nothing set")
            print("no gender is set")
        }
    }
    
    //Male Interested Button Target - Changing Interested In Radion Button to Male Selected
    func interestedInButtonTapped(_ sender: UIButton) {
        //Closing Keyboard if it is open
        if otherGenderTextField.isFirstResponder {
            otherGenderTextField.resignFirstResponder()
        }
        
        //Updating male InterestedIn to new selection
        if sender == maleInterestedInButton && !sender.isSelected {
            updateInterestedIn(interestedIn: "male")
        }
        //Updating female InterestedIn to new selection
        else if sender == femaleInterestedInButton && !sender.isSelected {
            updateInterestedIn(interestedIn: "female")
        }
    }
    
    //My Necter Buttons Target
    func myNecterButtonTapped(_ sender: UIButton) {
        sender.isSelected = false
        sender.isHighlighted = false
        
        if let title = sender.currentTitle {
            //open user's email application with email ready to be sent to necter email -> commented out and replaced with link to survey
            if title == "GIVE FEEDBACK" {
                
                let subject = "Providing%20Feedback%20for%20the%20necter%20Team"
                let encodedParams = "subject=\(subject)"
                let email = "blake@necter.social"
                let url = NSURL(string: "mailto:\(email)?\(encodedParams)")
                
                if UIApplication.shared.canOpenURL(url! as URL) {
                    UIApplication.shared.openURL(url! as URL)
                }
                
            }
            else if title == "TERMS OF USE" {
                let url = URL(string: "https://necter.social/termsofservice")
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.openURL(url!)
                }
                
            }
            else if title == "SHARE NECTER" {
                // Make sure the device can send text messages
                if (messageComposer.canSendText()) {
                    // Obtain a configured MFMessageComposeViewController
                    let messageComposeVC = messageComposer.configuredMessageComposeViewController()
                    
                    // Present the configured MFMessageComposeViewController instance
                    // Note that the dismissal of the VC will be handled by the messageComposer instance,
                    // since it implements the appropriate delegate call-back
                    present(messageComposeVC, animated: true, completion: nil)
                } else {
                    // Let the user know if his/her device isn't able to send text messages
                    let errorAlert = UIAlertView(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", delegate: self, cancelButtonTitle: "OK")
                    errorAlert.show()
                }
            }
            else if title == "PRIVACY POLICY" {
                let url = URL(string: "https://necter.social/privacypolicy")
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.openURL(url!)
                }

            }
            else if title == "LOGOUT" {
                PFUser.logOut()
                performSegue(withIdentifier: "showAccessViewController", sender: self)
                //present(AccessViewController(), animated: true, completion: nil)
            }
            else if title == "DELETE PROFILE" {
                print("delete profile")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Setting segue transition information and preparation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination
        let mirror = Mirror(reflecting: vc)
        if mirror.subjectType == MyProfileViewController.self {
            self.transitionManager.animationDirection = "Bottom"
        } else if mirror.subjectType == AccessViewController.self {
            self.transitionManager.animationDirection = "Top"
        }
        vc.transitioningDelegate = self.transitionManager
    }

}
