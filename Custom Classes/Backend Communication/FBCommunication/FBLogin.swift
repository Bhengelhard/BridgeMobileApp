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
import MBProgressHUD

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
                print("error - logging in in background - \(error)")
            } else {
                if let user = user {
                    let hud = MBProgressHUD.showAdded(to: vc.view, animated: true)
                    
                    if user.isNew {
                        hud.label.numberOfLines = 2
                        hud.label.text = "Loading...\nThis may take a while."
                    } else {
                        hud.label.text = "Loading..."
                    }
                    
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
                    let connection = FBSDKGraphRequestConnection()
                    let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, interested_in, name, gender, email, birthday, location, education, work, relationship_status"], tokenString: FBSDKAccessToken.current().tokenString, version: nil, httpMethod: "GET")
                    //let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, interested_in, name, gender, email, birthday, location, education, work, relationship_status"])
                    connection.add(graphRequest, completionHandler: { (_, result, error) in
                        if error != nil {
                            
                            print(error!)
                            print("got error")
                            
                        } else if let result = result as? [String: AnyObject] {
                            print("results are not nil")
                            
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
                            user.remove(forKey: "birthday")
                            if let birthday = result["birthday"] as? String {
                                user["birthday"] = birthday
                            }
                            
                            // gender
                            user.remove(forKey: "gender")
                            if let gender = result["gender"] as? String {
                                user["gender"] = gender
                            }
                            
                            // city
                            user.remove(forKey: "city")
                            if let location = result["location"] as? [String: AnyObject] {
                                if let locationName = location["name"] as? String {
                                    user["city"] = locationName
                                }
                            }
                            
                            // school
                            user.remove(forKey: "school")
                            user.remove(forKey: "current_school")
                            if let educationHistory = result["education"] as? [AnyObject] {
                                if let education = educationHistory.last {
                                    if let education = education as? [String: AnyObject] {
                                        if let school = education["school"] as? [String: AnyObject] {
                                            if let schoolName = school["name"] as? String {
                                                user["school"] = schoolName
                                                user["current_school"] = false
                                            }
                                        }
                                        if let year = education["year"] as? [String: AnyObject] {
                                            if let yearName = year["name"] as? String {
                                                let formatter = DateFormatter()
                                                formatter.locale = Locale(identifier: "en_US_POSIX")
                                                formatter.dateFormat = "yyyy"
                                                
                                                if let graduationDate = formatter.date(from: yearName) {
                                                    //getting age from Birthday
                                                    let calendar = Calendar.current as NSCalendar
                                                    let now = Date()
                                                    let currentYear = calendar.component(.year, from: now)
                                                    let graduationYear = calendar.component(.year, from: graduationDate)
                                                    
                                                    if graduationYear >= currentYear {
                                                        user["current_school"] = true
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            // work
                            user.remove(forKey: "work")
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
                            
                            if user.isNew {
                                
                                self.fbFunctions.getProfilePictures(completion: { 
                                    
                                })
                                
                                if let id = result["id"] {
                                    user["fb_id"] = id
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
                            }
                            
                            user.saveInBackground(block: { (success, error) in
                                if let error = error {
                                    print("error - saving user in background - \(error)")
                                } else {
                                    if success {
                                        let fbFunctions = FacebookFunctions()
                                        if user.isNew {
                                            if let loginVC = vc as? LoginViewController {
                                                loginVC.userIsNew = true
                                            } else if let privacyPolicyVC = vc as? PrivacyPolicyViewController {
                                                privacyPolicyVC.userIsNew = true
                                            }
                                            
                                            fbFunctions.updateFacebookFriends(withBlock: {
                                                self.showSwipe()
                                                
                                                // Update BridgePairings Table to include new user
                                                let pfCloudFunctions = PFCloudFunctions()
                                                pfCloudFunctions.changeBridgePairingsOnInterestedInUpdate(parameters: [:])
                                            })
                                        } else {
                                            //Updating the user's friends
                                            fbFunctions.updateFacebookFriends()
                                        }
                                    }
                                }
                            })
                        }
                    })
                    connection.start()
                    
                } else {
                    //self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
        }
        
    }
    
    func showSwipe() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if let vc = self.vc {
                MBProgressHUD.hide(for: vc.view, animated: true)

                DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 1), execute: {
                    vc.performSegue(withIdentifier: "showSwipe", sender: self)
                })
            }
        }
    }
    
}
