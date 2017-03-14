//
//  MyProfileObjects.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/20/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit

class MyProfileObjects {
    
    class NavBar: NecterNavigationBar {
        
        override init() {
            super.init()
            
            // Setting Navigation Items
            let rightIcon = #imageLiteral(resourceName: "Necter_Navbar_Inactive")
            rightButton.setImage(rightIcon, for: .normal)
            
            let titleImage = #imageLiteral(resourceName: "Profile_Navbar_Active")
            titleImageView.image = titleImage
            navItem.titleView = titleImageView
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
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
            self.setBackgroundColor(color: Constants.Colors.necter.backgroundGray)
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
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.4
            self.layer.shadowOffset = .init(width: 1, height: 1)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func tapped(_ sender: UIButton) {
            print("EditProfileButton tapped")
        }
        
    }
    
    /// Rounded Rectangle Button that displays the user's reputation score
    class ReputationScore: ReusableObjects.ReputationButton {
        
    }
    
    /// Greyed text giving explanation to the reputation score
    class ReputationText: UIButton {
        
        init() {
            super.init(frame: CGRect())
            
            self.setTitle("REPUTATION", for: .normal)
            self.setTitleColor(UIColor.gray, for: .normal)
            self.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
            self.titleLabel?.font = Constants.Fonts.light18
            
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
            self.titleLabel?.font = Constants.Fonts.light18
            
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
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.4
            self.layer.shadowOffset = .init(width: 1, height: 1)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}
