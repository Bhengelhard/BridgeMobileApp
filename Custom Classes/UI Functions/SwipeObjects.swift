//
//  SwipeObjects.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/17/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit

class SwipeObjects {
    
    class NavBar: NecterNavigationBar {
        
        override init() {
            super.init()
            
            // Setting Navigation Items
            let rightIcon = #imageLiteral(resourceName: "Messages_Navbar_Inactive")
            rightButton.setImage(rightIcon, for: .normal)
            
            let leftIcon = #imageLiteral(resourceName: "Profile_Navbar_Inactive")
            leftButton.setImage(leftIcon, for: .normal)
            
            let titleImage = #imageLiteral(resourceName: "Necter_Navbar_Active")
            titleImageView.image = titleImage
            navItem.titleView = titleImageView
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class DecisionButton: UIButton {
        
        let size = CGSize(width: 160, height: 40)
        
        init(text: String) {
            super.init(frame: CGRect())
            self.setTitle(text, for: .normal)
            self.setTitleColor(UIColor.white, for: .normal)
            self.titleLabel?.font = Constants.Fonts.bold24
            self.contentVerticalAlignment = UIControlContentVerticalAlignment.bottom
            self.layer.cornerRadius = 15
            self.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
            
            if text == "NECT" {
                self.backgroundColor = DisplayUtility.gradientColor(size: self.size)
            } else {
                self.backgroundColor = Constants.Colors.necter.buttonGray
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func tapped (_ sender: UIButton) {
            print("tapped")
        }
        
    }
    
    class InfoButton: UIButton {
        
        init() {
            super.init(frame: CGRect())
            
            self.setImage(#imageLiteral(resourceName: "Information_Icon"), for: .normal)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}
