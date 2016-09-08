//
//  UserInfo.swift
//  MyBridgeApp
//
//  Created by Sagar Sinha on 6/14/16. cIgAr.
//  Copyright © 2016 SagarSinha. All rights reserved.
//

import Foundation
class UserInfo:NSObject, NSCoding  {
    var username: String? = nil
    var interestedIn: String? = nil
    var friendlist: [String]? = []
    var mainProfilePicture: NSData? = nil
    var pairings:[UserInfoPair]? = nil
    var profilePictureFromFb:Bool? = nil
    var newMessagesPushNotifications:Bool? = nil
    var newBridgesPushNotifications:Bool? = nil
    var firstTimeSwipingRight:Bool? = nil
    var firstTimeSwipingLeft:Bool? = nil
    init( username:String?, friendlist: [String]?, mainProfilePicture: NSData? ,pairings:[UserInfoPair]?,
          interestedIn: String?, profilePictureFromFb:Bool?, newMessagesPushNotifications:Bool?, newBridgesPushNotifications:Bool?, firstTimeSwipingRight:Bool?, firstTimeSwipingLeft:Bool?) {
        self.username = username
        self.friendlist = friendlist
        self.mainProfilePicture = mainProfilePicture
        self.pairings = pairings
        self.interestedIn = interestedIn
        self.profilePictureFromFb = profilePictureFromFb
        self.newMessagesPushNotifications = newMessagesPushNotifications
        self.newBridgesPushNotifications = newBridgesPushNotifications
        self.firstTimeSwipingRight = firstTimeSwipingRight
        self.firstTimeSwipingLeft = firstTimeSwipingLeft
        
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let username = aDecoder.decodeObjectForKey("username") as! String?
        let friendlist = aDecoder.decodeObjectForKey("friendlist") as! [String]?
        let mainProfilePicture = aDecoder.decodeObjectForKey("mainProfilePicture") as! NSData?
        let pairings = aDecoder.decodeObjectForKey("pairings") as! [UserInfoPair]?
        let interestedIn = aDecoder.decodeObjectForKey("interestedIn") as! String?
        let profilePictureFromFb = aDecoder.decodeObjectForKey("profilePictureFromFb") as! Bool?
        let newMessagesPushNotifications = aDecoder.decodeObjectForKey("newMessagesPushNotifications") as! Bool?
        let newBridgesPushNotifications = aDecoder.decodeObjectForKey("newBridgesPushNotifications") as! Bool?
        let firstTimeSwipingRight = aDecoder.decodeObjectForKey("firstTimeSwipingRight") as! Bool?
        let firstTimeSwipingLeft = aDecoder.decodeObjectForKey("firstTimeSwipingLeft") as! Bool?
        
        self.init(username: username, friendlist: friendlist, mainProfilePicture: mainProfilePicture, pairings: pairings, interestedIn: interestedIn, profilePictureFromFb: profilePictureFromFb, newMessagesPushNotifications:newMessagesPushNotifications,
                  newBridgesPushNotifications:newBridgesPushNotifications, firstTimeSwipingRight: firstTimeSwipingRight, firstTimeSwipingLeft: firstTimeSwipingLeft)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(username, forKey: "username")
        aCoder.encodeObject(friendlist, forKey: "friendlist")
        aCoder.encodeObject(mainProfilePicture, forKey: "mainProfilePicture")
        aCoder.encodeObject(pairings, forKey: "pairings")
        aCoder.encodeObject(interestedIn, forKey: "interestedIn")
        aCoder.encodeObject(profilePictureFromFb, forKey: "profilePictureFromFb")
        aCoder.encodeObject(newMessagesPushNotifications, forKey: "newMessagesPushNotifications")
        aCoder.encodeObject(newBridgesPushNotifications, forKey: "newBridgesPushNotifications")
        aCoder.encodeObject(firstTimeSwipingRight, forKey:  "firstTimeSwipingRight")
        aCoder.encodeObject(firstTimeSwipingLeft, forKey:  "firstTimeSwipingLeft")
    }
    
}