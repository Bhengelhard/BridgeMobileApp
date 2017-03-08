//
//  SwipedRightView.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 3/8/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class SwipedRightView: UIView {
    
    let title = PopupViewObjects.Title(text: "Sweet 'nect")
    let text = PopupViewObjects.Text(text: "We'll let you know when they start a conversation!")
    let user1Hexagon: PopupViewObjects.HexagonWithImage
    let user2Hexagon: PopupViewObjects.HexagonWithImage
    let messageButton = PopupViewObjects.MessageButton()
    let keepSwipingButton = PopupViewObjects.KeepSwipingButton()
    

    init(user1Image: UIImage?, user2Image: UIImage?) {
        // initialize user1Hexagon with user1Image
        if let image = user1Image {
            user1Hexagon = PopupViewObjects.HexagonWithImage(image: image)
        } else {
            user1Hexagon = PopupViewObjects.HexagonWithImage(image: UIImage())
        }
        
        // initialize user2Hexagon with user2Image
        if let image = user2Image {
            user2Hexagon = PopupViewObjects.HexagonWithImage(image: image)
        } else {
            user2Hexagon = PopupViewObjects.HexagonWithImage(image: UIImage())
        }
        
        super.init(frame: CGRect())
        
        // Set background
        let displayUtility = DisplayUtility()
        displayUtility.setBlurredView(viewToBlur: self)
        
        let buffer: CGFloat = 20
        let margin: CGFloat = 20
        
        // Layout title
        addSubview(title)
        title.autoPinEdge(toSuperviewEdge: .top, withInset: 2*buffer)
        title.autoPinEdge(toSuperviewEdge: .left, withInset: margin)
        title.autoPinEdge(toSuperviewEdge: .right, withInset: margin)
        
        // Layout text below title
        addSubview(text)
        text.autoPinEdge(.top, to: .bottom, of: title, withOffset: buffer)
        text.autoPinEdge(toSuperviewEdge: .left, withInset: 2*margin)
        text.autoPinEdge(toSuperviewEdge: .right, withInset: 2*margin)
        
        // Layout user1Hexagon
        addSubview(user1Hexagon)
        user1Hexagon.autoPinEdge(.top, to: .bottom, of: text, withOffset: buffer)
        user1Hexagon.autoPinEdge(toSuperviewEdge: .left, withInset: 2*margin)
        user1Hexagon.autoSetDimension(.height, toSize: 100)
        user1Hexagon.autoMatch(.width, to: .height, of: user1Hexagon)
        
        // Layout user2Hexagon
        addSubview(user2Hexagon)
        user2Hexagon.autoMatch(.width, to: .width, of: user1Hexagon)
        user2Hexagon.autoMatch(.height, to: .height, of: user1Hexagon)
        user2Hexagon.autoPinEdge(.left, to: .right, of: user1Hexagon, withOffset: 1)
        
        // Layout keepSwipingButton
        addSubview(keepSwipingButton)
        keepSwipingButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 40)
        keepSwipingButton.autoSetDimensions(to: keepSwipingButton.size)
        keepSwipingButton.autoAlignAxis(.vertical, toSameAxisOf: self)
        
        // Layout messageButton
        addSubview(messageButton)
        messageButton.autoPinEdge(.bottom, to: .top, of: keepSwipingButton, withOffset: buffer)
        messageButton.autoSetDimensions(to: messageButton.size)
        messageButton.autoAlignAxis(.vertical, toSameAxisOf: self)
        messageButton.autoPinEdge(.top, to: .bottom, of: user2Hexagon, withOffset: 2*buffer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


class PopupViewObjects {
    class Title: UILabel {
        init(text: String) {
            super.init(frame: CGRect())
            
            self.text = text
            self.textColor = UIColor.white
            self.textAlignment = NSTextAlignment.center
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
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class HexagonWithImage: HexagonView {
        init(image: UIImage) {
            super.init()
            
            self.backgroundColor = UIColor.red
            //self.hexBackgroundImage = image
            self.layer.borderColor = UIColor.white.cgColor
            self.layer.borderWidth = 1
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class MessageButton: UIButton {
        let size = CGSize(width: 200, height: 40)
        
        init() {
            super.init(frame: CGRect())
            
            self.setTitle("MESSAGE BOTH", for: .normal)
            self.setTitleColor(UIColor.white, for: .normal)
            self.backgroundColor = DisplayUtility.gradientColor(size: size)
            self.layer.cornerRadius = 12
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
            self.layer.borderColor = DisplayUtility.gradientColor(size: size).cgColor
            self.layer.borderWidth = 2
            self.layer.cornerRadius = 12
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
