//
//  ThreadObjects.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/20/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit

class ThreadObjects {
    
    class navBar: NecterNavigationBar {
        
        init() {
            super.init(ViewControllersEnum.ThreadViewController)
            
            // Adding line at the bottom of the navigation bar
            self.setBackgroundImage(UIImage(), for: .default)
            self.shadowImage = nil
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    class Table: UITableView {
        
    }
    
    class NameTableCell: UITableViewCell {
        
    }
    
    class MessageTableCell: UITableViewCell {
        
    }
    
    class NotificationTableCell: UITableViewCell {
        
    }
    
    class Keyboard: CustomKeyboard {
        
    }
}
