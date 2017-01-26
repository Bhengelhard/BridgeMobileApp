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
    var navBar: ProfileNavBar?
    let userSettingsButton = UIButton()
    let editProfileButton = UIButton()
    var hexes: ProfileHexagons?
    let numNectedLastWeekLabel = UILabel()
    var statusButtons: ProfileStatusButtons?
    let statusLabel = UILabel()
    let unselectedStatusText = "Click an icon above to see your currently displayed requests."
    let businessStatusPlaceholder = "You have not yet posted a request for work."
    let loveStatusPlaceholder = "You have not yet posted a request for dating."
    let friendshipStatusPlaceholder = "You have not yet posted a request for friendship."
    var businessStatus = ""
    var loveStatus = ""
    var friendshipStatus = ""
    var businessStatusSet = false
    var loveStatusSet = false
    var friendshipStatusSet = false
    let friendsAndNectsView = UIView()
    let transitionManager = TransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set background color to white
        view.backgroundColor = .white
        
        
        if let user = PFUser.current() {
            
            
            // MARK: Navigation Bar
            
            // create image for back button
            let backArrowIcon = UIImageView(image: UIImage(named: "Dark_Arrow"))
            let backArrowWidth = 0.0533*DisplayUtility.screenWidth
            let backArrowHeight = backArrowWidth * 29.095/39.972
            backArrowIcon.frame.size = CGSize(width: backArrowWidth, height: backArrowHeight)
            
            // set text for welcome label
            var welcomeText = String()
            if let name = localData.getUsername() {
                let firstName = DisplayUtility.firstName(name: name)
                welcomeText = "Welcome back, \(firstName)."
            }
            
            // initialize navigation bar
            navBar = ProfileNavBar(leftButtonImageView: nil, leftButtonFunc: nil, rightButtonImageView: backArrowIcon, rightButtonFunc: goBack, mainText: welcomeText, mainTextColor: .black, subTextColor: .gray)
            view.addSubview(navBar!)
            
            // set text for num 'nected label
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
                        let numNectedText = "\(numNected) CONNECTIONS 'NECTED"
                        if let navBar = self.navBar {
                            navBar.updateSubLabel(subText: numNectedText)
                        }
                        
                        // store to local data
                        self.localData.setNumConnectionsNected(numNected)
                        self.localData.synchronize()
                    }
                    
                })
            }
            
            
            // MARK: Scroll View
            
            // make scroll view transparent
            scrollView.backgroundColor = .clear
            
            // place scroll view below navigation bar
            scrollView.frame = CGRect(x: 0, y: navBar!.frame.maxY, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight - navBar!.frame.maxY)
            view.addSubview(scrollView)
            
            
            // MARK: Upper Buttons
            
            let upperButtonsWidth = 0.34666*DisplayUtility.screenWidth
            let upperButtonsHeight = 0.2063*upperButtonsWidth
            
            userSettingsButton.setImage(UIImage(named: "UserSettings_Button"), for: .normal)
            userSettingsButton.frame = CGRect(x: 0.0383*DisplayUtility.screenWidth, y: 0, width: upperButtonsWidth, height: upperButtonsHeight)
            userSettingsButton.adjustsImageWhenHighlighted = false
            userSettingsButton.addTarget(self, action: #selector(userSettingsButtonTapped(_:)), for: .touchUpInside)
            print(userSettingsButton.frame.height / userSettingsButton.frame.width)
            scrollView.addSubview(userSettingsButton)
            
            editProfileButton.setImage(UIImage(named: "EditProfile_Button"), for: .normal)
            editProfileButton.frame = CGRect(x: 0.61753*DisplayUtility.screenWidth, y: userSettingsButton.frame.minY, width: upperButtonsWidth, height: upperButtonsHeight)
            editProfileButton.addTarget(self, action: #selector(editProfileButtonTapped(_:)), for: .touchUpInside)
            scrollView.addSubview(editProfileButton)
            
            
            // MARK: Profile Picture Hexagons
            
            // initialize hexes
            hexes = ProfileHexagons(minY: userSettingsButton.frame.maxY + 0.033*DisplayUtility.screenHeight, parentVC: self, hexImages: [], shouldShowDefaultFrame: false, shouldBeEditable: false)
            scrollView.addSubview(hexes!)
            
            // add images for hexes
            if let profilePics = user["profile_pictures"] as? [PFFile] {
                hexes!.addHexImages(from: profilePics, startingAt: 0)
            }
            
            numNectedLastWeekLabel.textColor = .black
            numNectedLastWeekLabel.textAlignment = .center
            numNectedLastWeekLabel.numberOfLines = 2
            numNectedLastWeekLabel.font = UIFont(name: "BentonSans-Light", size: 19)
            numNectedLastWeekLabel.frame = CGRect(x: 0, y: hexes!.frame.maxY + 0.05*DisplayUtility.screenHeight, width: 0, height: 0)
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
            
            
            // MARK: Statuses
            
            statusButtons = ProfileStatusButtons(minY: hexes!.frame.maxY + 0.16*DisplayUtility.screenHeight, selectType: selectType)
            scrollView.addSubview(statusButtons!)
 
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
            //statusLabel.frame = CGRect(x: 0, y: businessButton.frame.maxY + 0.04*DisplayUtility.screenHeight, width: 0.9*DisplayUtility.screenWidth, height: 0)
            statusLabel.frame = CGRect(x: 0, y: statusButtons!.frame.maxY + 0.04*DisplayUtility.screenHeight, width: 0.9*DisplayUtility.screenWidth, height: 0)
            statusLabel.sizeToFit()
            statusLabel.center.x = DisplayUtility.screenWidth / 2
            scrollView.addSubview(statusLabel)
            
            //scrollView.addSubview(friendsAndNectsView)
            
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
    
    func hexImages() -> [UIImage]? {
        if let hexes = hexes {
            return hexes.getImages()
        }
        return nil
    }
    
    //Send user to the userSettingsViewController so they can update their settings
    func userSettingsButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showUserSettings", sender: self)
    }
    
    //Send user to the editProfileViewController so they can edit their profile
    func editProfileButtonTapped(_ sender: UIButton) {
        let editProfileVC = EditProfileViewController(myProfileVC: self)
        present(editProfileVC, animated: false, completion: nil)
        unselectAllStatusButtons()
    }
    
    //Send user back to the bridgeViewController
    func goBack(_ sender: UIButton) {
        performSegue(withIdentifier: "showBridgePageFromMyProfile", sender: self)
    }
    
    func selectType(type: String?) {
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
                }
            } else {
                self.layoutBottomBasedOnStatus()
            }
        } else { // type is nil
            statusLabel.text = unselectedStatusText
            self.layoutBottomBasedOnStatus()
        }
    }
    
    func unselectAllStatusButtons() {
        if let statusButtons = statusButtons {
            statusButtons.unselectAllStatusButtons()
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
    
    //Setting segue transition information and preparation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination
        let mirror = Mirror(reflecting: vc)
        if mirror.subjectType == BridgeViewController.self {
            self.transitionManager.animationDirection = "Right"
        }
        else if mirror.subjectType == EditProfileViewController.self {
            self.transitionManager.animationDirection = "Left"
        } else if mirror.subjectType == UserSettingsViewController.self {
            self.transitionManager.animationDirection = "Top"
        }
        vc.transitioningDelegate = self.transitionManager
    }

}
