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
    
    static func setAge(label: UILabel) {
        User.getCurrent { (user) in
            label.text = "Add Age"
            if let displaySchool = user.displaySchool {
                if displaySchool {
                    if let school = user.school {
                        label.text = school
                    }
                }
            }
        }
    }
    
    static func setSchool(label: UILabel) {
        User.getCurrent { (user) in
            label.text = "Add School"
            if let displayAge = user.displayAge {
                if displayAge {
                    if let age = user.age {
                        label.text = "\(age)"
                    }
                }
            }
        }
    }
    
    static func setWork(label: UILabel) {
        User.getCurrent { (user) in
            label.text = "Add Work"
            if let displayWork = user.displayWork {
                if displayWork {
                    if let work = user.work {
                        label.text = work
                    }
                }
            }
        }
    }
    
    static func setGender(label: UILabel) {
        User.getCurrent { (user) in
            label.text = "Add Gender"
            if let displayGender = user.displayGender {
                if displayGender {
                    if let gender = user.gender {
                        label.text = gender.rawValue
                    }
                }
            }
        }
    }
    
    static func setRelationshipStatus(label: UILabel) {
        User.getCurrent { (user) in
            label.text = "Add Relationship Status"
            if let displayRelationshipStatus = user.displayRelationshipStatus {
                if displayRelationshipStatus {
                    if let relationshipStatus = user.relationshipStatus {
                        label.text = relationshipStatus.rawValue
                    }
                }
            }
        }
    }
    
}
