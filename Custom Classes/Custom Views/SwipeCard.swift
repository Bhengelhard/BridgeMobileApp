//
//  SwipeCard.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 11/10/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class SwipeCard: UIView {
    
    var cardsUser1PhotoURL:String?
    var cardsUser2PhotoURL:String?
    var cardsUser1Photo: UIImage?
    var cardsUser2Photo: UIImage?
    var cardsUser1City: String?
    var cardsUser2City: String?
    var cardsPredictedType: String?
    let topHalf = HalfSwipeCard()
    let bottomHalf = HalfSwipeCard()
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience init () {
        self.init(frame: CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This is a fatal error message from CustomClasses/CustomViews/SwipeCard.swift")
    }
    
    func initialize(user1PhotoURL: String!, user1Name: String, user1Status: String, user1City: String?, user2PhotoURL: String!, user2Name: String, user2Status: String, user2City: String?, connectionType: String) {
        self.frame = swipeCardFrame()
        self.layer.cornerRadius = 13.379

        cardsPredictedType = connectionType
        
        topHalf.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 0.5*self.frame.height)
        topHalf.initialize(name: user1Name, status: user1Status, photoURL: user1PhotoURL, connectionType: connectionType)
        cardsUser1PhotoURL = user1PhotoURL
        
        //applying rounded corners to the topHalf
        let maskPath = UIBezierPath(roundedRect: topHalf.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 13.379, height: 13.379))
        let topHalfShape = CAShapeLayer()
        topHalfShape.path = maskPath.cgPath
        topHalf.layer.mask = topHalfShape
        
        bottomHalf.frame = CGRect(x: 0, y: 0.5*self.frame.height, width: self.frame.width, height: 0.5*self.frame.height)
        bottomHalf.initialize(name: user2Name, status: user2Status, photoURL: user2PhotoURL, connectionType: connectionType)
        cardsUser2PhotoURL = user2PhotoURL
        
        //applying rounded corners to the bottomHalf
        let maskPath2 = UIBezierPath(roundedRect: bottomHalf.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 13.379, height: 13.379))
        let bottomHalfShape = CAShapeLayer()
        bottomHalfShape.path = maskPath2.cgPath
        bottomHalf.layer.mask = bottomHalfShape
        
        self.addSubview(topHalf)
        self.addSubview(bottomHalf)
        
        var shadowLayer: CAShapeLayer!
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 13.379).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            
            shadowLayer.shadowColor = UIColor.lightGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.5, height: 2.0)
            shadowLayer.shadowOpacity = 0.8
            shadowLayer.shadowRadius = 2
            
            shadowLayer.shouldRasterize = false
            
            layer.insertSublayer(shadowLayer, below: nil)
        }
        
        //Setting the User's cities to inform suggestions for Reason for Connections
        
        if let city = user1City {
            cardsUser1City = city
        }
        if let city = user2City {
            cardsUser2City = city
        }
        
        
        
    }

    func swipeCardFrame () -> CGRect {
        return CGRect(x: 0.071*DisplayUtility.screenWidth, y: 0.1178*DisplayUtility.screenHeight, width: 0.8586*DisplayUtility.screenWidth, height: 0.8178*DisplayUtility.screenHeight)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
