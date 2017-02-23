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
    let navBar = MyProfileObjects.NavBar(ViewControllersEnum.MyProfileViewController)
    let profilePictureBackground = MyProfileObjects.ProfilePictureBackground()
    let profilePicture = MyProfileObjects.ProfilePicture()
    let editProfileButton = MyProfileObjects.EditProfileButton()
    let reputationScore = MyProfileObjects.ReputationScore()
    let reputationText = MyProfileObjects.ReputationText()
    let settingsButton = MyProfileObjects.SettingsButton()
    let friendsImage = MyProfileObjects.FriendsImage()
    let inviteButton = MyProfileObjects.InviteButton()
    
    // MARK: - Layout
    /// Sets the initial layout constraints
    func initialize(view: UIView, didSetupConstraints: Bool) -> Bool {
        
        if (!didSetupConstraints) {
            
            // Layout the navigation bar with title image and right bar button items
            view.addSubview(navBar)
            navBar.autoPinEdge(toSuperviewEdge: .top)
            navBar.autoPinEdge(toSuperviewEdge: .left)
            navBar.autoMatch(.width, to: .width, of: view)
            navBar.autoSetDimension(.height, toSize: 64)
            
//            // Layout the profilePictureBackground with the Profile Faded Hexagon Image
//            view.addSubview(profilePictureBackground)
//            profilePictureBackground.autoPinEdge(.top, to: .bottom, of: navBar)
//            profilePictureBackground.autoPinEdge(.left, to: .left, of: view)
//            profilePictureBackground.autoMatch(.width, to: .width, of: view)
//            profilePictureBackground.autoMatch(.height, to: .width, of: profilePictureBackground)
            
            // Layout the profilePicture with the current User's profile Picture
            view.addSubview(profilePicture)
            profilePicture.autoAlignAxis(.vertical, toSameAxisOf: view)
            profilePicture.autoPinEdge(.top, to: .bottom, of: navBar, withOffset: 35)
            profilePicture.autoSetDimensions(to: CGSize(width: 260, height: 260))
            
            // Layout editProfileButton on the bottom right corner of the profilePictureBackground Hexagon
            view.addSubview(editProfileButton)
            editProfileButton.autoPinEdge(.bottom, to: .bottom, of: profilePicture)
            editProfileButton.autoPinEdge(.right, to: .right, of: profilePicture)
            editProfileButton.autoSetDimensions(to: CGSize(width: 60, height: 60))
            
            // Layout reputationScore below the profilePicture with the user's score
            view.addSubview(reputationScore)
            reputationScore.autoAlignAxis(.vertical, toSameAxisOf: view)
            reputationScore.autoPinEdge(.top, to: .bottom, of: profilePicture, withOffset: 8)
            reputationScore.autoSetDimensions(to: CGSize(width: 45, height: 45))
            
            // Layout reputationText below the reputationScore
            view.addSubview(reputationText)
            reputationText.autoAlignAxis(.vertical, toSameAxisOf: view)
            reputationText.autoPinEdge(.top, to: .bottom, of: reputationScore, withOffset: 2)

            
            // Layout settingsButton below the reputationText
            view.addSubview(settingsButton)
            settingsButton.autoAlignAxis(.vertical, toSameAxisOf: view)
            settingsButton.autoPinEdge(.top, to: .bottom, of: reputationText, withOffset: 35)
            
            // Layout friendsImage to pin to the bottom of the view
            view.addSubview(friendsImage)
            friendsImage.autoPinEdge(toSuperviewEdge: .left)
            friendsImage.autoPinEdge(toSuperviewEdge: .bottom)
            friendsImage.autoMatch(.width, to: .width, of: view)
            
            // Layout inviteButton to center of the friendsImage
            view.addSubview(inviteButton)
            inviteButton.autoAlignAxis(.horizontal, toSameAxisOf: friendsImage)
            inviteButton.autoAlignAxis(.vertical, toSameAxisOf: friendsImage)
            inviteButton.autoSetDimensions(to: CGSize(width: 241.5, height: 42.5))
            
        }
        
        return true
    }
    
}
