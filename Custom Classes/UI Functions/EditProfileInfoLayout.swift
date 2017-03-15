//
//  EditProfileInfoLayout.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 3/10/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import PureLayout

class EditProfileInfoLayout {
    
    // MARK: Global Variables
    let navBar: EditProfileInfoObjects.NavBar
    let table: EditProfileInfoObjects.TableView
    
    init(infoTitle: String, value: String) {
        self.navBar = EditProfileInfoObjects.NavBar(infoTitle: infoTitle)
        self.table = EditProfileInfoObjects.TableView(infoTitle: infoTitle, value: value)
        
    }
    
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
            
            // Layout the table below the navigation bar
            view.addSubview(table)
            table.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
            table.autoPinEdge(.top, to: .bottom, of: navBar)
            
        }
        
        return true
    }
    
}
