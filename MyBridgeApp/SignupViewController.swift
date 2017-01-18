//
//  SignupViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 1/17/17.
//  Copyright © 2017 Parse. All rights reserved.
//
import Parse

class SignupViewController: UIViewController, UITextViewDelegate, UIGestureRecognizerDelegate {
    
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
    var statusPlaceholder = true
    
    // data
    var greeting = "Hi,"
    var greetings = ["Hi,", "What's Up?", "Hello there,"]
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
            
            // Creating greeting label
            greetingLabel.textColor = .black
            greetingLabel.textAlignment = .center
            greetingLabel.font = UIFont(name: "BentonSans-Light", size: 21)
            if let userGreeting = user["profile_greeting"] as? String {
                greeting = userGreeting
            }
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
            
            let downloader = Downloader()
            
            //setting frame and image for topHexView
            topHexView.frame = CGRect(x: 0, y: 0, width: hexWidth, height: hexHeight)
            topHexView.center.x = DisplayUtility.screenWidth / 2
            
            //Setting static profile images for tech Demo
            let image1 = #imageLiteral(resourceName: "ProfPic2.jpg")
            //setImageToHexagon(image: image1, hexView: topHexView)
            topHexView.setBackgroundImage(image: image1)
            
            //            if let data = localData.getMainProfilePicture() {
            //                if let image = UIImage(data: data) {
            //                    setImageToHexagon(image: image, hexView: topHexView)
            //                }
            //            } else if let urlString = user["profile_picture_url"] as? String, let url = URL(string: urlString) {
            //                downloader.imageFromURL(URL: url, callBack: { (image) in
            //                    self.setImageToHexagon(image: image, hexView: self.topHexView)
            //                })
            //            }
            scrollView.addSubview(topHexView)
            
            let topHexViewGR = UITapGestureRecognizer(target: self, action: #selector(profilePicSelected(_:)))
            topHexView.addGestureRecognizer(topHexViewGR)
            
            //setting frame and image for leftHexView
            leftHexView.frame = CGRect(x: topHexView.frame.minX - 0.75*hexWidth - 3, y: topHexView.frame.midY + 2, width: hexWidth, height: hexHeight)
            let borderColor = DisplayUtility.gradientColor(size: leftHexView.frame.size)
            leftHexView.addBorder(width: 3.0, color: borderColor)
            //leftHexView.setNeedsDisplay()
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
            scrollView.addSubview(leftHexView)
            
            let leftHexViewGR = UITapGestureRecognizer(target: self, action: #selector(profilePicSelected(_:)))
            leftHexView.addGestureRecognizer(leftHexViewGR)
            
            //setting frame and image for rightHexView
            rightHexView.frame = CGRect(x: topHexView.frame.minX + 0.75*hexWidth + 3, y: topHexView.frame.midY + 2, width: hexWidth, height: hexHeight)
            //Setting static profile images for tech Demo
            let image2 = #imageLiteral(resourceName: "profpic3.jpg")
            //setImageToHexagon(image: image2, hexView: rightHexView)
            rightHexView.setBackgroundImage(image: image2)
            
            //            if let data = localData.getMainProfilePicture() {
            //                if let image = UIImage(data: data) {
            //                    setImageToHexagon(image: image, hexView: rightHexView)
            //                }
            //            } else if let urlString = user["profile_picture_url"] as? String, let url = URL(string: urlString) {
            //                downloader.imageFromURL(URL: url, callBack: { (image) in
            //                    self.setImageToHexagon(image: image, hexView: self.rightHexView)
            //                })
            //            }
            scrollView.addSubview(rightHexView)
            
            let rightHexViewGR = UITapGestureRecognizer(target: self, action: #selector(profilePicSelected(_:)))
            rightHexView.addGestureRecognizer(rightHexViewGR)
            
            //setting frame and image for bottomHexView
            bottomHexView.frame = CGRect(x: topHexView.frame.minX, y: topHexView.frame.maxY + 4, width: hexWidth, height: hexHeight)
            //Setting static profile images for tech Demo
            let image3 = #imageLiteral(resourceName: "profPic4.jpg")
            //setImageToHexagon(image: image3, hexView: bottomHexView)
            bottomHexView.setBackgroundImage(image: image3)
            //            if let data = localData.getMainProfilePicture() {
            //                if let image = UIImage(data: data) {
            //                    setImageToHexagon(image: image, hexView: bottomHexView)
            //                }
            //            } else if let urlString = user["profile_picture_url"] as? String, let url = URL(string: urlString) {
            //                downloader.imageFromURL(URL: url, callBack: { (image) in
            //                    self.setImageToHexagon(image: image, hexView: self.bottomHexView)
            //                })
            //            }
            scrollView.addSubview(bottomHexView)
            
            let bottomHexViewGR = UITapGestureRecognizer(target: self, action: #selector(profilePicSelected(_:)))
            bottomHexView.addGestureRecognizer(bottomHexViewGR)
            
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
            
            statusView.frame = CGRect(x: 0, y: bottomHexView.frame.maxY, width: DisplayUtility.screenWidth, height: statusTextView.frame.maxY)
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
    
    func layoutBottomBasedOnFactsView() {
        statusView.frame = CGRect(x: 0, y: bottomHexView.frame.maxY + 0.045*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: statusTextView.frame.maxY)
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
                } else {
                    print("User did not save successfuly")
                }
            })
        }
        dismiss(animated: false, completion: nil)
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
                if currentStatusType == "Business" {
                    businessStatus = statusTextView.text
                } else if currentStatusType == "Love" {
                    loveStatus = statusTextView.text
                } else if currentStatusType == "Friendship" {
                    friendshipStatus = statusTextView.text
                }
                if let unselectedImage = unselectedImage,
                    let selectedImage = selectedImage {
                    if statusButton.image(for: .normal) == unselectedImage {
                        statusButton.setImage(selectedImage, for: .normal)
                        statusTextView.isEditable = true
                        statusTextView.textAlignment = .left
                        DisplayUtility.topAlignTextVerticallyInTextView(textView: statusTextView)
                        var runQuery = false
                        if statusButton == businessStatusButton {
                            currentStatusType = "Business"
                            if noBusinessStatus {
                                statusPlaceholder = true
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
                                statusPlaceholder = true
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
                                statusPlaceholder = true
                            } else if let friendshipStatus = friendshipStatus {
                                statusPlaceholder = false
                                statusTextView.text = friendshipStatus
                            } else {
                                statusPlaceholder = false
                                runQuery = true
                            }
                        }
                        
                        if runQuery {
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
                                                print("status findObjectsInBackgroundWithBlock error - \(error)")
                                            }
                                            else if let results = results {
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
                                                }
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    } else {
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
            UIView.animate(withDuration: 0.5, animations: {
                //self.scrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height), animated: true)
            }, completion: { (finished) in
                if finished {
                    let editProfilePicView = ProfilePicturesView(hexView: newHexView, shouldShowEditButtons: true)
                    self.view.addSubview(editProfilePicView)
                    editProfilePicView.animate()
                }
            })
        }
    }
    
    // Remove placeholder
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.textAlignment = .left
        DisplayUtility.topAlignTextVerticallyInTextView(textView: textView)
    }
    
    // Add back placeholder
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textAlignment = .center
            DisplayUtility.centerTextVerticallyInTextView(textView: textView)
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
