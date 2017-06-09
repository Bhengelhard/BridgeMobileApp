//
//  OtherProfileLogic.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 2/21/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit

class ExternalProfileLogic {
    
    static func getFactsLabelTextAndNumberOfLines(age: String?, city: String?, work: String?, school: String?, currentSchool: Bool, gender: String?, relationshipStatus: String?) -> (String, Int) {
        var labelText = String()
        
        var selectedFields = [UserInfoField]()
        
        if age != nil {
            selectedFields.append(.age)
        }
        if city != nil {
            selectedFields.append(.city)
        }
        if work != nil {
            selectedFields.append(.work)
        }
        if school != nil {
            selectedFields.append(.school)
        }
        if gender != nil {
            selectedFields.append(.gender)
        }
        if relationshipStatus != nil {
            selectedFields.append(.relationshipStatus)
        }
        
        let numberOfLines = max(1, selectedFields.count)
        
        for i in 0..<selectedFields.count {
            let field = selectedFields[i]
            
            if i > 0 {
                labelText = "\(labelText)\n" // go to next line
            }
            
            switch field {
            case .age:
                if let age = age {
                    labelText = "\(labelText)\(age) years old"
                }
            
            case .city:
                if let city = city {
                    labelText = "\(labelText)Lives in \(city)"
                }
                
            case .work:
                if let work = work {
                    labelText = "\(labelText)Works at \(work)"
                }
                
            case .school:
                if let school = school {
                    if currentSchool {
                        labelText = "\(labelText)Goes to \(school)"
                    } else {
                        labelText = "\(labelText)Went to \(school)"
                    }
                }
            
            case .gender:
                if let gender = gender {
                    labelText = "\(labelText)\(gender)"
                }
            
            case .relationshipStatus:
                if let relationshipStatus = relationshipStatus {
                    labelText = "\(labelText)\(relationshipStatus)"
                }
                
            }
        }
        
        return (labelText, numberOfLines)
    }
}
