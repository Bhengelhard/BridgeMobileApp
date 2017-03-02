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
    let navBar = SwipeObjects.NavBar()
    let topSwipeCard = SwipeCard()
    let bottomSwipeCard = SwipeCard()
    let passButton = SwipeObjects.DecisionButton(text: "PASS")
    let nectButton = SwipeObjects.DecisionButton(text: "NECT")
    let infoButton = SwipeObjects.InfoButton()
    
    /// Sets the initial layout constraints
    func initialize(view: UIView, didSetupConstraints: Bool) -> Bool {
        
        if (!didSetupConstraints) {
            
            // MARK: Layout Objects
            let margin: CGFloat = 20
            
            // Layout the navigation bar at the top of the view for navigating from the SwipeViewController to the MessagesViewController and the MyProfileViewController
            view.addSubview(navBar)
            navBar.autoPinEdge(toSuperviewEdge: .top)
            navBar.autoPinEdge(toSuperviewEdge: .left)
            navBar.autoMatch(.width, to: .width, of: view)
            navBar.autoSetDimension(.height, toSize: 64)
            
            view.addSubview(topSwipeCard)
            topSwipeCard.autoCenterInSuperview()
            
            view.addSubview(bottomSwipeCard)
            bottomSwipeCard.autoCenterInSuperview()
            
            
            
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
    
}
