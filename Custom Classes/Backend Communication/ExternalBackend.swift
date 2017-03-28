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
            var age: String?
            if let displayAge = user.displayAge {
                if displayAge {
                    if let userAge = user.age {
                        age = String(userAge)
                    }
                }
            } else {
                if let userAge = user.age {
                    age = String(userAge)
                }
            }
            
            var city: String?
            if let displayCity = user.displayCity {
                if displayCity {
                    if let userCity = user.city {
                        city = userCity
                    }
                }
            } else {
                if let userCity = user.city {
                    city = userCity
                }
            }
            
            var work: String?
            if let displayWork = user.displayWork {
                if displayWork {
                    if let userWork = user.work {
                        work = userWork
                    }
                }
            } else {
                if let userWork = user.work {
                    work = userWork
                }
            }
            
            var school: String?
            if let displaySchool = user.displaySchool {
                if displaySchool {
                    if let userSchool = user.school {
                        school = userSchool
                    }
                }
            } else {
                if let userSchool = user.school {
                    school = userSchool
                }
            }
            
            var gender: String?
            if let displayGender = user.displayGender {
                if displayGender {
                    if let userGender = user.gender {
                        gender = userGender.rawValue
                    }
                }
            } else {
                if let userGender = user.gender {
                    gender = userGender.rawValue
                }
            }
            
            var relationshipStatus: String?
            if let displayRelationshipStatus = user.displayRelationshipStatus {
                if displayRelationshipStatus {
                    if let userRelationshipStatus = user.relationshipStatus {
                        relationshipStatus = userRelationshipStatus.rawValue
                    }
                }
            } else {
                if let userRelationshipStatus = user.relationshipStatus {
                    relationshipStatus = userRelationshipStatus.rawValue
                }
            }
            
            let (text, numberOfLines) = ExternalLogic.getFactsLabelTextAndNumberOfLines(age: age, city: city, work: work, school: school, gender: gender, relationshipStatus: relationshipStatus)
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
