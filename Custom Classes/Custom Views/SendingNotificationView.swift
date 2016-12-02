//
//  SendingNotificationView.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 11/22/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class SendingNotificationView: UIView {
    
    let notificationLabel = UILabel()

    override init (frame: CGRect) {
        super.init(frame: frame)
        self.frame.size = CGSize(width: 0.5*DisplayUtility.screenWidth, height: 0.2*DisplayUtility.screenHeight)
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        let displayUtility = DisplayUtility()
        displayUtility.setBlurredView(viewToBlur: self)
        
    }
    
    convenience init () {
        self.init(frame: CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This is a fatal error message from CustomClasses/CustomViews/SwipeCard.swift")
    }
    
    func initialize(view: UIView, sendingText: String, successText: String) {
        self.center = view.center
        
        notificationLabel.frame = CGRect(x: 0.1*self.frame.width, y: 0.75*self.frame.height, width: 0.85*self.frame.width, height: 0.15*self.frame.height)
        notificationLabel.text = sendingText
        notificationLabel.textColor = UIColor.white
        notificationLabel.font = UIFont(name: "BentonSans-Light", size: 18)
        notificationLabel.textAlignment = NSTextAlignment.center
        self.addSubview(notificationLabel)
        
        addCircleView()
    }
    
    //add animated circle
    func addCircleView() {
        //let diceRoll = CGFloat(Int(arc4random_uniform(7))*50)
        let circleWidth = 0.4*self.frame.width
        let circleHeight = circleWidth
        
        // Create a new CircleView
        let circleView = CircleView(frame: CGRect(x: 0.5*(self.frame.width - circleWidth), y:  0.1*self.frame.height, width: circleWidth, height: circleHeight))
        self.addSubview(circleView)
        
        // Animate the drawing of the circle over the course of 1 second
        circleView.animateCircle(duration: 1.5, notificationView: self, notificationLabel: notificationLabel)
    }

}
