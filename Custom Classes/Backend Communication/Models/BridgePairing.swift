//
//  BridgePairing.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 2/16/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Parse

class BridgePairing: NSObject {
    
    typealias BridgePairingBlock = (BridgePairing) -> Void
    typealias BridgePairingsBlock = ([BridgePairing]) -> Void
    
    private let parseBridgePairing: PFObject
    
    /// The objectId of the BridgePairing
    var id: String?
    
    /// The objectId of the first user of the BridgePairing
    var user1ID: String?
    
    /// The objectId of the second user of the BridgePairing
    var user2ID: String?
    
    /// The objectId of the connecter of the BridgePairing
    var connecterID: String?
    
    /// The full name of the first user of the BridgePairing
    var user1Name: String?
    
    /// The first name of the first user of the BridgePairing
    var user1FirstName: String? {
        if let user1Name = user1Name {
            return DisplayUtility.firstName(name: user1Name)
        }
        return nil
    }
    
    /// The first name and first initial of the last name of the first user of the BridgePairing
    var user1FirstNameLastNameInitial: String? {
        if let user1Name = user1Name {
            return DisplayUtility.firstNameLastNameInitial(name: user1Name)
        }
        return nil
    }
    
    /// The full name of the second user of the BridgePairing
    var user2Name: String?
    
    /// The first name of the second user of the BridgePairing
    var user2FirstName: String? {
        if let user2Name = user2Name {
            return DisplayUtility.firstName(name: user2Name)
        }
        return nil
    }
    
    /// The first name and first initial of the last name of the second user of the BridgePairing
    var user2FirstNameLastNameInitial: String? {
        if let user2Name = user2Name {
            return DisplayUtility.firstNameLastNameInitial(name: user2Name)
        }
        return nil
    }
    
    /// The full name of the connecter of the BridgePairing
    var connecterName: String?
    
    /// The first name of the connecter of the BridgePairing
    var connecterFirstName: String? {
        if let connecterName = connecterName {
            return DisplayUtility.firstName(name: connecterName)
        }
        return nil
    }
    
    /// The first name and first initial of the last name of the connecter of the BridgePairing
    var connecterFirstNameLastNameInitial: String? {
        if let connecterName = connecterName {
            return DisplayUtility.firstNameLastNameInitial(name: connecterName)
        }
        return nil
    }
    
    /// The objectId of the profile picture of the first user of the BridgePairing
    var user1PictureID: String?
    
    /// The objectId of the profile picture of the second user of the BridgePairing
    var user2PictureID: String?
    
    /// The objectId of the profile picture of the connecter of the BridgePairing
    var connecterPictureID: String?
    
    /// Whether the two users of the BridgePairing have been connected
    var bridged: Bool?
    
    /// The objectIds of the users that have been shown a card with the BridgePairing
    var shownTo: [String]?
    
    /// Whether the card with the BirdgePairing is currently in use
    var checkedOut: Bool?
    
    var blockedList: [String]?
    
    var youMatchedNotificationViewedUser1: Bool?
    
    var youMatchedNotificationViewedUser2: Bool?
    
    private var userIDsToUsers = [String: User]()
    private var pictureIDsToPictures = [String: Picture]()
    
    private init(parseBridgePairing: PFObject) {
        self.parseBridgePairing = parseBridgePairing
        
        id = parseBridgePairing.objectId
        
        if let parseUserObjectId1 = parseBridgePairing["user1_objectId"] as? String {
            user1ID = parseUserObjectId1
        }
        
        if let parseUserObjectId2 = parseBridgePairing["user2_objectId"] as? String {
            user2ID = parseUserObjectId2
        }
        
        if let parseConnecterObjectId = parseBridgePairing["connecter_objectId"] as? String {
            connecterID = parseConnecterObjectId
        }
        
        if let parseUser1Name = parseBridgePairing["user1_name"] as? String {
            user1Name = parseUser1Name
        }
        
        if let parseUser2Name = parseBridgePairing["user2_name"] as? String {
            user2Name = parseUser2Name
        }
        
        if let parseConnecterName = parseBridgePairing["connecter_name"] as? String {
            connecterName = parseConnecterName
        }
        
        if let parseUser1PictureObjectId = parseBridgePairing["user1_picture_objectId"] as? String {
            user1PictureID = parseUser1PictureObjectId
        }
        
        if let parseUser2PictureObjectId = parseBridgePairing["user2_picture_objectId"] as? String {
            user2PictureID = parseUser2PictureObjectId
        }
        
        if let parseConnecterPictureObjectId = parseBridgePairing["connecter_picture_objectId"] as? String {
            connecterPictureID = parseConnecterPictureObjectId
        }
        
        if let parseBridged = parseBridgePairing["bridged"] as? Bool {
            bridged = parseBridged
        }
        
        if let parseShownTo = parseBridgePairing["shown_to"] as? [String] {
            shownTo = parseShownTo
        }
        
        if let parseChekcedOut = parseBridgePairing["checked_out"] as? Bool {
            checkedOut = parseChekcedOut
        }
        
        if let parseBlockedList = parseBridgePairing["blocked_list"] as? [String] {
            blockedList = parseBlockedList
        }
        
        if let parseYouMatchedNotificationViewedUser1 = parseBridgePairing["you_matched_notification_viewed_user1"] as? Bool {
            youMatchedNotificationViewedUser1 = parseYouMatchedNotificationViewedUser1
        }
        
        if let parseYouMatchedNotificationViewedUser2 = parseBridgePairing["you_matched_notification_viewed_user2"] as? Bool {
            youMatchedNotificationViewedUser2 = parseYouMatchedNotificationViewedUser2
        }
        
    }
    
