//
//  LocalStorageUtility.swift
//  MyBridgeApp
//
//  Created by Sagar Sinha on 6/16/16.
//  Copyright © 2016 BHE Ventures LLC. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4
import FBSDKLoginKit
import CoreData
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

class LocalStorageUtility{
    var userLocation = [String : (Double,Double)] ()
    var userFriendList = [String : [String]]()
    var userBusinessInterest = [String : Bool]()
    var userLoveInterest = [String : Bool]()
    var userFriendshipInterest = [String : Bool]()
    var userBridgeStatuses = [String : [String]]()
    var userBridgeStatusePostedAt = [String : [Date]]()
    var userBridgeTypes = [String : [String]]()
    var objectsDownloaded = 0
    var result = true
    
    func getMainProfilePictureFromParse(){
        let pfData = PFUser.current()?["profile_picture"] as? PFFile
        if let pfData = pfData {
            pfData.getDataInBackground(block: { (data, error) in
                if error == nil && data != nil {
                    let localData = LocalData()
                    localData.setMainProfilePicture(data!)
                    localData.synchronize()
                }
            })
        }
    }
    //saves  to LocalDataStorage & Parse
    func getMainProfilePicture(){
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name"])
        _ = graphRequest?.start{ (connection, result, error) -> Void in
                if error != nil {
                print(error!)
                }
                else if let result = result as? [String:AnyObject] {
                let localData = LocalData()
                let userId = result["id"]! as! String
                /*let username = result["name"]! as! String
                localData.setUsername(username)*/
                let facebookProfilePictureUrl = "https://graph.facebook.com/" + userId + "/picture?type=large"
                if let fbpicUrl = URL(string: facebookProfilePictureUrl) {
                    if let data = try? Data(contentsOf: fbpicUrl) {
                        let imageFile: PFFile = PFFile(data: data)!
                        // commenting this out since we will be asking the user if he wants to upload the FB profile picture - cIgAr -
//                        var updateProfilePic = true
//                        if let profilePictureFromFbBool = localData.getProfilePictureFromFb(){
//                            updateProfilePic = profilePictureFromFbBool
//                        }
//                        if let _ = localData.getMainProfilePicture(){
//                            PFUser.currentUser()?["fb_profile_picture"] = imageFile
//                            if updateProfilePic {
//                                PFUser.currentUser()?["profile_picture"] = imageFile
//                                localData.setMainProfilePicture(data)
//                                localData.synchronize()
//
//                            }
//                        }
//                        else {
//                            PFUser.currentUser()?["fb_profile_picture"] = imageFile
//                            PFUser.currentUser()?["profile_picture"] = imageFile
//                            localData.setMainProfilePicture(data)
//                            localData.setProfilePictureFromFb(true)
//                            localData.synchronize()
//                            
//                        }
                        PFUser.current()?["fb_profile_picture"] = imageFile
                        PFUser.current()?["profile_picture"] = imageFile
                        
                        
                        PFUser.current()?.saveInBackground(block: { (success, error) in
                            
                            if success {
                            //Saving profilePicture url
                                if let profilePictureFile = PFUser.current()?["profile_picture"] as? PFFile {
                                    let url = profilePictureFile.url
                                    PFUser.current()?["profile_picture_url"] = url
                                }
                            } else if error != nil {
                                print(error ?? "error")
                            }
                            
                        })
                        localData.setMainProfilePicture(data)
                        localData.synchronize()

                    }
                }
        
            }
        }
    }
    
