//
//  PopupObjects.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 3/8/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class PopupViewObjects {
    class Title: UIImageView {
        init(titleImage: UIImage) {
            super.init(frame: CGRect())
            
            self.image = titleImage
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class Text: UILabel {
        init(text: String) {
            super.init(frame: CGRect())
            
            self.text = text
            self.textColor = UIColor.white
            self.textAlignment = NSTextAlignment.center
            self.numberOfLines = 0
            self.font = Constants.Fonts.light18
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class HexagonWithUserId: HexagonView {
        var userId: String?
        
        init(userId: String?) {
            if let id = userId {
                self.userId = id
            }
            super.init()
            
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.4
            self.layer.shadowOffset = .init(width: 1, height: 1)
            self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped(_:))))
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func tapped(_ gestureRecognizer: UITapGestureRecognizer) {
            if let hexagon = gestureRecognizer.view as? PopupViewObjects.HexagonWithUserId {
                if let userId = hexagon.userId {
                    // Notify EditProfileViewController to present the tappedTableCell
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "presentExternalProfileVC"), object: userId)
                }
            }
        }
        
    }
    
    class MessageButton: UIButton {
        let size = CGSize(width: 200, height: 40)
        
        init() {
            super.init(frame: CGRect())
            
            self.setTitle("MESSAGE BOTH", for: .normal)
            self.setTitleColor(UIColor.white, for: .normal)
            self.titleLabel?.font = Constants.Fonts.bold16
            self.backgroundColor = DisplayUtility.gradientColor(size: size)
            self.layer.cornerRadius = 18
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.4
            self.layer.shadowOffset = .init(width: 1, height: 1)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    class KeepSwipingButton: UIButton {
        let size = CGSize(width: 200, height: 40)
        
        init() {
            super.init(frame: CGRect())
            
            self.setTitle("KEEP SWIPING", for: .normal)
            self.setTitleColor(UIColor.white, for: .normal)
            self.titleLabel?.font = Constants.Fonts.bold16
            self.layer.borderColor = DisplayUtility.gradientColor(size: size).cgColor
            self.layer.borderWidth = 2
            self.layer.cornerRadius = 18
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.4
            self.layer.shadowOffset = .init(width: 1, height: 1)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class ConnectorImageButton: UIButton {
        
        init(image: UIImage) {
            super.init(frame: CGRect())
            
            self.setImage(image, for: .normal)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