    /// Creates a new BridgePairing object with the provided parameters and calls the given block
    /// on the result.
    static func create(user1ID: String?, user2ID: String?, connecterID: String?, user1Name: String?, user2Name: String?, connecterName: String?, user1PictureID: String?, user2PictureID: String?, connecterPictureID: String?, bridged: Bool?, shownTo: [String]?, checkedOut: Bool?, blockedList: [String]?, youMatchedNotificationViewedUser1: Bool?, youMatchedNotificationViewedUser2: Bool?, block: BridgePairingBlock? = nil) {
        
        let parseBridgePairing = PFObject(className: "BridgePairing")
        
        // set BridgePairing's ACL
        let acl = PFACL()
        acl.getPublicReadAccess = true
        parseBridgePairing.acl = acl
        
        if let user1ID = user1ID {
            parseBridgePairing["user1_objectId"] = user1ID
        }
        
        if let user2ID = user2ID {
            parseBridgePairing["user2_objectId"] = user2ID
        }
        
        if let connecterID = connecterID {
            parseBridgePairing["connecter_objectId"] = connecterID
        }
        
        if let user1Name = user1Name {
            parseBridgePairing["user1_name"] = user1Name
        }
        
        if let user2Name = user2Name {
            parseBridgePairing["user2_name"] = user2Name
        }
        
        if let connecterName = connecterName {
            parseBridgePairing["connecter_name"] = connecterName
        }
        
        if let user1PictureID = user1PictureID {
            parseBridgePairing["user1_picture_objectId"] = user1PictureID
        }
        
        if let user2PictureID = user2PictureID {
            parseBridgePairing["user2_picture_objectId"] = user2PictureID
        }
        
        if let connecterPictureID = connecterPictureID {
            parseBridgePairing["connecter_picture_objectId"] = connecterPictureID
        }
        
        if let bridged = bridged {
            parseBridgePairing["bridged"] = bridged
        }
        
        if let shownTo = shownTo {
            parseBridgePairing["shown_to"] = shownTo
        }
        
        if let checkedOut = checkedOut {
            parseBridgePairing["checked_out"] = checkedOut
        }
        
        if let blockedList = blockedList {
            parseBridgePairing["blocked_list"] = blockedList
        }
        
        if let youMatchedNotificationViewedUser1 = youMatchedNotificationViewedUser1 {
            parseBridgePairing["you_matched_notification_viewed_user1"] = youMatchedNotificationViewedUser1
        }
        
        if let youMatchedNotificationViewedUser2 = youMatchedNotificationViewedUser2 {
            parseBridgePairing["you_matched_notification_viewed_user2"] = youMatchedNotificationViewedUser2
        }
        
        let bridgePairing = BridgePairing(parseBridgePairing: parseBridgePairing)
        if let block = block {
            block(bridgePairing)
        }
    }
    
    /// Gets the BridgePiaring object with the provided objectId and calls the given block
    /// on the result.
    /// - parameter id: the objectId of the BridgePairing
    /// - parameter block: the block to call on the result
    static func get(withID id: String, withBlock block: BridgePairingBlock? = nil) {
        let query = PFQuery(className: "BridgePairings")
        query.getObjectInBackground(withId: id) { (parseObject, error) in
            if let error = error {
                print("error getting bridge pairing with id \(id) - \(error)")
            } else if let parseBridgePairing = parseObject {
                let bridgePairing = BridgePairing(parseBridgePairing: parseBridgePairing)
                if let block = block {
                    block(bridgePairing)
                }
            }
        }
    }
    
