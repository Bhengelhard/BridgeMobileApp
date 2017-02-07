//
//  NewMatch.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 11/18/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import UIKit

class NewMatch: NSObject {
    var user: String
    /// objectId of the related row in the BridgePairing table
    var objectId: String
    var profilePicURL: String
    var profilePic: UIImage?
    var name: String
    var type: String
    var color: UIColor
    var dot: Bool
    var status: String
    var connecterObjectId: String?
    var connecterName: String?
    var connecterPicURL: String?
    var connecterPic: UIImage?
    var reasonForConnection: String?
    /// ObjectId of the user that is not the current User in the corresponding row of the BridgePairing Table
    var otherUserObjectId: String
    
    init(user: String, objectId: String, profilePicURL: String, name: String, type: String, color: UIColor, dot: Bool, status: String, otherUserObjectId: String) {
        self.user = user
        self.objectId = objectId
        self.profilePicURL = profilePicURL
        self.name = name
        self.type = type
        self.color = color
        self.dot = dot
        self.status = status
        self.otherUserObjectId = otherUserObjectId
    }
    
    func setConnecterInfo(objectId: String?, name: String?, profilePicURL: String?, reasonForConnection: String?) {
        self.connecterObjectId = objectId
        self.connecterName = name
        self.connecterPicURL = profilePicURL
        self.reasonForConnection = reasonForConnection
    }
}
