//
//  SingleMessageContent.swift
//  MyBridgeApp
//
//  Created by Sagar Sinha on 7/19/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import UIKit
class SingleMessageContent {
    var messageText: String?
    var bridgeType: String?
    var senderName: String?
    var timestamp: String?
    var isNotification: Bool?
    init(messageContent: [String: AnyObject]) {
        if let m = messageContent["messageText"] as? String {
            messageText = m
        }
        if let b = messageContent["bridgeType"] as? String {
            bridgeType = b
        }
        if let s = messageContent["senderName"] as? String {
            senderName = s
        }
        if let t = messageContent["timestamp"] as? String {
            timestamp = t
        }
        if let i = messageContent["isNotification"] as? Bool {
            isNotification = i
        }
        
        
    }
    
    var backgroundColor: UIColor {
        if bridgeType == "Business" {
            return UIColor.init(red: 144.0/255, green: 207.0/255, blue: 214.0/255, alpha: 1.0)
        }
        else if bridgeType == "Love" {
            return UIColor.init(red: 255.0/255, green: 129.0/255, blue: 125.0/255, alpha: 1.0)
        }
        else if bridgeType == "Friendship" {
            return UIColor(red: 139.0/255, green: 217.0/255, blue: 176.0/255, alpha: 1.0)
        }
        return UIColor.grayColor()
    }
    
   
}

