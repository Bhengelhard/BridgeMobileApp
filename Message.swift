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
    
    private let parseMessage: PFObject
    
    let id: String?
    
    var user1ID: String?
    var user2ID: String?
    var bridgeBuilderID: String?
    
    var user1Name: String?
    var user2Name: String?
    
    var user1FirstName: String? {
        if let user1Name = user1Name {
            return DisplayUtility.firstName(name: user1Name)
        }
        return nil
    }
    
    var user1FirstNameLastNameInitial: String? {
        if let user1Name = user1Name {
            return DisplayUtility.firstNameLastNameInitial(name: user1Name)
        }
        return nil
    }
    
    var user2FirstName: String? {
        if let user2Name = user2Name {
            return DisplayUtility.firstName(name: user2Name)
        }
        return nil
    }
    
    var user2FirstNameLastNameInitial: String? {
        if let user2Name = user2Name {
            return DisplayUtility.firstNameLastNameInitial(name: user2Name)
        }
        return nil
    }
    
    private var userIDsToUsers = [String: User]()
    
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
            bridgeBuilderID = parseBridgeBuilder
        }
        
        if let parseUser1Name = parseMessage["user1_name"] as? String {
            user1Name = parseUser1Name
        }
        
        if let parseUser2Name = parseMessage["user2_name"] as? String {
            user2Name = parseUser2Name
        }
        
        super.init()
    }
    
    static func get(withId id: String, withBlock block: MessageBlock? = nil) {
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
        if let bridgeBuilderID = bridgeBuilderID {
            getUser(withID: bridgeBuilderID, withBlock: block)
        }
    }
    
    private func getUser(withID id: String, withBlock block: User.UserBlock? = nil) {
        if let user = userIDsToUsers[id] {
            if let block = block {
                block(user)
            }
        } else {
            User.get(withId: id) { (user) in
                self.userIDsToUsers[id] = user
                if let block = block {
                    block(user)
                }
            }
        }
    }
    
    /// Gets user in message that is not the current user. Defaults to User 1.
    func getNonCurrentUser(withBlock block: User.UserBlock? = nil) {
        User.getCurrent { (currentUser) in
            if currentUser.id == self.user1ID {
                self.getUser2(withBlock: block)
            } else {
                self.getUser1(withBlock: block)
            }
        }
    }
    
    func save(withBlock block: MessageBlock?) {
        if let user1ID = user1ID {
            parseMessage["user1_objectID"] = user1ID
        }
        
        if let user2ID = user2ID {
            parseMessage["user2_objectID"] = user2ID
        }
        
        if let bridgeBuilderID = bridgeBuilderID {
            parseMessage["bridge_builder"] = bridgeBuilderID
        }
        
        if let user1Name = user1Name {
            parseMessage["user1_name"] = user1Name
        }
        
        if let user2Name = user2Name {
            parseMessage["user2_name"] = user2Name
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

