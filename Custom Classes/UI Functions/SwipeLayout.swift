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
    let noMoreBridgePairingsLabel = SwipeObjects.NoMoreBridgePairingsLabel()
    let orLabel1 = SwipeObjects.OrLabel()
    let inviteButton = ReusableObjects.InviteButton()
    let orLabel2 = SwipeObjects.OrLabel()
    let refreshButton = SwipeObjects.RefreshButton()
    let loadingView = SwipeObjects.LoadingBridgePairingsView()
    var topSwipeCardHorizontalConstraint: NSLayoutConstraint?
    var bottomSwipeCardHorizontalConstraint: NSLayoutConstraint?
    
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
            
            // Layout invite friends button
            view.addSubview(inviteButton)
            inviteButton.autoCenterInSuperview()
            inviteButton.autoSetDimensions(to: CGSize(width: 241.5, height: 42.5))
            
            // Layout first or label
            view.addSubview(orLabel1)
            orLabel1.autoAlignAxis(toSuperviewAxis: .vertical)
            orLabel1.autoPinEdge(.bottom, to: .top, of: inviteButton, withOffset: -25)
            
            // Layout no more bridge pairings label
            view.addSubview(noMoreBridgePairingsLabel)
            noMoreBridgePairingsLabel.autoAlignAxis(toSuperviewAxis: .vertical)
            noMoreBridgePairingsLabel.autoPinEdge(.bottom, to: .top, of: orLabel1, withOffset: -25)
            noMoreBridgePairingsLabel.autoMatch(.width, to: .width, of: view, withMultiplier: 0.8)
            
            // Layout second or label
            view.addSubview(orLabel2)
            orLabel2.autoAlignAxis(toSuperviewAxis: .vertical)
            orLabel2.autoPinEdge(.top, to: .bottom, of: inviteButton, withOffset: 25)
            
            // Layout refresh button
            view.addSubview(refreshButton)
            refreshButton.autoAlignAxis(toSuperviewAxis: .vertical)
            refreshButton.autoPinEdge(.top, to: .bottom, of: orLabel2, withOffset: 25)
            
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
