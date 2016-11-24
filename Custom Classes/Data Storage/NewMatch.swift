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
    var objectId: String
    var profilePicURL: URL
    var name: String
    var type: String
    var color: UIColor
    var dot: Bool
    var status: String?
    
    init(user: String, objectId: String, profilePicURL: URL, name: String, type: String, color: UIColor, dot: Bool, status: String?) {
        self.user = user
        self.objectId = objectId
        self.profilePicURL = profilePicURL
        self.name = name
        self.type = type
        self.color = color
        self.dot = dot
        self.status = status
    }
}
