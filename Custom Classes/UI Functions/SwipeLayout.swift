//
//  SwipeLayout.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/17/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import PureLayout

class SwipeLayout {
    
    // MARK: Global Variables
    var view = UIView()
    let navBar = SwipeObjects.NavBar()
    var topSwipeCard = SwipeCard()
    var bottomSwipeCard = SwipeCard()
    let passButton = SwipeObjects.DecisionButton(text: "PASS")
    let nectButton = SwipeObjects.DecisionButton(text: "NECT")
    let infoButton = SwipeObjects.InfoButton()
    let connectIcon = UIImageView(image: #imageLiteral(resourceName: "Necter_Icon"))
    let disconnectIcon = UIImageView(image: #imageLiteral(resourceName: "Disconnect_Icon"))
    let loadingView = SwipeObjects.LoadingBridgePairingsView()
    var topSwipeCardHorizontalConstraint: NSLayoutConstraint?
    var bottomSwipeCardHorizontalConstraint: NSLayoutConstraint?
    
    // no more bridge pairings views
    
    let wayToNectLabel = SwipeObjects.BigLabel(text: "WAY TO NECT!")
    let noMoreNectsLabel = SwipeObjects.BigLabel(text: "RAN OUT OF NECTS")
    let nobodyToNectLabel = SwipeObjects.BigLabel(text: "NOBODY TO NECT")
    
    let comeBackLabel = SwipeObjects.SmallLabel(text: "Come back at 5pm est for your next batch.")
    let getFriendsLabelNoMore = SwipeObjects.SmallLabel(text: "Your next batch is currently empty!")
    let getFriendsLabelNone = SwipeObjects.SmallLabel(text: "Your next batch is currently empty!")
    
    let countdownLabelView = SwipeObjects.SwipeCountdownLabelView()
    
    let tomorrowsNectingLabel = SwipeObjects.SmallLabel(text: "Want to make tomorrow's necting even better...?")
    let toGetNectingLabel = SwipeObjects.SmallLabel(text: "To get necting, invite friends before 5pm est...")
    
    let friendsImage = ReusableObjects.FriendsImage()
    let inviteButton = ReusableObjects.InviteButton()
    
    var cardsLimitMetViews: [UIView]
    var noMoreCardsViews: [UIView]
    var noCardsViews: [UIView]

    init() {
        cardsLimitMetViews = [wayToNectLabel, comeBackLabel, countdownLabelView, tomorrowsNectingLabel]
        noMoreCardsViews = [noMoreNectsLabel, getFriendsLabelNoMore, countdownLabelView, toGetNectingLabel]
        noCardsViews = [nobodyToNectLabel, getFriendsLabelNone, countdownLabelView, toGetNectingLabel]
    }
    
    /// Sets the initial layout constraints
    func initialize(view: UIView, didSetupConstraints: Bool) -> Bool {
        if (!didSetupConstraints) {
            self.view = view
            
            // MARK: Layout Objects
            let margin: CGFloat = 20
            
            // Layout the navigation bar at the top of the view for navigating from the SwipeViewController to the MessagesViewController and the MyProfileViewController
            view.addSubview(navBar)
            navBar.autoPinEdge(toSuperviewEdge: .top)
            navBar.autoPinEdge(toSuperviewEdge: .left)
            navBar.autoMatch(.width, to: .width, of: view)
            navBar.autoSetDimension(.height, toSize: 64)
            
            // Layout friendsImage to pin to the bottom of the view
            view.addSubview(friendsImage)
            friendsImage.autoPinEdge(toSuperviewEdge: .left)
            friendsImage.autoPinEdge(toSuperviewEdge: .right)
            friendsImage.autoPinEdge(toSuperviewEdge: .bottom)
            //friendsImage.alpha = 0
            
            // Layout inviteButton to center of the friendsImage
            view.addSubview(inviteButton)
            inviteButton.autoAlignAxis(.horizontal, toSameAxisOf: friendsImage, withOffset: 20)
            inviteButton.autoAlignAxis(.vertical, toSameAxisOf: view)
            inviteButton.autoSetDimensions(to: CGSize(width: 241.5, height: 42.5))
            //inviteButton.alpha = 0

            // Change placement of tomorrowNectingLabel and toGetNectingLabel based on device size
            if UIDevice.current.modelName == "iPhone 6 Plus" || UIDevice.current.modelName == "iPhone 6s Plus" || UIDevice.current.modelName == "iPhone 7 Plus" || UIDevice.current.modelName == "Simulator" {
                
                view.addSubview(tomorrowsNectingLabel)
                tomorrowsNectingLabel.autoPinEdge(.bottom, to: .top, of: friendsImage, withOffset: -50)
                tomorrowsNectingLabel.autoAlignAxis(toSuperviewAxis: .vertical)
                tomorrowsNectingLabel.autoMatch(.width, to: .width, of: view, withMultiplier: 0.8)
                //tomorrowsNectingLabel.alpha = 0
                
                view.addSubview(toGetNectingLabel)
                toGetNectingLabel.autoPinEdge(.bottom, to: .top, of: friendsImage, withOffset: -50)
                toGetNectingLabel.autoAlignAxis(toSuperviewAxis: .vertical)
                toGetNectingLabel.autoMatch(.width, to: .width, of: view, withMultiplier: 0.8)
                //toGetNectingLabel.alpha = 0
                
            } else {
                view.addSubview(tomorrowsNectingLabel)
                tomorrowsNectingLabel.autoPinEdge(.bottom, to: .top, of: friendsImage, withOffset: -20)
                tomorrowsNectingLabel.autoAlignAxis(toSuperviewAxis: .vertical)
                tomorrowsNectingLabel.autoMatch(.width, to: .width, of: view, withMultiplier: 0.8)
                //tomorrowsNectingLabel.alpha = 0
                
                view.addSubview(toGetNectingLabel)
                toGetNectingLabel.autoPinEdge(.bottom, to: .top, of: friendsImage, withOffset: -20)
                toGetNectingLabel.autoAlignAxis(toSuperviewAxis: .vertical)
                toGetNectingLabel.autoMatch(.width, to: .width, of: view, withMultiplier: 0.8)
                //toGetNectingLabel.alpha = 0
            }
            
            
            
            let bigLabels = [wayToNectLabel, noMoreNectsLabel, nobodyToNectLabel]
            
            for bigLabel in bigLabels {
                view.addSubview(bigLabel)
                bigLabel.autoPinEdge(.top, to: .bottom, of: navBar, withOffset: 20)
                bigLabel.autoAlignAxis(toSuperviewAxis: .vertical)
                bigLabel.autoMatch(.width, to: .width, of: view, withMultiplier: 0.8)
                //bigLabel.alpha = 0
            }
            
            let smallLabels  = [comeBackLabel, getFriendsLabelNoMore, getFriendsLabelNone]
            
            for i in 0..<smallLabels.count {
                let smallLabel = smallLabels[i]
                view.addSubview(smallLabel)
                
                let bigLabel = bigLabels[i]
                smallLabel.autoPinEdge(.top, to: .bottom, of: bigLabel, withOffset: 20)
                smallLabel.autoAlignAxis(toSuperviewAxis: .vertical)
                smallLabel.autoMatch(.width, to: .width, of: view, withMultiplier: 0.8)
                //smallLabel.alpha = 0
            }
            
            view.addSubview(countdownLabelView)
            countdownLabelView.autoPinEdge(toSuperviewEdge: .left)
            countdownLabelView.autoPinEdge(toSuperviewEdge: .right)
            countdownLabelView.autoPinEdge(.top, to: .bottom, of: smallLabels[0], withOffset: 20)
            //countdownLabelView.autoAlignAxis(toSuperviewAxis: .horizontal)
                        
            view.addSubview(infoButton)
            view.addSubview(passButton)
            view.addSubview(nectButton)
            
            // Setting sizes
            infoButton.autoSetDimensions(to: CGSize(width: 25, height: 25))
            passButton.autoSetDimension(.height, toSize: passButton.size.height)
//            passButton.autoSetDimensions(to: passButton.size )
//            nectButton.autoMatch(.width, to: .width, of: passButton)
            nectButton.autoMatch(.height, to: .height, of: passButton)
            
            // Setting horizontal Alignment
            nectButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: margin)
            passButton.autoAlignAxis(.horizontal, toSameAxisOf: nectButton)
            infoButton.autoAlignAxis(.horizontal, toSameAxisOf: nectButton)
            
            // Setting vertical Alignment
            infoButton.autoAlignAxis(toSuperviewAxis: .vertical)
            passButton.autoPinEdge(.right, to: .left, of: infoButton, withOffset: -(margin))
            nectButton.autoPinEdge(.left, to: .right, of: infoButton, withOffset: margin)
            
            // Pinning Decision Buttons to left and right edges with marge
            passButton.autoPinEdge(toSuperviewEdge: .left, withInset: margin)
            nectButton.autoPinEdge(toSuperviewEdge: .right, withInset: margin)
            
            // Layout top swipe card
            view.addSubview(topSwipeCard)
            topSwipeCard.autoPinEdge(.top, to: .bottom, of: navBar, withOffset: 15)
            topSwipeCard.autoPinEdge(.bottom, to: .top, of: nectButton, withOffset: -10)
            topSwipeCard.autoSetDimension(.width, toSize: view.frame.width - 40)
            topSwipeCardHorizontalConstraint = topSwipeCard.autoAlignAxis(toSuperviewAxis: .vertical)
            //topSwipeCardHorizontalConstraint = topSwipeCard.autoPinEdge(toSuperviewEdge: .left, withInset: view.frame.width/2 - topSwipeCard.frame.width/2)
            
            // Layout bottom swipe card
            view.insertSubview(bottomSwipeCard, belowSubview: topSwipeCard)
            bottomSwipeCard.autoPinEdge(.top, to: .bottom, of: navBar, withOffset: 15)
            bottomSwipeCard.autoPinEdge(.bottom, to: .top, of: nectButton, withOffset: -10)
            bottomSwipeCard.autoSetDimension(.width, toSize: view.frame.width - 40)
            bottomSwipeCardHorizontalConstraint = bottomSwipeCard.autoAlignAxis(toSuperviewAxis: .vertical)
            //bottomSwipeCardHorizontalConstraint = bottomSwipeCard.autoPinEdge(toSuperviewEdge: .left, withInset: view.frame.width/2 - bottomSwipeCard.frame.width/2)
            
            let iconDiameter = view.frame.width / 3
            
            // Layout connect icon
            view.addSubview(connectIcon)
            connectIcon.autoSetDimensions(to: CGSize(width: iconDiameter, height: iconDiameter))
            connectIcon.autoAlignAxis(.vertical, toSameAxisOf: view, withOffset: 0.15*view.frame.width)
            connectIcon.autoAlignAxis(.horizontal, toSameAxisOf: topSwipeCard)
            connectIcon.alpha = 0
            
            // Layout disconnect icon
            view.addSubview(disconnectIcon)
            disconnectIcon.autoSetDimensions(to: CGSize(width: iconDiameter, height: iconDiameter))
            disconnectIcon.autoAlignAxis(.vertical, toSameAxisOf: view, withOffset: -0.15*view.frame.width)
            disconnectIcon.autoAlignAxis(.horizontal, toSameAxisOf: topSwipeCard)
            disconnectIcon.alpha = 0
        }
        
        return true
    }
    
//    func updateTopSwipeCardHorizontalConstraint(translation: CGFloat) {
//        if let constraint = topSwipeCardHorizontalConstraint {
//            constraint.constant = constraint.constant + translation
//        }
//    }
    
    func updateTopSwipeCardHorizontalConstraint(fromCenter: CGFloat) {
        if let constraint = topSwipeCardHorizontalConstraint {
            constraint.constant = fromCenter
        }
    }
    
    func recenterTopSwipeCard() {
        if let constraint = topSwipeCardHorizontalConstraint {
            constraint.constant = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func switchTopAndBottomCards() {
        let oldTopSwipeCard = topSwipeCard
        let oldTopSwipeCardHorizontalConstraint = topSwipeCardHorizontalConstraint
        topSwipeCard = bottomSwipeCard
        topSwipeCardHorizontalConstraint = bottomSwipeCardHorizontalConstraint
        bottomSwipeCard = oldTopSwipeCard
        bottomSwipeCardHorizontalConstraint = oldTopSwipeCardHorizontalConstraint
        if let constraint = bottomSwipeCardHorizontalConstraint {
            constraint.constant = 0
        }
        
        if let view = bottomSwipeCard.superview {
            view.insertSubview(bottomSwipeCard, belowSubview: topSwipeCard)
        }
    }
    
}
