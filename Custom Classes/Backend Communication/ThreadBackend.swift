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
    
    
    
    func setSenderInfo(collectionView: UICollectionView, withBlock block: @escaping (String?, String?) -> Void) {
        User.getCurrent { (user) in
            block(user.id, user.name)
            collectionView.reloadData()
        }
    }
    
    func getCurrentUserPicture(collectionView: UICollectionView, withBlock block: Picture.ImageBlock? = nil) {
        User.getCurrent { (user) in
            user.getMainPicture { (picture) in
                picture.getImage { (image) in
                    if let block = block {
                        block(image)
                    }
                    collectionView.reloadData()
                }
            }
        }
    }
    
    func getOtherUserInMessagePicture(collectionView: UICollectionView, messageID: String?, withBlock block: Picture.ImageBlock? = nil) {
        if let messageID = messageID {
            Message.get(withID: messageID) { (message) in
                message.getNonCurrentUser { (user) in
                    user.getMainPicture { (picture) in
                        picture.getImage { (image) in
                            if let block = block {
                                block(image)
                            }
                            collectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func jsqMessageToSingleMessage(jsqMessage: JSQMessage, messageID: String?, withBlock block: SingleMessage.SingleMessageBlock? = nil) {
        SingleMessage.create(text: jsqMessage.text, senderID: jsqMessage.senderId, senderName: jsqMessage.senderDisplayName, messageID: messageID, withBlock: block)
    }
    
    func updateMessageSnapshot(messageID: String?, snapshot: String) {
        if let messageID = messageID {
            Message.get(withID: messageID) { (message) in
                message.lastSingleMessage = snapshot
                message.save()
            }
        }
    }
    
}
