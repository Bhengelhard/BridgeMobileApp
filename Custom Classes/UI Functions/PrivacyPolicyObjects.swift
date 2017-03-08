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
            self.setImage(#imageLiteral(resourceName: "Carrot_Up"), for: .normal)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
                
    }
    
    /// FBLoginButton is UIButton allowing user to log into the necter app using Facebook authentication
    class FBLoginButton: ReusableObjects.FBLoginButton  {
        
    }
    
    /// Header is a UILabel that displays a statement about our privacy policy
    class Header: UILabel {
        
        init() {
            super.init(frame: CGRect())
            self.text = "We're serious about privacy"
            self.font = Constants.Fonts.bold24
            self.textColor = Constants.Colors.necter.textGray
            self.textAlignment = NSTextAlignment.center
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
            self.font = Constants.Fonts.light18
            self.textColor = Constants.Colors.necter.textGray
            self.textAlignment = NSTextAlignment.center
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        
    }
    
    /// PrivacyPolicyButton is a UIButton that allows the user to view the necter privacy policy from a web pop-up within the app
    class PrivacyPolicyButton: UIButton {
        
        let webView = UIWebView()
        
        init() {
            super.init(frame: CGRect())
            self.setTitle("Privacy Policy", for: .normal)
            self.setTitleColor(UIColor.red, for: .normal)
            self.titleLabel?.font = Constants.Fonts.bold16
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
}
