//
//  SwipeLogic.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 2/27/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit
import MBProgressHUD
import Firebase

class SwipeLogic {
    
    private static var vc: SwipeViewController?
    private static var originalLocation = CGPoint()

    
    static func swipe(gesture: UIPanGestureRecognizer, layout: SwipeLayout, vc: SwipeViewController, bottomSwipeCard: SwipeCard, connectIcon: UIImageView, disconnectIcon: UIImageView, reset: @escaping () -> Void) {
        
        self.vc = vc
        
        let view = vc.view!
        
        
//        let translation = gesture.translation(in: view)
//        let swipeCard = gesture.view as! SwipeCard
//        layout.updateTopSwipeCardHorizontalConstraint(translation: translation.x)
        
        let swipeCard = gesture.view as! SwipeCard
        
        //let scale = min(CGFloat(1.0), 1)
        //var rotation = CGAffineTransform(rotationAngle: -xFromCenter / 1000)
        //var rotation = CGAffineTransform(rotationAngle: translation.x / 1000)
        //var stretch = rotation.scaledBy(x: scale, y: scale)
        //swipeCard.transform = stretch
        
        //animating connect and disconnect icons when card is positioned from 0.4% of DisplayUtility.screenWidth to border
        if swipeCard.center.x < 0.4*DisplayUtility.screenWidth {
            //fading in with swipe left from 0.4% of DisplayUtility.screenWidth to border
            disconnectIcon.alpha = -2.5*(swipeCard.center.x/DisplayUtility.screenWidth)+1
            
        } else if swipeCard.center.x > 0.6*DisplayUtility.screenWidth {
            //fading in with swipe left from 0.6% of DisplayUtility.screenWidth to border
            connectIcon.alpha = 2.5*(swipeCard.center.x/DisplayUtility.screenWidth)-1.5
            
        } else {
            disconnectIcon.alpha = 0
            connectIcon.alpha = 0
            
        }
        
        var location = CGPoint()
        
        if gesture.state == .began {
            originalLocation = gesture.location(in: view)
        }
        
        if gesture.state == .changed {
            location = gesture.location(in: view)
            layout.updateTopSwipeCardHorizontalConstraint(fromCenter: location.x - originalLocation.x)
            
            let transform = CGAffineTransform.identity// swipeCard.transform
            //swipeCard.transform = transform.rotated(by: CGFloat(location.x - DisplayUtility.screenWidth/2)/(DisplayUtility.screenWidth/2) * CGFloat(M_PI/8))
            
           // let multiplier = CGFloat(0.98)
            let cardCenterX = swipeCard.center.x
            let screenMiddleX = DisplayUtility.screenWidth / 2
            let direction: CGFloat = cardCenterX <= screenMiddleX ? screenMiddleX - cardCenterX : cardCenterX - screenMiddleX
            
//            let percent: CGFloat = min(max(0.05 * (direction / screenMiddleX) + multiplier, multiplier), 1.0)
//            let maxFrame = swipeCard.swipeCardFrame()
//            let inset = CGSize(width: maxFrame.width * percent,
//                               height: maxFrame.height * percent)
//            let differential = CGSize(width: maxFrame.size.width - inset.width,
//                                      height: maxFrame.size.height - inset.height)
            /*
            bottomSwipeCard.frame = CGRect(origin: CGPoint(x: max(maxFrame.origin.x + differential.width, maxFrame.origin.x),
                                                           y: max(maxFrame.origin.y + differential.height, maxFrame.origin.y)),
                                           size: CGSize(width: min(abs(maxFrame.width - (inset.width * 2)), maxFrame.width),
                                                        height: min(abs(maxFrame.height - (inset.height * 2)), maxFrame.height)))*/
            
            let overlayMultiplier = CGFloat(bottomSwipeCard.defaultOverlayOpacity)
            var overlayPercent: CGFloat = 2.0 * (direction / screenMiddleX) - overlayMultiplier
            
            if overlayPercent < 0 {
                overlayPercent = abs(overlayPercent)
                
                bottomSwipeCard.overlay.opacity = Float(overlayPercent)
            }
        }
        if gesture.state == .ended {
            // Remove Icons
            disconnectIcon.alpha = 0.0
            connectIcon.alpha = 0.0
            
            //User Swiped Left
            if swipeCard.center.x < 0.25*DisplayUtility.screenWidth {
                // If this is the user's first time swiping left then display pop-up
                let localData = LocalData()
                let isFirstTimeSwipedLeft : Bool = localData.getFirstTimeSwipingLeft() ?? false
                if isFirstTimeSwipedLeft {
                    //show alert for swiping right here and then bridging or not
                    let alert = UIAlertController(title: "Don't Connect?", message: "Dragging a pair of pictures to the left indicates you do not want to introduce the friends shown.", preferredStyle: UIAlertControllerStyle.alert)
                    //Create the actions
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                        reset()
                    }))
                    alert.addAction(UIAlertAction(title: "Don't Connect", style: .default, handler: { (action) in
                        SwipeLogic.didSwipe(right: false, vc: vc)                        
                    }))
                    vc.present(alert, animated: true, completion: nil)
                    
                    localData.setFirstTimeSwipingLeft(false)
                    localData.synchronize()
                } else {
                    SwipeLogic.didSwipe(right: false, vc: vc)
                }
            }
            // User Swiped Right
            else if swipeCard.center.x > 0.75*DisplayUtility.screenWidth {
                
                SwipeLogic.didSwipe(right: true, vc: vc)
            }
            // Reset the cards
            else {
                //swipeCard.transform = CGAffineTransform.identity
                reset()
            }
        }
    }
    
    // Animate swiping and replace
    static func didSwipe(right: Bool, vc: SwipeViewController) {
        
        // Logging swiping right and left as events
        let title: String
        if right {
            title = "swipeRight"
        } else {
            title = "swipeLeft"
        }
        
        User.getCurrent { (user) in
            if let userObjectID = user?.id {
                AnalyticsLogs.swiped(title: title, userObjectID: userObjectID)
            }
        }
        
        
        let view = vc.view!
        let swipeBackend = vc.swipeBackend
        let layout = vc.layout
        
        
        let swipeCard = layout.topSwipeCard
        
        // create and save swipe
        var bridgePairingID: String?
        if let bridgePairing = swipeCard.bridgePairing {
            bridgePairingID = bridgePairing.id
        }
        User.getCurrent { (user) in
            if let user = user {
                Swipe.create(bridgePairingID: bridgePairingID, swiperID: user.id, swipedRight: right) { (swipe) in
                    swipe.save()
                }
            }
        }
        
        UIView.animate(withDuration: 0.4, animations: {
            
            // if swiped left, check in bridge pairing and animate left swipe
            if right {
                layout.updateTopSwipeCardHorizontalConstraint(fromCenter: (view.frame.width/2 + swipeCard.frame.width/2))
            }
            // if swiped right, animate card swiped right
            else {
                layout.updateTopSwipeCardHorizontalConstraint(fromCenter: -(view.frame.width/2 + swipeCard.frame.width/2))
            }
            view.layoutIfNeeded()
        }, completion: { (success) in
            
            if right {
                if let bridgePairing = swipeCard.bridgePairing {
                    
                    if let user1ID = bridgePairing.user1ID {
                        print("got user1ID")
                        // Layout swipeRightView full screen with user's images and ids for presenting ExternalProfiles if clicked
                        let user1Image = swipeCard.topHalf.photoView.image
                        let user2Image = swipeCard.bottomHalf.photoView.image
                        if let user2ID = bridgePairing.user2ID {
                            print("got user2ID")
                            // Initialize and display swipeRightView
                            let swipeRightView = PopupView(includesCurrentUser: false, user1Id: user1ID, user2Id: user2ID, textString: "We'll let you know when they start a conversation!", titleImage: #imageLiteral(resourceName: "Sweet_Nect"), user1Image: user1Image, user2Image: user2Image)
                            swipeRightView.alpha = 0
                            vc.view.addSubview(swipeRightView)
                            swipeRightView.autoPinEdgesToSuperviewEdges()
                            swipeRightView.layoutIfNeeded()
                            
                            UIView.animate(withDuration: 0.4, animations: {
                                swipeRightView.alpha = 1
                            })
                            
                            if let user1Name = bridgePairing.user1Name, let user2Name = bridgePairing.user2Name {
                                var connecterID = ""
                                var connecterName = ""
                                User.getCurrent(withBlock: { (user) in
                                    if let user = user {
                                        
                                        // set bridged to true
                                        bridgePairing.bridged = true
                                        
                                        if let id = user.id {
                                            connecterID = id
                                            bridgePairing.connecterID = id
                                        }
                                        
                                        if let name = user.name {
                                            connecterName = name
                                            bridgePairing.connecterName = name
                                        }
                                        
                                        bridgePairing.save()
                                       
                                    }
                                })
                                
                                let user1PictureID = bridgePairing.user1PictureID
                                let user2PictureID = bridgePairing.user2PictureID
                                
                                // Create message with both of the retrieved users
                                Message.create(user1ID: user1ID, user2ID: user2ID, connecterID: connecterID, user1Name: user1Name, user2Name: user2Name, user1PictureID: user1PictureID, user2PictureID: user2PictureID, lastSingleMessage: nil, user1HasSeenLastSingleMessage: nil, user2HasSeenLastSingleMessage: nil, user1HasPosted: nil, user2HasPosted: nil, withBlock: { (message, isNew) in
                                    if isNew {
                                        message.save(withBlock: { (message) in
                                            if let messageID = message.id {
                                                // Set messageID for SwipeRightView's message both button
                                                swipeRightView.setMessageID(messageID: messageID)
                                                
                                                //Send notification that user's have been 'nected
                                                sendNectedNotification(user1ID: user1ID, user2ID: user2ID, user1Name: user1Name, user2Name: user2Name, connecterName: connecterName, messageID: messageID)
                                                
                                            }
                                        })
                                    } else {
                                        if let messageID = message.id {
                                            // Set messageID for SwipeRightView's message both button
                                            swipeRightView.setMessageID(messageID: messageID)
                                            
                                            //Send notification that user's have been 'nected
                                            sendNectedNotification(user1ID: user1ID, user2ID: user2ID, user1Name: user1Name, user2Name: user2Name, connecterName: connecterName, messageID: messageID)
                                            
                                        }
                                    }
                                    
                                })
                            }
                        }
                    }
                }
                
            }
            // Swiped Left
            else {
                // Only check back in if user swiped left
                if let bridgePairing = swipeCard.bridgePairing {
                    swipeBackend.checkIn(bridgePairing: bridgePairing)
                }
            }
            
            layout.switchTopAndBottomCards()
            
            swipeBackend.swiped(topSwipepCard: layout.topSwipeCard, bottomSwipeCard: layout.bottomSwipeCard, limitMet: vc.limitMet, noMoreBridgePairings: vc.noMoreBridgePairings, noBridgePairings: vc.noBridgePairings) {
                //MBProgressHUD.hide(for: vc.view, animated: true)
            }
        })
    }
    
    private static func smallestSwipeCardFrame(swipeCard: SwipeCard) -> CGRect {
        let maxFrame = swipeCard.swipeCardFrame()
        let percent = CGFloat(0.98)
        let inset = CGSize(width: maxFrame.size.width * percent,
                           height: maxFrame.size.height * percent)
        
        return CGRect(x: maxFrame.origin.x + inset.width,
                      y: maxFrame.origin.y + inset.height,
                      width: maxFrame.size.width - (inset.width * 2),
                      height: maxFrame.size.height - (inset.height * 2))
    }
    
    // Send Push Notifications to Users to let them know they've been connected
    private static func sendNectedNotification(user1ID: String, user2ID: String, user1Name: String, user2Name: String, connecterName: String, messageID: String) {
        
        if !connecterName.isEmpty {
            PFCloudFunctions.pushNotification(parameters: ["userObjectId": user1ID,"alert":"\(connecterName) 'nected you with \(user2Name)! Get the conversation started!", "badge": "Increment",  "messageType" : "SingleMessage",  "messageId": messageID])
            PFCloudFunctions.pushNotification(parameters: ["userObjectId": user2ID,"alert":"\(connecterName) 'nected you with \(user1Name)! Get the conversation started!", "badge": "Increment",  "messageType" : "SingleMessage",  "messageId": messageID])
        } else {
            PFCloudFunctions.pushNotification(parameters: ["userObjectId": user1ID,"alert":"You were 'nected with \(user2Name)! Get the conversation started!", "badge": "Increment",  "messageType" : "SingleMessage",  "messageId": messageID])
            PFCloudFunctions.pushNotification(parameters: ["userObjectId": user2ID,"alert":"You were 'nected with \(user1Name)! Get the conversation started!", "badge": "Increment",  "messageType" : "SingleMessage",  "messageId": messageID])
        }
    }
}
