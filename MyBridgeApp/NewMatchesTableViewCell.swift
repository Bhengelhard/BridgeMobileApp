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
                newMatchView.autoMatch(.height, to: .height, of: scrollView, withMultiplier: 0.9)
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
    
    func setVC(vc: OldMessagesViewController) {
    }
    
    func filterBy(type: String) {
    }
    
    func addNewMatch(newMatch: NewMatch) {
    }
    
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
    }
    
}
