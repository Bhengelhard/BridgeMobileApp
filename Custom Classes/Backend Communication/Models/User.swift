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
    
    typealias UserBlock = (User) -> Void
    typealias UsersBlock = ([User]) -> Void
    
    private let parseUser: PFUser
    
    /// The objectId of the User
    var id: String?
    
    /// The Facebook ID of the User
    var fbID: String?
    
    /// The full name of the User
    var name: String?
    
    /// The first name of the User
    var firstName: String? {
        if let name = name {
            return DisplayUtility.firstName(name: name)
        }
        return nil
    }
    
    /// The first name and first initial of the last name of the User
    var firstNameLastNameInitial: String? {
        if let name = name {
            return DisplayUtility.firstNameLastNameInitial(name: name)
        }
        return nil
    }
    
    /// The email of the User
    var email: String?
    
    ///The objectIds of the User's friends
    var friendList: [String]?
    
    /// The reputation score of the User
    var reputation: Int?
    
    /// How many times the User has run out of pairs
    var ranOutOfPairs: Int?
    
    /// The gender of the User
    var gender: Gender?
    
    /// The User's birthday on Facebook
    var fbBirthday: Date?
    
    /// The age of the User
    var age: Int?
    
    /// The city of the User
    var city: String?
    
    /// The employer of the User
    var work: String?
    
    /// THe school of the User
    var school: String?
    
    /// A summary about the User
    var aboutMe: String?
    
    /// A summary of what the User is looking for
    var lookingFor: String?
    
    /// The objectIds of the User's Pictures
    var pictureIDs: [String]?
    
    private var pictureIDsToPictures = [String: Picture]()
    
    private init(parseUser: PFUser) {
        self.parseUser = parseUser
        
        id = parseUser.objectId
        
        if let parseFBID = parseUser["fb_id"] as? String {
            fbID = parseFBID
        }
        
        if let parseName = parseUser["name"] as? String {
            name = parseName
        }
        
        if let parseEmail = parseUser["email"] as? String {
            email = parseEmail
        }
        
        if let parseFriendList = parseUser["friend_list"] as? [String] {
            friendList = parseFriendList
        }
        
        if let parseReputation = parseUser["reputation"] as? Int {
            reputation = parseReputation
        }
        
        if let parseRanOutOfPairs = parseUser["ran_out_of_pairs"] as? Int {
            ranOutOfPairs = parseRanOutOfPairs
        }
        
        if let parseGender = parseUser["gender"] as? String {
            if parseGender == "male" {
                gender = .male
            } else if parseGender == "female" {
                gender = .female
            } else {
                gender = .other
            }
        }
        
        if let parseFBBirthday = parseUser["fb_birthday"] as? Date {
            fbBirthday = parseFBBirthday
        }

        if let parseAge = parseUser["age"] as? Int {
            age = parseAge
        }
        
        if let parseCity = parseUser["city"] as? String {
            city = parseCity
        }
        
        if let parseWork = parseUser["work"] as? String {
            work = parseWork
        }
        
        if let parseSchool = parseUser["school"] as? String {
            school = parseSchool
        }
        
        if let parseQuickUpdate = parseUser["quick_update"] as? String {
            aboutMe = parseQuickUpdate
        }
        
        if let parseLookingFor = parseUser["looking_for"] as? String {
            lookingFor = parseLookingFor
        }
        
        if let parsePictures = parseUser["pictures"] as? [String] {
            pictureIDs = parsePictures
        }
        
        super.init()
    }
    
    /// Gets the currently logged in User and calls the given block on the result.
    /// - parameter block: the block to call on the result
    static func getCurrent(withBlock block: UserBlock? = nil) {
        if let parseUser = PFUser.current() {
            let user = User(parseUser: parseUser)
            if let block = block {
                block(user)
            }
        } else {
            print("error getting current user")
        }
    }
    
    /// Gets the User with the provided objectId and calls the given block on the
    /// result.
    /// - parameter id: the objectId of the User
    /// - parameter block: the block to call on the result
    static func get(withID id: String, withBlock block: UserBlock? = nil) {
        let query = PFQuery(className: "_User")
        query.getObjectInBackground(withId: id) { (parseObject, error) in
            if let error = error {
                print("error getting user with id \(id) - \(error)")
            } else if let parseUser = parseObject as? PFUser {
                let user = User(parseUser: parseUser)
                if let block = block {
                    block(user)
                }
            }
        }
    }
    
    func getFriends(withBlock block: UsersBlock? = nil) {
        if let id = id {
            if let friendList = friendList {
                let query = PFQuery(className: "_User")
                query.whereKey("friend_list", contains: id)
                query.limit = 10000
                query.findObjectsInBackground(block: { (parseObjects, error) in
                    if let error = error {
                        print("error finding users - \(error)")
                    } else if let parseObjects = parseObjects {
                        var users = [User]()
                        for parseObject in parseObjects {
                            if let parseUser = parseObject as? PFUser {
                                let user = User(parseUser: parseUser)
                                users.append(user)
                            }
                        }
                        if let block = block {
                            block(users)
                        }
                    }
                })
            }
        }
    }
    
    func getPicture(atIndex index: Int, withBlock block: Picture.PictureBlock? = nil) {
        if let pictureIDs = pictureIDs {
            if index < pictureIDs.count {
                let pictureID = pictureIDs[index]
                if let picture = pictureIDsToPictures[pictureID] { // picture has already been retrieved
                    if let block = block {
                        block(picture)
                    }
                } else { // must retrieve picture
                    Picture.get(withID: pictureID) { (picture) in
                        self.pictureIDsToPictures[pictureID] = picture
                        if let block = block {
                            block(picture)
                        }
                    }
                }
            }
        } else {
            print("picture ID's were not retrieved")
        }
    }
    
    func getMainPicture(withBlock block: Picture.PictureBlock? = nil) {
        getPicture(atIndex: 0, withBlock: block)
    }
    
    func save(withBlock block: UserBlock? = nil) {
        if let fbID = fbID {
            parseUser["fb_id"] = fbID
        } else {
            parseUser.remove(forKey: "fb_id")
        }
        
        if let name = name {
            parseUser["name"] = name
        } else {
            parseUser.remove(forKey: "name")
        }
        
        if let email = email {
            parseUser["email"] = email
        } else {
            parseUser.remove(forKey: "email")
        }
        
        if let friendList = friendList {
            parseUser["friend_list"] = friendList
        } else {
            parseUser.remove(forKey: "friend_list")
        }
        
        if let reputation = reputation {
            parseUser["reputation"] = reputation
        } else {
            parseUser.remove(forKey: "reputation")
        }
        
        if let ranOutOfPairs = ranOutOfPairs {
            parseUser["ran_out_of_pairs"] = ranOutOfPairs
        } else {
            parseUser.remove(forKey: "ran_out_of_pairs")
        }
        
        if let gender = gender {
            if gender == .male {
                parseUser["gender"] = "male"
            } else if gender == .female {
                parseUser["gender"] = "female"
            } else {
                parseUser["gender"] = "other"
            }
        } else {
            parseUser.remove(forKey: "gender")
        }
        
        if let fbBirthday = fbBirthday {
            parseUser["fb_birthday"] = fbBirthday
        } else {
            parseUser.remove(forKey: "fb_birthday")
        }
        
        if let age = age {
            parseUser["age"] = age
        } else {
            parseUser.remove(forKey: "age")
        }
        
        if let city = city {
            parseUser["city"] = city
        } else {
            parseUser.remove(forKey: "city")
        }
        
        if let work = work {
            parseUser["work"] = work
        } else {
            parseUser.remove(forKey: "work")
        }
        
        if let school = school {
            parseUser["school"] = school
        } else {
            parseUser.remove(forKey: "school")
        }
                
        if let aboutMe = aboutMe {
            parseUser["quick_update"] = aboutMe
        } else {
            parseUser.remove(forKey: "quick_update")
        }
        
        if let lookingFor = lookingFor {
            parseUser["looking_for"] = lookingFor
        } else {
            parseUser.remove(forKey: "looking_for")
        }
        
        if let pictureIDs = pictureIDs {
            parseUser["pictures"] = pictureIDs
        } else {
            parseUser.remove(forKey: "pictures")
        }
        
        parseUser.saveInBackground { (succeeded, error) in
            if let error = error {
                print("error saving user - \(error)")
            } else if succeeded {
                self.id = self.parseUser.objectId
                if let block = block {
                    block(self)
                }
            }
        }
    }
}
