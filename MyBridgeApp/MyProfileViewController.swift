//
//  MyProfileViewController.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 12/21/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import UIKit
import Parse

class MyProfileViewController: UIViewController {
    
    let localData = LocalData()
    
    let scrollView = UIScrollView()
    
    let backArrow = UIButton()
    let welcomeLabel = UILabel()
    let numNectedLabel = UILabel()
    let userSettingsButton = UIButton()
    let editProfileButton = UIButton()
    let topHexView = HexagonView()
    let leftHexView = HexagonView()
    let rightHexView = HexagonView()
    let bottomHexView = HexagonView()
    let numNectedLastWeekLabel = UILabel()
    let businessButton = UIButton()
    let loveButton = UIButton()
    let friendshipButton = UIButton()
    let statusLabel = UILabel()
    var businessStatus = "You have not yet posted a request for work"
    var loveStatus = "You have not yet posted a request for dating"
    var friendshipStatus = "You have not yet posted a request for friendship"
    let friendsAndNectsView = UIView()
    let transitionManager = TransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        
        scrollView.backgroundColor = .clear
                
        if let user = PFUser.current() {
            
            //Creating viewed backArrow icon
            let backArrowIcon = UIImageView(frame: CGRect(x: 0.90015*DisplayUtility.screenWidth, y: 0.06*DisplayUtility.screenHeight, width: 0.0533*DisplayUtility.screenWidth, height: 0.02181*DisplayUtility.screenHeight))
            backArrowIcon.image = UIImage(named: "Dark_Arrow")
            view.addSubview(backArrowIcon)
            
            //Creating larger clickable space around backArrow
            backArrow.frame = CGRect(x: 0.87475*DisplayUtility.screenWidth, y: 0.04633*DisplayUtility.screenHeight, width: 0.15*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenWidth)
            //\\\\backArrow.backgroundColor = UIColor.clear
            backArrow.showsTouchWhenHighlighted = false
            backArrow.addTarget(self, action: #selector(goBack(_:)), for: .touchUpInside)
            view.addSubview(backArrow)
            
            
            welcomeLabel.textColor = .black
            welcomeLabel.textAlignment = .center
            welcomeLabel.font = UIFont(name: "BentonSans-Light", size: 21)
            if let name = localData.getUsername() {
                let firstName = DisplayUtility.firstName(name: name)
                welcomeLabel.text = "Welcome back, \(firstName)."
                welcomeLabel.sizeToFit()
                welcomeLabel.frame = CGRect(x: 0, y: 0.1*DisplayUtility.screenHeight, width: welcomeLabel.frame.width, height: welcomeLabel.frame.height)
                welcomeLabel.center.x = DisplayUtility.screenWidth / 2
                view.addSubview(welcomeLabel)
            }
            
            numNectedLabel.textColor = .gray
            numNectedLabel.textAlignment = .center
            numNectedLabel.font = UIFont(name: "BentonSans-Light", size: 12)
            numNectedLabel.frame = CGRect(x: 0, y: welcomeLabel.frame.maxY + 0.0075*DisplayUtility.screenHeight, width: 0, height: 0)
            
            //Check to get numConnectionsNected from localData
            if let numNected = localData.getNumConnectionsNected() {
                self.numNectedLabel.text = "\(numNected) CONNECTIONS 'NECTED"
                self.numNectedLabel.sizeToFit()
                self.numNectedLabel.frame = CGRect(x: 0, y: self.numNectedLabel.frame.minY, width: self.numNectedLabel.frame.width, height: self.numNectedLabel.frame.height)
                self.numNectedLabel.center.x = DisplayUtility.screenWidth / 2
                self.view.addSubview(self.numNectedLabel)
            }
            //If not available on device, calculate numConnectionsNected with query and then save to device
            else if let objectId = user.objectId {
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
                        
                        self.localData.setNumConnectionsNected(numNected)
                        self.localData.synchronize()
                    }

                })
            }
            
            scrollView.frame = CGRect(x: 0, y: welcomeLabel.frame.maxY + 0.045*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: 0.955*DisplayUtility.screenHeight - welcomeLabel.frame.maxY)
            view.addSubview(scrollView)
            
            scrollView.backgroundColor = .clear
            
            let upperButtonsWidth = 0.34666*DisplayUtility.screenWidth
            let upperButtonsHeight = 0.2063*upperButtonsWidth
            
            userSettingsButton.setImage(UIImage(named: "UserSettings_Button"), for: .normal)
            userSettingsButton.frame = CGRect(x: 0.0383*DisplayUtility.screenWidth, y: 0, width: upperButtonsWidth, height: upperButtonsHeight)
            userSettingsButton.addTarget(self, action: #selector(userSettingsButtonTapped(_:)), for: .touchUpInside)
            print(userSettingsButton.frame.height / userSettingsButton.frame.width)
            scrollView.addSubview(userSettingsButton)
            
            editProfileButton.setImage(UIImage(named: "EditProfile_Button"), for: .normal)
            editProfileButton.frame = CGRect(x: 0.61753*DisplayUtility.screenWidth, y: userSettingsButton.frame.minY, width: upperButtonsWidth, height: upperButtonsHeight)
            editProfileButton.addTarget(self, action: #selector(editProfileButtonTapped(_:)), for: .touchUpInside)
            scrollView.addSubview(editProfileButton)
            
            let hexWidth = 0.38154*DisplayUtility.screenWidth
            let hexHeight = hexWidth * sqrt(3) / 2
            
            let downloader = Downloader()
            
            //setting frame and image for topHexView
            topHexView.frame = CGRect(x: 0, y: userSettingsButton.frame.maxY + 0.033*DisplayUtility.screenHeight, width: hexWidth, height: hexHeight)
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
            
            //setting frame and image for leftHexView
            leftHexView.frame = CGRect(x: topHexView.frame.minX - 0.75*hexWidth - 3, y: topHexView.frame.midY + 2, width: hexWidth, height: hexHeight)
            if let data = localData.getMainProfilePicture() {
                if let image = UIImage(data: data) {
                    setImageToHexagon(image: image, hexView: leftHexView)
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
            
            numNectedLastWeekLabel.textColor = .black
            numNectedLastWeekLabel.textAlignment = .center
            numNectedLastWeekLabel.numberOfLines = 2
            numNectedLastWeekLabel.font = UIFont(name: "BentonSans-Light", size: 19)
            numNectedLastWeekLabel.frame = CGRect(x: 0, y: bottomHexView.frame.maxY + 0.05*DisplayUtility.screenHeight, width: 0, height: 0)
            if let objectId = user.objectId {
                let query = PFQuery(className: "BridgePairings")
                query.whereKey("connecter_objectId", equalTo: objectId)
                query.whereKey("user1_response", equalTo: 1)
                query.whereKey("user2_response", equalTo: 1)
                query.whereKey("accepted_notification_viewed", equalTo: true)
                let secondsPerWeek = 60*60*24*7.0
                let dateOneWeekAgo = Date.init(timeIntervalSinceNow: -1.0 * secondsPerWeek)
                query.whereKey("updatedAt", greaterThanOrEqualTo: dateOneWeekAgo) // filter on past week
                query.limit = 1000
                query.countObjectsInBackground(block: { (count, error) in
                    print("numNected query executing...")
                    if let error = error {
                        print("numNected findObjectsInBackgroundWithBlock error - \(error)")
                    }
                    else {
                        let numNected = Int(count)
                        if numNected == 0 {
                            self.numNectedLastWeekLabel.text = "You've 'nected 0 new connections\nin the past week."
                        } else if numNected == 1 {
                            self.numNectedLastWeekLabel.text = "You've 'nected 1 new connection\nin the past week. Sweet!"
                        } else {
                            self.numNectedLastWeekLabel.text = "You've 'nected \(numNected) new connections\nin the past week. Sweet!"
                        }
                        self.numNectedLastWeekLabel.sizeToFit()
                        self.numNectedLastWeekLabel.frame = CGRect(x: 0, y: self.numNectedLastWeekLabel.frame.minY, width: self.numNectedLastWeekLabel.frame.width, height: self.numNectedLastWeekLabel.frame.height)
                        self.numNectedLastWeekLabel.center.x = DisplayUtility.screenWidth / 2
                        self.scrollView.addSubview(self.numNectedLastWeekLabel)
                    }
                })
            }
            
            let statusButtonWidth = 0.11596*DisplayUtility.screenWidth
            let statusButtonHeight = statusButtonWidth
            
            grayOutButtons()
            
            //businessButton.backgroundColor = DisplayUtility.businessBlue
            businessButton.frame = CGRect(x: 0.17716*DisplayUtility.screenWidth, y: bottomHexView.frame.maxY + 0.16*DisplayUtility.screenHeight, width: statusButtonWidth, height: statusButtonHeight)
            businessButton.addTarget(self, action: #selector(statusTypeButtonSelected(_:)), for: .touchUpInside)
            scrollView.addSubview(businessButton)
            
            //loveButton.backgroundColor = DisplayUtility.loveRed
            loveButton.frame = CGRect(x: 0, y: businessButton.frame.minY, width: statusButtonWidth, height: statusButtonHeight)
            loveButton.center.x = DisplayUtility.screenWidth / 2
            loveButton.addTarget(self, action: #selector(statusTypeButtonSelected(_:)), for: .touchUpInside)
            scrollView.addSubview(loveButton)
            
            //friendshipButton.backgroundColor = DisplayUtility.friendshipGreen
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
            
            scrollView.addSubview(friendsAndNectsView)
            
            /*
            let myFriendsButton = UIButton()
            myFriendsButton.setTitle("MY FRIENDS", for: .normal)
            myFriendsButton.setTitleColor(.black, for: .normal)
            myFriendsButton.titleLabel?.textAlignment = .center
            myFriendsButton.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 12)
            myFriendsButton.sizeToFit()
            myFriendsButton.frame = CGRect(x: 0.20*DisplayUtility.screenWidth, y: 0, width: myFriendsButton.frame.width, height: myFriendsButton.frame.height)
            friendsAndNectsView.addSubview(myFriendsButton)
            
            let myNectsButton = UIButton()
            myNectsButton.setTitle("MY 'NECTS", for: .normal)
            myNectsButton.setTitleColor(.gray, for: .normal)
            myNectsButton.titleLabel?.textAlignment = .center
            myNectsButton.titleLabel?.font = myFriendsButton.titleLabel?.font
            myNectsButton.sizeToFit()
            myNectsButton.frame = CGRect(x: 0, y: myFriendsButton.frame.minY, width: myNectsButton.frame.width, height: myNectsButton.frame.height)
            myNectsButton.center.x = DisplayUtility.screenWidth - myFriendsButton.center.x
            friendsAndNectsView.addSubview(myNectsButton)
            
            let myFriendsSerachController = UISearchController(searchResultsController: nil)
            myFriendsSerachController.searchResultsUpdater = self
            myFriendsSerachController.dimsBackgroundDuringPresentation = false
            
            
            let myFriendsSearchBar = UISearchBar()
            myFriendsSearchBar.frame = CGRect(x:0, y: myFriendsButton.frame.maxY + 0.01*DisplayUtility.screenHeight, width: 0.92089*DisplayUtility.screenWidth, height: 0.04029*DisplayUtility.screenHeight)
            myFriendsSearchBar.center.x = DisplayUtility.screenWidth / 2
            myFriendsSearchBar.showsCancelButton = false
            myFriendsSearchBar.layer.cornerRadius = 10
            friendsAndNectsView.addSubview(myFriendsSearchBar)
            
            friendsAndNectsView.frame = CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: myFriendsSearchBar.frame.maxY)
                */
 
            layoutBottomBasedOnStatus()
        }
        
    }
    
    func setImageToHexagon(image: UIImage, hexView: HexagonView) {
        if let newImage = self.fitImageToView(viewSize: hexView.frame.size, image: image) {
            hexView.hexBackgroundColor = UIColor(patternImage: newImage)
        } else {
            hexView.hexBackgroundColor = UIColor(patternImage: image)
        }
        DispatchQueue.main.async {
            hexView.setNeedsDisplay()
        }
    }
    func fitImageToView(viewSize: CGSize, image: UIImage) -> UIImage? {
        //TODO: Keep image proportions constant
        var resultImage: UIImage?
        UIGraphicsBeginImageContext(viewSize)
        image.draw(in: CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height))
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return resultImage;
    }
    
    //Send user to the userSettingsViewController so they can update their settings
    //For now this is logging the user out and sending them to the access page
    func userSettingsButtonTapped(_ sender: UIButton) {
//        PFUser.logOut()
//        performSegue(withIdentifier: "showAccess", sender: self)
        performSegue(withIdentifier: "showUserSettings", sender: self)
    }
    
    //Send user to the editProfileViewController so they can edit their profile
    func editProfileButtonTapped(_ sender: UIButton) {
        //performSegue(withIdentifier: "showEditProfileFromMyProfile", sender: self)
        present(EditProfileViewController(), animated: false, completion: nil)
    }
    
    //Send user back to the bridgeViewController
    func goBack(_ sender: UIButton) {
        performSegue(withIdentifier: "showBridgePageFromMyProfile", sender: self)
    }
    
    func statusTypeButtonSelected(_ sender: UIButton) {
        grayOutButtons()
        var type = ""
        var statusSet = false
        
        // TODO: Turn off buttons if same one selected

        if sender == businessButton {
            if let bridgeStatus = localData.getBusinessStatus() {
                statusSet = true
                self.businessStatus = bridgeStatus
            }
            businessButton.setImage(UIImage(named: "MyProfile_Selected_Work"), for: .normal)
            type = "Business"
            statusLabel.text = businessStatus
            statusLabel.frame = CGRect(x: 0, y: self.businessButton.frame.maxY + 0.04*DisplayUtility.screenHeight, width: 0.9*DisplayUtility.screenWidth, height: 0)
            statusLabel.sizeToFit()
            statusLabel.center.x = DisplayUtility.screenWidth / 2
            layoutBottomBasedOnStatus()
        } else if sender == loveButton {
            if let bridgeStatus = localData.getLoveStatus() {
                statusSet = true
                self.loveStatus = bridgeStatus
            }
            loveButton.setImage(UIImage(named: "MyProfile_Selected_Dating"), for: .normal)
            type = "Love"
            statusLabel.text = loveStatus
            statusLabel.frame = CGRect(x: 0, y: self.businessButton.frame.maxY + 0.04*DisplayUtility.screenHeight, width: 0.9*DisplayUtility.screenWidth, height: 0)
            statusLabel.sizeToFit()
            statusLabel.center.x = DisplayUtility.screenWidth / 2
            layoutBottomBasedOnStatus()
        } else {
            if let bridgeStatus = localData.getFriendshipStatus() {
                statusSet = true
                self.friendshipStatus = bridgeStatus
            }
            friendshipButton.setImage(UIImage(named: "MyProfile_Selected_Friends"), for: .normal)
            type = "Friendship"
            statusLabel.text = friendshipStatus
            statusLabel.frame = CGRect(x: 0, y: self.businessButton.frame.maxY + 0.04*DisplayUtility.screenHeight, width: 0.9*DisplayUtility.screenWidth, height: 0)
            statusLabel.sizeToFit()
            statusLabel.center.x = DisplayUtility.screenWidth / 2
            layoutBottomBasedOnStatus()
        }
        
        self.statusLabel.frame = CGRect(x: 0, y: self.businessButton.frame.maxY + 0.04*DisplayUtility.screenHeight, width: 0.9*DisplayUtility.screenWidth, height: 0)
        
        //Get currentUser's most recent request (a.k.a bridge_status in DB) for selected connection type
        if statusSet {
        //Request already retrived forselected type from local data
            self.statusLabel.sizeToFit()
            self.statusLabel.center.x = DisplayUtility.screenWidth / 2
        }
        //Setting request for selected type from Database when local data is not available
        else if let user = PFUser.current() {
            if let objectId = user.objectId {
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
                                self.statusLabel.text = bridgeStatus
                                self.statusLabel.frame = CGRect(x: 0, y: self.businessButton.frame.maxY + 0.04*DisplayUtility.screenHeight, width: 0.9*DisplayUtility.screenWidth, height: 0)
                                self.statusLabel.sizeToFit()
                                self.statusLabel.center.x = DisplayUtility.screenWidth / 2
                                
                                if type == "Business" {
                                    self.businessStatus = bridgeStatus
                                    self.localData.setBusinessStatus(bridgeStatus)
                                } else if type == "Love" {
                                    self.loveStatus = bridgeStatus
                                    self.localData.setLoveStatus(bridgeStatus)
                                } else if type == "Friendship" {
                                    self.friendshipStatus = bridgeStatus
                                    self.localData.setFriendshipStatus(bridgeStatus)
                                }
                                self.localData.synchronize()
                            }
                        }
                    }
                })
            }
        }
        
        
        
        
        self.layoutBottomBasedOnStatus()
    }
    
    func grayOutButtons() {
        businessButton.setImage(UIImage(named: "MyProfile_Unselected_Work"), for: .normal)
        loveButton.setImage(UIImage(named: "MyProfile_Unselected_Dating"), for: .normal)
        friendshipButton.setImage(UIImage(named: "MyProfile_Unselected_Friends"), for: .normal)
    }
    
    func layoutBottomBasedOnStatus() {
        friendsAndNectsView.frame = CGRect(x: 0, y: statusLabel.frame.maxY + 0.04*DisplayUtility.screenHeight, width: friendsAndNectsView.frame.width, height: friendsAndNectsView.frame.height)
        
        print(friendsAndNectsView.frame)
        
        scrollView.contentSize = CGSize(width: DisplayUtility.screenWidth, height: max(DisplayUtility.screenHeight, friendsAndNectsView.frame.maxY + 0.02*DisplayUtility.screenHeight))
    }
    
    //Setting segue transition information and preparation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination
        let mirror = Mirror(reflecting: vc)
        if mirror.subjectType == BridgeViewController.self {
            self.transitionManager.animationDirection = "Right"
        }
        else if mirror.subjectType == EditProfileViewController.self {
            self.transitionManager.animationDirection = "Left"
        }
        vc.transitioningDelegate = self.transitionManager
    }

}
