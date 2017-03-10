//
//  ThreadLogic.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 3/10/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import JSQMessagesViewController

class ThreadLogic {
    static func singleMessageToJSQMessage(singleMessage: SingleMessage) -> JSQMessage? {
        if let senderID = singleMessage.senderID,
            let senderName = singleMessage.senderName,
            let createdAt = singleMessage.createdAt,
            let text = singleMessage.text {
            return JSQMessage(senderId: senderID, senderDisplayName: senderName, date: createdAt, text: text)
        }
        return nil
    }
}
