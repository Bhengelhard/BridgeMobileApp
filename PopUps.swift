//
//  PopUps.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/2/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class PopUps {
    
    /// When the user sees a match to swipe for the first time, display a pop-up to indicate what they are supposed to do
    func displaySwipeTutorialPopUp() -> UIAlertController{
        print("displaySwipeTutorialPopUp called")
        
        let alert = UIAlertController(title: "How to 'nect:", message: "Swipe right to connect the friends displayed.\nSwipe left to see the next match", preferredStyle: UIAlertControllerStyle.alert)
        //Create the actions
        alert.addAction(UIAlertAction(title: "Got it", style: .default, handler: { (action) in
        }))
        
        return alert
    }
    
}
