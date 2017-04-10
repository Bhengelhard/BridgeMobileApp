//
//  Message.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 2/15/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Parse


class Message: NSObject {
    typealias MessageBlock = (Message) -> Void
    typealias MessagesBlock = ([Message]) -> Void
    typealias MessageCreateBlock = (Message, Bool) -> Void
    
    private let parseMessage: PFObject
    
    /// The objectId of the Message
    var id: String?
    
    /// The objectId of the first user of the Message
    var user1ID: String?
    
    /// The objectId of the second user of the Message
    var user2ID: String?
    
    /// The objectId of the connecter of the Message
    var connecterID: String?
    
    /// The full name of the first user of the Message
    var user1Name: String?
    
    /// The first name of the first user of the Message
    var user1FirstName: String? {
        if let user1Name = user1Name {
            return DisplayUtility.firstName(name: user1Name)
        }
        return nil
    }
    
    /// The first name and first initial of the last name of the first user of the Message
    var user1FirstNameLastNameInitial: String? {
        if let user1Name = user1Name {
            return DisplayUtility.firstNameLastNameInitial(name: user1Name)
        }
        return nil
    }
    
    /// The full name of the second user of the Message
    var user2Name: String?
    
    /// The first name of the second user of the Message
    var user2FirstName: String? {
        if let user2Name = user2Name {
            return DisplayUtility.firstName(name: user2Name)
        }
        return nil
    }
    
    /// The first name and first initial of the last name of the second user of the Message
    var user2FirstNameLastNameInitial: String? {
        if let user2Name = user2Name {
            return DisplayUtility.firstNameLastNameInitial(name: user2Name)
        }
        return nil
    }
    
    /// The objectId of the profile picture of the first user of the Message
    var user1PictureID: String?
    
    /// The objectId of the profile picture of the second user of the Message
    var user2PictureID: String?
    
    /// The text of the last single message in the Message's thread
    var lastSingleMessage: String?
    
    /// The last updatedAt time of the last single message in the Message's thread
    var lastSingleMessageAt: Date?
    
    var user1HasSeenLastSingleMessage: Bool?
    
    var user2HasSeenLastSingleMessage: Bool?
    
    var user1HasPosted: Bool?
    
    var user2HasPosted: Bool?
    
    private var userIDsToUsers = [String: User]()
    private var pictureIDsToPictures = [String: Picture]()
    
    private init(parseMessage: PFObject) {
        self.parseMessage = parseMessage
        
        id = parseMessage.objectId
        
        if let parseUser1ObjectId = parseMessage["user1_objectId"] as? String {
            user1ID = parseUser1ObjectId
        }
        
        if let parseUser2ObjectId = parseMessage["user2_objectId"] as? String {
            user2ID = parseUser2ObjectId
        }
        
        if let parseBridgeBuilder = parseMessage["bridge_builder"] as? String {
            connecterID = parseBridgeBuilder
        }
        
        if let parseUser1Name = parseMessage["user1_name"] as? String {
            user1Name = parseUser1Name
        }
        
        if let parseUser2Name = parseMessage["user2_name"] as? String {
            user2Name = parseUser2Name
        }
        
        if let parseUser1PictureObjectId = parseMessage["user1_picture_objectId"] as? String {
            user1PictureID = parseUser1PictureObjectId
        }
        
        if let parseUser2PictureObjectId = parseMessage["user2_picture_objectId"] as? String {
            user2PictureID = parseUser2PictureObjectId
        }
        
        if let parseLastSingleMessage = parseMessage["last_single_message"] as? String {
            lastSingleMessage = parseLastSingleMessage
        }
        
        if let parseLastSingleMessageAt = parseMessage["lastSingleMessageAt"] as? Date {
            lastSingleMessageAt = parseLastSingleMessageAt
        }
        
        if let parseUser1HasSeenLastSingleMessage = parseMessage["user1_has_seen_last_single_message"] as? Bool {
            user1HasSeenLastSingleMessage = parseUser1HasSeenLastSingleMessage
        }
        
        if let parseUser2HasSeenLastSingleMessage = parseMessage["user2_has_seen_last_single_message"] as? Bool {
            user2HasSeenLastSingleMessage = parseUser2HasSeenLastSingleMessage
        }
        
        if let parseUser1HasPosted = parseMessage["user1_has_posted"] as? Bool {
            user1HasPosted = parseUser1HasPosted
        }
        
        if let parseUser2HasPosted = parseMessage["user2_has_posted"] as? Bool {
            user2HasPosted = parseUser2HasPosted
        }
        
        super.init()
    }
    
