//
//  EditProfileViewController.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 1/11/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Foundation
import UIKit
import Parse

class EditProfileViewController: UIViewController, UITextViewDelegate, UIGestureRecognizerDelegate {
    
    var tempSeguedFrom = ""
    var seguedTo = ""
    var seguedFrom = ""
    
    let localData = LocalData()
    
    // views
    let scrollView = UIScrollView()
    let exitButton = UIButton()
    let checkButton = UIButton()
    let greetingLabel = UILabel()
    let editingLabel = UILabel()
    let topHexView = HexagonView()
    let leftHexView = HexagonView()
    let rightHexView = HexagonView()
    let bottomHexView = HexagonView()
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
    let businessVisibilityButton = UIButton()
    let loveVisibilityButton = UIButton()
    let friendshipVisibilityButton = UIButton()
    let businessStatusButton = UIButton()
    let loveStatusButton = UIButton()
    let friendshipStatusButton = UIButton()
    let statusTextView = UITextView()
    var saveButton = UIButton()
    
    // boolean flags
    var quickUpdatePlaceholder = true
    var statusPlaceholder = true
    
    // data
    var originallyInterestedBusiness: Bool?
    var originallyInterestedLove: Bool?
    var originallyInterestedFriendship: Bool?
    var greeting = "Hi,"
    var greetings = ["Hi,", "What's Up?", "Hello there,"]
    var leftHexImage: UIImage?
    var topHexImage: UIImage?
    var rightHexImage: UIImage?
    var bottomHexImage: UIImage?
    var selectedFacts = [String]()
    var businessStatus: String?
    var loveStatus: String?
    var friendshipStatus: String?
    var noBusinessStatus = false
    var noLoveStatus = false
    var noFriendshipStatus = false
    var currentStatusType: String?
    
    func lblTapped() {
    }
    
