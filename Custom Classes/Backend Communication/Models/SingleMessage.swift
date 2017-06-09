//
//  SingleMessage.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 3/9/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import Parse

class SingleMessage {
    
    typealias SingleMessageBlock = (SingleMessage) -> Void
    typealias SingleMessagesBlock = ([SingleMessage]) -> Void
    
    let parseSingleMessage: PFObject
    
    var id: String?
    
    var text: String?
    var senderID: String?
    var senderName: String?
    var createdAt: Date?
    var messageID: String?
    
    private init(parseSingleMessage: PFObject) {
        self.parseSingleMessage = parseSingleMessage
        
        id = parseSingleMessage.objectId
        
        if let parseText = parseSingleMessage["message_text"] as? String {
            text = parseText
        }
        
        if let parseSenderID = parseSingleMessage["sender"] as? String {
            senderID = parseSenderID
        }
        
        if let parseSenderName = parseSingleMessage["sender_name"] as? String {
            senderName = parseSenderName
        }
        
        createdAt = parseSingleMessage.createdAt
        
        if let parseMessageID = parseSingleMessage["message_id"] as? String {
            messageID = parseMessageID
        }
    }
    
    static func create(text: String?, senderID: String?, senderName: String?, messageID: String?, withBlock block: SingleMessageBlock? = nil) {
        
        print("creating")
        
        let parseSingleMessage = PFObject(className: "SingleMessages")
        
        // set SingleMessage's ACL
        let acl = PFACL()
        acl.getPublicReadAccess = true
        parseSingleMessage.acl = acl
        
        if let text = text {
            parseSingleMessage["message_text"] = text
        }
        
        if let senderID = senderID {
            parseSingleMessage["sender"] = senderID
        }
        
        if let senderName = senderName {
            parseSingleMessage["sender_name"] = senderName
        }
        
        if let messageID = messageID {
            parseSingleMessage["message_id"] = messageID
        }
        
        let singleMessage = SingleMessage(parseSingleMessage: parseSingleMessage)
        if let block = block {
            block(singleMessage)
        }
    }
    
    static func get(withID id: String, withBlock block: SingleMessageBlock? = nil) {
        let query = PFQuery(className: "SingleMessages")
        query.getObjectInBackground(withId: id) { (parseObject, error) in
            if let error = error {
                print("error getting single message with id \(id) - \(error)")
            } else if let parseSingleMessage = parseObject {
                let singleMessage = SingleMessage(parseSingleMessage: parseSingleMessage)
                if let block = block {
                    block(singleMessage)
                }
            }
        }
    }
    
    static func getAll(withMessage message: Message, withBlock block: SingleMessagesBlock? = nil) {
        if let messageID = message.id {
            let query = PFQuery(className: "SingleMessages")
            query.whereKey("message_id", equalTo: messageID)
            query.order(byAscending: "createdAt")
            query.limit = 10000
            
            query.findObjectsInBackground { (parseSingleMessages, error) in
                if let error = error {
                    print("error getting single messages - \(error)")
                } else if let parseSingleMessages = parseSingleMessages {
                    var singleMessages = [SingleMessage]()
                    for parseSingleMessage in parseSingleMessages {
                        let singleMessage = SingleMessage(parseSingleMessage: parseSingleMessage)
                        singleMessages.append(singleMessage)
                    }
                    if let block = block {
                        block(singleMessages)
                    }
                }
            }
        }
    }
    
    func save(withBlock block: SingleMessageBlock? = nil) {
        if let text = text {
            parseSingleMessage["message_text"] = text
        } else {
            parseSingleMessage.remove(forKey: "message_text")
        }
        
        if let senderID = senderID {
            parseSingleMessage["sender"] = senderID
        } else {
            parseSingleMessage.remove(forKey: "sender")
        }
        
        if let senderName = senderName {
            parseSingleMessage["sender_name"] = senderName
        } else {
            parseSingleMessage.remove(forKey: "sender_name")
        }
        
        if let messageID = messageID {
            parseSingleMessage["message_id"] = messageID
        } else {
            parseSingleMessage.remove(forKey: "message_id")
        }
        
        parseSingleMessage.saveInBackground { (succeeded, error) in
            if let error = error {
                print("error saving single message - \(error)")
            } else if succeeded {
                self.id = self.parseSingleMessage.objectId
                self.createdAt = self.parseSingleMessage.createdAt
                if let block = block {
                    block(self)
                }
            }
        }
    }
    
}