    func getUserFriends(){
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name"])
        _ = graphRequest?.start{ (connection, result, error) -> Void in
            if error != nil {
                print("Error: \(error!)")
            }
            else if let result = result  as? [String:AnyObject] {
                let userId = result["id"]! as! String
                let accessToken = FBSDKAccessToken.current().tokenString
                let facebookFriendsUrl = "https://graph.facebook.com/\(userId)/friends?access_token=\(accessToken)"
                
                if let fbfriendsUrl = URL(string: facebookFriendsUrl) {
                    
                    if let data = try? Data(contentsOf: fbfriendsUrl) {
                        //background thread to parse the JSON data
                        
                        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high).async {
                            do{
                                let friendList: NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                                
                                if let data = friendList["data"] as? [[String: AnyObject]] {
                                    var friendsArray:[String] = []
                                    var friendsArrayFbId:[String] = []
                                    for item in data {
                                        if let name = item["name"] as? String {
                                            if let id = item["id"] as? String {
                                                
                                                friendsArrayFbId.append(id)
                                                let query = PFQuery(className:"_User")
                                                query.whereKey("fb_id", equalTo:id)
                                                let objects = try query.findObjects()
                                                for object in objects {
                                                    friendsArray.append(object.objectId!)
                                                }
                                                
                                            }
                                            else {
                                                print("Error: \(error!)")
                                            }
                                            
                                        }
                                    }
                                    //Update Parse DB to store the FBfriendlist
                                    
                                    PFUser.current()?["fb_friends"] = friendsArrayFbId
                                    
                                    
                                    
                                    //get friend_list
                                    //add unique from friendsArray to friend_list
                                    //add updated friendlist to the user's device
                                    
                                    //Update Iphone's local storage and Parse to store the friendlist with newly added fb friends -> this does not remove friends from facebook that were unfriended on Facebook
                                    
                                    //error with var parseFriendList = = PFUser.currentUser()?["friend_list"] as? [String]
                                    //var parseFriendList = [String]()
                                    /*if let foundFriendList = PFUser.currentUser()?["friend_list"] as? [String] {
                                        parseFriendList = foundFriendList
                                    }*/
                                    let parseFriendList = PFUser.current()?["friend_list"] as? [String] ?? []
                                    let localData = LocalData()
                                    //adding newly added fb friends to the user's friendlist
                                    var finalFriendList = parseFriendList
                                    for friend in friendsArray {
                                        if parseFriendList.contains(friend){
                                        }
                                        else{
                                            finalFriendList.append(friend)
                                        }
                                    }
                                    localData.setFriendList(finalFriendList)
                                    localData.synchronize()
                                    PFUser.current()?["friend_list"] = finalFriendList
                                    PFUser.current()?.saveInBackground()
                                }
                                
                            }
                            catch  {
                                print(error)
                            }
                        }
                        
                    }
                }
            }
        }
    }
}

//    func getUserDetails(_ id:String)->PairInfo?{
//        var user:PairInfo? = nil
//        let query = PFQuery(className:"_User")
//        query.whereKey("objectId", equalTo:id)
//        do{
//            let objects = try query.findObjects()
//            for object in objects {
//                var name:String? = nil
//                if let ob = object["name"] {
//                    //name with max characters of 25
//                    if name?.characters.count > 25 {
//                        name = ob as? String
//                        let index1 = name!.characters.index(name!.endIndex, offsetBy: name!.characters.count - 25)
//                        name = name!.substring(to: index1)
//                    }
//                }
//                var main_profile_picture:Data? = nil
//                var  main_profile_picture_file:PFFile? = nil
//                if let ob = object["fb_profile_picture"] {
//                    main_profile_picture_file = ob as! PFFile
//                    let data = try main_profile_picture_file!.getData()
//                    main_profile_picture = data
//                }
//                var location:[Double]? = nil
//                if let ob = object["location"] as? PFGeoPoint{
//                    location = [ob.latitude, ob.longitude]
//                }
//                var bridge_status:String? = nil
//                if let ob = object["current_bridge_status"] {
//                    bridge_status = ob as? String
//                }
//
//                user = PairInfo(name:name, mainProfilePicture: main_profile_picture_file?.url, profilePictures: nil,location: location, bridgeStatus: bridge_status, objectId: object.objectId,  bridgeType: nil, userId: nil, city: nil, savedProfilePicture: nil)
//            }
//        }
//        catch {
//
//        }
//        return user
//
//    }
//saves to LocalDataStorage and Parse