    func tappedOutside() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        scrollView.backgroundColor = .clear
        let scrollViewEndEditingGR = UITapGestureRecognizer(target: self, action: #selector(endEditing(_:)))
        scrollView.addGestureRecognizer(scrollViewEndEditingGR)
        view.addSubview(scrollView)
        
        if let user = PFUser.current() {
            
            // Creating viewed exit icon
            let xIcon = UIImageView(frame: CGRect(x: 0.044*DisplayUtility.screenWidth, y: 0.04384*DisplayUtility.screenHeight, width: 0.03514*DisplayUtility.screenWidth, height: 0.03508*DisplayUtility.screenWidth))
            xIcon.image = UIImage(named: "Black_X")
            view.addSubview(xIcon)
            
            // Creating larger clickable space around exit icon
            exitButton.frame = CGRect(x: xIcon.frame.minX - 0.02*DisplayUtility.screenWidth, y: xIcon.frame.minY - 0.02*DisplayUtility.screenWidth, width: xIcon.frame.width + 0.04*DisplayUtility.screenWidth, height: xIcon.frame.height + 0.04*DisplayUtility.screenWidth)
            exitButton.showsTouchWhenHighlighted = false
            exitButton.addTarget(self, action: #selector(exit(_:)), for: .touchUpInside)
            view.addSubview(exitButton)
            
            // Creating viewed check icon
            let checkIcon = UIImageView(frame: CGRect(x: DisplayUtility.screenWidth - xIcon.frame.minX - 0.05188*DisplayUtility.screenWidth, y: 0, width: 0.05188*DisplayUtility.screenWidth, height: 0.03698*DisplayUtility.screenWidth))
            checkIcon.center.y = xIcon.center.y
            checkIcon.image = UIImage(named: "Gradient_Check")
            view.addSubview(checkIcon)
            
            // Creating larger clickable space around check icon
            checkButton.frame = CGRect(x: checkIcon.frame.minX - 0.02*DisplayUtility.screenWidth, y: checkIcon.frame.minY - 0.02*DisplayUtility.screenWidth, width: checkIcon.frame.width + 0.04*DisplayUtility.screenWidth, height: checkIcon.frame.height + 0.04*DisplayUtility.screenWidth)
            checkButton.showsTouchWhenHighlighted = false
            checkButton.addTarget(self, action: #selector(save(_:)), for: .touchUpInside)
            view.addSubview(checkButton)
            
            // Creating greeting label
            greetingLabel.textColor = .gray
            greetingLabel.textAlignment = .center
            greetingLabel.font = UIFont(name: "BentonSans-Light", size: 21)
            if let userGreeting = user["profile_greeting"] as? String {
                greeting = userGreeting
            }
            updateGreetingLabel()
            view.addSubview(greetingLabel)
            
            // Adding gesture recognizer to greeting label
            greetingLabel.isUserInteractionEnabled = true
            let greetingGR = UITapGestureRecognizer(target: self, action: #selector(greetingLabelTapped(_:)))
            greetingLabel.addGestureRecognizer(greetingGR)
            
            // Creating editing label
            editingLabel.textColor = .black
            editingLabel.textAlignment = .center
            editingLabel.font = UIFont(name: "BentonSans-Light", size: 12)
            editingLabel.text = "EDITING PROFILE"
            editingLabel.sizeToFit()
            editingLabel.frame = CGRect(x: 0, y: greetingLabel.frame.maxY + 0.0075*DisplayUtility.screenHeight, width: editingLabel.frame.width, height: editingLabel.frame.height)
            editingLabel.center.x = DisplayUtility.screenWidth / 2
            view.addSubview(editingLabel)
            
            // Set up scroll view
            scrollView.frame = CGRect(x: 0, y: greetingLabel.frame.maxY + 0.045*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: 0.955*DisplayUtility.screenHeight - greetingLabel.frame.maxY)
            view.addSubview(scrollView)
            
            scrollView.backgroundColor = .clear
            
            // Profile pictures
            let hexWidth = 0.38154*DisplayUtility.screenWidth
            let hexHeight = hexWidth * sqrt(3) / 2
            
            let downloader = Downloader()
            
            //setting frame and image for topHexView
            topHexView.frame = CGRect(x: 0, y: 0, width: hexWidth, height: hexHeight)
            topHexView.center.x = DisplayUtility.screenWidth / 2
            scrollView.addSubview(topHexView)
            
            let topHexViewGR = UITapGestureRecognizer(target: self, action: #selector(profilePicSelected(_:)))
            topHexView.addGestureRecognizer(topHexViewGR)
            
            //setting frame and image for leftHexView
            leftHexView.frame = CGRect(x: topHexView.frame.minX - 0.75*hexWidth - 3, y: topHexView.frame.midY + 2, width: hexWidth, height: hexHeight)
            let borderColor = DisplayUtility.gradientColor(size: leftHexView.frame.size)
            leftHexView.addBorder(width: 3.0, color: borderColor)
            
            /*
            if let data = localData.getMainProfilePicture() {
                if let image = UIImage(data: data) {
                    self.leftHexView.setBackgroundImage(image: image)
                }
            } else if let urlString = user["profile_picture_url"] as? String, let url = URL(string: urlString) {
                downloader.imageFromURL(URL: url, callBack: { (image) in
                    //self.setImageToHexagon(image: image, hexView: self.leftHexView)
                    self.leftHexView.setBackgroundImage(image: image)
                    //Saviong mainProfilePicture to device if it has not already been saved
                    if let data = UIImageJPEGRepresentation(image, 1.0){
                        self.localData.setMainProfilePicture(data)
                    }
                })
            }
            */
            scrollView.addSubview(leftHexView)
            
            let leftHexViewGR = UITapGestureRecognizer(target: self, action: #selector(profilePicSelected(_:)))
            leftHexView.addGestureRecognizer(leftHexViewGR)
            
            //setting frame for rightHexView
            rightHexView.frame = CGRect(x: topHexView.frame.minX + 0.75*hexWidth + 3, y: topHexView.frame.midY + 2, width: hexWidth, height: hexHeight)
            scrollView.addSubview(rightHexView)
            
            let rightHexViewGR = UITapGestureRecognizer(target: self, action: #selector(profilePicSelected(_:)))
            rightHexView.addGestureRecognizer(rightHexViewGR)
            
            //setting frame for bottomHexView
            bottomHexView.frame = CGRect(x: topHexView.frame.minX, y: topHexView.frame.maxY + 4, width: hexWidth, height: hexHeight)
            scrollView.addSubview(bottomHexView)
            
            let bottomHexViewGR = UITapGestureRecognizer(target: self, action: #selector(profilePicSelected(_:)))
            bottomHexView.addGestureRecognizer(bottomHexViewGR)
            
            let hexViews = [leftHexView, topHexView, rightHexView, bottomHexView]
            let hexImages = [leftHexImage, topHexImage, rightHexImage, bottomHexImage]
            let defaultHexBackgroundColor = UIColor(red: 234/255.0, green: 237/255.0, blue: 239/255.0, alpha: 1)
            for i in 0..<hexViews.count {
                if let image = hexImages[i] {
                    hexViews[i].setBackgroundImage(image: image)
                } else if let profilePics = user["profile_pictures"] as? [PFFile] {
                    if profilePics.count > i {
                        profilePics[i].getDataInBackground(block: { (data, error) in
                            if error != nil {
                                print(error!)
                            } else {
                                if let data = data {
                                    if let image = UIImage(data: data) {
                                        hexViews[i].setBackgroundImage(image: image)
                                    }
                                }
                                
                            }
                        })
                    } else {
                        hexViews[i].setBackgroundColor(color: defaultHexBackgroundColor)
                    }
                } else {
                    hexViews[i].setBackgroundColor(color: defaultHexBackgroundColor)
                }
            }
            
            // Creating "Quick-Update" section
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
            quickUpdateTextView.text = "What have you been up to recently?\nWhat are your plans for the near future?"
            quickUpdateTextView.textColor = .black
            quickUpdateTextView.textAlignment = .center
            quickUpdateTextView.font = UIFont(name: "BentonSans-Light", size: 14)
            DisplayUtility.centerTextVerticallyInTextView(textView: quickUpdateTextView)
            quickUpdateView.addSubview(quickUpdateTextView)
            
            quickUpdateView.frame = CGRect(x: 0, y: bottomHexView.frame.maxY + 0.045*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: quickUpdateTextView.frame.maxY)
            scrollView.addSubview(quickUpdateView)
            
            // Creating "The Facts" section
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
            if user["age"] != nil {
                factsEditor.addSubview(ageBubble)
            }
            
            if selectedFacts.contains("School") {
                schoolBubble.setImage(selectedBubbleImage, for: .normal)
            } else {
                schoolBubble.setImage(unselectedBubbleImage, for: .normal)
            }
            schoolBubble.frame = CGRect(x: ageBubble.frame.minX, y: ageBubble.frame.maxY + 0.06*factsEditor.frame.height, width: bubbleWidth, height: bubbleHeight)
            schoolBubble.addTarget(self, action: #selector(bubbleSelected(_:)), for: .touchUpInside)
            if user["school"] != nil {
                factsEditor.addSubview(schoolBubble)
            }
            
            if selectedFacts.contains("Religion") {
                religionBubble.setImage(selectedBubbleImage, for: .normal)
            } else {
                religionBubble.setImage(unselectedBubbleImage, for: .normal)
            }
            religionBubble.frame = CGRect(x: ageBubble.frame.minX, y: schoolBubble.frame.maxY + 0.06*factsEditor.frame.height, width: bubbleWidth, height: bubbleHeight)
            religionBubble.addTarget(self, action: #selector(bubbleSelected(_:)), for: .touchUpInside)
            if user["religion"] != nil {
                factsEditor.addSubview(religionBubble)
            }
            
            if selectedFacts.contains("City") {
                cityBubble.setImage(selectedBubbleImage, for: .normal)
            } else {
                cityBubble.setImage(unselectedBubbleImage, for: .normal)
            }
            cityBubble.frame = CGRect(x: factsEditor.frame.width - ageBubble.frame.maxX, y: ageBubble.frame.minY, width: bubbleWidth, height: bubbleHeight)
            cityBubble.addTarget(self, action: #selector(bubbleSelected(_:)), for: .touchUpInside)
            if user["city"] != nil {
                factsEditor.addSubview(cityBubble)
            }
            
            if selectedFacts.contains("Work") {
                workBubble.setImage(selectedBubbleImage, for: .normal)
            } else {
                workBubble.setImage(unselectedBubbleImage, for: .normal)
            }
            workBubble.frame = CGRect(x: cityBubble.frame.minX, y: schoolBubble.frame.minY, width: bubbleWidth, height: bubbleHeight)
            workBubble.addTarget(self, action: #selector(bubbleSelected(_:)), for: .touchUpInside)
            if user["work"] != nil {
                factsEditor.addSubview(workBubble)
            }
            
            let labelOffsetFromBubble = 0.03*factsEditor.frame.width
            
            let ageLabel = UILabel()
            ageLabel.text = "AGE"
            ageLabel.textColor = .black
            ageLabel.font = UIFont(name: "BentonSans-Light", size: 15)
            ageLabel.sizeToFit()
            ageLabel.frame = CGRect(x: ageBubble.frame.minX - ageLabel.frame.width - labelOffsetFromBubble, y: 0, width: ageLabel.frame.width, height: ageLabel.frame.height+1)
            ageLabel.center.y = ageBubble.center.y
            factsEditor.addSubview(ageLabel)
            
            let schoolLabel = UILabel()
            schoolLabel.text = "SCHOOL"
            schoolLabel.textColor = .black
            schoolLabel.font = UIFont(name: "BentonSans-Light", size: 15)
            schoolLabel.sizeToFit()
            schoolLabel.frame = CGRect(x: schoolBubble.frame.minX - schoolLabel.frame.width - labelOffsetFromBubble, y: 0, width: schoolLabel.frame.width, height: schoolLabel.frame.height+1)
            schoolLabel.center.y = schoolBubble.center.y
            factsEditor.addSubview(schoolLabel)
            
            let religionLabel = UILabel()
            religionLabel.text = "RELIGION"
            religionLabel.textColor = .black
            religionLabel.font = UIFont(name: "BentonSans-Light", size: 15)
            religionLabel.sizeToFit()
            religionLabel.frame = CGRect(x: religionBubble.frame.minX - religionLabel.frame.width - labelOffsetFromBubble, y: 0, width: religionLabel.frame.width, height: religionLabel.frame.height+1)
            religionLabel.center.y = religionBubble.center.y
            factsEditor.addSubview(religionLabel)
            
            let cityLabel = UILabel()
            cityLabel.text = "CITY"
            cityLabel.textColor = .black
            cityLabel.font = UIFont(name: "BentonSans-Light", size: 15)
            cityLabel.sizeToFit()
            cityLabel.frame = CGRect(x: cityBubble.frame.maxX + labelOffsetFromBubble, y: 0, width: cityLabel.frame.width, height: cityLabel.frame.height+1)
            cityLabel.center.y = cityBubble.center.y
            factsEditor.addSubview(cityLabel)
            
            let workLabel = UILabel()
            workLabel.text = "WORK"
            workLabel.textColor = .black
            workLabel.font = UIFont(name: "BentonSans-Light", size: 15)
            workLabel.sizeToFit()
            workLabel.frame = CGRect(x: workBubble.frame.maxX + labelOffsetFromBubble, y: 0, width: workLabel.frame.width, height: workLabel.frame.height+1)
            workLabel.center.y = workBubble.center.y
            factsEditor.addSubview(workLabel)
            
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
                if interestedBusiness {
                    businessVisibilityButton.setImage(UIImage(named: "Profile_Selected_Work_Bubble"), for: .normal)
                } else {
                    businessVisibilityButton.setImage(UIImage(named: "Profile_Unselected_Work_Bubble"), for: .normal)
                }
            } else {
                businessVisibilityButton.setImage(UIImage(named: "Profile_Unselected_Work_Bubble"), for: .normal)
            }
            
            if let interestedLove = user["interested_in_love"] as? Bool {
                originallyInterestedLove = interestedLove
                if interestedLove {
                    loveVisibilityButton.setImage(UIImage(named: "Profile_Selected_Dating_Bubble"), for: .normal)
                } else {
                    loveVisibilityButton.setImage(UIImage(named: "Profile_Unselected_Dating_Bubble"), for: .normal)
                }
            } else {
                loveVisibilityButton.setImage(UIImage(named: "Profile_Unselected_Dating_Bubble"), for: .normal)
            }
            
            if let interestedFriendship = user["interested_in_friendship"] as? Bool {
                originallyInterestedFriendship = interestedFriendship
                if interestedFriendship {
                    friendshipVisibilityButton.setImage(UIImage(named: "Profile_Selected_Friends_Bubble"), for: .normal)
                } else {
                    friendshipVisibilityButton.setImage(UIImage(named: "Profile_Unselected_Friends_Bubble"), for: .normal)
                }
            } else {
                friendshipVisibilityButton.setImage(UIImage(named: "Profile_Unselected_Friends_Bubble"), for: .normal)
            }
            
            let visibilityButtonWidth = 0.076*DisplayUtility.screenWidth
            let visibilityButtonHeight = visibilityButtonWidth
            
            businessVisibilityButton.frame = CGRect(x: 0, y: visibilityLabel.frame.maxY + 0.03*DisplayUtility.screenHeight, width: visibilityButtonWidth, height: visibilityButtonHeight)
            businessVisibilityButton.addTarget(self, action: #selector(visibilityButtonSelected(_:)), for: .touchUpInside)
            statusView.addSubview(businessVisibilityButton)
            
            loveVisibilityButton.frame = CGRect(x: 0, y: businessVisibilityButton.frame.minY, width: visibilityButtonWidth, height: visibilityButtonHeight)
            loveVisibilityButton.addTarget(self, action: #selector(visibilityButtonSelected(_:)), for: .touchUpInside)
            statusView.addSubview(loveVisibilityButton)
            
            friendshipVisibilityButton.frame = CGRect(x: 0, y: businessVisibilityButton.frame.minY, width: visibilityButtonWidth, height: visibilityButtonHeight)
            friendshipVisibilityButton.addTarget(self, action: #selector(visibilityButtonSelected(_:)), for: .touchUpInside)
            statusView.addSubview(friendshipVisibilityButton)
            
            let line = UIView()
            let gradientLayer = DisplayUtility.getGradient()
            line.backgroundColor = .clear
            line.layer.insertSublayer(gradientLayer, at: 0)
            line.frame = CGRect(x: 0, y: businessVisibilityButton.frame.maxY + 0.02*DisplayUtility.screenHeight, width: 0.8*DisplayUtility.screenWidth, height: 1)
            line.center.x = DisplayUtility.screenWidth / 2
            gradientLayer.frame = line.bounds
            statusView.addSubview(line)
            
            businessStatusButton.setImage(UIImage(named: "Profile_Unselected_Work_Icon"), for: .normal)
            loveStatusButton.setImage(UIImage(named: "Profile_Unselected_Dating_Icon"), for: .normal)
            friendshipStatusButton.setImage(UIImage(named: "Profile_Unselected_Friends_Icon"), for: .normal)
            
            let statusButtonWidth = 0.11159*DisplayUtility.screenWidth
            let statusButtonHeight = statusButtonWidth
            
            businessStatusButton.frame = CGRect(x: 0.17716*DisplayUtility.screenWidth, y: line.frame.maxY + 0.02*DisplayUtility.screenHeight, width: statusButtonWidth, height: statusButtonHeight)
            businessVisibilityButton.center.x = businessStatusButton.center.x
            businessStatusButton.addTarget(self, action: #selector(statusButtonSelected(_:)), for: .touchUpInside)
            statusView.addSubview(businessStatusButton)
            
            loveStatusButton.frame = CGRect(x: 0, y: businessStatusButton.frame.minY, width: statusButtonWidth, height: statusButtonHeight)
            loveStatusButton.center.x = DisplayUtility.screenWidth / 2
            loveVisibilityButton.center.x = loveStatusButton.center.x
            loveStatusButton.addTarget(self, action: #selector(statusButtonSelected(_:)), for: .touchUpInside)
            statusView.addSubview(loveStatusButton)
            
            friendshipStatusButton.frame = CGRect(x: DisplayUtility.screenWidth - businessStatusButton.frame.maxX, y: businessStatusButton.frame.minY, width: statusButtonWidth, height: statusButtonHeight)
            friendshipVisibilityButton.center.x = friendshipStatusButton.center.x
            friendshipStatusButton.addTarget(self, action: #selector(statusButtonSelected(_:)), for: .touchUpInside)
            statusView.addSubview(friendshipStatusButton)
            
            statusTextView.isEditable = false
            statusTextView.frame = CGRect(x: 0, y: businessStatusButton.frame.maxY + 0.03*DisplayUtility.screenHeight, width: 0.85733*DisplayUtility.screenWidth, height: 0.208*DisplayUtility.screenWidth)
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
    
    func setHexImages(leftHexImage: UIImage?, topHexImage: UIImage?, rightHexImage: UIImage?, bottomHexImage: UIImage?) {
        self.leftHexImage = leftHexImage
        self.topHexImage = topHexImage
        self.rightHexImage = rightHexImage
        self.bottomHexImage = bottomHexImage
    }
    
    func layoutBottomBasedOnFactsView() {
        factsView.frame = CGRect(x: 0, y: quickUpdateView.frame.maxY + 0.045*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: factsBackground.frame.maxY)
        statusView.frame = CGRect(x: 0, y: factsView.frame.maxY + 0.045*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: statusTextView.frame.maxY)
        let saveButtonWidth = 0.18266*DisplayUtility.screenWidth
        let saveButtonHeight = 0.4453*saveButtonWidth
        saveButton.frame = CGRect(x: 0, y: statusView.frame.maxY + 0.055*DisplayUtility.screenHeight, width: saveButtonWidth, height: saveButtonHeight)
        saveButton.center.x = DisplayUtility.screenWidth / 2
        scrollView.contentSize = CGSize(width: DisplayUtility.screenWidth, height: saveButton.frame.maxY + 0.02*DisplayUtility.screenHeight)
    }
    
    func exit(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    func save(_ sender: UIButton) {
        view.endEditing(true)
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
            
            let interestedBusiness = businessVisibilityButton.image(for: .normal) == UIImage(named: "Profile_Selected_Work_Bubble")
            user["interested_in_business"] = interestedBusiness
            
            let interestedLove = loveVisibilityButton.image(for: .normal) == UIImage(named: "Profile_Selected_Dating_Bubble")
            user["interested_in_love"] = interestedLove
            
            let interestedFriendship = friendshipVisibilityButton.image(for: .normal) == UIImage(named: "Profile_Selected_Friends_Bubble")
            user["interested_in_friendship"] = interestedFriendship
            
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
                        PFCloudFunctions().changeBridgePairingsOnInterestedInUpdate(parameters: [:])
                    }
                } else {
                    print("User did not save successfuly")
                }
            })
            
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
    
    func greetingLabelTapped(_ gesture: UIGestureRecognizer) {
        if let index = greetings.index(of: greeting) {
            let newIndex = (index + 1) % greetings.count
            greeting = greetings[newIndex]
        } else {
            greeting = "Hi,"
        }
        updateGreetingLabel()
    }
    
    func updateGreetingLabel() {
        if let name = localData.getUsername() {
            let firstName = DisplayUtility.firstName(name: name)
            greetingLabel.text = "\(greeting) I'm \(firstName)."
            greetingLabel.sizeToFit()
            greetingLabel.frame = CGRect(x: 0, y: 0.07969*DisplayUtility.screenHeight, width: greetingLabel.frame.width, height: greetingLabel.frame.height)
            greetingLabel.center.x = DisplayUtility.screenWidth / 2
        }
    }
    
    func writeFactsInTextView() {
        if let user = PFUser.current() {
            factsTextView.text = ""
            var facts = [String]()
            
            if selectedFacts.contains("Age") {
                if let age = user["age"] as? Int {
                    facts.append("I'm \(age)")
                }
            }
            if selectedFacts.contains("City") {
                if let city = user["city"] as? String {
                    if let currentCity = user["current_city"] as? Bool {
                        if currentCity {
                            facts.append("I live in \(city)")
                        } else {
                            facts.append("I lived in \(city)")
                        }
                    } else {
                        facts.append("I lived in \(city)")
                    }
                }
            }
            if selectedFacts.contains("School") {
                if let school = user["school"] as? String {
                    if let currentStudent = user["current_student"] as? Bool {
                        if currentStudent {
                            facts.append("I go to \(school)")
                        } else {
                            facts.append("I went to \(school)")
                        }
                    } else {
                        facts.append("I went to \(school)")
                    }
                }
            }
            if selectedFacts.contains("Work") {
                if let work = user["work"] as? String {
                    if let currentWork = user["current_work"] as? Bool {
                        if currentWork {
                            facts.append("I work at \(work)")
                        } else {
                            facts.append("I worked at \(work)")
                        }
                    } else {
                        facts.append("I worked at \(work)")
                    }
                }
            }
            if selectedFacts.contains("Religion") {
                if let religion = user["religion"] as? String {
                    facts.append("I am \(religion)")
                }
            }
            if facts.count > 0 {
                for i in 0..<facts.count {
                    if i == facts.count - 1 {
                        factsTextView.text = "\(factsTextView.text!) \(facts[i])."
                    } else {
                        factsTextView.text = "\(factsTextView.text!) \(facts[i]),"
                    }
                }
            } else {
                factsTextView.text = "Click to select from available facts and\ndisplay information."
            }
            
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
    
    func visibilityButtonSelected(_ sender: UIButton) {
        var selectedImage: UIImage?
        var unselectedImage: UIImage?
        if sender == businessVisibilityButton {
            selectedImage = UIImage(named: "Profile_Selected_Work_Bubble")
            unselectedImage = UIImage(named: "Profile_Unselected_Work_Bubble")
        } else if sender == loveVisibilityButton {
            selectedImage = UIImage(named: "Profile_Selected_Dating_Bubble")
            unselectedImage = UIImage(named: "Profile_Unselected_Dating_Bubble")
        } else if sender == friendshipVisibilityButton {
            selectedImage = UIImage(named: "Profile_Selected_Friends_Bubble")
            unselectedImage = UIImage(named: "Profile_Unselected_Friends_Bubble")
        }
        
        if let unselectedImage = unselectedImage,
            let selectedImage = selectedImage {
            if sender.image(for: .normal) == unselectedImage {
                sender.setImage(selectedImage, for: .normal)
            } else {
                sender.setImage(unselectedImage, for: .normal)
            }
        }
    }
    
    func statusButtonSelected(_ sender: UIButton) {
        
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
        
        for statusButton in [businessStatusButton, loveStatusButton, friendshipStatusButton] {
            var selectedImage: UIImage?
            var unselectedImage: UIImage?
            if statusButton == businessStatusButton {
                selectedImage = UIImage(named: "Profile_Selected_Work_Icon")
                unselectedImage = UIImage(named: "Profile_Unselected_Work_Icon")
            } else if statusButton == loveStatusButton {
                selectedImage = UIImage(named: "Profile_Selected_Dating_Icon")
                unselectedImage = UIImage(named: "Profile_Unselected_Dating_Icon")
            } else if statusButton == friendshipStatusButton {
                selectedImage = UIImage(named: "Profile_Selected_Friends_Icon")
                unselectedImage = UIImage(named: "Profile_Unselected_Friends_Icon")
            }
            if sender == statusButton {
                if let unselectedImage = unselectedImage,
                    let selectedImage = selectedImage {
                    // selecting unselected type
                    if statusButton.image(for: .normal) == unselectedImage {
                        statusButton.setImage(selectedImage, for: .normal)
                        statusTextView.isEditable = true
                        var runQuery = false
                        if statusButton == businessStatusButton {
                            currentStatusType = "Business"
                            if noBusinessStatus {
                                setStatusPlaceholder()
                            } else if let businessStatus = businessStatus {
                                statusPlaceholder = false
                                statusTextView.text = businessStatus
                            } else {
                                statusPlaceholder = false
                                runQuery = true
                            }
                        } else if statusButton == loveStatusButton {
                            currentStatusType = "Love"
                            if noLoveStatus {
                                setStatusPlaceholder()
                            } else if let loveStatus = loveStatus {
                                statusPlaceholder = false
                                statusTextView.text = loveStatus
                            } else {
                                statusPlaceholder = false
                                runQuery = true
                            }
                        } else if statusButton == friendshipStatusButton {
                            currentStatusType = "Friendship"
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
                                    if let type = currentStatusType {
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
                            }
                        } else {
                            // realign text in status text view to center
                            statusTextView.textAlignment = .center
                            DisplayUtility.centerTextVerticallyInTextView(textView: statusTextView)
                        }
                    } else { // unselecting selected type
                        statusButton.setImage(unselectedImage, for: .normal)
                        currentStatusType = nil
                        statusTextView.isEditable = false
                        statusTextView.text = "Click an icon above to edit current requests."
                        statusTextView.textAlignment = .center
                        DisplayUtility.centerTextVerticallyInTextView(textView: statusTextView)
                    }
                }
            } else {
                if let unselectedImage = unselectedImage {
                    statusButton.setImage(unselectedImage, for: .normal)
                }
            }
        }
    }
    
    func profilePicSelected(_ gesture: UIGestureRecognizer) {
        if let hexView = gesture.view as? HexagonView {
            let newHexView = HexagonView()
            newHexView.frame = CGRect(x: hexView.frame.minX, y: scrollView.frame.minY - scrollView.contentOffset.y + hexView.frame.minY, width: hexView.frame.width, height: hexView.frame.height)
            if let image = hexView.hexBackgroundImage {
                newHexView.setBackgroundImage(image: image)
            } else {
                newHexView.setBackgroundColor(color: hexView.hexBackgroundColor)
            }
            newHexView.addBorder(width: 1, color: .black)
            
            var images = [UIImage]()
            var startingImageIndex = 0
            let hexViews = [leftHexView, topHexView, rightHexView, bottomHexView]
            for i in 0..<hexViews.count {
                if let image = hexViews[i].hexBackgroundImage {
                    images.append(image)
                }
                if hexViews[i] == hexView {
                    startingImageIndex = i
                }
            }
            let profilePicsView = ProfilePicturesView(hexView: newHexView, images: images, startingImageIndex: startingImageIndex, shouldShowEditButtons: true)
            self.view.addSubview(profilePicsView)
            profilePicsView.animate()
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
    
}
