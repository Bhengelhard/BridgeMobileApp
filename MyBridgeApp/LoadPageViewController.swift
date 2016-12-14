//
//  LoadPageViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 5/10/16.
//  Copyright © 2016 BHE Ventures LLC. All rights reserved.
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
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    let transitionManager = TransitionManager()
    var locationManager = CLLocationManager()
    var geoPoint:PFGeoPoint?
    
     // Do we need this function anymore? Not being called from anywhere. cIgAr 08/18/16
    //right now just updates users Friends
    func updateUser() {
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "friends"])
        graphRequest?.start { (connection, result, error) -> Void in
            if error != nil {
                print(error)
            } else if let result = result as? [String:AnyObject]{
                let friends = result["friends"]! as! NSDictionary
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
    
    func updateFriendList() {
        //add graph request to update users fb_friends
        //query to find and save fb_friends
        let currentUserFbFriends = PFUser.current()!["fb_friends"] as! NSArray
        let query: PFQuery = PFQuery(className: "_User")
        query.whereKey("fb_id", containedIn: currentUserFbFriends as! [Any])
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
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
        }
    }
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        locationManager.stopUpdatingLocation()
        //print("didUpdateLocations")
        if manager.location != nil {
        geoPoint = PFGeoPoint(latitude: manager.location!.coordinate.latitude, longitude: manager.location!.coordinate.longitude)
        //print("LoadViewController posting a notification")
        //print("\(geoPoint?.latitude),\(geoPoint?.longitude)")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "storeUserLocationOnParse"), object: nil, userInfo:  ["geoPoint":geoPoint!])
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let pfCloudFunctions = PFCloudFunctions()
        //pfCloudFunctions.updateUserTableToHaveURLS(parameters: [:])
        //pfCloudFunctions.updateBridgePairingsTableToHaveURLS(parameters: [:])
        //pfCloudFunctions.addProfilePicturesBackForUser1(parameters: [:])
        pfCloudFunctions.addProfilePicturesBackForUser2(parameters: [:])

        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /* Why is this in viewDidAppear? I'm leaving it here for historical reasons - cIgAr - 08/18/16*/
        PFUser.current()?.fetchInBackground(block: { (object, error) in
            let localData = LocalData()
            //Updating the user's friends
            self.updateUser()
            if (localData.getUsername() != nil) && ((PFUser.current()!.objectId) != nil){ //remember to change this back to username
                LocalStorageUtility().getUserFriends()
                //LocalStorageUtility().getMainProfilePicture()
                let hasSignedUp:Bool = localData.getHasSignedUp() ?? false

                if hasSignedUp == true {
                    self.performSegue(withIdentifier: "showBridgeFromLoadPage", sender: self)
                } else {
                    self.performSegue(withIdentifier: "showSignupFromLoadPage", sender: self)
                }
                
            }
            else{
                self.performSegue(withIdentifier: "showLoginFromLoadPage", sender: self)

            }
            
            
        })
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination
        let mirror = Mirror(reflecting: vc)
        if mirror.subjectType == ViewController.self {
            let vc2 = vc as! ViewController
            vc2.geoPoint = self.geoPoint
        }
        //NSNotificationCenter.defaultCenter().removeObserver(self)
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


/*
 //fixing app not setting bridges issue
 var count = 0
 print("fixing app not setting bridges issue")
 let messagesQuery = PFQuery(className:"Messages")
 messagesQuery.limit = 10000
 messagesQuery.findObjectsInBackground { (objects, error) in
 if error == nil {
 if let objects = objects {
 let numMessages = objects.count
 print("numMessages = \(numMessages)")
 for object in objects {
 let idsInMessage = object["ids_in_message"]
 if let idsInMessage = idsInMessage as? [String] {
 //print("idsInMessage - \(idsInMessage)")
 
 let bridgeBuilder = object["bridge_builder"] as? String
 var fixedIdsInMessage = [String]()
 if (idsInMessage.contains(bridgeBuilder!)) {
 for id in idsInMessage {
 if id != bridgeBuilder {
 fixedIdsInMessage.append(id)
 }
 }
 } else {
 fixedIdsInMessage = idsInMessage
 }
 print("fixedIdsInMessage - \(fixedIdsInMessage)")
 let bridgePairingsQuery = PFQuery(className: "BridgePairings")
 bridgePairingsQuery.limit = 10000
 bridgePairingsQuery.findObjectsInBackground(block: { (pairings, error2) in
 if error2 == nil {
 if let pairings = pairings {
 for pair in pairings {
 let pairIdsArray = pair["user_objectIds"]
 if let pairIdsArray = pairIdsArray as? [String]{
 if (pairIdsArray == fixedIdsInMessage || (pairIdsArray.reversed()) == fixedIdsInMessage) && fixedIdsInMessage.count == 2 {
 print("\(pairIdsArray) should be bridge")
 count = count + 1
 pair["bridged"] = true
 pair.saveInBackground()
 }
 }
 
 }
 print(count)
 
 }
 }
 
 })
 }
 }
 }
 }
 }*/

