//
//  EditProfileInfoBackend.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 3/16/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Parse

class EditProfileInfoBackend {
    
    // Get whether field is selected to be shown to user or not
    func shouldDisplay(field: UserInfoField, withBlock block: ((Bool) -> Void)? = nil) {
        var shouldDisplay = false
        User.getCurrent { (user) in
            if let user = user {
                switch field {
                case .age:
                    if user.age != nil {
                        if let displayAge = user.displayAge {
                            shouldDisplay = displayAge
                        } else {
                            user.displayAge = true
                            user.save()
                            
                            shouldDisplay = true
                        }
                    }
                    
                case .city:
                    if user.city != nil {
                        if let displayCity = user.displayCity {
                            shouldDisplay = displayCity
                        } else {
                            user.displayCity = true
                            user.save()
                            
                            shouldDisplay = true
                        }
                    }
                    
                case .work:
                    if user.work != nil {
                        if let displayWork = user.displayWork {
                            shouldDisplay = displayWork
                        } else {
                            user.displayWork = true
                            user.save()
                            
                            shouldDisplay = true
                        }
                    }
                    
                case .school:
                    if user.school != nil {
                        if let displaySchool = user.displaySchool {
                            shouldDisplay = displaySchool
                        } else {
                            user.displaySchool = true
                            user.save()
                            
                            shouldDisplay = true
                        }
                    }
                    
                case .gender:
                    if user.gender != nil {
                        if let displayGender = user.displayGender {
                            shouldDisplay = displayGender
                        } else {
                            user.displayGender = true
                            user.save()
                            
                            shouldDisplay = true
                        }
                    }
                    
                case .relationshipStatus:
                    if user.relationshipStatus != nil {
                        if let displayRelationshipStatus = user.displayRelationshipStatus {
                            shouldDisplay = displayRelationshipStatus
                        } else {
                            user.displayRelationshipStatus = true
                            user.save()
                            
                            shouldDisplay = true
                        }
                    }
                }
                
                if let block = block {
                    block(shouldDisplay)
                }
            }
        }
    }
    
    func setAndSaveShouldDisplay(field: UserInfoField, shouldDisplay: Bool, withBlock block: (() -> Void)? = nil) {
        User.getCurrent { (user) in
            if let user = user {
                    
                switch field {
                case .age:
                    user.displayAge = shouldDisplay
                
                case .city:
                    user.displayCity = shouldDisplay
                    
                case .work:
                    user.displayWork = shouldDisplay
                    
                case .school:
                    user.displaySchool = shouldDisplay
                    
                case .gender:
                    user.displayGender = shouldDisplay
                    
                case .relationshipStatus:
                    user.displayRelationshipStatus = shouldDisplay
                }
                
                user.save { (_) in
                    if let block = block {
                        block()
                    }
                }
            }
        }
    }
    
    func setFieldValueLabel(field: UserInfoField, label: UILabel, withBlock block: ((Bool) -> Void)? = nil) {
        User.getCurrent { (user) in
            if let user = user {
                    
                var fieldValueExists = false
                
                switch field {
                case .age:
                    if let age = user.age {
                        label.text = age
                        fieldValueExists = true
                    }
                    
                case .city:
                    if let city = user.city {
                        label.text = city
                        fieldValueExists = true
                    }
                    
                case .work:
                    if let work = user.work {
                        label.text = work
                        fieldValueExists = true
                    }
                    
                case .school:
                    if let school = user.school {
                        label.text = school
                        fieldValueExists = true
                    }
                    
                case .gender:
                    if let gender = user.gender {
                        label.text = gender.rawValue
                        fieldValueExists = true
                    }
                    
                case .relationshipStatus:
                    if let relationshipStatus = user.relationshipStatus {
                        label.text = relationshipStatus.rawValue
                        fieldValueExists = true
                    }
                }
                
                if let block = block {
                    block(fieldValueExists)
                }
            }
        }
    }
    
}
