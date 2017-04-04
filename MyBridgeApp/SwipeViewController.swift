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
        
        // Listener for presentingExternalProfileVC
        NotificationCenter.default.addObserver(self, selector: #selector(presentExternalProfileVC), name: NSNotification.Name(rawValue: "presentExternalProfileVC"), object: nil)
        
        // Add Targets for Swipe Cards
        layout.topSwipeCard.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeGesture(_:))))
        layout.bottomSwipeCard.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeGesture(_:))))
        layout.bottomSwipeCard.isUserInteractionEnabled = false
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
        dbRetrievingFunctions.queryForCurrentUserMatches(vc: self)
    }
    
    func getBridgePairings() {
        // Make no more bridge pairing objects invisible
        for view in [layout.noMoreBridgePairingsLabel, layout.orLabel1, layout.inviteButton, layout.orLabel2, layout.refreshButton] {
            view.alpha = 0
        }
        
        layout.loadingView.startAnimating()
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .customView
        hud.customView = layout.loadingView
        hud.label.text = "Finding Best\nPotential Friends..."
        hud.label.numberOfLines = 0
        
        // 2 second delay
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            // Get the first swipeCards
            self.swipeBackend.setInitialTopSwipeCard(topSwipeCard: self.layout.topSwipeCard, noMoreBridgePairings: nil) {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.layout.loadingView.stopAnimating()
                self.swipeBackend.setInitialBottomSwipeCard(bottomSwipeCard: self.layout.bottomSwipeCard, noMoreBridgePairings: self.noMoreBridgePairings)
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
        didSwipe(right: false)
    }
    
    func nectButtonTapped(_ sender: UIButton) {
        if layout.topSwipeCard.isUserInteractionEnabled {
            //SwipeLogic.swipedRight(swipeCard: layout.topSwipeCard)
        } else {
            //SwipeLogic.swipedRight(swipeCard: layout.bottomSwipeCard)
        }
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
        // if swiped left, check in bridge pairing
        if !right {
            swipeBackend.checkIn()
        }
        
        layout.switchTopAndBottomCards()
        layout.topSwipeCard.isUserInteractionEnabled = true
        layout.bottomSwipeCard.isUserInteractionEnabled = false
        layout.topSwipeCard.overlay.removeFromSuperlayer()
        layout.bottomSwipeCard.addOverlay()
        swipeBackend.setBottomSwipeCard(bottomSwipeCard: layout.bottomSwipeCard, noMoreBridgePairings: noMoreBridgePairings)
    }
    
    func reset() {
        layout.recenterTopSwipeCard()
    }
    
    func noMoreBridgePairings() {
        for view in [layout.noMoreBridgePairingsLabel, layout.orLabel1, layout.inviteButton, layout.orLabel2, layout.refreshButton] {
            view.alpha = 1
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
