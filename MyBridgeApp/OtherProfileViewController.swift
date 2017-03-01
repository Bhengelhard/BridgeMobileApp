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
    var userName: String?
    var userProfilePictureURL: String?
    
    var reportMenu: ReportUserMenu?
    let scrollView = UIScrollView()
    var navBar: ProfileNavBar?
    var hexes: ProfileHexagons?
    let messageButton = UIButton()
    let quickUpdateView = UIView()
    let factsView = UIView()
    let factsTextLabel = UILabel()
    var statusButtons: ProfileStatusButtons?
    let businessButton = UIButton()
    let loveButton = UIButton()
    let friendshipButton = UIButton()
    let statusLabel = UILabel()
    
    var unselectedStatusText = ""
    var businessStatusPlaceholder = ""
    var loveStatusPlaceholder = ""
    var friendshipStatusPlaceholder = ""
    var businessStatus = ""
    var loveStatus = ""
    var friendshipStatus = ""
    var businessStatusSet = false
    var loveStatusSet = false
    var friendshipStatusSet = false
    
    //Transition to SingleMessageVC preparation
    let transitionManager = TransitionManager()
    var messageId = ""
    var necterTypeColor = UIColor()
    var singleMessageTitle = ""
    
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

        
        print("otherProfileVC Did Load")
        
        // set background color to white
        view.backgroundColor = .white
        
        // run query to get user
        if user == nil {
            if let query = PFUser.query() {
                query.whereKey("objectId", equalTo: userId)
                query.limit = 1
                query.findObjectsInBackground(block: { (results, error) in
                    if error != nil {
                        print("error - get first object - \(error)")
                        self.dismiss(animated: true, completion: nil)
                    } else if let users = results as? [PFUser] {
                        if users.count > 0 {
                            self.user = users[0]
                            self.layoutViews()
                        } else {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                })
            }
        } else {
            layoutViews()
        }
        
    }
    
    func layoutViews() {
        if let user = user {
            
            
            // MARK: Navigation Bar
            
            // create image for exit button
            let xIcon = UIImageView(image: UIImage(named: "Black_X"))
            let xIconWidth = 0.03514*DisplayUtility.screenWidth
            let xIconHeight = xIconWidth * 26.31/26.352
            xIcon.frame.size = CGSize(width: xIconWidth, height: xIconHeight)
            
            //create image for report user button
            let reportIcon = UIImageView(image: UIImage(named: "Report_User"))
            let reportIconWidth = 0.061*DisplayUtility.screenWidth
            let reportIconHeight = reportIconWidth
            reportIcon.frame.size = CGSize(width: reportIconWidth, height: reportIconHeight)
            
            if let id = user.objectId, let name = user["name"] as? String {
                reportMenu = ReportUserMenu(parentVC: self, superView: view, userId: id, userName: name)
            }
            
            // set text for greeting label
            var greetingText = String()
            
            var greeting = "Hi,"
            if let userGreeting = user["profile_greeting"] as? String {
                greeting = userGreeting
            }
            if let name = user["name"] as? String {
                userName = name
                let firstName = DisplayUtility.firstName(name: name)
                greetingText = "\(greeting) I'm \(firstName)."
            }
            
            // initialize navigation bar
            if let reportMenu = reportMenu {
                navBar = ProfileNavBar(leftButtonImageView: xIcon, leftButtonFunc: exit, rightButtonImageView: reportIcon, rightButtonFunc: reportMenu.animateIn, mainText: greetingText, mainTextColor: .black, subTextColor: .gray)
                view.addSubview(navBar!)
            }
            
            // set text for num 'nected label
            if let objectId = user.objectId {
                let query = PFQuery(className: "BridgePairings")
                query.whereKey("connecter_objectId", equalTo: objectId)
                query.whereKey("user1_response", equalTo: 1)
                query.whereKey("user2_response", equalTo: 1)
                query.whereKey("accepted_notification_viewed", equalTo: true)
                query.limit = 1000
                query.countObjectsInBackground(block: { (count, error) in
                    if let error = error {
                        print("numNected findObjectsInBackgroundWithBlock error - \(error)")
                    }
                    else {
                        let numNected = Int(count)
                        let numNectedText = "\(numNected) CONNECTIONS 'NECTED"
                        if let navBar = self.navBar {
                            navBar.updateSubLabel(subText: numNectedText)
                        }
                    }
                    
                })
            }
            
            
            // MARK: Scroll View
            // make scroll view transparent
            scrollView.backgroundColor = .clear
            
            // place scroll view below navigation bar
            if let navBar = self.navBar {
                scrollView.frame = CGRect(x: 0, y: navBar.frame.maxY, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight - navBar.frame.maxY)
            } else {
                
            }
            
            view.addSubview(scrollView)
            
            
            // MARK: Profile Picture Hexagons
            
            // initialize hexes
            hexes = ProfileHexagons(minY: 0, parentVC: self, hexImages: [], shouldShowDefaultFrame: false, shouldBeEditable: false)
            scrollView.addSubview(hexes!)
            
            // add images for hexes
            if let profilePics = user["profile_pictures"] as? [PFFile] {
                hexes!.addHexImages(from: profilePics, startingAt: 0)
            }
            else {
                //If the user has not set any profile pictures, then check if the user has something saved in profile_picture_url to set
                if let urlString = user["profile_picture_url"] as? String {
                    if let URL = URL(string: urlString) {
                        let downloader = Downloader()
                        downloader.imageFromURL(URL: URL, callBack: { (image) in
                            if let hexes = self.hexes {
                                hexes.addImage(hexImage: image)
                            }
                        })
                    }
                    
                }

            }
                
                if let profilePictureURL = user["profile_picture_url"] as? String {
                    userProfilePictureURL = profilePictureURL
                }
            
            
            // MARK: Message Button
            
            // layout message button
            let messageButtonWidth = 0.34666*DisplayUtility.screenWidth
            let messageButtonHeight = 53.75 / 260.0 * messageButtonWidth
            messageButton.frame = CGRect(x: 0, y: hexes!.frame.maxY + 0.03*DisplayUtility.screenHeight, width: messageButtonWidth, height: messageButtonHeight)
            messageButton.center.x = DisplayUtility.screenWidth / 2
            messageButton.setImage(UIImage(named: "Message_Button"), for: .normal)
            messageButton.addTarget(self, action: #selector(messageButtonTapped(_:)), for: .touchUpInside)
            scrollView.addSubview(messageButton)
            
            let line = DisplayUtility.gradientLine(minY: messageButton.frame.maxY + 0.02*DisplayUtility.screenHeight, width: 0.8*DisplayUtility.screenWidth)
            scrollView.addSubview(line)
            
            var yOffsetFromLine: CGFloat = 0
            
            
            // MARK: Quick Update
            
            if let quickUpdate = user["quick_update"] as? String {
                let quickUpdateLabel = UILabel()
                quickUpdateLabel.text = "QUICK UPDATE"
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
            
            
            // MARK: The Facts
            
            let factsLabel = UILabel()
            factsLabel.text = "THE FACTS"
            factsLabel.textColor = .black
            factsLabel.textAlignment = .center
            factsLabel.font = UIFont(name: "BentonSans-Light", size: 12)
            factsLabel.sizeToFit()
            factsLabel.frame = CGRect(x: 0, y: 0, width: factsLabel.frame.width, height: factsLabel.frame.height)
            factsLabel.center.x = DisplayUtility.screenWidth / 2
            factsView.addSubview(factsLabel)
            
            factsTextLabel.numberOfLines = 0
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
                let line2 = DisplayUtility.gradientLine(minY: line.frame.maxY + yOffsetFromLine + 0.03*DisplayUtility.screenHeight, width: 0.8*DisplayUtility.screenWidth)
                scrollView.addSubview(line2)
                
                yOffsetFromLine = line2.frame.maxY - line.frame.maxY
            }
            
            
            // MARK: Statuses
            
            statusButtons = ProfileStatusButtons(minY: line.frame.maxY + yOffsetFromLine + 0.03*DisplayUtility.screenHeight, selectType: selectType)
            scrollView.addSubview(statusButtons!)
            
            if let name = user["name"] as? String {
                let firstName = DisplayUtility.firstName(name: name)
                unselectedStatusText = "Click an icon above to see \(firstName)'s currently displayed requests."
                businessStatusPlaceholder = "\(firstName) has not yet posted a request for work."
                loveStatusPlaceholder = "\(firstName) has not yet posted a request for dating."
                friendshipStatusPlaceholder = "\(firstName) has not yet posted a request for friendship."
                
            }
            
            businessStatus = businessStatusPlaceholder
            loveStatus = loveStatusPlaceholder
            friendshipStatus = friendshipStatusPlaceholder
            
            statusLabel.textColor = UIColor.init(red: 56/255.0, green: 56/255.0, blue: 56/255.0, alpha: 1.0)
            statusLabel.textAlignment = .center
            statusLabel.numberOfLines = 0
            statusLabel.text = unselectedStatusText
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
    
    func messageButtonTapped(_ sender: UIButton) {
        print("messageButtonTapped")
        let messagingFunctions = MessagingFunctions()
        if let name = userName {
            print("name retrieved")
            if let URL = userProfilePictureURL {
                print("url retrieved")
                messagingFunctions.createDirectMessage(otherUserObjectId: userId, otherUserName: name, otherUserProfilePictureURL: URL, vc: self)
            }
        }
        
    }
    
    func exit(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    func writeFacts() -> Bool {
        if let user = user {
            if let selectedFacts = user["selected_facts"] as? [String] {
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
                            factsText = "I \(facts[i]),"
                        } else if i == facts.count - 1 {
                            factsText = "\(factsText) and \(facts[i])."
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
    
    
    func selectType(type: String?) {
        if let user = user {
            if let type = type {
                var runQuery = false
                if type == "Business" {
                    if businessStatusSet {
                        statusLabel.text = businessStatus
                    } else {
                        runQuery = true
                    }
                } else if type == "Love" {
                    if loveStatusSet {
                        statusLabel.text = loveStatus
                    } else {
                        runQuery = true
                    }
                } else if type == "Friendship" {
                    if friendshipStatusSet {
                        statusLabel.text = friendshipStatus
                    } else {
                        runQuery = true
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
                                self.layoutBottomBasedOnStatus()
                            }
                        })
                    }
                } else {
                    self.layoutBottomBasedOnStatus()
                }
            } else { // type is nil
                statusLabel.text = unselectedStatusText
                self.layoutBottomBasedOnStatus()
            }
        }
    }
    
    func layoutBottomBasedOnStatus() {
        if let statusButtons = statusButtons {
            self.statusLabel.frame = CGRect(x: 0, y: statusButtons.frame.maxY + 0.04*DisplayUtility.screenHeight, width: 0.9*DisplayUtility.screenWidth, height: 0)
            self.statusLabel.sizeToFit()
            self.statusLabel.center.x = DisplayUtility.screenWidth / 2
            //friendsAndNectsView.frame = CGRect(x: 0, y: statusLabel.frame.maxY + 0.04*DisplayUtility.screenHeight, width: friendsAndNectsView.frame.width, height: friendsAndNectsView.frame.height)
            
            scrollView.contentSize = CGSize(width: DisplayUtility.screenWidth, height: max(scrollView.frame.height, statusLabel.frame.maxY + 0.02*DisplayUtility.screenHeight))
        }
    }
    
    func transitionToMessageWithID(_ id: String, color: UIColor, title: String) {
        print("transition ran in BridgeVC")
        self.messageId = id
        self.necterTypeColor = color
        self.singleMessageTitle = title
        
        let singleMessageVC:SingleMessageViewController = SingleMessageViewController()
        singleMessageVC.isSeguedFromBridgePage = true
        singleMessageVC.newMessageId = self.messageId
        singleMessageVC.singleMessageTitle = singleMessageTitle
        singleMessageVC.seguedFrom = "OtherProfileViewController"
        singleMessageVC.necterTypeColor = necterTypeColor
        singleMessageVC.transitioningDelegate = self.transitionManager
        present(singleMessageVC, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NotificationCenter.default.removeObserver(self)
        let vc = segue.destination
        let mirror = Mirror(reflecting: vc)
        if mirror.subjectType == SingleMessageViewController.self {
            self.transitionManager.animationDirection = "Right"
            let singleMessageVC:SingleMessageViewController = segue.destination as! SingleMessageViewController
            singleMessageVC.isSeguedFromBridgePage = true
            singleMessageVC.newMessageId = self.messageId
            singleMessageVC.singleMessageTitle = singleMessageTitle
            singleMessageVC.seguedFrom = "OtherProfileViewController"
            singleMessageVC.necterTypeColor = necterTypeColor
            singleMessageVC.transitioningDelegate = self.transitionManager
        }
        vc.transitioningDelegate = self.transitionManager
            
        
    }

}
