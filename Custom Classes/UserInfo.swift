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
    var mainProfilePicture: Data? = nil
    var pairings:[UserInfoPair]? = nil
    var profilePictureFromFb:Bool? = nil
    var newMessagesPushNotifications:Bool? = nil
    var newBridgesPushNotifications:Bool? = nil
    var firstTimeSwipingRight:Bool? = nil
    var firstTimeSwipingLeft:Bool? = nil
    var hasSignedUp:Bool? = nil
    init( username:String?, friendlist: [String]?, mainProfilePicture: Data? ,pairings:[UserInfoPair]?,
          interestedIn: String?, profilePictureFromFb:Bool?, newMessagesPushNotifications:Bool?, newBridgesPushNotifications:Bool?, firstTimeSwipingRight:Bool?, firstTimeSwipingLeft:Bool?, hasSignedUp:Bool?) {
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
        self.hasSignedUp = hasSignedUp
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
        let firstTimeSwipingRight = aDecoder.decodeObject(forKey: "firstTimeSwipingRight") as! Bool?
        let firstTimeSwipingLeft = aDecoder.decodeObject(forKey: "firstTimeSwipingLeft") as! Bool?
        let hasSignedUp = aDecoder.decodeObject(forKey: "hasSignedUp") as! Bool?
        
        self.init(username: username, friendlist: friendlist, mainProfilePicture: mainProfilePicture, pairings: pairings, interestedIn: interestedIn, profilePictureFromFb: profilePictureFromFb, newMessagesPushNotifications:newMessagesPushNotifications,
                  newBridgesPushNotifications:newBridgesPushNotifications, firstTimeSwipingRight: firstTimeSwipingRight, firstTimeSwipingLeft: firstTimeSwipingLeft, hasSignedUp: hasSignedUp)
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
        aCoder.encode(firstTimeSwipingRight, forKey:  "firstTimeSwipingRight")
        aCoder.encode(firstTimeSwipingLeft, forKey:  "firstTimeSwipingLeft")
        aCoder.encode(hasSignedUp, forKey:  "hasSignedUp")
        
    }
    
}
