//
//  PairInfo.swift
//  MyBridgeApp
//
//  Created by Sagar Sinha on 6/14/16.
//  Copyright © 2016 BHE Ventures LLC. All rights reserved.
//

import Foundation
import Parse
class PairInfo:NSObject, NSCoding {
    var name:String? = nil
    var objectId:String? = nil
    var mainProfilePicture:String? = nil
    var profilePictures: [Data]? = nil
    var location:[Double]? = nil
    var bridgeStatus:String? = nil
    var city:String? = nil
    var savedProfilePicture:Data? = nil
    var bridgeType:String? = nil
    var userId:String? = nil
    init(name:String?, mainProfilePicture: String?, profilePictures: [Data]?, location:[Double]?, bridgeStatus:String?, objectId:String?,bridgeType:String?,userId:String?,city:String?, savedProfilePicture:Data? ) {
        self.name = name
        self.mainProfilePicture = mainProfilePicture
        self.profilePictures = profilePictures
        self.location = location
        self.bridgeStatus = bridgeStatus
        self.objectId = objectId
        self.bridgeType = bridgeType
        self.userId = userId
        self.city = city
        self.savedProfilePicture = savedProfilePicture
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String?
        let mainProfilePicture = aDecoder.decodeObject(forKey: "mainProfilePicture") as! String?
        let profilePictures = aDecoder.decodeObject(forKey: "profilePictures") as! [Data]?
        let location = aDecoder.decodeObject(forKey: "location") as! [Double]?
        let bridgeStatus = aDecoder.decodeObject(forKey: "bridgeStatus") as! String?
        let objectId = aDecoder.decodeObject(forKey: "objectId") as! String?
        let bridgeType = aDecoder.decodeObject(forKey: "bridgeType") as! String?
        let userId = aDecoder.decodeObject(forKey: "userId") as! String?
        let city = aDecoder.decodeObject(forKey: "city") as! String?
        let savedProfilePicture = aDecoder.decodeObject(forKey: "savedProfilePicture") as! Data?
        self.init(name: name, mainProfilePicture: mainProfilePicture, profilePictures: profilePictures,
                  location: location, bridgeStatus: bridgeStatus, objectId:objectId, bridgeType: bridgeType, userId:userId, city: city, savedProfilePicture: savedProfilePicture)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(mainProfilePicture, forKey: "mainProfilePicture")
        aCoder.encode(profilePictures, forKey: "profilePictures")
        aCoder.encode(location, forKey: "location")
        aCoder.encode(bridgeStatus, forKey: "bridgeStatus")
        aCoder.encode(objectId, forKey: "objectId")
        aCoder.encode(bridgeType, forKey: "bridgeType")
        aCoder.encode(userId, forKey: "userId")
        aCoder.encode(city, forKey: "city")
        aCoder.encode(savedProfilePicture, forKey: "savedProfilePicture")
    }
    
}
