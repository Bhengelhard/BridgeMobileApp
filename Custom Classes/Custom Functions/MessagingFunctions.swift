//
//  MessagingFunctions.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 1/19/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Foundation
import Parse

class MessagingFunctions {
    
//    var singleMessageId = ""
//    var necterTypeColor = UIColor()
//    var segueToSingleMessage = false
//    var singleMessageTitle = ""
    var vc = UIViewController()

    func createDirectMessage(otherUserObjectId: String, otherUserName: String, otherUserProfilePictureURL: String, vc: UIViewController) {
        self.vc = vc
        
        print("creating direct Message")
        //Checking if message with paired user's already exists
        let messagesQuery = PFQuery(className: "Messages")
        let currentUserObjectId = PFUser.current()?.objectId
        let optionsForIdsInMessage = [[currentUserObjectId, otherUserObjectId], [otherUserObjectId, currentUserObjectId]]
        messagesQuery.whereKey("ids_in_message", containedIn: optionsForIdsInMessage)
        messagesQuery.getFirstObjectInBackground(block: { (object, error) in
            if let object = object {
                print("message with these users already exists so send users to that message")
                //message with these users already exists so send users to that message
                //Transition to single message
                if let messageId = object.objectId {
                    if let type = object["message_type"] as? String {
                        let color = self.whichColor(type: type)
                        if let bridgeVC = vc as? BridgeViewController {
                            if let user1ObjectId = object["user1_objectId"] as? String {
                                if user1ObjectId != PFUser.current()?.objectId {
                                    if let name = object["user1_name"] as? String {
                                        bridgeVC.transitionToMessageWithID(messageId, color: color, title: name)
                                    }
                                } else {
                                    if let name = object["user2_name"] as? String {
                                        bridgeVC.transitionToMessageWithID(messageId, color: color, title: name)
                                    }
                                    
                                }
                            } else {
                                if let name = object["user2_name"] as? String {
                                    bridgeVC.transitionToMessageWithID(messageId, color: color, title: name)
                                }
                            }
                        } else if let otherProfileVC = vc as? OtherProfileViewController {
                            //Transition to single message
                            if let user1ObjectId = object["user1_objectId"] as? String {
                                if user1ObjectId != PFUser.current()?.objectId {
                                    if let name = object["user1_name"] as? String {
                                        otherProfileVC.transitionToMessageWithID(messageId, color: color, title: name)
                                    }
                                } else {
                                    if let name = object["user2_name"] as? String {
                                        otherProfileVC.transitionToMessageWithID(messageId, color: color, title: name)
                                    }
                                    
                                }
                            } else {
                                if let name = object["user2_name"] as? String {
                                    otherProfileVC.transitionToMessageWithID(messageId, color: color, title: name)
                                }
                            }
                        }
                    }
                }
            } else {
                //print(error ?? "There were no such objects")
                print("message does not yet exist so create new message")
                //message does not yet exist so create new message
                //Creating new message
                let message = PFObject(className: "Messages")
                let acl = PFACL()
                acl.getPublicReadAccess = true
                acl.getPublicWriteAccess = true
                message.acl = acl
                
                //Setting values in message
                //Setting userNames in message
                let user1ObjectId = currentUserObjectId
                var user1Name = ""
                var user1ProfilePictureURL = ""
                let user2Name = otherUserName
                let user2ObjectId = otherUserObjectId
                let user2ProfilePictureURL = otherUserProfilePictureURL
                message["bridge_builder"] = currentUserObjectId
                
                //setting items for currentUser
                if let user = PFUser.current() {
                    if let name = user["name"] as? String {
                        user1Name = name
                    }
                    if let URL = user["profile_picture_url"] as? String {
                        user1ProfilePictureURL = URL
                    }
                }
                
                //Setting objectIds
                message["ids_in_message"] = [user1ObjectId, user2ObjectId]
                message["user1_objectId"] = user1ObjectId
                message["user2_objectId"] = user2ObjectId
                
                //Setting names
                message["user1_name"] = user1Name
                message["user2_name"] = user2Name
                message["names_in_message"] = [user1Name, user2Name]
                
                //Setting Profile Picture URLs
                message["user1_profile_picture_url"] = user1ProfilePictureURL
                message["user2_profile_picture_url"] = user2ProfilePictureURL
                message["profile_picture_urls"] = [user1ProfilePictureURL, user2ProfilePictureURL]
                
                message["no_of_single_messages"] = 1
                
                //Setting todays date as the date of creation
                message["lastSingleMessageAt"] = Date()
                
                message["bridge_builder"] = currentUserObjectId
                let bridgeType = "Friendship"
                message["message_type"] = bridgeType
                message["message_viewed"] = [currentUserObjectId]
                
                print("about to save")
                message.saveInBackground(block: { (succeeded: Bool, error: Error?) in
                    if error != nil {
                        print("message was not save")
                        print(error ?? "error save newly created message")
                    } else if succeeded {
                        print("Saved message")
                        
                        //Reload MessagesVC and transition to single message
                        if let messageId = message.objectId {
                            let color = self.whichColor(type: bridgeType)
                            if let bridgeVC = vc as? BridgeViewController {
                                    //Transition to single message
                                    if user1ObjectId == currentUserObjectId {
                                        print("time for transition 1")
                                        bridgeVC.transitionToMessageWithID(messageId, color: color, title: user2Name)
                                    } else {
                                        print("time for transition 2")
                                        bridgeVC.transitionToMessageWithID(messageId, color: color, title: user1Name)
                                    }
                            } else if let otherProfileVC = vc as? OtherProfileViewController {
                                //Transition to single message
                                if user1ObjectId == currentUserObjectId {
                                    print("time for transition 1")
                                    otherProfileVC.transitionToMessageWithID(messageId, color: color, title: user2Name)
                                } else {
                                    print("time for transition 2")
                                    otherProfileVC.transitionToMessageWithID(messageId, color: color, title: user1Name)
                                }
                            }
                        }
                        
                    }
                    
                })
            }
        })
    }
    
