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
    
    private let parseMessage: PFObject
    
    /// The objectId of the Message
    let id: String?
    
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
        
        super.init()
    }
    
    /// Creates a new Message object with the provided parameters and calls the given block on the result.
    static func create(user1ID: String? = nil, user2ID: String? = nil, connecterID: String? = nil, user1Name: String? = nil, user2Name: String? = nil, user1PictureID: String?, user2PictureID: String?, lastSingleMessage: String? = nil, withBlock block: MessageBlock?) {
        
        let parseMessage = PFObject(className: "Messages")
        
        // set Message's ACL
        let acl = PFACL()
        acl.getPublicReadAccess = true
        parseMessage.acl = acl
        
        if let user1ID = user1ID {
            parseMessage["user1_objectId"] = user1ID
        }
        
        if let user2ID = user2ID {
            parseMessage["user2_objectId"] = user2ID
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
        
        let message = Message(parseMessage: parseMessage)
        if let block = block {
            block(message)
        }
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
        
    static func countAll(withUser user: User, withBlock block: ((Int32) -> Void)? = nil) {
        if let userID = user.id {
            let subQuery1 = PFQuery(className: "Messages")
            subQuery1.whereKey("user1_objectId", equalTo: userID)
            let subQuery2 = PFQuery(className: "Messages")
            subQuery2.whereKey("user2_objectId", equalTo: userID)
            
            let query = PFQuery.orQuery(withSubqueries: [subQuery1, subQuery2])
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
    
    func save(withBlock block: MessageBlock?) {
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
        
        parseMessage.saveInBackground { (succeeded, error) in
            if let error = error {
                print("error saving message - \(error)")
            } else if succeeded {
                if let block = block {
                    block(self)
                }
            }
        }
    }
}

