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
    var noNewMatchesLabel = UILabel()
    var shouldSetUpConstraints = true
    
    init() {
        super.init(style: .default, reuseIdentifier: "newMatches")
        
        line.backgroundColor = .clear
        line.layer.insertSublayer(gradientLayer, at: 0)
        
        noNewMatchesLabel.text = "You have no new matches."
        noNewMatchesLabel.textColor = Constants.Colors.necter.textGray
        noNewMatchesLabel.font = Constants.Fonts.light18
        
        scrollView.bounces = false
        
        setNeedsUpdateConstraints()
    }
    
    class NewMatchView: UIView {
        let message: Message
        let profileImageView = UIImageView()
        let notificationDot = UIView()
        let nameLabel = UILabel()
        var shouldSetUpConstraints = true
        
        init(message: Message) {
            self.message = message
            super.init(frame: CGRect())
            
            profileImageView.clipsToBounds = true
            profileImageView.contentMode = .scaleAspectFill
            profileImageView.backgroundColor = Constants.Colors.necter.backgroundGray
            
            notificationDot.clipsToBounds = true
            
            nameLabel.textAlignment = .center
            
            setNeedsUpdateConstraints()
            setNeedsLayout()
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
            
            addSubview(notificationDot)
            notificationDot.autoMatch(.width, to: .width, of: profileImageView, withMultiplier: 0.2)
            notificationDot.autoMatch(.height, to: .width, of: notificationDot)
            notificationDot.autoPinEdge(.top, to: .top, of: profileImageView)
            notificationDot.autoPinEdge(.right, to: .right, of: profileImageView)
            
            addSubview(nameLabel)
            nameLabel.autoAlignAxis(.vertical, toSameAxisOf: profileImageView)
            nameLabel.autoPinEdge(toSuperviewEdge: .bottom)
            nameLabel.autoMatch(.width, to: .width, of: profileImageView)
            
            super.updateConstraints()
            layoutIfNeeded()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            profileImageView.layer.cornerRadius = profileImageView.frame.height/2
            
            notificationDot.layer.cornerRadius = notificationDot.frame.height/2
            notificationDot.backgroundColor = DisplayUtility.gradientColor(size: notificationDot.frame.size)
        }
    }
    
    override func updateConstraints() {
        if shouldSetUpConstraints {
            
            addSubview(noNewMatchesLabel)
            noNewMatchesLabel.autoCenterInSuperview()
            
            addSubview(scrollView)
            scrollView.autoPinEdge(toSuperviewEdge: .top)
            scrollView.autoPinEdge(toSuperviewEdge: .left)
            scrollView.autoPinEdge(toSuperviewEdge: .right)
            scrollView.autoPinEdge(toSuperviewEdge: .bottom)
            
            shouldSetUpConstraints = false
        }
        
        for i in 0..<newMatchViews.count {
            let newMatchView = newMatchViews[i]
            
            //newMatchViewMargin = 0.2*scrollView.frame.height
            
            
            
            if newMatchView.shouldSetUpConstraints {
                // add and layout margin view before new match
                let marginView = UIView()
                scrollView.addSubview(marginView)
                marginView.autoMatch(.width, to: .height, of: scrollView, withMultiplier: 0.2)
                marginView.autoSetDimension(.height, toSize: 0)
                marginView.autoAlignAxis(toSuperviewAxis: .horizontal)
                if i == 0 {
                    marginView.autoPinEdge(toSuperviewEdge: .left)
                } else {
                    marginView.autoPinEdge(.left, to: .right, of: newMatchViews[i-1])
                }
                
                // add and layout new match
                scrollView.addSubview(newMatchView)
                newMatchView.autoMatch(.height, to: .height, of: scrollView, withMultiplier: 0.8)
                newMatchView.autoMatch(.width, to: .height, of: newMatchView, withMultiplier: 0.75)
                newMatchView.autoAlignAxis(toSuperviewAxis: .horizontal)
                newMatchView.autoPinEdge(.left, to: .right, of: marginView)
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
            scrollView.contentSize = CGSize(width: newMatchViews[newMatchViews.count-1].frame.maxX + 0.2*scrollView.frame.height, height: scrollView.frame.height)
        } else {
            scrollView.contentSize = CGSize(width: 0, height: scrollView.frame.height)
        }
    }
    
    func reset() {
        for newMatchView in newMatchViews {
            newMatchView.alpha = 0
        }
        newMatchViews = [NewMatchView]()
        
        noNewMatchesLabel.alpha = 1
        
        layoutIfNeeded()
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addUserInMessage(message: Message) {
        noNewMatchesLabel.alpha = 0
        
        let newMatchView = NewMatchView(message: message)
        newMatchViews.append(newMatchView)
        
        // add gesture recognizer to take to thread
        let newMatchGR = UITapGestureRecognizer(target: self, action: #selector(goToThread(_:)))
        newMatchView.addGestureRecognizer(newMatchGR)
        
        message.getNonCurrentUser { (user) in
            user.getMainPicture { (picture) in
                picture.getImage { (image) in
                    newMatchView.profileImageView.image = image
                }
            }
            
            if let firstName = user.firstName {
                newMatchView.nameLabel.text = firstName
            }
            
            if user.id == message.user1ID { // user is user1; you are user2
                if let hasSeenLastSingleMessage = message.user2HasSeenLastSingleMessage {
                    if hasSeenLastSingleMessage {
                        newMatchView.notificationDot.alpha = 0
                    }
                }
            } else { // user is user2; you are user1
                if let hasSeenLastSingleMessage = message.user1HasSeenLastSingleMessage {
                    if hasSeenLastSingleMessage {
                        newMatchView.notificationDot.alpha = 0
                    }
                }
            }
        }
        
        setNeedsUpdateConstraints()
    }

    func goToThread(_ gesture: UIGestureRecognizer) {
        if let messagesVC = parentVC as? MessagesViewController {
            if let view = gesture.view {
                if let newMatchView = view as? NewMatchView {
                    messagesVC.goToThread(messageID: newMatchView.message.id)
                }
            }
        }
    }
    
}