//    func runBridgeAlgorithmOnCloud(){
//        if let friendList = PFUser.current()?["friend_list"] as? [String] {
//            PFCloud.callFunction(inBackground: "updateBridgePairingsTable", withParameters: ["friendList":friendList], block: {
//                (response: Any?, error: Error?) in
//                if error == nil {
//                    if let response = response as? String {
//                        print(response)
//                    }
//                } else {
//                    print(error)
//                }
//            })
//        }
//    }
//    func updateBridgePairingsTable(){
//        print("got into updateBridgePairingsTable")
//        // The user will have a default city at co-ordinates (-122,37). Mind you, the city is set during Logging In from Facebook. cIgAr - 08/22
//        if let friendList = PFUser.current()?["friend_list"] as? [String] {
//            var latitude:CLLocationDegrees = -122.0312186
//            var longitude:CLLocationDegrees = 37.33233141
//            if let location = PFUser.current()?["location"] as? PFGeoPoint {
//                latitude = location.latitude
//                longitude = location.longitude
//            }
//            let location = CLLocation(latitude: latitude, longitude: longitude)
//            CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
//                if error != nil {
//                    print("Reverse geocoder failed with error" + error!.localizedDescription)
//                    PFUser.current()?["city"] = ""
//                }
//                else {
//                if placemarks!.count > 0 {
//                    let pm = placemarks![0]
//                    PFUser.current()?["city"] = pm.locality
//                }
//                else {
//                    PFUser.current()?["city"] = ""
//                    print("Problem with the data received from geocoder")
//                }
//                }
//                print("Got just before save in background")
//                PFUser.current()?.saveInBackground{
//                (success, error) -> Void in
//
//                    print("SavedInBackground")
//                // Perform the bridgePairings table update irresepctive of the save being a success or failure - cIgAr 08/22
//                    PFCloud.callFunction(inBackground: "updateBridgePairingsTable", withParameters: ["friendList":friendList], block: { (response: Any?, error: Error?) in
//                        if error == nil {
//                            if let response = response as? String {
//                                print(response)
//                                print("Got the response of updateBridgePairingsTable")
//                            }
//                        } else {
//                            print(error ?? "There was an error in updating the BridgePariings Table")
//                        }
//                    })
//
//                }
//            })
//
//        }
//    }

