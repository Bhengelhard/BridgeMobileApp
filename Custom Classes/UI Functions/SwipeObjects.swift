//
//  SwipeObjects.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/17/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SwipeObjects {
    
    class NavBar: NecterNavigationBar {
        
        override init() {
            super.init()
            
            // Setting Navigation Items
            let rightIcon = #imageLiteral(resourceName: "Messages_Navbar_Inactive")
            rightButton.setImage(rightIcon, for: .normal)
            
            let leftIcon = #imageLiteral(resourceName: "Profile_Navbar_Inactive")
            leftButton.setImage(leftIcon, for: .normal)
            
            let titleImage = #imageLiteral(resourceName: "Necter_Navbar_Active")
            //titleImageView.image = titleImage
            setTitleImage(image: titleImage)
            //navItem.titleView = titleImageView
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class DecisionButton: UIButton {
        
        let size = CGSize(width: 160, height: 40)
        
        init(text: String) {
            super.init(frame: CGRect())
            self.setTitle(text, for: .normal)
            self.setTitleColor(UIColor.white, for: .normal)
            self.titleLabel?.font = Constants.Fonts.bold24
            self.contentVerticalAlignment = UIControlContentVerticalAlignment.bottom
            self.layer.cornerRadius = 15
            
            if text == "NECT" {
                self.backgroundColor = DisplayUtility.gradientColor(size: self.size)
            } else {
                self.backgroundColor = Constants.Colors.necter.buttonGray
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class InfoButton: UIButton {
        
        init() {
            super.init(frame: CGRect())
            
            self.setImage(#imageLiteral(resourceName: "Information_Icon"), for: .normal)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class NoMoreBridgePairingsLabel: UILabel {
        init() {
            super.init(frame: CGRect())
            
            text = "You have no more pairs to NECT. Please check back tomorrow"
            textColor = Constants.Colors.necter.textGray
            textAlignment = .center
            font = UIFont(name: "BentonSans-Bold", size: 22)
            numberOfLines = 0
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class OrLabel: UILabel {
        init() {
            super.init(frame: CGRect())
            
            text = "or"
            textColor = Constants.Colors.necter.textGray
            textAlignment = .center
            font = UIFont(name: "BentonSans-Bold", size: 22)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    /*
    var attrs = [
        NSFontAttributeName : UIFont.systemFontOfSize(19.0),
        NSForegroundColorAttributeName : UIColor.redColor(),
        NSUnderlineStyleAttributeName : 1]
    
    var attributedString = NSMutableAttributedString(string:"")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttonTitleStr = NSMutableAttributedString(string:"My Button", attributes:attrs)
        attributedString.appendAttributedString(buttonTitleStr)
        yourButton.setAttributedTitle(attributedString, forState: .Normal)
    }
*/
    
    class RefreshButton: UIButton {
        init() {
            super.init(frame: CGRect())
            
            let attributes: [String: Any] = [
                NSFontAttributeName: Constants.Fonts.light18 ?? UIFont(),
                NSForegroundColorAttributeName: Constants.Colors.necter.yellow,
                NSUnderlineStyleAttributeName: 1]
            let attributedString = NSAttributedString(string: "check for more pairs", attributes: attributes)
            
            setAttributedTitle(attributedString, for: .normal)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class LoadingBridgePairingsView: UIView {
        let activityIndicatorView: NVActivityIndicatorView
        
        init() {
            activityIndicatorView = NVActivityIndicatorView(frame: CGRect(), type: .ballZigZag, color: Constants.Colors.necter.yellow, padding: 0)
            super.init(frame: CGRect(x: 0, y: 0, width: 37, height: 37))
            activityIndicatorView.frame = self.frame
            addSubview(activityIndicatorView)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override var intrinsicContentSize: CGSize {
            return CGSize(width: 37, height: 37)
        }
        
        func startAnimating() {
            activityIndicatorView.startAnimating()
        }
        
        func stopAnimating() {
            activityIndicatorView.stopAnimating()
        }
    }
    
}
