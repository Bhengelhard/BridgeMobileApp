//
//  SettingsLayout.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/21/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import PureLayout

class SettingsLayout {
    
    // MARK: Global Variables
    let navBar = SettingsObjects.NavBar()
    let table = SettingsObjects.Table()
    let websiteView = SettingsObjects.WebsiteView()
    
    // MARK: - Layout
    /// Sets the initial layout constraints
    func initialize(view: UIView, didSetupConstraints: Bool) -> Bool {
        
        if (!didSetupConstraints) {
            
            // Layout the navigation bar at the top of the view with a done button for dismissing the EditProfileViewController
            view.addSubview(navBar)
            navBar.autoPinEdge(toSuperviewEdge: .top)
            navBar.autoPinEdge(toSuperviewEdge: .left)
            navBar.autoMatch(.width, to: .width, of: view)
            navBar.autoSetDimension(.height, toSize: 64)
            
            // Layout the website view pinned to the bottom of the page
            view.addSubview(websiteView)
            websiteView.autoPinEdge(toSuperviewEdge: .bottom)
            websiteView.autoPinEdge(toSuperviewEdge: .left)
            websiteView.autoPinEdge(toSuperviewEdge: .right)
            websiteView.autoSetDimension(.height, toSize: 40)
            websiteView.label.autoCenterInSuperview()
            
            // Layout the table below the navigation bar and above the websiteView
            view.addSubview(table)
            table.autoPinEdge(.top, to: .bottom, of: navBar)
            table.autoPinEdge(.bottom, to: .top, of: websiteView)
            table.autoPinEdge(toSuperviewEdge: .left)
            table.autoPinEdge(toSuperviewEdge: .right)
            
        }
        
        return true
    }
    
}
