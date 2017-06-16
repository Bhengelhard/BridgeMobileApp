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

		clipsToBounds = true
        
        self.addSubview(topHalf)
        topHalf.autoPinEdge(toSuperviewEdge: .top)
        topHalf.autoPinEdge(toSuperviewEdge: .left)
        topHalf.autoPinEdge(toSuperviewEdge: .right)
        topHalf.autoMatch(.height, to: .height, of: self, withMultiplier: 0.5)
        
        self.addSubview(bottomHalf)
        bottomHalf.autoPinEdge(.top, to: .bottom, of: topHalf)
        bottomHalf.autoPinEdge(toSuperviewEdge: .left)
        bottomHalf.autoPinEdge(toSuperviewEdge: .right)
        bottomHalf.autoPinEdge(toSuperviewEdge: .bottom)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This is a fatal error message from CustomClasses/CustomViews/SwipeCard.swift")
    }
    
    func initialize(bridgePairing: BridgePairing) {
        if let id = bridgePairing.id {
            //print("initializing swipe card with bridgePairing id = \(id)")
        }
        
        self.bridgePairing = bridgePairing
        
        let swipCardCornerRadius: CGFloat = 12
        self.layer.cornerRadius = swipCardCornerRadius
        
        topHalf.initialize(name: bridgePairing.user1Name!)
        
        //applying rounded corners to the topHalf
        let maskPath = UIBezierPath(roundedRect: topHalf.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: swipCardCornerRadius, height: swipCardCornerRadius))
        let topHalfShape = CAShapeLayer()
        topHalfShape.path = maskPath.cgPath
        topHalf.layer.mask = topHalfShape
        
        bridgePairing.getUser1 { (user) in
            if let user = user {
                if let name = user.firstNameLastNameInitial {
                    self.topHalf.setName(name: name)
                }
                user.getMainPicture { (picture) in
                    picture.getImage { (image) in
                        self.topHalf.setImage(image: image)
                    }
                }
            }
        }
        
        //bottomHalf = HalfSwipeCard()
        //bottomHalf.frame = CGRect(x: 0, y: 0.5*self.frame.height, width: self.frame.width, height: 0.5*self.frame.height)
        bottomHalf.initialize(name: bridgePairing.user2Name!)
        
        //applying rounded corners to the bottomHalf
        let maskPath2 = UIBezierPath(roundedRect: bottomHalf.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: swipCardCornerRadius, height: swipCardCornerRadius))
        let bottomHalfShape = CAShapeLayer()
        bottomHalfShape.path = maskPath2.cgPath
        bottomHalf.layer.mask = bottomHalfShape
        
        bridgePairing.getUser2 { (user) in
            if let user = user {
                if let name = user.firstNameLastNameInitial {
                    self.bottomHalf.setName(name: name)
                }
                user.getMainPicture { (picture) in
                    picture.getImage { (image) in
                        self.bottomHalf.setImage(image: image)
                    }
                }
            }
        }
        
        //self.addSubview(topHalf)
        //self.addSubview(bottomHalf)
        
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
    
    func clear() {
        if let bridgePairing = bridgePairing {
            if let id = bridgePairing.id {
                print("clearing swipe card with bridgePairing id = \(id)")
            }
        } else {
            print("clearing swipe card")
        }
        bridgePairing = nil
        
        topHalf.setImage(image: nil)
        topHalf.photoView.removeFromSuperview()
        
        topHalf.setName(name: "")
        topHalf.nameLabel.removeFromSuperview()
        
        bottomHalf.setImage(image: nil)
        bottomHalf.photoView.removeFromSuperview()
        
        bottomHalf.setName(name: "")
        bottomHalf.nameLabel.removeFromSuperview()
    }
    
    // MARK: - Targets
    // Present External View Controller with ID of Top Half Card
    func topHalfCardtapped(_ gestureRecognizer: UITapGestureRecognizer) {
        print("top half card tapped")
        if let userID = bridgePairing?.user1ID {
            // Notify SwipeViewController to present the tapped User
            if let image = topHalf.photoView.image {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "presentExternalProfileVC"), object: (userID, image))
            } else {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "presentExternalProfileVC"), object: userID)
            }
        }
    }
    
    // Present External View Controller with ID of Bottom Half Card
    func bottomHalfCardtapped(_ gestureRecognizer: UITapGestureRecognizer) {
        print("bottom half card tapped")
        if let userID = bridgePairing?.user2ID {
            // Notify SwipeViewController to present the tapped User
            if let image = bottomHalf.photoView.image {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "presentExternalProfileVC"), object: (userID, image))
            } else {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "presentExternalProfileVC"), object: userID)
            }
        }
    }
}

