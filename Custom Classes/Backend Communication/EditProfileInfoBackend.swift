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
    
    func shouldDisplay(title: String, withBlock block: (Bool) -> Void) {
        User.getCurrent { (user) in
            let fieldTitle = title.lowercased()
            var fieldValue: Bool?
            
            switch fieldTitle {
            case "age":
                fieldValue = user.displayAge
            case "work":
                fieldValue = user.displayWork
            case "school":
                fieldValue = user.displaySchool
            case "gender":
                fieldValue = user.displayGender
            case "relationship status":
                fieldValue = user.displayRelationshipStatus
            default:
                fieldValue = nil
            }
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
    
}
