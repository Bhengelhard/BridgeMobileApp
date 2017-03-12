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
    
    // MARK: - Layout
    /// Sets the initial layout constraints
    func initialize(view: UIView, messagesView: UIView, didSetupConstraints: Bool) -> Bool {
        if (!didSetupConstraints) {
            
            // MARK: Layout Objects
                        
            // Layout the navigation bar
            view.addSubview(navBar)
            navBar.autoPinEdge(toSuperviewEdge: .top)
            navBar.autoPinEdge(toSuperviewEdge: .left)
            navBar.autoMatch(.width, to: .width, of: view)
            navBar.autoSetDimension(.height, toSize: 64)
            
            // Layout messages view
            view.addSubview(messagesView)
            messagesView.autoPinEdge(.top, to: .bottom, of: navBar)
            messagesView.autoPinEdge(toSuperviewEdge: .left)
            messagesView.autoMatch(.width, to: .width, of: view)
            messagesView.autoPinEdge(toSuperviewEdge: .bottom)
            
        }
        
        return true
    }
}
