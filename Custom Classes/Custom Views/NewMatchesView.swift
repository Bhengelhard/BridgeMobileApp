//
//  NewMatchesView.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 11/15/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class NewMatchesView: UIScrollView {
    
    let frameWithNoMatches: CGRect
    let frameWithMatches: CGRect
    var newMatches: [NewMatch]
    var profilePics: [UIImage]
    var names: [String]
    let line: UIView
    let gradientLayer: CAGradientLayer
    
    init() {
        frameWithNoMatches = CGRect(x: 0, y: 0, width: 0, height: 0)
        frameWithMatches = CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: 0.17*DisplayUtility.screenHeight)
        profilePics = [UIImage]()
        names = [String]()
        newMatches = [NewMatch]()
        line = UIView()
        gradientLayer = CAGradientLayer()
        super.init(frame: frameWithNoMatches)
        let color1 = UIColor(red: 255.0/255.0, green: 204.0/255.0, blue: 0.0/255.0, alpha: 1).cgColor
        let color2 = UIColor(red: 237.0/255.0, green: 104.0/255.0, blue: 60.0/255.0, alpha: 1).cgColor
        let color3 = UIColor(red: 247.0/255.0, green: 237.0/255.0, blue: 144.0/255.0, alpha: 1).cgColor
        let color4 = UIColor(red: 243.0/255.0, green: 144.0/255.0, blue: 63.0/255.0, alpha: 1).cgColor
        let color5 = UIColor(red: 233.0/255.0, green: 62.0/255.0, blue: 58.0/255.0, alpha: 1).cgColor
        gradientLayer.colors = [color1, color2, color3, color4, color5]
        gradientLayer.locations = [0.0, 0.25, 0.5, 0.75, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        line.backgroundColor = .clear
        line.layer.insertSublayer(gradientLayer, at: 0)

        line.isHidden = true
        addSubview(line)
    }
    
    func addNewMatch(newMatch: NewMatch) {
        newMatches.append(newMatch)
        frame = frameWithMatches
        contentSize = CGSize(width: max(DisplayUtility.screenWidth, CGFloat(profilePics.count)*0.2243*DisplayUtility.screenWidth), height: 0.17*DisplayUtility.screenHeight)
        line.frame = CGRect(x: 0.0463*frame.width, y: 0.99*frame.height, width: 0.9205*contentSize.width, height: 1)
        gradientLayer.frame = line.bounds
        line.isHidden = false
        
        // add profile picture
        let profilePicView = newMatch.profilePicView
        profilePicView.frame = CGRect(x: CGFloat(newMatches.count-1)*0.2243*frame.width + 0.0563*frame.width, y: self.frame.minY, width: 0.168*frame.width, height: 0.168*frame.width)
        profilePicView.layer.cornerRadius = profilePicView.frame.height/2
        profilePicView.layer.borderWidth = 2
        profilePicView.layer.borderColor = newMatch.color.cgColor
        profilePicView.clipsToBounds = true
        addSubview(profilePicView)
        
        /*
        // add gesture recognizer
        let gesture = UITapGestureRecognizer(target: self, action: #selector("handleTap"))
        profilePicView.addGestureRecognizer(gesture)*/
        
        // add name
        let name = newMatch.firstName
        let nameLabel = UILabel(frame: CGRect(x: profilePicView.frame.minX, y: profilePicView.frame.maxY + 0.1*frame.height, width: 0, height: 0.2*frame.height))
        nameLabel.text = name
        nameLabel.sizeToFit()
        nameLabel.frame = CGRect(x: profilePicView.frame.midX - nameLabel.frame.width/2, y: nameLabel.frame.minY, width: nameLabel.frame.width, height: nameLabel.frame.height)
        addSubview(nameLabel)
        
        if newMatch.dot {
            let notificationDot = UIImageView(image: UIImage(named: "Inbox_Notification_Icon"))
            notificationDot.frame = CGRect(x: profilePicView.frame.minX + 0.75*profilePicView.frame.width, y: profilePicView.frame.minY, width: 0.2*profilePicView.frame.width, height: 0.2*profilePicView.frame.width)
            addSubview(notificationDot)
        }

    }
    
    /*
    func handleTap(gr: UIGestureRecognizer) {
        print("tapped")
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
