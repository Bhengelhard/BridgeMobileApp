//
//  LocalData.swift
//  MyBridgeApp
//
//  Created by Sagar Sinha on 6/15/16.
//  Copyright © 2016 BHE Ventures LLC. All rights reserved.
//

import Foundation
class LocalData {
    
    // MARK: - Global Variables
    
    /// Saves the current User's name
    var username:String? = nil
    
    /// Saves the current User's friend list
    var friendlist: [String]? = nil
    
    /// Saves the current User's main profile picture
    var mainProfilePicture: Data? = nil
    
    /// Saves the bridge pairings on the user's device to display on the BridgeViewController
    var pairings:[UserInfoPair]? = nil
    
    /// Indicates the gender the current user is interested in
    var interestedIn:String? = nil
    
    /// Indicates whether the current User is using their main profile picture from fb for their main profile picture on necter
    var profilePictureFromFb:Bool? = nil
    
    var newMessagesPushNotifications:Bool? = nil
    var newBridgesPushNotifications:Bool? = nil
    
    /// Indicates whether the user is viewing the BridgeViewController for the first time
    var firstTimeOnBridgeVC:Bool? = nil
    
    /// Indicates whether the current User has swiped left since signing up
    var firstTimeSwipingLeft:Bool? = nil
    
    /// Indicates whether the current User has completed the sign up process
    var hasSignedUp:Bool? = nil
    
    /// Indicates the current User's most recent business status (a.k.a. request)
    var businessStatus:String? = nil
    
    /// Indicates the current User's most recent love status (a.k.a. request)
    var loveStatus:String? = nil
    
    /// Indicates the current User's most recent friendship status (a.k.a. request)
    var friendshipStatus:String? = nil
    
    /// Indicates the number of connections the current User had created
    var numConnectionsNected:Int? = nil
    
    /// Indicates the user's gender
    var myGender:String? = nil
    
    /// Indicates whether the user is interested in being connected for love
    var interestedInLove: Bool? = nil
    
    /// Indicates whether the user has entered an access code
    var hasProvidedAccessCode: Bool? = nil
    
