//
//  OtherProfileBackend.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 2/21/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class ExternalBackend {
    let userID: String
    
    init(userID: String) {
        self.userID = userID
    }
    
    func setProfilePicture(imageView: UIImageView) {
        User.get(withID: userID) { (user) in
            user.getMainPicture(withBlock: { (picture) in
                if let image = picture.croppedImage {
                    imageView.image = image
                }
            })
        }
    }
    
    func setFacts(label: UILabel) {
        User.get(withID: userID) { (user) in
            ExternalLogic.setFactsLabelText(label: label, age: user.age, city: user.city, school: user.school)
        }
    }
    
}
