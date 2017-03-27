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
    
    class NoMessagesView: UIView {
        
        
        init() {
            super.init(frame: CGRect())
                        
            let label = UILabel()
            label.text = "\"All of life is rooted in relationships\"\n\n-Lee A. Harris"
            label.textColor = Constants.Colors.necter.textGray
            label.font = Constants.Fonts.bold24
            label.numberOfLines = 0
            label.textAlignment = NSTextAlignment.center
            
            addSubview(label)
            label.autoPinEdgesToSuperviewEdges()
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
