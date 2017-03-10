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
    var senderID: String?
    var senderName: String?
    
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
                    collectionView.layoutIfNeeded()
                }
            }
        }
    }
    
    
    
    func setSenderInfo(collectionView: UICollectionView, messageID: String?) {
        if let messageID = messageID {
            Message.get(withID: messageID) { (message) in
                message.getNonCurrentUser { (user) in
                    self.senderID = user.id
                    self.senderName = user.name
                    collectionView.reloadData()
                    collectionView.layoutIfNeeded()
                }
            }
        }
    }
    
}
