//
//  TransitionManager.swift
//  MyBridgeApp
//
//  Created by Sagar Sinha on 6/26/16.
//  Copyright © 2016 BHE Ventures LLC. All rights reserved.
//

import UIKit

class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate  {
    
    var animationDirection = "Right"
    // MARK: UIViewControllerAnimatedTransitioning protocol methods
    
    // animate a change from one viewcontroller to another
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // get reference to our fromView, toView and the container view that we should perform the transition in
        let container = transitionContext.containerView
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        // set up from 2D transforms that we'll use in the animation
        let offScreenRight = CGAffineTransform(translationX: container.frame.width, y: 0)
        let offScreenLeft = CGAffineTransform(translationX: -container.frame.width, y: 0)
        let offScreenBottom = CGAffineTransform(translationX: 0, y: -container.frame.height)
        let offScreenTop = CGAffineTransform(translationX: 0, y: container.frame.height)
        
        // start the toView to the right of the screen
        switch(animationDirection){
            case "Right":
                toView.transform = offScreenRight
                break
            case "Left":
                toView.transform = offScreenLeft
                break
            case "Bottom":
                toView.transform = offScreenBottom
                break
            case "Top":
                toView.transform = offScreenTop
                break
            default:
                toView.transform = offScreenRight
            
        }
        
        // add the both views to our view controller
        container.addSubview(toView)
        container.addSubview(fromView)
        
        // get the duration of the animation
        let duration = self.transitionDuration(using: transitionContext)
        
        // perform the animation!
        //  just slid both fromView and toView to the left at the same time
        // meaning fromView is pushed off the screen and toView slides into view
        // we also use the block animation usingSpringWithDamping for a little bounce
        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions(), animations: {
            switch(self.animationDirection){
            case "Right":
                fromView.transform = offScreenLeft
                break
            case "Left":
                fromView.transform = offScreenRight
                break
            case "Bottom":
                fromView.transform = offScreenTop
                break
            case "Top":
                fromView.transform = offScreenBottom
                break
            default:
                fromView.transform = offScreenLeft
                
            }
            
            toView.transform = CGAffineTransform.identity
            
            }, completion: { finished in
                
                // tell our transitionContext object that we've finished animating
                transitionContext.completeTransition(true)
                
        })
        
    
    }
    
    // return how many seconds the transiton animation will take
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    // MARK: UIViewControllerTransitioningDelegate protocol methods
    
    // return the animataor when presenting a viewcontroller
    // remmeber that an animator (or animation controller) is any object that aheres to the UIViewControllerAnimatedTransitioning protocol
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    // return the animator used when dismissing from a viewcontroller
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
}
