//
//  SignupViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 1/17/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit

class SignupViewController: UIViewController, UITextViewDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var tempSeguedFrom = ""
    var seguedTo = ""
    var seguedFrom = ""
    
    let localData = LocalData()
    let transitionManager = TransitionManager()
    
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
    let uploadMenu = UIView()
    let imagePicker = UIImagePickerController()
    
    // boolean flags
    var statusPlaceholder = true
    
    // data
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        scrollView.backgroundColor = .clear
        let scrollViewEndEditingGR = UITapGestureRecognizer(target: self, action: #selector(endEditing(_:)))
        scrollView.addGestureRecognizer(scrollViewEndEditingGR)
        view.addSubview(scrollView)
        
        if let user = PFUser.current() {
            
            // Creating greeting label
            greetingLabel.textColor = .black
            greetingLabel.textAlignment = .center
            greetingLabel.font = UIFont(name: "BentonSans-Light", size: 21)
            updateGreetingLabel()
            view.addSubview(greetingLabel)
            
            // Creating editing label
            editingLabel.textColor = .gray
            editingLabel.textAlignment = .center
            editingLabel.font = UIFont(name: "BentonSans-Light", size: 12)
            editingLabel.text = "YOU CAN ALWAYS UPDATE YOUR PROFILE LATER"
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
             let downloader = Downloader()
             
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
            for hexView in hexViews {
                hexView.setBackgroundColor(color: DisplayUtility.defaultHexBackgroundColor)
            }
            if let profilePics = user["profile_pictures"] as? [PFFile] {
                for i in 0..<hexViews.count {
                    if profilePics.count > i {
                        profilePics[i].getDataInBackground(block: { (data, error) in
                            if error != nil {
                                print(error!)
                            } else {
                                if let data = data {
                                    if let image = UIImage(data: data) {
                                        hexViews[i].setBackgroundImage(image: image)
                                        let hexViewGR = UITapGestureRecognizer(target: self, action: #selector(self.profilePicSelected(_:)))
                                        hexViews[i].addGestureRecognizer(hexViewGR)
                                    }
                                }
                                
                            }
                        })
                    }
                }
            }
            
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
                if interestedBusiness {
                    businessVisibilityButton.setImage(UIImage(named: "Profile_Selected_Work_Bubble"), for: .normal)
                } else {
                    businessVisibilityButton.setImage(UIImage(named: "Profile_Unselected_Work_Bubble"), for: .normal)
                }
            } else {
                businessVisibilityButton.setImage(UIImage(named: "Profile_Unselected_Work_Bubble"), for: .normal)
            }
            
            if let interestedLove = user["interested_in_love"] as? Bool {
                if interestedLove {
                    loveVisibilityButton.setImage(UIImage(named: "Profile_Selected_Dating_Bubble"), for: .normal)
                } else {
                    loveVisibilityButton.setImage(UIImage(named: "Profile_Unselected_Dating_Bubble"), for: .normal)
                }
            } else {
                loveVisibilityButton.setImage(UIImage(named: "Profile_Unselected_Dating_Bubble"), for: .normal)
            }
            
            if let interestedFriendship = user["interested_in_friendship"] as? Bool {
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
            
            businessVisibilityButton.frame = CGRect(x: 0, y: visibilityLabel.frame.maxY + 0.01*DisplayUtility.screenHeight, width: visibilityButtonWidth, height: visibilityButtonHeight)
            businessVisibilityButton.addTarget(self, action: #selector(visibilityButtonSelected(_:)), for: .touchUpInside)
            statusView.addSubview(businessVisibilityButton)
            
            loveVisibilityButton.frame = CGRect(x: 0, y: businessVisibilityButton.frame.minY, width: visibilityButtonWidth, height: visibilityButtonHeight)
            loveVisibilityButton.addTarget(self, action: #selector(visibilityButtonSelected(_:)), for: .touchUpInside)
            statusView.addSubview(loveVisibilityButton)
            
            friendshipVisibilityButton.frame = CGRect(x: 0, y: businessVisibilityButton.frame.minY, width: visibilityButtonWidth, height: visibilityButtonHeight)
            friendshipVisibilityButton.addTarget(self, action: #selector(visibilityButtonSelected(_:)), for: .touchUpInside)
            statusView.addSubview(friendshipVisibilityButton)
            
            let line = DisplayUtility.gradientLine(minY: businessVisibilityButton.frame.maxY + 0.02*DisplayUtility.screenHeight, width: 0.8*DisplayUtility.screenWidth)
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
            statusTextView.frame = CGRect(x: 0, y: businessStatusButton.frame.maxY + 0.02*DisplayUtility.screenHeight, width: 0.85733*DisplayUtility.screenWidth, height: 0.208*DisplayUtility.screenWidth)
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
            
            statusView.frame = CGRect(x: 0, y: bottomHexView.frame.maxY, width: DisplayUtility.screenWidth, height: statusTextView.frame.maxY)
            scrollView.addSubview(statusView)
            
            let saveButtonWidth = 0.45*DisplayUtility.screenWidth
            let saveButtonHeight = 0.2063*saveButtonWidth
            let saveButtonFrame = CGRect(x: 0, y: statusView.frame.maxY + 0.01*DisplayUtility.screenHeight, width: saveButtonWidth, height: saveButtonHeight)
            saveButton = DisplayUtility.gradientButton(frame: saveButtonFrame, text: "VIEW TUTORIAL", textColor: UIColor.black, fontSize: 15.5)
            saveButton.layer.borderWidth = 2.0
            saveButton.layer.borderColor = DisplayUtility.gradientColor(size: saveButton.frame.size).cgColor
            saveButton.center.x = DisplayUtility.screenWidth / 2
            DisplayUtility.centerTextVerticallyInButton(button: saveButton)
            saveButton.addTarget(self, action: #selector(save(_:)), for: .touchUpInside)
            scrollView.addSubview(saveButton)
            
            layoutBottomBasedOnFactsView()
        }
    }
    
    func layoutBottomBasedOnFactsView() {
        statusView.frame = CGRect(x: 0, y: bottomHexView.frame.maxY + 0.045*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: statusTextView.frame.maxY)
        let saveButtonWidth = 0.45*DisplayUtility.screenWidth
        let saveButtonHeight = 0.2063*saveButtonWidth
        saveButton.frame = CGRect(x: 0, y: statusView.frame.maxY + 0.02*DisplayUtility.screenHeight, width: saveButtonWidth, height: saveButtonHeight)
        saveButton.center.x = DisplayUtility.screenWidth / 2
        scrollView.contentSize = CGSize(width: DisplayUtility.screenWidth, height: saveButton.frame.maxY + 0.02*DisplayUtility.screenHeight)
    }
    
    func exit(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    func save(_ sender: UIButton) {
        view.endEditing(true)
        if let user = PFUser.current() {
            
            user["interested_in_business"] =
                businessVisibilityButton.image(for: .normal) == UIImage(named: "Profile_Selected_Work_Bubble")
            user["interested_in_love"] =
                loveVisibilityButton.image(for: .normal) == UIImage(named: "Profile_Selected_Dating_Bubble")
            user["interested_in_friendship"] =
                friendshipVisibilityButton.image(for: .normal) == UIImage(named: "Profile_Selected_Friends_Bubble")
            
            user.saveInBackground(block: { (succeeded, error) in
                if error != nil {
                    print("User save error: \(error)")
                } else if succeeded {
                    print("User saved successfully")
                    let pfCloudFunctions = PFCloudFunctions()
                    pfCloudFunctions.changeBridgePairingsOnInterestedInUpdate(parameters: [:])
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
            
            // Adding bridge statuses
            if let businessStatus = businessStatus {
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
            
            if let loveStatus = loveStatus {
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
            
            if let friendshipStatus = friendshipStatus {
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
        performSegue(withIdentifier: "showTutorial", sender: self)
    }
    
    func updateGreetingLabel() {
        if let name = localData.getUsername() {
            let firstName = DisplayUtility.firstName(name: name)
            greetingLabel.text = "Hi \(firstName). Welcome!"
            greetingLabel.sizeToFit()
            greetingLabel.frame = CGRect(x: 0, y: 0.07969*DisplayUtility.screenHeight, width: greetingLabel.frame.width, height: greetingLabel.frame.height)
            greetingLabel.center.x = DisplayUtility.screenWidth / 2
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
    
    func profilePicSelected(_ gesture: UIGestureRecognizer) {
        if let hexView = gesture.view as? HexagonView {
            if let hexBackgroundImage = hexView.hexBackgroundImage {
                let newHexView = HexagonView()
                newHexView.frame = CGRect(x: hexView.frame.minX, y: scrollView.frame.minY - scrollView.contentOffset.y + hexView.frame.minY, width: hexView.frame.width, height: hexView.frame.height)
                newHexView.setBackgroundImage(image: hexBackgroundImage)
                newHexView.addBorder(width: 1, color: .black)
                
                var images = [UIImage]()
                var originalHexFrames = [CGRect]()
                var startingIndex = 0
                let hexViews = [leftHexView, topHexView, rightHexView, bottomHexView]
                for i in 0..<hexViews.count {
                    if let image = hexViews[i].hexBackgroundImage {
                        images.append(image)
                    }
                    let frame = CGRect(x: hexViews[i].frame.minX, y: hexViews[i].frame.minY + scrollView.frame.minY - scrollView.contentOffset.y, width: hexViews[i].frame.width, height: hexViews[i].frame.height)
                    originalHexFrames.append(frame)
                    if hexViews[i] == hexView {
                        startingIndex = i
                    }
                }
                let profilePicsView = ProfilePicturesView(images: images, originalHexFrames: originalHexFrames, hexViews: hexViews, startingIndex: startingIndex, shouldShowEditButtons: true, parentVC: self)
                self.view.addSubview(profilePicsView)
                profilePicsView.animateIn()
            } else if leftHexView.hexBackgroundImage == nil { // no images
                uploadMenu.frame = CGRect(x: 0, y: DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight)
                uploadMenu.center.x = DisplayUtility.screenWidth / 2
                uploadMenu.backgroundColor = .white
                view.addSubview(uploadMenu)
                
                // add gesture recognizer to hide upload menu
                let hideUploadMenuGR = UITapGestureRecognizer(target: self, action: #selector(hideUploadMenu(_:)))
                uploadMenu.addGestureRecognizer(hideUploadMenuGR)
                
                let uploadButtonWidth = 0.66*DisplayUtility.screenWidth
                let uploadButtonHeight = 0.14*DisplayUtility.screenWidth
                
                // layout upload from Facebook button
                let uploadFromFBButton = UIButton()
                uploadFromFBButton.frame = CGRect(x: 0, y: 0, width: uploadButtonWidth, height: uploadButtonHeight)
                uploadFromFBButton.center.x = uploadMenu.frame.width / 2
                uploadFromFBButton.center.y = 0.4*uploadMenu.frame.height
                uploadFromFBButton.setTitle("UPLOAD FROM FACEBOOK", for: .normal)
                uploadFromFBButton.setTitleColor(.black, for: .normal)
                uploadFromFBButton.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 13)
                uploadFromFBButton.titleLabel?.textAlignment = .center
                uploadFromFBButton.layer.borderWidth = 1
                uploadFromFBButton.layer.borderColor = UIColor.gray.cgColor
                uploadFromFBButton.layer.cornerRadius = 0.3*uploadFromFBButton.frame.height
                
                // add target to upload from Facebook button
                uploadFromFBButton.addTarget(self, action: #selector(uploadFromFB(_:)), for: .touchUpInside)
                
                uploadMenu.addSubview(uploadFromFBButton)
                
                // layout upload from camera roll button
                let uploadFromCameraRollButton = UIButton()
                uploadFromCameraRollButton.frame = CGRect(x: 0, y: 0, width: uploadButtonWidth, height: uploadButtonHeight)
                uploadFromCameraRollButton.center.x = uploadMenu.frame.width / 2
                uploadFromCameraRollButton.center.y = 0.6*uploadMenu.frame.height
                uploadFromCameraRollButton.setTitle("UPLOAD FROM CAMERA ROLL", for: .normal)
                uploadFromCameraRollButton.setTitleColor(.black, for: .normal)
                uploadFromCameraRollButton.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 13)
                uploadFromCameraRollButton.titleLabel?.textAlignment = .center
                uploadFromCameraRollButton.layer.borderWidth = 1
                uploadFromCameraRollButton.layer.borderColor = UIColor.gray.cgColor
                uploadFromCameraRollButton.layer.cornerRadius = 0.3*uploadFromCameraRollButton.frame.height
                uploadMenu.addSubview(uploadFromCameraRollButton)
                
                // add target to upload from camera roll button
                uploadFromCameraRollButton.addTarget(self, action: #selector(uploadFromCameraRoll(_:)), for: .touchUpInside)
                
                UIView.animate(withDuration: 0.5) {
                    self.uploadMenu.frame = self.view.bounds
                }
            }
        }
    }
    
    func uploadFromFB(_ button: UIButton) {
        uploadMenu.removeFromSuperview()
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name"])
        graphRequest?.start{ (_, result, error) -> Void in
            if error != nil {
                print(error!)
            }
            else if let result = result as? [String: AnyObject]{
                let userId = result["id"]! as! String
                let facebookProfilePictureUrl = "https://graph.facebook.com/" + userId + "/picture?type=large"
                if let fbpicUrl = URL(string: facebookProfilePictureUrl) {
                    if let data = try? Data(contentsOf: fbpicUrl) {
                        DispatchQueue.main.async(execute: {
                            if let image = UIImage(data: data) {
                                self.leftHexView.setBackgroundImage(image: image)
                            }
                            if let user = PFUser.current() {
                                if let picFile = PFFile(data: data) {
                                    user["profile_pictures"] = [picFile]
                                    user.saveInBackground()
                                }
                            }
                        })
                    }
                }
            }
        }
    }
    
    func uploadFromCameraRoll(_ button: UIButton) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    //update the UIImageView once an image has been picked
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        uploadMenu.removeFromSuperview()
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            leftHexView.setBackgroundImage(image: image)
            if let data = UIImageJPEGRepresentation(image, 1.0) {
                if let user = PFUser.current() {
                    if let picFile = PFFile(data: data) {
                        user["profile_pictures"] = [picFile]
                        user.saveInBackground()
                    }
                }
            }
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func hideUploadMenu(_ gesture: UIGestureRecognizer) {
        UIView.animate(withDuration: 0.5, animations: {
            self.uploadMenu.frame = CGRect(x: 0, y: DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight)
        }) { (finished) in
            if finished {
                self.uploadMenu.removeFromSuperview()
            }
        }
    }
    
    // Remove placeholder
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.textAlignment = .left
        DisplayUtility.topAlignTextVerticallyInTextView(textView: textView)
        if statusPlaceholder {
            textView.text = nil
            statusPlaceholder = false
        }
    }
    
    // Add back placeholder
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            setStatusPlaceholder()
        }
        textView.textAlignment = .center
        DisplayUtility.centerTextVerticallyInTextView(textView: textView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func endEditing(_ gesture: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    //Setting segue transition information and preparation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination
        let mirror = Mirror(reflecting: vc)
        if mirror.subjectType == TutorialsViewController.self {
            self.transitionManager.animationDirection = "Right"
        }
        vc.transitioningDelegate = self.transitionManager
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
