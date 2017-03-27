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
    let messageComposer = MessageComposer()
    
    var didSetupConstraints = false
    
    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Listeners
        // Listener for presentingExternalProfileVC
        NotificationCenter.default.addObserver(self, selector: #selector(presentExternalProfileVC(_:)), name: NSNotification.Name(rawValue: "presentExternalProfileVC"), object: nil)
        // Listener for presentingThreadVC
        NotificationCenter.default.addObserver(self, selector: #selector(presentThreadVC(_:)), name: NSNotification.Name(rawValue: "presentThreadVC"), object: nil)
        // Listener for updating inbox Icon
//        NotificationCenter.default.addObserver(self, selector: #selector(presentThreadVC(_:)), name: NSNotification.Name(rawValue: "pushNotification"), object: nil)
        
        // Add Targets for Swipe Cards
        layout.topSwipeCard.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeGesture(_:))))
        layout.bottomSwipeCard.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeGesture(_:))))
        layout.bottomSwipeCard.isUserInteractionEnabled = false
        layout.infoButton.addTarget(self, action: #selector(infoButtonTapped(_:)), for: .touchUpInside)
        layout.passButton.addTarget(self, action: #selector(passButtonTapped(_:)), for: .touchUpInside)
        layout.nectButton.addTarget(self, action: #selector(nectButtonTapped(_:)), for: .touchUpInside)
        layout.inviteButton.addTarget(self, action: #selector(inviteButtonTapped(_:)), for: .touchUpInside)
        layout.refreshButton.addTarget(self, action: #selector(refreshButtonTapped(_:)), for: .touchUpInside)
        
        // Make no more bridge pairing objects invisible
        for view in [layout.noMoreBridgePairingsLabel, layout.orLabel1, layout.inviteButton, layout.orLabel2, layout.refreshButton] {
            view.alpha = 0
        }
        
        // Check for New Matches
        //Check for Connections Conversed and for the current User's New Matches
        let dbRetrievingFunctions = DBRetrievingFunctions()
        dbRetrievingFunctions.queryForConnectionsConversed(vc: self)
        dbRetrievingFunctions.queryForCurrentUserMatches(vc: self)

    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.white
        
        view.setNeedsUpdateConstraints()

        // Get the next swipeCards
        //swipeBackend.setInitialTopAndBottomSwipeCards(topSwipeCard: layout.topSwipeCard, bottomSwipeCard: layout.bottomSwipeCard)
        swipeBackend.setInitialTopSwipeCard(topSwipeCard: layout.topSwipeCard, noMoreBridgePairings: noMoreBridgePairings) {
            self.swipeBackend.setInitialBottomSwipeCard(bottomSwipeCard: self.layout.bottomSwipeCard, noMoreBridgePairings: self.noMoreBridgePairings)
        }
        
    }
    
    override func updateViewConstraints() {
        didSetupConstraints = layout.initialize(view: view, didSetupConstraints: didSetupConstraints)
        
        super.updateViewConstraints()
    }
    
    // MARK: - Targets and GestureRecognizer
    func passButtonTapped(_ sender: UIButton) {
        didSwipe(right: false)
    }
    
    func nectButtonTapped(_ sender: UIButton) {
//        if layout.topSwipeCard.isUserInteractionEnabled {
//            //SwipeLogic.swipedRight(swipeCard: layout.topSwipeCard)
//        } else {
//            //SwipeLogic.swipedRight(swipeCard: layout.bottomSwipeCard)
//        }
        didSwipe(right: true)
    }
    
    func infoButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "How to NECT:", message: "Our algorithm pairs two of your friends.\nSwipe right to introduce them.\nSwipe left to see the next pair.", preferredStyle: UIAlertControllerStyle.alert)
        //Create the actions
        alert.addAction(UIAlertAction(title: "Got it", style: .default, handler: { (action) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Presents Message with text prepopulated
    func inviteButtonTapped(_ sender: UIButton) {
        
        // Make sure the device can send text messages
        if (messageComposer.canSendText()) {
            // Obtain a configured MFMessageComposeViewController
            let messageComposeVC = messageComposer.configuredMessageComposeViewController()
            // Present the configured MFMessageComposeViewController instance
            // Note that the dismissal of the VC will be handled by the messageComposer instance,
            // since it implements the appropriate delegate call-back
            present(messageComposeVC, animated: true, completion: nil)
        } else {
            // Let the user know if his/her device isn't able to send text messages
            let errorAlert = UIAlertView(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", delegate: self, cancelButtonTitle: "OK")
            errorAlert.show()
        }
    }

    func refreshButtonTapped( _ sender: UIButton) {
        // Make no more bridge pairing objects invisible
        for view in [layout.noMoreBridgePairingsLabel, layout.orLabel1, layout.inviteButton, layout.orLabel2, layout.refreshButton] {
            view.alpha = 0
        }
        swipeBackend.setInitialTopSwipeCard(topSwipeCard: layout.topSwipeCard, noMoreBridgePairings: noMoreBridgePairings) {
            self.swipeBackend.setInitialBottomSwipeCard(bottomSwipeCard: self.layout.bottomSwipeCard, noMoreBridgePairings: self.noMoreBridgePairings)
        }
    }
    
    func swipeGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        SwipeLogic.swipe(gesture: gestureRecognizer, layout: layout, vc: self, bottomSwipeCard: layout.bottomSwipeCard, connectIcon: layout.connectIcon, disconnectIcon: layout.disconnectIcon, didSwipe: didSwipe, reset: reset)
    }
    
    func presentExternalProfileVC(_ notification: Notification) {
        if let userId = notification.object as? String {
            let externalProfileVC = ExternalProfileViewController()
            externalProfileVC.setUserID(userID: userId)
            self.present(externalProfileVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - Functions to pass as parameters
    
    func didSwipe(right: Bool) {
        print("didSwipe")
        let swipeCard: SwipeCard
        if layout.bottomSwipeCard.isUserInteractionEnabled {
            swipeCard = layout.bottomSwipeCard
        } else {
            swipeCard = layout.topSwipeCard
        }
        
        // if swiped left, check in bridge pairing and animate left swipe
        if !right {
            print("swiped left")
            swipeBackend.checkIn()
            UIView.animate(withDuration: 0.4, animations: { 
                print("animation happened")
                self.layout.updateTopSwipeCardHorizontalConstraint(fromCenter: -(self.view.frame.width/2 + swipeCard.frame.width/2))
                self.view.layoutIfNeeded()
            }, completion: { (success) in
                self.layout.switchTopAndBottomCards()
                self.layout.topSwipeCard.isUserInteractionEnabled = true
                self.layout.bottomSwipeCard.isUserInteractionEnabled = false
                self.layout.topSwipeCard.overlay.removeFromSuperlayer()
                self.swipeBackend.setBottomSwipeCard(bottomSwipeCard: self.layout.bottomSwipeCard, noMoreBridgePairings: self.noMoreBridgePairings)
            })
        }
        // if swiped right, animate card swiped right
        else {
            UIView.animate(withDuration: 0.4, animations: {
                print("animation happened")
                self.layout.updateTopSwipeCardHorizontalConstraint(fromCenter: (self.view.frame.width/2 + swipeCard.frame.width/2))
                self.view.layoutIfNeeded()
            }, completion: { (success) in
                self.layout.switchTopAndBottomCards()
                self.layout.topSwipeCard.isUserInteractionEnabled = true
                self.layout.bottomSwipeCard.isUserInteractionEnabled = false
                self.layout.topSwipeCard.overlay.removeFromSuperlayer()
                self.swipeBackend.setBottomSwipeCard(bottomSwipeCard: self.layout.bottomSwipeCard, noMoreBridgePairings: self.noMoreBridgePairings)
            })
        }
        
        
        
        
    }
    
    func reset() {
        layout.recenterTopSwipeCard()
    }
    
    func noMoreBridgePairings() {
        for view in [layout.noMoreBridgePairingsLabel, layout.orLabel1, layout.inviteButton, layout.orLabel2, layout.refreshButton] {
            view.alpha = 1
        }
    }
    
    func presentThreadVC(_ notification: Notification) {
        if let messageID = notification.object as? String {
            let threadVC = ThreadViewController()
            threadVC.setMessageID(messageID: messageID)
            self.present(threadVC, animated: true, completion: nil)
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
