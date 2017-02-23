//
//  MyProfileLayout.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/20/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import PureLayout

class MyProfileLayout {
    
    // MARK: Global Variables
    let navBar = MyProfileObjects.NavBar()
    let profilePictureBackground = MyProfileObjects.ProfilePictureBackground()
    let profilePicture = MyProfileObjects.ProfilePicture()
    let editProfileButton = MyProfileObjects.EditProfileButton()
    let reputationScore = MyProfileObjects.ReputationScore()
    let reputationText = MyProfileObjects.ReputationText()
    let settingsButton = MyProfileObjects.SettingsButton()
    let friendsImage = MyProfileObjects.FriendsImage()
    let inviteFriendsButton = MyProfileObjects.InviteFriendsButton()
    
    // MARK: - Layout
    /// Sets the initial layout constraints
    func initialize(view: UIView, didSetupConstraints: Bool) -> Bool {
        
        if (!didSetupConstraints) {
            
            // Layout the navigation bar with title image and left and right bar button items
            view.addSubview(navBar)
            navBar.autoPinEdge(toSuperviewEdge: .top)
            navBar.autoPinEdge(toSuperviewEdge: .leading)
            navBar.autoMatch(.width, to: .width, of: view)
            navBar.autoSetDimension(.height, toSize: 64)
            
        }
        
        return true
    }
    
}
