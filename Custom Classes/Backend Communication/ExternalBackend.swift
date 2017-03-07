//
//  OtherProfileBackend.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 2/21/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class ExternalBackend {
    
    func setProfilePicture(userID: String, imageView: UIImageView, atIndex index: Int) {
        User.get(withID: userID) { (user) in
            user.getPicture(atIndex: index) { (picture) in
                if let image = picture.image {
                    imageView.image = image
                }
            }
        }
    }
    
    func setFacts(userID: String, label: UILabel) {
        User.get(withID: userID) { (user) in
            let (text, numberOfLines) = ExternalLogic.getFactsLabelTextAndNumberOfLines(age: user.age, city: user.city, school: user.school)
            label.text = text
            label.numberOfLines = numberOfLines
        }
    }
    
}
