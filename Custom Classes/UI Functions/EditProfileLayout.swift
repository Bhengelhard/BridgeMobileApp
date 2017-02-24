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
    let editImagesView = EditProfileObjects.EditImagesView()
    
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
            
//            // Layout the editImagesView below the navigation bar
//            editImagesView.backgroundColor = UIColor.red
//            view.addSubview(editImagesView)
//            view.autoMatch(.width, to: .width, of: view)
//            view.autoPinEdge(.top, to: .bottom, of: navBar)
//            view.autoPinEdge(toSuperviewEdge: .left)
//            view.autoSetDimension(.height, toSize: 394.5)

            
        }
        
        return true
    }

}
