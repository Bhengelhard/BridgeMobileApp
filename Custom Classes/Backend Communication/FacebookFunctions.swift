//
//  FacebookFunctions.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 12/16/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import ParseFacebookUtilsV4
import FBSDKLoginKit



class FacebookFunctions {
    
    var geoPoint:PFGeoPoint?
    
    //Login User after they click the login with facebook button
    func loginWithFacebook (vc: UIViewController){
        var global_name:String = ""
        
        let localData = LocalData()
        
        //setting first Time Swiping Right to true so the user will be notified of what swiping does for their first swipe
        localData.setFirstTimeSwipingRight(true)
        
        //setting first Time SwipingRight to true so the user will be notified of what swiping does for their first swipe
        localData.setFirstTimeSwipingLeft(true)
        
        //setting hasSignedUp to false so the user will be sent back to the signUp page if they have not completed signing up
        let hasSignedUp:Bool = localData.getHasSignedUp() ?? false
        localData.setHasSignedUp(hasSignedUp)
        localData.synchronize()
        
        //Log user in with permissions public_profile, email and user_friends
        let permissions = ["public_profile", "email", "user_friends"]
        PFFacebookUtils.logInInBackground(withReadPermissions: permissions) { (user, error) in
            print("got past permissions")
            if let error = error {
                print(error)
                print("got to error")
            } else {
                if let user = user {
                    print("got user")
                    /* Check if the global variable geoPoint has been set to the user's location. If so, store it in Parse. Extremely important since the location would be used to get the user's current city in LocalUtility().getBridgePairings() which is indeed called in SignupViewController - cIgAr 08/18/16 */
                    if let geoPoint = self.geoPoint {
                        PFUser.current()?["location"] = geoPoint
                        PFUser.current()?.saveInBackground()
                    }
                    // identify user id with the device
                    let installation = PFInstallation.current()
                    //installation.setDeviceTokenFromData(deviceToken)
                    installation["user"] = PFUser.current()
                    installation["userObjectId"] = PFUser.current()?.objectId
                    installation.saveInBackground()
                    
                    LocalStorageUtility().getUserFriends()
                    
                    if user.isNew {
                        
                        //sync profile picture with facebook profile picture
                        LocalStorageUtility().getMainProfilePicture()
                        
                        print("got to new user")
                        let localData = LocalData()
                        
                        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, interested_in, name, gender, email, friends, birthday, location"])
                        graphRequest!.start { (connection, result, error) -> Void in
                            print("got into graph request")
                            
                            if error != nil {
                                
                                print(error)
                                print("got error")
                                
                            } else if let result = result as? [String: AnyObject]{
                                // saves these to parse at every login
                                print("got result")
                                var hasInterestedIn = false
                                if let interested_in = result["interested_in"] {
                                    localData.setInterestedIN(interested_in as! String)
                                    PFUser.current()?["interested_in"] = interested_in
                                    hasInterestedIn = true
                                }
                                
                                
                                if let gender: String = result["gender"]! as? String {
                                    PFUser.current()?["gender"] = gender
                                    PFUser.current()?["fb_gender"] = gender
                                    //saves a guess at the gender the current user is interested in if it doesn't already exist
                                    if hasInterestedIn == false {
                                        if gender == "male" {
                                            PFUser.current()?["interested_in"] = "female"
                                        } else if gender == "female" {
                                            PFUser.current()?["interested_in"] = "male"
                                        }
                                    }
                                }
                                
                                //setting main name and names for Bridge Types to Facebook name
                                if let name = result["name"] {
                                    global_name = name as! String
                                    // Store the name in core data 06/09
                                    localData.setUsername(global_name)
                                    PFUser.current()?["fb_name"] = name
                                    PFUser.current()?["name"] = name
                                    //PFUser.current()?["business_name"] = name
                                    //PFUser.current()?["love_name"] = name
                                    //PFUser.current()?["friendship_name"] = name
                                }
                                if let email = result["email"] {
                                    PFUser.current()?["email"] = email
                                }
                                if let id = result["id"] {
                                    PFUser.current()?["fb_id"] =  id
                                }
                                
                                if let birthday = result["birthday"] {
                                    print(result["birthday"]!)
                                    print("birthday")
                                    //getting birthday from Facebook and calculating age
                                    PFUser.current()?["fb_birthday"] = birthday
                                    
                                    //getting age from Birthday
                                    let NSbirthday: Date = birthday as! Date
                                    let calendar: Calendar = Calendar.current
                                    let now = Date()
                                    let age = (calendar as NSCalendar).components(.year, from: NSbirthday, to: now, options: [])
                                    print(age)
                                    PFUser.current()?["age"] = age
                                }
                                
                                //Getting user friends from facebook and then updating the friend_list
                                if let friends = result["friends"]! as? NSDictionary {
                                    let friendsData : NSArray = friends.object(forKey: "data") as! NSArray
                                    var fbFriendIds = [String]()
                                    for friend in friendsData {
                                        let valueDict : NSDictionary = friend as! NSDictionary
                                        fbFriendIds.append(valueDict.object(forKey: "id") as! String)
                                    }
                                    PFUser.current()?["fb_friends"] = fbFriendIds
                                    PFUser.current()?.saveInBackground(block: { (success, error) in
                                        if error != nil {
                                            print(error)
                                        } else {
                                            self.updateFriendList()
                                        }
                                    })
                                }
                                
                                
                                PFUser.current()?["distance_interest"] = 100
                                PFUser.current()?["new_message_push_notifications"] = true
                                localData.setNewMessagesPushNotifications(true)
                                PFUser.current()?["new_bridge_push_notifications"] = true
                                localData.setNewBridgesPushNotifications(true)
                                PFUser.current()?["built_bridges"] = []
                                PFUser.current()?["rejected_bridges"] = []
                                PFUser.current()?["interested_in_business"] = true
                                PFUser.current()?["interested_in_love"] = true
                                PFUser.current()?["interested_in_friendship"] = true
                                PFUser.current()?["ran_out_of_pairs"] = 0
                                
                                PFUser.current()?.saveInBackground()
                                
                                //setting hasSignedUp to false so the user will be sent back to the signUp page if they have not completed signing up
                                localData.setHasSignedUp(false)
                                localData.synchronize()
                                
                                PFUser.current()?.saveInBackground(block: { (success, error) in
                                    if success == true {
                                        //self.activityIndicator.stopAnimating()
                                        UIApplication.shared.endIgnoringInteractionEvents()
                                        vc.performSegue(withIdentifier: "showSignUp", sender: self)
                                    } else {
                                        print(error ?? "error")
                                    }
                                })
                            }
                        }
                        
                    } else {
                        //spinner
                        //update user and friends
                        //use while access token is nil instead of delay
                        print("not new")
                        if let _ = (PFUser.current()?["name"]) as? String {
                            let localData = LocalData()
                            localData.setUsername((PFUser.current()?["name"])! as! String)
                            localData.synchronize()
                        }
                        let localData = LocalData()
                        if localData.getMainProfilePicture() == nil {
                            print("user is not new but we are getting his picture")
                            LocalStorageUtility().getMainProfilePictureFromParse()
                        }
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { () -> Void in
                            //stop the spinner animation and reactivate the interaction with user
                            //self.activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                            
                            if hasSignedUp == true {
                                vc.performSegue(withIdentifier: "showBridgeViewController", sender: self)
                            } else {
                               vc.performSegue(withIdentifier: "showSignUp", sender: self)
                            }
                            
                        })
                    }
                    
                    
                    
                } else {
                    print("there is no user")
                    //self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
        }
        
    }
    
    //right now just updates users Friends
    /* Why is this in viewDidAppear? I'm leaving it here for historical reasons - cIgAr - 08/18/16*/
    func updateUser() {
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "friends"])
        graphRequest?.start { (connection, result, error) -> Void in
            if error != nil {
                
                print(error)
                
            } else if let result = result as? [String:AnyObject]{
                
                if let friends = result["friends"]! as? NSDictionary {
                    let friendsData : NSArray = friends.object(forKey: "data") as! NSArray
                    var fbFriendIds = [String]()
                    for friend in friendsData {
                        let valueDict : NSDictionary = friend as! NSDictionary
                        fbFriendIds.append(valueDict.object(forKey: "id") as! String)
                    }
                    PFUser.current()?["fb_friends"] = fbFriendIds
                    PFUser.current()?.saveInBackground(block: { (success, error) in
                        if error != nil {
                            print(error)
                        } else {
                            self.updateFriendList()
                        }
                    })
                }
            }
        }
    }
    
    /* Why is this in viewDidAppear? I'm leaving it here for historical reasons - cIgAr - 08/18/16*/
    func updateFriendList() {
        //add graph request to update users fb_friends
        //query to find and save fb_friends
        
        let currentUserFbFriends = PFUser.current()!["fb_friends"] as! NSArray
        let query: PFQuery = PFQuery(className: "_User")
        
        query.whereKey("fb_id", containedIn: currentUserFbFriends as [AnyObject])
        
        query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
            if error != nil {
                print(error)
            } else if let objects = objects {
                PFUser.current()?.fetchInBackground(block: { (success, error) in
                    for object in objects {
                        var containedInFriendList = false
                        if let friendList: NSArray = PFUser.current()!["friend_list"] as? NSArray {
                            //This was exchanged for the following in Swift3 migration -> containedInFriendList = friendList.contains {$0 as! String == object.objectId!}
                            containedInFriendList = friendList.contains(object.objectId!)
                        }
                        if containedInFriendList == false {
                            if PFUser.current()!["friend_list"] != nil {
                                let currentFriendList = PFUser.current()!["friend_list"]
                                PFUser.current()!["friend_list"] = currentFriendList as! Array + [object.objectId!]
                            } else {
                                PFUser.current()!["friend_list"] = [object.objectId!]
                            }
                        }
                        PFUser.current()?.saveInBackground()
                    }
                })
            }
        })
    }
    
}
