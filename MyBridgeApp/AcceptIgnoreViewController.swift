//
//  AcceptIgnoreViewController.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 11/21/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class AcceptIgnoreViewController: UIViewController {
    
    var newMatch: NewMatch?
    let exitButton = UIButton()
    
    func setNewMatch(newMatch: NewMatch) {
        self.newMatch = newMatch
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        exitButton.frame = CGRect(x: 0.0204*DisplayUtility.screenWidth, y: 0.04*DisplayUtility.screenHeight, width: 0.0230*DisplayUtility.screenHeight, height: 0.0230*DisplayUtility.screenHeight)
        exitButton.setTitle("X", for: .normal)
        exitButton.titleLabel?.textColor = .white
        exitButton.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 16)
        exitButton.addTarget(self, action: #selector(dismissVC(_:)), for: .touchUpInside)
        view.addSubview(exitButton)
        let newConnectionLabel = UILabel()
        newConnectionLabel.text = "You have one new connection!"
        newConnectionLabel.textColor = .white
        newConnectionLabel.font = UIFont(name: "BentonSans-Light", size: 23.5)
        newConnectionLabel.sizeToFit()
        newConnectionLabel.frame = CGRect(x: 0.5*DisplayUtility.screenWidth - newConnectionLabel.frame.width/2, y: exitButton.frame.maxY + 0.02*DisplayUtility.screenHeight, width: newConnectionLabel.frame.width, height: newConnectionLabel.frame.height)
        view.addSubview(newConnectionLabel)
        let line = UIView()
        line.frame = CGRect(x: 0.5*DisplayUtility.screenWidth - 0.45*newConnectionLabel.frame.width, y: newConnectionLabel.frame.maxY + 0.03*DisplayUtility.screenHeight, width: 0.9*newConnectionLabel.frame.width, height: 2)
        line.backgroundColor = .white
        view.addSubview(line)
        
        let acceptButton = UIButton()
        acceptButton.frame = CGRect(x: 0.2828*DisplayUtility.screenWidth, y: line.frame.maxY + 0.035*DisplayUtility.screenHeight, width: 0.1823*DisplayUtility.screenWidth, height: 0.0456*DisplayUtility.screenHeight)
        acceptButton.setTitle("accept", for: .normal)
        acceptButton.backgroundColor = .black
        acceptButton.titleLabel?.textColor = .white
        acceptButton.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 18)
        acceptButton.layer.cornerRadius = 0.1*acceptButton.frame.height
        acceptButton.clipsToBounds = true
        
        let shape1 = CAShapeLayer()
        shape1.lineWidth = 2
        shape1.path = UIBezierPath(rect: acceptButton.bounds).cgPath
        shape1.strokeColor = UIColor.black.cgColor
        shape1.fillColor = UIColor.clear.cgColor
        let gradient1 = DisplayUtility.getGradient()
        gradient1.frame = acceptButton.bounds
        gradient1.mask = shape1
        acceptButton.layer.addSublayer(gradient1)
        view.addSubview(acceptButton)
        
        let ignoreButton = UIButton()
        ignoreButton.frame = CGRect(x: 0.527*DisplayUtility.screenWidth, y: acceptButton.frame.minY, width: acceptButton.frame.width, height: acceptButton.frame.height)
        ignoreButton.setTitle("ignore", for: .normal)
        ignoreButton.backgroundColor = .black
        ignoreButton.titleLabel?.textColor = .white
        ignoreButton.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 18)
        ignoreButton.layer.cornerRadius = 0.1*ignoreButton.frame.height
        ignoreButton.clipsToBounds = true
        
        let shape2 = CAShapeLayer()
        shape2.lineWidth = 2
        shape2.path = UIBezierPath(rect: ignoreButton.bounds).cgPath
        shape2.strokeColor = UIColor.black.cgColor
        shape2.fillColor = UIColor.clear.cgColor
        let gradient2 = DisplayUtility.getGradient()
        gradient2.frame = ignoreButton.bounds
        gradient2.mask = shape2
        ignoreButton.layer.addSublayer(gradient2)
        view.addSubview(ignoreButton)
        
        if let newMatch = newMatch {
            let profilePicView = UIImageView()
            profilePicView.frame = CGRect(x: 0.0725*DisplayUtility.screenWidth, y: acceptButton.frame.maxY + 0.035*DisplayUtility.screenHeight, width: 0.855*DisplayUtility.screenWidth, height: 0.855*DisplayUtility.screenWidth)
            let downloader = Downloader()
            downloader.imageFromURL(URL: newMatch.profilePicURL, imageView: profilePicView, callBack: nil)
            let maskPath = UIBezierPath(roundedRect: profilePicView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 0.08*profilePicView.frame.width, height: 0.1*profilePicView.frame.width))
            let profilePicShape = CAShapeLayer()
            profilePicShape.path = maskPath.cgPath
            profilePicView.layer.mask = profilePicShape
            view.addSubview(profilePicView)
            
            let connectionIcon = UIImageView()
            switch newMatch.type {
            case "Business":
                connectionIcon.image = UIImage(named: "Business_Card_Icon")
            case "Love":
                connectionIcon.image = UIImage(named: "Love_Card_Icon")
            case "Friendship":
                connectionIcon.image = UIImage(named: "Friendship_Card_Icon")
            default:
                break
            }
            connectionIcon.frame = CGRect(x: 0.0164*profilePicView.frame.width, y: 0.75*profilePicView.frame.height, width: 0.105*profilePicView.frame.width, height: 0.105*profilePicView.frame.width)
            profilePicView.addSubview(connectionIcon)
            
            let profileNameLabel = UILabel()
            let name = newMatch.name
            let wordsInName = name.components(separatedBy: " ")
            let firstName: String
            if wordsInName.count > 0 {
                firstName = wordsInName.first!
            } else {
                firstName = name
            }
            var firstNameLastInitial = firstName
            if wordsInName.count > 1 {
                firstNameLastInitial += " \(wordsInName.last!.characters.first!)."
            }
            profileNameLabel.text = firstNameLastInitial
            profileNameLabel.font = UIFont(name: "BentonSans-Bold", size: 26)
            profileNameLabel.textColor = .white
            profileNameLabel.frame = CGRect(x: connectionIcon.frame.maxX + 0.015*profilePicView.frame.width, y: connectionIcon.frame.minY, width: 0.9*profilePicView.frame.width - connectionIcon.frame.maxX, height: connectionIcon.frame.height)
            profileNameLabel.layer.shadowOpacity = 0.95
            profileNameLabel.layer.shadowOffset = CGSize(width: 0.013*profilePicView.frame.width, height: 0.013*profilePicView.frame.width)
            profileNameLabel.layer.shadowRadius = 0.007*profilePicView.frame.width
            profilePicView.addSubview(profileNameLabel)
            
            let statusLabel = UILabel()
            statusLabel.frame = CGRect(x: 0, y: connectionIcon.frame.maxY + 0.01*profilePicView.frame.height, width: profilePicView.frame.width, height: 0.07*profilePicView.frame.height)
            statusLabel.backgroundColor = DisplayUtility.necterGray.withAlphaComponent(0.6)
            if let status = newMatch.status {
                statusLabel.text = status
                statusLabel.textAlignment = .center
                statusLabel.textColor = .white
                statusLabel.font = UIFont(name: "BentonSans-Light", size: 16)
            }
            profilePicView.addSubview(statusLabel)
        }
    }
    
    func dismissVC(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
