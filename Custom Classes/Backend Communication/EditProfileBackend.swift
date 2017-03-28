//
//  EditProfileBackend.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 3/7/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class EditProfileBackend {
    
    func loadCurrentUserPictures(withBlock block: Picture.PicturesBlock? = nil) {
        User.getCurrent { (user) in
            Picture.getAll(withUser: user) { (pictures) in
                if let block = block {
                    block(pictures)
                }
            }

        }
    }
    
    func setPicturesToUser(user: User, pictureIDs: [String?], images: [UIImage]) {
        setPicturesToUser(user: user, pictureIDs: pictureIDs, images: images, index: 0, soFar: [])
    }
    
    private func setPicturesToUser(user: User, pictureIDs: [String?], images: [UIImage], index: Int, soFar: [String]) {
        if index >= pictureIDs.count || index >= images.count {
            user.pictureIDs = soFar
        } else if let pictureID = pictureIDs[index] {
            var newSoFar = soFar
            newSoFar.append(pictureID)
            setPicturesToUser(user: user, pictureIDs: pictureIDs, images: images, index: index+1, soFar: newSoFar)
        } else {
            let image = images[index]
            Picture.create(image: image) { (picture) in
                picture.save { (savedPicture) in
                    if let pictureID = savedPicture.id {
                        var newSoFar = soFar
                        newSoFar.append(pictureID)
                        self.setPicturesToUser(user: user, pictureIDs: pictureIDs, images: images, index: index+1, soFar: newSoFar)
                    }
                }
            }
        }
    }
    
    func setFieldLabel(field: UserInfoField, label: UILabel) {
        User.getCurrent { (user) in
            label.text = "Add \(field.rawValue)"

            switch field {
            case .age:
                if let displayAge = user.displayAge {
                    if displayAge {
                        if let age = user.age {
                            label.text = String(age)
                        }
                    }
                } else {
                    user.displayAge = true
                    user.save()
                    if let age = user.age {
                        label.text = String(age)
                    }
                }
                
            case .city:
                if let displayCity = user.displayCity {
                    if displayCity {
                        if let city = user.city {
                            label.text = city
                        }
                    }
                } else {
                    user.displayCity = true
                    user.save()
                    if let city = user.city {
                        label.text = city
                    }
                }
                
            case .work:
                if let displayWork = user.displayWork {
                    if displayWork {
                        if let work = user.work {
                            label.text = work
                        }
                    }
                } else {
                    user.displayWork = true
                    user.save()
                    if let work = user.work {
                        label.text = work
                    }
                }
                
            case .school:
                if let displaySchool = user.displaySchool {
                    if displaySchool {
                        if let school = user.school {
                            label.text = school
                        }
                    }
                } else {
                    user.displaySchool = true
                    user.save()
                    if let school = user.school {
                        label.text = school
                    }
                }
                
            case .gender:
                if let displayGender = user.displayGender {
                    if displayGender {
                        if let gender = user.gender {
                            label.text = gender.rawValue
                        }
                    }
                } else {
                    user.displayGender = true
                    user.save()
                    if let gender = user.gender {
                        label.text = gender.rawValue
                    }
                }
            
            case .relationshipStatus:
                if let displayRelationshipStatus = user.displayRelationshipStatus {
                    if displayRelationshipStatus {
                        if let relationshipStatus = user.relationshipStatus {
                            label.text = relationshipStatus.rawValue
                        }
                    }
                } else {
                    user.displayRelationshipStatus = true
                    user.save()
                    if let relationshipStatus = user.relationshipStatus {
                        label.text = relationshipStatus.rawValue
                    }
                }
            }
        }
    }
    
}