    static func getAll(withUser user: User, bridgedOnly: Bool = false, withLimit limit: Int = 10000, whereUserHasNotViewedNotificationOnly: Bool = false, withBlock block: BridgePairingsBlock? = nil) {
        if let userID = user.id {
            let subQuery1 = PFQuery(className: "BridgePairings")
            subQuery1.whereKey("user1_objectId", equalTo: userID)
            
            if whereUserHasNotViewedNotificationOnly {
                subQuery1.whereKey("you_matched_notification_viewed_user1", notEqualTo: true)
            }
            
            let subQuery2 = PFQuery(className: "BridgePairings")
            subQuery2.whereKey("user2_objectId", equalTo: userID)
            
            if whereUserHasNotViewedNotificationOnly {
                subQuery2.whereKey("you_matched_notification_viewed_user2", notEqualTo: true)
            }
            
            let query = PFQuery.orQuery(withSubqueries: [subQuery1, subQuery2])
            if bridgedOnly {
                query.whereKey("bridged", equalTo: true)
            }
            query.limit = limit
            
            query.findObjectsInBackground { (parseBridgePairings, error) in
                if let error = error {
                    print("error getting bridge pairings - \(error)")
                } else if let parseBridgePairings = parseBridgePairings {
                    var bridgePairings = [BridgePairing]()
                    for parseBridgePairing in parseBridgePairings {
                        let bridgePairing = BridgePairing(parseBridgePairing: parseBridgePairing)
                        bridgePairings.append(bridgePairing)
                    }
                    if let block = block {
                        block(bridgePairings)
                    }
                }
            }
        }
    }
    
    static func getAllWithFriends(ofUser user: User, notShownOnly: Bool = false, withLimit limit: Int = 10000, notCheckedOutOnly: Bool = false, exceptFriend1WithID friend1ID: String? = nil, exceptFriend2WithID friend2ID: String? = nil, exceptForBlocked: Bool = false, withBlock block: BridgePairingsBlock? = nil) {
        
        if let userFriendList = user.friendList {
            
            let query = PFQuery(className: "BridgePairings")
            
            if exceptForBlocked {
                
                // hide bridge pairings containing blockee from blocker
                var nonBlockedFriendList = [String]()
                if let blockingList = user.blockingList {
                    for friend in userFriendList {
                        if !blockingList.contains(friend) {
                            nonBlockedFriendList.append(friend)
                        }
                    }
                } else {
                    nonBlockedFriendList = userFriendList
                }
                
                query.whereKey("user1_objectId", containedIn: nonBlockedFriendList)
                query.whereKey("user2_objectId", containedIn: nonBlockedFriendList)
                
                // hide bridge pairings containing blocker from blockee
                if let id = user.id {
                    query.whereKey("blocked_list", notEqualTo: id)
                }
            } else {
                query.whereKey("user1_objectId", containedIn: userFriendList)
                query.whereKey("user2_objectId", containedIn: userFriendList)
            }
            
            query.limit = limit
            
            if notShownOnly {
                if let userID = user.id {
                    query.whereKey("shown_to", notEqualTo: userID)
                }
            }
            
            if notCheckedOutOnly {
                query.whereKey("checked_out", equalTo: false)
            }
            
            if let friend1ID = friend1ID, let friend2ID = friend2ID {
                query.whereKey("user1_objectId", notContainedIn: [friend1ID, friend2ID])
                query.whereKey("user2_objectId", notContainedIn: [friend1ID, friend2ID])
            }
            
            query.order(byDescending: "score")
            query.findObjectsInBackground { (parseBridgePairings, error) in
                if let error = error {
                    print("error getting bridge pairings - \(error)")
                } else if let parseBridgePairings = parseBridgePairings {
                    var bridgePairings = [BridgePairing]()
                    for parseBridgePairing in parseBridgePairings {
                        print(parseBridgePairing["score"])
                        let bridgePairing = BridgePairing(parseBridgePairing: parseBridgePairing)
                        bridgePairings.append(bridgePairing)
                    }
                    if let block = block {
                        block(bridgePairings)
                    }
                }
            }
        }
    }
    
    func getUser1(withBlock block: User.UserBlock? = nil) {
        if let user1ID = user1ID {
            getUser(withID: user1ID, withBlock: block)
        }
    }
    