//    func getBridgePairingsFromCloud(_ maxNoOfCards:Int, typeOfCards:String){
//        let q = PFQuery(className: "_User")
//        var flist = [String]()
//        do {
//        let object = try q.getObjectWithId((PFUser.current()?.objectId)!)
////        q.getObjectInBackgroundWithId((PFUser.currentUser()?.objectId)!){
////            (object, error) -> Void in
//        //if error == nil && object != nil {
//        if let fl = object["friend_list"] as? [String]{
//        flist = fl
//        let bridgePairings = LocalData().getPairings()
//        var pairings = [UserInfoPair]()
//        if (bridgePairings != nil) {
//            pairings = bridgePairings!
//        }
//        if let _ = PFUser.current()?.objectId {
//            var getMorePairings = true
//            var i = 1
//            while getMorePairings {
//                let query = PFQuery(className:"BridgePairings")
//
////                if let friendlist = (PFUser.currentUser()?["friend_list"] as? [String]) {
////                    flist = friendlist
////                }
//                query.whereKey("user_objectIds", containedIn :flist)
//                query.whereKey("user_objectIds", notEqualTo:(PFUser.current()?.objectId)!) //change this to notEqualTo
//                query.whereKey("checked_out", equalTo: false)
//                query.whereKey("shown_to", notEqualTo:(PFUser.current()?.objectId)!)
//                if (typeOfCards != "All" && typeOfCards != "EachOfAllType") {
//                    query.whereKey("bridge_type", equalTo: typeOfCards)
//                }
//                if typeOfCards == "EachOfAllType" {
//                    switch i {
//                    case 1:
//                        query.whereKey("bridge_type", equalTo: "Business")
//                    case 2:
//                        query.whereKey("bridge_type", equalTo: "Love")
//                    case 3:
//                        query.whereKey("bridge_type", equalTo: "Friendship")
//                    default: break
//                    }
//
//                }
//                query.limit = maxNoOfCards
//                do {
//                    let results = try query.findObjects()
//
//
//                    // query.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
//                    //if let results = results {
//                    print("Hi")
//                    for result in results {
//                        var user1:PairInfo? = nil
//                        var user2:PairInfo? = nil
//                        var name1:String? = nil
//                        var name2:String? = nil
//                        var userId1:String? = nil
//                        var userId2:String? = nil
//                        if let ob = result["user_objectIds"] as? [String] {
//                            userId1 =  ob[0]
//                            userId2 =  ob[1]
//                            /* Performing this important check here to make sure that each individual in the pair is friend's with the current user. Parse query -"query.whereKey("user_objectIds", containedIn :flist)" returns true even if anyone of those user's is friend with the current user - cIgAr - 08/18/16*/
//                            if flist.index(of: userId1!) == nil || flist.index(of: userId2!) == nil {
//                                continue
//                            }
//                        }
//
//                        if let ob = result["user1_name"] {
//                            name1 = ob as? String
//
//                        }
//                        if let ob = result["user2_name"] {
//                            name2 = ob as? String
//                        }
//                        var location1:[Double]? = nil
//                        var location2:[Double]? = nil
//
//                        if let ob = result["user_locations"] as? [AnyObject]{
//                            if let x = ob[0] as? PFGeoPoint{
//                                location1 = [x.latitude,x.longitude]
//                            }
//                            if let x = ob[1] as? PFGeoPoint{
//                                location2 = [x.latitude,x.longitude]
//                            }
//                        }
//                        var profilePicture1:Data? = nil
//                        var profilePicture2:Data? = nil
//                        var profilePictureFile1:String? = nil
//                        var profilePictureFile2:String? = nil
//
//                        if let ob = result["user1_profile_picture"] {
//                            let main_profile_picture_file = ob as! PFFile
//                            profilePictureFile1 = main_profile_picture_file.url
//                            profilePicture1 = try main_profile_picture_file.getData()
//                        }
//                        if let ob = result["user2_profile_picture"] {
//                            let main_profile_picture_file = ob as! PFFile
//                            profilePictureFile2 = main_profile_picture_file.url
//                            profilePicture2 = try main_profile_picture_file.getData()
//                        }
//
//                        var bridgeStatus1:String? = nil
//                        var bridgeStatus2:String? = nil
//                        if let ob = result["user1_bridge_status"] {
//                            bridgeStatus1 =  ob as? String
//                        }
//                        if let ob = result["user2_bridge_status"] {
//                            bridgeStatus2 =  ob as? String
//                        }
//                        var city1:String? = nil
//                        var city2:String? = nil
//                        if let ob = result["user1_city"] {
//                            city1 =  ob as? String
//                        }
//                        if let ob = result["user2_city"] {
//                            city2 =  ob as? String
//                        }
//
//
//                        var bridgeType1:String? = nil
//                        var bridgeType2:String? = nil
//                        if let ob = result["bridge_type"] {
//                            bridgeType1 =  ob as? String
//                            bridgeType2 =  ob as? String
//                        }
//
//                        var objectId1:String? = nil
//                        var objectId2:String? = nil
//                        if let ob = result.objectId {
//                            objectId1 =  ob as String
//                            objectId2 =  ob as String
//                        }
//
//
//                        result["checked_out"]  = true
//                        if let _ = result["shown_to"] {
//                            if var ar = result["shown_to"] as? [String] {
//                                let s = (PFUser.current()?.objectId)! as String
//                                ar.append(s)
//                                result["shown_to"] = ar
//                            }
//                            else {
//                                result["shown_to"] = [(PFUser.current()?.objectId)!]
//                            }
//                        }
//                        else {
//                            result["shown_to"] = [(PFUser.current()?.objectId)!]
//                        }
//                        result.saveInBackground()
//
//                        user1 = PairInfo(name:name1, mainProfilePicture: profilePictureFile1, profilePictures: nil,location: location1, bridgeStatus: bridgeStatus1, objectId: objectId1,  bridgeType: bridgeType1, userId: userId1, city: city1, savedProfilePicture: nil)
//                        user2 = PairInfo(name:name2, mainProfilePicture: profilePictureFile2, profilePictures: nil,location: location2, bridgeStatus: bridgeStatus2, objectId: objectId2,  bridgeType: bridgeType2, userId: userId2, city: city2, savedProfilePicture: nil)
//                        let userInfoPair = UserInfoPair(user1: user1, user2: user2)
//                        pairings.append(userInfoPair)
//
//                    }
//                    let localData = LocalData()
//                    localData.setPairings(pairings)
//                    localData.synchronize()
//
//
//                }
//                catch {
//
//                }
//                i += 1
//                if i > 3 || typeOfCards != "EachOfAllType"{
//                    getMorePairings = false
//                }
//
//
//            }
//        }
//        }
//        }
//        catch {
//
//        }
//    }

