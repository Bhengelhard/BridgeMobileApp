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
    let navBar = MessagesObjects.NavBar()
    //let newMatchesTitle = MessagesObjects.NewMatchesTitle()
    //let newMatchesScrollView = MessagesObjects.NewMatchesScrollView()
//    let messagesTitle = MessagesObjects.MessagesTitle()
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
            
//            // Layout the newMatchesTitle below the navigation bar
//            view.addSubview(newMatchesTitle)
//            newMatchesTitle.autoPinEdge(.top, to: .bottom, of: navBar, withOffset: 12)
//            newMatchesTitle.autoPinEdge(.left, to: .left, of: view, withOffset: 20)
//            
//            // Layout the newMatchesScrollView below the newMatchesTitle
//            view.addSubview(newMatchesScrollView)
//            newMatchesScrollView.autoPinEdge(.top, to: .bottom, of: newMatchesTitle, withOffset: 20)
//            newMatchesScrollView.autoPinEdge(toSuperviewEdge: .left)
//            newMatchesScrollView.autoMatch(.width, to: .width, of: view)
//            newMatchesScrollView.autoSetDimension(.height, toSize: 80)
            
//            // Layout the messagesTitle below the newMatchesScrollView
//            view.addSubview(messagesTitle)
//            messagesTitle.autoPinEdge(.left, to: .left, of: view, withOffset: 20)
//            messagesTitle.autoPinEdge(.top, to: .bottom, of: navBar, withOffset: 20)
            
            view.addSubview(messagesTable)
            messagesTable.autoPinEdge(.top, to: .bottom, of: navBar)
            messagesTable.autoMatch(.width, to: .width, of: view)
            messagesTable.autoPinEdge(toSuperviewEdge: .bottom)
            
        }
        
        return true
    }
    
}
