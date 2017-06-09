//
//  Swipe.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 4/6/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import Foundation
import Parse

class Swipe: NSObject {
    
    typealias SwipeBlock = (Swipe) -> Void
    
    private let parseSwipe: PFObject
    
    /// The objectId of the Swipe
    var id: String?
    
    /// The objectId of the bridge pairing on the card that was swiped
    var bridgePairingID: String?
    
    /// The objectId of the user that swiped the card
    var swiperID: String?
    
    /// Whether the card was swiped right (or left)
    var swipedRight: Bool?
    
    /// When the card was swiped
    var createdAt: Date?
    
    private init(parseSwipe: PFObject) {
        self.parseSwipe = parseSwipe
        
        if let parseBridgePairingID = parseSwipe["bridge_pairing_id"] as? String {
            bridgePairingID = parseBridgePairingID
        }
        
        if let parseSwiperID = parseSwipe["swiper_id"] as? String {
            swiperID = parseSwiperID
        }
        
        if let parseSwipedRight = parseSwipe["swiped_right"] as? Bool {
            swipedRight = parseSwipedRight
        }
        
        createdAt = parseSwipe.createdAt
    }
    
    static func create(bridgePairingID: String?, swiperID: String?, swipedRight: Bool?, withBlock block: SwipeBlock? = nil) {
        
        let parseSwipe = PFObject(className: "Swipes")
        
        // set SingleMessage's ACL
        let acl = PFACL()
        acl.getPublicReadAccess = true
        acl.getPublicWriteAccess = true
        parseSwipe.acl = acl
        
        if let bridgePairingID = bridgePairingID {
            parseSwipe["bridge_pairing_id"] = bridgePairingID
        }
        
        if let swiperID = swiperID {
            parseSwipe["swiper_id"] = swiperID
        }
        
        if let swipedRight = swipedRight {
            parseSwipe["swiped_right"] = swipedRight
        }
        
        let swipe = Swipe(parseSwipe: parseSwipe)
        if let block = block {
            block(swipe)
        }
    }
    
    func save(withBlock block: SwipeBlock? = nil) {
        if let bridgePairingID = bridgePairingID {
            parseSwipe["bridge_pairing_id"] = bridgePairingID
        } else {
            parseSwipe.remove(forKey: "message_text")
        }
        
        if let swiperID = swiperID {
            parseSwipe["swiper_id"] = swiperID
        } else {
            parseSwipe.remove(forKey: "sender")
        }
        
        if let swipedRight = swipedRight {
            parseSwipe["swiped_right"] = swipedRight
        } else {
            parseSwipe.remove(forKey: "sender_name")
        }
        
        parseSwipe.saveInBackground { (succeeded, error) in
            if let error = error {
                print("error saving single message - \(error)")
            } else if succeeded {
                self.id = self.parseSwipe.objectId
                self.createdAt = self.parseSwipe.createdAt
                if let block = block {
                    block(self)
                }
            }
        }
    }
}
