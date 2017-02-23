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
            
            // Layout the profilePictureBackground with the Profile Faded Hexagon Image
            view.addSubview(profilePictureBackground)
            profilePictureBackground.autoPinEdge(.top, to: .bottom, of: navBar)
            profilePictureBackground.autoPinEdge(.left, to: .left, of: view)
            profilePictureBackground.autoMatch(.width, to: .width, of: view)
            profilePictureBackground.autoMatch(.height, to: .width, of: profilePictureBackground)
            
            // Layout the profilePicture with the current User's profile Picture
            profilePictureBackground.addSubview(profilePicture)
            profilePicture.autoCenterInSuperview()
            profilePicture.autoSetDimensions(to: CGSize(width: 150, height: 150))
            
            // Layout editProfileButton on the bottom right corner of the profilePictureBackground Hexagon
            profilePicture.addSubview(editProfileButton)
            editProfileButton.autoPinEdge(.bottom, to: .bottom, of: profilePicture)
            editProfileButton.autoPinEdge(.right, to: .right, of: profilePicture)
            editProfileButton.autoSetDimensions(to: CGSize(width: 60, height: 60))
            
            
        }
        
        return true
    }
    
}
