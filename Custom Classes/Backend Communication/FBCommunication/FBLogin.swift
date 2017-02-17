//
//  FBLogin.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/8/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import ParseFacebookUtilsV4

/// This class handles functions related to the Facebook api
class FBLogin {
    
    var geoPoint:PFGeoPoint?
    var fbFriendIds = [String]()
    
    // MARK: -
    
    //Login User after they click the login with facebook button
    func initialize (vc: UIViewController){
        
        var global_name:String = ""
        
        let fbFunctions = FacebookFunctions()
        let localData = LocalData()
        
        //setting first Time Swiping Right to true so the user will be notified of what swiping does for their first swipe
        localData.setFirstTimeOnBridgeVC(true)
        
        //setting first Time SwipingRight to true so the user will be notified of what swiping does for their first swipe
        localData.setFirstTimeSwipingLeft(true)
        
        //setting hasSignedUp to false so the user will be sent back to the signUp page if they have not completed signing up
        let hasSignedUp:Bool = localData.getHasSignedUp() ?? false
        localData.setHasSignedUp(hasSignedUp)
        localData.synchronize()
        
        //Log user in with permissions public_profile, email and user_friends
        let permissions = ["public_profile", "email", "user_friends", "user_photos", "user_birthday"]
        PFFacebookUtils.logInInBackground(withReadPermissions: permissions) { (user, error) in
            if let error = error {
                print(error)
                print("got to error")
            } else {
                if let user = user {
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
                    
                    // get necessary facebook fields
                    let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, interested_in, name, gender, email, birthday, location"])
                    graphRequest!.start { (connection, result, error) -> Void in
                        if error != nil {
                            
                            print(error!)
                            print("got error")
                            
                        } else if let result = result as? [String: AnyObject]{
                            // saves these to parse at every login
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
                            
                            if let birthday = result["birthday"] as? String {
                                //getting birthday from Facebook and calculating age
                                PFUser.current()?["fb_birthday"] = birthday
                                
                                //getting age from Birthday
                                let formatter = DateFormatter()
                                
                                //formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
                                formatter.locale = Locale(identifier: "en_US_POSIX")
                                formatter.dateFormat = "MM/dd/yyyy"
                                
                                if let NSbirthday = formatter.date(from: birthday) {
                                    let calendar: Calendar = Calendar.current
                                    let now = Date()
                                    //calendar.component(.year, from: NSbirthday)
                                    //let secondsInYear = 365*24*60*60
                                    //let age = Int(now.timeIntervalSince(NSbirthday)) / secondsInYear
                                    if let age = ((calendar as NSCalendar).components(.year, from: NSbirthday, to: now, options: [])).year {
                                        PFUser.current()?["age"] = age
                                    }
                                }
                            }
                            
                            //Adding access code to current user field access_codes to identify which communities the user has joined
                            if let accessVC = vc as? LoginViewController {
                                //Checking if user had to enter an access code -> i.e. HasSignedUp was false before they logged in
                                if !accessVC.accessCode.isEmpty {
                                    PFUser.current()?.addUniqueObject(accessVC.accessCode, forKey: "access_codes")
                                }
                            }
                            
                            PFUser.current()?.saveInBackground()
                        }
                    }
                    
                    if user.isNew {
                        fbFunctions.getProfilePictures()
                        
                        //sync profile picture with facebook profile picture
                        LocalStorageUtility().getMainProfilePicture()
                        
                        let localData = LocalData()
                        
                        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, interested_in, name, gender, email, friends, birthday, location"])
                        graphRequest!.start { (connection, result, error) -> Void in
                            
                            if error != nil {
                                
                                print(error!)
                                print("got error")
                                
                            } else if let result = result as? [String: AnyObject]{
                                // saves these to parse at every login
                                var hasInterestedIn = false
                                if let interested_in = result["interested_in"] {
                                    localData.setInterestedIn(interested_in as! String)
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
                                
                                if let id = result["id"] {
                                    PFUser.current()?["fb_id"] =  id
                                }
                                
//                                //Getting user friends from facebook and then updating the friend_list
//                                if let friends = result["friends"]! as? NSDictionary {
//                                    let friendsData : NSArray = friends.object(forKey: "data") as! NSArray
//                                    var fbFriendIds = [String]()
//                                    for friend in friendsData {
//                                        let valueDict : NSDictionary = friend as! NSDictionary
//                                        fbFriendIds.append(valueDict.object(forKey: "id") as! String)
//                                    }
//                                    PFUser.current()?["fb_friends"] = fbFriendIds
//                                    PFUser.current()?.saveInBackground(block: { (success, error) in
//                                        if error != nil {
//                                            print(error!)
//                                        } else {
//                                            fbFunctions.updateFriendList()
//                                        }
//                                    })
//                                }
                                
                                
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
                        if PFUser.current()?["profile_pictures"] == nil {
                            fbFunctions.getProfilePictures()
                        }
                        
                        if let _ = (PFUser.current()?["name"]) as? String {
                            let localData = LocalData()
                            localData.setUsername((PFUser.current()?["name"])! as! String)
                            localData.synchronize()
                        }
                        let localData = LocalData()
                        if localData.getMainProfilePicture() == nil {
                            // User is not new but we are getting his picture
                            LocalStorageUtility().getMainProfilePictureFromParse()
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { () -> Void in
                            //stop the spinner animation and reactivate the interaction with user
                            //self.activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                            
                            if hasSignedUp == true {
                                vc.performSegue(withIdentifier: "showBridgeViewController", sender: self)
                            } else {
                                
                                //If the user has already provided an access code, then do not display it again
                                let hasProvidedAccessCode = localData.getHasProvidedAccessCode() ?? false
                                if !hasProvidedAccessCode {
                                    localData.setHasProvidedAccessCode(true)
                                    localData.synchronize()
                                }
                                vc.performSegue(withIdentifier: "showSignUp", sender: self)
                            }
                            
                        })
                    }
                    
                    
                    
                } else {
                    //self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
        }
        
    }
    
}
