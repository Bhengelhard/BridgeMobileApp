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
//    
//    static func randomizeBridgeScores() {
//        print("randomize bridge scores called")
//        let query = PFQuery(className: "BridgePairings")
//        query.whereKey("Bridged", notEqualTo: true)
//        query.whereKey("score", equalTo: 0)
//        
//        query.limit = 10000
//        query.findObjectsInBackground { (objects, error) in
//            if error == nil {
//                if let objects = objects {
//                    var countOfSaved = 0
//                    var i = 0
//                    print("objects count \(objects.count)")
//                    for object in objects {
//                        object["score"] = i
//                        object.saveInBackground(block: { (success, error) in
//                            countOfSaved += 1
//                            
//                            if success {
//                                print("Count of Saved - \(countOfSaved)")
//                            }
//                        })
//                        
//                        print("i is \(i)")
//                        i += 1
//                        i = i%500
//                    }
//                }
//            }
//        }
//        
//    }
//    
//    
//    static func increaseSameCityBridgeScores() {
//        print("increaseSameCityBridgeScores called")
//        let query = PFQuery(className: "BridgePairings")
//        query.whereKey("Bridged", notEqualTo: true)
//        query.whereKeyExists("user1_city")
//        query.whereKeyExists("user2_city")
//        
//        query.limit = 10000
//        query.findObjectsInBackground { (objects, error) in
//            if error == nil {
//                if let objects = objects {
//                    var countOfSaved = 0
//                    var i = 1
//                    print("objects count \(objects.count)")
//                    for object in objects {
//                        if let user2City = object["user2_city"] as? String {
//                            if let user1City = object["user1_city"] as? String {
//                                if user2City == user1City {
//                                    print("i is \(i)")
//                                    object["score"] = i+499
//                                    object.saveInBackground(block: { (success, error) in
//                                        if success {
//                                            countOfSaved += 1
//                                            print("Count of Saved - \(countOfSaved)")
//                                        }
//                                    })
//                                }
//                            }
//                        }
//                        i += 1
//                        i = i%500
//                    }
//                }
//            }
//        }
//        
//    }
//}
