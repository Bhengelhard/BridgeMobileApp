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
    
    //running app metrics scraper
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
    
    func addIntroducedUsersToEachothersFriendLists(parameters: [AnyHashable: Any]?) {
        PFCloud.callFunction(inBackground: "addIntroducedUsersToEachothersFriendLists", withParameters: parameters, block: { (response: Any?, error: Error?) in
            if error == nil {
                if let response = response as? String {
                    print(response)
                }
            }
        })
    }
    
    func pushNotification(parameters: [AnyHashable: Any]?) {
        PFCloud.callFunction(inBackground: "pushNotification", withParameters: parameters, block: {
            (response: Any?, error: Error?) in
            if error == nil {
                if let response = response as? String {
                    print(response)
                }
            }
        })
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
}