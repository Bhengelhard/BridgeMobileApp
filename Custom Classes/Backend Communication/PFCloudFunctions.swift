//
//  PFCloudFunctions.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 10/14/16.
//  Copyright © 2016 BHE Ventures. All rights reserved.
//
//This class is a helper class to store the PFCloud functions stored in the server-side file main.js

import UIKit
import Parse

class PFCloudFunctions {
    
    // updating the User Table to addUnique photos from the Pictures table to the User's pictures array
    func setMatchesNotificationToViewed(parameters: [AnyHashable: Any]?) {
        PFCloud.callFunction(inBackground: "setMatchesNotificationToViewed", withParameters: parameters, block: {
            (response: Any?, error: Error?) in
            if error == nil {
                if let response = response as? String {
                    print(response)
                } else {
                    
                }
            }
        })
    }
    
    /// updating the Pictures Table to include the current user's photos
    func scriptToSetUpPicturesTable(parameters: [AnyHashable: Any]?) {
        PFCloud.callFunction(inBackground: "scriptToSetUpPicturesTable", withParameters: parameters, block: {
            (response: Any?, error: Error?) in
            if error == nil {
                if let response = response as? String {
                    print(response)
                } else {
                    
                }
            }
        })
    }
    
    /// updating the bridgePairings Table to include the current user upon signUp
    func updateBridgePairingsTable(parameters: [AnyHashable: Any]?) {
        PFCloud.callFunction(inBackground: "updateBridgePairingsTable", withParameters: parameters, block: {
            (response: Any?, error: Error?) in
            if error == nil {
                if let response = response as? String {
                    print(response)
                } else {
                    
                }
            }
        })
    }
    
    /// running app metrics scraper
    func getMainAppMetrics(parameters: [AnyHashable: Any]?) {
        PFCloud.callFunction(inBackground: "getMainAppMetrics", withParameters: parameters, block: {
            (response: Any?, error: Error?) in
            if error == nil {
                if let response = response as? String {
                    print(response)
                } else {
                    
                }
            }
        })
    }
    
