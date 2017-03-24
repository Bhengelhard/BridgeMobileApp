//
//  ThreadLayout.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/20/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import PureLayout
import JSQMessagesViewController

class ThreadLayout {
    
    // MARK: Global Variables
    let navBar = ThreadObjects.NavBar()
    let noMessagesView = ThreadObjects.NoMessagesView()
    
    // MARK: - Layout
    /// Sets the initial layout constraints
    func initialize(view: UIView, messagesVC: JSQMessagesViewController, didSetupConstraints: Bool) -> Bool {
        if (!didSetupConstraints) {
            
            // MARK: Layout Objects
                        
            // Layout the navigation bar
            view.addSubview(navBar)
            navBar.autoPinEdge(toSuperviewEdge: .top)
            navBar.autoPinEdge(toSuperviewEdge: .left)
            navBar.autoMatch(.width, to: .width, of: view)
            navBar.autoSetDimension(.height, toSize: 64)
            
            // Layout messages view
            view.addSubview(messagesVC.view)
            messagesVC.view.autoPinEdge(.top, to: .bottom, of: navBar)
            messagesVC.view.autoPinEdge(toSuperviewEdge: .left)
            messagesVC.view.autoMatch(.width, to: .width, of: view)
            messagesVC.view.autoPinEdge(toSuperviewEdge: .bottom)
            
            messagesVC.collectionView.addSubview(noMessagesView)
            noMessagesView.autoCenterInSuperview()
            noMessagesView.autoMatch(.width, to: .width, of: view, withMultiplier: 0.6)
            noMessagesView.autoMatch(.height, to: .width, of: noMessagesView, withMultiplier: 0.5)
            
        }
        
        return true
    }
}
