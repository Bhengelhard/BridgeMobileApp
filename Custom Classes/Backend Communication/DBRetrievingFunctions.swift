//
//  DBRetrievingFunctions.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 1/9/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Foundation
import Parse

class DBRetrievingFunctions {
    
    //Checking to see if user has been matched
    func queryForCurrentUserMatches(vc: UIViewController) {
        let currentUserMatchesQuery = PFQuery(className: "BridgePairings")
        currentUserMatchesQuery.whereKey("bridged", equalTo: true)
        currentUserMatchesQuery.whereKey("user_objectIds", contains: PFUser.current()?.objectId)
        currentUserMatchesQuery.whereKeyExists("connecter_name")
        currentUserMatchesQuery.whereKey("you_matched_notification_viewed", notEqualTo: true)
        currentUserMatchesQuery.limit = 10000
        currentUserMatchesQuery.findObjectsInBackground(block: { (results, error) -> Void in
            if let error = error {
                print("refresh findObjectsInBackgroundWithBlock error - \(error)")
            }
            else if let results = results {
                print(results.count)
            
                for result in results {
                    
                    var currentUserObjectId = ""
                    if let currentUserId = PFUser.current()?.objectId {
                        currentUserObjectId = currentUserId
                    }
                    
                    // Finding whether the current user is the first or the second user in the BridgePairing Table
                    var otherUserNum = ""
                    
                    
                    var otherUserObjectId = ""
                    if let user1_objectId = result["user_objectId1"] as? String {
                        if user1_objectId != currentUserObjectId {
                            otherUserNum = "user1"
                            otherUserObjectId = user1_objectId
                        }
                    }
                    if let user2_objectId = result["user_objectId2"] as? String {
                        if user2_objectId != currentUserObjectId {
                            otherUserNum = "user2"
                            otherUserObjectId = user2_objectId
                        }
                    }
                    
                    //These force unwraps need to be removed
                    var otherUserName = ""
                    if otherUserNum != "" {
                        if let name = result["\(otherUserNum)_name"] as? String {
                                otherUserName = name
                        }
                    }
                    
                    //var connecterName = ""
                    //if let name = result["connecter_name"] as? String {
                    //    connecterName = name
                    //}
                    
                    let connectionsConversedPopup = PopupView(user1Id: currentUserObjectId, user2Id: otherUserObjectId, textString: "\(otherUserName) and \(otherUserName) conversed! Way to create a friendship!", titleImage: #imageLiteral(resourceName: "You_Matched"), user1Image: nil, user2Image: nil)
                    vc.view.addSubview(connectionsConversedPopup)
                    connectionsConversedPopup.autoPinEdgesToSuperviewEdges()
                    
                    result["you_matched_notification_viewed"] = true
                    result.saveInBackground()

                    break
                }
            }
        })
    }

    
    //Checking to see if user's nects have conversed for the first time
    func queryForConnectionsConversed(vc: UIViewController) {
        let connectionsConversedQuery = PFQuery(className: "Messages")
        connectionsConversedQuery.whereKey("bridge_builder", equalTo: PFUser.current()?.objectId)
        connectionsConversedQuery.whereKeyExists("last_single_message")
        connectionsConversedQuery.whereKey("connection_conversed_notification_viewed", notEqualTo: true)
        connectionsConversedQuery.findObjectsInBackground { (objects, error) in
            if error != nil {
                print(error ?? "There was an error in DBRetrievingFunctions.queryForConnectionsConversed")
            } else {
                print("query ran")
                
                if let objects = objects {
                    print(" objects acquired")
                    
                    for object in objects {
                        
                        if let user1Name = object["user1_name"] as? String,
                            let user1ObjectId = object["user1_objectId"] as? String,
                            let user2Name = object["user2_name"] as? String,
                            let user2ObjectId = object["user2_objectId"] as? String {
                            print(user1Name)
                            print(user1ObjectId)
                            print(user2Name)
                            print(user2ObjectId)
                            
                            let connectionsConversedPopup = PopupView(user1Id: user1ObjectId, user2Id: user2ObjectId, textString: "\(user1Name) and \(user2Name) conversed!", titleImage: #imageLiteral(resourceName: "Sweet_Nect"), user1Image: nil, user2Image: nil)
                            vc.view.addSubview(connectionsConversedPopup)
                            connectionsConversedPopup.autoPinEdgesToSuperviewEdges()
                            
                            object["connection_conversed_notification_viewed"] = true
                            object.saveInBackground()
                            
                            break
                        }
                    
                    }
                
                }
            }
        }
    }
}