    func whichColor(type: String) -> UIColor{
        if type == "Business" {
            return DisplayUtility.businessBlue
        } else if type == "Love" {
            return DisplayUtility.loveRed
        } else if type == "Friendship" {
            return DisplayUtility.friendshipGreen
        } else {
            return DisplayUtility.friendshipGreen
        }
    }
    
//    //Segueing the the appropriate message
//    func transitionToMessageWithID(id: String, color: UIColor, title: String) {
//        if let otherProfileVC = vc as? OtherProfileViewController {
//            
//        } else if let bridgeVC = vc as? BridgeViewController {
//            print("is in bridgeViewController")
//            print(id)
//            print(color)
//            bridgeVC.messageId = id
//            bridgeVC.necterTypeColor = color
//            bridgeVC.singleMessageTitle = title
//            bridgeVC.performSegue(withIdentifier: "showThread", sender: self)
//        }
//    }
    
//    func createNewMessageFromBridgePairing(pairObjectId: String) {
//        //Saving user's decision to accept
//        let query: PFQuery = PFQuery(className: "BridgePairings")
//        query.getObjectInBackground(withId: pairObjectId) { (result, error) in
//            if let error = error {
//                print("refresh findObjectsInBackgroundWithBlock error - \(error)")
//            } else if let result = result {
//                
//                //Checking if message with paired user's already exists
//                if let bridgePairObjectIds = result["user_objectIds"] as? [String] {
//                    let messagesQuery = PFQuery(className: "Messages")
//                    let optionsForIdsInMessage = [bridgePairObjectIds, bridgePairObjectIds.reversed()]
//                    messagesQuery.whereKey("ids_in_message", containedIn: optionsForIdsInMessage)
//                    messagesQuery.getFirstObjectInBackground(block: { (object, error) in
//                        if error != nil {
//                            print(error ?? "Error in MessagingFunctions createNewMessage messagesQuery")
//                        } else if object != nil {
//                            print("message with these users already exists so send users to that message")
//                            //message with these users already exists so send users to that message
//                        } else {
//                            print("message does not yet exist so create new message")
//                            //message does not yet exist so create new message
//                            //Creating new message
//                            let message = PFObject(className: "Messages")
//                            let acl = PFACL()
//                            acl.getPublicReadAccess = true
//                            acl.getPublicWriteAccess = true
//                            message.acl = acl
//                            
//                            //Setting values in message
//                            //Setting userNames in message
//                            let user1Name = result["user1_name"]
//                            let user2Name = result["user2_name"]
//                            message["user1_name"] = user1Name
//                            message["user2_name"] = user2Name
//                            message["names_in_message"] = [user1Name, user2Name]
//                            
//                            //Setting objectIds
//                            let user1ObjectId = result["user_objectId1"]
//                            let user2ObjectId = result["user_objectId2"]
//                            message["ids_in_message"] = [user1ObjectId, user2ObjectId]
//                            message["user1_objectId"] = user1ObjectId
//                            message["user2_objectId"] = user2ObjectId
//                            
//                            let bridgeType = result["bridge_type"]
//                            message["message_type"] = bridgeType
//                            message["no_of_single_messages"] = 1
//                            
//                            //Setting profile pictures
//                            let user1ProfilePictureURL = result["user1_profile_picture_url"]
//                            let user2ProfilePictureURL = result["user2_profile_picture_url"]
//                            message["user1_profile_picture_url"] = user1ProfilePictureURL
//                            message["user2_profile_picture_url"] = user2ProfilePictureURL
//                            message["profile_picture_urls"] = [user1ProfilePictureURL, user2ProfilePictureURL]
//                            
//                            //Setting todays date as the date of creation
//                            message["lastSingleMessageAt"] = Date()
//                            
//                            message["message_viewed"] = [String]()
//                            message["bridge_builder"] = result["connecter_objectId"]
//                            
//                            message["message_type"] = result["connected_bridge_type"]
//                            message["message_viewed"] = [PFUser.current()?.objectId]
//                            message.saveInBackground(block: { (succeeded: Bool, error: Error?) in
//                                if error != nil {
//                                    print(error!)
//                                } else if succeeded {
//                                    //Transition to single message
//                                    if let messageId = message.objectId {
//                                        if let type = bridgeType as? String {
//                                            let color = self.whichColor(type: type)
//                                            if let id = user1ObjectId as? String {
//                                                if id != PFUser.current()?.objectId {
//                                                    if let name = user1Name as? String {
//                                                        self.transitionToMessageWithID(id: messageId, color: color, title: name)
//                                                    }
//                                                } else {
//                                                    if let name = user2Name as? String {
//                                                        self.transitionToMessageWithID(id: messageId, color: color, title: name)
//                                                    }
//                                                    
//                                                }
//                                            } else {
//                                                if let name = user2Name as? String {
//                                                    self.transitionToMessageWithID(id: messageId, color: color, title: name)
//                                                }
//                                            }
//                                        }
//                                    }
//                                }
//                                
//                            })
//                            
//                        }
//                    })
//                }
//            }
//        }
//    }
    
    
    //    func otherStuff(){
    //        //decrease the badgeCount by 1
    //        if let currentUserResponse = result["\(self.newMatch.user)_response"] as? Int {
    //            if currentUserResponse == 0 {
    //                DBSavingFunctions.decrementBadge()
    //            }
    //        } else {
    //            DBSavingFunctions.decrementBadge()
    //        }
    //
    //        //setting currentUser's response to 1 after acceptance
    //        result["\(self.newMatch.user)_response"] = 1
    //        let otherUser = self.newMatch.user == "user1" ? "user2" : "user1"
    //        result.saveInBackground()
    //
    //        //checking if other user has already accepted
    //        if result["\(otherUser)_response"] as! Int == 1 {
    //            //createNewMessage
    //        }
    //    //Adding users to eachothers FriendLists
    //    let pfCloudFunctions = PFCloudFunctions()
    //    pfCloudFunctions.addIntroducedUsersToEachothersFriendLists(parameters: ["userObjectId1": userObjectId1, "userObjectId2": userObjectId2])
    //    
    //    //Close current View with fade
    //    self.phaseOut()
    //
    //    }
    
}
