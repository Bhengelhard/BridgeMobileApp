//
//  SwipeObjects.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/17/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class SwipeObjects {
    
    class NavBar: CustomNavigationBar {
        
    }
    
    class DecisionButton: UIButton {
        
        init(text: String) {
            super.init(frame: CGRect())
            self.setTitle("text", for: .normal)
            self.setTitleColor(UIColor.white, for: .normal)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class InfoButton: UIButton {
        
        init() {
            super.init(frame: CGRect())
            self.setTitle("i", for: .normal)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}
