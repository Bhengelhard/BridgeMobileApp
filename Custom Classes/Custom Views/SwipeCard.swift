//
//  SwipeCard.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 11/10/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import PureLayout

class SwipeCard: UIView {
    
    var cardsUser1Id: String?
    var cardsUser2Id: String?
    var cardsUser1PhotoURL: String?
    var cardsUser2PhotoURL: String?
    var cardsUser1City: String?
    var cardsUser2City: String?
    var cardsPredictedType: String?
    var topHalf = HalfSwipeCard()
    var bottomHalf = HalfSwipeCard()
	var overlay = CALayer()
	let defaultOverlayOpacity: Float = 0.75
    var bridgePairing: BridgePairing?
    
    init () {
        super.init(frame: CGRect())

        self.frame = swipeCardFrame()
		self.clipsToBounds = true
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This is a fatal error message from CustomClasses/CustomViews/SwipeCard.swift")
    }
    
    func initialize(bridgePairing: BridgePairing) {
        self.bridgePairing = bridgePairing
        
        let swipCardCornerRadius: CGFloat = 12
        self.layer.cornerRadius = swipCardCornerRadius
        
        topHalf = HalfSwipeCard()
        topHalf.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 0.5*self.frame.height)
        topHalf.initialize(name: bridgePairing.user1Name!)
        
        //applying rounded corners to the topHalf
        let maskPath = UIBezierPath(roundedRect: topHalf.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: swipCardCornerRadius, height: swipCardCornerRadius))
        let topHalfShape = CAShapeLayer()
        topHalfShape.path = maskPath.cgPath
        topHalf.layer.mask = topHalfShape
        
        bridgePairing.getUser1 { (user) in
            if let name = user.name {
                self.topHalf.setName(name: name)
            }
            user.getMainPicture { (picture) in
                picture.getImage { (image) in
                    self.topHalf.setImage(image: image)
                }
            }
        }
        
        bottomHalf = HalfSwipeCard()
        bottomHalf.frame = CGRect(x: 0, y: 0.5*self.frame.height, width: self.frame.width, height: 0.5*self.frame.height)
        bottomHalf.initialize(name: bridgePairing.user2Name!)
        
        //applying rounded corners to the bottomHalf
        let maskPath2 = UIBezierPath(roundedRect: bottomHalf.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: swipCardCornerRadius, height: swipCardCornerRadius))
        let bottomHalfShape = CAShapeLayer()
        bottomHalfShape.path = maskPath2.cgPath
        bottomHalf.layer.mask = bottomHalfShape
        
        bridgePairing.getUser2 { (user) in
            if let name = user.name {
                self.bottomHalf.setName(name: name)
            }
            user.getMainPicture { (picture) in
                picture.getImage { (image) in
                    self.bottomHalf.setImage(image: image)
                }
            }
        }
        
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
            
            // Add Targets
            topHalf.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(topHalfCardtapped(_:))))
            bottomHalf.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(bottomHalfCardtapped(_:))))
            
        }
    }
    
    func addOverlay() {
        overlay.frame = self.layer.bounds
        //overlay.frame.origin = CGPoint(x: 0, y: 0)
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
    
    // MARK: - Targets
    // Present External View Controller with ID of Top Half Card
    func topHalfCardtapped(_ gestureRecognizer: UITapGestureRecognizer) {
        print("top half card tapped")
        if let userId = bridgePairing?.user1ID {
            // Notify SwipeViewController to present the tapped User
            NotificationCenter.default.post(name: Notification.Name(rawValue: "presentExternalProfileVC"), object: userId)
        }
    }
    
    // Present External View Controller with ID of Bottom Half Card
    func bottomHalfCardtapped(_ gestureRecognizer: UITapGestureRecognizer) {
        print("bottom half card tapped")
        if let userId = bridgePairing?.user2ID {
            // Notify SwipeViewController to present the tapped User
            NotificationCenter.default.post(name: Notification.Name(rawValue: "presentExternalProfileVC"), object: userId)
        }
    }
}
