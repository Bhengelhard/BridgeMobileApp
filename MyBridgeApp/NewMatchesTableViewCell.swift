//
//  NewMatchesTableViewCell.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 11/15/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class NewMatchesTableViewCell: UITableViewCell {
    
    var parentVC: UIViewController?
    let allNewMatches = [NewMatch]()
    let scrollView = UIScrollView()
    var users = [User]()
    let line = UIView()
    var newMatchesTitle = UILabel()
    let gradientLayer = DisplayUtility.gradientLayer()
    var newMatchViews = [NewMatchView]()
    var newMatchViewMargin = CGFloat(0)
    var shouldSetUpConstraints = true
    
    init() {
        super.init(style: .default, reuseIdentifier: "newMatches")
        
        line.backgroundColor = .clear
        line.layer.insertSublayer(gradientLayer, at: 0)
        
        scrollView.bounces = false
        
        setNeedsUpdateConstraints()
    }
    
    class NewMatchView: UIView {
        let message: Message
        let profileImageView = UIImageView()
        let nameLabel = UILabel()
        var shouldSetUpConstraints = true
        
        init(message: Message) {
            self.message = message
            super.init(frame: CGRect())
            
            profileImageView.clipsToBounds = true
            
            nameLabel.textAlignment = .center
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func updateConstraints() {
            addSubview(profileImageView)
            profileImageView.autoMatch(.width, to: .width, of: self)
            profileImageView.autoMatch(.height, to: .width, of: profileImageView)
            profileImageView.autoPinEdge(toSuperviewEdge: .top)
            profileImageView.autoAlignAxis(toSuperviewAxis: .vertical)
            
            addSubview(nameLabel)
            nameLabel.autoAlignAxis(.vertical, toSameAxisOf: profileImageView)
            //nameLabel.autoPinEdge(.top, to: .bottom, of: profileImageView, withOffset: 0.02*frame.height)
            nameLabel.autoPinEdge(toSuperviewEdge: .bottom)
            nameLabel.autoMatch(.width, to: .width, of: profileImageView)
            
            super.updateConstraints()
            layoutIfNeeded()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        }
    }
    
    override func updateConstraints() {
        if shouldSetUpConstraints {
            
            addSubview(line)
            line.autoSetDimension(.height, toSize: 1)
            line.autoPinEdge(toSuperviewEdge: .bottom)
            line.autoAlignAxis(toSuperviewAxis: .vertical)
            line.autoMatch(.width, to: .width, of: self, withMultiplier: 0.9)
            
            addSubview(scrollView)
            scrollView.autoPinEdge(toSuperviewEdge: .top)
            scrollView.autoPinEdge(toSuperviewEdge: .left)
            scrollView.autoPinEdge(toSuperviewEdge: .right)
            scrollView.autoPinEdge(.bottom, to: .top, of: line)
            
            shouldSetUpConstraints = false
        }
        
        for i in 0..<newMatchViews.count {
            let newMatchView = newMatchViews[i]
            
            newMatchViewMargin = 0.2*scrollView.frame.height
            
            if newMatchView.shouldSetUpConstraints {
                scrollView.addSubview(newMatchView)
                newMatchView.autoMatch(.height, to: .height, of: scrollView, withMultiplier: 0.9)
                newMatchView.autoMatch(.width, to: .height, of: newMatchView, withMultiplier: 0.75)
                newMatchView.autoAlignAxis(toSuperviewAxis: .horizontal)
                if i == 0 {
                    newMatchView.autoPinEdge(toSuperviewEdge: .left, withInset: newMatchViewMargin)
                } else {
                    let previosNewMatchView = newMatchViews[i-1]
                    newMatchView.autoPinEdge(.left, to: .right, of: previosNewMatchView, withOffset:newMatchViewMargin)
                }
                newMatchView.shouldSetUpConstraints = false
            }
        }
        
        super.updateConstraints()
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = line.bounds
        
        if newMatchViews.count > 0 {
            scrollView.contentSize = CGSize(width: newMatchViews[newMatchViews.count-1].frame.maxX + newMatchViewMargin, height: scrollView.frame.height)
        } else {
            scrollView.contentSize = CGSize(width: 0, height: scrollView.frame.height)
        }
    }
    
    func setVC(vc: OldMessagesViewController) {
    }
    
    func filterBy(type: String) {
    }
    
    func addNewMatch(newMatch: NewMatch) {
    }
    
//<<<<<<< HEAD
//    func handleTap(_ gesture: UIGestureRecognizer) {
//        print("tapped")
//        /*
//         let newMatchView = gesture.view!
//         let acceptIgnoreView = AcceptIgnoreView(newMatch: displayedNewMatches[newMatchView.tag])
//         if let vc = self.vc {
//         acceptIgnoreView.setVC(vc: vc)
//         vc.view.addSubview(acceptIgnoreView)
//         }*/
//    }
//    
//=======
//>>>>>>> wiredFrame
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addUserInMessage(message: Message) {
        let newMatchView = NewMatchView(message: message)
        newMatchViews.append(newMatchView)
        
        // add gesture recognizer to take to thread
        let gesture = UITapGestureRecognizer(target: self, action: #selector(takeToThread(_:)))
        newMatchView.addGestureRecognizer(gesture)
        
        message.getNonCurrentUser { (user) in
            user.getMainPicture { (picture) in
                picture.getImage { (image) in
                    newMatchView.profileImageView.image = image
                }
            }
            
            if let firstName = user.firstName {
                newMatchView.nameLabel.text = firstName
            }
        }
        
        setNeedsUpdateConstraints()
    }
    
    func takeToThread(_ gesture: UIGestureRecognizer) {
        if let view = gesture.view {
            if let newMatchView = view as? NewMatchView {
                if let parentVC = parentVC {
                    let threadVC = ThreadViewController()
                    threadVC.setMessageID(messageID: newMatchView.message.id)
                    parentVC.present(threadVC, animated: true, completion: nil)
                }
            }
        }
//<<<<<<< HEAD
//        
//        // add gesture recognizer
//        profilePicView.isUserInteractionEnabled = true
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//        profilePicView.addGestureRecognizer(gesture)
//        
//        // add name
//        //let nameLabel = UILabel(frame: CGRect(x: profilePicView.frame.minX, y: profilePicView.frame.maxY + 0.08*frame.height, width: 0, height: 0.2*frame.height))
//        let nameLabel = UILabel()
//        scrollView.addSubview(nameLabel)
//        nameLabel.autoAlignAxis(.vertical, toSameAxisOf: profilePicView)
//        nameLabel.autoPinEdge(.top, to: .bottom, of: profilePicView, withOffset: 0.02*frame.height)
//        nameLabel.autoMatch(.width, to: .width, of: profilePicView)
//        nameLabel.adjustsFontSizeToFitWidth = true
//        nameLabel.textAlignment = .center
//        
//        if let firstName = user.firstName {
//            nameLabel.text = firstName
//        }
//        
//        scrollView.contentSize = CGSize(width: max(DisplayUtility.screenWidth, spaceBetweenProfilePics + CGFloat(position+1)*(profilePicWidth+spaceBetweenProfilePics)), height: frame.height)
//        
//        //        line.frame = CGRect(x: 0.0463*frame.width, y: frame.height-1, width: 0.9205*contentSize.width, height: 1)
//        //line.frame = CGRect(x: 0, y: frame.height-1, width: contentSize.width, height: 1)
//=======
//>>>>>>> wiredFrame
    }
    
}
