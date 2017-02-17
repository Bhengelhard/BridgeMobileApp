//
//  AccessBackgroundView.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/14/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import PureLayout

///  The AccessVC Objects class defines a class nested with object classes initializing the objects displayed in LoginViewController
class LoginUI {
    
    // MARK: References to Objects
    let fbLoginButton = FBLoginButton()
    let seeMoreButton = SeeMoreButton()
    
    
    // MARK: - Layout
    /// Sets the initial layout constraints
    func initialize(view: UIView, didSetupConstraints: Bool) -> Bool {
        
        if (!didSetupConstraints) {
            
            // Layout the fbLoginButton below the tutorialPageController to the bottom with 80pt inset and dimensions of 300x40
            view.addSubview(fbLoginButton)
            fbLoginButton.autoSetDimensions(to: CGSize(width: 300, height: 40))
            fbLoginButton.autoAlignAxis(toSuperviewAxis: .vertical)
            //fbLoginButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 80)
            
            // Layout Objects Pinned to the Bottom
            
            // Layout the seemMoreButton pinned just above the bottom of the ViewController
            view.addSubview(seeMoreButton)
            seeMoreButton.autoSetDimensions(to: CGSize(width: 28, height: 9))
            seeMoreButton.autoAlignAxis(.vertical, toSameAxisOf: view)
            seeMoreButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 26)
            
            // Layout the loginInformationLabel just above the seeMoreButton
        }
        
        return true
    }
    
    
    // MARK: - Object Classes
    /// Displays four tutorial pages as a page view controller
    class TutorialPageController: UIPageViewController {
        
        /// Displays the title of the tutorial view
        class TitleLabel : UILabel {
            
        }
        
        /// Displays the image in the tutorial view
        class AppImageView : UIImageView {
            
        }
        
        /// Displays the page control circles
        class PageControl : UIPageControl {
            
        }
    }
    
    class FBLoginButton: UIButton  {
        
        init() {
            super.init(frame: CGRect())
            
            self.setTitle("LOGIN WITH FACEBOOK", for: .normal)
            self.setTitleColor(UIColor.white, for: .normal)
            self.setTitleColor(DisplayUtility.gradientColor(size: (self.titleLabel?.frame.size)!), for: .highlighted)
            self.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 16)
            self.backgroundColor = UIColor(red: 66.0/255.0, green: 103.0/255.0, blue: 178.0/255.0, alpha: 1)
            self.layer.cornerRadius = 8
            self.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)

        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func tapped(_ sender: FBLoginButton) {
            print("LoginVCFBLoginButton")
        }
    }
    
    /// Displays label letting user know about privacy information and the necter terms of service
    class LoginInformationLabel : UILabel {
        
        
    }
    
    /// Allows the user to login to Facebook
    class SeeMoreButton: UIButton  {
        
        init() {
            super.init(frame: CGRect())
            self.setImage(#imageLiteral(resourceName: "Black_X"), for: .normal)
            self.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        /// Segues to PrivacyInformationViewController to show more information about privacy while using the application
        func tapped (_ sender: UIButton) {
            print("SeeMoreButton tapped")
        }
    }
    
}






