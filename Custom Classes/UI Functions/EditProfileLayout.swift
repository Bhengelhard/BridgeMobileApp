//
//  EditProfileLayout.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/20/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import PureLayout

class EditProfileLayout {
    
    // MARK: Global Variables
    let navBar = EditProfileObjects.NavBar()
    let table = EditProfileObjects.Table()
    
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
            
            // Layout the Table below the navigation bar
            view.addSubview(table)
            table.autoPinEdge(.top, to: .bottom, of: navBar)
            table.autoPinEdge(toSuperviewEdge: .left)
            table.autoPinEdge(toSuperviewEdge: .right)
            table.autoPinEdge(toSuperviewEdge: .bottom)
            
        }
        
        return true
    }

}
