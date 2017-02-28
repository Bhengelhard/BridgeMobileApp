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
        
        init() {
            super.init(ViewControllersEnum.MyProfileViewController)
            
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
            
            // **Backend - delete Parse Import at top
            self.setBackgroundImage(image: #imageLiteral(resourceName: "Example_User_Profile_Picture"))
            self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped(_:))))
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func tapped(_ sender: UITapGestureRecognizer) {
            print("ProfilePicture tapped")
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
