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
    var isNotification: Bool?
    init(messageContent: [String: AnyObject]) {
        if let m = messageContent["messageText"] as? String {
            messageText = m
        }
        else {
            messageText = ""
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
        if let s = messageContent["showTimestamp"] as? Bool {
            showTimestamp = s
        }
        else {
            showTimestamp = false
        }

        
        
    }
    
    var backgroundColor: UIColor {
        if senderId == PFUser.currentUser()?.objectId {
            print("bridgeType == PFUser.currentUser()?.objectId")
            return UIColor.lightGrayColor()
        }
        else if bridgeType == "Business" {
            return UIColor.init(red: 144.0/255, green: 207.0/255, blue: 214.0/255, alpha: 1.0)
        }
        else if bridgeType == "Love" {
            print("bridgeType == Love")
            return UIColor.init(red: 255.0/255, green: 129.0/255, blue: 125.0/255, alpha: 1.0)
        }
        else if bridgeType == "Friendship" {
            return UIColor(red: 139.0/255, green: 217.0/255, blue: 176.0/255, alpha: 1.0)
        }
        print("bridgeType == UIColor.grayColor")
        return UIColor.lightGrayColor()
    }
    
   
}

