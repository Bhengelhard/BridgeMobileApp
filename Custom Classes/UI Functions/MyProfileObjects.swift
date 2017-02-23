//
//  MyProfileObjects.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/20/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit
import Parse

class MyProfileObjects {
    
    /// Navigation Bar Object for the MyProfileViewController
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
        
        // Add Target to rightBarButton for segue from MyProfileViewController to SwipeViewController
        func rightBarButtonTapped(_ sender: UIBarButtonItem) {
            print("segue from MyProfileViewController to SwipeViewController")
        }
    }
    
    /// Glowing Faded Hexagon Image on MyProfileViewController
    class ProfilePictureBackground: UIImageView {
        
        init() {
            super.init(frame: CGRect())
            
            self.image = #imageLiteral(resourceName: "Profile_Faded_Hexagon")
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    /// Current User's Main Profile Picture displayed inside of a Hexagon
    class ProfilePicture: HexagonView {
        
        override init() {
            super.init()
            
            // **Backend - delete Parse Import at top
            self.setBackgroundImage(image: #imageLiteral(resourceName: "Profile_Navbar_Icon"))
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    /// Button that segues the user from MyProfileViewController to the EditProfileViewController
    class EditProfileButton: UIButton {
        
        init() {
            super.init(frame: CGRect())
            
            self.setBackgroundImage(#imageLiteral(resourceName: "Profile_Edit_Button"), for: .normal)
            self.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func tapped(_ sender: UIButton) {
            print("EditProfileButton tapped")
        }
        
    }
    
    /// Rounded Rectangle Button that displays the user's reputation score
    class ReputationScore: UIButton {
        
        init() {
            super.init(frame: CGRect())
            
            self.layer.cornerRadius = 10
            self.layer.borderColor = UIColor.black.cgColor
            self.layer.borderWidth = 3
            self.setTitle("15", for: .normal)
            self.titleLabel?.font = Constants.Fonts.bold50
            self.setTitleColor(UIColor.black, for: .normal)
            self.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func tapped(_ sender: UIButton) {
            print("ReputationScore tapped")
        }
        
    }
    
    /// Greyed text giving explanation to the reputation score
    class ReputationText: UIButton {
        
        init() {
            super.init(frame: CGRect())
            
            self.setTitle("REPUTATION", for: .normal)
            self.setTitleColor(UIColor.gray, for: .normal)
            self.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
            self.titleLabel?.font = Constants.Fonts.light14
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func tapped(_ sender: UIButton) {
            print("ReputationText tapped")
        }
    
    }
    
    /// Button that segues the user from the MyProfileViewController to the SettingsViewController
    class SettingsButton: UIButton {
        
        init() {
            super.init(frame: CGRect())
            
            self.setTitle("MY SETTINGS", for: .normal)
            self.setTitleColor(UIColor.red, for: .normal)
            self.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
            self.titleLabel?.font = Constants.Fonts.light14
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // Segues from the MyProfileViewController to the SettingsViewController
        func tapped(_ sender: UIButton) {
            print("SettingsButton tapped")
        }
        
    }
    
    /// Hexagon designed images of potential friends to add to the app
    class FriendsImage: UIImageView {
        
        init() {
            super.init(frame: CGRect())
            
            self.image = #imageLiteral(resourceName: "Profile_Friends_Hexagons")
            self.contentMode = .scaleAspectFill
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    class InviteButton: UIButton {
        
        init() {
            super.init(frame: CGRect())
            
            self.setImage(#imageLiteral(resourceName: "Profile_Invite_Button"), for: .normal)
            self.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // Presents Message with text prepopulated
        func tapped(_ sender: UIButton) {
            print("InviteButton tapped")
        }
        
    }
    
}
