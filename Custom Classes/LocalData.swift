//
//  LocalData.swift
//  MyBridgeApp
//
//  Created by Sagar Sinha on 6/15/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
class LocalData {
    
    var username:String? = nil
    var friendlist: [String]? = nil
    var mainProfilePicture: Data? = nil
    var pairings:[UserInfoPair]? = nil
    var interestedIn:String? = nil
    var profilePictureFromFb:Bool? = nil
    var newMessagesPushNotifications:Bool? = nil
    var newBridgesPushNotifications:Bool? = nil
    var firstTimeSwipingRight:Bool? = nil
    var firstTimeSwipingLeft:Bool? = nil
    var hasSignedUp:Bool? = nil
    var businessStatus:String? = nil
    var loveStatus:String? = nil
    var friendshipStatus:String? = nil
    
    init(){
        let userDefaults = UserDefaults.standard
        if let decoded = userDefaults.object(forKey: "userInfo") {
            if let userInfo = NSKeyedUnarchiver.unarchiveObject(with: decoded as! Data) {
                username = (userInfo as! UserInfo).username
                friendlist = (userInfo as! UserInfo).friendlist
                mainProfilePicture = (userInfo as! UserInfo).mainProfilePicture as Data?
                pairings = (userInfo as! UserInfo).pairings
                interestedIn = (userInfo as! UserInfo).interestedIn
                profilePictureFromFb = (userInfo as! UserInfo).profilePictureFromFb
                newMessagesPushNotifications = (userInfo as! UserInfo).newMessagesPushNotifications
                newBridgesPushNotifications = (userInfo as! UserInfo).newBridgesPushNotifications
                firstTimeSwipingRight = (userInfo as! UserInfo).firstTimeSwipingRight
                firstTimeSwipingLeft = (userInfo as! UserInfo).firstTimeSwipingLeft
                hasSignedUp = (userInfo as! UserInfo).hasSignedUp
                businessStatus = (userInfo as! UserInfo).businessStatus
                loveStatus = (userInfo as! UserInfo).loveStatus
                friendshipStatus = (userInfo as! UserInfo).friendshipStatus
            }
        }
    }
    
    func setLoveStatus(_ loveStatus:String){
        self.loveStatus = loveStatus
        print("setting loveStatus from local data file")
    }
    func getLoveStatus()-> String?{
        let userDefaults = UserDefaults.standard
        if let _ = userDefaults.object(forKey: "userInfo"){
            let decoded  = userDefaults.object(forKey: "userInfo") as! Data
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UserInfo
            print("getting loveStatus from local data file")
            return userInfo.loveStatus
        }
        else{
            return nil
        }
    }
    func setFriendshipStatus(_ friendshipStatus:String){
        self.friendshipStatus = friendshipStatus
        print("setting business status from local data file")
    }
    func getFriendshipStatus()-> String?{
        let userDefaults = UserDefaults.standard
        if let _ = userDefaults.object(forKey: "userInfo"){
            let decoded  = userDefaults.object(forKey: "userInfo") as! Data
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UserInfo
            print("getting business status from local data file")
            return userInfo.friendshipStatus
        }
        else{
            return nil
        }
    }
    func setBusinessStatus(_ businessStatus:String){
        self.businessStatus = businessStatus
        print("setting business status from local data file")
    }
    func getBusinessStatus()-> String?{
        let userDefaults = UserDefaults.standard
        if let _ = userDefaults.object(forKey: "userInfo"){
            let decoded  = userDefaults.object(forKey: "userInfo") as! Data
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UserInfo
            print("getting business status from local data file")
            return userInfo.businessStatus
        }
        else{
            return nil
        }
    }
    
    func setHasSignedUp(_ hasSignedUp:Bool){
        self.hasSignedUp = hasSignedUp
    }
    func getHasSignedUp()->Bool? {
        let userDefaults = UserDefaults.standard
        if let _ = userDefaults.object(forKey: "userInfo"){
            let decoded  = userDefaults.object(forKey: "userInfo") as! Data
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UserInfo
            return userInfo.hasSignedUp
        }
        else{
            return nil
        }
    }
    
    func setFirstTimeSwipingRight(_ firstTimeSwipingRight:Bool){
        self.firstTimeSwipingRight = firstTimeSwipingRight
    }
    func getFirstTimeSwipingRight()->Bool? {
        let userDefaults = UserDefaults.standard
        if let _ = userDefaults.object(forKey: "userInfo"){
            let decoded  = userDefaults.object(forKey: "userInfo") as! Data
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UserInfo
            return userInfo.firstTimeSwipingRight
        }
        else{
            return nil
        }
    }
    func setFirstTimeSwipingLeft(_ firstTimeSwipingLeft:Bool){
        self.firstTimeSwipingLeft = firstTimeSwipingLeft
    }
    func getFirstTimeSwipingLeft()->Bool? {
        let userDefaults = UserDefaults.standard
        if let _ = userDefaults.object(forKey: "userInfo"){
            let decoded  = userDefaults.object(forKey: "userInfo") as! Data
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UserInfo
            return userInfo.firstTimeSwipingLeft
        }
        else{
            return nil
        }
    }
    
    
    
