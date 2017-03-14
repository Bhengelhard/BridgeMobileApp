//
//  PopupView.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 3/8/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import PureLayout

class PopupView: UIView {
    
    // MARK: - Global Variables
    let title: PopupViewObjects.Title
    let text: PopupViewObjects.Text
    let user1Hexagon: PopupViewObjects.HexagonWithUserId
    let user2Hexagon: PopupViewObjects.HexagonWithUserId
    var user1Image: UIImage?
    var user2Image: UIImage?
    let messageButton = PopupViewObjects.MessageButton()
    let keepSwipingButton = PopupViewObjects.KeepSwipingButton()
    
    // MARK: - Init
    init(user1Id: String, user2Id: String, textString: String, titleImage: UIImage, user1Image: UIImage?, user2Image: UIImage?) {
        self.title = PopupViewObjects.Title(titleImage: titleImage)
        self.text = PopupViewObjects.Text(text: textString)
        
        self.user1Hexagon = PopupViewObjects.HexagonWithUserId(userId: user1Id)
        self.user2Hexagon = PopupViewObjects.HexagonWithUserId(userId: user2Id)
        
        self.user1Image = user1Image
        self.user2Image = user2Image
        
        super.init(frame: CGRect())
        
        if user1Image == nil {
            User.get(withID: user1Id) { (user) in
                user.getMainPicture { (picture) in
                    picture.getImage { (image) in
                        self.user1Image = image
                        self.user1Hexagon.setBackgroundImage(image: image)

                    }
                }
            }
        }
        
        if user2Image == nil {
            print("id = user2Id")
            
            User.get(withID: user2Id) { (user) in
                print("user2 user retrived")
                print(user.name)
                
                user.getPicture(atIndex: 0, withBlock: { (picture) in
                    picture.getImage(withBlock: { (image) in
                        self.user2Image = image
                        self.user2Hexagon.setBackgroundImage(image: image)
                        print("got user2Image")
                    
                    })
                })
            }
        }
        
        
        // MARK: - Add Targets
        keepSwipingButton.addTarget(self, action: #selector(keepSwipingTapped(_:)), for: .touchUpInside)
        messageButton.addTarget(self, action: #selector(messageButtonTapped(_:)), for: .touchUpInside)
        
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let image = user1Image {
            user1Hexagon.setBackgroundImage(image: image)
        }
        
        if let image = user2Image {
            user2Hexagon.setBackgroundImage(image: image)
        }
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
    
    // MARK: - Functions
    func setHexagonImages(user1Image: UIImage?, user2Image: UIImage?) {
        // Set Hexagon Images
        if let image = user1Image {
            user1Hexagon.setBackgroundImage(image: image)
        }
        
        if let image = user2Image {
            user2Hexagon.setBackgroundImage(image: image)
        }
    }
}
