//
//  MyProfileBackend.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 2/21/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class MyProfileBackend {
    
    func setProfilePicture(hexView: HexagonView) {
        var storedLocally = false
        let localData = LocalData()
        if let data = localData.getMainProfilePicture() {
            if let image = UIImage(data: data) {
                storedLocally = true
                hexView.setBackgroundImage(image: image)
            }
        }
        if !storedLocally {
            User.getCurrent { (user) in
                user.getMainPicture(withBlock: { (picture) in
                    if let image = picture.croppedImage {
                        hexView.setBackgroundImage(image: image)
                    }
                })
            }
        }
    }
    
    func setReputationScore(button: UIButton) {
        User.getCurrent { (user) in
            if let reputation = user.reputation {
                button.setTitle("\(reputation)", for: .normal)
            }
        }
    }
}
