//
//  SwipeLogic.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 2/27/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class SwipeLogic {
    
    private static var vc: SwipeViewController?
    
    static func swipe(gesture: UIPanGestureRecognizer, layout: SwipeLayout, vc: SwipeViewController, bottomSwipeCard: SwipeCard, connectIcon: UIImageView, disconnectIcon: UIImageView, didSwipe: @escaping (Bool) -> Void, reset: @escaping () -> Void) {
        
        self.vc = vc
        
        let view = vc.view!
        
        let translation = gesture.translation(in: view)
        let swipeCard = gesture.view as! SwipeCard
        layout.updateTopSwipeCardHorizontalConstraint(translation: translation.x)
        //let scale = min(CGFloat(1.0), 1)
        //var rotation = CGAffineTransform(rotationAngle: -xFromCenter / 1000)
        //var rotation = CGAffineTransform(rotationAngle: translation.x / 1000)
        //var stretch = rotation.scaledBy(x: scale, y: scale)
        //swipeCard.transform = stretch
        var removeCard = false
        
        
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
        
        if gesture.state == .changed {
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
            
            //User Swiped Left
            if swipeCard.center.x < 0.25*DisplayUtility.screenWidth {
                let localData = LocalData()
                let isFirstTimeSwipedLeft : Bool = localData.getFirstTimeSwipingLeft()!
                if isFirstTimeSwipedLeft {
                    //show alert for swiping right here and then bridging or not
                    let alert = UIAlertController(title: "Don't Connect?", message: "Dragging a pair of pictures to the left indicates you do not want to introduce the friends shown.", preferredStyle: UIAlertControllerStyle.alert)
                    //Create the actions
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                        reset()
                    }))
                    alert.addAction(UIAlertAction(title: "Don't Connect", style: .default, handler: { (action) in
                        UIView.animate(withDuration: 0.2, animations: {
                            //swipeCard.center.x = -1.0*DisplayUtility.screenWidth
                            //disconnectIcon.center.x = -1.0*DisplayUtility.screenWidth
                            disconnectIcon.alpha = 0.0
                            swipeCard.overlay.opacity = 0.0
                        }, completion: { (success) in
                            didSwipe(false)
                        })
                        removeCard = true
                    }))
                    vc.present(alert, animated: true, completion: nil)
                    
                    localData.setFirstTimeSwipingLeft(false)
                    localData.synchronize()
                } else {
                    UIView.animate(withDuration: 0.2, animations: {
                        //disconnectIcon.center.x = -1.0*DisplayUtility.screenWidth
                        disconnectIcon.alpha = 0.0
                        swipeCard.overlay.opacity = 0.0
                    }, completion: { (success) in
                        didSwipe(false)
                    })
                    removeCard = true
                }
            }
            // User Swiped Right
            else if swipeCard.center.x > 0.75*DisplayUtility.screenWidth {
                // Layout swipeRightView full screen with user's images and ids for presenting ExternalProfiles if clicked
                let user1Image = swipeCard.topHalf.photoView.image
                let user2Image = swipeCard.bottomHalf.photoView.image
                let swipeRightView = PopupView(user1Id: swipeCard.bridgePairing?.user1ID, user2Id: swipeCard.bridgePairing?.user2ID, textString: "We'll let you know when they start a conversation!", titleImage: #imageLiteral(resourceName: "Sweet_Nect"))
                swipeRightView.alpha = 0
                vc.view.addSubview(swipeRightView)
                swipeRightView.autoPinEdgesToSuperviewEdges()
                
                // Set the hexagonImages
                swipeRightView.setHexagonImages(user1Image: user1Image, user2Image: user2Image)
                
                UIView.animate(withDuration: 0.4, animations: {
                    swipeCard.center.x = 1.6*DisplayUtility.screenWidth
                    connectIcon.center.x = 1.6*DisplayUtility.screenWidth
                    connectIcon.alpha = 0.0
                    swipeCard.overlay.opacity = 0.0
                    swipeRightView.alpha = 1
                }, completion: { (success) in
                    didSwipe(true)
                })
                removeCard = false
            }
            
            if removeCard {
                
            } else {
                // Reset the cards
                //disconnectIcon.center.x = -1.0 * DisplayUtility.screenWidth
                disconnectIcon.alpha = 0.0
                connectIcon.center.x = 1.6 * DisplayUtility.screenWidth
                connectIcon.alpha = 0.0
                
                reset()
                
                UIView.animate(withDuration: 0.7, delay: 0, options: .allowUserInteraction, animations: {
                    //rotation = CGAffineTransform(rotationAngle: 0)
                    //stretch = rotation.scaledBy(x: 1, y: 1)
                    //swipeCard.transform = stretch
                    //swipeCard.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
                    //swipeCard.frame = swipeCardFrame
                    //bottomSwipeCard.frame = smallestSwipeCardFrame(swipeCard: bottomSwipeCard)
                    //bottomSwipeCard.center.x = view.center.x
                }, completion: nil)
            }
        }
    }
    
    enum Swipe: String {
        case right
        case left
        case none
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
}
