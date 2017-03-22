//
//  DBSavingFunctions.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 11/17/16.
//  Copyright © 2016 Parse. All rights reserved.
//
// This class is for saving data to the database

import UIKit
import Parse

class DBSavingFunctions {
    
    //Saving Data related to the user sharing the app to their friends
    func sharedNecter(recipients: [String]?) {
        if let user = PFUser.current() {
            //Increments the number of times the user has shared necter
            user.incrementKey("num_shared_necter")
            
            //Saves the recipients the user shared the app to in shared_to field in _User table
            if let recipients = recipients {
                if let currentSharedTo = user["shared_to"] as? [String] {
                    let newSharedTo = currentSharedTo + recipients
                    user["shared_to"] = newSharedTo
                } else {
                    user["shared_to"] = recipients
                }
            }
            user.saveInBackground()
        }
    }
    
    //decrease the badgeCount by 1
    static func decrementBadge() {
		PFCloudFunctions().updateApplicationBadge();

        let currentBadgeCount = UIApplication.shared.applicationIconBadgeNumber
        var newBadgeCount = currentBadgeCount - 1
        //making sure badge count doesn't go below 0
        if newBadgeCount < 0 {
            newBadgeCount = 0
        }
        let installation = PFInstallation.current()
        installation.badge = newBadgeCount
        installation.saveInBackground()
        print("installation badge should have changed")
    }
}
