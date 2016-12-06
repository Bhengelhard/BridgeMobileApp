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
        
        let newConnectionLabel = UILabel()
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
        acceptButton = DisplayUtility.gradientButton(text: "accept", frame: acceptButtonFrame)
        addSubview(acceptButton)
        
        let ignoreButtonFrame = CGRect(x: 0.5422*DisplayUtility.screenWidth, y: acceptButton.frame.minY, width: acceptButton.frame.width, height: acceptButton.frame.height)
        ignoreButton = DisplayUtility.gradientButton(text: "ignore", frame: ignoreButtonFrame)
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
            print ("profile pic stored")
            profilePicView = UIImageView(image: profilePic)
        } else if let url = URL(string: newMatch.profilePicURL) {
            print ("profile pic not stored; must download")
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
            print ("connecter pic stored")
            connecterProfilePicView = UIImageView(image: connecterPic)
        } else if let connecterPicURL = newMatch.connecterPicURL {
            if let url = URL(string: connecterPicURL) {
                print ("connecter pic not stored; must download")
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
    }
    
    func phaseOut() {
        self.alpha = 1
        UIView.animate(withDuration: 0.4, animations: {
            self.alpha = 0
        })
    }
            
    func dismissView(_ sender: UIButton) {
        self.phaseOut()
    }
    
    func accept(_ sender: UIButton) {
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
                    result["\(self.newMatch.user)_response"] = 1
                    result.saveInBackground()
                    let otherUser = self.newMatch.user == "user1" ? "user2" : "user1"
                    if result["\(otherUser)_response"] as! Int == 1 {
                        print("creating message")
                        let message = PFObject(className: "Messages")
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
                        message["user1_objectId"] = (message["ids_in_message"] as! [String])[0]
                        message["user2_objectId"] = (message["ids_in_message"] as! [String])[1]
                        message["user1_name"] = result["\(self.newMatch.user)_name"]
                        message["user2_name"] = result["\(otherUser)_name"]
                        message["user1_profile_picture_url"] = result["\(self.newMatch.user)_profile_picture_url"]
                        message["user2_profile_picture_url"] = result["\(otherUser)_profile_picture_url"]
                        message["message_viewed"] = [String]()
                        message["bridge_builder"] = result["connecter_objectId"]
                        message.saveInBackground(block: { (succeeded: Bool, error: Error?) in
                            self.phaseOut()
                            if let vc = self.vc {
                                vc.viewDidLoad()
                                if let messageId = message.objectId {
                                    vc.transitionToMessageWithID(messageId, color: self.newMatch.color)
                                }
                            }
                        })
                    } else {
                        self.phaseOut()
                        if let vc = self.vc {
                            vc.loadNewMatches()
                        }
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
                    result["\(self.newMatch.user)_response"] = 2
                    result.saveInBackground()
                }
                
            }
        })
        self.phaseOut()
        if let vc = self.vc {
            vc.loadNewMatches()
        }
    }
}