    func revitalizeMyPairs(parameters: [AnyHashable: Any]?) {
        PFCloud.callFunction(inBackground: "revitalizeMyPairs", withParameters: parameters, block: {
            (response: Any?, error: Error?) in
            if error == nil {
                if let response = response as? String {
                    print(response)
                    //sends notification to call displayMessageFromBot function
                    let userInfo = ["message" : "Your pairs were revitalized"]
                    //self.didSendPost = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "revitalizeMyPairsHelper"), object: nil, userInfo: userInfo)
                } else {
                    //sends notification to call displayMessageFromBot function
                    let userInfo = ["message" : "Your pairs did not revitalize"]
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "revitalizeMyPairsHelper"), object: nil, userInfo: userInfo)
                }
            }
        })
    }
    
    //This function adds the users to eachother's friend lists
    static func addIntroducedUsersToEachothersFriendLists(parameters: [AnyHashable: Any]?) {
        PFCloud.callFunction(inBackground: "addIntroducedUsersToEachothersFriendLists", withParameters: parameters, block: { (response: Any?, error: Error?) in
            if error == nil {
                if let response = response as? String {
                    print(response)
                }
            }
        })
    }
    
    //This function removes the users from eachother's friend lists
    func removeUsersFromEachothersFriendLists(parameters: [AnyHashable: Any]?) {
        PFCloud.callFunction(inBackground: "removeUsersFromEachothersFriendLists", withParameters: parameters, block: { (response: Any?, error: Error?) in
            if error == nil {
                if let response = response as? String {
                    print(response)
                }
            }
        })
    }
    
    static func pushNotification(parameters: [AnyHashable: Any]?) {
        print("push notification called")
        PFCloud.callFunction(inBackground: "pushNotification", withParameters: parameters, block: {
            (response: Any?, error: Error?) in
            if error == nil {
                if let response = response as? String {
                    print(response)
                }
            }
        })
    }

	/// Request that the server update the application badge using a push notification
	static func updateApplicationBadge () {
		PFCloud.callFunction(inBackground: "applicationBadgePushNotification", 
		                     withParameters: ["userObjectID": PFUser.current()!.objectId!])
	}
    
    func changeBridgePairingsOnStatusUpdate(parameters: [AnyHashable: Any]?) {
        PFCloud.callFunction(inBackground: "changeBridgePairingsOnStatusUpdate", withParameters: parameters, block: {
            (response:Any?, error: Error?) in
            if error == nil {
                if let response = response as? String {
                    print(response)
                }
            }
        })
    }
    
    func changeBridgePairingsOnProfilePictureUpdate(parameters: [AnyHashable: Any]?) {
        PFCloud.callFunction(inBackground: "changeBridgePairingsOnProfilePictureUpdate", withParameters: [:], block: {
            (response:Any?, error: Error?) in
            if error == nil {
                if let response = response as? String {
                    print(response)
                }
            }
        })
    }
    
    func changeMessagesTableOnNameUpdate(parameters: [AnyHashable: Any]?) {
        PFCloud.callFunction(inBackground: "changeMessagesTableOnNameUpdate", withParameters: [:], block: {
            (response:Any?, error: Error?) in
            if error == nil {
                if let response = response as? String {
                    print(response)
                    print("changeMessagesTableOnNameUpdate")
                }
            }
        })
    }
    
    func changeSingleMessagesTableOnNameUpdate(parameters: [AnyHashable: Any]?) {
        PFCloud.callFunction(inBackground: "changeSingleMessagesTableOnNameUpdate", withParameters: [:], block: {
            (response:Any?, error: Error?) in
            if error == nil {
                if let response = response as? String {
                    print(response)
                    print("changeSingleMessagesTableOnNameUpdate")
                }
            }
        })
    }
    
    func changeBridgePairingsOnNameUpdate(parameters: [AnyHashable: Any]?) {
        PFCloud.callFunction(inBackground: "changeBridgePairingsOnNameUpdate", withParameters: [:], block: {
            (response:Any?, error: Error?) in
            if error == nil {
                if let response = response as? String {
                    print(response)
                    print("changeBridgePairingsOnNameUpdate")
                }
            }
        })
    }
    
    func changeBridgePairingsOnInterestedInUpdate(parameters: [AnyHashable: Any]?) {
        PFCloud.callFunction(inBackground: "changeBridgePairingsOnInterestedInUpdate", withParameters: [:], block: {
            (response:Any?, error: Error?) in
            if error == nil {
                if let response = response as? String {
                    print("changeBridgePairingsOnInterestedInUpdate")
                    print(response)
                }
            }
        })
    }
    
    func updateUserTableToHaveURLS(parameters: [AnyHashable: Any]?) {
        PFCloud.callFunction(inBackground: "updateUserTableToHaveURLS", withParameters: [:], block: {
            (response:Any?, error: Error?) in
            if error == nil {
                if let response = response as? String {
                    print("updateUserTableToHaveURLS")
                    print(response)
                }
            }
        })
    }
    
    // Add a user to the currentUser's friendList
    func addOtherUserToFriendList(parameters: [AnyHashable: Any]?) {
        PFCloud.callFunction(inBackground: "addOtherUserToFriendList", withParameters: [:], block: {
            (response:Any?, error: Error?) in
            if error == nil {
                if let response = response as? String {
                    print("addOtherUserToFriendList")
                    print(response)
                }
            }
        })
    }
    
    func addProfilePicturesBackForUser2(parameters: [AnyHashable: Any]?) {
        PFCloud.callFunction(inBackground: "addProfilePicturesBackForUser2", withParameters: [:], block: {
            (response:Any?, error: Error?) in
            if error == nil {
                if let response = response as? String {
                    print("addProfilePicturesBackForUser2")
                    print(response)
                }
            }
        })
    }
    func addProfilePicturesBackForUser1(parameters: [AnyHashable: Any]?) {
        PFCloud.callFunction(inBackground: "addProfilePicturesBackForUser1", withParameters: [:], block: {
            (response:Any?, error: Error?) in
            if error == nil {
                if let response = response as? String {
                    print("addProfilePicturesBackForUser1")
                    print(response)
                }
            }
        })
    }
    func changeBridgePairingsOnInterestedInUpdateForUser(parameters: [AnyHashable: Any]?) {
        PFCloud.callFunction(inBackground: "changeBridgePairingsOnInterestedInUpdateForUser", withParameters: parameters, block: {
            (response:Any?, error: Error?) in
            if error == nil {
                if let response = response as? String {
                    print("changeBridgePairingsOnInterestedInUpdateForUser")
                    print(response)
                }
            }
        })
    }
}
