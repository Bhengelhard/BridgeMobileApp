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
    var navBar: ProfileNavBar?
    var hexes: ProfileHexagons?
    let statusView = UIView()
    var statusButtons: ProfileStatusButtons?
    let businessVisibilityButton = UIButton()
    let loveVisibilityButton = UIButton()
    let friendshipVisibilityButton = UIButton()
    let businessStatusButton = UIButton()
    let loveStatusButton = UIButton()
    let friendshipStatusButton = UIButton()
    let statusTextView = UITextView()
    var viewTutorialButton = UIButton()
    
    // boolean flags
    var statusPlaceholder = true
    
    // data
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
    
    func lblTapped() {
    }
    
    func tappedOutside() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set background color to white
        view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        if let user = PFUser.current() {
            
            
            // MARK: Navigation Bar
            
            // set text for greeting label
            var greetingText = String()
            if let name = localData.getUsername() {
                let firstName = DisplayUtility.firstName(name: name)
                greetingText = "Hi \(firstName). Welcome!"
            }
            
            // initialize navigation bar
            navBar = ProfileNavBar(leftButtonImageView: nil, rightButtonImageView: nil, mainText: greetingText, mainTextColor: .black, subText: "YOU CAN ALWAYS UPDATE YOUR PROFILE LATER", subTextColor: .gray)
            view.addSubview(navBar!)
            
            
            // MARK: Scroll View
            
            scrollView.backgroundColor = .clear
            let scrollViewEndEditingGR = UITapGestureRecognizer(target: self, action: #selector(endEditing(_:)))
            scrollView.addGestureRecognizer(scrollViewEndEditingGR)
            
            // place scroll view below navigation bar
            scrollView.frame = CGRect(x: 0, y: navBar!.frame.maxY, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight - navBar!.frame.maxY)
            view.addSubview(scrollView)
            
            
            // MARK: Profile Picture Hexagons
            
            // initialize hexes
            hexes = ProfileHexagons(minY: 0, parentVC: self, hexImages: [], shouldShowDefaultFrame: true, shouldBeEditable: true)
            scrollView.addSubview(hexes!)
            
            // add images for hexes
            if let profilePics = user["profile_pictures"] as? [PFFile] {
                hexes!.addHexImages(from: profilePics, startingAt: 0)
            }
            
            
            // MARK: Statuses
            
            let visibilityLabel = UILabel()
            visibilityLabel.text = "SHOW MY PROFILE FOR"
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
            
            let businessVisible = originallyInterestedBusiness ?? true
            let loveVisible = originallyInterestedLove ?? true
            let friendshipVisible = originallyInterestedFriendship ?? true
            
            statusButtons = ProfileStatusButtons(minY: visibilityLabel.frame.maxY + 0.03*DisplayUtility.screenHeight, selectType: selectType, shouldShowVisibilityButtons: true, businessVisible: businessVisible, loveVisible: loveVisible, friendshipVisible: friendshipVisible)
            statusView.addSubview(statusButtons!)
            
            statusTextView.isEditable = false
            statusTextView.frame = CGRect(x: 0, y: statusButtons!.frame.maxY + 0.02*DisplayUtility.screenHeight, width: 0.85733*DisplayUtility.screenWidth, height: 0.208*DisplayUtility.screenWidth)
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
            
            statusView.frame = CGRect(x: 0, y: hexes!.frame.maxY + 0.045*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: statusTextView.frame.maxY)
            scrollView.addSubview(statusView)
            
            
            // MARK: View Tutorial Button
            
            let viewTutorialButtonWidth = 0.45*DisplayUtility.screenWidth
            let viewTutorialButtonHeight = 0.2063*viewTutorialButtonWidth
            let viewTutorialButtonFrame = CGRect(x: 0, y: statusView.frame.maxY + 0.01*DisplayUtility.screenHeight, width: viewTutorialButtonWidth, height: viewTutorialButtonHeight)
            viewTutorialButton = DisplayUtility.gradientButton(frame: viewTutorialButtonFrame, text: "VIEW TUTORIAL", textColor: UIColor.black, fontSize: 15.5)
            viewTutorialButton.layer.borderWidth = 2.0
            viewTutorialButton.layer.borderColor = DisplayUtility.gradientColor(size: viewTutorialButton.frame.size).cgColor
            viewTutorialButton.center.x = DisplayUtility.screenWidth / 2
            DisplayUtility.centerTextVerticallyInButton(button: viewTutorialButton)
            viewTutorialButton.addTarget(self, action: #selector(save(_:)), for: .touchUpInside)
            scrollView.addSubview(viewTutorialButton)
            
            scrollView.contentSize = CGSize(width: DisplayUtility.screenWidth, height: max(scrollView.frame.height, viewTutorialButton.frame.maxY + 0.02*DisplayUtility.screenHeight))
        }
    }
    
    func exit(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    func save(_ sender: UIButton) {
        view.endEditing(true)
        if let user = PFUser.current() {
            
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
            
            // Unselect current status button (and save status, accordingly)
            if let statusButtons = statusButtons {
                statusButtons.unselectAllStatusButtons()
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
