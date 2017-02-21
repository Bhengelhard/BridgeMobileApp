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
    let table = ThreadObjects.Table()
    let keyboard = ThreadObjects.Keyboard()
    
    // MARK: - Layout
    /// Sets the initial layout constraints
    func initialize(view: UIView, didSetupConstraints: Bool) -> Bool {
        
        if (!didSetupConstraints) {
            
            
        }
        
        return true
    }
    
}
