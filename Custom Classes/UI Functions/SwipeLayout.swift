//
//  SwipeLayout.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/17/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import PureLayout

class SwipeLayout {
    
    // MARK: Global Variables
    let navBar = SwipeObjects.NavBar()
    let firstSwipeCard = SwipeCard()
    let secondSwipeCard = SwipeCard()
    let passButton = SwipeObjects.DecisionButton(text: "PASS")
    let nectButton = SwipeObjects.DecisionButton(text: "NECT")
    let infoButton = SwipeObjects.InfoButton()
    
    /// Sets the initial layout constraints
    func initialize(view: UIView, didSetupConstraints: Bool) -> Bool {
        
        if (!didSetupConstraints) {
            
            // MARK: Layout Objects
            // Layout the navigation bar at the top of the view for navigating from the SwipeViewController to the MessagesViewController and the MyProfileViewController
            view.addSubview(navBar)
            
            // Layout the pass button at the bottom of the view for dismissing presented matches
            view.addSubview(passButton)
            passButton.backgroundColor = UIColor.lightGray
            
            // Layout the secondSwipeCard in the center of the screen
            view.addSubview(secondSwipeCard)
            view.autoCenterInSuperview()
            
            // Layout the firstSwipeCard in the center of the screen above the secondSwipeCard
            view.addSubview(firstSwipeCard)
            firstSwipeCard.autoCenterInSuperview()
            
            // Layout the information button at the bottom of the view to get instructions on how to use the app
            view.addSubview(infoButton)
            infoButton.autoAlignAxis(.vertical, toSameAxisOf: view)
            infoButton.autoAlignAxis(.horizontal, toSameAxisOf: passButton)
            
            // Layout nect button at the bottom of the view for connecting presented matches
            view.addSubview(nectButton)
            nectButton.backgroundColor = UIColor.orange
            nectButton.autoMatch(.width, to: .width, of: passButton)
            nectButton.autoMatch(.height, to: .height, of: passButton)
            nectButton.autoAlignAxis(.horizontal, toSameAxisOf: passButton)
            
        }
        
        return true
    }
    
}
