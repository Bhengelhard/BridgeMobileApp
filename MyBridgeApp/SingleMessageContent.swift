//
//  SingleMessageContent.swift
//  MyBridgeApp
//
//  Created by Sagar Sinha on 7/19/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import UIKit
import Parse
class SingleMessageContent {
    var messageText: String?
    var bridgeType: String?
    var senderName: String?
    var senderId: String?
    var previousSenderName: String?
    var previousSenderId: String?
    var timestamp: String?
    var showTimestamp: Bool?
    var notificationText: String?
    var isNotification = false
    
    //necter Colors
    let businessBlue = UIColor(red: 36.0/255, green: 123.0/255, blue: 160.0/255, alpha: 1.0)
    let loveRed = UIColor(red: 242.0/255, green: 95.0/255, blue: 92.0/255, alpha: 1.0)
    let friendshipGreen = UIColor(red: 112.0/255, green: 193.0/255, blue: 179.0/255, alpha: 1.0)
    let necterGray = UIColor(red: 80.0/255.0, green: 81.0/255.0, blue: 79.0/255.0, alpha: 1.0)
    
    init(messageContent: [String: AnyObject]) {
        if let m = messageContent["messageText"] as? String {
            messageText = m
            notificationText = m
        }
        else {
            messageText = ""
            notificationText = ""
        }
        if let b = messageContent["bridgeType"] as? String {
            bridgeType = b
        }
        else {
            bridgeType = ""
        }
        if let s = messageContent["senderName"] as? String {
            senderName = s
        }
        else {
            senderName = ""
        }
        if let s = messageContent["senderId"] as? String {
            senderId = s
        }
        else {
            senderId = ""
        }
        if let p = messageContent["previousSenderName"] as? String {
            previousSenderName = p
        }
        else {
            previousSenderName = ""
        }
        if let p = messageContent["previousSenderId"] as? String {
            previousSenderId = p
        }
        else {
            previousSenderId = ""
        }
        if let t = messageContent["timestamp"] as? String {
            timestamp = t
        }
        else {
            timestamp = ""
        }
        if let i = messageContent["isNotification"] as? Bool {
            isNotification = i
        }
        else {
            isNotification = false
        }
        if let n = messageContent["notification"] as? String {
            notificationText = n
        }
        else {
            notificationText = ""
        }
        if let s = messageContent["showTimestamp"] as? Bool {
            showTimestamp = s
        }
        else {
            showTimestamp = false
        }
        
    }
    
    var backgroundColor: UIColor {
        if senderId == PFUser.currentUser()?.objectId {
            return UIColor.lightGrayColor()
        }
        else if bridgeType == "Business" {
            return businessBlue
        }
        else if bridgeType == "Love" {
            return loveRed
        }
        else if bridgeType == "Friendship" {
            return friendshipGreen
        } else {
            return UIColor.lightGrayColor()
        }
        
    }
    
   
}

