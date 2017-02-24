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
            navBar.autoPinEdge(toSuperviewEdge: .top)
            navBar.autoPinEdge(toSuperviewEdge: .left)
            navBar.autoMatch(.width, to: .width, of: view)
            navBar.autoSetDimension(.height, toSize: 64)
            
            
            let toolBarView = UIView()
            view.addSubview(toolBarView)
            toolBarView.backgroundColor = UIColor.yellow
            toolBarView.autoAlignAxis(.vertical, toSameAxisOf: view)
            toolBarView.autoPinEdge(.bottom, to: .bottom, of: view)
            toolBarView.autoMatch(.width, to: .width, of: view)
            toolBarView.autoSetDimension(.height, toSize: 49)
            
            toolBarView.addSubview(infoButton)
            infoButton.autoAlignAxis(.horizontal, toSameAxisOf: toolBarView)
            infoButton.autoAlignAxis(.vertical, toSameAxisOf: toolBarView)
            infoButton.autoSetDimensions(to: CGSize(width: 30, height: 30))
            
            // Layout the pass button at the bottom of the view for dismissing presented matches
            view.addSubview(passButton)
            passButton.autoAlignAxis(.horizontal, toSameAxisOf: toolBarView)
            passButton.autoPinEdge(.right, to: .left, of: infoButton, withOffset: -20)
            passButton.autoSetDimensions(to: CGSize(width: 120, height: 40))
            
            // Layout nect button at the bottom of the view for connecting presented matches
            toolBarView.addSubview(nectButton)
            nectButton.autoAlignAxis(.horizontal, toSameAxisOf: toolBarView)
            nectButton.autoPinEdge(.left, to: .right, of: infoButton, withOffset: 20)
            nectButton.autoMatch(.width, to: .width, of: passButton)
            nectButton.autoMatch(.height, to: .height, of: passButton)

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
