//
//  SwipeBackend.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 2/27/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class SwipeBackend {
    
    var lastCardInStack:UIView? = nil
    var topSwipeCard = SwipeCard()
    var bottomSwipeCard = SwipeCard()
    var topBridgePairing: BridgePairing?
    var bottomBridgePairing: BridgePairing?
    var reserveBridgePairing: BridgePairing?
    let localBridgePairings = LocalBridgePairings()
    var gotTopBridgePairing = false
    var gotBottomBridgePairing = false
    var gotReserveBridgeParing = false
    var downloadOnSwipe = false
    
    
    private func getTopBridgePairing(noMoreBridgePairings: (() -> Void)?, completion: (() -> Void)? = nil) {
        User.getCurrent { (user) in
            if let user = user {
                BridgePairing.getAllWithFriends(ofUser: user, notShownOnly: true, withLimit: 1, notCheckedOutOnly: true, exceptForBlocked: true) { (bridgePairings) in
                    if bridgePairings.count > 0 {
                        let bridgePairing = bridgePairings[0]
                        self.gotTopBridgePairing(bridgePairing: bridgePairing, user: user, noMoreBridgePairings: noMoreBridgePairings, completion: completion)
                    } else {
                        self.gotNoBridgePairings(noMoreBridgePairings: noMoreBridgePairings, completion: completion)
                    }
                }
            }
        }
    }
    
    private func getTwoBridgePairings(noMoreBridgePairings: (() -> Void)?, completion: (() -> Void)? = nil) {
        User.getCurrent { (user) in
            if let user = user {
                BridgePairing.getAllWithFriends(ofUser: user, notShownOnly: true, withLimit: 2, notCheckedOutOnly: true, exceptForBlocked: true) { (bridgePairings) in
                    if bridgePairings.count > 1 {
                        let bridgePairing1 = bridgePairings[0]
                        let bridgePairing2 = bridgePairings[1]
                        self.gotTwoBridgePairings(bridgePairing1: bridgePairing1, bridgePairing2: bridgePairing2, user: user, noMoreBridgePairings: noMoreBridgePairings, completion: completion)
                    } else if bridgePairings.count > 0 {
                        let bridgePairing = bridgePairings[0]
                        self.gotBottomBridgePairing(bridgePairing: bridgePairing, user: user, noMoreBridgePairings: noMoreBridgePairings, completion: completion)
                    } else {
                        self.gotNoBridgePairings(noMoreBridgePairings: noMoreBridgePairings, completion: completion)
                    }
                }
            }
        }
    }
    
    private func getReserveBridgePairing(noMoreBridgePairings: (() -> Void)?, completion: (() -> Void)? = nil) {
        User.getCurrent { (user) in
            if let user = user {
                BridgePairing.getAllWithFriends(ofUser: user, notShownOnly: true, withLimit: 1, notCheckedOutOnly: true, exceptForBlocked: true) { (bridgePairings) in
                    if bridgePairings.count > 0 {
                        let bridgePairing = bridgePairings[0]
                        self.gotReserveBridgePairing(bridgePairing: bridgePairing, user: user, noMoreBridgePairings: noMoreBridgePairings, completion: completion)
                    } else {
                        self.gotNoBridgePairings(noMoreBridgePairings: noMoreBridgePairings, completion: completion)
                    }
                }
            }
        }
    }
    
    private func gotTopBridgePairing(bridgePairing: BridgePairing, user: User, noMoreBridgePairings: (() -> Void)?, completion: (() -> Void)?) {
        print("got one bridge pairing from parse")
        
        if let id = bridgePairing.id {
            print("top bridgePairing id: \(id)")
        }
        
        if let userID = user.id {
            var shownTo: [String]
            if let bridgePairingShownTo = bridgePairing.shownTo {
                shownTo = bridgePairingShownTo
                shownTo.append(userID)
            } else {
                shownTo = [userID]
            }
            bridgePairing.shownTo = shownTo
        }
        
        bridgePairing.getUser1 { (user1) in
            bridgePairing.getUser2 { (user2) in
                var usersExistAndHavePics = false
                if let user1 = user1 {
                    if let user2 = user2 {
                        if let user1PictureIDs = user1.pictureIDs {
                            if user1PictureIDs.count > 0 { // user1 pic exists
                                if let user2PictureIDs = user2.pictureIDs {
                                    if user2PictureIDs.count > 0 { // user2 pic exists
                                        usersExistAndHavePics = true
                                        
                                        bridgePairing.checkedOut = true
                                        
                                        self.topSwipeCard.alpha = 1
                                        self.topSwipeCard.isUserInteractionEnabled = true
                                        
                                        self.gotTopBridgePairing = true
                                        self.topBridgePairing = bridgePairing
                                        
                                        // store bridge pairing locally
                                        self.localBridgePairings.setBridgePairing1ID(bridgePairing.id)
                                        self.localBridgePairings.synchronize()
                                        
                                        self.topSwipeCard.initialize(bridgePairing: bridgePairing)
                                        
                                        bridgePairing.save { (_) in
                                            if let completion = completion {
                                                completion()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if !usersExistAndHavePics {
                    bridgePairing.save { (_) in
                        self.getTopBridgePairing(noMoreBridgePairings: noMoreBridgePairings, completion: completion)
                    }
                }
            }
        }
    }
    
    private func gotTwoBridgePairings(bridgePairing1: BridgePairing, bridgePairing2: BridgePairing, user: User, noMoreBridgePairings: (() -> Void)?, completion: (() -> Void)?) {
        print("got two bridge pairings from parse")
        
        if let id = bridgePairing1.id {
            print("bottom bridgePairing id: \(id)")
        }
        
        if let id = bridgePairing2.id {
            print("reserve bridgePairing id: \(id)")
        }
        
        if let userID = user.id {
            var shownTo1: [String]
            if let bridgePairingShownTo1 = bridgePairing1.shownTo {
                shownTo1 = bridgePairingShownTo1
                shownTo1.append(userID)
            } else {
                shownTo1 = [userID]
            }
            bridgePairing1.shownTo = shownTo1
        }
        
        bridgePairing1.save { (_) in
            bridgePairing1.getUser1 { (user1) in
                bridgePairing1.getUser2 { (user2) in
                    var bridgePairing1UsersExistAndHavePics = false
                    if let user1 = user1 {
                        if let user2 = user2 {
                            if let user1PictureIDs = user1.pictureIDs {
                                if user1PictureIDs.count > 0 { // user1 pic exists
                                    if let user2PictureIDs = user2.pictureIDs {
                                        if user2PictureIDs.count > 0 { // user2 pic exists
                                            bridgePairing1UsersExistAndHavePics = true
                                            
                                            bridgePairing1.checkedOut = true
                                            
                                            self.bottomSwipeCard.alpha = 1
                                            self.bottomSwipeCard.isUserInteractionEnabled = true
                                            
                                            self.gotBottomBridgePairing = true
                                            self.bottomBridgePairing = bridgePairing1
                                                
                                            // store bridge pairing locally
                                            self.localBridgePairings.setBridgePairing2ID(bridgePairing1.id)
                                            self.localBridgePairings.synchronize()
                                            
                                            self.bottomSwipeCard.initialize(bridgePairing: bridgePairing1)
                                            
                                            bridgePairing1.save { (_) in
                                                
                                                if let userID = user.id {
                                                    var shownTo2: [String]
                                                    if let bridgePairingShownTo2 = bridgePairing2.shownTo {
                                                        shownTo2 = bridgePairingShownTo2
                                                        shownTo2.append(userID)
                                                    } else {
                                                        shownTo2 = [userID]
                                                    }
                                                    bridgePairing2.shownTo = shownTo2
                                                }
                                                
                                                bridgePairing2.save { (_) in
                                                    bridgePairing2.getUser1 { (user1) in
                                                        bridgePairing2.getUser2 { (user2) in
                                                            var bridgePairing2UsersExistAndHavePics = false
                                                            if let user1 = user1 {
                                                                if let user2 = user2 {
                                                                    if let user1PictureIDs = user1.pictureIDs {
                                                                        if user1PictureIDs.count > 0 { // user1 pic exists
                                                                            if let user2PictureIDs = user2.pictureIDs {
                                                                                if user2PictureIDs.count > 0 { // user2 pic exists
                                                                                    bridgePairing2UsersExistAndHavePics = true
                                                                                    
                                                                                    bridgePairing2.checkedOut = true
                                                                                    
                                                                                    self.reserveBridgePairing = bridgePairing2
                                                                                    
                                                                                    bridgePairing2.save { (_) in
                                                                                        if let completion = completion {
                                                                                            completion()
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                            if !bridgePairing2UsersExistAndHavePics {
                                                                self.getReserveBridgePairing(noMoreBridgePairings: noMoreBridgePairings, completion: completion)
                                                            }
                                                        }
                                                    }
                                                    
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if !bridgePairing1UsersExistAndHavePics {
                        self.getTwoBridgePairings(noMoreBridgePairings: noMoreBridgePairings, completion: completion)
                    }
                }
            }
        }
    }
    
    private func gotBottomBridgePairing(bridgePairing: BridgePairing, user: User, noMoreBridgePairings: (() -> Void)?, completion: (() -> Void)?) {
        print("got one bridge pairing from parse")
        
        if let id = bridgePairing.id {
            print("bottom bridgePairing id: \(id)")
        }
        
        if let userID = user.id {
            var shownTo: [String]
            if let bridgePairingShownTo = bridgePairing.shownTo {
                shownTo = bridgePairingShownTo
                shownTo.append(userID)
            } else {
                shownTo = [userID]
            }
            bridgePairing.shownTo = shownTo
        }
        
        bridgePairing.getUser1 { (user1) in
            bridgePairing.getUser2 { (user2) in
                var usersExistAndHavePics = false
                if let user1 = user1 {
                    if let user2 = user2 {
                        if let user1PictureIDs = user1.pictureIDs {
                            if user1PictureIDs.count > 0 { // user1 pic exists
                                if let user2PictureIDs = user2.pictureIDs {
                                    if user2PictureIDs.count > 0 { // user2 pic exists
                                        usersExistAndHavePics = true
                                        
                                        bridgePairing.checkedOut = true
                                        
                                        self.bottomSwipeCard.alpha = 1
                                        self.bottomSwipeCard.isUserInteractionEnabled = true
                                        
                                        self.gotBottomBridgePairing = true
                                        self.bottomBridgePairing = bridgePairing
                                        
                                        // store bridge pairing locally
                                        self.localBridgePairings.setBridgePairing2ID(bridgePairing.id)
                                        self.localBridgePairings.synchronize()
                                        
                                        self.bottomSwipeCard.initialize(bridgePairing: bridgePairing)
                                        
                                        self.reserveBridgePairing = nil
                                        
                                        bridgePairing.save { (_) in
                                            if let completion = completion {
                                                completion()
                                            }
                                            
                                            if let noMoreBridgePairings = noMoreBridgePairings {
                                                noMoreBridgePairings()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if !usersExistAndHavePics {
                    bridgePairing.save { (_) in
                        self.gotNoBridgePairings(noMoreBridgePairings: noMoreBridgePairings, completion: completion)
                    }
                }
            }
        }
    }
    
    private func gotReserveBridgePairing(bridgePairing: BridgePairing, user: User, noMoreBridgePairings: (() -> Void)?, completion: (() -> Void)?) {
        print("got one bridge pairing from parse")
        
        if let id = bridgePairing.id {
            print("reserve bridgePairing id: \(id)")
        }
        
        if let userID = user.id {
            var shownTo: [String]
            if let bridgePairingShownTo = bridgePairing.shownTo {
                shownTo = bridgePairingShownTo
                shownTo.append(userID)
            } else {
                shownTo = [userID]
            }
            bridgePairing.shownTo = shownTo
        }
        
        bridgePairing.getUser1 { (user1) in
            bridgePairing.getUser2 { (user2) in
                var usersExistAndHavePics = false
                if let user1 = user1 {
                    if let user2 = user2 {
                        if let user1PictureIDs = user1.pictureIDs {
                            if user1PictureIDs.count > 0 { // user1 pic exists
                                if let user2PictureIDs = user2.pictureIDs {
                                    if user2PictureIDs.count > 0 { // user2 pic exists  
                                        usersExistAndHavePics = true
                                        
                                        bridgePairing.checkedOut = true
                                        
                                        self.reserveBridgePairing = bridgePairing
                                        
                                        bridgePairing.save { (_) in
                                            if let completion = completion {
                                                completion()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if !usersExistAndHavePics {
                    bridgePairing.save { (_) in
                        self.getReserveBridgePairing(noMoreBridgePairings: noMoreBridgePairings, completion: completion)
                    }
                }
            }
        }
    }
    
    private func gotNoBridgePairings(noMoreBridgePairings: (() -> Void)?, completion: (() -> Void)?) {
        print("got no bridge pairings from parse")
        
        self.gotBottomBridgePairing = true
        
        self.bottomBridgePairing = nil
        self.localBridgePairings.setBridgePairing2ID(nil)
        self.localBridgePairings.synchronize()
        
        self.reserveBridgePairing = nil
        
        if let completion = completion {
            completion()
        }
        
        if let noMoreBridgePairings = noMoreBridgePairings {
            noMoreBridgePairings()
        }
    }
    
    
    // user just swiped, get two new cards every other swipe
    func updateAfterSwipe(topSwipeCard: SwipeCard, bottomSwipeCard: SwipeCard, noMoreBridgePairings: (() -> Void)?, completion: (() -> Void)? = nil) {
        print("\nupdate after swipe, download: \(downloadOnSwipe)")
        self.topSwipeCard = topSwipeCard
        self.bottomSwipeCard = bottomSwipeCard
        
        bottomSwipeCard.alpha = 0
        bottomSwipeCard.isUserInteractionEnabled = false
        bottomSwipeCard.clear()
        
        topBridgePairing = bottomBridgePairing
        bottomBridgePairing = reserveBridgePairing
        reserveBridgePairing = nil
        
        // store bridge pairings locally
        if let topBridgePairing = topBridgePairing {
            localBridgePairings.setBridgePairing1ID(topBridgePairing.id)
            
            topSwipeCard.alpha = 1
            topSwipeCard.isUserInteractionEnabled = true
        } else {
            localBridgePairings.setBridgePairing1ID(nil)
        }
        
        if let bottomBridgePairing = bottomBridgePairing {
            localBridgePairings.setBridgePairing2ID(bottomBridgePairing.id)
            
            bottomSwipeCard.alpha = 1
            bottomSwipeCard.isUserInteractionEnabled = true
        } else {
            localBridgePairings.setBridgePairing2ID(nil)
        }
        
        localBridgePairings.synchronize()
        
        if downloadOnSwipe {
            downloadOnSwipe = false
            gotBottomBridgePairing = false
            getTwoBridgePairings(noMoreBridgePairings: noMoreBridgePairings, completion: completion)
        } else {
            downloadOnSwipe = true
            if let bottomBridgePairing = bottomBridgePairing {
                bottomSwipeCard.initialize(bridgePairing: bottomBridgePairing)
            }
        }
    }
    
    func getInitialBridgePairings(topSwipeCard: SwipeCard, bottomSwipeCard: SwipeCard, noMoreBridgePairings: (() -> Void)?, completion: (() -> Void)? = nil) {
        print("\ngetting initial bridge pairings")
        
        self.topSwipeCard = topSwipeCard
        self.bottomSwipeCard = bottomSwipeCard
        
        downloadOnSwipe = false
        
        if let topBridgePairingID = localBridgePairings.getBridgePairing1ID() {
            print("got top locally with id: \(topBridgePairingID)")
            BridgePairing.get(withID: topBridgePairingID) { (topBridgePairing) in
                self.topSwipeCard.alpha = 1
                self.topSwipeCard.isUserInteractionEnabled = true
                
                self.topBridgePairing = topBridgePairing
                self.gotTopBridgePairing = true
                
                self.topSwipeCard.initialize(bridgePairing: topBridgePairing)
                
                if let bottomBridgePairingID = self.localBridgePairings.getBridgePairing2ID() {
                    print("got bottom locally with id: \(bottomBridgePairingID)")
                    BridgePairing.get(withID: bottomBridgePairingID) { (bottomBridgePairing) in
                        self.bottomSwipeCard.alpha = 1
                        self.bottomSwipeCard.isUserInteractionEnabled = true
                        
                        self.bottomBridgePairing = bottomBridgePairing
                        self.gotBottomBridgePairing = true
                        
                        self.bottomSwipeCard.initialize(bridgePairing: bottomBridgePairing)
                        
                        if let completion = completion {
                            completion()
                        }
                    }
                } else {
                    print("bottom not stored locally")
                    self.getTwoBridgePairings(noMoreBridgePairings: noMoreBridgePairings, completion: completion)
                }
            }
        } else {
            print("top and bottom not stored locally")
            getTopBridgePairing(noMoreBridgePairings: noMoreBridgePairings) {
                self.getTwoBridgePairings(noMoreBridgePairings: noMoreBridgePairings, completion: completion)
            }
        }
    }
    
    func checkIn(bridgePairing: BridgePairing) {
        bridgePairing.checkedOut = false
        bridgePairing.save()
    }
    
    func getCurrentUserUnviewedMatches(withBlock block: @escaping BridgePairing.BridgePairingsBlock) {
        User.getCurrent { (user) in
            if let user = user {
                BridgePairing.getAll(withUser: user, bridgedOnly: true, whereUserHasNotViewedNotificationOnly: true) { (bridgePairings) in
                    block(bridgePairings)
                }
            }
        }
    }
}