//    func getUserPhotos(){
//        // Need to be worked upon after we get permission
//        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name"])
//        graphRequest?.start{ (connection, result, error) -> Void in
//            if error != nil {
//                print(error)
//            } else if let result = result as? [String: AnyObject]{
//                let userId = result["id"]! as! String
//                let accessToken = FBSDKAccessToken.current().tokenString
//
//                let facebookProfilePictureUrl = "https://graph.facebook.com/\(userId)/albums?access_token=\(accessToken)"
//                if let fbpicUrl = URL(string: facebookProfilePictureUrl) {
//                    if let data = try? Data(contentsOf: fbpicUrl) {
//                        var error: NSError?
//                        do{
//                            var albumsDictionary: NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
//                        }
//                        catch{
//                            print(error)
//                        }
//                    }
//
//                }
//
//            }
//
//
//        }
//    }





//    //defunct now since we moved to using the Cloud
//    func ifNotFriends(_ friend1:String, friend2:String) -> Bool{
//        var result = true
//        if userFriendList[friend1] != nil {
//            if userFriendList[friend1]!.contains(friend2){
//                result = false
//            }
//        }
//        if userFriendList[friend2] != nil {
//            if userFriendList[friend2]!.contains(friend1){
//                result = false
//            }
//        }
//        return result
//    }
//    //defunct now since we moved to using the Cloud
//    func ifHaveCommonInterest(_ friend1:String, friend2:String) -> Bool {
//        var businessInterest = false
//        var loveInterest = false
//        var friendshipInterest = false
//        if userBusinessInterest[friend1] != nil && userBusinessInterest[friend2] != nil {
//            if userBusinessInterest[friend1]! && userBusinessInterest[friend2]! {
//                businessInterest = true
//            }
//        }
//        if userLoveInterest[friend1] != nil && userLoveInterest[friend2] != nil {
//            if userLoveInterest[friend1]! && userLoveInterest[friend2]! {
//                loveInterest = true
//            }
//        }
//        if userFriendshipInterest[friend1] != nil && userFriendshipInterest[friend2] != nil {
//            if userFriendshipInterest[friend1]! && userFriendshipInterest[friend2]! {
//                friendshipInterest = true
//            }
//        }
//        return (businessInterest || loveInterest || friendshipInterest)
//
//    }
//    //defunct now since we moved to using the Cloud
//    func runBridgeAlgorithm(_ friendList:[String]){
//        var ignoredPairings = [[String]]()
//        if let builtBridges = PFUser.current()?["built_bridges"] {
//            let builtBridges2 = builtBridges as! [[String]]
//            ignoredPairings = ignoredPairings + builtBridges2
//        }
//        if let rejectedBridges = PFUser.current()?["rejected_bridges"] {
//            let rejectedBridges2 = rejectedBridges as! [[String]]
//            ignoredPairings = ignoredPairings + rejectedBridges2
//        }
//        let friendPairings =  [[String]]()
//        for friend1 in friendList {
//            for friend2 in friendList {
//                let containedInIgnoredPairings = ignoredPairings.contains {$0 == [friend1, friend2]} || ignoredPairings.contains {$0 == [friend2, friend1]}
//
//                let PreviouslyDisplayedUser = friendPairings.contains {$0 == [friend1, friend2]} || friendPairings.contains {$0 == [friend2, friend1]}
//
//
//                if PreviouslyDisplayedUser == false && friend1 != friend2 &&
//                    containedInIgnoredPairings == false  {
//                    if !userFriendList[friend1]!.contains(friend2) && !userFriendList[friend2]!.contains(friend1) && ifNotFriends(friend1,friend2: friend2) && ifHaveCommonInterest(friend1,friend2: friend2){
//
//                    }
//                }
//
//            }
//
//        }
//    }
//    //defunct now since we moved to using the Cloud
//    func getBridgePairings(_ friendIds:[String]) {
//        let noOfFriends = friendIds.count
//        getFriendsInfo(friendIds)
//        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async { () -> Void in
//            while self.userBusinessInterest.count < noOfFriends ||
//                self.userBridgeStatuses.count < noOfFriends {
//
//            }
//            self.runBridgeAlgorithm(friendIds)
//
//        }
//    }
//    //defunct now since we moved to using the Cloud
//    func setUserBridgeStatusInfo(_ friendId:String, results:[PFObject]) {
//        var statuses = [String]()
//        var bridgeTypes = [String]()
//        var postedAt = [Date]()
//        for user in results {
//            if let ob = user["bridge_status"] as? String {
//                statuses.append(ob)
//            }
//            if let ob = user["bridge_type"] as? String {
//                bridgeTypes.append(ob)
//            }
//            if let date = user.createdAt {
//                postedAt.append(date)
//            }
//        }
//        self.userBridgeStatuses[friendId] = statuses
//        self.userBridgeTypes[friendId] = bridgeTypes
//        self.userBridgeStatusePostedAt[friendId] = postedAt
//    }
//    //defunct now since we moved to using the Cloud
//    func getFriendsInfo(_ friendIds:[String]){
//
//        let todaysDate =  Date(); // gets today
//        let date14DaysAgo = todaysDate.addingTimeInterval(-1000 * 60 * 60 * 24 * 14); // gets 14 days ago
//
//        let splitSize = 1000
//        let allFriendIds = stride(from: friendIds.startIndex, to: friendIds.count, by: splitSize).map {
//            friendIds[$0 ..< $0.advanced(by: splitSize)] //, limit: friendIds.endIndex
//        }
//        for friendId in friendIds {
//
//            let query = PFQuery(className:"BridgeStatus")
//
//            query.whereKey("userId", equalTo:friendId)
//            query.limit = 1000
//            query.order(byDescending: "createdAt")
//            query.whereKey("createdAt", greaterThan: date14DaysAgo)
//            query.findObjectsInBackground(block: { (results, error) in
//                if error == nil {
//                    if let results = results {
//                        if results.count < 1 {
//                            let query = PFQuery(className:"BridgeStatus")
//                            query.whereKey("userId", equalTo:friendId)
//                            query.limit = 1000
//                            query.order(byDescending: "createdAt")
//                            query.findObjectsInBackground(block: { (results, error) in
//                                if error == nil {
//                                    if let results = results {
//                                        self.setUserBridgeStatusInfo(friendId,results: results)
//                                    }
//                                }
//                            })
//                        }
//                        else {
//                            self.setUserBridgeStatusInfo(friendId,results: results)
//                        }
//                    }
//                    else {
//                        let query = PFQuery(className:"BridgeStatus")
//                        query.whereKey("userId", equalTo:friendId)
//                        query.limit = 1000
//                        query.order(byDescending: "createdAt")
//                        query.findObjectsInBackground(block: { (results, error) in
//                            if error == nil {
//                                if let results = results {
//                                    self.setUserBridgeStatusInfo(friendId,results: results)
//                                }
//                            }
//                        })
//                    }
//
//
//                }
//            })
//        }
//
//        for friendIdSlices in allFriendIds {
//        let friendIds = Array(friendIdSlices)
//        let query = PFQuery(className:"_User")
//        query.whereKey("objectId", containedIn: friendIds)
//        query.limit = 1000
//        query.findObjectsInBackground(block: { (results, error) in
//            if error == nil {
//                if let results = results {
//                    for user in results {
//                        if let ob = user["location"] as? PFGeoPoint{
//                            self.userLocation[user.objectId!] = (ob.latitude, ob.longitude)
//                        }
//                        if let ob = user["friend_list"] as? [String] {
//                            self.userFriendList[user.objectId!] = ob
//                        }
//                        if let ob = user["interested_in_business"] as? Bool {
//                            self.userBusinessInterest[user.objectId!] = ob
//                        }
//                        if let ob = user["interested_in_love"] as? Bool {
//                            self.userLoveInterest[user.objectId!] = ob
//                        }
//                        if let ob = user["interested_in_friendship"] as? Bool {
//                            self.userFriendshipInterest[user.objectId!] = ob
//                        }
//                    }
//                }
//            }
//        })
//        }
//
//    }
//    //defunct now since we moved to using the Cloud
//    func checkComptability (_ friend1:String, friend2:String)->Bool {
//        var friend1BridgeStatus:String? = nil
//        var friend1Location:[Double]? = nil
//        var friend1FriendList:[String]? = nil
//        var friend2BridgeStatus:String? = nil
//        var friend2Location:[Double]? = nil
//        var friend2FriendList:[String]? = nil
//
//        var areFriends = false
//        var commonInterest = false
//
//        var friend1InterestedInBusiness = false
//        var friend1InterestedInLove = false
//        var friend1InterestedInFriendship = false
//
//        var friend2InterestedInBusiness = false
//        var friend2InterestedInLove = false
//        var friend2InterestedInFriendship = false
//
//        var friend1RelevantBusinessBridgeStatus:String? = nil
//        var friend2RelevantBusinessBridgeStatus:String? = nil
//        var friend1RelevantLoveBridgeStatus:String? = nil
//        var friend2RelevantLoveBridgeStatus:String? = nil
//        var friend1RelevantFriendshipBridgeStatus:String? = nil
//        var friend2RelevantFriendshipBridgeStatus:String? = nil
//
//        let query = PFQuery(className:"_User")
//        query.whereKey("objectId", equalTo:friend1)
//        do{
//            let objects = try query.findObjects()
//            for object in objects {
//
//                if let ob = object["current_bridge_status"] {
//                    friend1BridgeStatus = ob as? String
//                }
//
//                if let ob = object["location"] as? PFGeoPoint{
//                    friend1Location = [ob.latitude, ob.longitude]
//                }
//
//                if let ob = object["friend_list"] {
//                    friend1FriendList = ob as? [String]
//               }
//                if let ob = object["interested_in_business"] {
//                    if let val = ob as? Bool {
//                        friend1InterestedInBusiness = val
//                    }
//                }
//                if let ob = object["interested_in_love"] {
//                    if let val = ob as? Bool {
//                        friend1InterestedInLove = val
//                    }
//                }
//                if let ob = object["interested_in_friendship"] {
//                    if let val = ob as? Bool {
//                        friend1InterestedInFriendship = val
//                    }
//                }
//
//            }
//        }
//        catch {
//
//        }
//        let query2 = PFQuery(className:"_User")
//        query2.whereKey("objectId", equalTo:friend2)
//        do{
//            let objects = try query.findObjects()
//            for object in objects {
//
//                if let ob = object["current_bridge_status"] {
//                    friend2BridgeStatus = ob as? String
//                }
//                if let ob = object["location"] as? PFGeoPoint{
//                    friend2Location = [ob.latitude, ob.longitude]
//                }
//                if let ob = object["friend_list"] {
//                    friend2FriendList = ob as? [String]
//                }
//                if let ob = object["interested_in_business"] {
//                    if let val = ob as? Bool {
//                        friend2InterestedInBusiness = val
//                    }
//                }
//                if let ob = object["interested_in_love"] {
//                    if let val = ob as? Bool {
//                        friend2InterestedInLove = val
//                    }
//                }
//                if let ob = object["interested_in_friendship"] {
//                    if let val = ob as? Bool {
//                        friend2InterestedInFriendship = val
//                    }
//                }
//            }
//        }
//
//        catch {
//
//        }
//        var friend1BridgeStatuses = [String]()
//        var friend1BridgeStatusTypes = [String]()
//        var friend2BridgeStatuses = [String]()
//        var friend2BridgeStatusTypes = [String]()
//        let d =  Date(); // gets today
//        let d1 = d.addingTimeInterval(-1000 * 60 * 60 * 24 * 14); // gets 14 days ago
//        let query3 = PFQuery(className:"BridgeStatus")
//        query3.whereKey("userId", equalTo:friend1)
//        query3.whereKey("createdAt", greaterThan: d1)
//        query3.order(byDescending: "createdAt")
//        do{
//            var objects = try query3.findObjects()
//            if objects.count < 1 {
//                let query3 = PFQuery(className:"BridgeStatus")
//                query3.whereKey("userId", equalTo:friend1)
//                query3.order(byDescending: "createdAt")
//                objects = try query.findObjects()
//
//            }
//            for object in objects {
//                if let ob = object["bridge_status"] {
//                    friend1BridgeStatuses.append(ob as! String)
//                }
//                if let ob = object["bridge_type"] {
//                    friend1BridgeStatusTypes.append(ob as! String)
//                }
//
//
//            }
//
//        }
//        catch {
//
//        }
//        let query4 = PFQuery(className:"BridgeStatus")
//        query4.whereKey("userId", equalTo:friend2)
//        query4.whereKey("createdAt", greaterThan: d1)
//        query4.order(byDescending: "createdAt")
//        do{
//            var objects = try query4.findObjects()
//            if objects.count < 1 {
//                let query4 = PFQuery(className:"BridgeStatus")
//                query4.whereKey("userId", equalTo:friend2)
//                query4.order(byDescending: "createdAt")
//                objects = try query.findObjects()
//
//            }
//            for object in objects {
//                if let ob = object["bridge_status"] {
//                    friend2BridgeStatuses.append(ob as! String)
//                }
//                if let ob = object["bridge_type"] {
//                    friend2BridgeStatusTypes.append(ob as! String)
//                }
//
//
//            }
//
//
//        }
//        catch {
//
//        }
//        var friend1Statuscounts:[String:Int] = [:]
//        for item in friend1BridgeStatusTypes {
//            friend1Statuscounts[item] = (friend1Statuscounts[item] ?? 0) + 1
//        }
//        var friend2Statuscounts:[String:Int] = [:]
//        for item in friend2BridgeStatusTypes {
//            friend2Statuscounts[item] = (friend2Statuscounts[item] ?? 0) + 1
//        }
//
//        commonInterest = (friend1InterestedInBusiness && friend2InterestedInBusiness) ||
//                            (friend1InterestedInLove && friend2InterestedInLove) ||
//                            (friend1InterestedInFriendship && friend2InterestedInFriendship)
//        if commonInterest {
//            if friend1InterestedInBusiness && friend2InterestedInBusiness {
//
//                if let status = friend1BridgeStatusTypes.index(of: "Business") {
//                    friend1RelevantBusinessBridgeStatus = friend1BridgeStatuses[status]
//                }
//                if let status2 = friend2BridgeStatusTypes.index(of: "Business") {
//                    friend2RelevantBusinessBridgeStatus = friend1BridgeStatuses[status2]
//                }
//            }
//            if friend1InterestedInLove && friend2InterestedInLove {
//
//                if let status = friend1BridgeStatusTypes.index(of: "Love") {
//                    friend1RelevantLoveBridgeStatus = friend1BridgeStatuses[status]
//                }
//                if let status2 = friend2BridgeStatusTypes.index(of: "Love") {
//                    friend2RelevantLoveBridgeStatus = friend1BridgeStatuses[status2]
//                }
//            }
//            if friend1InterestedInFriendship && friend2InterestedInFriendship {
//
//                if let status = friend1BridgeStatusTypes.index(of: "Friendship") {
//                    friend1RelevantFriendshipBridgeStatus = friend1BridgeStatuses[status]
//                }
//                if let status2 = friend2BridgeStatusTypes.index(of: "Friendship") {
//                    friend2RelevantFriendshipBridgeStatus = friend1BridgeStatuses[status2]
//                }
//            }
//
//        }
//        if friend1FriendList != nil && friend2FriendList != nil {
//            areFriends = friend1FriendList!.contains(friend2) || friend2FriendList!.contains(friend1)
//        }
//        return true
//    }

