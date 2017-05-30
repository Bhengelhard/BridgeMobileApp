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
    
    var topBridgePairing: BridgePairing?
    var bottomBridgePairing: BridgePairing?
    var bridgePairingDict = [String: BridgePairing]()
    var bridgePairingIDs = [String]()
    let localBridgePairings = LocalBridgePairings()
    var gotTopBridgePairing = false
    var gotBottomBridgePairing = false
    
    
    private func gotNoBridgePairings(user: User, swipeCard: SwipeCard, top: Bool, limitMet: (() -> Void)?, noMoreBridgePairings: (() -> Void)?, noBridgePairings: (() -> Void)?, completion: (() -> Void)?) {
        
        //swipeCard.alpha = 0
        
        if let limitPairsCount = user.limitPairsCount {
            if limitPairsCount <= 0 {
                if let limitMet = limitMet {
                    limitMet()
                }
            } else if limitPairsCount < Constants.cardLimit {
                if let noMoreBridgePairings = noMoreBridgePairings {
                    noMoreBridgePairings()
                }
            } else {
                if let noBridgePairings = noBridgePairings {
                    noBridgePairings()
                }
            }
        } else if let noMoreBridgePairings = noMoreBridgePairings {
            noMoreBridgePairings()
        }
    }
    
    private func populateBridgePairingDictWithIDs(bridgePairingIDs: [String], startingAt index: Int, completion: (() -> Void)?) {
        if index >= bridgePairingIDs.count {
            if let completion = completion {
                completion()
            }
        } else {
            let bridgePairingID = bridgePairingIDs[index]
            BridgePairing.get(withID: bridgePairingID) { (bridgePairing) in
                self.bridgePairingDict[bridgePairingID] = bridgePairing
                self.populateBridgePairingDictWithIDs(bridgePairingIDs: bridgePairingIDs, startingAt: index+1, completion: completion)
            }
        }
    }
    
    func getBridgePairings(topSwipeCard: SwipeCard, bottomSwipeCard: SwipeCard, limitMet: (() -> Void)?, noMoreBridgePairings: (() -> Void)?, noBridgePairings: (() -> Void)?, completion: (() -> Void)? = nil) {
        
        topBridgePairing = nil
        bottomBridgePairing = nil
        
        // get locally stored bridge pairing ids
        if let bridgePairingIDs = localBridgePairings.getBridgePairingIDs() {
            self.bridgePairingIDs = bridgePairingIDs
        }
        
        // retrieve and save bridge pairings
        populateBridgePairingDictWithIDs(bridgePairingIDs: bridgePairingIDs, startingAt: 0) {
        
            // get remainder of bridge pairings
            User.getCurrent { (user) in
                if let user = user {
                    if let limitPairsCount = user.limitPairsCount {
                        if limitPairsCount > 0 {
                            BridgePairing.getAllWithFriends(ofUser: user, notShownOnly: true, withLimit: limitPairsCount, notCheckedOutOnly: true, exceptForBlocked: true) { (bridgePairings) in
                                
                                for bridgePairing in bridgePairings {
                                    if let id = bridgePairing.id {
                                        self.bridgePairingIDs.append(id)
                                        self.bridgePairingDict[id] = bridgePairing
                                        
                                        if let userID = user.id {
                                            var shownTo: [String]
                                            if let bridgePairingShownTo = bridgePairing.shownTo {
                                                shownTo = bridgePairingShownTo
                                                shownTo.append(userID)
                                            } else {
                                                shownTo = [userID]
                                            }
                                            bridgePairing.shownTo = shownTo
                                            bridgePairing.save()
                                        }
                                    }
                                }
                                
                                // store locally
                                self.localBridgePairings.setBridgePairingIDs(self.bridgePairingIDs)
                                self.localBridgePairings.synchronize()

                                user.limitPairsCount = limitPairsCount - bridgePairings.count
                                user.save { (_) in
                                    
                                    if self.bridgePairingIDs.count == 0 { // no pairings
                                        self.gotNoBridgePairings(user: user, swipeCard: bottomSwipeCard, top: true, limitMet: limitMet, noMoreBridgePairings: noMoreBridgePairings, noBridgePairings: noBridgePairings, completion: completion)
                                    } else { // at least one pairing
                                        topSwipeCard.alpha = 1
                                        topSwipeCard.isUserInteractionEnabled = true
                                        if let bridgePairing = self.bridgePairingDict[self.bridgePairingIDs[0]] {
                                            topSwipeCard.initialize(bridgePairing: bridgePairing)
                                            self.topBridgePairing = bridgePairing
                                        }
                                        
                                        if self.bridgePairingIDs.count == 1 { // exactly one pairing
                                            self.gotNoBridgePairings(user: user, swipeCard: bottomSwipeCard, top: true, limitMet: limitMet, noMoreBridgePairings: noMoreBridgePairings, noBridgePairings: noBridgePairings, completion: completion)
                                        } else { // more than one pairing
                                            bottomSwipeCard.alpha = 1
                                            if let bridgePairing = self.bridgePairingDict[self.bridgePairingIDs[1]] {
                                                bottomSwipeCard.initialize(bridgePairing: bridgePairing)
                                                self.bottomBridgePairing = bridgePairing
                                            }
                                            
                                            if let completion = completion {
                                                completion()
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            if self.bridgePairingIDs.count == 0 { // no pairings
                                self.gotNoBridgePairings(user: user, swipeCard: bottomSwipeCard, top: true, limitMet: limitMet, noMoreBridgePairings: noMoreBridgePairings, noBridgePairings: noBridgePairings, completion: completion)
                            } else {
                                topSwipeCard.alpha = 1
                                topSwipeCard.isUserInteractionEnabled = true
                                if let bridgePairing = self.bridgePairingDict[self.bridgePairingIDs[0]] {
                                    topSwipeCard.initialize(bridgePairing: bridgePairing)
                                    self.topBridgePairing = bridgePairing
                                }
                                
                                if self.bridgePairingIDs.count == 1 { // one pairing
                                    self.gotNoBridgePairings(user: user, swipeCard: bottomSwipeCard, top: true, limitMet: limitMet, noMoreBridgePairings: noMoreBridgePairings, noBridgePairings: noBridgePairings, completion: completion)
                                } else { // more than one pairing
                                    bottomSwipeCard.alpha = 1
                                    if let bridgePairing = self.bridgePairingDict[self.bridgePairingIDs[1]] {
                                        bottomSwipeCard.initialize(bridgePairing: bridgePairing)
                                        self.bottomBridgePairing = bridgePairing
                                    }
                                    
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
    }
    
    func swiped(topSwipepCard: SwipeCard, bottomSwipeCard: SwipeCard, limitMet: (() -> Void)?, noMoreBridgePairings: (() -> Void)?, noBridgePairings: (() -> Void)?, completion: (() -> Void)? = nil) {
        bottomSwipeCard.alpha = 0
        bottomSwipeCard.isUserInteractionEnabled = false
        bottomSwipeCard.clear()
        bottomBridgePairing = nil
        
        if bridgePairingIDs.count > 0 {
            let bridgePairingID = bridgePairingIDs[0]
            bridgePairingDict.removeValue(forKey: bridgePairingID)
            bridgePairingIDs.remove(at: 0)
            
            localBridgePairings.setBridgePairingIDs(bridgePairingIDs)
            localBridgePairings.synchronize()
            
            if bridgePairingIDs.count > 0 {
                topSwipepCard.isUserInteractionEnabled = true
                
                if bridgePairingIDs.count > 1 {
                    let newBridgePairingID = bridgePairingIDs[1]
                    if let newBridgePairing = bridgePairingDict[newBridgePairingID] {
                        bottomSwipeCard.alpha = 1
                        bottomSwipeCard.initialize(bridgePairing: newBridgePairing)
                        bottomBridgePairing = newBridgePairing
                    }
                } else {
                    User.getCurrent { (user) in
                        if let user = user {
                            self.gotNoBridgePairings(user: user, swipeCard: bottomSwipeCard, top: true, limitMet: limitMet, noMoreBridgePairings: noMoreBridgePairings, noBridgePairings: noBridgePairings, completion: completion)
                        }
                    }
                }
            } else {
                User.getCurrent { (user) in
                    if let user = user {
                        self.gotNoBridgePairings(user: user, swipeCard: bottomSwipeCard, top: true, limitMet: limitMet, noMoreBridgePairings: noMoreBridgePairings, noBridgePairings: noBridgePairings, completion: completion)
                    }
                }
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
