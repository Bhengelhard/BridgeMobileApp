//
//  MessageContent.swift
//  MyBridgeApp
//
//  Created by Sagar Sinha on 8/11/16.
//  Copyright © 2016 Parse. All rights reserved.
//
import Foundation
import UIKit
import Parse
class MessageContent {
    var participantsText: String?
    var messageSnapshotText: String?
    var messageTimestampText: String?
    var notificationDotHidden: Bool?
    var participantsTextColor: UIColor?
    var arrowTextColor: UIColor?
    
    
    init(messageContent: [String: AnyObject]) {
        if let m = messageContent["participantsText"] as? String {
            participantsText = m
        }
        else {
            participantsText = ""
        }
        if let b = messageContent["messageSnapshotText"] as? String {
            messageSnapshotText = b
        }
        else {
            messageSnapshotText = ""
        }
        if let s = messageContent["messageTimestampText"] as? String {
            messageTimestampText = s
        }
        else {
            messageTimestampText = ""
        }
        if let s = messageContent["notificationDotHidden"] as? Bool {
            notificationDotHidden = s
        }
        else {
            notificationDotHidden = true
        }
        
        if let p = messageContent["participantsTextColor"] as? UIColor {
            participantsTextColor = p
        }
        else {
            participantsTextColor = UIColor.black
        }
        if let p = messageContent["arrowTextColor"] as? UIColor {
            arrowTextColor = p
        }
        else {
            arrowTextColor = UIColor.black
        }
}
}
