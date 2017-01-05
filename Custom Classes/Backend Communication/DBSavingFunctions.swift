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
    
    let localData = LocalData()
    
    // Connect two users in the app so they can accept/ignore the introduction
    func bridgeUsers(messageText: String, type: String) {
        print("Bridge Users")
        let bridgeVC = BridgeViewController()
        
        let bridgePairings = localData.getPairings()
        if var bridgePairings = bridgePairings {
            var x = 0
            for i in 0 ..< (bridgePairings.count) {
                if bridgeVC.currentTypeOfCardsOnDisplay == .all || bridgePairings[x].user1?.bridgeType == bridgeVC.convertBridgeTypeEnumToBridgeTypeString(bridgeVC.currentTypeOfCardsOnDisplay) {
                    break
                }
                x = i
            }
            
            //id of the BridgePairing
            let objectId = bridgePairings[x].user1?.objectId
            
            //Push Notification Messages
            let pfCloudFunctions = PFCloudFunctions()
            let notificationMessage1 = PFUser.current()!["name"] as! String + " has connected you with "+bridgePairings[x].user2!.name! + " for " + bridgePairings[x].user2!.bridgeType!
            let notificationMessage2 = PFUser.current()!["name"] as! String + " has connected you with "+bridgePairings[x].user1!.name! + " for " + bridgePairings[x].user2!.bridgeType!
            //Users being connected
            let userObjectId1 = bridgePairings[x].user1!.userId!
            let userObjectId2 = bridgePairings[x].user2!.userId!
 
            
            //Query to Update to BridgePairings Table
            print("objectId is equal to \(objectId)")
            let query = PFQuery(className:"BridgePairings")
            query.getObjectInBackground(withId: objectId!, block: { (result, error) -> Void in
                //Update pair in BridgePairings table fields: checked_out, bridged, connecter_objectId, connecter_name, connecter_profile_picture_url
                if let result = result {
                    result["checked_out"] = true
                    result["bridged"] = true
                    result["connecter_objectId"] = PFUser.current()?.objectId
                    result["connecter_name"] = PFUser.current()?["name"]
                    result["connecter_profile_picture_url"] = PFUser.current()?["profile_picture_url"]
                    result["reason_for_connection"] = messageText
                    result["connected_bridge_type"] = type
                    result["user1_response"] = 0
                    result["user2_response"] = 0
                    result.saveInBackground()
                    
                    //Update pushNotifications for new matches notifications that will bring the user to the accept/ignore page
                    pfCloudFunctions.pushNotification(parameters: ["userObjectId":userObjectId1,"alert":notificationMessage1, "badge": "Increment", "messageType" : "Bridge"])
                    pfCloudFunctions.pushNotification(parameters: ["userObjectId":userObjectId2,"alert":notificationMessage2, "badge": "Increment", "messageType" : "Bridge"])
                }
            })
            
            /*let bridgePairings = localData.getPairings()
             if var bridgePairings = bridgePairings {
             var x = 0
             for i in 0 ..< (bridgePairings.count) {
             if self.currentTypeOfCardsOnDisplay == typesOfCard.all || bridgePairings[x].user1?.bridgeType == convertBridgeTypeEnumToBridgeTypeString(self.currentTypeOfCardsOnDisplay) {
             break
             }
             x = i
             }
             var bridgeType = "All"
             if let bt = bridgePairings[x].user1?.bridgeType {
             bridgeType = bt
             }
             //bridgePairings.remove(at: x)
             localData.setPairings(bridgePairings)
             localData.synchronize()
             //getBridgePairings(1,typeOfCards: bridgeType, callBack: nil, bridgeType: nil)
             }*/
            
            //remove the swipeCard from the BridgeViewController View
            /*bridgePairings.remove(at: x)
            localData.setPairings(bridgePairings)
            localData.synchronize()
            if let bridgeType = bridgePairings[x].user1?.bridgeType {
                bridgeVC.getBridgePairings(1, typeOfCards: bridgeType, callBack: nil, bridgeType: nil)
            }*/
            
        }
        
    }
    
    // Post Statuses to the BridgeStatus Table
    func postStatus(messageText: String, type: String) {
        print("postStatus")
        //setting the status to local data
        if type == "Business" {
            localData.setBusinessStatus(messageText)
            localData.synchronize()
        } else if type == "Love" {
            localData.setLoveStatus(messageText)
            localData.synchronize()
        } else if type == "Friendship" {
            localData.setFriendshipStatus(messageText)
            localData.synchronize()
        }
        
        //saving the status to the database
        let bridgeStatusObject = PFObject(className: "BridgeStatus")
        bridgeStatusObject["bridge_status"] = messageText
        bridgeStatusObject["bridge_type"] = type
        bridgeStatusObject["userId"] = PFUser.current()?.objectId
        bridgeStatusObject.saveInBackground { (success, error) in
            
            if error != nil {
                //sends notification to call displayMessageFromBot function
                let userInfo = ["message" : "Your post did not go through. Please wait a minute and try posting again"]
                NotificationCenter.default.post(name: Notification.Name(rawValue: "displayMessageFromBot"), object: nil, userInfo: userInfo)
            } else if success {
                //sends notification to call displayMessageFromBot function
                let userInfo = ["message" : "Your post is now being shown to friends so they can connect you!"]
                NotificationCenter.default.post(name: Notification.Name(rawValue: "displayMessageFromBot"), object: nil, userInfo: userInfo)
            }
        }
        let pfCloudFunctions = PFCloudFunctions()
        pfCloudFunctions.changeBridgePairingsOnStatusUpdate(parameters: ["status":messageText, "bridgeType":type])
    }
    
    func sendMessage(messageText: String) {
        print("sendMessage")
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
    
    //Creating a message
    /*let bridgePairings = localData.getPairings()
    if var bridgePairings = bridgePairings {
        var x = 0
        for i in 0 ..< (bridgePairings.count) {
            if self.currentTypeOfCardsOnDisplay == typesOfCard.all || bridgePairings[x].user1?.bridgeType == convertBridgeTypeEnumToBridgeTypeString(self.currentTypeOfCardsOnDisplay) {
                break
            }
            x = i
        }
        let message = PFObject(className: "Messages")
        let acl = PFACL()
        acl.getPublicReadAccess = true
        acl.getPublicWriteAccess = true
        message.acl = acl
        
        let currentUserId = PFUser.current()?.objectId
        let currentUserName = (PFUser.current()?["name"] as? String) ?? ""
        message["ids_in_message"] = [(bridgePairings[x].user1?.userId)!, (bridgePairings[x].user2?.userId)!, currentUserId!]
        message["names_in_message"] = [(bridgePairings[x].user1?.name)!, (bridgePairings[x].user2?.name)!, currentUserName]
        let user1FirstName = (bridgePairings[x].user1?.name)!.components(separatedBy: " ").first!
        let user2FirstName = (bridgePairings[x].user2?.name)!.components(separatedBy: " ").first!
        singleMessageTitle = "\(user1FirstName) & \(user2FirstName)"
        message["bridge_builder"] = currentUserId
        var y = [String]()
        y.append(currentUserId as String!)
        message["message_viewed"] = y
        if let necterType = bridgePairings[x].user1?.bridgeType {
            message["message_type"] = necterType
            switch(necterType) {
            case "Business":
                necterTypeColor = DisplayUtility.businessBlue
            case "Love":
                necterTypeColor = DisplayUtility.loveRed
            case "Friendship":
                necterTypeColor = DisplayUtility.friendshipGreen
            default:
                necterTypeColor = DisplayUtility.necterGray
            }
        }
        else {
            message["message_type"] = "Friendship"
        }
        message["lastSingleMessageAt"] = Date()
        // update the no of message in a Thread - Start
        message["no_of_single_messages"] = 1
        var noOfSingleMessagesViewed = [String:Int]()
        noOfSingleMessagesViewed[PFUser.current()!.objectId!] = 1
        message["no_of_single_messages_viewed"] = NSKeyedArchiver.archivedData(withRootObject: noOfSingleMessagesViewed)
        // update the no of message in a Thread - End
        do {
            try message.save()
            let objectId = bridgePairings[x].user1?.objectId
            let query = PFQuery(className:"BridgePairings")
            let notificationMessage1 = PFUser.current()!["name"] as! String + " has connected you with "+bridgePairings[x].user2!.name! + " for " + bridgePairings[x].user2!.bridgeType!
            let notificationMessage2 = PFUser.current()!["name"] as! String + " has connected you with "+bridgePairings[x].user1!.name! + " for " + bridgePairings[x].user2!.bridgeType!
            let userObjectId1 = bridgePairings[x].user1!.userId!
            let userObjectId2 = bridgePairings[x].user2!.userId!
            query.getObjectInBackground(withId: objectId!, block: { (result, error) -> Void in
                //this should only happen if result can equal result - i.e. in the result if let statement, but the code was not allow for this, so it was taken out and should be tested.
                if let result = result as? PFObject?{
                    result?["checked_out"] = true
                    result?["bridged"] = true
                    result?.saveInBackground()
                    //when users are introduced, they are added to eachother's friend_lists in the _User table (i.e. they become friends)
                    //when users both accept, they are added to eachother's friend_lists in the _User table (i.e. they become friends)self.pfCloudFunctions.addIntroducedUsersToEachothersFriendLists(parameters: ["userObjectId1": userObjectId1, "userObjectId2": userObjectId2])
                    self.pfCloudFunctions.pushNotification(parameters: ["userObjectId":userObjectId1,"alert":notificationMessage1, "badge": "Increment", "messageType" : "Bridge", "messageId": message.objectId!])
                    self.pfCloudFunctions.pushNotification(parameters: ["userObjectId":userObjectId2,"alert":notificationMessage2, "badge": "Increment", "messageType" : "Bridge", "messageId": message.objectId!])
                }
            })
            self.messageId = message.objectId!
        }
        catch {
            
        }
        var bridgeType = "All"
        if let bt = bridgePairings[x].user1?.bridgeType {
            bridgeType = bt
        }
        // { Used for nextPair()
        bridgePairings.remove(at: x)
        localData.setPairings(bridgePairings)
        localData.synchronize()
        getBridgePairings(1,typeOfCards: bridgeType, callBack: nil, bridgeType: nil)
        // }
        segueToSingleMessage = true
        performSegue(withIdentifier: "showSingleMessage", sender: nil)
    }*/
    
    
    //Add users to eachothers friendLists after they both accept
    //pfCloudFunctions.addIntroducedUsersToEachothersFriendLists(parameters: ["userObjectId1": userObjectId1, "userObjectId2": userObjectId2])
    
}
