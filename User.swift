//
//  User.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 2/14/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Parse

/// a Necter User
class User: NSObject {
    
    private let pfUser: PFUser
    let id: String?
    var fbID: String?
    var name: String?
    var email: String?
    var friendList: [String]?
    var ranOutOfPairs: Int?
    var gender: Gender?
    var interestedIn: Gender?
    var fbBirthday: Date?
    var age: Int?
    var city: String?
    var school: String?
    var employer: String?
    var religion: String?
    var quickUpdate: String?
    
    private init(pfUser: PFUser) {
        self.pfUser = pfUser
        
        id = pfUser.objectId
        
        if let pfFBID = pfUser["fb_id"] as? String {
            fbID = pfFBID
        }
        
        if let pfName = pfUser["name"] as? String {
            name = pfName
        }
        
        if let pfEmail = pfUser["email"] as? String {
            email = pfEmail
        }
        
        if let pfFriendList = pfUser["friendList"] as? [String] {
            friendList = pfFriendList
        }
        
        if let pfRanOutOfPairs = pfUser["ran_out_of_pairs"] as? Int {
            ranOutOfPairs = pfRanOutOfPairs
        }
        
        if let pfGender = pfUser["gender"] as? String {
            if pfGender == "male" {
                gender = .male
            } else if pfGender == "female" {
                gender = .female
            } else {
                gender = .other
            }
        }
        
        if let pfFBBirthday = pfUser["fb_birthday"] as? Date {
            fbBirthday = pfFBBirthday
        }

        if let pfAge = pfUser["age"] as? Int {
            age = pfAge
        }
        
        if let pfCity = pfUser["city"] as? String {
            city = pfCity
        }
        
        if let pfSchool = pfUser["school"] as? String {
            school = pfSchool
        }
        
        if let pfEmployer = pfUser["employer"] as? String {
            employer = pfEmployer
        }
        
        if let pfReligion = pfUser["religion"] as? String {
            religion = pfReligion
        }
        
        if let pfQuickUpdate = pfUser["quick_update"] as? String {
            quickUpdate = pfQuickUpdate
        }
        
        super.init()
    }
    
    static func getCurrent(withBlock block: ((User) -> Void)? = nil) {
        if let pfUser = PFUser.current() {
            let user = User(pfUser: pfUser)
            if let block = block {
                block(user)
            }
        }
    }
    
    static func get(withId id: String, withBlock block: ((User) -> Void)? = nil) {
        let query = PFQuery(className: "_User")
        query.getObjectInBackground(withId: id) { (pfObject, error) in
            if let pfUser = pfObject as? PFUser {
                let user = User(pfUser: pfUser)
                if let block = block {
                    block(user)
                }
            }
        }
    }
    
    func save(withBlock block: ((User) -> Void)? = nil) {
        if let fbID = fbID {
            pfUser["fb_id"] = fbID
        }
        if let name = name {
            pfUser["name"] = name
        }
        if let email = email {
            pfUser["email"] = email
        }
        if let friendList = friendList {
            pfUser["friend_list"] = friendList
        }
        if let ranOutOfPairs = ranOutOfPairs {
            pfUser["ran_out_of_pairs"] = ranOutOfPairs
        }
        if let gender = gender {
            if gender == .male {
                pfUser["gender"] = "male"
            } else if gender == .female {
                pfUser["gender"] = "female"
            } else {
                pfUser["gender"] = "other"
            }
        }
        if let fbBirthday = fbBirthday {
            pfUser["fb_birthday"] = fbBirthday
        }
        if let age = age {
            pfUser["age"] = age
        }
        if let city = city {
            pfUser["city"] = city
        }
        if let school = school {
            pfUser["school"] = school
        }
        if let employer = employer {
            pfUser["employer"] = employer
        }
        if let religion = religion {
            pfUser["religion"] = religion
        }
        if let quickUpdate = quickUpdate {
            pfUser["quick_update"] = quickUpdate
        }
        
        pfUser.saveInBackground { (succeeded, error) in
            if succeeded {
                if let block = block {
                    block(self)
                }
            }
        }
    }
}

enum Gender {
    case male
    case female
    case other
}
