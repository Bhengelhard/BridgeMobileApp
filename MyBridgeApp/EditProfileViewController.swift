//
//  EditProfileViewController.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 1/11/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit
import Parse

class EditProfileViewController: UIViewController, UITextViewDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var myProfileVC: MyProfileViewController
    
    let localData = LocalData()
    
    // views
    let scrollView = UIScrollView()
    var navBar: ProfileNavBar?
    var hexes: ProfileHexagons?
    let quickUpdateView = UIView()
    let quickUpdateTextView = UITextView()
    let factsView = UIView()
    let factsBackground = UIView()
    let factsTextView = UITextView()
    let factsEditor = UIView()
    let ageBubble = UIButton()
    let schoolBubble = UIButton()
    let religionBubble = UIButton()
    let cityBubble = UIButton()
    let workBubble = UIButton()
    var clearViews = [UIView]()
    let statusView = UIView()
    var statusButtons: ProfileStatusButtons?
    let statusTextView = UITextView()
    var saveButton = UIButton()
    let uploadMenu = UIView()
    let imagePicker = UIImagePickerController()
    
    // boolean flags
    var quickUpdatePlaceholder = true
    var statusPlaceholder = true
    
    // data
    var greeting = "Hi,"
    var greetings = ["Hi,", "What's Up?", "Hello there,"]
    var selectedFacts = [String]()
    var originallyInterestedBusiness: Bool?
    var originallyInterestedLove: Bool?
    var originallyInterestedFriendship: Bool?
    var businessStatus: String?
    var loveStatus: String?
    var friendshipStatus: String?
    var noBusinessStatus = false
    var noLoveStatus = false
    var noFriendshipStatus = false
    var currentStatusType: String?
    
    init(myProfileVC: MyProfileViewController) {
        self.myProfileVC = myProfileVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set background color to white
        view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        if let user = PFUser.current() {
            
            
            // MARK: Navigation Bar
            
            // create image for exit button
            let xIcon = UIImageView(image: UIImage(named: "Black_X"))
            let xIconWidth = 0.03514*DisplayUtility.screenWidth
            let xIconHeight = xIconWidth * 26.31/26.352
            xIcon.frame.size = CGSize(width: xIconWidth, height: xIconHeight)
            
            // create image for save button
            let checkIcon = UIImageView(image: UIImage(named: "Gradient_Check"))
            let checkIconWidth = 0.05188*DisplayUtility.screenWidth
            let checkIconHeight = checkIconWidth * 27.73/38.907
            checkIcon.frame.size = CGSize(width: checkIconWidth, height: checkIconHeight)
            
            // set text for greeting label
            var greetingText = String()
            if let userGreeting = user["profile_greeting"] as? String {
                greeting = userGreeting
            }
            if let name = localData.getUsername() {
                let firstName = DisplayUtility.firstName(name: name)
                greetingText = "\(greeting) I'm \(firstName)."
            }
            
            // initialize navigation bar
            navBar = ProfileNavBar(leftButtonImageView: xIcon, leftButtonFunc: exit, rightButtonImageView: checkIcon, rightButtonFunc: save, mainText: greetingText, mainTextColor: .gray, subText: "EDITING PROFILE", subTextColor: .black)
            view.addSubview(navBar!)
            
            // add gesture recognizer for greeting label
            navBar!.mainLabel.isUserInteractionEnabled = true
            let greetingGR = UITapGestureRecognizer(target: self, action: #selector(greetingLabelTapped(_:)))
            navBar!.mainLabel.addGestureRecognizer(greetingGR)
            
            
            // MARK: Scroll View
            
            scrollView.backgroundColor = .clear
            let scrollViewEndEditingGR = UITapGestureRecognizer(target: self, action: #selector(endEditing(_:)))
            scrollView.addGestureRecognizer(scrollViewEndEditingGR)
            
            // place scroll view below navigation bar
            scrollView.frame = CGRect(x: 0, y: navBar!.frame.maxY, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight - navBar!.frame.maxY)
            view.addSubview(scrollView)
            
            
            // MARK: Profile Picture Hexagons
            
            // get images for hexes
            var hexImages: [UIImage]
            if let images = myProfileVC.hexImages() {
                hexImages = images
            } else {
                hexImages = [UIImage]()
            }
            
            // initialize hexes
            hexes = ProfileHexagons(minY: 0, parentVC: self, hexImages: hexImages, shouldShowDefaultFrame: true, shouldBeEditable: true)
            scrollView.addSubview(hexes!)
            
            
            // MARK: Quick Update
            
            let quickUpdateLabel = UILabel()
            quickUpdateLabel.text = "QUICK-UPDATE"
            quickUpdateLabel.textColor = .black
            quickUpdateLabel.textAlignment = .center
            quickUpdateLabel.font = UIFont(name: "BentonSans-Light", size: 12)
            quickUpdateLabel.sizeToFit()
            quickUpdateLabel.frame = CGRect(x: 0, y: 0, width: quickUpdateLabel.frame.width, height: quickUpdateLabel.frame.height)
            quickUpdateLabel.center.x = DisplayUtility.screenWidth / 2
            quickUpdateView.addSubview(quickUpdateLabel)
            
            quickUpdateTextView.frame = CGRect(x: 0, y: quickUpdateLabel.frame.maxY + 0.04*DisplayUtility.screenHeight, width: 0.85733*DisplayUtility.screenWidth, height: 0.208*DisplayUtility.screenWidth)
            quickUpdateTextView.center.x = DisplayUtility.screenWidth / 2
            quickUpdateTextView.layer.cornerRadius = 13
            quickUpdateTextView.layer.borderWidth = 1
            quickUpdateTextView.layer.borderColor = UIColor.black.cgColor
            quickUpdateTextView.delegate = self
            if let quickUpdate = user["quick_update"] as? String {
                quickUpdateTextView.text = quickUpdate
                quickUpdatePlaceholder = false
            } else {
                quickUpdateTextView.text = "What have you been up to recently?\nWhat are your plans for the near future?"
                quickUpdatePlaceholder = true
            }
            quickUpdateTextView.textColor = .black
            quickUpdateTextView.textAlignment = .center
            quickUpdateTextView.font = UIFont(name: "BentonSans-Light", size: 14)
            DisplayUtility.centerTextVerticallyInTextView(textView: quickUpdateTextView)
            quickUpdateView.addSubview(quickUpdateTextView)
            
            quickUpdateView.frame = CGRect(x: 0, y: hexes!.frame.maxY + 0.045*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: quickUpdateTextView.frame.maxY)
            scrollView.addSubview(quickUpdateView)
            
            
            // MARK: The Facts
            
            let factsLabel = UILabel()
            factsLabel.text = "THE FACTS"
            factsLabel.textColor = .black
            factsLabel.textAlignment = .center
            factsLabel.font = UIFont(name: "BentonSans-Light", size: 12)
            factsLabel.sizeToFit()
            factsLabel.frame = CGRect(x: 0, y: 0, width: quickUpdateLabel.frame.width, height: quickUpdateLabel.frame.height)
            factsLabel.center.x = DisplayUtility.screenWidth / 2
            factsView.addSubview(factsLabel)
            
            
            factsBackground.backgroundColor = .clear
            factsBackground.layer.cornerRadius = 13
            factsBackground.layer.borderWidth = 1
            factsBackground.layer.borderColor = UIColor.black.cgColor
            factsView.addSubview(factsBackground)
            
            factsEditor.frame = CGRect(x: 0, y: 0, width: 0.85733*DisplayUtility.screenWidth, height: 0.484*DisplayUtility.screenWidth)
            
            let selectedBubbleImage = UIImage(named: "Profile_Selected_Gray_Bubble")
            let unselectedBubbleImage = UIImage(named: "Profile_Unselected_Gray_Bubble")
            
            let bubbleWidth = 0.076*DisplayUtility.screenWidth
            let bubbleHeight = bubbleWidth
            
            if let userSelectedFacts = user["selected_facts"] as? [String] {
                selectedFacts = userSelectedFacts
            }
            
            if selectedFacts.contains("Age") {
                ageBubble.setImage(selectedBubbleImage, for: .normal)
            } else {
                ageBubble.setImage(unselectedBubbleImage, for: .normal)
            }
            ageBubble.frame = CGRect(x: 0.315*factsEditor.frame.width, y: 0.18*factsEditor.frame.height, width: bubbleWidth, height: bubbleHeight)
            ageBubble.addTarget(self, action: #selector(bubbleSelected(_:)), for: .touchUpInside)
            
            if selectedFacts.contains("School") {
                schoolBubble.setImage(selectedBubbleImage, for: .normal)
            } else {
                schoolBubble.setImage(unselectedBubbleImage, for: .normal)
            }
            schoolBubble.frame = CGRect(x: ageBubble.frame.minX, y: ageBubble.frame.maxY + 0.06*factsEditor.frame.height, width: bubbleWidth, height: bubbleHeight)
            schoolBubble.addTarget(self, action: #selector(bubbleSelected(_:)), for: .touchUpInside)

            
            if selectedFacts.contains("Religion") {
                religionBubble.setImage(selectedBubbleImage, for: .normal)
            } else {
                religionBubble.setImage(unselectedBubbleImage, for: .normal)
            }
            religionBubble.frame = CGRect(x: ageBubble.frame.minX, y: schoolBubble.frame.maxY + 0.06*factsEditor.frame.height, width: bubbleWidth, height: bubbleHeight)
            religionBubble.addTarget(self, action: #selector(bubbleSelected(_:)), for: .touchUpInside)

            
            if selectedFacts.contains("City") {
                cityBubble.setImage(selectedBubbleImage, for: .normal)
            } else {
                cityBubble.setImage(unselectedBubbleImage, for: .normal)
            }
            cityBubble.frame = CGRect(x: factsEditor.frame.width - ageBubble.frame.maxX, y: ageBubble.frame.minY, width: bubbleWidth, height: bubbleHeight)
            cityBubble.addTarget(self, action: #selector(bubbleSelected(_:)), for: .touchUpInside)

            
            if selectedFacts.contains("Work") {
                workBubble.setImage(selectedBubbleImage, for: .normal)
            } else {
                workBubble.setImage(unselectedBubbleImage, for: .normal)
            }
            workBubble.frame = CGRect(x: cityBubble.frame.minX, y: schoolBubble.frame.minY, width: bubbleWidth, height: bubbleHeight)
            workBubble.addTarget(self, action: #selector(bubbleSelected(_:)), for: .touchUpInside)

            
            let labelOffsetFromBubble = 0.03*factsEditor.frame.width
            
            let ageLabel = UILabel()
            ageLabel.text = "AGE"
            ageLabel.textColor = .gray
            ageLabel.font = UIFont(name: "BentonSans-Light", size: 15)
            ageLabel.sizeToFit()
            ageLabel.frame = CGRect(x: ageBubble.frame.minX - ageLabel.frame.width - labelOffsetFromBubble, y: 0, width: ageLabel.frame.width, height: ageLabel.frame.height+1)
            ageLabel.center.y = ageBubble.center.y
            factsEditor.addSubview(ageLabel)
            
            let schoolLabel = UILabel()
            schoolLabel.text = "SCHOOL"
            schoolLabel.textColor = .gray
            schoolLabel.font = UIFont(name: "BentonSans-Light", size: 15)
            schoolLabel.sizeToFit()
            schoolLabel.frame = CGRect(x: schoolBubble.frame.minX - schoolLabel.frame.width - labelOffsetFromBubble, y: 0, width: schoolLabel.frame.width, height: schoolLabel.frame.height+1)
            schoolLabel.center.y = schoolBubble.center.y
            factsEditor.addSubview(schoolLabel)
            
            let religionLabel = UILabel()
            religionLabel.text = "RELIGION"
            religionLabel.textColor = .gray
            religionLabel.font = UIFont(name: "BentonSans-Light", size: 15)
            religionLabel.sizeToFit()
            religionLabel.frame = CGRect(x: religionBubble.frame.minX - religionLabel.frame.width - labelOffsetFromBubble, y: 0, width: religionLabel.frame.width, height: religionLabel.frame.height+1)
            religionLabel.center.y = religionBubble.center.y
            factsEditor.addSubview(religionLabel)
            
            let cityLabel = UILabel()
            cityLabel.text = "CITY"
            cityLabel.textColor = .gray
            cityLabel.font = UIFont(name: "BentonSans-Light", size: 15)
            cityLabel.sizeToFit()
            cityLabel.frame = CGRect(x: cityBubble.frame.maxX + labelOffsetFromBubble, y: 0, width: cityLabel.frame.width, height: cityLabel.frame.height+1)
            cityLabel.center.y = cityBubble.center.y
            factsEditor.addSubview(cityLabel)
            
            let workLabel = UILabel()
            workLabel.text = "WORK"
            workLabel.textColor = .gray
            workLabel.font = UIFont(name: "BentonSans-Light", size: 15)
            workLabel.sizeToFit()
            workLabel.frame = CGRect(x: workBubble.frame.maxX + labelOffsetFromBubble, y: 0, width: workLabel.frame.width, height: workLabel.frame.height+1)
            workLabel.center.y = workBubble.center.y
            factsEditor.addSubview(workLabel)
            
            if user["age"] != nil {
                factsEditor.addSubview(ageBubble)
                ageLabel.textColor = .black
            }
            
            if user["school"] != nil {
                factsEditor.addSubview(schoolBubble)
                schoolLabel.textColor = .black
            }
            
            if user["religion"] != nil {
                factsEditor.addSubview(religionBubble)
                religionLabel.textColor = .black
            }
            
            if user["city"] != nil {
                factsEditor.addSubview(cityBubble)
                cityLabel.textColor = .black
            }
            if user["work"] != nil {
                factsEditor.addSubview(workBubble)
                workLabel.textColor = .black
            }
            
            let editFactsLabel = UILabel()
            editFactsLabel.text = "TO EDIT FACTS, UPDATE ON FACEBOOK."
            editFactsLabel.textColor = .black
            editFactsLabel.textAlignment = .center
            editFactsLabel.font = UIFont(name: "BentonSans-Light", size: 12)
            editFactsLabel.sizeToFit()
            editFactsLabel.frame = CGRect(x: 0, y: religionBubble.frame.maxY + 0.1*factsEditor.frame.height, width: editFactsLabel.frame.width, height: editFactsLabel.frame.height)
            editFactsLabel.center.x = factsEditor.frame.width / 2
            factsEditor.addSubview(editFactsLabel)
            
            factsEditor.alpha = 0
            factsBackground.addSubview(factsEditor)
            
            factsTextView.isEditable = false
            factsTextView.frame = CGRect(x: 0, y: 0, width: factsEditor.frame.width, height: 0.208*DisplayUtility.screenWidth)
            factsTextView.textColor = .black
            factsTextView.textAlignment = .center
            factsTextView.font = UIFont(name: "BentonSans-Light", size: 14)
            
            writeFactsInTextView()
            factsBackground.addSubview(factsTextView)
            
            factsBackground.frame = CGRect(x: 0, y: factsLabel.frame.maxY + 0.04*DisplayUtility.screenHeight, width: factsTextView.frame.width, height: factsTextView.frame.height)
            factsBackground.center.x = DisplayUtility.screenWidth / 2
            
            // Adding gesture recognizer for facts text view
            factsTextView.isUserInteractionEnabled = true
            let factsTextViewGR = UITapGestureRecognizer(target: self, action: #selector(displayFactsEditor(_:)))
            factsTextViewGR.delegate = self
            factsTextView.addGestureRecognizer(factsTextViewGR)

            factsView.frame = CGRect(x: 0, y: quickUpdateView.frame.maxY + 0.045*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: factsBackground.frame.maxY)
            scrollView.addSubview(factsView)
            

            // MARK: Statuses
            
            let visibilityLabel = UILabel()
            visibilityLabel.text = "SHOW MY PROFILE FOR:"
            visibilityLabel.textColor = .black
            visibilityLabel.textAlignment = .center
            visibilityLabel.font = UIFont(name: "BentonSans-Light", size: 12)
            visibilityLabel.sizeToFit()
            visibilityLabel.frame = CGRect(x: 0, y: 0, width: visibilityLabel.frame.width, height: visibilityLabel.frame.height)
            visibilityLabel.center.x = DisplayUtility.screenWidth / 2
            statusView.addSubview(visibilityLabel)
            
            if let interestedBusiness = user["interested_in_business"] as? Bool {
                originallyInterestedBusiness = interestedBusiness
            }
            
            if let interestedLove = user["interested_in_love"] as? Bool {
                originallyInterestedLove = interestedLove
            }
            
            if let interestedFriendship = user["interested_in_friendship"] as? Bool {
                originallyInterestedFriendship = interestedFriendship
            }
            
            let businessVisible = originallyInterestedBusiness ?? false
            let loveVisible = originallyInterestedLove ?? false
            let friendshipVisible = originallyInterestedFriendship ?? false

            statusButtons = ProfileStatusButtons(minY: visibilityLabel.frame.maxY + 0.03*DisplayUtility.screenHeight, selectType: selectType, shouldShowVisibilityButtons: true, businessVisible: businessVisible, loveVisible: loveVisible, friendshipVisible: friendshipVisible)
            statusView.addSubview(statusButtons!)
 
            statusTextView.isEditable = false
            statusTextView.frame = CGRect(x: 0, y: statusButtons!.frame.maxY + 0.03*DisplayUtility.screenHeight, width: 0.85733*DisplayUtility.screenWidth, height: 0.208*DisplayUtility.screenWidth)
            statusTextView.center.x = DisplayUtility.screenWidth / 2
            statusTextView.layer.cornerRadius = 13
            statusTextView.layer.borderWidth = 1
            statusTextView.layer.borderColor = UIColor.black.cgColor
            statusTextView.delegate = self
            statusTextView.text = "Click an icon above to edit current requests."
            statusTextView.textColor = .black
            statusTextView.textAlignment = .center
            statusTextView.font = UIFont(name: "BentonSans-Light", size: 14)
            DisplayUtility.centerTextVerticallyInTextView(textView: statusTextView)
            statusView.addSubview(statusTextView)
            
            statusView.frame = CGRect(x: 0, y: factsView.frame.maxY + 0.045*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: statusTextView.frame.maxY)
            scrollView.addSubview(statusView)
            
            
            // MARK: Save Button
            
            let saveButtonWidth = 0.18266*DisplayUtility.screenWidth
            let saveButtonHeight = 0.4453*saveButtonWidth
            let saveButtonFrame = CGRect(x: 0, y: statusView.frame.maxY + 0.055*DisplayUtility.screenHeight, width: saveButtonWidth, height: saveButtonHeight)
            saveButton = DisplayUtility.gradientButton(frame: saveButtonFrame, text: "save", textColor: UIColor.black, fontSize: 13)
            saveButton.center.x = DisplayUtility.screenWidth / 2
            saveButton.addTarget(self, action: #selector(save(_:)), for: .touchUpInside)
            scrollView.addSubview(saveButton)
            
            layoutBottomBasedOnFactsView()
        }
    }
    
    func layoutBottomBasedOnFactsView() {
        factsView.frame = CGRect(x: 0, y: quickUpdateView.frame.maxY + 0.045*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: factsBackground.frame.maxY)
        statusView.frame = CGRect(x: 0, y: factsView.frame.maxY + 0.045*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: statusTextView.frame.maxY)
        let saveButtonWidth = 0.18266*DisplayUtility.screenWidth
        let saveButtonHeight = 0.4453*saveButtonWidth
        saveButton.frame = CGRect(x: 0, y: statusView.frame.maxY + 0.055*DisplayUtility.screenHeight, width: saveButtonWidth, height: saveButtonHeight)
        saveButton.center.x = DisplayUtility.screenWidth / 2
        scrollView.contentSize = CGSize(width: DisplayUtility.screenWidth, height: max(scrollView.frame.height, saveButton.frame.maxY + 0.02*DisplayUtility.screenHeight))
    }
    
    func exit(_ sender: UIButton) {
        updateMyProfileHexImages()
        dismiss(animated: false, completion: nil)
    }
    
    func save(_ sender: UIButton) {
        view.endEditing(true)
        updateMyProfileHexImages()
        if let user = PFUser.current() {
            
            user["profile_greeting"] = greeting
            
            if !quickUpdatePlaceholder && quickUpdateTextView.text != "" {
                user["quick_update"] = quickUpdateTextView.text
            }
            
            var selectedFacts = [String]()
            let selectedImage = UIImage(named: "Profile_Selected_Gray_Bubble")
            if ageBubble.image(for: .normal) == selectedImage {
                selectedFacts.append("Age")
            }
            if cityBubble.image(for: .normal) == selectedImage {
                selectedFacts.append("City")
            }
            if schoolBubble.image(for: .normal) == selectedImage {
                selectedFacts.append("School")
            }
            if workBubble.image(for: .normal) == selectedImage {
                selectedFacts.append("Work")
            }
            if religionBubble.image(for: .normal) == selectedImage {
                selectedFacts.append("Religion")
            }
            user["selected_facts"] = selectedFacts
            
            var interestedBusiness: Bool? = nil
            var interestedLove: Bool? = nil
            var interestedFriendship: Bool? = nil
            
            if let statusButtons = statusButtons {
                interestedBusiness = statusButtons.isInterestedInBusiness()
                interestedLove = statusButtons.isInterestedInLove()
                interestedFriendship = statusButtons.isInterestedInFriendship()
            }
            
            if let interestedBusiness = interestedBusiness {
                user["interested_in_business"] = interestedBusiness
            }
            
            if let interestedLove = interestedLove {
                user["interested_in_love"] = interestedLove
            }
            
            if let interestedFriendship = interestedFriendship {
                user["interested_in_friendship"] = interestedFriendship
            }
            
            // save user
            user.saveInBackground(block: { (succeeded, error) in
                if error != nil {
                    print("User save error: \(error)")
                } else if succeeded {
                    print("User saved successfully")
                    
                    // update other users based on current user's interests, if necessary
                    if self.originallyInterestedBusiness != interestedBusiness ||
                        self.originallyInterestedLove != interestedLove ||
                        self.originallyInterestedFriendship != interestedFriendship {
                        print("must change parings because of interested in update")
                        PFCloudFunctions().changeBridgePairingsOnInterestedInUpdate(parameters: [:])
                    }
                } else {
                    print("User did not save successfuly")
                }
            })
            
            // update status of current type based on current text in text view
            if currentStatusType == "Business" {
                if statusPlaceholder || statusTextView.text.isEmpty { // no status
                    businessStatus = nil
                } else {
                    businessStatus = statusTextView.text
                }
            } else if currentStatusType == "Love" {
                if statusPlaceholder || statusTextView.text.isEmpty { // no status
                    loveStatus = nil
                } else {
                    loveStatus = statusTextView.text
                }
            } else if currentStatusType == "Friendship" {
                if statusPlaceholder || statusTextView.text.isEmpty { // no status
                    friendshipStatus = nil
                } else {
                    friendshipStatus = statusTextView.text
                }
            }
            
            updateMyProfileStatuses()
            
            // Adding bridge statuses
            if let businessStatus = businessStatus {
                if businessStatus != localData.getBusinessStatus() {
                    localData.setBusinessStatus(businessStatus)
                    let bridgeStatus = PFObject(className: "BridgeStatus")
                    bridgeStatus["bridge_status"] = businessStatus
                    bridgeStatus["bridge_type"] = "Business"
                    bridgeStatus["userId"] = user.objectId
                    bridgeStatus.saveInBackground(block: { (succeeded, error) in
                        if error != nil {
                            print("BridgeStatus save error: \(error)")
                        } else if succeeded {
                            print("BridgeStatus saved successfully")
                        } else {
                            print("BridgeStatus did not save successfully")
                        }
                    })
                }
            }
            
            if let loveStatus = loveStatus {
                if loveStatus != localData.getLoveStatus() {
                    localData.setLoveStatus(loveStatus)
                    let bridgeStatus = PFObject(className: "BridgeStatus")
                    bridgeStatus["bridge_status"] = loveStatus
                    bridgeStatus["bridge_type"] = "Love"
                    bridgeStatus["userId"] = user.objectId
                    bridgeStatus.saveInBackground(block: { (succeeded, error) in
                        if error != nil {
                            print("BridgeStatus save error: \(error)")
                        } else if succeeded {
                            print("BridgeStatus saved successfully")
                        } else {
                            print("BridgeStatus did not save successfully")
                        }
                    })
                }
            }
            
            if let friendshipStatus = friendshipStatus {
                if friendshipStatus != localData.getFriendshipStatus() {
                    localData.setFriendshipStatus(friendshipStatus)
                    let bridgeStatus = PFObject(className: "BridgeStatus")
                    bridgeStatus["bridge_status"] = friendshipStatus
                    bridgeStatus["bridge_type"] = "Friendship"
                    bridgeStatus["userId"] = user.objectId
                    bridgeStatus.saveInBackground(block: { (succeeded, error) in
                        if error != nil {
                            print("BridgeStatus save error: \(error)")
                        } else if succeeded {
                            print("BridgeStatus saved successfully")
                        } else {
                            print("BridgeStatus did not save successfully")
                        }
                    })
                }
            }
        }
        
        dismiss(animated: false, completion: nil)
    }
    
    func updateMyProfileHexImages() {
        if let hexes = hexes {
            if let myProfileHexes = myProfileVC.hexes {
                myProfileHexes.setImages(hexImages: hexes.getImages())
            }
        }
    }
    
    func updateMyProfileStatuses() {
        if let businessStatus = businessStatus {
            myProfileVC.businessStatus = businessStatus
        }
        if let loveStatus = loveStatus {
            myProfileVC.loveStatus = loveStatus
        }
        if let friendshipStatus = friendshipStatus {
            myProfileVC.friendshipStatus = friendshipStatus
        }
    }
    
    func greetingLabelTapped(_ gesture: UIGestureRecognizer) {
        // update greeting label
        if let index = greetings.index(of: greeting) {
            let newIndex = (index + 1) % greetings.count
            greeting = greetings[newIndex]
        } else {
            greeting = "Hi,"
        }
        if let navBar = navBar {
            if let name = localData.getUsername() {
                let firstName = DisplayUtility.firstName(name: name)
                let greetingText = "\(greeting) I'm \(firstName)."
                navBar.updateMainLabel(mainText: greetingText)
            }
        }
    }
    
    func writeFactsInTextView() {
        if let user = PFUser.current() {
            factsTextView.text = ""
            var facts = [String]()
            
            if selectedFacts.contains("Age") {
                if let age = user["age"] as? Int {
                    facts.append("am \(age)")
                }
            }
            if selectedFacts.contains("City") {
                if let city = user["city"] as? String {
                    if let currentCity = user["current_city"] as? Bool {
                        if currentCity {
                            facts.append("live in \(city)")
                        } else {
                            facts.append("lived in \(city)")
                        }
                    } else {
                        facts.append("lived in \(city)")
                    }
                }
            }
            if selectedFacts.contains("School") {
                if let school = user["school"] as? String {
                    if let currentStudent = user["current_student"] as? Bool {
                        if currentStudent {
                            facts.append("go to \(school)")
                        } else {
                            facts.append("went to \(school)")
                        }
                    } else {
                        facts.append("went to \(school)")
                    }
                }
            }
            if selectedFacts.contains("Work") {
                if let work = user["work"] as? String {
                    if let currentWork = user["current_work"] as? Bool {
                        if currentWork {
                            facts.append("work at \(work)")
                        } else {
                            facts.append("worked at \(work)")
                        }
                    } else {
                        facts.append("worked at \(work)")
                    }
                }
            }
            if selectedFacts.contains("Religion") {
                if let religion = user["religion"] as? String {
                    facts.append("am \(religion)")
                }
            }
            var factsText = ""
            if facts.count > 0 {
                for i in 0..<facts.count {
                    if i == 0 && i == facts.count - 1 {
                        factsText = "I \(facts[i])."
                    }
                    else if i == 0 {
                        factsText = "I \(factsText) \(facts[i]), "
                    } else if i == facts.count - 1 {
                        factsText = "\(factsText) and \(facts[i])."
                    } else {
                        factsText = "\(factsText) \(facts[i]), "
                    }
                }
            } else {
                factsText = "Click to select from available facts and\ndisplay information."
            }
            
            factsTextView.text = factsText
            
            
            DisplayUtility.centerTextVerticallyInTextView(textView: factsTextView)
        }
    }
    
    
    func displayFactsEditor(_ gesture: UIGestureRecognizer) {
        changeAlphaForAllBut(mainView: factsView, superview: view, alphaInc: -0.7)

        UIView.animate(withDuration: 0.5, animations: {
            self.factsBackground.frame = CGRect(x: self.factsBackground.frame.minX, y: self.factsBackground.frame.minY, width: self.factsEditor.frame.width, height: self.factsEditor.frame.height)
            self.factsTextView.alpha = 0
            self.factsEditor.alpha = 1
            self.layoutBottomBasedOnFactsView()
        }, completion: {(finished) in
            if (finished) {
                let clearView1 = UIView()
                clearView1.frame = CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: self.scrollView.frame.minY)
                clearView1.backgroundColor = .clear
                let removeFactsEditorGR1 = UITapGestureRecognizer(target: self, action: #selector(self.removeFactsEditor(_:)))
                clearView1.addGestureRecognizer(removeFactsEditorGR1)
                self.view.addSubview(clearView1)
                self.clearViews.append(clearView1)
                
                let clearView2 = UIView()
                clearView2.frame = CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: self.factsView.frame.minY)
                clearView2.backgroundColor = .clear
                let removeFactsEditorGR2 = UITapGestureRecognizer(target: self, action: #selector(self.removeFactsEditor(_:)))
                clearView2.addGestureRecognizer(removeFactsEditorGR2)
                self.scrollView.addSubview(clearView2)
                self.clearViews.append(clearView2)
                
                let clearView3 = UIView()
                clearView3.frame = CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: self.factsBackground.frame.minY)
                clearView3.backgroundColor = .clear
                let removeFactsEditorGR3 = UITapGestureRecognizer(target: self, action: #selector(self.removeFactsEditor(_:)))
                clearView3.addGestureRecognizer(removeFactsEditorGR3)
                self.factsView.addSubview(clearView3)
                self.clearViews.append(clearView3)
                
                let clearView4 = UIView()
                clearView4.frame = CGRect(x: 0, y: self.factsView.frame.maxY, width: DisplayUtility.screenWidth, height: self.scrollView.contentSize.height - self.factsView.frame.maxY)
                clearView4.backgroundColor = .clear
                let removeFactsEditorGR4 = UITapGestureRecognizer(target: self, action: #selector(self.removeFactsEditor(_:)))
                clearView4.addGestureRecognizer(removeFactsEditorGR4)
                self.scrollView.addSubview(clearView4)
                self.clearViews.append(clearView4)
            }
        })
    }
    
    func removeFactsEditor(_ gesture: UIGestureRecognizer) {
        for clearView in clearViews {
            if clearView == gesture.view {
                clearView.backgroundColor = .magenta
            }
            clearView.removeFromSuperview()
        }
        clearViews.removeAll()
        
        changeAlphaForAllBut(mainView: factsView, superview: view, alphaInc: 0.7)
        
        writeFactsInTextView()
        
        UIView.animate(withDuration: 0.5) {
            self.factsBackground.frame = CGRect(x: self.factsBackground.frame.minX, y: self.factsBackground.frame.minY, width: self.factsTextView.frame.width, height: self.factsTextView.frame.height)
            self.factsEditor.alpha = 0
            self.factsTextView.alpha = 1
            self.layoutBottomBasedOnFactsView()
        }
    }
    
    func changeAlphaForAllBut(mainView: UIView?, superview: UIView, alphaInc: CGFloat) {
        if mainView == superview {
            return
        }
        if let mainView = mainView {
            if mainView.isDescendant(of: superview) {
                for subview in superview.subviews {
                    changeAlphaForAllBut(mainView: mainView, superview: subview, alphaInc: alphaInc)
                }
                return
            }
        }
        superview.alpha += alphaInc
    }
    
    func setUserInteractionForAllBut(mainView: UIView?, superview: UIView, enabled: Bool) {
        if mainView == superview {
            return
        }
        superview.isUserInteractionEnabled = enabled
        for subview in superview.subviews {
            setUserInteractionForAllBut(mainView: mainView, superview: subview, enabled: enabled)
        }
    }
    
    func bubbleSelected(_ sender: UIButton) {
        let selectedImage = UIImage(named: "Profile_Selected_Gray_Bubble")
        let unselectedImage = UIImage(named: "Profile_Unselected_Gray_Bubble")
        if sender.image(for: .normal) == unselectedImage {
            sender.setImage(selectedImage, for: .normal)
            
            if sender == ageBubble {
                selectedFacts.append("Age")
            } else if sender == schoolBubble {
                selectedFacts.append("School")
            } else if sender == religionBubble {
                selectedFacts.append("Religion")
            } else if sender == cityBubble {
                selectedFacts.append("City")
            } else if sender == workBubble {
                selectedFacts.append("Work")
            }
        } else {
            sender.setImage(unselectedImage, for: .normal)
            
            if sender == ageBubble {
                selectedFacts = selectedFacts.filter {$0 != "Age"}
            } else if sender == schoolBubble {
                selectedFacts = selectedFacts.filter {$0 != "School"}
            } else if sender == religionBubble {
                selectedFacts = selectedFacts.filter {$0 != "Religion"}
            } else if sender == cityBubble {
                selectedFacts = selectedFacts.filter {$0 != "City"}
            } else if sender == workBubble {
                selectedFacts = selectedFacts.filter {$0 != "Work"}
            }
        }
    }
    
    func selectType(type: String?) {
        
        // update status of current type based on current text in text view
        if currentStatusType == "Business" {
            if statusPlaceholder || statusTextView.text.isEmpty { // no status
                noBusinessStatus = true
                businessStatus = nil
            } else {
                noBusinessStatus = false
                businessStatus = statusTextView.text
            }
        } else if currentStatusType == "Love" {
            if statusPlaceholder || statusTextView.text.isEmpty { // no status
                noLoveStatus = true
                loveStatus = nil
            } else {
                noLoveStatus = false
                loveStatus = statusTextView.text
            }
        } else if currentStatusType == "Friendship" {
            if statusPlaceholder || statusTextView.text.isEmpty { // no status
                noFriendshipStatus = true
                friendshipStatus = nil
            } else {
                noFriendshipStatus = false
                friendshipStatus = statusTextView.text
            }
        }
        
        // stop editing textViews
        view.endEditing(true)
        
        currentStatusType = type
        
        if let type = type {
            statusTextView.isEditable = true
            currentStatusType = type
            var runQuery = false
            if type == "Business" {
                if noBusinessStatus {
                    setStatusPlaceholder()
                } else if let businessStatus = businessStatus {
                    statusPlaceholder = false
                    statusTextView.text = businessStatus
                } else {
                    statusPlaceholder = false
                    runQuery = true
                }
            } else if type == "Love" {
                if noLoveStatus {
                    setStatusPlaceholder()
                } else if let loveStatus = loveStatus {
                    statusPlaceholder = false
                    statusTextView.text = loveStatus
                } else {
                    statusPlaceholder = false
                    runQuery = true
                }
            } else if type == "Friendship" {
                if noFriendshipStatus {
                    setStatusPlaceholder()
                } else if let friendshipStatus = friendshipStatus {
                    statusPlaceholder = false
                    statusTextView.text = friendshipStatus
                } else {
                    statusPlaceholder = false
                    runQuery = true
                }
            }
            
            if runQuery {
                print ("running BridgeStatus query")
                if let user = PFUser.current() {
                    if let objectId = user.objectId {
                        let query = PFQuery(className: "BridgeStatus")
                        query.whereKey("userId", equalTo: objectId)
                        query.whereKey("bridge_type", equalTo: type)
                        query.order(byDescending: "updatedAt")
                        query.limit = 1
                        query.findObjectsInBackground(block: { (results, error) in
                            if let error = error {
                                print("error - find objects in background - \(error)")
                            } else if let results = results {
                                if results.count > 0 {
                                    let result = results[0]
                                    if let bridgeStatus = result["bridge_status"] as? String {
                                        self.statusTextView.text = bridgeStatus
                                        if type == "Business" {
                                            self.businessStatus = bridgeStatus
                                            //self.localData.setBusinessStatus(bridgeStatus)
                                        } else if type == "Love" {
                                            self.loveStatus = bridgeStatus
                                            //self.localData.setLoveStatus(bridgeStatus)
                                        } else if type == "Friendship" {
                                            self.friendshipStatus = bridgeStatus
                                            //self.localData.setFriendshipStatus(bridgeStatus)
                                        }
                                        //self.localData.synchronize()
                                    }
                                } else {
                                    print("no status")
                                    if type == "Business" {
                                        self.noBusinessStatus = true
                                    } else if type == "Love" {
                                        self.noLoveStatus = true
                                    } else if type == "Friendship" {
                                        self.noFriendshipStatus = true
                                    }
                                    self.setStatusPlaceholder()
                                }
                            } else {
                                print("no status")
                                if type == "Business" {
                                    self.noBusinessStatus = true
                                } else if type == "Love" {
                                    self.noLoveStatus = true
                                } else if type == "Friendship" {
                                    self.noFriendshipStatus = true
                                }
                                self.setStatusPlaceholder()
                            }
                            // realign text in status text view to center
                            self.statusTextView.textAlignment = .center
                            DisplayUtility.centerTextVerticallyInTextView(textView: self.statusTextView)
                        })
                    }
                }
            } else {
                // realign text in status text view to center
                statusTextView.textAlignment = .center
                DisplayUtility.centerTextVerticallyInTextView(textView: statusTextView)
            }
        } else { // type is nil
            statusTextView.isEditable = false
            statusTextView.text = "Click an icon above to edit current requests."
            statusTextView.textAlignment = .center
            DisplayUtility.centerTextVerticallyInTextView(textView: statusTextView)
        }
    }

    // Remove placeholder
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.textAlignment = .left
        DisplayUtility.topAlignTextVerticallyInTextView(textView: textView)
        if textView == quickUpdateTextView && quickUpdatePlaceholder {
            textView.text = nil
            quickUpdatePlaceholder = false
        } else if textView == statusTextView && statusPlaceholder {
            textView.text = nil
            statusPlaceholder = false
        }
    }
    
    // Add back placeholder
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if textView == quickUpdateTextView {
                textView.text = "What have you been up to recently?\nWhat are your plans for the near future?"
                quickUpdatePlaceholder = true
            } else if textView == statusTextView {
                setStatusPlaceholder()
            }
        }
        textView.textAlignment = .center
        DisplayUtility.centerTextVerticallyInTextView(textView: textView)
    }
    
    func setStatusPlaceholder() {
        var statusTypeStr: String?
        if currentStatusType == "Business" {
            statusTypeStr = "work"
        } else if currentStatusType == "Love" {
            statusTypeStr = "dating"
        } else if currentStatusType == "Friendship" {
            statusTypeStr = "friendship"
        }
        if let statusTypeStr = statusTypeStr {
            statusTextView.text = "Edit and save to post your first \(statusTypeStr) request."
            statusPlaceholder = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func endEditing(_ gesture: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    // scroll scroll view when keyboard shows
    func keyboardWillShow(_ notification:NSNotification) {
        print("keyboard will show")
        if let userInfo = notification.userInfo {
            // get keyboard frame
            var keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            keyboardFrame = view.convert(keyboardFrame, from: nil)
            
            // update content inset of scroll view
            scrollView.contentInset.bottom = keyboardFrame.height
            
            // update content offset of scroll view
            scrollView.contentOffset.y = scrollView.contentOffset.y + keyboardFrame.height
        }
    }
    
    // scroll scroll view when keyboard hides
    func keyboardWillHide(_ notification:NSNotification){
        if let userInfo = notification.userInfo {
            // get keyboard frame
            var keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            keyboardFrame = view.convert(keyboardFrame, from: nil)
        
            // reset content offset of scroll view
            scrollView.contentOffset.y = scrollView.contentOffset.y - keyboardFrame.height
            
            // reset content inset of scroll view
            scrollView.contentInset = UIEdgeInsets.zero
        }
    }
    
}
