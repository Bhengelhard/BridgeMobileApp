//
//  SwipedRightView.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 3/8/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import PureLayout

class SwipedRightView: UIView {
    
    let title = PopupViewObjects.Title(titleImage: #imageLiteral(resourceName: "Sweet_Nect"))
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
            user1Hexagon = PopupViewObjects.HexagonWithImage(image: nil)
        }
        user1Hexagon.layer.masksToBounds = true
        
        // initialize user2Hexagon with user2Image
        if let image = user2Image {
            user2Hexagon = PopupViewObjects.HexagonWithImage(image: image)
        } else {
            user2Hexagon = PopupViewObjects.HexagonWithImage(image: nil)
        }
        user1Hexagon.clipsToBounds = true
        
        super.init(frame: CGRect())
        
        // MARK: - Add Targets
        keepSwipingButton.addTarget(self, action: #selector(keepSwipingTapped(_:)), for: .touchUpInside)
        messageButton.addTarget(self, action: #selector(messageButtonTapped(_:)), for: .touchUpInside)
        user1Hexagon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(user1HexagonTapped(_:))))
        user2Hexagon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(user2HexagonTapped(_:))))
        
        // MARK: - Layout objects
        // Set background
        let displayUtility = DisplayUtility()
        displayUtility.setBlurredView(viewToBlur: self)
        
        let buffer: CGFloat = 20
        let margin: CGFloat = 20
        
        // Layout title
        addSubview(title)
        title.autoPinEdge(toSuperviewEdge: .top, withInset: 3*buffer)
        title.autoMatch(.width, to: .height, of: title, withMultiplier: 6)
        title.autoPinEdge(toSuperviewEdge: .left, withInset: margin)
        title.autoPinEdge(toSuperviewEdge: .right, withInset: margin)
        
        // Layout text below title
        addSubview(text)
        text.autoPinEdge(.top, to: .bottom, of: title, withOffset: buffer)
        text.autoPinEdge(toSuperviewEdge: .left, withInset: 2*margin)
        text.autoPinEdge(toSuperviewEdge: .right, withInset: 2*margin)
        
        // Layout keepSwipingButton
        addSubview(keepSwipingButton)
        keepSwipingButton.autoSetDimensions(to: keepSwipingButton.size)
        keepSwipingButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 3*buffer)
        keepSwipingButton.autoAlignAxis(toSuperviewAxis: .vertical)
        
        // Layout messageButton
        addSubview(messageButton)
        messageButton.autoPinEdge(.bottom, to: .top, of: keepSwipingButton, withOffset: -buffer)
        messageButton.autoSetDimensions(to: messageButton.size)
        messageButton.autoAlignAxis(.vertical, toSameAxisOf: self)
        
        // Layout user1Hexagon
        let hexWToHRatio: CGFloat = 2 / sqrt(3)
        
        addSubview(user1Hexagon)
        user1Hexagon.autoPinEdge(.top, to: .bottom, of: text, withOffset: buffer)
        user1Hexagon.autoMatch(.width, to: .height, of: user1Hexagon, withMultiplier: hexWToHRatio)
        user1Hexagon.autoAlignAxis(.vertical, toSameAxisOf: self, withMultiplier: 0.6)
        user1Hexagon.autoPinEdge(toSuperviewEdge: .left, withInset: margin)
        
        let middleOfUser1Hexagon = UIView()
        addSubview(middleOfUser1Hexagon)
        middleOfUser1Hexagon.autoSetDimension(.height, toSize: 2)
        middleOfUser1Hexagon.autoAlignAxis(.horizontal, toSameAxisOf: user1Hexagon)

        // Layout user2Hexagon
        addSubview(user2Hexagon)
        user2Hexagon.autoMatch(.width, to: .width, of: user1Hexagon)
        user2Hexagon.autoMatch(.height, to: .height, of: user1Hexagon)
        user2Hexagon.autoPinEdge(.top, to: .bottom, of: middleOfUser1Hexagon)
        user2Hexagon.autoAlignAxis(.vertical, toSameAxisOf: self, withMultiplier: 1.4)
        user2Hexagon.autoPinEdge(.bottom, to: .top, of: messageButton, withOffset: -buffer)
        user2Hexagon.autoPinEdge(toSuperviewEdge: .right, withInset: margin)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Targets
    // Dismiss SwipeRightView
    func keepSwipingTapped (_ sender: UIButton) {
        UIView.animate(withDuration: 0.4, animations: {
            self.alpha = 0
        }) { (success) in
            self.removeConstraints(self.constraints)
            self.removeFromSuperview()
        }
    }
    
    // Create Direct Message with both of the users in the message
    func messageButtonTapped (_ sender: UIButton) {
        print("messageButtonTapped")
    }
    
    // Present user1's ExternalProfile
    func user1HexagonTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        print("user1HexagonTapped")
    }
    
    // Present user2's ExternalProfile
    func user2HexagonTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        print("user2HexagonTapped")
    }
}


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
    
    class HexagonWithImage: HexagonView {
        init(image: UIImage?) {
            super.init()
            
            if let image = image {
                self.setBackgroundImage(image: image)
            }
            else {
                self.setBackgroundColor(color: Constants.Colors.necter.buttonGray)
            }
            
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.4
            self.layer.shadowOffset = .init(width: 1, height: 1)
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
