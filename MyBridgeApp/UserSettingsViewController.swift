//
//  UserSettingsViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 1/12/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class UserSettingsViewController: UIViewController {
    
    let localData = LocalData()
    let optionTitleFont = UIFont(name: "BentonSans-Light", size: 12)
    let optionTextFont = UIFont(name: "BentonSans-Light", size: 16)
    let optionCircleDiameter = 0.05*DisplayUtility.screenHeight
    let optionLabelSize = CGSize(width: 0.2*DisplayUtility.screenWidth, height: 0.05*DisplayUtility.screenHeight)
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        initializeUI()
        
    }
    
    func initializeUI () {
        //Initialize Navigation Bar
        displayNavigationBar()
        
        //Initialize My Gender
        displayMyGender()
        
        //Display Interested In
        displayInterestedIn()
        
        //Display My Necter buttons
        
        //Display logout, delete profile, and website

    }
    
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
    
    //Left Bar Button Target
    func cancelButtonTapped(_ sender: UIButton) {
        print("cancelButtonTapped")
        //performSegue(withIdentifier: "showMyProfile", sender: self)
        dismiss(animated: true, completion: nil)
    }
    
    //Right Bar Button Target
    func saveButtonTapped(_ sender: UIButton) {
        print("saveButtonTapped and not yet saving")
        dismiss(animated: true, completion: nil)
    }

    //Initialize My Gender
    func displayMyGender() {
        //Initializing MY GENDER title
        let title = UILabel()
        title.frame = CGRect(x: 0, y: 0.20778*DisplayUtility.screenHeight, width: 0.5*DisplayUtility.screenWidth, height: 0.05*DisplayUtility.screenHeight)
        title.center.x = view.center.x
        title.text = "MY GENDER"
        title.textAlignment = NSTextAlignment.center
        title.font = optionTitleFont
        view.addSubview(title)
        
        //Finding User's Gender
        
        //Initializing Male Gender label, checkmark and button
        let maleFrameOrigin = CGPoint(x: 0.1496*DisplayUtility.screenWidth, y: 0.25787*DisplayUtility.screenHeight)
        setUpGenderClickableSpace(button: maleGenderButton, checkmarkIcon: maleGenderCheckmarkIcon, origin: maleFrameOrigin, text: "MALE")
        maleGenderButton.addTarget(self, action: #selector(maleButtonTapped(_:)), for: .touchUpInside)
        
        //Initializing Female Gender label, checkmark, and button
        let femaleFrameOrigin = CGPoint(x: 0.5689*DisplayUtility.screenWidth, y: 0.25787*DisplayUtility.screenHeight)
        setUpGenderClickableSpace(button: femaleGenderButton, checkmarkIcon: femaleGenderCheckmarkIcon, origin: femaleFrameOrigin, text: "FEMALE")
        femaleGenderButton.addTarget(self, action: #selector(femaleButtonTapped(_:)), for: .touchUpInside)
        
        //Initializing Female Gender label, checkmark, and button
        let otherFrameOrigin = CGPoint(x: 0.1496*DisplayUtility.screenWidth, y: 0.32346*DisplayUtility.screenHeight)
        setUpGenderClickableSpace(button: otherGenderButton, checkmarkIcon: otherGenderCheckmarkIcon, origin: otherFrameOrigin, text: "OTHER:")
        otherGenderButton.addTarget(self, action: #selector(otherButtonTapped(_:)), for: .touchUpInside)
        
        otherGenderTextField.frame = CGRect(x: otherGenderButton.frame.maxX + 0.025*DisplayUtility.screenWidth, y: 0, width: 0.4*DisplayUtility.screenWidth, height: 0.05*DisplayUtility.screenHeight)
        otherGenderTextField.center.y = otherGenderCheckmarkIcon.center.y
        otherGenderTextField.textAlignment = NSTextAlignment.left
        otherGenderTextField.font = optionTextFont
        otherGenderTextField.isUserInteractionEnabled = false
        view.addSubview(otherGenderTextField)
        
        let otherGenderBottomLine = UIView()
        otherGenderBottomLine.frame.origin.y = otherGenderTextField.frame.maxY
        otherGenderBottomLine.frame.origin.x = otherGenderTextField.frame.minX
        otherGenderBottomLine.frame.size.width = otherGenderTextField.frame.width
        otherGenderBottomLine.frame.size.height = 1
        otherGenderBottomLine.backgroundColor = UIColor.black
        view.addSubview(otherGenderBottomLine)
    }
    
    //Initialize Interested In
    func displayInterestedIn() {
        
        
    }
    
    func setUpGenderClickableSpace(button: UIButton, checkmarkIcon: UIImageView, origin: CGPoint, text: String) {
        checkmarkIcon.frame.origin = origin
        checkmarkIcon.frame.size = CGSize(width: optionCircleDiameter, height: optionCircleDiameter)
        checkmarkIcon.image = unselectedCheckmark
        view.addSubview(checkmarkIcon)
        
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
    }
    
    //Male Button Target - Changing Gender Radio Button to Male Selected
    func maleButtonTapped(_ sender: UIButton) {
        if !maleGenderButton.isSelected {
            //Set male Checkmark Icon and Button to selected
            maleGenderCheckmarkIcon.image = selectedCheckmark
            maleGenderButton.isSelected = true
            
            //Set female checkmark Icon and Button to unselected
            femaleGenderCheckmarkIcon.image = unselectedCheckmark
            femaleGenderButton.isSelected = false
            
            //Set other checkmark Icon and Button to unselected
            otherGenderCheckmarkIcon.image = unselectedCheckmark
            otherGenderButton.isSelected = false
            otherGenderTextField.isUserInteractionEnabled = false
        }
    }
    
    //Female Button Target - Changing Gender Radio Button to Female Selected
    func femaleButtonTapped(_ sender: UIButton) {
        if !femaleGenderButton.isSelected {
            //Set female Checkmark Icon and Button to selected
            femaleGenderCheckmarkIcon.image = selectedCheckmark
            femaleGenderButton.isSelected = true
            
            //Set male checkmark Icon and Button to unselected
            maleGenderCheckmarkIcon.image = unselectedCheckmark
            maleGenderButton.isSelected = false
            
            //Set other checkmark Icon and Button to unselected
            otherGenderCheckmarkIcon.image = unselectedCheckmark
            otherGenderButton.isSelected = false
            otherGenderTextField.isUserInteractionEnabled = false
        }
    }
    
    //Other Button Target - Changing Gender Radio Button to Other Selected
    func otherButtonTapped(_ sender: UIButton) {
        if !otherGenderButton.isSelected {
            //Set other Checkmark Icon and Button to selected
            otherGenderCheckmarkIcon.image = selectedCheckmark
            otherGenderButton.isSelected = true
            otherGenderTextField.isUserInteractionEnabled = true
            
            //Set male checkmark Icon and Button to unselected
            maleGenderCheckmarkIcon.image = unselectedCheckmark
            maleGenderButton.isSelected = false
            
            //Set female checkmark Icon and Button to unselected
            femaleGenderCheckmarkIcon.image = unselectedCheckmark
            femaleGenderButton.isSelected = false
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
