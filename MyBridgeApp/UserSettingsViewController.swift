//
//  UserSettingsViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 1/12/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class UserSettingsViewController: UIViewController {
    
    let localData = LocalData()
    let optionTitleFont = UIFont(name: "BentonSans-Light", size: 12)
    
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
        
        //Initialize Navigation Bar
        displayNavigationBar()
        
        //Initialize My Gender
        displayMyGender()
        
        //Display Interested In
        displayInterestedIn()
        
        //Display My Necter
        displayMyNecterButtons()
        
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
        let gradientButtonsHeight = 0.2063*gradientButtonWidth
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
        checkmarkIcon.image = unselectedCheckmark
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
            otherGenderTextField.isUserInteractionEnabled = false
            view.addSubview(otherGenderTextField)
        }
    }
    
    
    //----Targets----
    //Left Bar Button Target
    func cancelButtonTapped(_ sender: UIButton) {
        print("cancelButtonTapped")
        dismiss(animated: true, completion: nil)
        //performSegue(withIdentifier: "showMyProfile", sender: self)
    }
    
    //Right Bar Button Target
    func saveButtonTapped(_ sender: UIButton) {
        print("saveButtonTapped and not yet saving")
        dismiss(animated: true, completion: nil)
    }
    
    //My Gender Button Target - Changing My Gender Radio Button to Selected Button
    func myGenderButtonTapped(_ sender: UIButton) {
        
        //Updating MaleGenderButton to new selection
        if sender == maleGenderButton && !sender.isSelected {
            //Set male Checkmark Icon and Button to selected
            maleGenderCheckmarkIcon.image = selectedCheckmark
            maleGenderButton.isSelected = true
        } else if sender != maleGenderButton && maleGenderButton.isSelected{
            //Set male checkmark Icon and Button to unselected
            maleGenderCheckmarkIcon.image = unselectedCheckmark
            maleGenderButton.isSelected = false
        }
        
        //Updating FemaleGenderButton to new selection
        if sender == femaleGenderButton && !sender.isSelected {
            //Set female Checkmark Icon and Button to selected
            femaleGenderCheckmarkIcon.image = selectedCheckmark
            femaleGenderButton.isSelected = true
        } else if sender != femaleGenderButton && femaleGenderButton.isSelected{
            //Set female checkmark Icon and Button to unselected
            femaleGenderCheckmarkIcon.image = unselectedCheckmark
            femaleGenderButton.isSelected = false
        }
        
        //Updating OtherGenderButton to new selection
        if sender == otherGenderButton && !sender.isSelected {
            //Set other checkmark Icon and Button to unselected
            otherGenderCheckmarkIcon.image = selectedCheckmark
            otherGenderButton.isSelected = true
            otherGenderTextField.isUserInteractionEnabled = true
            otherGenderTextField.becomeFirstResponder()
        } else if sender != otherGenderButton && otherGenderButton.isSelected{
            //Set other checkmark Icon and Button to unselected
            otherGenderCheckmarkIcon.image = unselectedCheckmark
            otherGenderButton.isSelected = false
            otherGenderTextField.isUserInteractionEnabled = false
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
            //Set male Checkmark Icon and Button to selected
            maleInterestedInCheckmarkIcon.image = selectedCheckmark
            maleInterestedInButton.isSelected = true
        } else if sender != maleInterestedInButton && maleInterestedInButton.isSelected{
            //Set male checkmark Icon and Button to unselected
            maleInterestedInCheckmarkIcon.image = unselectedCheckmark
            maleInterestedInButton.isSelected = false
        }
        
        //Updating female InterestedIn to new selection
        if sender == femaleInterestedInButton && !sender.isSelected {
            //Set female Checkmark Icon and Button to selected
            femaleInterestedInCheckmarkIcon.image = selectedCheckmark
            femaleInterestedInButton.isSelected = true
        } else if sender != femaleInterestedInButton && femaleInterestedInButton.isSelected{
            //Set female checkmark Icon and Button to unselected
            femaleInterestedInCheckmarkIcon.image = unselectedCheckmark
            femaleInterestedInButton.isSelected = false
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
            else if title == "TERMS OF SERVICE" {
                let url = URL(string: "https://necter.social/termsofservice")
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.openURL(url!)
                }
                
            }
            else if title == "SHARE NECTER" {
                
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
