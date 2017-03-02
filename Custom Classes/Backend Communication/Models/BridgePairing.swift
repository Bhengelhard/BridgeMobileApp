//
//  BridgePairing.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 2/16/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Parse

class BridgePairing: NSObject, NSCoding {
    
    typealias BridgePairingBlock = (BridgePairing) -> Void
    typealias BridgePairingsBlock = ([BridgePairing]) -> Void
    
    private let parseBridgePairing: PFObject
    
    /// The objectId of the BridgePairing
    let id: String?
    
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
    
    /// Whether the first user of the BridgePairing has accepted or rejected the
    /// connection or neither
    var user1Response: UserResponse?
    
    /// Whether the second user of the BridgePairing has accepted or rejected the
    /// connection or neither
    var user2Response: UserResponse?
    
    /// Whether a user in a BridgePairing has accepted or rejected a connection, or if
    /// their response is still pending
    enum UserResponse: Int {
        case pending = 0
        case accepted = 1
        case ignored = 2
    }
    
    /// The objectIds of the users that have been shown a card with the BridgePairing
    var shownTo: [String]?
    
    /// Whether the card with the BirdgePairing is currently in use
    var checkedOut: Bool?
    
    private var userIDsToUsers = [String: User]()
    private var pictureIDsToPictures = [String: Picture]()
    
