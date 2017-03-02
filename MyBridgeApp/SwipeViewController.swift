//
//  SwipeViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/17/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit

/// The SwipeViewController class displays and handles swiping for introductions
class SwipeViewController: UIViewController {

    // MARK: Global Variables
    let layout = SwipeLayout()
    let transitionManager = TransitionManager()
    
    var didSetupConstraints = false
    
    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.white
        
        view.setNeedsUpdateConstraints()
        
        // Get the next swipeCards
        let swipeBackend = SwipeBackend()
        swipeBackend.setInitialTopAndBottomSwipeCards(topSwipeCard: layout.topSwipeCard, bottomSwipeCard: layout.bottomSwipeCard)
        
        // Add Targets
        layout.passButton.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
        
        
        layout.topSwipeCard.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeTopGesture(_:))))
        
        //layout.bottomSwipeCard.addGestureRecognizer(<#T##gestureRecognizer: UIGestureRecognizer##UIGestureRecognizer#>)
        
    }
    
    
    override func updateViewConstraints() {
        didSetupConstraints = layout.initialize(view: view, didSetupConstraints: didSetupConstraints)
        
        super.updateViewConstraints()
    }
    
    // MARK: - Targets and GestureRecognizer
    func tapped(_ sender: UIButton) {
        
    }
    
    func swipeTopGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.view == layout.topSwipeCard {
            callIsDragged(gestureRecognizer: gestureRecognizer, bottomSwipeCard: layout.bottomSwipeCard)
        } else {
            callIsDragged(gestureRecognizer: gestureRecognizer, bottomSwipeCard: layout.topSwipeCard)
        }
    }
    func callIsDragged(gestureRecognizer: UIPanGestureRecognizer, bottomSwipeCard: SwipeCard) {
        let swipeBackend = SwipeBackend()
        let moveBottomToTop = swipeBackend.moveBottomSwipeCardToTopAndResetBottom
        let checkIn = swipeBackend.checkIn
        
        SwipeLogic.isDragged(gesture: gestureRecognizer, vc: self, yCenter: self.view.center.y, bottomSwipeCard: bottomSwipeCard, connectIcon: layout.connectIcon, disconnectIcon: layout.disconnectIcon, didSwipe: moveBottomToTop, checkIn: checkIn)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination
        let mirror = Mirror(reflecting: vc)
        if mirror.subjectType == MyProfileViewController.self {
            self.transitionManager.animationDirection = "Left"
        } else if mirror.subjectType == MessagesViewController.self {
            self.transitionManager.animationDirection = "Right"
        }
        //vc.transitioningDelegate = self.transitionManager
        
    }
    
}
