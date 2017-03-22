//
//  ThreadBackend.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 3/10/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import JSQMessagesViewController
import UIKit

class ThreadBackend {
    
    var jsqMessages = [JSQMessage]()
    
    func reloadSingleMessages(collectionView: UICollectionView, messageID: String?) {
        jsqMessages = [JSQMessage]()
        if let messageID = messageID {
            Message.get(withID: messageID) { (message) in
                SingleMessage.getAll(withMessage: message) { (singleMessages) in
                    for singleMessage in singleMessages {
                        if let jsqMessage = ThreadLogic.singleMessageToJSQMessage(singleMessage: singleMessage) {
                            self.jsqMessages.append(jsqMessage)
                        }
                    }
                    collectionView.reloadData()
                    
                    // scroll to bottom
                    if self.jsqMessages.count > 0 {
                        collectionView.scrollToItem(at: IndexPath(item: self.jsqMessages.count-1, section: 0), at: .bottom, animated: true)
                    }
                }
            }
        }
    }
    
    
    
    func setSenderInfo(withBlock block: @escaping (String?, String?) -> Void) {
        User.getCurrent { (user) in
            block(user.id, user.name)
        }
    }
    
    func setOtherInfo(messageID: String?, withBlock block: @escaping (String?, String?) -> Void) {
        if let messageID = messageID {
            Message.get(withID: messageID) { (message) in
                message.getNonCurrentUser { (user) in
                    block(user.id, user.name)
                }
            }
        }
    }
    
    func getCurrentUserPicture(withBlock block: Picture.ImageBlock? = nil) {
        User.getCurrent { (user) in
            user.getMainPicture { (picture) in
                picture.getImage { (image) in
                    if let block = block {
                        block(image)
                    }
                }
            }
        }
    }
    
    func getOtherUserInMessagePicture(messageID: String?, withBlock block: Picture.ImageBlock? = nil) {
        if let messageID = messageID {
            Message.get(withID: messageID) { (message) in
                message.getNonCurrentUser { (user) in
                    user.getMainPicture { (picture) in
                        picture.getImage { (image) in
                            if let block = block {
                                block(image)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getUserPicture(userID: String?, withBlock block: Picture.ImageBlock? = nil) {
        if let userID = userID {
            User.get(withID: userID) { (user) in
                user.getMainPicture { (picture) in
                    picture.getImage { (image) in
                        if let block = block {
                            block(image)
                        }
                    }
                }
            }
        }
    }
    
    func jsqMessageToSingleMessage(jsqMessage: JSQMessage, messageID: String?, withBlock block: SingleMessage.SingleMessageBlock? = nil) {
        SingleMessage.create(text: jsqMessage.text, senderID: jsqMessage.senderId, senderName: jsqMessage.senderDisplayName, messageID: messageID, withBlock: block)
    }
    
    func updateMessageAfterSingleMessageSent(messageID: String?, snapshot: String, withBothHavePostedForFirstTimeBlock block: (() -> Void)? = nil) {
        if let messageID = messageID {
            Message.get(withID: messageID) { (message) in
                // update last single message
                message.lastSingleMessage = snapshot
                
                // update current user has posted and other user has seen last single message
                User.getCurrent { (user) in
                    var shouldCallBlock = false
                    if let userID = user.id {
                        if userID == message.user1ID {
                            // check if both have posted for the first time
                            if let user2HasPosted = message.user2HasPosted {
                                if user2HasPosted { // user 2 has already posted
                                    if let user1HasPosted = message.user1HasPosted {
                                        if !user1HasPosted { // this is user 1's first post
                                            shouldCallBlock = true
                                        }
                                    } else { // user1HasPosted == nil -> this is user 1's first post
                                        shouldCallBlock = true
                                    }
                                }
                            }
                            message.user1HasPosted = true
                            message.user2HasSeenLastSingleMessage = false
                        } else if userID == message.user2ID {
                            // check if both have posted for the first time
                            if let user1HasPosted = message.user1HasPosted {
                                if user1HasPosted { // user 1 has already posted
                                    if let user2HasPosted = message.user2HasPosted {
                                        if !user2HasPosted { // this is user 2's first post
                                            shouldCallBlock = true
                                        }
                                    } else { // user2HasPosted == nil -> this is user 2's first post
                                        shouldCallBlock = true
                                    }
                                }
                            }
                            message.user2HasPosted = true
                            message.user1HasSeenLastSingleMessage = false
                        }
                    }
                    message.save { (message) in
                        if shouldCallBlock {
                            if let block = block {
                                block()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func updateHasSeenLastSingleMessage(messageID: String?) {
        if let messageID = messageID {
            Message.get(withID: messageID) { (message) in
                User.getCurrent { (user) in
                    if let userID = user.id {
                        if userID == message.user1ID {
                            message.user1HasSeenLastSingleMessage = true
                        } else if userID == message.user2ID {
                            message.user2HasSeenLastSingleMessage = true
                        }
                    }
                    message.save()
                }
            }
        }
    }
    
}
