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
//    let reputationScore = MyProfileObjects.ReputationScore()
    let name = MyProfileObjects.ReputationText()
    let settingsButton = MyProfileObjects.SettingsButton()
    let friendsImage = MyProfileObjects.FriendsImage()
    let inviteButton = MyProfileObjects.InviteButton()
    
    // MARK: - Layout
    /// Sets the initial layout constraints
    func initialize(view: UIView, didSetupConstraints: Bool) -> Bool {
        
        if (!didSetupConstraints) {
            
            print(DisplayUtility.screenWidth)
            print(DisplayUtility.screenHeight)
            
            // Layout the navigation bar with title image and right bar button items
            view.addSubview(navBar)
            navBar.autoPinEdge(toSuperviewEdge: .top)
            navBar.autoPinEdge(toSuperviewEdge: .left)
            navBar.autoMatch(.width, to: .width, of: view)
            navBar.autoSetDimension(.height, toSize: 64)
            
            // Layout the profilePicture with the current User's profile Picture
            view.addSubview(profilePicture)
            profilePicture.autoAlignAxis(.vertical, toSameAxisOf: view)
            profilePicture.autoPinEdge(.top, to: .bottom, of: navBar, withOffset: 35)
            let hexWToHRatio: CGFloat = 2 / sqrt(3)
            let hexWidth : CGFloat = 190
            let hexHeight = hexWidth / hexWToHRatio
            profilePicture.autoSetDimensions(to: CGSize(width: hexWidth, height: hexHeight))
            
            // Layout editProfileButton on the bottom right corner of the profilePictureBackground Hexagon
            view.addSubview(editProfileButton)
            editProfileButton.autoPinEdge(.bottom, to: .bottom, of: profilePicture)
            editProfileButton.autoPinEdge(.right, to: .right, of: profilePicture)
            editProfileButton.autoSetDimensions(to: CGSize(width: 70, height: 70))
            
            // Layout reputationText below the reputationScore
            view.addSubview(name)
            name.autoAlignAxis(.vertical, toSameAxisOf: view)
            name.autoPinEdge(.top, to: .bottom, of: profilePicture, withOffset: 12)

            // Layout settingsButton below the reputationText
            view.addSubview(settingsButton)
            settingsButton.autoAlignAxis(.vertical, toSameAxisOf: view)
            settingsButton.autoPinEdge(.top, to: .bottom, of: name, withOffset: 50)
            
            // Layout friendsImage to pin to the bottom of the view
            view.addSubview(friendsImage)
            friendsImage.autoPinEdge(toSuperviewEdge: .left)
            friendsImage.autoPinEdge(toSuperviewEdge: .bottom)
            friendsImage.autoMatch(.width, to: .width, of: view)
            
            // Layout inviteButton to center of the friendsImage
            view.addSubview(inviteButton)
            inviteButton.autoAlignAxis(.horizontal, toSameAxisOf: friendsImage)
            inviteButton.autoAlignAxis(.vertical, toSameAxisOf: view)
            inviteButton.autoSetDimensions(to: CGSize(width: 241.5, height: 42.5))
            
        }
        
        return true
    }
    
}