    /// Creates a new Message object with the provided parameters and calls the given block on the result.
    static func create(user1ID: String? = nil, user2ID: String? = nil, connecterID: String? = nil, user1Name: String? = nil, user2Name: String? = nil, user1PictureID: String? = nil, user2PictureID: String? = nil, lastSingleMessage: String? = nil, user1HasSeenLastSingleMessage: Bool?, user2HasSeenLastSingleMessage: Bool?, user1HasPosted: Bool?, user2HasPosted: Bool?, withBlock block: MessageCreateBlock? = nil) {

        // Checking if the users are already in a message
        let query1 = PFQuery(className: "Messages")
        if let user1ID = user1ID, let user2ID = user2ID {
            query1.whereKey("user1_objectId", equalTo: user1ID)
            query1.whereKey("user2_objectId", equalTo: user2ID)
        }
        
        let query2 = PFQuery(className: "Messages")
        if let user1ID = user1ID, let user2ID = user2ID {
            query2.whereKey("user1_objectId", equalTo: user2ID)
            query1.whereKey("user2_objectId", equalTo: user1ID)
        }
        
        let query = PFQuery.orQuery(withSubqueries: [query1, query2])
        
        /*
        let optionsForIdsInMessage = [[user1ID, user2ID], [user2ID, user1ID]]
        let query = PFQuery(className: "Messages")
        query.whereKey("ids_in_message", containedIn: optionsForIdsInMessage)
        */
        
        query.getFirstObjectInBackground(block: { (object, error) in
            // The users are already in a message together
            if user1ID != nil && user2ID != nil && object != nil {
                if let object = object {
                    let message = Message(parseMessage: object)
                    let isNew = false

                    if let block = block {
                        block(message, isNew)
                    }
                }
            } else { // The users are not yet in a message together, so create a new one
                let parseMessage = PFObject(className: "Messages")

                // set Message's ACL
                let acl = PFACL()
                acl.getPublicReadAccess = true
                acl.getPublicWriteAccess = true
                parseMessage.acl = acl
                
                if let user1ID = user1ID, let user2ID = user2ID {
                    parseMessage["user1_objectId"] = user1ID
                    parseMessage["user2_objectId"] = user2ID
                    parseMessage["ids_in_message"] = [user1ID, user2ID]
                }
                
                if let connecterID = connecterID {
                    parseMessage["bridge_builder"] = connecterID
                }
                
                if let user1Name = user1Name {
                    parseMessage["user1_name"] = user1Name
                }
                
                if let user2Name = user2Name {
                    parseMessage["user2_name"] = user2Name
                }
                
                if let user1PictureID = user1PictureID {
                    parseMessage["user1_picture_objectId"] = user1PictureID
                }
                
                if let user2PictureID = user2PictureID {
                    parseMessage["user2_picture_objectId"] = user2PictureID
                }
                
                if let lastSingleMessage = lastSingleMessage {
                    parseMessage["last_single_message"] = lastSingleMessage
                }
                
                if let user1HasSeenLastSingleMessage = user1HasSeenLastSingleMessage {
                    parseMessage["user1_has_seen_last_single_message"] = user1HasSeenLastSingleMessage
                }
                
                if let user2HasSeenLastSingleMessage = user2HasSeenLastSingleMessage {
                    parseMessage["user2_has_seen_last_single_message"] = user2HasSeenLastSingleMessage
                }
                
                if let user1HasPosted = user1HasPosted {
                    parseMessage["user1_has_posted"] = user1HasPosted
                }
                
                if let user2HasPosted = user2HasPosted {
                    parseMessage["user2_has_posted"] = user2HasPosted
                }
                
                let message = Message(parseMessage: parseMessage)
                                
                let isNew = true
                
                if let block = block {
                    block(message, isNew)
                }
            }
        })
        
    }
    
