//
//  MyProfileBackend.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 2/21/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class MyProfileBackend {
    
    func setProfilePictureAndName(hexView: HexagonView, label: UILabel) {
        /*
        var storedLocally = false
        let localData = LocalData()
        if let data = localData.getMainProfilePicture() {
            if let image = UIImage(data: data) {
                storedLocally = true
                hexView.setBackgroundImage(image: image)
            }
        }
        if !storedLocally {
        */
            User.getCurrent { (user) in
                // Setting the user's profile picture
                user.getMainPicture { (picture) in
                    picture.getImage { (image) in
                        hexView.setBackgroundImage(image: image)
                    }
                }
                
                // Setting the user's name
                label.text = user.name
                
            }
        //}
    }
    
    func setReputationScore(button: UIButton) {
        User.getCurrent { (user) in
            if let reputation = user.reputation {
                button.setTitle("\(reputation)", for: .normal)
            }
        }
    }
}
