//
//  OtherProfileViewController.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 1/19/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class OtherProfileViewController: UIViewController {
    let userId: String
    var user: PFUser?
    
    let scrollView = UIScrollView()
    let exitButton = UIButton()
    let privacyButton = UIButton()
    let greetingLabel = UILabel()
    let numNectedLabel = UILabel()
    let topHexView = HexagonView()
    let leftHexView = HexagonView()
    let rightHexView = HexagonView()
    let bottomHexView = HexagonView()
    let messageButton = UIButton()
    let quickUpdateView = UIView()
    let factsView = UIView()
    let factsTextLabel = UILabel()
    let businessButton = UIButton()
    let loveButton = UIButton()
    let friendshipButton = UIButton()
    let statusLabel = UILabel()
    
    var businessStatus = ""
    var loveStatus = ""
    var friendshipStatus = ""
    var businessStatusSet = false
    var loveStatusSet = false
    var friendshipStatusSet = false
    
    init(userId: String) {
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUser(user: PFUser) {
        self.user = user
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //Setting Background Color
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        
        scrollView.backgroundColor = .clear
        
        // run query to get user
        if user == nil {
            if let query = PFUser.query() {
                query.whereKey("objectId", equalTo: userId)
                query.getFirstObjectInBackground(block: { (user, error) in
                    if error != nil {
                        print("error - get first object - \(error)")
                    } else if let user = user as? PFUser {
                        self.user = user
                        self.layoutViews()
                    }
                })
            }
        } else {
            layoutViews()
        }
        
    }
    
    func layoutViews() {
        if let user = user {
            // Creating viewed exit icon
            let xIcon = UIImageView(frame: CGRect(x: 0.044*DisplayUtility.screenWidth, y: 0.04384*DisplayUtility.screenHeight, width: 0.03514*DisplayUtility.screenWidth, height: 0.03508*DisplayUtility.screenWidth))
            xIcon.image = UIImage(named: "Black_X")
            view.addSubview(xIcon)
            
            // Creating larger clickable space around exit icon
            exitButton.frame = CGRect(x: xIcon.frame.minX - 0.02*DisplayUtility.screenWidth, y: xIcon.frame.minY - 0.02*DisplayUtility.screenWidth, width: xIcon.frame.width + 0.04*DisplayUtility.screenWidth, height: xIcon.frame.height + 0.04*DisplayUtility.screenWidth)
            exitButton.showsTouchWhenHighlighted = false
            exitButton.addTarget(self, action: #selector(exit(_:)), for: .touchUpInside)
            view.addSubview(exitButton)
            
            // Creating greeting label
            greetingLabel.textColor = .black
            greetingLabel.textAlignment = .center
            greetingLabel.font = UIFont(name: "BentonSans-Light", size: 21)
            var greeting = "Hi,"
            if let userGreeting = user["profile_greeting"] as? String {
                greeting = userGreeting
            }
            if let name = user["name"] as? String {
                let firstName = DisplayUtility.firstName(name: name)
                greetingLabel.text = "\(greeting) I'm \(firstName)."
                greetingLabel.sizeToFit()
                greetingLabel.frame = CGRect(x: 0, y: 0.07969*DisplayUtility.screenHeight, width: greetingLabel.frame.width, height: greetingLabel.frame.height)
                greetingLabel.center.x = DisplayUtility.screenWidth / 2
                view.addSubview(greetingLabel)
                
                businessStatus = "\(firstName) has not yet posted a response for work."
                loveStatus = "\(firstName) has not yet posted a response for dating."
                friendshipStatus = "\(firstName) has not yet posted a response for friendship."
            }
            
            numNectedLabel.textColor = .gray
            numNectedLabel.textAlignment = .center
            numNectedLabel.font = UIFont(name: "BentonSans-Light", size: 12)
            numNectedLabel.frame = CGRect(x: 0, y: greetingLabel.frame.maxY + 0.0075*DisplayUtility.screenHeight, width: 0, height: 0)

            if let objectId = user.objectId {
                let query = PFQuery(className: "BridgePairings")
                query.whereKey("connecter_objectId", equalTo: objectId)
                query.whereKey("user1_response", equalTo: 1)
                query.whereKey("user2_response", equalTo: 1)
                query.whereKey("accepted_notification_viewed", equalTo: true)
                query.limit = 1000
                query.countObjectsInBackground(block: { (count, error) in
                    print("numNected query executing...")
                    if let error = error {
                        print("numNected findObjectsInBackgroundWithBlock error - \(error)")
                    }
                    else {
                        let numNected = Int(count)
                        self.numNectedLabel.text = "\(numNected) CONNECTIONS 'NECTED"
                        self.numNectedLabel.sizeToFit()
                        self.numNectedLabel.frame = CGRect(x: 0, y: self.numNectedLabel.frame.minY, width: self.numNectedLabel.frame.width, height: self.numNectedLabel.frame.height)
                        self.numNectedLabel.center.x = DisplayUtility.screenWidth / 2
                        self.view.addSubview(self.numNectedLabel)
                    }
                    
                })
            }
            
            scrollView.frame = CGRect(x: 0, y: greetingLabel.frame.maxY + 0.045*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: 0.955*DisplayUtility.screenHeight - greetingLabel.frame.maxY)
            view.addSubview(scrollView)
            
            scrollView.backgroundColor = .clear
            
            let hexWidth = 0.38154*DisplayUtility.screenWidth
            let hexHeight = hexWidth * sqrt(3) / 2
            
            let downloader = Downloader()
            
            //setting frame for topHexView
            topHexView.frame = CGRect(x: 0, y: 0, width: hexWidth, height: hexHeight)
            topHexView.center.x = DisplayUtility.screenWidth / 2
            scrollView.addSubview(topHexView)
            
            //setting frame for leftHexView
            leftHexView.frame = CGRect(x: topHexView.frame.minX - 0.75*hexWidth - 3, y: topHexView.frame.midY + 2, width: hexWidth, height: hexHeight)
            scrollView.addSubview(leftHexView)
            
            //setting frame for rightHexView
            rightHexView.frame = CGRect(x: topHexView.frame.minX + 0.75*hexWidth + 3, y: topHexView.frame.midY + 2, width: hexWidth, height: hexHeight)
            scrollView.addSubview(rightHexView)
            
            //setting frame for bottomHexView
            bottomHexView.frame = CGRect(x: topHexView.frame.minX, y: topHexView.frame.maxY + 4, width: hexWidth, height: hexHeight)
            scrollView.addSubview(bottomHexView)
            
            if let profilePics = user["profile_pictures"] as? [PFFile] {
                let hexViews = [leftHexView, topHexView, rightHexView, bottomHexView]
                for i in 0..<hexViews.count {
                    if profilePics.count > i {
                        profilePics[i].getDataInBackground(block: { (data, error) in
                            if error != nil {
                                print(error)
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
            
            // layout message button
            let messageButtonWidth = 0.34666*DisplayUtility.screenWidth
            let messageButtonHeight = 53.75 / 260.0 * messageButtonWidth
            messageButton.frame = CGRect(x: 0, y: bottomHexView.frame.maxY + 0.03*DisplayUtility.screenHeight, width: messageButtonWidth, height: messageButtonHeight)
            messageButton.center.x = DisplayUtility.screenWidth / 2
            messageButton.setImage(UIImage(named: "Message_Button"), for: .normal)
            scrollView.addSubview(messageButton)
            
            let line = UIView()
            let gradientLayer = DisplayUtility.getGradient()
            line.backgroundColor = .clear
            line.layer.insertSublayer(gradientLayer, at: 0)
            line.frame = CGRect(x: 0, y: messageButton.frame.maxY + 0.02*DisplayUtility.screenHeight, width: 0.8*DisplayUtility.screenWidth, height: 1)
            line.center.x = DisplayUtility.screenWidth / 2
            gradientLayer.frame = line.bounds
            scrollView.addSubview(line)
            
            var yOffsetFromLine: CGFloat = 0
            
            // Creating "Quick-Update" section
            if let quickUpdate = user["quick_update"] as? String {
                let quickUpdateLabel = UILabel()
                quickUpdateLabel.text = "QUICK-UPDATE"
                quickUpdateLabel.textColor = .black
                quickUpdateLabel.textAlignment = .center
                quickUpdateLabel.font = UIFont(name: "BentonSans-Light", size: 12)
                quickUpdateLabel.sizeToFit()
                quickUpdateLabel.frame = CGRect(x: 0, y: 0, width: quickUpdateLabel.frame.width, height: quickUpdateLabel.frame.height)
                quickUpdateLabel.center.x = DisplayUtility.screenWidth / 2
                quickUpdateView.addSubview(quickUpdateLabel)
                
                let quickUpdateTextLabel = UILabel()
                quickUpdateTextLabel.text = quickUpdate
                quickUpdateTextLabel.numberOfLines = 0
                quickUpdateTextLabel.font = UIFont(name: "BentonSans-Light", size: 17)
                quickUpdateTextLabel.adjustsFontSizeToFitWidth = true
                quickUpdateTextLabel.minimumScaleFactor = 0.5
                quickUpdateTextLabel.textColor = .black
                quickUpdateTextLabel.textAlignment = .center
                quickUpdateTextLabel.frame = CGRect(x: 0, y: quickUpdateLabel.frame.maxY + 0.03*DisplayUtility.screenHeight, width: 0.9*DisplayUtility.screenWidth, height: 0)
                quickUpdateTextLabel.sizeToFit()
                quickUpdateTextLabel.center.x = DisplayUtility.screenWidth / 2
                quickUpdateView.addSubview(quickUpdateTextLabel)
                
                quickUpdateView.frame = CGRect(x: 0, y: line.frame.maxY + yOffsetFromLine + 0.03*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: quickUpdateTextLabel.frame.maxY)
                scrollView.addSubview(quickUpdateView)
                
                yOffsetFromLine = quickUpdateView.frame.maxY - line.frame.maxY
            }
            
            let factsLabel = UILabel()
            factsLabel.text = "THE FACTS"
            factsLabel.textColor = .black
            factsLabel.textAlignment = .center
            factsLabel.font = UIFont(name: "BentonSans-Light", size: 12)
            factsLabel.sizeToFit()
            factsLabel.frame = CGRect(x: 0, y: 0, width: factsLabel.frame.width, height: factsLabel.frame.height)
            factsLabel.center.x = DisplayUtility.screenWidth / 2
            factsView.addSubview(factsLabel)
            
            factsTextLabel.font = UIFont(name: "BentonSans-Light", size: 17)
            factsTextLabel.adjustsFontSizeToFitWidth = true
            factsTextLabel.minimumScaleFactor = 0.5
            factsTextLabel.textColor = .black
            factsTextLabel.textAlignment = .center
            factsTextLabel.frame = CGRect(x: 0, y: factsLabel.frame.maxY + 0.03*DisplayUtility.screenHeight, width: 0.9*DisplayUtility.screenWidth, height: 0)
            
            if writeFacts() { // facts to write
                factsTextLabel.sizeToFit()
                factsTextLabel.center.x = DisplayUtility.screenWidth / 2
                factsView.addSubview(factsTextLabel)
                
                factsView.frame = CGRect(x: 0, y: line.frame.maxY + yOffsetFromLine + 0.05*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: factsTextLabel.frame.maxY)
                scrollView.addSubview(factsView)
                
                yOffsetFromLine = factsView.frame.maxY - line.frame.maxY
            }
            
            if yOffsetFromLine != 0 {
                let line2 = UIView()
                let gradientLayer = DisplayUtility.getGradient()
                line2.backgroundColor = .clear
                line2.layer.insertSublayer(gradientLayer, at: 0)
                line2.frame = CGRect(x: 0, y: line.frame.maxY + yOffsetFromLine + 0.03*DisplayUtility.screenHeight, width: 0.8*DisplayUtility.screenWidth, height: 1)
                line2.center.x = DisplayUtility.screenWidth / 2
                gradientLayer.frame = line2.bounds
                scrollView.addSubview(line2)
                
                yOffsetFromLine = line2.frame.maxY - line.frame.maxY
            }
            
            let statusButtonWidth = 0.11596*DisplayUtility.screenWidth
            let statusButtonHeight = statusButtonWidth
            
            businessButton.setImage(UIImage(named: "Profile_Unselected_Work_Icon"), for: .normal)
            loveButton.setImage(UIImage(named: "Profile_Unselected_Dating_Icon"), for: .normal)
            friendshipButton.setImage(UIImage(named: "Profile_Unselected_Friends_Icon"), for: .normal)
            
            businessButton.frame = CGRect(x: 0.17716*DisplayUtility.screenWidth, y: line.frame.maxY + yOffsetFromLine + 0.03*DisplayUtility.screenHeight, width: statusButtonWidth, height: statusButtonHeight)
            businessButton.addTarget(self, action: #selector(statusTypeButtonSelected(_:)), for: .touchUpInside)
            scrollView.addSubview(businessButton)
            
            loveButton.frame = CGRect(x: 0, y: businessButton.frame.minY, width: statusButtonWidth, height: statusButtonHeight)
            loveButton.center.x = DisplayUtility.screenWidth / 2
            loveButton.addTarget(self, action: #selector(statusTypeButtonSelected(_:)), for: .touchUpInside)
            scrollView.addSubview(loveButton)
            
            friendshipButton.frame = CGRect(x: DisplayUtility.screenWidth - businessButton.frame.maxX, y: businessButton.frame.minY, width: statusButtonWidth, height: statusButtonHeight)
            friendshipButton.addTarget(self, action: #selector(statusTypeButtonSelected(_:)), for: .touchUpInside)
            scrollView.addSubview(friendshipButton)
            
            statusLabel.textColor = UIColor.init(red: 56/255.0, green: 56/255.0, blue: 56/255.0, alpha: 1.0)
            statusLabel.textAlignment = .center
            statusLabel.numberOfLines = 0
            statusLabel.text = "Click an icon above to see your\ncurrently displayed requests."
            statusLabel.font = UIFont(name: "BentonSans-Light", size: 17)
            statusLabel.adjustsFontSizeToFitWidth = true
            statusLabel.minimumScaleFactor = 0.5
            statusLabel.frame = CGRect(x: 0, y: businessButton.frame.maxY + 0.04*DisplayUtility.screenHeight, width: 0.9*DisplayUtility.screenWidth, height: 0)
            statusLabel.sizeToFit()
            statusLabel.center.x = DisplayUtility.screenWidth / 2
            scrollView.addSubview(statusLabel)
            
            layoutBottomBasedOnStatus()

        }
    }
    
    func exit(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
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
            var originalHexFrames = [CGRect]()
            var startingIndex = 0
            let hexViews = [leftHexView, topHexView, rightHexView, bottomHexView]
            for i in 0..<hexViews.count {
                if let image = hexViews[i].hexBackgroundImage {
                    images.append(image)
                    let frame = CGRect(x: hexViews[i].frame.minX, y: hexViews[i].frame.minY + scrollView.frame.minY - scrollView.contentOffset.y, width: hexViews[i].frame.width, height: hexViews[i].frame.height)
                    originalHexFrames.append(frame)
                }
                if hexViews[i] == hexView {
                    startingIndex = i
                }
            }
            let profilePicsView = ProfilePicturesView(images: images, originalHexFrames: originalHexFrames, startingIndex: startingIndex, shouldShowEditButtons: false, parentVC: self)
            self.view.addSubview(profilePicsView)
            profilePicsView.animateIn()
        }
    }
    
    func writeFacts() -> Bool {
        if let user = user {
            if let selectedFacts = user["selected_facts"] as? [String] {
                var factsText = ""
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
                            factsText = "\(factsText) \(facts[i])."
                        } else {
                            factsText = "\(factsText) \(facts[i]),"
                        }
                    }
                    factsTextLabel.text = factsText
                    
                    return true
                }
            }
        }
        return false
    }
    
    func statusTypeButtonSelected(_ sender: UIButton) {
        if let user = user {
            for statusButton in [businessButton, loveButton, friendshipButton] {
                var selectedImage: UIImage?
                var unselectedImage: UIImage?
                if statusButton == businessButton {
                    selectedImage = UIImage(named: "Profile_Selected_Work_Icon")
                    unselectedImage = UIImage(named: "Profile_Unselected_Work_Icon")
                } else if statusButton == loveButton {
                    selectedImage = UIImage(named: "Profile_Selected_Dating_Icon")
                    unselectedImage = UIImage(named: "Profile_Unselected_Dating_Icon")
                } else if statusButton == friendshipButton {
                    selectedImage = UIImage(named: "Profile_Selected_Friends_Icon")
                    unselectedImage = UIImage(named: "Profile_Unselected_Friends_Icon")
                }
                if sender == statusButton {
                    if let unselectedImage = unselectedImage,
                        let selectedImage = selectedImage {
                        // selecting unselected type
                        if statusButton.image(for: .normal) == unselectedImage {
                            statusButton.setImage(selectedImage, for: .normal)
                            var runQuery = false
                            var type = ""
                            if statusButton == businessButton {
                                if let interestedBusiness = user["interested_in_business"] as? Bool {
                                    businessStatusSet = !interestedBusiness
                                } else {
                                    businessStatusSet = true
                                }
                                if businessStatusSet {
                                    statusLabel.text = businessStatus
                                } else {
                                    runQuery = true
                                    type = "Business"
                                }
                            } else if statusButton == loveButton {
                                if let interestedLove = user["interested_in_love"] as? Bool {
                                    loveStatusSet = !interestedLove
                                } else {
                                    loveStatusSet = true
                                }
                                if loveStatusSet {
                                    statusLabel.text = loveStatus
                                } else {
                                    runQuery = true
                                    type = "Love"
                                }
                            } else if statusButton == friendshipButton {
                                if let interestedFriendship = user["interested_in_friendship"] as? Bool {
                                    friendshipStatusSet = !interestedFriendship
                                } else {
                                    friendshipStatusSet = true
                                }
                                if friendshipStatusSet {
                                    statusLabel.text = friendshipStatus
                                } else {
                                    runQuery = true
                                    type = "Friendship"
                                }
                            }
                            
                            if runQuery {
                                print ("running BridgeStatus query")
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
                                                    self.statusLabel.text = bridgeStatus
                                                    if type == "Business" {
                                                        self.businessStatus = bridgeStatus
                                                        self.businessStatusSet = true
                                                    } else if type == "Love" {
                                                        self.loveStatus = bridgeStatus
                                                        self.loveStatusSet = true
                                                    } else if type == "Friendship" {
                                                        self.friendshipStatus = bridgeStatus
                                                        self.friendshipStatusSet = true
                                                    }
                                                }
                                            } else {
                                                if type == "Business" {
                                                    self.businessStatusSet = true
                                                    self.statusLabel.text = self.businessStatus
                                                } else if type == "Love" {
                                                    self.loveStatusSet = true
                                                    self.statusLabel.text = self.loveStatus
                                                } else if type == "Friendship" {
                                                    self.friendshipStatusSet = true
                                                    self.statusLabel.text = self.friendshipStatus
                                                }
                                            }
                                            self.statusLabel.frame = CGRect(x: 0, y: self.businessButton.frame.maxY + 0.04*DisplayUtility.screenHeight, width: 0.9*DisplayUtility.screenWidth, height: 0)
                                            self.statusLabel.sizeToFit()
                                            self.statusLabel.center.x = DisplayUtility.screenWidth / 2
                                            self.layoutBottomBasedOnStatus()
                                        } else {
                                            if type == "Business" {
                                                self.businessStatusSet = true
                                                self.statusLabel.text = self.businessStatus
                                            } else if type == "Love" {
                                                self.loveStatusSet = true
                                                self.statusLabel.text = self.loveStatus
                                            } else if type == "Friendship" {
                                                self.friendshipStatusSet = true
                                                self.statusLabel.text = self.friendshipStatus
                                            }
                                            self.statusLabel.frame = CGRect(x: 0, y: self.businessButton.frame.maxY + 0.04*DisplayUtility.screenHeight, width: 0.9*DisplayUtility.screenWidth, height: 0)
                                            self.statusLabel.sizeToFit()
                                            self.statusLabel.center.x = DisplayUtility.screenWidth / 2
                                            self.layoutBottomBasedOnStatus()
                                        }
                                    })
                                }
                            } else {
                                self.statusLabel.frame = CGRect(x: 0, y: self.businessButton.frame.maxY + 0.04*DisplayUtility.screenHeight, width: 0.9*DisplayUtility.screenWidth, height: 0)
                                self.statusLabel.sizeToFit()
                                self.statusLabel.center.x = DisplayUtility.screenWidth / 2
                                self.layoutBottomBasedOnStatus()
                            }
                        } else { // unselecting selected type
                            statusButton.setImage(unselectedImage, for: .normal)
                            if let name = user["name"] as? String {
                                let firstName = DisplayUtility.firstName(name: name)
                                statusLabel.text = "Click an icon above to see \(firstName)'s currently displayed requests."
                            }
                            self.statusLabel.frame = CGRect(x: 0, y: self.businessButton.frame.maxY + 0.04*DisplayUtility.screenHeight, width: 0.9*DisplayUtility.screenWidth, height: 0)
                            self.statusLabel.sizeToFit()
                            self.statusLabel.center.x = DisplayUtility.screenWidth / 2
                            self.layoutBottomBasedOnStatus()
                        }
                    }
                } else {
                    if let unselectedImage = unselectedImage {
                        statusButton.setImage(unselectedImage, for: .normal)
                    }
                }
            }
        }
    }
    
    func layoutBottomBasedOnStatus() {
        scrollView.contentSize = CGSize(width: DisplayUtility.screenWidth, height: max(DisplayUtility.screenHeight, statusLabel.frame.maxY + 0.02*DisplayUtility.screenHeight - scrollView.frame.minY))
    }

}