    func getUser2(withBlock block: User.UserBlock? = nil) {
        if let user2ID = user2ID {
            getUser(withID: user2ID, withBlock: block)
        }
    }
    
    func getConnecter(withBlock block: User.UserBlock? = nil) {
        if let connecterID = connecterID {
            getUser(withID: connecterID, withBlock: block)
        }
    }
    
    /// Gets user in Message that is not the current user. Defaults to User 1.
    func getNonCurrentUser(withBlock block: User.UserBlock? = nil) {
        User.getCurrent { (currentUser) in
            if currentUser.id == self.user1ID {
                self.getUser2(withBlock: block)
            } else {
                self.getUser1(withBlock: block)
            }
        }
    }
    
    private func getUser(withID id: String, withBlock block: User.UserBlock? = nil) {
//        if let user = userIDsToUsers[id] {
//            if let block = block {
//                block(user)
//            }
//        } else {
            User.get(withID: id) { (user) in
                self.userIDsToUsers[id] = user
                if let block = block {
                    block(user)
                }
            }
        //}
    }
    
    func getUser1Picture(withBlock block: Picture.PictureBlock? = nil) {
        if let user1PictureID = user1PictureID {
            getPicture(withID: user1PictureID, withBlock: block)
        }
    }
    
    func getUser2Picture(withBlock block: Picture.PictureBlock? = nil) {
        if let user2PictureID = user2PictureID {
            getPicture(withID: user2PictureID, withBlock: block)
        }
    }
    
    func getConnecterPicture(withBlock block: Picture.PictureBlock? = nil) {
        if let connecterPictureID = connecterPictureID {
            getPicture(withID: connecterPictureID, withBlock: block)
        }
    }
    
    private func getPicture(withID id: String, withBlock block: Picture.PictureBlock? = nil) {
        if let picture = pictureIDsToPictures[id] {
            if let block = block {
                block(picture)
            }
        } else {
            Picture.get(withID: id) { (picture) in
                self.pictureIDsToPictures[id] = picture
                if let block = block {
                    block(picture)
                }
            }
        }
    }
    
    /// Saves the BridgePairing object in the background and run the given block on it
    func save(withBlock block: BridgePairingBlock? = nil) {
        if let user1ID = user1ID {
            parseBridgePairing["user1_objectId"] = user1ID
        } else {
            parseBridgePairing.remove(forKey: "user1_objectId")
        }
        
        if let user2ID = user2ID {
            parseBridgePairing["user2_objectId"] = user2ID
        } else {
            parseBridgePairing.remove(forKey: "user2_objectId")
        }
        
        if let connecterID = connecterID {
            parseBridgePairing["connecter_objectId"] = connecterID
        } else {
            parseBridgePairing.remove(forKey: "connecter_objectId")
        }
        
        if let user1Name = user1Name {
            parseBridgePairing["user1_name"] = user1Name
        }  else {
            parseBridgePairing.remove(forKey: "user1_name")
        }
        
        if let user2Name = user2Name {
            parseBridgePairing["user2_name"] = user2Name
        } else {
            parseBridgePairing.remove(forKey: "user2_name")
        }
        
        if let connecterName = connecterName {
            parseBridgePairing["connecter_name"] = connecterName
        } else {
            parseBridgePairing.remove(forKey: "connecter_name")
        }
        
        if let user1PictureID = user1PictureID {
            parseBridgePairing["user1_picture_objectId"] = user1PictureID
        } else {
            parseBridgePairing.remove(forKey: "user1_picture_objectId")
        }
        
        if let user2PictureID = user2PictureID {
            parseBridgePairing["user2_picture_objectId"] = user2PictureID
        } else {
            parseBridgePairing.remove(forKey: "user2_picture_objectId")
        }
        
        if let connecterPictureID = connecterPictureID {
            parseBridgePairing["connecter_picture_objectId"] = connecterPictureID
        } else {
            parseBridgePairing.remove(forKey: "connecter_picture_objectId")
        }
        
        if let bridged = bridged {
            parseBridgePairing["bridged"] = bridged
        } else {
            parseBridgePairing.remove(forKey: "bridged")
        }
        
        if let shownTo = shownTo {
            parseBridgePairing["shown_to"] = shownTo
        } else {
            parseBridgePairing.remove(forKey: "shown_to")
        }
        
        if let checkedOut = checkedOut {
            parseBridgePairing["checked_out"] = checkedOut
        } else {
            parseBridgePairing.remove(forKey: "checkedOut")
        }
        
        if let blockedList = blockedList {
            parseBridgePairing["blocked_list"] = blockedList
        } else {
            parseBridgePairing.remove(forKey: "blocked_list")
        }
        
        if let youMatchedNotificationViewedUser1 = youMatchedNotificationViewedUser1 {
            parseBridgePairing["you_matched_notification_viewed_user1"] = youMatchedNotificationViewedUser1
        } else {
            parseBridgePairing.remove(forKey: "you_matched_notification_viewed_user1")
        }
        
        if let youMatchedNotificationViewedUser2 = youMatchedNotificationViewedUser2 {
            parseBridgePairing["you_matched_notification_viewed_user2"] = youMatchedNotificationViewedUser2
        } else {
            parseBridgePairing.remove(forKey: "you_matched_notification_viewed_user2")
        }
        
        parseBridgePairing.saveInBackground { (succeeded, error) in
            if let error = error {
                print("error saving bridge pairing - \(error)")
            } else if succeeded {
                self.id = self.parseBridgePairing.objectId
                if let block = block {
                    block(self)
                }
            }
        }
    }
}

