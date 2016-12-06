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
    var vc: UIViewController?
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
        
        exitButton.frame = CGRect(x: 0.0204*DisplayUtility.screenWidth, y: 0.04*DisplayUtility.screenHeight, width: 0.0230*DisplayUtility.screenHeight, height: 0.0230*DisplayUtility.screenHeight)
        exitButton.setTitle("X", for: .normal)
        exitButton.titleLabel?.textColor = .white
        exitButton.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 16)
        exitButton.addTarget(self, action: #selector(dismissView(_:)), for: .touchUpInside)
        addSubview(exitButton)
        let newConnectionLabel = UILabel()
        newConnectionLabel.text = "You have one new connection!"
        newConnectionLabel.textColor = .white
        newConnectionLabel.textAlignment = .center
        newConnectionLabel.font = UIFont(name: "BentonSans-Light", size: 23.5)
        newConnectionLabel.adjustsFontSizeToFitWidth = true
        newConnectionLabel.frame = CGRect(x: 0.05*frame.width, y: exitButton.frame.maxY + 0.02*DisplayUtility.screenHeight, width: 0.9*frame.width, height: 0.0491*frame.height)
        addSubview(newConnectionLabel)
        let line = UIView()
        line.frame = CGRect(x: 0.1*frame.width, y: newConnectionLabel.frame.maxY + 0.03*DisplayUtility.screenHeight, width: 0.8*frame.width, height: 1)
        line.backgroundColor = .white
        addSubview(line)
        
        let acceptButtonFrame = CGRect(x: 0.2328*DisplayUtility.screenWidth, y: line.frame.maxY + 0.035*DisplayUtility.screenHeight, width: 0.237*DisplayUtility.screenWidth, height: 0.0593*DisplayUtility.screenHeight)
        acceptButton = DisplayUtility.gradientButton(text: "accept", frame: acceptButtonFrame)
        addSubview(acceptButton)
        
        let ignoreButtonFrame = CGRect(x: 0.5302*DisplayUtility.screenWidth, y: acceptButton.frame.minY, width: acceptButton.frame.width, height: acceptButton.frame.height)
        ignoreButton = DisplayUtility.gradientButton(text: "ignore", frame: ignoreButtonFrame)
        addSubview(ignoreButton)
        
        acceptButton.addTarget(self, action: #selector(accept(_:)), for: .touchUpInside)
        ignoreButton.addTarget(self, action: #selector(ignore(_:)), for: .touchUpInside)
        
        let cardBackground = UIView()
        cardBackground.frame = CGRect(x: 0.075*frame.width, y: acceptButton.frame.maxY + 0.03*frame.height, width: 0.85*frame.width, height: 0.97*frame.height - acceptButton.frame.maxY)
        //cardBackground.frame = CGRect(x: 0.075*frame.width, y: acceptButton.frame.maxY + 0.03*frame.height, width: 0.8586*DisplayUtility.screenWidth, height: 0.5*(0.8178*DisplayUtility.screenHeight))
        cardBackground.backgroundColor = .black
        
        let halfCard = HalfSwipeCard()
        //halfCard.frame = CGRect(x: 0.075*frame.width, y: acceptButton.frame.maxY + 0.03*frame.height, width: 0.85*frame.width, height: 0.85*frame.width)
        halfCard.frame = CGRect(x: 0, y: 0, width: cardBackground.frame.width, height: cardBackground.frame.width)
        
        let name = self.firstNameLastNameInitial(name: newMatch.name)
        
        let profilePicView = UIImageView()
        profilePicView.frame = halfCard.bounds
        let downloader = Downloader()
        let url = URL(string: newMatch.profilePicURL)!
        downloader.imageFromURL(URL: url, imageView: profilePicView, callBack: nil)
        let photoMaskPath = UIBezierPath(roundedRect: profilePicView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 13.379/*0.08*profilePicView.frame.width*/, height: 13.379/*0.1*profilePicView.frame.width*/))
        let profilePicShape = CAShapeLayer()
        profilePicShape.path = photoMaskPath.cgPath
        profilePicView.layer.mask = profilePicShape
        
        let cardMaskPath = UIBezierPath(roundedRect: cardBackground.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 13.379/*0.08*profilePicView.frame.width*/, height: 13.379/*0.1*profilePicView.frame.width*/))
        let cardShape = CAShapeLayer()
        cardShape.path = cardMaskPath.cgPath
        cardBackground.layer.mask = cardShape
        cardBackground.clipsToBounds = true
        addSubview(cardBackground)
        
        halfCard.layoutHalfCard(name: name, status: newMatch.status, photoView: profilePicView, connectionType: newMatch.type)
        
        //applying rounded corners to the topHalf
        //let cardMaskPath = UIBezierPath(roundedRect: halfCard.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 13.379, height: 13.379))
        let halfCardShape = CAShapeLayer()
        //halfCardShape.path = cardMaskPath.cgPath
        halfCardShape.path = photoMaskPath.cgPath
        halfCard.layer.mask = halfCardShape
        halfCard.clipsToBounds = true
        cardBackground.addSubview(halfCard)
        
        
        if let connecterPicURL = newMatch.connecterPicURL {
            let connecterProfilePicView = UIImageView()
            let url = URL(string: connecterPicURL)!
            downloader.imageFromURL(URL: url, imageView: connecterProfilePicView, callBack: nil)
            connecterProfilePicView.frame = CGRect(x: 0.075*cardBackground.frame.width, y: halfCard.frame.maxY + 0.02*frame.height, width: 0.168*frame.width, height: 0.168*frame.width)
            connecterProfilePicView.layer.cornerRadius = connecterProfilePicView.frame.height/2
            connecterProfilePicView.layer.borderWidth = 1
            connecterProfilePicView.layer.borderColor = newMatch.color.cgColor
            connecterProfilePicView.clipsToBounds = true
            cardBackground.addSubview(connecterProfilePicView)
            
            if let connecterName = newMatch.connecterName {
                let connecterNameLabel = UILabel()
                let name = self.firstNameLastNameInitial(name: connecterName)
                connecterNameLabel.text = "Introduced by \(name)"
                connecterNameLabel.textColor = .white
                connecterNameLabel.font = UIFont(name: "BentonSans-Light", size: 20)
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
                let maxHeight : CGFloat = 0.984*cardBackground.frame.height - connecterProfilePicView.frame.maxY
                let rect = reasonForConnectionLabel.attributedText?.boundingRect(with: CGSize(width: 0.7*frame.width, height: maxHeight), options: .usesLineFragmentOrigin, context: nil)
                reasonForConnectionLabel.frame = CGRect(x: 0.1*cardBackground.frame.width, y: connecterProfilePicView.frame.maxY + 0.016*cardBackground.frame.height, width: 0.8*cardBackground.frame.width, height: rect!.size.height+1)
                print("\(maxHeight), \(reasonForConnectionLabel.frame.height)")
                cardBackground.addSubview(reasonForConnectionLabel)
            }
        }
    }
    
    func firstNameLastNameInitial(name: String) -> String {
        let wordsInName = name.components(separatedBy: " ")
        let firstName: String
        if wordsInName.count > 0 {
            firstName = wordsInName.first!
        } else {
            firstName = name
        }
        var firstNameLastNameInitial = firstName
        if wordsInName.count > 1 {
            firstNameLastNameInitial += " \(wordsInName.last!.characters.first!)."
        }
        return firstNameLastNameInitial
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setVC(vc: UIViewController) {
        self.vc = vc
    }
            
    func dismissView(_ sender: UIButton) {
        self.removeFromSuperview()
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
                        message.saveInBackground()
                    }
                    
                }
            }
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
            self.removeFromSuperview()
            if let vc = self.vc {
                vc.viewDidLoad()
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
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
            self.removeFromSuperview()
            if let vc = self.vc {
                vc.viewDidLoad()
            }
        })
    }
}
