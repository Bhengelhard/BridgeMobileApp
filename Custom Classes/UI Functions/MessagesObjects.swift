//
//  MessagesObjects.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/20/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit

class MessagesObjects {
    
    class NavBar: NecterNavigationBar {
        
        override init() {
            super.init()
            
            // Setting Navigation Items
            let leftIcon = #imageLiteral(resourceName: "Necter_Navbar_Inactive")
            leftButton.setImage(leftIcon, for: .normal)
            
            let titleImage = #imageLiteral(resourceName: "Messages_Navbar_Active")
            titleImageView.image = titleImage
            navItem.titleView = titleImageView
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    }
    
    class NewMatchesTitle: UILabel {
        
        init() {
            super.init(frame: CGRect())
            
            self.text = "New Matches"
            self.font = Constants.Fonts.bold16
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    class NewMatchesScrollView: NewMatchesView {

    }
    
    class MessagesTitle: UILabel {
        
        init() {
            super.init(frame: CGRect())
            
            self.text = "Messages"
            self.font = Constants.Fonts.bold16
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    class MessagesTable: UITableView {
        
        
        
    }
    
    class MessagesTableCell: UITableViewCell {
        
    }
    
}