class LocalBridgePairings {
    
    // MARK: - Global Variables
    /// Indicates whether the user has entered an access code
    var bridgePairing1ID: String?
    var bridgePairing2ID: String?
    
    // MARK: -
    init() {
        let userDefaults = UserDefaults.standard
        if let decoded = userDefaults.object(forKey: "bridgePairings") {
            if let bridgePairings = NSKeyedUnarchiver.unarchiveObject(with: decoded as! Data) {
                bridgePairing1ID = (bridgePairings as! BridgePairings).bridgePairing1ID
                bridgePairing2ID = (bridgePairings as! BridgePairings).bridgePairing2ID
            }
        }
    }
    
    // MARK: - Set and Get Functions
    
    //Saving bridgePairing 1 ID
    func setBridgePairing1ID(_ bridgePairing1ID: String?) {
        print("saving top locally with id: \(bridgePairing1ID == nil ? "nil" : bridgePairing1ID!)")
        self.bridgePairing1ID = bridgePairing1ID
    }
    func getBridgePairing1ID() -> String? {
        let userDefaults = UserDefaults.standard
        if let _ = userDefaults.object(forKey: "bridgePairings") {
            let decoded  = userDefaults.object(forKey: "bridgePairings") as! Data
            let bridgePairings = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! BridgePairings
            return bridgePairings.bridgePairing1ID
        }
        else{
            return nil
        }
    }
    
    //Saving bridgePairing 2 ID
    func setBridgePairing2ID(_ bridgePairing2ID: String?) {
        print("saving bottom locally with id: \(bridgePairing2ID == nil ? "nil" : bridgePairing2ID!)")
        self.bridgePairing2ID = bridgePairing2ID
    }
    func getBridgePairing2ID() -> String? {
        let userDefaults = UserDefaults.standard
        if let _ = userDefaults.object(forKey: "bridgePairings") {
            let decoded  = userDefaults.object(forKey: "bridgePairings") as! Data
            let bridgePairings = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! BridgePairings
            return bridgePairings.bridgePairing2ID
        }
        else{
            return nil
        }
    }
    
    // MARK: -
    // This function saves the local data to the device
    func synchronize(){
        print("synchronizing")
        let bridgePairings: BridgePairings = BridgePairings(bridgePairing1ID: bridgePairing1ID, bridgePairing2ID: bridgePairing2ID)
        let userDefaults = UserDefaults.standard
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: bridgePairings)
        userDefaults.set(encodedData, forKey: "bridgePairings")
        userDefaults.synchronize()
    }
    
}


class BridgePairings:NSObject, NSCoding {
    var bridgePairing1ID: String?
    var bridgePairing2ID: String?
    
    init(bridgePairing1ID: String?, bridgePairing2ID: String?) {
        self.bridgePairing1ID = bridgePairing1ID
        self.bridgePairing2ID = bridgePairing2ID
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let bridgePairing1ID = aDecoder.decodeObject(forKey: "bridgePairing1ID") as! String?
        let bridgePairing2ID = aDecoder.decodeObject(forKey: "bridgePairing2ID") as! String?
        self.init(bridgePairing1ID: bridgePairing1ID, bridgePairing2ID: bridgePairing2ID)
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(bridgePairing1ID, forKey: "bridgePairing1ID")
        aCoder.encode(bridgePairing2ID, forKey: "bridgePairing2ID")
    }
    
}
