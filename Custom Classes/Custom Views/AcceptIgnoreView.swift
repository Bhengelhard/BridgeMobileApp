//
//  AcceptIgnoreViewController.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 11/21/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class AcceptIgnoreView: UIView {
    
    var newMatch: NewMatch
    var vc: MessagesViewController?
    let exitButton = UIButton()
    var acceptButton = UIButton()
    var ignoreButton = UIButton()
    let newConnectionLabel = UILabel()
    var numNewConnections = 1
    
    init(newMatch: NewMatch) {
        self.newMatch = newMatch
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight))
                
        self.alpha = 0
        let displayUtility = DisplayUtility()
        displayUtility.setBlurredView(viewToBlur: self)
        
        UIView.animate(withDuration: 0.4, animations: {
            self.alpha = 1
        })
        
        //exitButton.frame = CGRect(x: 0.0204*DisplayUtility.screenWidth, y: 0.04*DisplayUtility.screenHeight, width: 0.0230*DisplayUtility.screenHeight, height: 0.0230*DisplayUtility.screenHeight)
        exitButton.frame = CGRect(x: 0.0204*DisplayUtility.screenWidth, y: 0.04*DisplayUtility.screenHeight, width: 0.97*DisplayUtility.screenWidth, height: 0.043*DisplayUtility.screenHeight)
        exitButton.setTitle("X", for: .normal)
        exitButton.titleLabel?.textColor = .white
        exitButton.titleLabel?.textAlignment = .left
        exitButton.contentHorizontalAlignment = .left
        exitButton.contentVerticalAlignment = .top
        exitButton.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 16)
        exitButton.addTarget(self, action: #selector(dismissView(_:)), for: .touchUpInside)
        addSubview(exitButton)
        
        newConnectionLabel.text = "You have one new connection!"
        newConnectionLabel.textColor = .white
        newConnectionLabel.textAlignment = .center
        newConnectionLabel.font = UIFont(name: "BentonSans-Light", size: 23.5)
        newConnectionLabel.adjustsFontSizeToFitWidth = true
        newConnectionLabel.frame = CGRect(x: 0.05*frame.width, y: 0.083*DisplayUtility.screenHeight, width: 0.9*frame.width, height: 0.0491*frame.height)
        addSubview(newConnectionLabel)
        
        let line = UIView()
        line.frame = CGRect(x: 0.1*frame.width, y: newConnectionLabel.frame.maxY + 0.03*DisplayUtility.screenHeight, width: 0.8*frame.width, height: 1)
        line.backgroundColor = .white
        addSubview(line)
        
        let acceptButtonFrame = CGRect(x: 0.2328*DisplayUtility.screenWidth, y: line.frame.maxY + 0.035*DisplayUtility.screenHeight, width: 0.225*DisplayUtility.screenWidth, height: 0.058*DisplayUtility.screenHeight)
        acceptButton = DisplayUtility.gradientButton(frame: acceptButtonFrame, text: "accept", textColor: UIColor.white, fontSize: 20)
        addSubview(acceptButton)
        
        let ignoreButtonFrame = CGRect(x: 0.5422*DisplayUtility.screenWidth, y: acceptButton.frame.minY, width: acceptButton.frame.width, height: acceptButton.frame.height)
        ignoreButton = DisplayUtility.gradientButton(frame: ignoreButtonFrame, text: "ignore", textColor: UIColor.white, fontSize: 20)
        addSubview(ignoreButton)
        
        acceptButton.addTarget(self, action: #selector(accept(_:)), for: .touchUpInside)
        ignoreButton.addTarget(self, action: #selector(ignore(_:)), for: .touchUpInside)
        
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0.075*frame.width, y: acceptButton.frame.maxY + 0.03*frame.height, width: 0.85*frame.width, height: 0.97*frame.height - acceptButton.frame.maxY)
        addSubview(scrollView)
        
        let halfCard = HalfSwipeCard()
        //halfCard.frame = CGRect(x: 0.075*frame.width, y: acceptButton.frame.maxY + 0.03*frame.height, width: 0.85*frame.width, height: 0.85*frame.width)
        halfCard.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.width)
        
        let name = DisplayUtility.firstNameLastNameInitial(name: newMatch.name)
        
        var profilePicView = UIImageView()
        if let profilePic = newMatch.profilePic {
            profilePicView = UIImageView(image: profilePic)
        } else if let url = URL(string: newMatch.profilePicURL) {
            let downloader = Downloader()
            downloader.imageFromURL(URL: url, imageView: profilePicView, callBack: nil)
        }
        profilePicView.frame = halfCard.bounds
        let photoMaskPath = UIBezierPath(roundedRect: profilePicView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 13.379, height: 13.379))
        let profilePicShape = CAShapeLayer()
        profilePicShape.path = photoMaskPath.cgPath
        profilePicView.layer.mask = profilePicShape
        
        halfCard.layoutHalfCard(name: name, status: newMatch.status, photoView: profilePicView, connectionType: newMatch.type)
        //addSubview(halfCard)
        
        let cardBackground = UIView()
        cardBackground.frame = CGRect(x: halfCard.frame.minX, y: halfCard.frame.maxY, width: halfCard.frame.width, height: scrollView.frame.height - halfCard.frame.maxY)
        cardBackground.backgroundColor = .black
        //addSubview(cardBackground)
        
        scrollView.addSubview(halfCard)
        scrollView.addSubview(cardBackground)
        //scrollView.sizeToFit()
        
        var connecterProfilePicView: UIImageView? = nil
        if let connecterPic = newMatch.connecterPic {
            connecterProfilePicView = UIImageView(image: connecterPic)
        } else if let connecterPicURL = newMatch.connecterPicURL {
            if let url = URL(string: connecterPicURL) {
                connecterProfilePicView = UIImageView()
                let downloader = Downloader()
                downloader.imageFromURL(URL: url, imageView: connecterProfilePicView!, callBack: nil)
            }
        }
        if let connecterProfilePicView = connecterProfilePicView {
            connecterProfilePicView.frame = CGRect(x: 0.075*cardBackground.frame.width, y: 0.07*cardBackground.frame.height, width: 0.197*cardBackground.frame.width, height: 0.197*cardBackground.frame.width)
            connecterProfilePicView.layer.cornerRadius = connecterProfilePicView.frame.height/2
            connecterProfilePicView.layer.borderWidth = 1
            connecterProfilePicView.layer.borderColor = newMatch.color.cgColor
            connecterProfilePicView.clipsToBounds = true
            connecterProfilePicView.contentMode = UIViewContentMode.scaleAspectFill
            cardBackground.addSubview(connecterProfilePicView)
            
            if let connecterName = newMatch.connecterName {
                let connecterNameLabel = UILabel()
                let name = DisplayUtility.firstNameLastNameInitial(name: connecterName)
                connecterNameLabel.text = "'nected by \(name)"
                connecterNameLabel.textColor = .white
                connecterNameLabel.font = UIFont(name: "BentonSans-Light", size: 30)
                connecterNameLabel.adjustsFontSizeToFitWidth = true
                connecterNameLabel.frame = CGRect(x: connecterProfilePicView.frame.maxX + 0.05*cardBackground.frame.width, y: 0, width: 0.875*cardBackground.frame.width - connecterProfilePicView.frame.maxX, height: connecterProfilePicView.frame.height)
                connecterNameLabel.center.y = connecterProfilePicView.center.y
                cardBackground.addSubview(connecterNameLabel)
            }
            
            if let reasonForConnection = newMatch.reasonForConnection {
                let reasonForConnectionLabel = UILabel()
                reasonForConnectionLabel.text = "\"\(reasonForConnection)\""
                reasonForConnectionLabel.textColor = .white
                reasonForConnectionLabel.font = UIFont(name: "BentonSans-Light", size: 17)
                reasonForConnectionLabel.textAlignment = .center
                reasonForConnectionLabel.lineBreakMode = .byWordWrapping
                reasonForConnectionLabel.numberOfLines = 0
                reasonForConnectionLabel.adjustsFontSizeToFitWidth = true
                reasonForConnectionLabel.minimumScaleFactor = 0.5
                /*
                let maxHeight : CGFloat = 0.99*cardBackground.frame.height - connecterProfilePicView.frame.maxY
                let rect = reasonForConnectionLabel.attributedText?.boundingRect(with: CGSize(width: 0.9*cardBackground.frame.width, height: maxHeight), options: .usesLineFragmentOrigin, context: nil)
                reasonForConnectionLabel.frame = CGRect(x: 0, y: connecterProfilePicView.frame.maxY + 0.06*cardBackground.frame.height, width: rect!.size.width, height: rect!.size.height+1)
                */
                reasonForConnectionLabel.frame = CGRect(x: 0, y: connecterProfilePicView.frame.maxY + 0.06*cardBackground.frame.height, width: 0.9*cardBackground.frame.width, height: 0)
                reasonForConnectionLabel.sizeToFit()
                //print("reason: \(reasonForConnectionLabel.frame.maxY)")
                reasonForConnectionLabel.center.x = cardBackground.bounds.midX
                cardBackground.addSubview(reasonForConnectionLabel)
                cardBackground.frame = CGRect(x: cardBackground.frame.minX, y: cardBackground.frame.minY, width: cardBackground.frame.width, height: max(cardBackground.frame.height, reasonForConnectionLabel.frame.maxY + 10))
            }
        }
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: cardBackground.frame.maxY)
        //scrollView.clipsToBounds = true
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        
        //print ("screen: \(DisplayUtility.screenHeight), card: \(cardBackground.frame.maxY)/\(cardBackground.frame.height), scroll: \(scrollView.frame.minY)/\(scrollView.frame.maxY)/\(scrollView.frame.height)/\(scrollView.contentSize.height)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setVC(vc: MessagesViewController) {
        self.vc = vc
        
        //Setting the newConnectionLabel to the number of new connections
        updateNumNewConnections()
        
    }
    
    //Updating the number of new connections and updating the newConnectionsLabel
    func updateNumNewConnections() {
        if let messagesVC = vc {
            let newMatches = messagesVC.newMatchesView.allNewMatches
            var count = 0
            for match in newMatches {
                if match.dot {
                    count += 1
                }
            }
            numNewConnections = count
            
            //Updating the newConnections label to the newly found numNewConnections
            updateNewConnectionsLabel()
        }
        
    }
    //Updating new connections label with text displaying the number of new matches that have not been ignored in the matches view
    func updateNewConnectionsLabel() {
        if numNewConnections == 0 {
            newConnectionLabel.text = "You have no new connections."
        } else if numNewConnections == 1 {
            newConnectionLabel.text = "You have one new connection!"
        } else if numNewConnections < 10 {
            var countAsText = String()
            switch (numNewConnections) {
            case 1: countAsText = "one"
            case 2: countAsText = "two"
            case 3: countAsText = "three"
            case 4: countAsText = "four"
            case 5: countAsText = "five"
            case 6: countAsText = "six"
            case 7: countAsText = "seven"
            case 8: countAsText = "eight"
            case 9: countAsText = "nine"
            default: countAsText = ""
            }
            newConnectionLabel.text = "You have \(countAsText) new connections!"
        } else {
            newConnectionLabel.text = "You have \(numNewConnections) new connections!"
        }
    }
    
    func phaseOut() {
        self.alpha = 1
        UIView.animate(withDuration: 0.4, animations: {
            self.alpha = 0
        })
    }
    
    func dismissView(_ sender: UIButton) {
        print("dismissView Tapped")
        self.phaseOut()
    }
    
    func displayWaitingForOtherUserNotification() {
        //Reloading messages view controller for when the user exits the AcceptIgnoreView
        if let vc = self.vc {
            vc.loadNewMatches()
        }
        
        //Setting the waiting for other user label
        let waitingForOtherUserLabel = UILabel()
        waitingForOtherUserLabel.frame.size = CGSize(width: 0.8*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenHeight)
        waitingForOtherUserLabel.center.x = self.center.x
        waitingForOtherUserLabel.center.y = acceptButton.center.y
        if let firstName = newMatch.name.components(separatedBy: " ").first {
            waitingForOtherUserLabel.text = "Stay tuned! We'll let you know when \(firstName) accepts."
        } else {
            waitingForOtherUserLabel.text = "Stay tuned! We'll let you know when they accept."
        }
        waitingForOtherUserLabel.textColor = .white
        waitingForOtherUserLabel.textAlignment = NSTextAlignment.center
        waitingForOtherUserLabel.font = UIFont(name: "BentonSans-Light", size: 18)
        waitingForOtherUserLabel.numberOfLines = 2
        waitingForOtherUserLabel.alpha = 0
        addSubview(waitingForOtherUserLabel)
        
        
        UIView.animate(withDuration: 0.02, animations: {
            waitingForOtherUserLabel.alpha = 1
            self.acceptButton.alpha = 0
            self.ignoreButton.alpha = 0
        }) { (success) in
            if success {
                self.numNewConnections -= 1
                self.updateNewConnectionsLabel()
                self.acceptButton.removeFromSuperview()
                self.ignoreButton.removeFromSuperview()
            }
        }
    }
    
    func accept(_ sender: UIButton) {
        //setting buttons to false so user cannot click them during transition
        //exitButton.isEnabled = false
        ignoreButton.isEnabled = false
        acceptButton.isEnabled = false
        
        //Saving user's decision to accept
        let query: PFQuery = PFQuery(className: "BridgePairings")
        query.whereKey("objectId", equalTo: newMatch.objectId)
        query.limit = 1
        query.findObjectsInBackground(block: { (results, error) -> Void in
            if let error = error {
                print("refresh findObjectsInBackgroundWithBlock error - \(error)")
            }
            else if let results = results {
                if results.count > 0 {
                    let result = results[0]
                    
                    //decrease the badgeCount by 1
                    if let currentUserResponse = result["\(self.newMatch.user)_response"] as? Int {
                        if currentUserResponse == 0 {
                            DBSavingFunctions.decrementBadge()
                        }
                    } else {
                        DBSavingFunctions.decrementBadge()
                    }
                    
                    //setting currentUser's response to 1 after acceptance
                    result["\(self.newMatch.user)_response"] = 1
                    let otherUser = self.newMatch.user == "user1" ? "user2" : "user1"
                    result.saveInBackground()
                    
                    //checking if other user has already accepted
                    if result["\(otherUser)_response"] as! Int == 1 {
                        let message = PFObject(className: "Messages")
                        let acl = PFACL()
                        acl.getPublicReadAccess = true
                        acl.getPublicWriteAccess = true
                        message.acl = acl

                        message["names_in_message"] = [
                            result["\(self.newMatch.user)_name"],
                            result["\(otherUser)_name"]
                        ]
                        message["message_type"] = result["bridge_type"]
                        if self.newMatch.user == "user1" {
                            message["ids_in_message"] = [
                                result["user_objectId1"],
                                result["user_objectId2"]
                            ]
                        } else {
                            message["ids_in_message"] = [
                                result["user_objectId2"],
                                result["user_objectId1"]
                            ]
                        }
                        message["no_of_single_messages"] = 1
                        message["profile_picture_urls"] = [
                            result["\(self.newMatch.user)_profile_picture_url"],
                            result["\(otherUser)_profile_picture_url"]
                        ]
                        message["lastSingleMessageAt"] = Date()
                        let userObjectId1 = (message["ids_in_message"] as! [String])[0]
                        message["user1_objectId"] = userObjectId1
                        let userObjectId2 = (message["ids_in_message"] as! [String])[1]
                        message["user2_objectId"] = userObjectId2
                        message["user1_name"] = result["\(self.newMatch.user)_name"]
                        let otherUserName = result["\(otherUser)_name"]
                        message["user2_name"] = otherUserName
                        message["user1_profile_picture_url"] = result["\(self.newMatch.user)_profile_picture_url"]
                        message["user2_profile_picture_url"] = result["\(otherUser)_profile_picture_url"]
                        message["message_viewed"] = [String]()
                        message["bridge_builder"] = result["connecter_objectId"]
                        message["message_type"] = self.newMatch.type
                        message["message_viewed"] = [PFUser.current()?.objectId]
                        message.saveInBackground(block: { (succeeded: Bool, error: Error?) in
                            if error != nil {
                                print(error)
                            } else if succeeded {
                                //Adding users to eachothers FriendLists
                                let pfCloudFunctions = PFCloudFunctions()
                                pfCloudFunctions.addIntroducedUsersToEachothersFriendLists(parameters: ["userObjectId1": userObjectId1, "userObjectId2": userObjectId2])
                                
                                //Close current View with fade
                                self.phaseOut()
                                
                                //Reload MessagesVC and transition to single message
                                if let vc = self.vc {
                                    vc.viewDidLoad()
                                    if let messageId = message.objectId {
                                        if let name = otherUserName as? String {
                                            vc.transitionToMessageWithID(messageId, color: self.newMatch.color, title: name)
                                        } else {
                                            vc.transitionToMessageWithID(messageId, color: self.newMatch.color, title: "Conversation")
                                        }
                                    }
                                }
                            }
                            
                        })
                    }
                    //If the other user has not yet accepted
                    else {
                        //Display label telling the user they will be notified when the other user accepts
                        //self.exitButton.isEnabled = true
                        self.displayWaitingForOtherUserNotification()
                        
//                        self.phaseOut()
//                        print("phasing out")
//                        if let currentView = self.vc?.view {
////                            let sendingNotificationView = SendingNotificationView()
////                            sendingNotificationView.initialize(view: currentView, sendingText: "Accepting...", successText: "Accepted")
////                            currentView.addSubview(sendingNotificationView)
////                            currentView.bringSubview(toFront: sendingNotificationView)
//                            
//
//                            
//                        }
                        
                    }
                }
            }
        })
    }
    
    func ignore(_ sender: UIButton) {
        let query: PFQuery = PFQuery(className: "BridgePairings")
        query.whereKey("objectId", equalTo: newMatch.objectId)
        query.limit = 1
        query.findObjectsInBackground(block: { (results, error) -> Void in
            if let error = error {
                print("refresh findObjectsInBackgroundWithBlock error - \(error)")
            }
            else if let results = results {
                if results.count > 0 {
                    let result = results[0]
                    //decrease the badgeCount by 1
                    if let currentUserResponse = result["\(self.newMatch.user)_response"] as? Int {
                        if currentUserResponse == 0 {
                            DBSavingFunctions.decrementBadge()
                        }
                    } else {
                        DBSavingFunctions.decrementBadge()
                    }
                    
                    result["\(self.newMatch.user)_response"] = 2
                    result.saveInBackground(block: { (succeeded: Bool, error: Error?) in
                        self.phaseOut()
                        if let vc = self.vc {
                            vc.loadNewMatches()
                        }
                    })
                }
                
            }
        })
    }
}
