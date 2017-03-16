//
//  NewMatchesTableViewCell.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 11/15/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class NewMatchesTableViewCell: UITableViewCell {
    
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
        let profileImageView = UIImageView()
        let nameLabel = UILabel()
        var shouldSetUpConstraints = true
        
        init() {
            super.init(frame: CGRect())
            
            profileImageView.clipsToBounds = true
            
            //nameLabel.adjustsFontSizeToFitWidth = true
            nameLabel.textAlignment = .center
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func updateConstraints() {
            addSubview(profileImageView)
            profileImageView.autoMatch(.height, to: .height, of: self, withMultiplier: 0.6)
            profileImageView.autoMatch(.width, to: .height, of: profileImageView)
            profileImageView.autoPinEdge(toSuperviewEdge: .top)
            profileImageView.autoAlignAxis(toSuperviewAxis: .vertical)
            
            addSubview(nameLabel)
            nameLabel.autoAlignAxis(.vertical, toSameAxisOf: profileImageView)
            nameLabel.autoPinEdge(.top, to: .bottom, of: profileImageView, withOffset: 0.02*frame.height)
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
            print("margin = \(newMatchViewMargin)")
            
            if newMatchView.shouldSetUpConstraints {
                scrollView.addSubview(newMatchView)
                newMatchView.autoMatch(.height, to: .height, of: scrollView)
                newMatchView.autoMatch(.width, to: .height, of: newMatchView, withMultiplier: 0.7)
                newMatchView.autoPinEdge(toSuperviewEdge: .top)
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
        
        print(newMatchViews.count, scrollView.contentSize)
    }
    
    func setVC(vc: OldMessagesViewController) {
    }
    
    func filterBy(type: String) {
    }
    
    func addNewMatch(newMatch: NewMatch) {
    }
    
    func handleTap(_ gesture: UIGestureRecognizer) {
        print("tapped")
        /*
         let newMatchView = gesture.view!
         let acceptIgnoreView = AcceptIgnoreView(newMatch: displayedNewMatches[newMatchView.tag])
         if let vc = self.vc {
         acceptIgnoreView.setVC(vc: vc)
         vc.view.addSubview(acceptIgnoreView)
         }*/
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addUser(_ user: User) {
        let newMatchView = NewMatchView()
        newMatchViews.append(newMatchView)
        
        user.getMainPicture { (picture) in
            picture.getImage { (image) in
                newMatchView.profileImageView.image = image
            }
        }
        
        if let firstName = user.firstName {
            newMatchView.nameLabel.text = firstName
        }
        
        setNeedsUpdateConstraints()
    }
    
    func layoutUser(user: User, position: Int) {
        //frame = frameWithMatches
        
        //newMatchesTitle.frame = CGRect(x: 0.0463*frame.width, y: self.frame.minY + 0.02*frame.height, width: 0.8*frame.width, height: 0.06*frame.width)
        //newMatchesTitle.isHidden = false
        
        let profilePicView = UIImageView()
        //profilePicView.frame = CGRect(x: CGFloat(position)*0.2243*frame.width + 0.0563*frame.width, y: self.frame.minY + 0.05*DisplayUtility.screenHeight, width: 0.168*frame.width, height: 0.168*frame.width)
        scrollView.addSubview(profilePicView)
        let profilePicWidth = 0.6*frame.height
        let profilePicHeight = profilePicWidth
        let spaceBetweenProfilePics = 0.2*frame.height
        profilePicView.autoSetDimensions(to: CGSize(width: profilePicWidth, height: profilePicHeight))
        profilePicView.autoPinEdge(toSuperviewEdge: .top)
        profilePicView.autoPinEdge(toSuperviewEdge: .leading, withInset: spaceBetweenProfilePics + CGFloat(position)*(profilePicWidth+spaceBetweenProfilePics))
        profilePicView.layer.cornerRadius = profilePicHeight/2
        profilePicView.layer.borderWidth = 2
        profilePicView.layer.borderColor = UIColor.black.cgColor
        profilePicView.clipsToBounds = true
        profilePicView.tag = position
        profilePicView.backgroundColor = UIColor(red: 234/255, green: 237/255, blue: 239/255, alpha: 1.0)
        
        
        user.getMainPicture { (picture) in
            picture.getImage { (image) in
                profilePicView.image = image
            }
        }
        
        // add gesture recognizer
        profilePicView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        profilePicView.addGestureRecognizer(gesture)
        
        // add name
        //let nameLabel = UILabel(frame: CGRect(x: profilePicView.frame.minX, y: profilePicView.frame.maxY + 0.08*frame.height, width: 0, height: 0.2*frame.height))
        let nameLabel = UILabel()
        scrollView.addSubview(nameLabel)
        nameLabel.autoAlignAxis(.vertical, toSameAxisOf: profilePicView)
        nameLabel.autoPinEdge(.top, to: .bottom, of: profilePicView, withOffset: 0.02*frame.height)
        nameLabel.autoMatch(.width, to: .width, of: profilePicView)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.textAlignment = .center
        
        if let firstName = user.firstName {
            nameLabel.text = firstName
        }
        
        scrollView.contentSize = CGSize(width: max(DisplayUtility.screenWidth, spaceBetweenProfilePics + CGFloat(position+1)*(profilePicWidth+spaceBetweenProfilePics)), height: frame.height)
        
        //        line.frame = CGRect(x: 0.0463*frame.width, y: frame.height-1, width: 0.9205*contentSize.width, height: 1)
        //line.frame = CGRect(x: 0, y: frame.height-1, width: contentSize.width, height: 1)
    }
    
    
}