    /// Gets the Message object with the provided objectId and calls the given block on
    /// the result.
    /// - parameter id: the objectId of the Message
    /// - parameter block: the block to call on the result
    static func get(withID id: String, withBlock block: MessageBlock? = nil) {
        let query = PFQuery(className: "Messages")
        query.getObjectInBackground(withId: id) { (parseObject, error) in
            if let error = error {
                print("error getting message with id \(id) - \(error)")
            } else if let parseMessage = parseObject {
                let message = Message(parseMessage: parseMessage)
                if let block = block {
                    block(message)
                }
            }
        }
    }
    
    static func getAll(withUser user: User, withLimit limit: Int = 10000, withSkip skip: Int = 0, withBlock block: MessagesBlock? = nil) {
        if let userID = user.id {
            let subQuery1 = PFQuery(className: "Messages")
            subQuery1.whereKey("user1_objectId", equalTo: userID)
            let subQuery2 = PFQuery(className: "Messages")
            subQuery2.whereKey("user2_objectId", equalTo: userID)
            
            let query = PFQuery.orQuery(withSubqueries: [subQuery1, subQuery2])
            query.order(byDescending: "lastSingleMessageAt")
            query.limit = limit
            query.skip = skip
            
            query.findObjectsInBackground { (parseMessages, error) in
                if let error = error {
                    print("error getting messages - \(error)")
                } else if let parseMessages = parseMessages {
                    var messages = [Message]()
                    for parseMessage in parseMessages {
                        let message = Message(parseMessage: parseMessage)
                        messages.append(message)
                    }
                    if let block = block {
                        block(messages)
                    }
                }
            }
        }
    }
    
    static func getAllUnstarted(withUser user: User, withLimit limit: Int = 10000, withSkip skip: Int = 0, withBlock block: MessagesBlock? = nil) {
        if let userID = user.id {
            let subQuery1 = PFQuery(className: "Messages")
            subQuery1.whereKey("user1_objectId", equalTo: userID)
            let subQuery2 = PFQuery(className: "Messages")
            subQuery2.whereKey("user2_objectId", equalTo: userID)
            
            let query = PFQuery.orQuery(withSubqueries: [subQuery1, subQuery2])
            query.whereKeyDoesNotExist("last_single_message")
            query.order(byDescending: "updatedAt")
            query.limit = limit
            query.skip = skip
            
            query.findObjectsInBackground { (parseMessages, error) in
                if let error = error {
                    print("error getting messages - \(error)")
                } else if let parseMessages = parseMessages {
                    var messages = [Message]()
                    for parseMessage in parseMessages {
                        let message = Message(parseMessage: parseMessage)
                        messages.append(message)
                    }
                    if let block = block {
                        block(messages)
                    }
                }
            }
        }
    }
    
    static func getAllStarted(withUser user: User, withLimit limit: Int = 10000, withSkip skip: Int = 0, withBlock block: MessagesBlock? = nil) {
        if let userID = user.id {
            let subQuery1 = PFQuery(className: "Messages")
            subQuery1.whereKey("user1_objectId", equalTo: userID)
            let subQuery2 = PFQuery(className: "Messages")
            subQuery2.whereKey("user2_objectId", equalTo: userID)
            
            let query = PFQuery.orQuery(withSubqueries: [subQuery1, subQuery2])
            query.whereKeyExists("last_single_message")
            query.order(byDescending: "lastSingleMessageAt")
            query.limit = limit
            query.skip = skip
            
            query.findObjectsInBackground { (parseMessages, error) in
                if let error = error {
                    print("error getting messages - \(error)")
                } else if let parseMessages = parseMessages {
                    var messages = [Message]()
                    for parseMessage in parseMessages {
                        let message = Message(parseMessage: parseMessage)
                        messages.append(message)
                    }
                    if let block = block {
                        block(messages)
                    }
                }
            }
        }
    }
        
