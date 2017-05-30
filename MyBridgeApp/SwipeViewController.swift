//
//  SwipeViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/17/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit
import MBProgressHUD
import Parse

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
        
        for view in layout.cardsLimitMetViews {
            view.alpha = 0
        }
        
        for view in layout.noMoreCardsViews {
            view.alpha = 0
        }
        
        for view in layout.noCardsViews {
            view.alpha = 0
        }
        
        layout.friendsImage.alpha = 0
        layout.inviteButton.alpha = 0
        
        layout.countdownLabelView.countdownFinishedCompletion = checkHasResetPairs
        layout.countdownLabelView.startCountdown()
        
        // Listeners
        // Listener for presentingExternalProfileVC
        NotificationCenter.default.addObserver(self, selector: #selector(presentExternalProfileVC(_:)), name: NSNotification.Name(rawValue: "presentExternalProfileVC"), object: nil)
        // Listener for presentingThreadVC
        NotificationCenter.default.addObserver(self, selector: #selector(presentThreadVC(_:)), name: NSNotification.Name(rawValue: "presentThreadVC"), object: nil)
        
        // Listener for updating inbox Icon
        NotificationCenter.default.addObserver(self, selector: #selector(displayInboxIconNotification(_:)), name: NSNotification.Name(rawValue: "displayInboxIconNotification"), object: nil)
        
        // Add Targets for Swipe Cards
        layout.topSwipeCard.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeGesture(_:))))
        layout.bottomSwipeCard.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeGesture(_:))))
        layout.topSwipeCard.isUserInteractionEnabled = false
        layout.bottomSwipeCard.isUserInteractionEnabled = false
        layout.infoButton.addTarget(self, action: #selector(infoButtonTapped(_:)), for: .touchUpInside)
        layout.passButton.addTarget(self, action: #selector(passButtonTapped(_:)), for: .touchUpInside)
        layout.nectButton.addTarget(self, action: #selector(nectButtonTapped(_:)), for: .touchUpInside)
        layout.navBar.titleButton.addTarget(self, action: #selector(necterIconTapped(_:)), for: .touchUpInside)
        
        layout.inviteButton.setVC(vc: self)
        
        User.getCurrent { (user) in
            if let user = user {
                // if user has not reset cards, set locally stored cards to nil
                if let hasResetPairs = user.hasResetPairs {
                    if !hasResetPairs {
                        let localBridgePairings = LocalBridgePairings()
                        localBridgePairings.setBridgePairing1ID(nil)
                        localBridgePairings.setBridgePairing2ID(nil)
                        localBridgePairings.synchronize()
                        
                        user.hasResetPairs = true
                        user.save { (_) in
                            self.getBridgePairings()
                        }
                    } else {
                        self.getBridgePairings()
                    }
                } else {
                    user.hasResetPairs = true
                    user.save { (_) in
                        self.getBridgePairings()
                    }
                }
            }
        }
        
        // Check for New Matches
        //Check for Connections Conversed and for the current User's New Matches
        let dbRetrievingFunctions = DBRetrievingFunctions()
        dbRetrievingFunctions.queryForConnectionsConversed(vc: self)
        //dbRetrievingFunctions.queryForCurrentUserMatches(vc: self)
        
        
        // TODO: Check if it's possible to combine this with the getCurrentUserUnviewMatchesNotification
        // TODO: Make it so the notification only goes away when the user reads a message instead of just clicking on the inbox -> this could be by re-running the below check the same times as reloading the messages table.
        // Check if the current user has a notification
        User.getCurrent { (user) in
            Message.getCurrentUserNotificationStatus(withUser: user!) { (hasNotification) in
                if hasNotification {
                    self.layout.navBar.rightButton.setImage(#imageLiteral(resourceName: "Inbox_Navbar_Icon_Notification"), for: .normal)
                } else {
                    self.layout.navBar.rightButton.setImage(#imageLiteral(resourceName: "Messages_Navbar_Inactive"), for: .normal)
                }
            }
        }

        
        swipeBackend.getCurrentUserUnviewedMatches { (bridgePairings) in
            User.getCurrent { (currentUser) in
                if let currentUser = currentUser {
                    for bridgePairing in bridgePairings {
                        // create poppup view
                        bridgePairing.getNonCurrentUser { (otherUser) in
                            if let otherUser = otherUser {
                                if let currentUserID = currentUser.id, let otherUserID = otherUser.id, let connecterName = bridgePairing.connecterName, let otherUserName = otherUser.name {
                                    let youMatchedPopUp = PopupView(includesCurrentUser: true, user1Id: currentUserID, user2Id: otherUserID, textString: "\(connecterName) 'nected you with \(otherUserName)!", titleImage: #imageLiteral(resourceName: "You_Matched"), user1Image: nil, user2Image: nil)
                                    self.view.addSubview(youMatchedPopUp)
                                    youMatchedPopUp.autoPinEdgesToSuperviewEdges()
                                }
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

    }
    
    func checkHasResetPairs() {
        User.getCurrent { (user) in
            if let user = user {
                // if user has not reset cards, set locally stored cards to nil
                if let hasResetPairs = user.hasResetPairs {
                    if !hasResetPairs {
                        let localBridgePairings = LocalBridgePairings()
                        localBridgePairings.setBridgePairing1ID(nil)
                        localBridgePairings.setBridgePairing2ID(nil)
                        localBridgePairings.synchronize()
                        
                        user.hasResetPairs = true
                        user.save { (_) in
                            self.getBridgePairings()
                        }
                    } else {
                        self.getBridgePairings()
                    }
                } else {
                    user.hasResetPairs = true
                    user.save { (_) in
                        self.getBridgePairings()
                    }
                }
            }
        }
    }
    
    func getBridgePairings() {
        for view in layout.cardsLimitMetViews {
            view.alpha = 0
        }
        
        for view in layout.noMoreCardsViews {
            view.alpha = 0
        }
        
        for view in layout.noCardsViews {
            view.alpha = 0
        }
        
        layout.friendsImage.alpha = 0
        layout.inviteButton.alpha = 0
        
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
        self.swipeBackend.getBridgePairings(topSwipeCard: layout.topSwipeCard, bottomSwipeCard: layout.bottomSwipeCard, limitMet: limitMet, noMoreBridgePairings: noMoreBridgePairings, noBridgePairings: noBridgePairings) {
            let dateAfter = Date()
            let timeInterval = dateAfter.timeIntervalSince(dateBefore)
            var delay = 0.0
            if timeInterval < 2.0 {
                delay = 2.0 - timeInterval
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.layout.loadingView.stopAnimating()
            }
        }
        
        /*
        // Get the first swipeCards
        self.swipeBackend.setInitialTopSwipeCard(topSwipeCard: layout.topSwipeCard, limitMet: limitMet, noMoreBridgePairings: noMoreBridgePairings, noBridgePairings: noBridgePairings) {
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
                
                self.swipeBackend.setInitialBottomSwipeCard(bottomSwipeCard: self.layout.bottomSwipeCard, limitMet: self.limitMet, noMoreBridgePairings: self.noMoreBridgePairings, noBridgePairings: self.noBridgePairings) {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.layout.loadingView.stopAnimating()
                }
            }
        }*/
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
        presentAppInstructions()
    }
    func necterIconTapped(_ sender: UIButton) {
        presentAppInstructions()
    }
    func presentAppInstructions() {
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
        /*if let userId = notification.object as? String {
            let externalProfileVC = ExternalProfileViewController()
            externalProfileVC.setUserID(userID: userId)
            self.present(externalProfileVC, animated: true, completion: nil)
        }*/
        let externalProfileVC = ExternalProfileViewController()
        if let (userID, image) = notification.object as? (String, UIImage) { // pass image through
            externalProfileVC.setMainProfilePictureAndUserID(image: image, userID: userID)
            self.present(externalProfileVC, animated: true, completion: nil)
        } else if let userID = notification.object as? String {
            externalProfileVC.setUserID(userID: userID)
            self.present(externalProfileVC, animated: true, completion: nil) // must download image
        }
    }
    
    // MARK: - Functions to pass as parameters
    func reset() {
        layout.recenterTopSwipeCard()
    }
    
    func limitMet() {
        print("limit met")
        
        MBProgressHUD.hide(for: self.view, animated: true)
        self.layout.loadingView.stopAnimating()
        
        for view in layout.noMoreCardsViews {
            view.alpha = 0
        }
        
        for view in layout.noCardsViews {
            view.alpha = 0
        }
        
        for view in layout.cardsLimitMetViews {
            view.alpha = 1
        }
        
        // both cards gone
        if layout.topSwipeCard.bridgePairing == nil && layout.bottomSwipeCard.bridgePairing == nil {
            layout.friendsImage.alpha = 1
            layout.inviteButton.alpha = 1
            
            for view in [layout.passButton, layout.infoButton, layout.nectButton] {
                view.alpha = 0
            }
        }
        
    }
    
    func noMoreBridgePairings() {
        print("no more bridge pairings")
        MBProgressHUD.hide(for: self.view, animated: true)
        self.layout.loadingView.stopAnimating()
        
        /*
        for view in [layout.noMoreBridgePairingsLabel, layout.orLabel1, layout.inviteButton, layout.orLabel2, layout.refreshButton] {
            view.alpha = 1
        }*/

        for view in layout.cardsLimitMetViews {
            view.alpha = 0
        }
        
        for view in layout.noCardsViews {
            view.alpha = 0
        }
        
        for view in layout.noMoreCardsViews {
            view.alpha = 1
        }
        
        // both cards gone
        if layout.topSwipeCard.bridgePairing == nil && layout.bottomSwipeCard.bridgePairing == nil {
            layout.friendsImage.alpha = 1
            layout.inviteButton.alpha = 1
            
            for view in [layout.passButton, layout.infoButton, layout.nectButton] {
                view.alpha = 0
            }
        }
    }
    
    func noBridgePairings() {
        print("no bridge pairings")
        MBProgressHUD.hide(for: self.view, animated: true)
        self.layout.loadingView.stopAnimating()
        
        for view in layout.cardsLimitMetViews {
            view.alpha = 0
        }
        
        for view in layout.noMoreCardsViews {
            view.alpha = 0
        }
        
        for view in layout.noCardsViews {
            view.alpha = 1
        }
        
        // both cards gone
        if layout.topSwipeCard.bridgePairing == nil && layout.bottomSwipeCard.bridgePairing == nil {
            layout.friendsImage.alpha = 1
            layout.inviteButton.alpha = 1
            
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
    
    // Upon Push Notification, display inbox Icon with notification dot
    func displayInboxIconNotification(_ notification: Notification) {
        print("displayInboxIconNotification")
        layout.navBar.rightButton.setImage(#imageLiteral(resourceName: "Inbox_Navbar_Icon_Notification"), for: .normal)
    }
    
    // MARK: - Navigationza

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
