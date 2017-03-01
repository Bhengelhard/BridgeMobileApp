//
//  SwipeLogic.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 2/27/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class SwipeLogic {
    static func isDragged(_ gesture: UIPanGestureRecognizer, vc: UIViewController, yCenter: CGFloat, bottomSwipeCard: SwipeCard, connectIcon: UIImageView, disconnectIcon: UIImageView, didSwipe: @escaping () -> Void, checkIn: @escaping () -> Void) {
        let view = vc.view!
        let translation = gesture.translation(in: view)
        let swipeCard = gesture.view as! SwipeCard
        swipeCard.center = CGPoint(x: DisplayUtility.screenWidth / 2 + translation.x, y: DisplayUtility.screenHeight / 2 + translation.y)
        let xFromCenter = swipeCard.center.x - view.bounds.width / 2
        let scale = min(CGFloat(1.0), 1)
        var rotation = CGAffineTransform(rotationAngle: -xFromCenter / 1000)
        var stretch = rotation.scaledBy(x: scale, y: scale)
        swipeCard.transform = stretch
        var removeCard = false
        var showReasonForConnection = false
        
        //Displaying and Removing the connect and disconnect icons
        let disconnectIconX = max(min((-1.5*(swipeCard.center.x/DisplayUtility.screenWidth)+0.6)*DisplayUtility.screenWidth, 0.1*DisplayUtility.screenWidth), 0)
        let connectIconX = max(min(((-2.0/3.0)*(swipeCard.center.x/DisplayUtility.screenWidth)+1.0)*DisplayUtility.screenWidth, 0.6*DisplayUtility.screenWidth), 0.5*DisplayUtility.screenWidth)
        
        //Limiting Y axis of swipe
        swipeCard.center.y = yCenter
        
        //animating connect and disconnect icons when card is positioned from 0.4% of DisplayUtility.screenWidth to 0.25% of DisplayUtility.screenWidth
        if swipeCard.center.x < 0.4*DisplayUtility.screenWidth {
            
            //fading in with swipe left from 0.4% of DisplayUtility.screenWidth to 0.25% of screen width
            disconnectIcon.alpha = -6.66*(swipeCard.center.x/DisplayUtility.screenWidth)+2.66
            disconnectIcon.frame = CGRect(x: disconnectIconX, y: 0.33*DisplayUtility.screenHeight, width: 0.4*DisplayUtility.screenWidth, height: 0.4*DisplayUtility.screenWidth)
            
        } else if swipeCard.center.x > 0.6*DisplayUtility.screenWidth {
            
            //fading in with swipe right from 0.6% of DisplayUtility.screenWidth to 0.75% of screen width
            connectIcon.alpha = 6.66*(swipeCard.center.x/DisplayUtility.screenWidth)-4
            connectIcon.frame = CGRect(x: connectIconX, y: 0.33*DisplayUtility.screenHeight, width: 0.4*DisplayUtility.screenWidth, height: 0.4*DisplayUtility.screenWidth)
            
        } else {
            
            disconnectIcon.alpha = -6.66*(swipeCard.center.x/DisplayUtility.screenWidth)+2.66
            disconnectIcon.frame = CGRect(x: disconnectIconX, y: 0.33*DisplayUtility.screenHeight, width: 0.4*DisplayUtility.screenWidth, height: 0.4*DisplayUtility.screenWidth)
            connectIcon.frame = CGRect(x: connectIconX, y: 0.33*DisplayUtility.screenHeight, width: 0.4*DisplayUtility.screenWidth, height: 0.4*DisplayUtility.screenWidth)
            
            connectIcon.alpha = 6.66*(swipeCard.center.x/DisplayUtility.screenWidth)-4
            
        }
        
        if gesture.state == .began {
            bottomSwipeCard.frame = smallestSwipeCardFrame(swipeCard: bottomSwipeCard)
            bottomSwipeCard.center.x = view.center.x
        }
        
        if gesture.state == .changed {
            let multiplier = CGFloat(0.98)
            let cardCenterX = swipeCard.center.x
            let screenMiddleX = DisplayUtility.screenWidth / 2
            let direction: CGFloat = cardCenterX <= screenMiddleX ? screenMiddleX - cardCenterX : cardCenterX - screenMiddleX
            let percent: CGFloat = min(max(0.05 * (direction / screenMiddleX) + multiplier, multiplier), 1.0)
            let maxFrame = swipeCard.swipeCardFrame()
            let inset = CGSize(width: maxFrame.width * percent,
                               height: maxFrame.height * percent)
            let differential = CGSize(width: maxFrame.size.width - inset.width,
                                      height: maxFrame.size.height - inset.height)
            
            bottomSwipeCard.frame = CGRect(origin: CGPoint(x: max(maxFrame.origin.x + differential.width, maxFrame.origin.x),
                                                           y: max(maxFrame.origin.y + differential.height, maxFrame.origin.y)),
                                           size: CGSize(width: min(abs(maxFrame.width - (inset.width * 2)), maxFrame.width),
                                                        height: min(abs(maxFrame.height - (inset.height * 2)), maxFrame.height)))
            
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
                        
                    }))
                    alert.addAction(UIAlertAction(title: "Don't Connect", style: .default, handler: { (action) in
                        UIView.animate(withDuration: 0.2, animations: {
                            swipeCard.center.x = -1.0*DisplayUtility.screenWidth
                            disconnectIcon.center.x = -1.0*DisplayUtility.screenWidth
                            disconnectIcon.alpha = 0.0
                            swipeCard.overlay.opacity = 0.0
                        }, completion: { (success) in
                            didSwipe()
                        })
                        removeCard = true
                        checkIn()
                    }))
                    vc.present(alert, animated: true, completion: nil)
                    
                    localData.setFirstTimeSwipingLeft(false)
                    localData.synchronize()
                } else {
                    UIView.animate(withDuration: 0.2, animations: {
                        swipeCard.center.x = -1.0*DisplayUtility.screenWidth
                        disconnectIcon.center.x = -1.0*DisplayUtility.screenWidth
                        disconnectIcon.alpha = 0.0
                        swipeCard.overlay.opacity = 0.0
                    }, completion: { (success) in
                        didSwipe()
                    })
                    removeCard = true
                    checkIn()
                }
            }
                //User Swiped Right
            else if swipeCard.center.x > 0.75*DisplayUtility.screenWidth {
                UIView.animate(withDuration: 0.4, animations: {
                    swipeCard.center.x = 1.6*DisplayUtility.screenWidth
                    connectIcon.center.x = 1.6*DisplayUtility.screenWidth
                    connectIcon.alpha = 0.0
                    swipeCard.overlay.opacity = 0.0
                }, completion: { (success) in
                    // FIXME: take to sweet nect page
                })
                removeCard = false
                showReasonForConnection = true
            }
            
            if removeCard
            {
                swipeCard.removeFromSuperview()
                
                /*
                if arrayOfCardsInDeck.count > 1
                {
                    swipeCard = arrayOfCardsInDeck[0]
                    swipeCard.overlay.removeFromSuperlayer()
                    bottomSwipeCard = arrayOfCardsInDeck.indices.contains(1) ? arrayOfCardsInDeck[1] : SwipeCard()
                }*/
                
            } else if showReasonForConnection {
                
            }
            else
            {
                // Reset the cards
                disconnectIcon.center.x = -1.0 * DisplayUtility.screenWidth
                disconnectIcon.alpha = 0.0
                connectIcon.center.x = 1.6 * DisplayUtility.screenWidth
                connectIcon.alpha = 0.0
                
                UIView.animate(withDuration: 0.7, delay: 0, options: .allowUserInteraction, animations: {
                    rotation = CGAffineTransform(rotationAngle: 0)
                    stretch = rotation.scaledBy(x: 1, y: 1)
                    swipeCard.transform = stretch
                    //swipeCard.frame = swipeCardFrame
                    bottomSwipeCard.frame = smallestSwipeCardFrame(swipeCard: bottomSwipeCard)
                    bottomSwipeCard.center.x = view.center.x
                }, completion: nil)
            }
        }
    }
    
    static func smallestSwipeCardFrame(swipeCard: SwipeCard) -> CGRect {
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