    static func countAllStarted(withUser user: User, withBlock block: ((Int32) -> Void)? = nil) {
        if let userID = user.id {
            let subQuery1 = PFQuery(className: "Messages")
            subQuery1.whereKey("user1_objectId", equalTo: userID)
            let subQuery2 = PFQuery(className: "Messages")
            subQuery2.whereKey("user2_objectId", equalTo: userID)
            
            let query = PFQuery.orQuery(withSubqueries: [subQuery1, subQuery2])
            query.whereKeyExists("last_single_message")
            query.countObjectsInBackground(block: { (count, error) in
                if let error = error {
                    print("error counting messages - \(error)")
                } else {
                    if let block = block {
                        block(count)
                    }
                }
            })
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
    
    func getBridgeBuilder(withBlock block: User.UserBlock? = nil) {
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
    
    func save(withBlock block: MessageBlock? = nil) {
        if let user1ID = user1ID {
            parseMessage["user1_objectId"] = user1ID
        } else {
            parseMessage.remove(forKey: "user1_objectId")
        }
        
        if let user2ID = user2ID {
            parseMessage["user2_objectId"] = user2ID
        } else {
            parseMessage.remove(forKey: "user2_objectId")
        }
        
        if let connecterID = connecterID {
            parseMessage["bridge_builder"] = connecterID
        } else {
            parseMessage.remove(forKey: "bridge_builder")
        }
        
        if let user1Name = user1Name {
            parseMessage["user1_name"] = user1Name
        }  else {
            parseMessage.remove(forKey: "user1_name")
        }
        
        if let user2Name = user2Name {
            parseMessage["user2_name"] = user2Name
        } else {
            parseMessage.remove(forKey: "user2_name")
        }
        
        if let user1PictureID = user1PictureID {
            parseMessage["user1_picture_objectId"] = user1PictureID
        } else {
            parseMessage.remove(forKey: "user1_picture_objectId")
        }
        
        if let user2PictureID = user2PictureID {
            parseMessage["user2_picture_objectId"] = user2PictureID
        } else {
            parseMessage.remove(forKey: "user2_picture_objectId")
        }
        
        if let lastSingleMessage = lastSingleMessage {
            parseMessage["last_single_message"] = lastSingleMessage
        } else {
            parseMessage.remove(forKey: "last_single_message")
        }
        
        if let lastSingleMessageAt = lastSingleMessageAt {
            parseMessage["lastSingleMessageAt"] = lastSingleMessageAt
        } else {
            parseMessage.remove(forKey: "lastSingleMessageAt")
        }
        
        if let user1HasSeenLastSingleMessage = user1HasSeenLastSingleMessage {
            parseMessage["user1_has_seen_last_single_message"] = user1HasSeenLastSingleMessage
        } else {
            parseMessage.remove(forKey: "user1_has_seen_last_single_message")
        }
        
        if let user2HasSeenLastSingleMessage = user2HasSeenLastSingleMessage {
            parseMessage["user2_has_seen_last_single_message"] = user2HasSeenLastSingleMessage
        } else {
            parseMessage.remove(forKey: "user2_has_seen_last_single_message")
        }
        
        if let user1HasPosted = user1HasPosted {
            parseMessage["user1_has_posted"] = user1HasPosted
        } else {
            parseMessage.remove(forKey: "user1_has_posted")
        }
        
        if let user2HasPosted = user2HasPosted {
            parseMessage["user2_has_posted"] = user2HasPosted
        } else {
            parseMessage.remove(forKey: "user2_has_posted")
        }
        
        parseMessage.saveInBackground { (succeeded, error) in
            if let error = error {
                print("error saving message - \(error)")
            } else if succeeded {
                self.id = self.parseMessage.objectId
                if let block = block {
                    block(self)
                }
            }
        }
    }
}

