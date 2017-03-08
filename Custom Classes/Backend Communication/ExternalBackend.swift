//
//  OtherProfileBackend.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 2/21/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class ExternalBackend {
    
    /// get user's pictures and add them to the page control view controllers
    func setPictures(userID: String, withBlock block: Picture.PicturesBlock? = nil) {
        User.get(withID: userID) { (user) in
            Picture.getAll(withUser: user) { (pictures) in
                if let block = block {
                    block(pictures)
                }
            }
        }
    }
    
    /// set the name label to display the user's name
    func setName(userID: String, label: UILabel) {
        User.get(withID: userID) { (user) in
            if let name = user.name {
                label.text = name
            }
        }
    }
    
    /// set the facts label to display the user's facts
    func setFacts(userID: String, label: UILabel) {
        User.get(withID: userID) { (user) in
            let (text, numberOfLines) = ExternalLogic.getFactsLabelTextAndNumberOfLines(age: user.age, city: user.city, school: user.school)
            label.text = text
            label.numberOfLines = numberOfLines
        }
    }
    
    /// set the about me label to display a summary about the user
    func setAboutMe(userID: String, label: UILabel) {
        User.get(withID: userID) { (user) in
            if let aboutMe = user.aboutMe {
                label.text = aboutMe
            }
        }
    }
    
}
