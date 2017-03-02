//
//  SwipeCard.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 11/10/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class SwipeCard: UIView {
    
    var cardsUser1Id: String?
    var cardsUser2Id: String?
    var cardsUser1PhotoURL: String?
    var cardsUser2PhotoURL: String?
    var cardsUser1City: String?
    var cardsUser2City: String?
    var cardsPredictedType: String?
    let topHalf = HalfSwipeCard()
    let bottomHalf = HalfSwipeCard()
	var overlay = CALayer()
	let defaultOverlayOpacity: Float = 0.75
    
    init () {
        super.init(frame: CGRect())

        self.frame = swipeCardFrame()
		self.clipsToBounds = true
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This is a fatal error message from CustomClasses/CustomViews/SwipeCard.swift")
    }
    
    func initialize(bridgePairing: BridgePairing) {
        let swipCardCornerRadius: CGFloat = 9//13.379
        self.layer.cornerRadius = swipCardCornerRadius
        
        cardsPredictedType = "Business"
        
        topHalf.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 0.5*self.frame.height)
        topHalf.initialize(name: bridgePairing.user1Name!, status: "", photoURL: "", connectionType: "Business")
        bridgePairing.getUser1Picture { (picture) in
            if let image = picture.image {
                self.topHalf.setImage(image: image)
            }
        }
        
        //applying rounded corners to the topHalf
        let maskPath = UIBezierPath(roundedRect: topHalf.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: swipCardCornerRadius, height: swipCardCornerRadius))
        let topHalfShape = CAShapeLayer()
        topHalfShape.path = maskPath.cgPath
        topHalf.layer.mask = topHalfShape
        
        bottomHalf.frame = CGRect(x: 0, y: 0.5*self.frame.height, width: self.frame.width, height: 0.5*self.frame.height)
        bottomHalf.initialize(name: bridgePairing.user2Name!, status: "", photoURL: "", connectionType: "Business")
        bridgePairing.getUser2Picture { (picture) in
            if let image = picture.image {
                self.bottomHalf.setImage(image: image)
            }
        }
        
        //applying rounded corners to the bottomHalf
        let maskPath2 = UIBezierPath(roundedRect: bottomHalf.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: swipCardCornerRadius, height: swipCardCornerRadius))
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
        
        //Setting the user's ids
        cardsUser1Id = bridgePairing.user1ID!
        cardsUser2Id = bridgePairing.user2ID!
        
        //Setting the User's cities to inform suggestions for Reason for Connections
        
//        if let city = user1City {
//            cardsUser1City = city
//        }
//        if let city = user2City {
//            cardsUser2City = city
//        }
        
        overlay.frame = self.layer.frame
        overlay.frame.origin = CGPoint(x: 0, y: 0)
        overlay.backgroundColor = UIColor.black.cgColor
        overlay.opacity = defaultOverlayOpacity
        
        layer.insertSublayer(overlay, at: UInt32.max)
        
    }
    
    func swipeCardFrame () -> CGRect {
        //Width is half of height to keep photos as squares
        let originY = 0.12*DisplayUtility.screenHeight
        let height = 0.98*DisplayUtility.screenHeight - originY
        let width = 0.9*DisplayUtility.screenWidth
        let originX = (DisplayUtility.screenWidth - width) / 2
        
        
        return CGRect(x: originX, y: originY, width: width, height: height)
    }

}
