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
    func returnSelected(title: String) -> Bool {
        if let user = PFUser.current() {
            let fieldTitle = title.lowercased()
            let fieldname = "display_\(fieldTitle)"
            
            if let isSelected = user[fieldname] as? Bool {
                return isSelected
                
            }
            else {
                user[fieldname] = true
                user.saveInBackground()
                return true
                
            }
            
        } else {
            
            return true
            
        }
    }
    
    func setSelected(title: String, isSelected: Bool) {
        if let user = PFUser.current() {
            let fieldTitle = title.lowercased()
            let fieldName = "display_\(fieldTitle)"
            user[fieldName] = isSelected
            user.saveInBackground()
            
        }
    }
    
    func setFieldValueLabel(field: UserInfoField, label: UILabel, withBlock block: ((Bool) -> Void)? = nil) {
        User.getCurrent { (user) in
            var fieldValueExists = false
            
            switch field {
            case .age:
                if let age = user.age {
                    label.text = String(age)
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
