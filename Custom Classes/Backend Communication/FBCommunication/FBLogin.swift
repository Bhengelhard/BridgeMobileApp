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
    let fbFunctions = FacebookFunctions()
    let localData = LocalData()
    var vc: UIViewController?

    
    // MARK: -
    
    //Login User after they click the login with facebook button
    func initialize (vc: UIViewController) {
        self.vc = vc
        
        //setting first Time Swiping Right to true so the user will be notified of what swiping does for their first swipe
        localData.setFirstTimeOnBridgeVC(true)
        
        //setting first Time SwipingRight to true so the user will be notified of what swiping does for their first swipe
        localData.setFirstTimeSwipingLeft(true)
        
        
        //Log user in with permissions public_profile, email and user_friends
        let permissions = ["public_profile", "email", "user_friends", "user_photos", "user_birthday", "user_location", "user_education_history", "user_work_history", "user_relationships"]
        PFFacebookUtils.logInInBackground(withReadPermissions: permissions) { (user, error) in
            if let error = error {
                print(error)
                print("got to error")
            } else {
                if let user = user {
                    /* Check if the global variable geoPoint has been set to the user's location. If so, store it in Parse. Extremely important since the location would be used to get the user's current city in LocalUtility().getBridgePairings() which is indeed called in SignupViewController - cIgAr 08/18/16 */
                    /*
                    if let geoPoint = self.geoPoint {
                        user["location"] = geoPoint
                        user.saveInBackground()
                    }*/
                    // identify user id with the device
                    let installation = PFInstallation.current()
                    //installation.setDeviceTokenFromData(deviceToken)
                    installation["user"] = PFUser.current()
                    installation["userObjectId"] = PFUser.current()?.objectId
                    installation.saveInBackground()
                    
                    LocalStorageUtility().getUserFriends()
                    
                    // get necessary facebook fields
                    let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, interested_in, name, gender, email, birthday, location, education, work, relationship_status"], tokenString: FBSDKAccessToken.current().tokenString, version: nil, httpMethod: "GET")
                    graphRequest!.start { (connection, result, error) -> Void in
                        if error != nil {
                            
                            print(error!)
                            print("got error")
                            
                        } else if let result = result as? [String: AnyObject] {
                            
                            // saves these to parse at every login
                            
                            // name
                            if let name = result["name"] as? String {
                                user["name"] = name
                            }
                            
                            // email
                            if let email = result["email"] as? String {
                                user["email"] = email
                            }
                            
                            // birthday (used for age)
                            if let birthday = result["birthday"] as? String {
                                user["birthday"] = birthday
                            }
                            
                            // gender
                            if let gender = result["gender"] as? String {
                                user["gender"] = gender
                            }
                            
                            // city
                            if let location = result["location"] as? [String: AnyObject] {
                                if let locationName = location["name"] as? String {
                                    user["city"] = locationName
                                }
                            }
                            
                            // school
                            if let educationHistory = result["education"] as? [AnyObject] {
                                if let education = educationHistory.last {
                                    if let education = education as? [String: AnyObject] {
                                        if let school = education["school"] as? [String: AnyObject] {
                                            if let schoolName = school["name"] as? String {
                                                user["school"] = schoolName
                                            }
                                        }
                                    }
                                }
                            }
                            
                            // work
                            if let workHistory = result["work"] as? [AnyObject] {
                                if let work = workHistory.last {
                                    if let work = work as? [String: AnyObject] {
                                        if let employer = work["employer"] as? [String: AnyObject] {
                                            if let employerName = employer["name"] as? String {
                                                user["work"] = employerName
                                            }
                                        }
                                    }
                                }
                            }
                            
                            //Adding access code to current user field access_codes to identify which communities the user has joined
                            if let accessVC = vc as? LoginViewController {
                                //Checking if user had to enter an access code -> i.e. HasSignedUp was false before they logged in
                                if !accessVC.accessCode.isEmpty {
                                    user.addUniqueObject(accessVC.accessCode, forKey: "access_codes")
                                }
                            }
                            
                            user.saveInBackground()
                        }
                    }
                    
                    if user.isNew {
                        self.fbFunctions.getProfilePictures {
                        
                            //sync profile picture with facebook profile picture
                            LocalStorageUtility().getMainProfilePicture()
                            
                            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, interested_in, name, gender, email, friends, birthday, location"])
                            graphRequest!.start { (connection, result, error) -> Void in
                                
                                if error != nil {
                                    
                                    print(error!)
                                    print("got error")
                                    
                                } else if let result = result as? [String: AnyObject]{
                                    // saves these to parse at every login
                                    if let interested_in = result["interested_in"] {
                                        self.localData.setInterestedIn(interested_in as! String)
                                        PFUser.current()?["interested_in"] = interested_in
                                    }
                                    
                                    if let id = result["id"] {
                                        user["fb_id"] = id
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
                                    
                                    
                                    user["distance_interest"] = 100
                                    user["new_message_push_notifications"] = true
                                    self.localData.setNewMessagesPushNotifications(true)
                                    user["new_bridge_push_notifications"] = true
                                    self.localData.setNewBridgesPushNotifications(true)
                                    user["built_bridges"] = []
                                    user["rejected_bridges"] = []
                                    user["interested_in_business"] = true
                                    user["interested_in_love"] = true
                                    user["interested_in_friendship"] = true
                                    user["ran_out_of_pairs"] = 0
                                    user["friend_list"] = []
                                    
                                    //setting hasSignedUp to false so the user will be sent back to the signUp page if they have not completed signing up
                                    self.localData.setHasSignedUp(false)
                                    self.localData.synchronize()
                                    
                                    user.saveInBackground(block: { (success, error) in
                                        if success == true {
                                            // Update BridgePairings Table to include new user
                                            let pfCloudFunctions = PFCloudFunctions()
                                            pfCloudFunctions.changeBridgePairingsOnInterestedInUpdate(parameters: [:])
                                            
                                            //self.activityIndicator.stopAnimating()
                                            UIApplication.shared.endIgnoringInteractionEvents()
                                            //vc.performSegue(withIdentifier: "showSignUp", sender: self)
                                            if let loginVC = vc as? LoginViewController {
                                                loginVC.userIsNew = true
                                            } else if let privacyPolicyVC = vc as? PrivacyPolicyViewController {
                                                privacyPolicyVC.userIsNew = true
                                            }
                                            vc.performSegue(withIdentifier: "showSwipe", sender: self)
                                        } else {
                                            print(error ?? "error")
                                        }
                                    })
                                }
                            }
                        }
                        
                    } else {
                        
                        if let hasLoggedIn = user["has_logged_in"] as? Bool {
                            if !hasLoggedIn {
                                user["has_logged_in"] = true
                                user.saveInBackground { (succeeded, _) in
                                    if succeeded {
                                        self.fbFunctions.getProfilePictures(completion: self.showSwipe)
                                    }
                                }
                            } else {
                                self.showSwipe()
                            }
                        } else {
                            user["has_logged_in"] = true
                            user.saveInBackground { (succeeded, _) in
                                if succeeded {
                                    self.fbFunctions.getProfilePictures(completion: self.showSwipe)
                                }
                            }
                        }
                        
                        //spinner
                        //update user and friends
                        //use while access token is nil instead of delay
                        //if PFUser.current()?["profile_pictures"] == nil {
                        //    fbFunctions.getProfilePictures()
                        //}
                        
                        if let name = user["name"] as? String {
                            self.localData.setUsername(name)
                            self.localData.synchronize()
                        }
                        //let localData = LocalData()
                        if self.localData.getMainProfilePicture() == nil {
                            // User is not new but we are getting his picture
                            LocalStorageUtility().getMainProfilePictureFromParse()
                        }
                        
                        /*
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { () -> Void in
                            //stop the spinner animation and reactivate the interaction with user
                            //self.activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                            
                            if hasSignedUp == true {
                                vc.performSegue(withIdentifier: "showSwipe", sender: self)
                            } else {
                                //If the user has already provided an access code, then do not display it again
                                let hasProvidedAccessCode = localData.getHasProvidedAccessCode() ?? false
                                if !hasProvidedAccessCode {
                                    localData.setHasProvidedAccessCode(true)
                                    localData.synchronize()
                                }
                                vc.performSegue(withIdentifier: "showSwipe", sender: self)
                            }
                            
                        })*/
                    }
                    
                    
                    
                } else {
                    //self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
        }
        
    }
    
    func showSwipe() {
        //setting hasSignedUp to false so the user will be sent back to the signUp page if they have not completed signing up
        let hasSignedUp = localData.getHasSignedUp() ?? false
        localData.setHasSignedUp(hasSignedUp)
        localData.synchronize()

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { () -> Void in
            //stop the spinner animation and reactivate the interaction with user
            //self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if hasSignedUp == true {
                if let vc = self.vc {
                    vc.performSegue(withIdentifier: "showSwipe", sender: self)
                }
            } else {
                //If the user has already provided an access code, then do not display it again
                let hasProvidedAccessCode = self.localData.getHasProvidedAccessCode() ?? false
                if !hasProvidedAccessCode {
                    self.localData.setHasProvidedAccessCode(true)
                    self.localData.synchronize()
                }
                //vc.performSegue(withIdentifier: "showSignUp", sender: self)
                if let vc = self.vc {
                    vc.performSegue(withIdentifier: "showSwipe", sender: self)
                }
            }
            
        })
    }
    
}
