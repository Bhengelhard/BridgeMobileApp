//
//  ThreadLayout.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/20/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import PureLayout

class ThreadLayout {
    
    // MARK: Global Variables
    let navBar = ThreadObjects.navBar()
    let keyboard = ThreadObjects.Keyboard()
    
    // MARK: - Layout
    /// Sets the initial layout constraints
    func initialize(view: UIView, didSetupConstraints: Bool) -> Bool {
        
        if (!didSetupConstraints) {
            
            // MARK: Layout Objects
            
            // Layout the navigation bar at the top of the view for navigating from the SwipeViewController to the MessagesViewController and the MyProfileViewController
            view.addSubview(navBar)
            navBar.autoPinEdge(toSuperviewEdge: .top)
            navBar.autoPinEdge(toSuperviewEdge: .left)
            navBar.autoMatch(.width, to: .width, of: view)
            navBar.autoSetDimension(.height, toSize: 64)
            print("navBar was laid out")
            
            // Layout the keyboard pinned to the bottom of the view
            
        }
        
        return true
    }
    
    func layoutCollectionView(view: UIView, collectionView: UICollectionView) {

        // Layout the collectionView
        view.addSubview(collectionView)
        collectionView.autoPinEdge(.top, to: .bottom, of: navBar)
        collectionView.autoPinEdge(toSuperviewEdge: .left)
        collectionView.autoPinEdge(toSuperviewEdge: .right)
        collectionView.autoPinEdge(toSuperviewEdge: .bottom)
    }
    
}
