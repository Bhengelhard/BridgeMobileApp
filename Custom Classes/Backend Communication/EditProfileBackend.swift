//
//  EditProfileBackend.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 3/7/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class EditProfileBackend {
    
    func setQuickUpdate(textView: UITextView) {
        print("2")
        User.getCurrent { (user) in
            if let quickUpdate = user.quickUpdate {
                textView.text = quickUpdate
            }
        }
    }
}