    private init(parseBridgePairing: PFObject) {
        self.parseBridgePairing = parseBridgePairing
        
        id = parseBridgePairing.objectId
        
        if let parseUserObjectId1 = parseBridgePairing["user_objectId1"] as? String {
            user1ID = parseUserObjectId1
        }
        
        if let parseUserObjectId2 = parseBridgePairing["user_objectId2"] as? String {
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
        
        if let parseUser1Response = parseBridgePairing["user1_response"] as? Int {
            user1Response = UserResponse(rawValue: parseUser1Response)
        }
        
        if let parseUser2Response = parseBridgePairing["user2_response"] as? Int {
            user2Response = UserResponse(rawValue: parseUser2Response)
        }
        
        if let parseShownTo = parseBridgePairing["shown_to"] as? [String] {
            shownTo = parseShownTo
        }
        
        if let parseChekcedOut = parseBridgePairing["checked_out"] as? Bool {
            checkedOut = parseChekcedOut
        }
        
    }
    
    /// Creates a new BridgePairing object with the provided parameters and calls the given block
    /// on the result.
    static func create(user1ID: String?, user2ID: String?, connecterID: String?, user1Name: String?, user2Name: String?, connecterName: String?, user1PictureID: String?, user2PictureID: String?, connecterPictureID: String?, bridged: Bool?, user1Response: UserResponse?, user2Response: UserResponse?, shownTo: [String]?, checkedOut: Bool?, block: BridgePairingBlock? = nil) {
        
        let parseBridgePairing = PFObject(className: "BridgePairing")
        
        // set BridgePairing's ACL
        let acl = PFACL()
        acl.getPublicReadAccess = true
        parseBridgePairing.acl = acl
        
        if let user1ID = user1ID {
            parseBridgePairing["user_objectId1"] = user1ID
        }
        
        if let user2ID = user2ID {
            parseBridgePairing["user_objectId2"] = user2ID
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
        
        if let user1Response = user1Response {
            parseBridgePairing["user1_response"] = user1Response.rawValue
        }
        
        if let user2Response = user2Response {
            parseBridgePairing["user2_response"] = user2Response.rawValue
        }
        
        if let shownTo = shownTo {
            parseBridgePairing["shown_to"] = shownTo
        }
        
        if let checkedOut = checkedOut {
            parseBridgePairing["checked_out"] = checkedOut
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
    func get(withID id: String, withBlock block: BridgePairingBlock? = nil) {
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
    
    static func getAll(withUser user: User, bridgedOnly: Bool = false, withLimit limit: Int = 10000, withBlock block: BridgePairingsBlock? = nil) {
        if let userID = user.id {
            let subQuery1 = PFQuery(className: "BridgePairings")
            subQuery1.whereKey("user_objectId1", equalTo: userID)
            let subQuery2 = PFQuery(className: "BridgePairings")
            subQuery2.whereKey("user_objectId2", equalTo: userID)
            
            let query = PFQuery.orQuery(withSubqueries: [subQuery1, subQuery2])
            if bridgedOnly {
                query.whereKey("bridges", equalTo: true)
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
    
    static func getAllWithFriends(ofUser user: User, notShownOnly: Bool = false, withLimit limit: Int = 10000, notCheckedOutOnly: Bool = false, withBlock block: BridgePairingsBlock? = nil) {
        if let userFriendList = user.friendList {
            let subQuery1 = PFQuery(className: "BridgePairings")
            subQuery1.whereKey("user_objectId1", containedIn: userFriendList)
            let subQuery2 = PFQuery(className: "BridgePairings")
            subQuery2.whereKey("user_objectId2", containedIn: userFriendList)
            
            let query = PFQuery.orQuery(withSubqueries: [subQuery1, subQuery2])
            query.limit = limit
            
            if notShownOnly {
                if let userID = user.id {
                    query.whereKey("shown_to", notEqualTo: userID)
                }
            }
            
            if notCheckedOutOnly {
                query.whereKey("checked_out", equalTo: false)
            }
            
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
        if let user = userIDsToUsers[id] {
            if let block = block {
                block(user)
            }
        } else {
            User.get(withID: id) { (user) in
                self.userIDsToUsers[id] = user
                if let block = block {
                    block(user)
                }
            }
        }
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
            parseBridgePairing["user_objectId1"] = user1ID
        } else {
            parseBridgePairing.remove(forKey: "user_objectId1")
        }
        
        if let user2ID = user2ID {
            parseBridgePairing["user_objectId1"] = user2ID
        } else {
            parseBridgePairing.remove(forKey: "user_objectId2")
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
        
        if let user1Response = user1Response {
            parseBridgePairing["user1_response"] = user1Response.rawValue
        } else {
            parseBridgePairing.remove(forKey: "user1_response")
        }
        
        if let user2Response = user2Response {
            parseBridgePairing["user2_response"] = user2Response.rawValue
        } else {
            parseBridgePairing.remove(forKey: "user2_response")
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
        
        parseBridgePairing.saveInBackground { (succeeded, error) in
            if let error = error {
                print("error saving bridge pairing - \(error)")
            } else if succeeded {
                if let block = block {
                    block(self)
                }
            }
        }
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let user1ID = aDecoder.decodeObject(forKey: "user1ID") as! String?
        let user2ID = aDecoder.decodeObject(forKey: "user2ID") as! String?
        let connecterID = aDecoder.decodeObject(forKey: "connecterID") as! String?
        let user1Name = aDecoder.decodeObject(forKey: "user1Name") as! String?
        let user2Name = aDecoder.decodeObject(forKey: "user2Name") as! String?
        let connecterName = aDecoder.decodeObject(forKey: "connecterName") as! String?
        let user1PictureID = aDecoder.decodeObject(forKey: "user1PictureID") as! String?
        let user2PictureID = aDecoder.decodeObject(forKey: "user2PictureID") as! String?
        let connecterPictureID = aDecoder.decodeObject(forKey: "connecterPictureID") as! String?
        let bridged = aDecoder.decodeObject(forKey: "bridged") as! Bool?
        let user1Response = aDecoder.decodeObject(forKey: "user1Repsonse") as! Int?
        let user2Response = aDecoder.decodeObject(forKey: "user2Response") as! Int?
        let shownTo = aDecoder.decodeObject(forKey: "shownTo") as! [String]?
        let checkedOut = aDecoder.decodeObject(forKey: "chekcedOut") as! Bool?
        
        let parseBridgePairing = PFObject(className: "BridgePairings")
        
        if let user1ID = user1ID {
            parseBridgePairing["user_objectId1"] = user1ID
        } else {
            parseBridgePairing.remove(forKey: "user_objectId1")
        }
        
        if let user2ID = user2ID {
            parseBridgePairing["user_objectId1"] = user2ID
        } else {
            parseBridgePairing.remove(forKey: "user_objectId2")
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
        
        if let user1Response = user1Response {
            parseBridgePairing["user1_response"] = user1Response
        } else {
            parseBridgePairing.remove(forKey: "user1_response")
        }
        
        if let user2Response = user2Response {
            parseBridgePairing["user2_response"] = user2Response
        } else {
            parseBridgePairing.remove(forKey: "user2_response")
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
        
        self.init(parseBridgePairing: parseBridgePairing)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(user1ID, forKey: "user1ID")
        aCoder.encode(user2ID, forKey: "user2ID")
        aCoder.encode(connecterID, forKey: "connecterID")
        aCoder.encode(user1Name, forKey: "user1Name")
        aCoder.encode(user2Name, forKey: "user2Name")
        aCoder.encode(connecterName, forKey: "connecterName")
        aCoder.encode(user1PictureID, forKey: "user1PictureID")
        aCoder.encode(user2PictureID, forKey: "user2PictureID")
        aCoder.encode(connecterPictureID, forKey: "connecterPictureID")
        aCoder.encode(bridged, forKey: "bridged")
        if let user1Response = user1Response {
            aCoder.encode(user1Response.rawValue, forKey: "user1Respnse")
        } else {
            aCoder.encode(nil, forKey: "user1Respnse")
        }
        if let user2Response = user2Response {
            aCoder.encode(user2Response.rawValue, forKey: "user2Respnse")
        } else {
            aCoder.encode(nil, forKey: "user2Respnse")
        }
        aCoder.encode(shownTo, forKey: "shownTo")
        aCoder.encode(checkedOut, forKey: "checkedOut")
        
    }
    
}