    // MARK: -
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
                firstTimeOnBridgeVC = (userInfo as! UserInfo).firstTimeOnBridgeVC
                firstTimeSwipingLeft = (userInfo as! UserInfo).firstTimeSwipingLeft
                hasSignedUp = (userInfo as! UserInfo).hasSignedUp
                businessStatus = (userInfo as! UserInfo).businessStatus
                loveStatus = (userInfo as! UserInfo).loveStatus
                friendshipStatus = (userInfo as! UserInfo).friendshipStatus
                numConnectionsNected = (userInfo as! UserInfo).numConnectionsNected
                myGender = (userInfo as! UserInfo).myGender
                interestedInLove = (userInfo as! UserInfo).interestedInLove
                hasProvidedAccessCode = (userInfo as! UserInfo).hasProvidedAccessCode
            }
        }
    }
    
    // MARK: - Set and Get Functions
    
    //Saving whether the currentUser has provided an access code
    func setHasProvidedAccessCode(_ hasProvidedAccessCode: Bool) {
        self.hasProvidedAccessCode = hasProvidedAccessCode
    }
    func getHasProvidedAccessCode() -> Bool? {
        let userDefaults = UserDefaults.standard
        if let _ = userDefaults.object(forKey: "userInfo"){
            let decoded  = userDefaults.object(forKey: "userInfo") as! Data
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UserInfo
            return userInfo.hasProvidedAccessCode
        }
        else{
            return nil
        }
    }
    
    
    //Saving whether the currentUser's is interested in love
    func setInterestedInLove(_ interestedInLove: Bool) {
        self.interestedInLove = interestedInLove
    }
    func getInterestedInLove() -> Bool? {
        let userDefaults = UserDefaults.standard
        if let _ = userDefaults.object(forKey: "userInfo"){
            let decoded  = userDefaults.object(forKey: "userInfo") as! Data
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UserInfo
            return userInfo.interestedInLove
        }
        else{
            return nil
        }
    }
    
    //Saving the currentUser's gender
    func setMyGender(_ myGender: String) {
        self.myGender = myGender
    }
    
    func getMyGender() -> String? {
        let userDefaults = UserDefaults.standard
        if let _ = userDefaults.object(forKey: "userInfo"){
            let decoded  = userDefaults.object(forKey: "userInfo") as! Data
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UserInfo
            return userInfo.myGender
        }
        else{
            return nil
        }
    }
    
    /*
    func getMyGender() -> Gender? {
        let userDefaults = UserDefaults.standard
        if let _ = userDefaults.object(forKey: "userInfo") {
            let decoded  = userDefaults.object(forKey: "userInfo") as! Data
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UserInfo
            if let myGender = userInfo.myGender {
                let myGenderLowercased = myGender.lowercased()
                if myGenderLowercased == "male" {
                    return .male
                }
                if myGenderLowercased == "female" {
                    return .female
                }
                return .other
            }
        }
        return nil
    }
     */

    
    //Saving number of connections the currentUser has connected to the user's device
    func setNumConnectionsNected(_ numConnectionsNected: Int) {
        self.numConnectionsNected = numConnectionsNected
    }
    func getNumConnectionsNected() -> Int? {
        let userDefaults = UserDefaults.standard
        if let _ = userDefaults.object(forKey: "userInfo"){
            let decoded  = userDefaults.object(forKey: "userInfo") as! Data
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UserInfo
            return userInfo.numConnectionsNected
        }
        else{
            return nil
        }
    }
    
    //Saving user's current Status (a.k.a. requests) to the device
    func setLoveStatus(_ loveStatus:String){
        self.loveStatus = loveStatus
    }
    func getLoveStatus()-> String?{
        let userDefaults = UserDefaults.standard
        if let _ = userDefaults.object(forKey: "userInfo"){
            let decoded  = userDefaults.object(forKey: "userInfo") as! Data
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UserInfo
            return userInfo.loveStatus
        }
        else{
            return nil
        }
    }
    
    func setFriendshipStatus(_ friendshipStatus:String){
        self.friendshipStatus = friendshipStatus
    }
    func getFriendshipStatus()-> String?{
        let userDefaults = UserDefaults.standard
        if let _ = userDefaults.object(forKey: "userInfo"){
            let decoded  = userDefaults.object(forKey: "userInfo") as! Data
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UserInfo
            return userInfo.friendshipStatus
        }
        else{
            return nil
        }
    }
    
    func setBusinessStatus(_ businessStatus:String){
        self.businessStatus = businessStatus
    }
    func getBusinessStatus()-> String?{
        let userDefaults = UserDefaults.standard
        if let _ = userDefaults.object(forKey: "userInfo"){
            let decoded  = userDefaults.object(forKey: "userInfo") as! Data
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UserInfo
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
    
    func setFirstTimeOnBridgeVC(_ firstTimeOnBridgeVC:Bool){
        self.firstTimeOnBridgeVC = firstTimeOnBridgeVC
    }
    func getFirstTimeOnBridgeVC()->Bool? {
        let userDefaults = UserDefaults.standard
        if let _ = userDefaults.object(forKey: "userInfo"){
            let decoded  = userDefaults.object(forKey: "userInfo") as! Data
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UserInfo
            return userInfo.firstTimeOnBridgeVC
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
    
    //Saving the gender the currentUser's is Interested In
    func setInterestedIn(_ interestedIn:String){
        self.interestedIn = interestedIn
    }
    func getInterestedIn()-> String?{
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
    
    // MARK: -
    // This function saves the local data to the device
    func synchronize(){
        let userInfo:UserInfo = UserInfo(username: username, friendlist: friendlist, mainProfilePicture: mainProfilePicture, pairings:pairings, interestedIn: interestedIn, profilePictureFromFb:profilePictureFromFb, newMessagesPushNotifications:newMessagesPushNotifications, newBridgesPushNotifications:newBridgesPushNotifications, firstTimeOnBridgeVC: firstTimeOnBridgeVC, firstTimeSwipingLeft: firstTimeSwipingLeft, hasSignedUp: hasSignedUp, businessStatus: businessStatus, loveStatus: loveStatus, friendshipStatus: friendshipStatus, numConnectionsNected: numConnectionsNected, myGender: myGender, interestedInLove: interestedInLove, hasProvidedAccessCode: hasProvidedAccessCode)
        let userDefaults = UserDefaults.standard
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: userInfo)
        userDefaults.set(encodedData, forKey: "userInfo")
        userDefaults.synchronize()
    }
    
}
