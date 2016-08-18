//
//  LoadPageViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 5/10/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4
import FBSDKLoginKit
import CoreData
import CoreLocation

class LoadPageViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var appDescription: UILabel!
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    let transitionManager = TransitionManager()
    var locationManager = CLLocationManager()
    var geoPoint: PFGeoPoint? = nil
    
     // Do we need this function anymore? Not being called from anywhere. cIgAr 08/18/16
    //right now just updates users Friends
    func updateUser() {
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "friends"])
        graphRequest.startWithCompletionHandler { (connection, result, error) -> Void in
            if error != nil {
                
                print(error)
                
            } else if let result = result {
                
                
                
                let friends = result["friends"]! as! NSDictionary
                
                let friendsData : NSArray = friends.objectForKey("data") as! NSArray
                
                var fbFriendIds = [String]()
                
                for friend in friendsData {
                    
                    let valueDict : NSDictionary = friend as! NSDictionary
                    fbFriendIds.append(valueDict.objectForKey("id") as! String)
                    
                }
                
                
                PFUser.currentUser()?["fb_friends"] = fbFriendIds
                
                PFUser.currentUser()?.saveInBackgroundWithBlock({ (success, error) in
                    
                    if error != nil {
                        
                        print(error)
                        
                    } else {
                        
                        self.updateFriendList()
                        
                    }
                    
                })
                
            }
            
        }
        
    }
    // Do we need this function anymore? Not being called from anywhere. cIgAr 08/18/16
    func updateFriendList() {
        
        //add graph request to update users fb_friends
        //query to find and save fb_friends
        
        let currentUserFbFriends = PFUser.currentUser()!["fb_friends"] as! NSArray
        
        let query: PFQuery = PFQuery(className: "_User")
        
        query.whereKey("fb_id", containedIn: currentUserFbFriends as [AnyObject])
        
        query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) in
            
            if error != nil {
                
                print(error)
                
            } else if let objects = objects {
                
                PFUser.currentUser()?.fetchInBackgroundWithBlock({ (success, error) in
                    
                    for object in objects {
                        
                        var containedInFriendList = false
                        
                        if let friendList: NSArray = PFUser.currentUser()!["friend_list"] as? NSArray {
                            
                            containedInFriendList = friendList.contains {$0 as! String == object.objectId!}
                            
                        }
                        
                        if containedInFriendList == false {
                            
                            if PFUser.currentUser()!["friend_list"] != nil {
                                
                                let currentFriendList = PFUser.currentUser()!["friend_list"]
                                PFUser.currentUser()!["friend_list"] = currentFriendList as! Array + [object.objectId!]
                                
                            } else {
                                
                                PFUser.currentUser()!["friend_list"] = [object.objectId!]
                                
                            }
                            
                        }
                        
                        PFUser.currentUser()?.saveInBackground()
                        
                    }
                    
                })
                
            }
            
        })
        
    }
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        locationManager.stopUpdatingLocation()
        geoPoint = PFGeoPoint(latitude: manager.location!.coordinate.latitude, longitude: manager.location!.coordinate.longitude)
        print("LoadViewController posting a notification")
        print("\(geoPoint?.latitude),\(geoPoint?.longitude)")
        NSNotificationCenter.defaultCenter().postNotificationName("storeUserLocationOnParse", object: nil, userInfo:  ["geoPoint":geoPoint!])
        
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(animated: Bool) {
        /* Why is this in viewDidAppear? I'm leaving it here for historical reasons - cIgAr - 08/18/16*/
        PFUser.currentUser()?.fetchInBackgroundWithBlock({ (object, error) in
            let localData = LocalData()
            
            if (localData.getUsername() != nil) && ((PFUser.currentUser()!.objectId) != nil){ //remember to change this back to username
                LocalStorageUtility().getUserFriends()
                LocalStorageUtility().getMainProfilePicture()
                self.performSegueWithIdentifier("showBridgeFromLoadPage", sender: self)
            }
            else{
                self.performSegueWithIdentifier("showLoginFromLoadPage", sender: self)

            }
            
            
        })
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
        appName.frame = CGRect(x: 0.1*screenWidth, y:0.36*screenHeight, width:0.80*screenWidth, height:0.15*screenHeight)
        appDescription.frame = CGRect(x: 0.05*screenWidth, y:0.49*screenHeight, width:0.90*screenWidth, height:0.15*screenHeight)
        
    }

}
