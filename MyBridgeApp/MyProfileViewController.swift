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
    var businessStatus: String?
    var loveStatus: String?
    var friendshipStatus: String?
    let friendsAndNectsView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        scrollView.frame = CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight)
        view.addSubview(scrollView)
        
        scrollView.backgroundColor = .clear
                
        if let user = PFUser.current() {
            
            backArrow.setImage(UIImage(named: "Dark_Arrow"), for: .normal)
            backArrow.frame = CGRect(x: 0.90015*DisplayUtility.screenWidth, y: 0.04969*DisplayUtility.screenHeight, width: 0.0533*DisplayUtility.screenWidth, height: 0.02181*DisplayUtility.screenHeight)
            backArrow.addTarget(self, action: #selector(goBack(_:)), for: .touchUpInside)
            view.addSubview(backArrow)
            
            welcomeLabel.textColor = .black
            welcomeLabel.textAlignment = .center
            welcomeLabel.font = UIFont(name: "BentonSans-Light", size: 21)
            if let name = localData.getUsername() {
                let firstName = DisplayUtility.firstName(name: name)
                welcomeLabel.text = "Welcome back, \(firstName)."
                welcomeLabel.sizeToFit()
                welcomeLabel.frame = CGRect(x: 0, y: backArrow.frame.minY + 0.00265*DisplayUtility.screenHeight, width: welcomeLabel.frame.width, height: welcomeLabel.frame.height)
                welcomeLabel.center.x = DisplayUtility.screenWidth / 2
                view.addSubview(welcomeLabel)
            }
            
            numNectedLabel.textColor = .gray
            numNectedLabel.textAlignment = .center
            numNectedLabel.font = UIFont(name: "BentonSans-Light", size: 12)
            numNectedLabel.frame = CGRect(x: 0, y: welcomeLabel.frame.maxY + 0.0075*DisplayUtility.screenHeight, width: 0, height: 0)
            if let objectId = user.objectId {
                let query = PFQuery(className: "BridgePairings")
                query.whereKey("connecter_objectId", equalTo: objectId)
                query.whereKey("user1_response", equalTo: 1)
                query.whereKey("user2_response", equalTo: 1)
                query.whereKey("accepted_notification_viewed", equalTo: true)
                query.limit = 1000
                query.findObjectsInBackground(block: { (results, error) in
                    print("numNected query executing...")
                    if let error = error {
                        print("numNected findObjectsInBackgroundWithBlock error - \(error)")
                    }
                    else if let results = results {
                        self.numNectedLabel.text = "\(results.count) CONNECTIONS 'NECTED"
                        self.numNectedLabel.sizeToFit()
                        self.numNectedLabel.frame = CGRect(x: 0, y: self.numNectedLabel.frame.minY, width: self.numNectedLabel.frame.width, height: self.numNectedLabel.frame.height)
                        self.numNectedLabel.center.x = DisplayUtility.screenWidth / 2
                        self.view.addSubview(self.numNectedLabel)
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
            print(userSettingsButton.frame.height / userSettingsButton.frame.width)
            scrollView.addSubview(userSettingsButton)
            
            editProfileButton.setImage(UIImage(named: "EditProfile_Button"), for: .normal)
            editProfileButton.frame = CGRect(x: 0.61753*DisplayUtility.screenWidth, y: userSettingsButton.frame.minY, width: upperButtonsWidth, height: upperButtonsHeight)
            scrollView.addSubview(editProfileButton)
            
            let hexWidth = 0.38154*DisplayUtility.screenWidth
            let hexHeight = hexWidth * sqrt(3) / 2
            
            let downloader = Downloader()
            
            topHexView.frame = CGRect(x: 0, y: userSettingsButton.frame.maxY + 0.033*DisplayUtility.screenHeight, width: hexWidth, height: hexHeight)
            topHexView.center.x = DisplayUtility.screenWidth / 2
            if let urlString = user["profile_picture_url"] as? String, let url = URL(string: urlString) {
                downloader.imageFromURL(URL: url, callBack: { (image) in
                    if let newImage = self.fitImageToView(viewSize: self.topHexView.frame.size, image: image) {
                        self.topHexView.hexBackgroundColor = UIColor(patternImage: newImage)
                    } else {
                        self.topHexView.hexBackgroundColor = UIColor(patternImage: image)
                    }
                    DispatchQueue.main.async {
                        self.topHexView.setNeedsDisplay()
                    }
                })
            }
            scrollView.addSubview(topHexView)
            
            leftHexView.frame = CGRect(x: topHexView.frame.minX - 0.75*hexWidth - 3, y: topHexView.frame.midY + 2, width: hexWidth, height: hexHeight)
            if let urlString = user["profile_picture_url"] as? String, let url = URL(string: urlString) {
                downloader.imageFromURL(URL: url, callBack: { (image) in
                    if let newImage = self.fitImageToView(viewSize: self.leftHexView.frame.size, image: image) {
                        self.leftHexView.hexBackgroundColor = UIColor(patternImage: newImage)
                    } else {
                        self.leftHexView.hexBackgroundColor = UIColor(patternImage: image)
                    }
                    DispatchQueue.main.async {
                        self.leftHexView.setNeedsDisplay()
                    }
                })
            }
            scrollView.addSubview(leftHexView)
            
            rightHexView.frame = CGRect(x: topHexView.frame.minX + 0.75*hexWidth + 3, y: topHexView.frame.midY + 2, width: hexWidth, height: hexHeight)
            if let urlString = user["profile_picture_url"] as? String, let url = URL(string: urlString) {
                downloader.imageFromURL(URL: url, callBack: { (image) in
                    if let newImage = self.fitImageToView(viewSize: self.rightHexView.frame.size, image: image) {
                        self.rightHexView.hexBackgroundColor = UIColor(patternImage: newImage)
                    } else {
                        self.rightHexView.hexBackgroundColor = UIColor(patternImage: image)
                    }
                    DispatchQueue.main.async {
                        self.rightHexView.setNeedsDisplay()
                    }
                })
            }
            scrollView.addSubview(rightHexView)
            
            bottomHexView.frame = CGRect(x: topHexView.frame.minX, y: topHexView.frame.maxY + 4, width: hexWidth, height: hexHeight)
            if let urlString = user["profile_picture_url"] as? String, let url = URL(string: urlString) {
                downloader.imageFromURL(URL: url, callBack: { (image) in
                    if let newImage = self.fitImageToView(viewSize: self.bottomHexView.frame.size, image: image) {
                        self.bottomHexView.hexBackgroundColor = UIColor(patternImage: newImage)
                    } else {
                        self.bottomHexView.hexBackgroundColor = UIColor(patternImage: image)
                    }
                    DispatchQueue.main.async {
                        self.bottomHexView.setNeedsDisplay()
                    }
                })
            }
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
                query.findObjectsInBackground(block: { (results, error) in
                    print("numNected query executing...")
                    if let error = error {
                        print("numNected findObjectsInBackgroundWithBlock error - \(error)")
                    }
                    else if let results = results {
                        if results.count == 0 {
                            self.numNectedLastWeekLabel.text = "You've 'nected 0 new connections\nin the past week."
                        } else if results.count == 1 {
                            self.numNectedLastWeekLabel.text = "You've 'nected 1 new connection\nin the past week. Sweet!"
                        } else {
                            self.numNectedLastWeekLabel.text = "You've 'nected \(results.count) new connections\nin the past week. Sweet!"
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
    
    func fitImageToView(viewSize: CGSize, image: UIImage) -> UIImage? {
        var resultImage: UIImage?
        UIGraphicsBeginImageContext(viewSize)
        image.draw(in: CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height))
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return resultImage;
    }
    
    func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func statusTypeButtonSelected(_ sender: UIButton) {
        grayOutButtons()
        var type = ""
        if sender == businessButton {
            businessButton.setImage(UIImage(named: "MyProfile_Selected_Work"), for: .normal)
            type = "Business"
            if let status = businessStatus {
                statusLabel.text = status
                statusLabel.frame = CGRect(x: 0, y: self.businessButton.frame.maxY + 0.04*DisplayUtility.screenHeight, width: 0.9*DisplayUtility.screenWidth, height: 0)
                statusLabel.sizeToFit()
                statusLabel.center.x = DisplayUtility.screenWidth / 2
                layoutBottomBasedOnStatus()
                return
            }
        } else if sender == loveButton {
            loveButton.setImage(UIImage(named: "MyProfile_Selected_Dating"), for: .normal)
            type = "Love"
            if let status = loveStatus {
                statusLabel.text = status
                statusLabel.frame = CGRect(x: 0, y: self.businessButton.frame.maxY + 0.04*DisplayUtility.screenHeight, width: 0.9*DisplayUtility.screenWidth, height: 0)
                statusLabel.sizeToFit()
                statusLabel.center.x = DisplayUtility.screenWidth / 2
                layoutBottomBasedOnStatus()
                return
            }
        } else {
            friendshipButton.setImage(UIImage(named: "MyProfile_Selected_Friends"), for: .normal)
            type = "Friendship"
            if let status = friendshipStatus {
                statusLabel.text = status
                statusLabel.frame = CGRect(x: 0, y: self.businessButton.frame.maxY + 0.04*DisplayUtility.screenHeight, width: 0.9*DisplayUtility.screenWidth, height: 0)
                statusLabel.sizeToFit()
                statusLabel.center.x = DisplayUtility.screenWidth / 2
                layoutBottomBasedOnStatus()
                return
            }
        }
        
        if let user = PFUser.current() {
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
                                } else if type == "Love" {
                                    self.loveStatus = bridgeStatus
                                } else if type == "Friendship" {
                                    self.friendshipStatus = bridgeStatus
                                }
                                
                                self.layoutBottomBasedOnStatus()
                            }
                        }
                    }
                })
            }
        }
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

}
