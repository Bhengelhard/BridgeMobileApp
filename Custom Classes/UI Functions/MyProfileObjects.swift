//
//  MyProfileObjects.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/20/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit

class MyProfileObjects {
    
    class NavBar: UINavigationBar {
        
        init() {
            super.init(frame: CGRect())
            
            // Setting the color of the navigation bar to white
            self.backgroundColor = UIColor.white
            
            // Removing line at the bottom of the navigation bar
            self.setBackgroundImage(UIImage(), for: .default)
            self.shadowImage = UIImage()
            
            // Setting the navigation Bar Title Image
            let navItem = UINavigationItem()
            let logo = #imageLiteral(resourceName: "Profile_Navbar_Active")
            let imageView = UIImageView(image: logo)
            imageView.frame.size = CGSize(width: 40, height: 40)
            imageView.contentMode = .scaleAspectFit
            navItem.titleView = imageView
            
            // Setting the right Bar Button Item
            let rightIcon = #imageLiteral(resourceName: "Necter_Navbar")
            let rightButton = UIButton()
            rightButton.frame.size = CGSize(width: 36, height: 36)
            rightButton.setImage(rightIcon, for: .normal)
            rightButton.addTarget(self, action: #selector(rightBarButtonTapped(_:)), for: .touchUpInside)
            let rightItem = UIBarButtonItem(customView: rightButton)
            navItem.rightBarButtonItem = rightItem
            
            self.setItems([navItem], animated: false)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func rightBarButtonTapped(_ sender: UIBarButtonItem) {
            print("segue from MyProfileViewController to SwipeViewController")
        }
    }
    
    class ProfilePictureBackground: UIImageView {
        
    }
    class ProfilePicture: HexagonView {
        
    }
    
    class EditProfileButton: UIButton {
        
    }
    
    class ReputationScore: UIButton {
        
    }
    
    class ReputationText: UIButton {
    
    }
    
    class SettingsButton: UIButton {
        
    }
    
    class FriendsImage: UIImageView {
        
    }
    
    class InviteFriendsButton: UIButton {
        
    }
    
}
