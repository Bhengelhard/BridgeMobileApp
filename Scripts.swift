//
//  Scripts.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 5/4/17.
//  Copyright © 2017 Parse. All rights reserved.
//

//import Parse
//
//class Scripts {
//    static func removeFromAllShownTos(userID: String) {
//        print("removing \(userID) from all shown_tos...")
//        
//        let query = PFQuery(className: "BridgePairings")
//        query.whereKey("shown_to", contains: userID)
//        query.limit = 100000
//        
//        query.findObjectsInBackground { (objects, error) in
//            if let error = error {
//                print("error - finding bridge pairings - \(error)")
//            } else if let objects = objects {
//                print("\(objects.count) objects")
//                for object in objects {
//                    if var shownTo = object["shown_to"] as? [String] {
//                        if let index = shownTo.index(of: userID) {
//                            shownTo.remove(at: index)
//                            object["shown_to"] = shownTo
//                            object.saveInBackground()
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    static func changeAllWithSingleMessageToHasPosted() {
//        let query = PFQuery(className: "Messages")
//        query.whereKeyExists("last_single_message")
//
//        query.limit = 10000
//        query.findObjectsInBackground { (objects, error) in
//            if error == nil {
//                if let objects = objects {
//                    for object in objects {
//                        object["user1_has_posted"] = true
//                        object["user2_has_posted"] = true
//                        object.saveInBackground()
//                    }
//                }
//                
//            }
//        }
//    }
//}
