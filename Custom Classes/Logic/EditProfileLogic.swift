//
//  EditProfileBackend.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 3/7/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class EditProfileLogic {
    
    static func setAboutMe(textView: UITextView) {
        User.getCurrent { (user) in
            if let aboutMe = user.aboutMe {
                textView.text = aboutMe
            } else {
                textView.text = ""
            }
        }
    }
    
    static func setLookingFor(textView: UITextView) {
        User.getCurrent { (user) in
            if let lookingFor = user.lookingFor {
                textView.text = lookingFor
            } else {
                textView.text = ""
            }
        }
    }
    
    static func setSchool(label: UILabel) {
        User.getCurrent { (user) in
            if let school = user.school {
                label.text = school
            } else {
                label.text = "Add School"
            }
        }
    }
    
    static func setWork(label: UILabel) {
        User.getCurrent { (user) in
            if let work = user.work {
                label.text = work
            } else {
                label.text = "Add Work"
            }
        }
    }
    
    static func setGender(label: UILabel) {
        User.getCurrent { (user) in
            if let gender = user.gender {
                label.text = gender.rawValue
            } else {
                label.text = "Add Gender"
            }
        }
    }
}
