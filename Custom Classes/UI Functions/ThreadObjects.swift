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
        
        let nectedByLabel = UILabel()
        
        init() {
            super.init(frame: CGRect())
            
            // Initialization
            nectedByLabel.font = Constants.Fonts.bold16
            nectedByLabel.textColor = Constants.Colors.necter.textGray
            nectedByLabel.numberOfLines = 0
            nectedByLabel.textAlignment = NSTextAlignment.center
            nectedByLabel.alpha = 0
                        
            let label = UILabel()
            label.text = "\"All of life is rooted in relationships\"\n\n-Lee A. Harris"
            label.textColor = Constants.Colors.necter.textGray
            label.font = Constants.Fonts.bold24
            label.numberOfLines = 0
            label.textAlignment = NSTextAlignment.center
            
            // Layout
            addSubview(label)
            label.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            label.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
            label.autoAlignAxis(toSuperviewAxis: .vertical)
            label.autoAlignAxis(.horizontal, toSameAxisOf: self, withOffset: 120)
            
            addSubview(nectedByLabel)
            nectedByLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            nectedByLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
            nectedByLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 40)
            //nectedByLabel.autoPinEdge(.bottom, to: .top, of: label, withOffset: -20)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setNectedByLabel(messageID: String?) {
            // Displaying connecter info
            if let id = messageID {
                Message.get(withID: id) { (message) in
                    if let id = message.connecterID {
                        User.get(withID: id, withBlock: { (user) in
                            if let name = user.name {
                                self.nectedByLabel.text = "You were 'nected by \(name)."
                                self.nectedByLabel.alpha = 1
                            }
                        })
                    }
                }
            }
        }
    }
}
