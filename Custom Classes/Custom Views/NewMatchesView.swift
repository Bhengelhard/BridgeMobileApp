//
//  NewMatchesView.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 11/15/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class NewMatchesView: UIScrollView {
    
    var vc: MessagesViewController?
    let frameWithNoMatches: CGRect
    let frameWithMatches: CGRect
    var allNewMatches: [NewMatch]
    var displayedNewMatches: [NewMatch]
    let line: UIView
    let gradientLayer: CAGradientLayer
    
    init() {
        frameWithNoMatches = CGRect(x: 0, y: 0, width: 0, height: 0)
        frameWithMatches = CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: 0.17*DisplayUtility.screenHeight)
        allNewMatches = [NewMatch]()
        displayedNewMatches = [NewMatch]()
        line = UIView()
        gradientLayer = DisplayUtility.getGradient()
        super.init(frame: frameWithNoMatches)
        contentSize = frame.size
        line.backgroundColor = .clear
        line.layer.insertSublayer(gradientLayer, at: 0)

        line.isHidden = true
        addSubview(line)
    }
    
    func setVC(vc: MessagesViewController) {
        self.vc = vc
    }
    
    func filterBy(type: String) {
        displayedNewMatches = [NewMatch]()
        for newMatch in allNewMatches {
            if newMatch.type == type || type == "All Types" {
                displayedNewMatches.append(newMatch)
            }
        }
        for subview in subviews {
            subview.removeFromSuperview()
        }
        addSubview(line)
        if displayedNewMatches.count == 0 {
            frame = frameWithNoMatches
            line.isHidden = true
        }
        for i in 0..<displayedNewMatches.count {
            layoutNewMatch(newMatch: displayedNewMatches[i], position: i)
        }
    }
    
    func addNewMatch(newMatch: NewMatch) {
        allNewMatches.append(newMatch)
        displayedNewMatches.append(newMatch)
        layoutNewMatch(newMatch: newMatch, position: displayedNewMatches.count-1)
    }
    
    func layoutNewMatch(newMatch: NewMatch, position: Int) {
        frame = frameWithMatches
        contentSize = CGSize(width: max(DisplayUtility.screenWidth, CGFloat(position+1)*0.2243*DisplayUtility.screenWidth), height: 0.17*DisplayUtility.screenHeight)
        line.frame = CGRect(x: 0.0463*frame.width, y: 0.99*frame.height, width: 0.9205*contentSize.width, height: 1)
        gradientLayer.frame = line.bounds
        line.isHidden = false
        
        // add profile picture
        let downloader = Downloader()
        let profilePicView = UIImageView()
        let url = URL(string: newMatch.profilePicURL)!
        downloader.imageFromURL(URL: url, imageView: profilePicView, callBack: nil)
        profilePicView.frame = CGRect(x: CGFloat(position)*0.2243*frame.width + 0.0563*frame.width, y: self.frame.minY, width: 0.168*frame.width, height: 0.168*frame.width)
        profilePicView.layer.cornerRadius = profilePicView.frame.height/2
        profilePicView.layer.borderWidth = 2
        profilePicView.layer.borderColor = newMatch.color.cgColor
        profilePicView.clipsToBounds = true
        profilePicView.tag = position
        addSubview(profilePicView)
        
        // add gesture recognizer
        profilePicView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        profilePicView.addGestureRecognizer(gesture)
        
        // add name
        let name = newMatch.name
        let wordsInName = name.components(separatedBy: " ")
        let firstName: String
        if wordsInName.count > 0 {
            firstName = wordsInName.first!
        } else {
            firstName = name
        }
        let nameLabel = UILabel(frame: CGRect(x: profilePicView.frame.minX, y: profilePicView.frame.maxY + 0.1*frame.height, width: 0, height: 0.2*frame.height))
        nameLabel.text = firstName
        nameLabel.sizeToFit()
        nameLabel.frame = CGRect(x: profilePicView.frame.midX - nameLabel.frame.width/2, y: nameLabel.frame.minY, width: nameLabel.frame.width, height: nameLabel.frame.height)
        addSubview(nameLabel)
        
        if newMatch.dot {
            let notificationDot = UIImageView(image: UIImage(named: "Inbox_Notification_Icon"))
            notificationDot.frame = CGRect(x: profilePicView.frame.minX + 0.75*profilePicView.frame.width, y: profilePicView.frame.minY, width: 0.2*profilePicView.frame.width, height: 0.2*profilePicView.frame.width)
            addSubview(notificationDot)
        }

    }
    
    func handleTap(_ gesture: UIGestureRecognizer) {
        print("tapped")
        let newMatchView = gesture.view!
        let acceptIgnoreView = AcceptIgnoreView(newMatch: displayedNewMatches[newMatchView.tag])
        if let vc = self.vc {
            acceptIgnoreView.setVC(vc: vc)
            vc.view.addSubview(acceptIgnoreView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
