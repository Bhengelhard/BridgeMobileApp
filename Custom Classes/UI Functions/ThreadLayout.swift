//
//  ThreadLayout.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/20/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import PureLayout
import JSQMessagesViewController

class ThreadLayout {
    
    // MARK: Global Variables
    let navBar = ThreadObjects.navBar()
    let keyboard = ThreadObjects.Keyboard()
    
    // MARK: - Layout
    /// Sets the initial layout constraints
    func initialize(view: UIView, didSetupConstraints: Bool) -> Bool {
        if (!didSetupConstraints) {
            
            // MARK: Layout Objects
            
            view.removeConstraints(view.constraints)
            view.autoSetDimensions(to: CGSize(width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight))
            
            // Layout the navigation bar at the top of the view for navigating from the SwipeViewController to the MessagesViewController and the MyProfileViewController
            view.addSubview(navBar)
            navBar.autoPinEdge(toSuperviewEdge: .top)
            navBar.autoPinEdge(toSuperviewEdge: .left)
            navBar.autoMatch(.width, to: .width, of: view)
            navBar.autoSetDimension(.height, toSize: 64)
            
            // Layout the keyboard pinned to the bottom of the view
            
        }
        
        return true
    }
    
    func layoutCollectionViewAndInputToolbar(view: UIView, collectionView: UICollectionView, inputToolbar: JSQMessagesInputToolbar) {
        
        //let inputToolbarContentViewHeight = inputToolbarContentView.frame.height
        //inputToolbar.removeConstraints(inputToolbar.constraints)
        inputToolbar.autoPinEdge(toSuperviewEdge: .bottom)
        inputToolbar.autoPinEdge(toSuperviewEdge: .left)
        inputToolbar.autoMatch(.width, to: .width, of: view)
        inputToolbar.autoSetDimension(.height, toSize: 45)
        
        collectionView.removeConstraints(collectionView.constraints)
        
        // Layout the collectionView
        //view.addSubview(collectionView)
        collectionView.autoPinEdge(.top, to: .bottom, of: navBar)
        collectionView.autoPinEdge(toSuperviewEdge: .left)
        collectionView.autoPinEdge(toSuperviewEdge: .right)
        collectionView.autoPinEdge(.bottom, to: .top, of: inputToolbar)

    }
    
}
