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
    
    //Checking to see if user has any unviewed notifications that a connection they made has accepted
    func queryForAcceptedConnectionNotifications(vc: UIViewController) {
        let acceptedConnectionQuery = PFQuery(className: "BridgePairings")
        acceptedConnectionQuery.whereKey("connecter_objectId", equalTo: PFUser.current()!.objectId!)
        acceptedConnectionQuery.whereKey("user1_response", equalTo: 1)
        acceptedConnectionQuery.whereKey("user2_response", equalTo: 1)
        acceptedConnectionQuery.whereKey("accepted_notification_viewed", notEqualTo: true)
        acceptedConnectionQuery.findObjectsInBackground { (objects, error) in
            if error != nil {
                print(error!)
            } else {
                print("ran the query")
                if let objects = objects {
                    print("objects acquired")
                    for object in objects {
                        print("here is one of the objects")
                        //Get data to pass to acceptedConnectionNotifcation
                        if let acceptedConnectionObjectId = object.objectId {
                            if let user1Name = object["user1_name"] as? String {
                                print(user1Name)
                                if let user1ObjectId = object["user_objectId1"] as? String {
                                    print(user1ObjectId)
                                    if let user1ProfilePictureURL = object["user1_profile_picture_url"] as? String {
                                        print(user1ProfilePictureURL)
                                        if let user2Name = object["user2_name"] as? String {
                                            print(user2Name)
                                            if let user2ObjectId = object["user_objectId2"] as? String {
                                                print(user2ObjectId)
                                                if let user2ProfilePictureURL = object["user2_profile_picture_url"] as? String {
                                                    print(user2ProfilePictureURL)
                                                    let acceptedConnectionNotification = AcceptedConnectionNotification(acceptedConnectionObjectId: acceptedConnectionObjectId, user1Name: user1Name, user1ObjectId: user1ObjectId, user1ProfilePictureURL: user1ProfilePictureURL, user2Name: user2Name, user2ObjectId: user2ObjectId, user2ProfilePictureURL: user2ProfilePictureURL, vc: vc)
                                                    vc.view.addSubview(acceptedConnectionNotification)
                                                    break
                                                }
                                                
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
}