    func setUsername(_ username:String){
        self.username = username
    }
    func getUsername()-> String?{
        let userDefaults = UserDefaults.standard
        if let _ = userDefaults.object(forKey: "userInfo"){
        let decoded  = userDefaults.object(forKey: "userInfo") as! Data
        let userInfo = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UserInfo
        return userInfo.username
        }
        else{
        return nil
        }
    }
    
    
    func setInterestedIN(_ interestedIn:String){
        self.interestedIn = interestedIn
    }
    func getInterestedIN()-> String?{
        let userDefaults = UserDefaults.standard
        if let _ = userDefaults.object(forKey: "userInfo"){
        let decoded  = userDefaults.object(forKey: "userInfo") as! Data
        let userInfo = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UserInfo
        return userInfo.interestedIn
        }
        else{
            return nil
        }
    }
    
    
    func setProfilePictureFromFb(_ profilePictureFromFb:Bool){
        self.profilePictureFromFb = profilePictureFromFb
    }
    
    func getProfilePictureFromFb()-> Bool?{
        let userDefaults = UserDefaults.standard
        if let _ = userDefaults.object(forKey: "userInfo"){
        let decoded  = userDefaults.object(forKey: "userInfo") as! Data
        let userInfo = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UserInfo
        return userInfo.profilePictureFromFb
        }
        else{
            return nil
        }
    }
    
    func setNewMessagesPushNotifications(_ newMessagesPushNotifications:Bool){
        self.newMessagesPushNotifications = newMessagesPushNotifications
    }
    func getNewMessagesPushNotifications()-> Bool?{
        let userDefaults = UserDefaults.standard
        if let _ = userDefaults.object(forKey: "userInfo"){
        let decoded  = userDefaults.object(forKey: "userInfo") as! Data
        let userInfo = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UserInfo
        return userInfo.newMessagesPushNotifications
        }
        else{
            return nil
        }
    }

    
    func setNewBridgesPushNotifications(_ newBridgesPushNotifications:Bool){
        self.newBridgesPushNotifications = newBridgesPushNotifications
    }
    func getNewBridgesPushNotifications()-> Bool?{
        let userDefaults = UserDefaults.standard
        if let _ = userDefaults.object(forKey: "userInfo"){
        let decoded  = userDefaults.object(forKey: "userInfo") as! Data
        let userInfo = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UserInfo
        return userInfo.newBridgesPushNotifications
        }
        else{
            return nil
        }
    }



    func setFriendList(_ friendlist: [String]){
        self.friendlist = friendlist
    }
    func getFriendList()-> [String]?{
        let userDefaults = UserDefaults.standard
        if let _ = userDefaults.object(forKey: "userInfo"){
        let decoded  = userDefaults.object(forKey: "userInfo") as! Data
        let userInfo = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UserInfo
        return userInfo.friendlist
        }
        else{
            return nil
        }

    }
    
    
    func setMainProfilePicture(_ mainProfilePicture:Data){
        self.mainProfilePicture = mainProfilePicture
    }
    
    func getMainProfilePicture()->Data?{
        let userDefaults = UserDefaults.standard
        if let _ = userDefaults.object(forKey: "userInfo"){
        let decoded  = userDefaults.object(forKey: "userInfo") as! Data
        let userInfo = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UserInfo
        return userInfo.mainProfilePicture as Data?
        }
        else{
            return nil
        }
    }
    
    
    
    // add an array of pairs
    func setPairings(_ pairings:[UserInfoPair]){
        self.pairings = pairings
    }
    // add a single pair
    func addPair(_ userInfoPair:UserInfoPair){
        if var pairings = pairings{
            pairings.append(userInfoPair)
        }
        else{
            pairings = [userInfoPair]
        }
    }
    func getPairings()->[UserInfoPair]?{
        let userDefaults = UserDefaults.standard
        if let _ = userDefaults.object(forKey: "userInfo"){
        let decoded  = userDefaults.object(forKey: "userInfo") as! Data
        let userInfo = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UserInfo
        return userInfo.pairings
        }
        else{
            return nil
        }
    }
    
    
    
    func synchronize(){
        //print("Setting mainProfilePicture to \(mainProfilePicture)")
        let userInfo:UserInfo = UserInfo(username: username, friendlist: friendlist, mainProfilePicture: mainProfilePicture, pairings:pairings, interestedIn: interestedIn, profilePictureFromFb:profilePictureFromFb, newMessagesPushNotifications:newMessagesPushNotifications, newBridgesPushNotifications:newBridgesPushNotifications, firstTimeSwipingRight: firstTimeSwipingRight, firstTimeSwipingLeft: firstTimeSwipingLeft, hasSignedUp: hasSignedUp, businessStatus: businessStatus, loveStatus: loveStatus, friendshipStatus: friendshipStatus)
        let userDefaults = UserDefaults.standard
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: userInfo)
        userDefaults.set(encodedData, forKey: "userInfo")
        userDefaults.synchronize()
    }
    
}
