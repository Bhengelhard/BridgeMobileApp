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
    let swipeBackend = SwipeBackend()
    
    var didSetupConstraints = false
    
    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Listener for presentingExternalProfileVC
        NotificationCenter.default.addObserver(self, selector: #selector(presentExternalProfileVC), name: NSNotification.Name(rawValue: "presentExternalProfileVC"), object: nil)
        
        // Add Targets for Swipe Cards
        layout.topSwipeCard.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeGesture(_:))))
        layout.bottomSwipeCard.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeGesture(_:))))
        layout.bottomSwipeCard.isUserInteractionEnabled = false
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.white
        
        view.setNeedsUpdateConstraints()

        // Get the next swipeCards
        //swipeBackend.setInitialTopAndBottomSwipeCards(topSwipeCard: layout.topSwipeCard, bottomSwipeCard: layout.bottomSwipeCard)
        swipeBackend.setInitialTopSwipeCard(topSwipeCard: layout.topSwipeCard) {
            self.swipeBackend.setInitialBottomSwipeCard(bottomSwipeCard: self.layout.bottomSwipeCard)
        }
        
    }
    
    
    override func updateViewConstraints() {
        didSetupConstraints = layout.initialize(view: view, didSetupConstraints: didSetupConstraints)
        
        super.updateViewConstraints()
    }
    
    // MARK: - Targets and GestureRecognizer
    func swipeGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        SwipeLogic.swipe(gesture: gestureRecognizer, layout: layout, vc: self, bottomSwipeCard: layout.bottomSwipeCard, connectIcon: layout.connectIcon, disconnectIcon: layout.disconnectIcon, didSwipe: didSwipe, reset: reset)
    }
    
    func didSwipe(right: Bool) {
        
        // if swiped left, check in bridge pairing
        if !right {
            swipeBackend.checkIn()
        }
        
        layout.switchTopAndBottomCards()
        layout.topSwipeCard.isUserInteractionEnabled = true
        layout.bottomSwipeCard.isUserInteractionEnabled = false
        layout.topSwipeCard.overlay.removeFromSuperlayer()
        swipeBackend.setBottomSwipeCard(bottomSwipeCard: layout.bottomSwipeCard)
    }
    
    func reset() {
        layout.recenterTopSwipeCard()
    }
    
    func presentExternalProfileVC(_ notification: Notification) {
        if let userId = notification.object as? String {
            let externalProfileVC = ExternalProfileViewController()
            externalProfileVC.setUserID(userID: userId)
            self.present(externalProfileVC, animated: true, completion: nil)
        }
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
