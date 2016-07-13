//
//  PairInfo.swift
//  HitList
//
//  Created by Sagar Sinha on 6/14/16.
//  Copyright © 2016 SagarSinha. All rights reserved.
//

import Foundation
class PairInfo:NSObject, NSCoding {
    var name:String? = nil
    var objectId:String? = nil
    var mainProfilePicture:NSData? = nil
    var profilePictures: [NSData]? = nil
    var location:[Double]? = nil
    var bridgeStatus:String? = nil
//    var profilePicturePFFile:PFFile? = nil
    var bridgeType:String? = nil
    init( name:String?, mainProfilePicture: NSData?, profilePictures: [NSData]?, location:[Double]?, bridgeStatus:String?, objectId:String?,bridgeType:String?  ) { //, profilePicturePFFile:PFFile?
        self.name = name
        self.mainProfilePicture = mainProfilePicture
        self.profilePictures = profilePictures
        self.location = location
        self.bridgeStatus = bridgeStatus
        self.objectId = objectId
//        self.profilePicturePFFile = profilePicturePFFile
        self.bridgeType = bridgeType
        
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey("name") as! String?
        let mainProfilePicture = aDecoder.decodeObjectForKey("mainProfilePicture") as! NSData?
        let profilePictures = aDecoder.decodeObjectForKey("profilePictures") as! [NSData]?
        let location = aDecoder.decodeObjectForKey("location") as! [Double]?
        let bridgeStatus = aDecoder.decodeObjectForKey("bridgeStatus") as! String?
        let objectId = aDecoder.decodeObjectForKey("objectId") as! String?
        //let profilePicturePFFile = aDecoder.decodeObjectForKey("profilePicturePFFile") as! PFFile?
        let bridgeType = aDecoder.decodeObjectForKey("bridgeType") as! String?
        self.init(name: name, mainProfilePicture: mainProfilePicture, profilePictures: profilePictures,
                  location: location, bridgeStatus: bridgeStatus, objectId:objectId, bridgeType: bridgeType)
        //, profilePicturePFFile: profilePicturePFFile
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(mainProfilePicture, forKey: "mainProfilePicture")
        aCoder.encodeObject(profilePictures, forKey: "profilePictures")
        aCoder.encodeObject(location, forKey: "location")
        aCoder.encodeObject(bridgeStatus, forKey: "bridgeStatus")
        aCoder.encodeObject(objectId, forKey: "objectId")
       // aCoder.encodeObject(profilePicturePFFile, forKey: "profilePicturePFFile")
        aCoder.encodeObject(bridgeType, forKey: "bridgeType")
        
    }
    
}