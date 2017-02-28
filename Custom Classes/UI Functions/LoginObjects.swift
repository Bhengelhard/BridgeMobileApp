//
//  LoginVCLayout.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/15/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit

///  The LoginObjects class defines a class nested with object classes of the objects displayed in LoginViewController
class LoginObjects {
    
    // MARK: - Object Classes
    /// TutorialsView is a UIView that displays a swipable set of tutorial pages
    class TutorialsView: UIView {
        
        init() {
            super.init(frame: CGRect())
            
            self.backgroundColor = UIColor.red
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    class TutorialsPageViewController: ReusableObjects.NecterPageViewController {
        
        let initialVC = TutorialViewController(color: UIColor.red)
        let swipeRightVC = TutorialViewController(color: UIColor.blue)
        let swipeLeftVC = TutorialViewController(color: UIColor.green)
        let chatVC = TutorialViewController(color: UIColor.orange)
        
        init() {
            super.init(arrayOfVCs: [initialVC, swipeRightVC, swipeLeftVC, chatVC])
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    class TutorialViewController: UIViewController {
        
        init(color: UIColor) {
            super.init(nibName: nil, bundle: nil)
            
            self.view.backgroundColor = color
            
            
            
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
    
    /// Displays label letting user know about privacy information and the necter terms of service
    class LoginInformationLabel : UILabel {
        
        init() {
            super.init(frame: CGRect())
            self.text = "No need to get sour! We don't post to Facebook.\nBy signing in, you agree to our Terms of Service"
            self.numberOfLines = 2
            self.textAlignment = NSTextAlignment.center
            self.font = Constants.Fonts.light14
            //UIFont(name: Constants.Fonts.bentonSansLight, size: 12)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    /// SeeMoreButton is a UIButton that segues to more detailed privacy information in the PrivacyPolicyViewController
    class SeeMoreButton: UIButton  {
        
        init() {
            super.init(frame: CGRect())
            self.setImage(#imageLiteral(resourceName: "Black_X"), for: .normal)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }

}
