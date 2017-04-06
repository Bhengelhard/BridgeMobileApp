//
//  OtherProfileBackend.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 2/21/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class ExternalProfileBackend {
    
    /// get user's images
    func getImages(userID: String, withBlock block: Picture.ImagesBlock? = nil) {
        User.get(withID: userID) { (user) in
            Picture.getAll(withUser: user) { (pictures) in
                self.getImages(pictures: pictures, imagesSoFar: [], index: 0, withBlock: block)
            }
        }
    }
    
    func getImages(pictures: [Picture], imagesSoFar: [UIImage], index: Int, withBlock block: Picture.ImagesBlock? = nil) {
        if index >= pictures.count {
            if let block = block {
                block(imagesSoFar)
            }
        } else {
            let picture = pictures[index]
            picture.getImage { (image) in
                var newImagesSoFar = imagesSoFar
                newImagesSoFar.append(image)
                self.getImages(pictures: pictures, imagesSoFar: newImagesSoFar, index: index+1, withBlock: block)
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
                        age = userAge
                    }
                }
            } else {
                if let userAge = user.age {
                    age = userAge
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
            
            let (text, numberOfLines) = ExternalProfileLogic.getFactsLabelTextAndNumberOfLines(age: age, city: city, work: work, school: school, gender: gender, relationshipStatus: relationshipStatus)
            label.text = text
            label.numberOfLines = numberOfLines
        }
    }
    
    func getFieldShouldDisplayAndValue(userID: String, field: UserInfoField, completion: @escaping (Bool, String?) -> Void) {
        User.get(withID: userID) { (user) in
            switch field {
            case .age:
                if let displayAge = user.displayAge {
                    completion(displayAge, user.age)
                } else {
                    completion(true, user.age)
                }
            case .city:
                if let displayCity = user.displayCity {
                    completion(displayCity, user.city)
                } else {
                    completion(true, user.city)
                }
            case .work:
                if let displayWork = user.displayWork {
                    completion(displayWork, user.work)
                } else {
                    completion(true, user.work)
                }
            case .school:
                if let displaySchool = user.displaySchool {
                    completion(displaySchool, user.school)
                } else {
                    completion(true, user.school)
                }
            case .gender:
                if let displayGender = user.displayGender {
                    if let gender = user.gender {
                        completion(displayGender, gender.rawValue)
                    } else {
                        completion(displayGender, nil)
                    }
                } else {
                    if let gender = user.gender {
                        completion(true, gender.rawValue)
                    } else {
                        completion(true, nil)
                    }
                }
            case .relationshipStatus:
                if let displayRelationshipStatus = user.displayRelationshipStatus {
                    if let relationshipStatus = user.relationshipStatus {
                        completion(displayRelationshipStatus, relationshipStatus.rawValue)
                    } else {
                        completion(displayRelationshipStatus, nil)
                    }
                } else {
                    if let relationshipStatus = user.relationshipStatus {
                        completion(true, relationshipStatus.rawValue)
                    } else {
                        completion(true, nil)
                    }
                }
            }
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
