//
//  SharedModelFunctions.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 2/20/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Foundation

class SharedModelFunctions {
    
    func getUser(withID id: String, userIDsToUsers: [String: User], withBlock block: User.UserBlock? = nil) {
        if let user = userIDsToUsers[id] {
            if let block = block {
                block(user)
            }
        } else {
            User.get(withId: id) { (user) in
                userIDsToUsers[id] = user
                if let block = block {
                    block(user)
                }
            }
        }
    }
    
}
