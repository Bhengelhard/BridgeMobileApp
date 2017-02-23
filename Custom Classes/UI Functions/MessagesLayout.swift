//
//  MessagesLayout.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/20/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import PureLayout

class MessagesLayout {
    
    // MARK: Global Variables
    let navBar = MessagesObjects.NavBar(ViewControllersEnum.MessagesViewController)
    let newMatchesTitle = MessagesObjects.NewMatchesTitle()
    let newMatchesScrollView = MessagesObjects.NewMatchesScrollView()
    let messagesTitle = MessagesObjects.MessagesTitle()
    let messagesTable = MessagesObjects.MessagesTable()
    let messagesTableCell = MessagesObjects.MessagesTableCell()
    
    // MARK: - Layout
    /// Sets the initial layout constraints
    func initialize(view: UIView, didSetupConstraints: Bool) -> Bool {
        
        if (!didSetupConstraints) {
            
            // Layout the navigation bar with title image and left bar button items
            view.addSubview(navBar)
            navBar.autoPinEdge(toSuperviewEdge: .top)
            navBar.autoPinEdge(toSuperviewEdge: .left)
            navBar.autoMatch(.width, to: .width, of: view)
            navBar.autoSetDimension(.height, toSize: 64)
            
            
        }
        
        return true
    }
    
}
