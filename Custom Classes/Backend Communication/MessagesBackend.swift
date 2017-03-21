//
//  MessagesBackend.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 2/22/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class MessagesBackend {
    
    // number of elements
    var totalElements: Int32 = 0
    let noOfElementsPerRefresher = 5
    var noOfElementsFetched = 0
    var noOfElementsProcessed = 0
    
    // message info storage
    var messagePositionToIDMapping = [Int: String]()
    var messageNames = [String: String?]()
    var messageSnapshots = [String: String?]()
    var messageProfilePictures = [String: UIImage?]()
    var messageNotificationDots = [String: Bool?]()
    
    init() {
    }
    
    // get rid of all stored messages and reload messages table from scratch
    func reloadMessagesTable(tableView: UITableView) {
        totalElements = 0
        noOfElementsFetched = 0
        noOfElementsProcessed = 0
        
        messagePositionToIDMapping = [Int: String]()
        messageNames = [String: String?]()
        messageSnapshots = [String: String?]()
        messageProfilePictures = [String: UIImage?]()
        
        User.getCurrent { (user) in
            Message.countAllStarted(withUser: user) { (count) in
                self.totalElements = count
                
                // get rid of no messages label, if applicable
                if let messagesTableView = tableView as? MessagesObjects.MessagesTable {
                    if count == 0 {
                        messagesTableView.noMessagesLabel.alpha = 1
                    } else {
                        messagesTableView.noMessagesLabel.alpha = 0
                    }
                }
                
                self.refreshMessagesTable(tableView: tableView)
            }
        }
    }
    
    // get next batch of messages and add to messages table
    func refreshMessagesTable(tableView: UITableView) {
        User.getCurrent { (user) in
            Message.getAllStarted(withUser: user, withLimit: self.noOfElementsPerRefresher, withSkip: self.noOfElementsFetched) { (messages) in
                self.noOfElementsFetched += messages.count
                for message in messages {
                    if let messageID = message.id {
                        // save message position
                        self.messagePositionToIDMapping[self.noOfElementsProcessed] = messageID
                        self.noOfElementsProcessed += 1
                        
                        // save name of other user in message
                        if let userID = user.id {
                            if let messageUser1ID = message.user1ID {
                                if messageUser1ID == userID { // current user is user1
                                    // we want user2's name
                                    if let messageUser2Name = message.user2Name {
                                        self.messageNames[messageID] = messageUser2Name
                                    }
                                }
                            }
                            if let messageUser2ID = message.user2ID {
                                if messageUser2ID == userID { // current user is user2
                                    // we want user1's name
                                    if let messageUser1Name = message.user1Name {
                                        self.messageNames[messageID] = messageUser1Name
                                    }
                                }
                            }
                        }
                        
                        // save profile picture of other user in message
                        message.getNonCurrentUser { (otherUser) in
                            otherUser.getMainPicture { (picture) in
                                picture.getImage { (image) in
                                    self.messageProfilePictures[messageID] = image
                                    tableView.reloadData()
                                }
                            }
                        }
                        
                        // save message snapshot
                        if let messageLastSingleMessage = message.lastSingleMessage {
                            self.messageSnapshots[messageID] = messageLastSingleMessage
                        }
                        
                        // save notification dot
                        if let userID = user.id {
                            if let messageUser1ID = message.user1ID {
                                if messageUser1ID == userID { // current user is user1
                                    // we want whether user1 has seen last single message
                                    if let messageUser1HasSeenLastSingleMessage = message.user1HasSeenLastSingleMessage {
                                        self.messageNotificationDots[messageID] = !messageUser1HasSeenLastSingleMessage
                                    }
                                }
                            }
                            if let messageUser2ID = message.user2ID {
                                if messageUser2ID == userID { // current user is user2
                                    // we want whether user2 has seen last single message
                                    if let messageUser2HasSeenLastSingleMessage = message.user2HasSeenLastSingleMessage {
                                        self.messageNotificationDots[messageID] = !messageUser2HasSeenLastSingleMessage
                                    }
                                }
                            }
                        }
                    }
                }
                tableView.reloadData()
            }
        }
    }
    
    func loadNewMatches(newMatchesTableViewCell: NewMatchesTableViewCell) {
        newMatchesTableViewCell.reset()
        User.getCurrent { (user) in
            Message.getAllUnstarted(withUser: user) { (messages) in
                for message in messages {
                    newMatchesTableViewCell.addUserInMessage(message: message)
                }
            }
        }
    }
    
    func setParticipantsLabel(index: Int, label: UILabel) {
        if let id = messagePositionToIDMapping[index] {
            if let name = messageNames[id] {
                label.text = name
            }
        }
    }
    
    func setSanpshotLabel(index: Int, textView: UITextView) {
        if let id = messagePositionToIDMapping[index] {
            if let snapshot = messageSnapshots[id] {
                textView.text = snapshot
            } else {
                textView.text = "You've been 'nected. Get the conversation going!"
                textView.textColor = .gray
            }
        }
    }
    
    func setProfilePicture(index: Int, imageView: UIImageView) {
        if let id = messagePositionToIDMapping[index] {
            if let image = messageProfilePictures[id] {
                imageView.image = image
            }
        }
    }
    
    func setDotAlpha(index: Int, dot: UIView) {
        if let id = messagePositionToIDMapping[index] {
            if let notificationDot = messageNotificationDots[id] {
                if let notificationDot = notificationDot {
                    if notificationDot {
                        dot.alpha = 1
                    } else {
                        dot.alpha = 0
                    }
                } else {
                    dot.alpha = 0
                }
            }
        }
    }
    
    
}
