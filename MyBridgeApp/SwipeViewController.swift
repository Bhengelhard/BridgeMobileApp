//
//  SwipeViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/17/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit
import MBProgressHUD

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
        //layout.bottomSwipeCard.isUserInteractionEnabled = false
        layout.infoButton.addTarget(self, action: #selector(infoButtonTapped(_:)), for: .touchUpInside)
        layout.passButton.addTarget(self, action: #selector(passButtonTapped(_:)), for: .touchUpInside)
        layout.nectButton.addTarget(self, action: #selector(nectButtonTapped(_:)), for: .touchUpInside)
        layout.refreshButton.addTarget(self, action: #selector(refreshButtonTapped(_:)), for: .touchUpInside)
        
        layout.inviteButton.setVC(vc: self)
        
        getBridgePairings()
        
        // Check for New Matches
        //Check for Connections Conversed and for the current User's New Matches
        let dbRetrievingFunctions = DBRetrievingFunctions()
        dbRetrievingFunctions.queryForConnectionsConversed(vc: self)
        //dbRetrievingFunctions.queryForCurrentUserMatches(vc: self)
        
        swipeBackend.getCurrentUserUnviewedMacthes { (bridgePairings) in
            User.getCurrent { (currentUser) in
                for bridgePairing in bridgePairings {
                    // create poppup view
                    bridgePairing.getNonCurrentUser { (otherUser) in
                        if let currentUserID = currentUser.id, let otherUserID = otherUser.id, let connecterName = bridgePairing.connecterName, let otherUserName = otherUser.name {
                            let youMatchedPopUp = PopupView(includesCurrentUser: true, user1Id: currentUserID, user2Id: otherUserID, textString: "\(connecterName) 'nected you with \(otherUserName)!", titleImage: #imageLiteral(resourceName: "You_Matched"), user1Image: nil, user2Image: nil)
                            self.view.addSubview(youMatchedPopUp)
                            youMatchedPopUp.autoPinEdgesToSuperviewEdges()
                        }
                    }
                    
                    // set viewed notification to true
                    if currentUser.id == bridgePairing.user1ID {
                        bridgePairing.youMatchedNotificationViewedUser1 = true
                    } else {
                        bridgePairing.youMatchedNotificationViewedUser2 = true
                    }
                    bridgePairing.save()
                }
            }
        }

    }
    
    func getBridgePairings() {
        // Make no more bridge pairing objects invisible
        for view in [layout.noMoreBridgePairingsLabel, layout.orLabel1, layout.inviteButton, layout.orLabel2, layout.refreshButton] {
            view.alpha = 0
        }
        
        // Make nect buttons visible
        for view in [layout.passButton, layout.infoButton, layout.nectButton] {
            view.alpha = 1
        }

        
        layout.loadingView.startAnimating()
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .customView
        hud.customView = layout.loadingView
        hud.label.text = "Finding best\npairs to 'nect..."
        hud.label.numberOfLines = 0
        
        let dateBefore = Date()
        // Get the first swipeCards
        self.swipeBackend.setInitialTopSwipeCard(topSwipeCard: self.layout.topSwipeCard, noMoreBridgePairings: nil) {
            let dateAfter = Date()
            let timeInterval = dateAfter.timeIntervalSince(dateBefore)
            var delay = 0.0
            if timeInterval < 2.0 {
                delay = 2.0 - timeInterval
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                if self.swipeBackend.gotTopBridgePairing {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.layout.loadingView.stopAnimating()
                }
                
                self.swipeBackend.setInitialBottomSwipeCard(bottomSwipeCard: self.layout.bottomSwipeCard, noMoreBridgePairings: self.noMoreBridgePairings) {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.layout.loadingView.stopAnimating()
                }
            }
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.white
        
        view.setNeedsUpdateConstraints()

    }
    
    override func updateViewConstraints() {
        didSetupConstraints = layout.initialize(view: view, didSetupConstraints: didSetupConstraints)
        
        super.updateViewConstraints()
    }
    
    // MARK: - Targets and GestureRecognizer
    func passButtonTapped(_ sender: UIButton) {
        SwipeLogic.didSwipe(right: false, vc: self)
    }
    
    func nectButtonTapped(_ sender: UIButton) {
        SwipeLogic.didSwipe(right: true, vc: self)
    }
    
    func infoButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "How to NECT:", message: "Our algorithm pairs two of your friends.\nSwipe right to introduce them.\nSwipe left to see the next pair.", preferredStyle: UIAlertControllerStyle.alert)
        //Create the actions
        alert.addAction(UIAlertAction(title: "Got it", style: .default, handler: { (action) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func refreshButtonTapped( _ sender: UIButton) {
        getBridgePairings()
    }
    
    func swipeGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        SwipeLogic.swipe(gesture: gestureRecognizer, layout: layout, vc: self, bottomSwipeCard: layout.bottomSwipeCard, connectIcon: layout.connectIcon, disconnectIcon: layout.disconnectIcon, reset: reset)
    }
    
    func presentExternalProfileVC(_ notification: Notification) {
        if let userId = notification.object as? String {
            let externalProfileVC = ExternalProfileViewController()
            externalProfileVC.setUserID(userID: userId)
            self.present(externalProfileVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - Functions to pass as parameters
    func reset() {
        layout.recenterTopSwipeCard()
    }
    
    func noMoreBridgePairings() {
        for view in [layout.noMoreBridgePairingsLabel, layout.orLabel1, layout.inviteButton, layout.orLabel2, layout.refreshButton] {
            view.alpha = 1
        }
        
        // both cards gone
        if swipeBackend.topBridgePairing == nil && swipeBackend.bottomBridgePairing == nil {
            for view in [layout.passButton, layout.infoButton, layout.nectButton] {
                view.alpha = 0
            }
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
