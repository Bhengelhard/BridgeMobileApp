//
//  UserInfo.swift
//  MyBridgeApp
//
//  Created by Sagar Sinha on 6/14/16. cIgAr.
//  Copyright © 2016 BHE Ventures LLC. All rights reserved.
//

import Foundation
class UserInfo:NSObject, NSCoding  {
    var username: String? = nil
    var interestedIn: String? = nil
    var friendlist: [String]? = []
    var mainProfilePicture: Data? = nil
    var pairings:[UserInfoPair]? = nil
    var profilePictureFromFb:Bool? = nil
    var newMessagesPushNotifications:Bool? = nil
    var newBridgesPushNotifications:Bool? = nil
    var firstTimeOnBridgeVC:Bool? = nil
    var firstTimeSwipingLeft:Bool? = nil
    var hasSignedUp:Bool? = nil
    var businessStatus:String? = nil
    var loveStatus:String? = nil
    var friendshipStatus:String? = nil
    var numConnectionsNected:Int? = nil
    var myGender:String? = nil
    var interestedInLove:Bool? = nil
    var hasProvidedAccessCode:Bool? = nil
    
    init( username:String?, friendlist: [String]?, mainProfilePicture: Data? ,pairings:[UserInfoPair]?,
          interestedIn: String?, profilePictureFromFb:Bool?, newMessagesPushNotifications:Bool?, newBridgesPushNotifications:Bool?, firstTimeOnBridgeVC:Bool?, firstTimeSwipingLeft:Bool?, hasSignedUp:Bool?, businessStatus:String?, loveStatus: String?, friendshipStatus: String?, numConnectionsNected: Int?, myGender: String?, interestedInLove: Bool?, hasProvidedAccessCode: Bool?) {
        self.username = username
        self.friendlist = friendlist
        self.mainProfilePicture = mainProfilePicture
        self.pairings = pairings
        self.interestedIn = interestedIn
        self.profilePictureFromFb = profilePictureFromFb
        self.newMessagesPushNotifications = newMessagesPushNotifications
        self.newBridgesPushNotifications = newBridgesPushNotifications
        self.firstTimeOnBridgeVC = firstTimeOnBridgeVC
        self.firstTimeSwipingLeft = firstTimeSwipingLeft
        self.hasSignedUp = hasSignedUp
        self.businessStatus = businessStatus
        self.loveStatus = loveStatus
        self.friendshipStatus = friendshipStatus
        self.numConnectionsNected = numConnectionsNected
        self.myGender = myGender
        self.interestedInLove = interestedInLove
        self.hasProvidedAccessCode = hasProvidedAccessCode
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let username = aDecoder.decodeObject(forKey: "username") as! String?
        let friendlist = aDecoder.decodeObject(forKey: "friendlist") as! [String]?
        let mainProfilePicture = aDecoder.decodeObject(forKey: "mainProfilePicture") as! Data?
        let pairings = aDecoder.decodeObject(forKey: "pairings") as! [UserInfoPair]?
        let interestedIn = aDecoder.decodeObject(forKey: "interestedIn") as! String?
        let profilePictureFromFb = aDecoder.decodeObject(forKey: "profilePictureFromFb") as! Bool?
        let newMessagesPushNotifications = aDecoder.decodeObject(forKey: "newMessagesPushNotifications") as! Bool?
        let newBridgesPushNotifications = aDecoder.decodeObject(forKey: "newBridgesPushNotifications") as! Bool?
        let firstTimeOnBridgeVC = aDecoder.decodeObject(forKey: "firstTimeOnBridgeVC") as! Bool?
        let firstTimeSwipingLeft = aDecoder.decodeObject(forKey: "firstTimeSwipingLeft") as! Bool?
        let hasSignedUp = aDecoder.decodeObject(forKey: "hasSignedUp") as! Bool?
        let businessStatus = aDecoder.decodeObject(forKey: "businessStatus") as! String?
        let loveStatus = aDecoder.decodeObject(forKey: "loveStatus") as! String?
        let friendshipStatus = aDecoder.decodeObject(forKey: "friendshipStatus") as! String?
        let numConnectionsNected = aDecoder.decodeObject(forKey: "numConnectionsNected") as! Int?
        let myGender = aDecoder.decodeObject(forKey: "myGender") as! String?
        let interestedInLove = aDecoder.decodeObject(forKey: "interestedInLove") as! Bool?
        let hasProvidedAccessCode = aDecoder.decodeObject(forKey: "hasProvidedAccessCode") as! Bool?
        
        self.init(username: username, friendlist: friendlist, mainProfilePicture: mainProfilePicture, pairings: pairings, interestedIn: interestedIn, profilePictureFromFb: profilePictureFromFb, newMessagesPushNotifications:newMessagesPushNotifications, newBridgesPushNotifications:newBridgesPushNotifications, firstTimeOnBridgeVC: firstTimeOnBridgeVC, firstTimeSwipingLeft: firstTimeSwipingLeft, hasSignedUp: hasSignedUp, businessStatus: businessStatus, loveStatus: loveStatus, friendshipStatus: friendshipStatus, numConnectionsNected: numConnectionsNected, myGender: myGender, interestedInLove: interestedInLove, hasProvidedAccessCode: hasProvidedAccessCode)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(username, forKey: "username")
        aCoder.encode(friendlist, forKey: "friendlist")
        aCoder.encode(mainProfilePicture, forKey: "mainProfilePicture")
        aCoder.encode(pairings, forKey: "pairings")
        aCoder.encode(interestedIn, forKey: "interestedIn")
        aCoder.encode(profilePictureFromFb, forKey: "profilePictureFromFb")
        aCoder.encode(newMessagesPushNotifications, forKey: "newMessagesPushNotifications")
        aCoder.encode(newBridgesPushNotifications, forKey: "newBridgesPushNotifications")
        aCoder.encode(firstTimeOnBridgeVC, forKey:  "firstTimeOnBridgeVC")
        aCoder.encode(firstTimeSwipingLeft, forKey:  "firstTimeSwipingLeft")
        aCoder.encode(hasSignedUp, forKey:  "hasSignedUp")
        aCoder.encode(businessStatus, forKey: "businessStatus")
        aCoder.encode(loveStatus, forKey: "loveStatus")
        aCoder.encode(friendshipStatus, forKey: "friendshipStatus")
        aCoder.encode(numConnectionsNected, forKey: "numConnectionsNected")
        aCoder.encode(myGender, forKey: "myGender")
        aCoder.encode(interestedInLove, forKey: "interestedInLove")
        aCoder.encode(hasProvidedAccessCode, forKey: "hasProvidedAccessCode")
        
    }
    
}
