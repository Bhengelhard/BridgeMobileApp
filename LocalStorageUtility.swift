//
//  LocalStorageUtility.swift
//  MyBridgeApp
//
//  Created by Sagar Sinha on 6/16/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4
import FBSDKLoginKit
import CoreData
class LocalStorageUtility{
    var userLocation = [String : (Double,Double)] ()
    var userFriendList = [String : [String]]()
    var userBusinessInterest = [String : Bool]()
    var userLoveInterest = [String : Bool]()
    var userFriendshipInterest = [String : Bool]()
    var userBridgeStatuses = [String : [String]]()
    var userBridgeStatusePostedAt = [String : [NSDate]]()
    var userBridgeTypes = [String : [String]]()
    var objectsDownloaded = 0
    var totalObjects = 0
    var result = true
    //defunct now since we moved to using the Cloud
    func ifNotFriends(friend1:String, friend2:String) -> Bool{
        var result = true
        if userFriendList[friend1] != nil {
            if userFriendList[friend1]!.contains(friend2){
                result = false
            }
        }
        if userFriendList[friend2] != nil {
            if userFriendList[friend2]!.contains(friend1){
                result = false
            }
        }
        return result
    }
    //defunct now since we moved to using the Cloud
    func ifHaveCommonInterest(friend1:String, friend2:String) -> Bool {
        var businessInterest = false
        var loveInterest = false
        var friendshipInterest = false
        if userBusinessInterest[friend1] != nil && userBusinessInterest[friend2] != nil {
            if userBusinessInterest[friend1]! && userBusinessInterest[friend2]! {
                businessInterest = true
            }
        }
        if userLoveInterest[friend1] != nil && userLoveInterest[friend2] != nil {
            if userLoveInterest[friend1]! && userLoveInterest[friend2]! {
                loveInterest = true
            }
        }
        if userFriendshipInterest[friend1] != nil && userFriendshipInterest[friend2] != nil {
            if userFriendshipInterest[friend1]! && userFriendshipInterest[friend2]! {
                friendshipInterest = true
            }
        }
        return (businessInterest || loveInterest || friendshipInterest)

    }
    //defunct now since we moved to using the Cloud
    func runBridgeAlgorithm(friendList:[String]){
        var ignoredPairings = [[String]]()
        if let builtBridges = PFUser.currentUser()?["built_bridges"] {
            let builtBridges2 = builtBridges as! [[String]]
            ignoredPairings = ignoredPairings + builtBridges2
        }
        if let rejectedBridges = PFUser.currentUser()?["rejected_bridges"] {
            let rejectedBridges2 = rejectedBridges as! [[String]]
            ignoredPairings = ignoredPairings + rejectedBridges2
        }
        var friendPairings =  [[String]]()
        for friend1 in friendList {
            for friend2 in friendList {
                let containedInIgnoredPairings = ignoredPairings.contains {$0 == [friend1, friend2]} || ignoredPairings.contains {$0 == [friend2, friend1]}
                
                let PreviouslyDisplayedUser = friendPairings.contains {$0 == [friend1, friend2]} || friendPairings.contains {$0 == [friend2, friend1]}
                
                
                if PreviouslyDisplayedUser == false && friend1 != friend2 &&
                    containedInIgnoredPairings == false  {
                    if !userFriendList[friend1]!.contains(friend2) && !userFriendList[friend2]!.contains(friend1) && ifNotFriends(friend1,friend2: friend2) && ifHaveCommonInterest(friend1,friend2: friend2){
                        
                    }
                }
                
            }
            
        }
    }
    //defunct now since we moved to using the Cloud
    func getBridgePairings(friendIds:[String]) {
        let noOfFriends = friendIds.count
        getFriendsInfo(friendIds)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            while self.userBusinessInterest.count < noOfFriends ||
                self.userBridgeStatuses.count < noOfFriends {
                
            }
            self.runBridgeAlgorithm(friendIds)
            
        }
    }
    //defunct now since we moved to using the Cloud
    func setUserBridgeStatusInfo(friendId:String, results:[PFObject]) {
        var statuses = [String]()
        var bridgeTypes = [String]()
        var postedAt = [NSDate]()
        for user in results {
            if let ob = user["bridge_status"] as? String {
                statuses.append(ob)
            }
            if let ob = user["bridge_type"] as? String {
                bridgeTypes.append(ob)
            }
            if let date = user.createdAt {
                postedAt.append(date)
            }
        }
        self.userBridgeStatuses[friendId] = statuses
        self.userBridgeTypes[friendId] = bridgeTypes
        self.userBridgeStatusePostedAt[friendId] = postedAt
    }
    //defunct now since we moved to using the Cloud
    func getFriendsInfo(friendIds:[String]){
       
        let todaysDate =  NSDate(); // gets today
        let date14DaysAgo = todaysDate.dateByAddingTimeInterval(-1000 * 60 * 60 * 24 * 14); // gets 14 days ago

        let splitSize = 1000
        let allFriendIds = friendIds.startIndex.stride(to: friendIds.count, by: splitSize).map {
            friendIds[$0 ..< $0.advancedBy(splitSize, limit: friendIds.endIndex)]
        }
        
        for friendId in friendIds {
            
            let query = PFQuery(className:"BridgeStatus")
            
            query.whereKey("userId", equalTo:friendId)
            query.limit = 1000
            query.orderByDescending("createdAt")
            query.whereKey("createdAt", greaterThan: date14DaysAgo)
            query.findObjectsInBackgroundWithBlock({ (results, error) in
                if error == nil {
                    if let results = results {
                        if results.count < 1 {
                            let query = PFQuery(className:"BridgeStatus")
                            query.whereKey("userId", equalTo:friendId)
                            query.limit = 1000
                            query.orderByDescending("createdAt")
                            query.findObjectsInBackgroundWithBlock({ (results, error) in
                                if error == nil {
                                    if let results = results {
                                        self.setUserBridgeStatusInfo(friendId,results: results)
                                    }
                                }
                            })
                        }
                        else {
                            self.setUserBridgeStatusInfo(friendId,results: results)
                        }
                    }
                    else {
                        let query = PFQuery(className:"BridgeStatus")
                        query.whereKey("userId", equalTo:friendId)
                        query.limit = 1000
                        query.orderByDescending("createdAt")
                        query.findObjectsInBackgroundWithBlock({ (results, error) in
                            if error == nil {
                                if let results = results {
                                    self.setUserBridgeStatusInfo(friendId,results: results)
                                }
                            }
                        })
                    }
                    
                
                }
            })
        }
        
        for friendIdSlices in allFriendIds {
        let friendIds = Array(friendIdSlices)
        let query = PFQuery(className:"_User")
        query.whereKey("objectId", containedIn: friendIds)
        query.limit = 1000
        query.findObjectsInBackgroundWithBlock({ (results, error) in
            if error == nil {
                if let results = results {
                    for user in results {
                        if let ob = user["location"] as? PFGeoPoint{
                            self.userLocation[user.objectId!] = (ob.latitude, ob.longitude)
                        }
                        if let ob = user["friend_list"] as? [String] {
                            self.userFriendList[user.objectId!] = ob
                        }
                        if let ob = user["interested_in_business"] as? Bool {
                            self.userBusinessInterest[user.objectId!] = ob
                        }
                        if let ob = user["interested_in_love"] as? Bool {
                            self.userLoveInterest[user.objectId!] = ob
                        }
                        if let ob = user["interested_in_friendship"] as? Bool {
                            self.userFriendshipInterest[user.objectId!] = ob
                        }
                    }
                }
            }
        })
        }
        
    }
    //defunct now since we moved to using the Cloud
    func checkComptability (friend1:String, friend2:String)->Bool {
        var friend1BridgeStatus:String? = nil
        var friend1Location:[Double]? = nil
        var friend1FriendList:[String]? = nil
        var friend2BridgeStatus:String? = nil
        var friend2Location:[Double]? = nil
        var friend2FriendList:[String]? = nil
        
        var areFriends = false
        var commonInterest = false
        
        var friend1InterestedInBusiness = false
        var friend1InterestedInLove = false
        var friend1InterestedInFriendship = false
        
        var friend2InterestedInBusiness = false
        var friend2InterestedInLove = false
        var friend2InterestedInFriendship = false
        
        var friend1RelevantBusinessBridgeStatus:String? = nil
        var friend2RelevantBusinessBridgeStatus:String? = nil
        var friend1RelevantLoveBridgeStatus:String? = nil
        var friend2RelevantLoveBridgeStatus:String? = nil
        var friend1RelevantFriendshipBridgeStatus:String? = nil
        var friend2RelevantFriendshipBridgeStatus:String? = nil
        
        let query = PFQuery(className:"_User")
        query.whereKey("objectId", equalTo:friend1)
        do{
            let objects = try query.findObjects()
            for object in objects {
                
                if let ob = object["current_bridge_status"] {
                    friend1BridgeStatus = ob as? String
                }
               
                if let ob = object["location"] as? PFGeoPoint{
                    friend1Location = [ob.latitude, ob.longitude]
                }
               
                if let ob = object["friend_list"] {
                    friend1FriendList = ob as? [String]
               }
                if let ob = object["interested_in_business"] {
                    if let val = ob as? Bool {
                        friend1InterestedInBusiness = val
                    }
                }
                if let ob = object["interested_in_love"] {
                    if let val = ob as? Bool {
                        friend1InterestedInLove = val
                    }
                }
                if let ob = object["interested_in_friendship"] {
                    if let val = ob as? Bool {
                        friend1InterestedInFriendship = val
                    }
                }
                
            }
        }
        catch {
            
        }
        let query2 = PFQuery(className:"_User")
        query2.whereKey("objectId", equalTo:friend2)
        do{
            let objects = try query.findObjects()
            for object in objects {
                
                if let ob = object["current_bridge_status"] {
                    friend2BridgeStatus = ob as? String
                }
                if let ob = object["location"] as? PFGeoPoint{
                    friend2Location = [ob.latitude, ob.longitude]
                }
                if let ob = object["friend_list"] {
                    friend2FriendList = ob as? [String]
                }
                if let ob = object["interested_in_business"] {
                    if let val = ob as? Bool {
                        friend2InterestedInBusiness = val
                    }
                }
                if let ob = object["interested_in_love"] {
                    if let val = ob as? Bool {
                        friend2InterestedInLove = val
                    }
                }
                if let ob = object["interested_in_friendship"] {
                    if let val = ob as? Bool {
                        friend2InterestedInFriendship = val
                    }
                }
            }
        }
        
        catch {
            
        }
        var friend1BridgeStatuses = [String]()
        var friend1BridgeStatusTypes = [String]()
        var friend2BridgeStatuses = [String]()
        var friend2BridgeStatusTypes = [String]()
        let d =  NSDate(); // gets today
        let d1 = d.dateByAddingTimeInterval(-1000 * 60 * 60 * 24 * 14); // gets 14 days ago
        let query3 = PFQuery(className:"BridgeStatus")
        query3.whereKey("userId", equalTo:friend1)
        query3.whereKey("createdAt", greaterThan: d1)
        query3.orderByDescending("createdAt")
        do{
            var objects = try query3.findObjects()
            if objects.count < 1 {
                let query3 = PFQuery(className:"BridgeStatus")
                query3.whereKey("userId", equalTo:friend1)
                query3.orderByDescending("createdAt")
                objects = try query.findObjects()

            }
            for object in objects {
                if let ob = object["bridge_status"] {
                    friend1BridgeStatuses.append(ob as! String)
                }
                if let ob = object["bridge_type"] {
                    friend1BridgeStatusTypes.append(ob as! String)
                }
                

            }

        }
        catch {
            
        }
        let query4 = PFQuery(className:"BridgeStatus")
        query4.whereKey("userId", equalTo:friend2)
        query4.whereKey("createdAt", greaterThan: d1)
        query4.orderByDescending("createdAt")
        do{
            var objects = try query4.findObjects()
            if objects.count < 1 {
                let query4 = PFQuery(className:"BridgeStatus")
                query4.whereKey("userId", equalTo:friend2)
                query4.orderByDescending("createdAt")
                objects = try query.findObjects()
                
            }
            for object in objects {
                if let ob = object["bridge_status"] {
                    friend2BridgeStatuses.append(ob as! String)
                }
                if let ob = object["bridge_type"] {
                    friend2BridgeStatusTypes.append(ob as! String)
                }
                
                
            }

            
        }
        catch {
            
        }
        var friend1Statuscounts:[String:Int] = [:]
        for item in friend1BridgeStatusTypes {
            friend1Statuscounts[item] = (friend1Statuscounts[item] ?? 0) + 1
        }
        var friend2Statuscounts:[String:Int] = [:]
        for item in friend2BridgeStatusTypes {
            friend2Statuscounts[item] = (friend2Statuscounts[item] ?? 0) + 1
        }

        commonInterest = (friend1InterestedInBusiness && friend2InterestedInBusiness) ||
                            (friend1InterestedInLove && friend2InterestedInLove) ||
                            (friend1InterestedInFriendship && friend2InterestedInFriendship)
        if commonInterest {
            if friend1InterestedInBusiness && friend2InterestedInBusiness {
                
                if let status = friend1BridgeStatusTypes.indexOf("Business") {
                    friend1RelevantBusinessBridgeStatus = friend1BridgeStatuses[status]
                }
                if let status2 = friend2BridgeStatusTypes.indexOf("Business") {
                    friend2RelevantBusinessBridgeStatus = friend1BridgeStatuses[status2]
                }
            }
            if friend1InterestedInLove && friend2InterestedInLove {
                
                if let status = friend1BridgeStatusTypes.indexOf("Love") {
                    friend1RelevantLoveBridgeStatus = friend1BridgeStatuses[status]
                }
                if let status2 = friend2BridgeStatusTypes.indexOf("Love") {
                    friend2RelevantLoveBridgeStatus = friend1BridgeStatuses[status2]
                }
            }
            if friend1InterestedInFriendship && friend2InterestedInFriendship {
                
                if let status = friend1BridgeStatusTypes.indexOf("Friendship") {
                    friend1RelevantFriendshipBridgeStatus = friend1BridgeStatuses[status]
                }
                if let status2 = friend2BridgeStatusTypes.indexOf("Friendship") {
                    friend2RelevantFriendshipBridgeStatus = friend1BridgeStatuses[status2]
                }
            }

        }
        if friend1FriendList != nil && friend2FriendList != nil {
            areFriends = friend1FriendList!.contains(friend2) || friend2FriendList!.contains(friend1)
        }
        return true
    }
    func getUserPhotos(){
        // Need to be worked upon after we get permission
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name"])
        graphRequest.startWithCompletionHandler{ (connection, result, error) -> Void in
            print(" graph request")
            if error != nil {
                
                print(error)
                print("got error")
                
            } else if let result = result {
                print("got result")
                let userId = result["id"]! as! String
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                
                let facebookProfilePictureUrl = "https://graph.facebook.com/\(userId)/albums?access_token=\(accessToken)"
                if let fbpicUrl = NSURL(string: facebookProfilePictureUrl) {
                    print(fbpicUrl)
                    if let data = NSData(contentsOfURL: fbpicUrl) {
                        var error: NSError?
                        do{
                            var albumsDictionary: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                            print(albumsDictionary["data"]!)
                        }
                        catch{
                            print(error)
                        }
                    }
                    
                }
                
            }
            
            
        }
    }
    //saves  to LocalDataStorage & Parse
    func getMainProfilePicture(){
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name"])
        graphRequest.startWithCompletionHandler{ (connection, result, error) -> Void in
                if error != nil {
                print(error)
                }
                else if let result = result {
                let localData = LocalData()
                let userId = result["id"]! as! String
                /*let username = result["name"]! as! String
                localData.setUsername(username)*/
                let facebookProfilePictureUrl = "https://graph.facebook.com/" + userId + "/picture?type=large"
                if let fbpicUrl = NSURL(string: facebookProfilePictureUrl) {
                    if let data = NSData(contentsOfURL: fbpicUrl) {
                        let imageFile: PFFile = PFFile(data: data)!
                        //PFUser.currentUser()?["profile_picture"] = imageFile
                        //PFUser.currentUser()?["profile_picture_from_fb"] = true
                        //print("storing profile picture to local storage")
                        var updateProfilePic = false
                        if let profilePictureFromFbBool = localData.getProfilePictureFromFb(){
                            updateProfilePic = profilePictureFromFbBool
                        }
                        if let _ = localData.getMainProfilePicture(){
                            PFUser.currentUser()?["fb_profile_picture"] = imageFile
                            if updateProfilePic {
                                PFUser.currentUser()?["profile_picture"] = imageFile
                                localData.setMainProfilePicture(data)
                                localData.synchronize()

                            }
                        }
                        else {
                        PFUser.currentUser()?["fb_profile_picture"] = imageFile
                        PFUser.currentUser()?["profile_picture"] = imageFile
                        localData.setMainProfilePicture(data)
                        localData.setProfilePictureFromFb(true)
                        localData.synchronize()
                        }
                    }
                }
        
            }
        }
    }
    func getUserDetails(id:String)->PairInfo?{
        var user:PairInfo? = nil
        let query = PFQuery(className:"_User")
        query.whereKey("objectId", equalTo:id)
        do{
            let objects = try query.findObjects()
            for object in objects {
                var name:String? = nil
                if let ob = object["name"] {
                    name = ob as? String
                }
                var main_profile_picture:NSData? = nil
                if let ob = object["fb_profile_picture"] {
                    let main_profile_picture_file = ob as! PFFile
                    let data = try main_profile_picture_file.getData()
                    main_profile_picture = data
                }
                var location:[Double]? = nil
                if let ob = object["location"] as? PFGeoPoint{
                    location = [ob.latitude, ob.longitude]
                }
                var bridge_status:String? = nil
                if let ob = object["current_bridge_status"] {
                    bridge_status = ob as? String
                }
                
                user = PairInfo(name:name, mainProfilePicture: main_profile_picture, profilePictures: nil,location: location, bridgeStatus: bridge_status, objectId: object.objectId,  bridgeType: nil, userId: nil )
            }
        }
        catch {
            
        }
        return user
        
    }
    //saves to LocalDataStorage and Parse

    func getUserFriends(){
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name"])
        graphRequest.startWithCompletionHandler{ (connection, result, error) -> Void in
            if error != nil {
                print(print("Error: \(error!) \(error!.userInfo)"))
            }
            else if let result = result {
                let userId = result["id"]! as! String
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                let facebookFriendsUrl = "https://graph.facebook.com/\(userId)/friends?access_token=\(accessToken)"
                
                if let fbfriendsUrl = NSURL(string: facebookFriendsUrl) {
                    
                    if let data = NSData(contentsOfURL: fbfriendsUrl) {
                        //background thread to parse the JSON data
                        
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                            do{
                                let friendList: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                                
                                if let data = friendList["data"] as? [[String: AnyObject]] {
                                    var friendsArray:[String] = []
                                    var friendsArrayFbId:[String] = []
                                    for item in data {
                                        if let name = item["name"] as? String {
                                            if let id = item["id"] as? String {
                                                
                                                //print("\(name)'s id is \(id)")
                                                friendsArrayFbId.append(id)
                                                let query = PFQuery(className:"_User")
                                                query.whereKey("fb_id", equalTo:id)
                                                let objects = try query.findObjects()
                                                for object in objects {
                                                    friendsArray.append(object.objectId!)
                                                }
                                                
                                            }
                                            else {
                                                print("Error: \(error!) \(error!.userInfo)")
                                            }
                                            
                                        }
                                    }
                                    //Update Parse DB to store the FBfriendlist
                                    
                                    PFUser.currentUser()?["fb_friends"] = friendsArrayFbId
                                   
                                    
                                    //Update Iphone's local storage and Parse to store the friendlist
                                    let localData = LocalData()
                                    if let localFriendList = localData.getFriendList() {
                                        var finalFriendList = localFriendList
                                        for friend in friendsArray {
                                            if finalFriendList.contains(friend){
                                                
                                            }
                                            else{
                                                finalFriendList.append(friend)
                                            }
                                        }
                                        localData.setFriendList(finalFriendList)
                                        localData.synchronize()
                                        PFUser.currentUser()?["friend_list"] = finalFriendList
                                        
                                    }
                                    else {
                                    localData.setFriendList(friendsArray)
                                    localData.synchronize()
                                    PFUser.currentUser()?["friend_list"] = friendsArray
                                    }
                                    //print("friends array -\(friendsArray)")
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
    func runBridgeAlgorithmOnCloud(){
        if let friendList = PFUser.currentUser()?["friend_list"] as? [String] {
            PFCloud.callFunctionInBackground("updateBridgePairingsTable", withParameters: ["friendList":friendList]) {
                (response: AnyObject?, error: NSError?) -> Void in
                if let ratings = response as? String {
                    print(ratings)
                }
                else {
                    print(error)
                }
            }
            
        }
    }
    func getBridgePairings(){
        if let friendList = PFUser.currentUser()?["friend_list"] as? [String] {
                        //print("ratings")
                        PFCloud.callFunctionInBackground("updateBridgePairingsTable", withParameters: ["friendList":friendList]) {
                            (response: AnyObject?, error: NSError?) -> Void in
                            if let ratings = response as? String {
                                print(ratings)
                            }
                            else {
                                print(error)
                            }
                        }
        }
 //       getBridgePairingsFromCloud()
//             var ignoredPairings = [[String]]()
//        
//        if let builtBridges = PFUser.currentUser()?["built_bridges"] {
//            let builtBridges2 = builtBridges as! [[String]]
//            ignoredPairings = ignoredPairings + builtBridges2
//        }
//        
//        if let rejectedBridges = PFUser.currentUser()?["rejected_bridges"] {
//            let rejectedBridges2 = rejectedBridges as! [[String]]
//            ignoredPairings = ignoredPairings + rejectedBridges2
//        }
//        var friendPairings =  [[String]]()
//        
//        if let friendList = PFUser.currentUser()?["friend_list"] as? [String] {
//            print("ratings")
//            PFCloud.callFunctionInBackground("updateBridgePairingsTable", withParameters: ["friendList":friendList]) {
//                (response: AnyObject?, error: NSError?) -> Void in
//                if let ratings = response as? String {
//                    print(ratings)
//                }
//                else {
//                    print(error)
//                }
//            }
//
//            var pairings = [UserInfoPair]()
//            for friend1 in friendList {
//                if friendPairings.count >= 10 {
//                    break
//                }
//                for friend2 in friendList {
//                    if friendPairings.count >= 10 {
//                        break
//                    }
//                    let containedInIgnoredPairings = ignoredPairings.contains {$0 == [friend1, friend2]} || ignoredPairings.contains {$0 == [friend2, friend1]}
//                    
//                    let PreviouslyDisplayedUser = friendPairings.contains {$0 == [friend1, friend2]} || friendPairings.contains {$0 == [friend2, friend1]}
//                    
//
//                    if PreviouslyDisplayedUser == false && friend1 != friend2 && containedInIgnoredPairings == false  {
//                        friendPairings.append([friend1,friend2])
//                        var user1:PairInfo? = nil
//                        var user2:PairInfo? = nil
//                        user1 = getUserDetails(friend1)
//                        user2 = getUserDetails(friend2)
//                        
//                        let userInfoPair = UserInfoPair(user1: user1, user2: user2)
//                        pairings.append(userInfoPair)
//                    }
//                    
//                }
//                
//            }
//            let localData = LocalData()
//            localData.setPairings(pairings)
//            localData.synchronize()
//        }
        
    }
    func waitForCardsToBeDownloaded() -> Bool {
        
//        print("totalObjects == objectsDownloaded \(totalObjects) == \(objectsDownloaded)")
//        if objectsDownloaded > 0 && totalObjects == objectsDownloaded {
//            result = false
//        }
        return result
    }
    func getBridgePairingsFromCloud(maxNoOfCards:Int, typeOfCards:String){
//        var pairings = [UserInfoPair]()
        let bridgePairings = LocalData().getPairings()
        var pairings = [UserInfoPair]()
        if (bridgePairings != nil) {
            pairings = bridgePairings!
        }
        if let _ = PFUser.currentUser()?.objectId {
        let query = PFQuery(className:"BridgePairings")
        query.whereKey("user_objectIds", notEqualTo:(PFUser.currentUser()?.objectId)!) //change this to notEqualTo
        query.whereKey("checked_out", equalTo: false)
        query.whereKey("shown_to", notEqualTo:(PFUser.currentUser()?.objectId)!)
        if (typeOfCards != "All") {
            query.whereKey("bridge_type", equalTo: typeOfCards)
        }
        query.limit = maxNoOfCards
//        let err = NSErrorPointer()
//        totalObjects =  query.countObjects(err)
        print("totalObjects \(totalObjects)")
           do {
                let results = try query.findObjects()
            
            
           // query.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                                //if let results = results {
                                    print("Hi")
                                    for result in results {
                                        var user1:PairInfo? = nil
                                        var user2:PairInfo? = nil
                                        var name1:String? = nil
                                        var name2:String? = nil
                                        if let ob = result["user1_name"] {
                                            name1 = ob as? String
                
                                        }
                                        if let ob = result["user2_name"] {
                                            name2 = ob as? String
                                        }
                                        print("name2 - \(name2)")
                                        var location1:[Double]? = nil
                                        var location2:[Double]? = nil
                                        if let ob = result["user_locations"] as? [PFGeoPoint]{
                                            location1 = [ob[0].latitude, ob[0].longitude]
                                            location2 = [ob[1].latitude, ob[1].longitude]
                                        }
                                        print("location1 - \(location2)")
                                        var profilePicture1:NSData? = nil
                                        var profilePicture2:NSData? = nil
                                        

                                        if let ob = result["user1_profile_picture"] {
                                            let main_profile_picture_file = ob as! PFFile
                                            profilePicture1 = try main_profile_picture_file.getData()
                                        }
                                        if let ob = result["user2_profile_picture"] {
                                            let main_profile_picture_file = ob as! PFFile
                                            profilePicture2 = try main_profile_picture_file.getData()
                                        }
                
                                        var bridgeStatus1:String? = nil
                                        var bridgeStatus2:String? = nil
                                        if let ob = result["user1_bridge_status"] {
                                            bridgeStatus1 =  ob as? String
                                        }
                                        if let ob = result["user2_bridge_status"] {
                                            bridgeStatus2 =  ob as? String
                                        }
                
                
                                        var bridgeType1:String? = nil
                                        var bridgeType2:String? = nil
                                        if let ob = result["bridge_type"] {
                                            bridgeType1 =  ob as? String
                                            bridgeType2 =  ob as? String
                                        }
                                        
                                        var objectId1:String? = nil
                                        var objectId2:String? = nil
                                        if let ob = result.objectId {
                                            objectId1 =  ob as String
                                            objectId2 =  ob as String
                                        }
                                        var userId1:String? = nil
                                        var userId2:String? = nil
                                        if let ob = result["user_objectIds"] as? [String] {
                                            userId1 =  ob[0]
                                            userId2 =  ob[1]
                                        }

                                        result["checked_out"]  = true
                                        if let _ = result["shown_to"] {
                                            if var ar = result["shown_to"] as? [String] {
                                                let s = (PFUser.currentUser()?.objectId)! as String
                                                ar.append(s)
                                                result["shown_to"] = ar
                                            }
                                            else {
                                                result["shown_to"] = [(PFUser.currentUser()?.objectId)!]
                                            }
                                        }
                                        else {
                                            result["shown_to"] = [(PFUser.currentUser()?.objectId)!]
                                        }
                                        result.saveInBackground()
                
                                        user1 = PairInfo(name:name1, mainProfilePicture: profilePicture1, profilePictures: nil,location: location1, bridgeStatus: bridgeStatus1, objectId: objectId1,  bridgeType: bridgeType1, userId: userId1)
                                        user2 = PairInfo(name:name2, mainProfilePicture: profilePicture2, profilePictures: nil,location: location2, bridgeStatus: bridgeStatus2, objectId: objectId2,  bridgeType: bridgeType2, userId: userId2)
                                        let userInfoPair = UserInfoPair(user1: user1, user2: user2)
                                        pairings.append(userInfoPair)
                                        print("userId1, userId2 - \(userId1),\(userId2)")
                                        
                                    }
                                    let localData = LocalData()
                                    localData.setPairings(pairings)
                                    localData.synchronize()
                
            
            }
            catch {
                
            }

        
    }
    }
}