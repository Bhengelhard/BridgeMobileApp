//
//  PrivacyPolicyObjects.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/17/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit

class PrivacyPolicyObjects {
    
    // MARK: - Object Classes
    /// ReturnToLoginButton allows the user can segue back to Login from the Privacy Policy
    class ReturnToLoginButton: UIButton {
        init() {
            super.init(frame: CGRect())
            self.setImage(#imageLiteral(resourceName: "Black_X"), for: .normal)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
                
    }
    
    /// FBLoginButton is UIButton allowing user to log into the necter app using Facebook authentication
    class FBLoginButton: UIButton  {
        
        init() {
            super.init(frame: CGRect())
            
            self.setTitle("CONNECT WITH FACEBOOK", for: .normal)
            self.setTitleColor(UIColor.white, for: .normal)
            self.setTitleColor(DisplayUtility.gradientColor(size: (self.titleLabel?.frame.size)!), for: .highlighted)
            self.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 16)
            self.backgroundColor = UIColor(red: 66.0/255.0, green: 103.0/255.0, blue: 178.0/255.0, alpha: 1)
            self.layer.cornerRadius = 8
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    /// Header is a UILabel that displays a statement about our privacy policy
    class Header: UILabel {
        
        init() {
            super.init(frame: CGRect())
            self.text = "We're serious about privacy"
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    /// Label initiate a set of privacy description labels with text inputs
    class Label: UILabel {
        
        init(text: String) {
            super.init(frame: CGRect())
            self.text = text
            self.numberOfLines = 0
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        
    }
    
    /// PrivacyPolicyButton is a UIButton that allows the user to view the necter privacy policy from a web pop-up within the app
    class PrivacyPolicyButton: UIButton {
        
        init() {
            super.init(frame: CGRect())
            self.setTitle("Privacy Policy", for: .normal)
            self.setTitleColor(UIColor.red, for: .normal)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
}
