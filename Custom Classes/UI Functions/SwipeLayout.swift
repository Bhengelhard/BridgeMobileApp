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
    var topSwipeCardHorizontalConstraint: NSLayoutConstraint?
    var bottomSwipeCardHorizontalConstraint: NSLayoutConstraint?
    
    /// Sets the initial layout constraints
    func initialize(view: UIView, didSetupConstraints: Bool) -> Bool {
        print("initializing layout")
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
            
            let height = 450
            let width = 300
            let size = CGSize(width: width, height: height)
            view.addSubview(topSwipeCard)
            let topSwipeCardLocationConstraints = topSwipeCard.autoCenterInSuperview()
            if topSwipeCardLocationConstraints.count >= 2 {
                topSwipeCardHorizontalConstraint = topSwipeCardLocationConstraints[1]
            }
            topSwipeCard.autoSetDimensions(to: size)
            
            view.insertSubview(bottomSwipeCard, belowSubview: topSwipeCard)
            let bottomSwipeCardLocationConstraints = bottomSwipeCard.autoCenterInSuperview()
            if bottomSwipeCardLocationConstraints.count >= 2 {
                bottomSwipeCardHorizontalConstraint = bottomSwipeCardLocationConstraints[1]
            }
            bottomSwipeCard.autoSetDimensions(to: size)
            
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
            
            view.addSubview(connectIcon)
            connectIcon.alpha = 0
            
            view.addSubview(disconnectIcon)
            disconnectIcon.alpha = 0
            
            // Layout the pass button at the bottom of the view for dismissing presented matches
            
            
            // Layout nect button at the bottom of the view for connecting presented matches
            
            

//            // Layout the secondSwipeCard in the center of the screen
//            view.addSubview(secondSwipeCard)
//            view.autoCenterInSuperview()
            
//            // Layout the firstSwipeCard in the center of the screen above the secondSwipeCard
//            view.addSubview(firstSwipeCard)
//            firstSwipeCard.autoCenterInSuperview()


            
        }
        
        return true
    }
    
    func updateTopSwipeCardHorizontalConstraint(translation: CGFloat) {
        if let constraint = topSwipeCardHorizontalConstraint {
            constraint.constant = constraint.constant + translation
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
        print("switching top and bottom cards")
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
