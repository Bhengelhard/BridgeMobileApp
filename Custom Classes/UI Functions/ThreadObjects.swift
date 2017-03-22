//
//  ThreadObjects.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/20/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ThreadObjects {
    
    class NavBar: NecterNavigationBar {
        
        override init() {
            super.init()
            
            // Setting Navigation Items
            let leftIcon = #imageLiteral(resourceName: "Back_Button")
            leftButton.setImage(leftIcon, for: .normal)
            
            let rightIcon = #imageLiteral(resourceName: "More_Button")
            rightButton.setImage(rightIcon, for: .normal)
            rightButton.frame.size = CGSize(width: 50, height: 14)
            
            setTitleImage(image: #imageLiteral(resourceName: "Background_Gray_Circle"))
            
            // Adding line at the bottom of the navigation bar
            setBackgroundImage(UIImage(), for: .default)
            shadowImage = nil
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
}
