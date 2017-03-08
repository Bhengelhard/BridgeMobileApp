//
//  OtherProfileLogic.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 2/21/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class ExternalLogic {
    
    static func getFactsLabelTextAndNumberOfLines(age: Int?, city: String?, school: String?) -> (String, Int) {
        var labelText = String()
        
        var selectedFacts = [String]()
        
        if age != nil {
            selectedFacts.append("age")
        }
        if city != nil {
            selectedFacts.append("city")
        }
        if school != nil {
            selectedFacts.append("school")
        }
        
        let numberOfLines = max(1, selectedFacts.count)
        
        for i in 0..<selectedFacts.count {
            let fact = selectedFacts[i]
            
            if i > 0 {
                labelText = "\(labelText)\n" // go to next line
            }
            
            if fact == "age" {
                if let age = age {
                    labelText = "\(labelText)\(age) years old"
                }
            } else if fact == "city" {
                if let city = city {
                    labelText = "\(labelText)\(city)"
                }
            } else if fact == "school" {
                if let school = school {
                    labelText = "\(labelText)\(school)"
                }
            }
        }
        
        return (labelText, numberOfLines)
    }
}
