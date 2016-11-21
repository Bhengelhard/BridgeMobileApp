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
    var profilePicView: UIImageView
    var firstName: String
    var color: UIColor
    var dot: Bool
    
    init(profilePicView: UIImageView, firstName: String, color: UIColor, dot: Bool) {
        self.profilePicView = profilePicView
        self.firstName = firstName
        self.color = color
        self.dot = dot
    }
}
