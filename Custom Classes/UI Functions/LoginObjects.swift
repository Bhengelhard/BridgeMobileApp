//
//  LoginVCLayout.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/15/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import PureLayout

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
        
        let initialVC = TutorialViewController(image: #imageLiteral(resourceName: "Initial_Tutorial"), text: "Introduce friends that go well together.")
        let swipeRightVC = TutorialViewController(image: #imageLiteral(resourceName: "Swipe_Right_Tutorial"), text: "Swipe right to introduce.")
        let swipeLeftVC = TutorialViewController(image: #imageLiteral(resourceName: "Swipe_Left_Tutorial"), text: "Swipe left to see the next pair.")
        let chatVC = TutorialViewController(image: #imageLiteral(resourceName: "Chat_Tutorial"), text: "Get to know the people your introduced to")
        
        init() {
            super.init(arrayOfVCs: [initialVC, swipeRightVC, swipeLeftVC, chatVC], startingIndex: 0)
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    class TutorialViewController: UIViewController {
        let imageView = UIImageView.newAutoLayout()
        let label = UILabel.newAutoLayout()
        
        init(image: UIImage, text: String) {
            super.init(nibName: nil, bundle: nil)
            
            view.backgroundColor = UIColor.white
            
            // initializing the title label
            label.text = text
            label.font = Constants.Fonts.bold24
            label.textColor = UIColor.lightGray
            label.numberOfLines = 2
            label.textAlignment = NSTextAlignment.center
            
            view.addSubview(label)
            label.autoPinEdge(toSuperviewEdge: .top, withInset: 40)
            label.autoPinEdge(.left, to: .left, of: view, withOffset: 20)
            label.autoPinEdge(.right, to: .right, of: view, withOffset: -20)
            label.autoSetDimension(.height, toSize: 48)
            
            // initializing the imageView
            imageView.image = image
            view.insertSubview(imageView, belowSubview: label)
            imageView.autoAlignAxis(.vertical, toSameAxisOf: view)
            imageView.autoPinEdge(.bottom, to: .bottom, of: view, withOffset: -30)
            imageView.autoPinEdge(.top, to: .bottom, of: label, withOffset: 20)
            imageView.autoMatch(.width, to: .height, of: imageView, withMultiplier: 0.9)

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
            self.titleLabel?.font = Constants.Fonts.bold16
            self.backgroundColor = UIColor(red: 66.0/255.0, green: 103.0/255.0, blue: 178.0/255.0, alpha: 1)
            self.layer.cornerRadius = 12
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    /// Displays label letting user know about privacy information and the necter terms of service
    class LoginInformationLabel : UILabel {
        
        init() {
            super.init(frame: CGRect())
            self.text = "No need to get sour! We don't post to Facebook.\nBy signing in, you agree to our Terms of Service."
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
            self.setImage(#imageLiteral(resourceName: "Carrot_Down"), for: .normal)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    /// Transgradient view is a colored asset that displays at the bottom of the LoginViewController
    class TransgradientView: UIImageView {
        
        init() {
            super.init(frame: CGRect())
            self.image = #imageLiteral(resourceName: "Transgradient_View")
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }

}
