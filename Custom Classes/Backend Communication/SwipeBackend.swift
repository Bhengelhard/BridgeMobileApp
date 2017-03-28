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
    let localBridgePairings = LocalBridgePairings()
    
    func setCityName(locationLabel: UILabel, locationCoordinates:[Double], pairing:UserInfoPair) {
        // We will store the city names to LocalData.  Not required now. But will ne be needed in fututre when when optimize.
        if locationLabel.tag == 0 && pairing.user1?.city != nil {
            DispatchQueue.main.async(execute: {
                locationLabel.text = (pairing.user1?.city)!
            })
        }
        else if  locationLabel.tag == 1 && pairing.user2?.city != nil {
            DispatchQueue.main.async(execute: {
                locationLabel.text = (pairing.user2?.city)!
            })
        }
        else {
            var longitude: CLLocationDegrees = -122.0312186
            var latitude: CLLocationDegrees = 37.33233141
            if locationCoordinates.count == 2 {
                longitude = locationCoordinates[1]
                latitude = locationCoordinates[0]
            }
            
            let location = CLLocation(latitude: latitude, longitude: longitude) //changed!!!
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
                if error != nil {
                    print("Reverse geocoder failed with error" + error!.localizedDescription)
                    return
                }
                
                if placemarks!.count > 0 {
                    let pm = placemarks![0]
                    DispatchQueue.main.async(execute: {
                        locationLabel.text = pm.locality
                    })
                }
                else {
                    print("Problem with the data received from geocoder")
                }
            })
        }
    }
    
    private func getNextBridgePairing(swipeCard: SwipeCard, top: Bool, noMoreBridgePairings: @escaping () -> Void, completion: (() -> Void)? = nil) {
        User.getCurrent { (user) in
            if top {
                BridgePairing.getAllWithFriends(ofUser: user, notShownOnly: true, withLimit: 1, notCheckedOutOnly: true) { (bridgePairings) in
                    if bridgePairings.count > 0 {
                        let bridgePairing = bridgePairings[0]
                        self.gotBridgePairing(bridgePairing: bridgePairing, user: user, swipeCard: swipeCard, top: top, noMoreBridgePairings: noMoreBridgePairings, completion: completion)
                    } else {
                        self.gotNoBridgePairings(swipeCard: swipeCard, top: top, noMoreBridgePairings: noMoreBridgePairings, completion: completion)
                    }
                }
            } else {
                print("topBridgePairing is nil? \(self.topBridgePairing == nil)")
                if let topBridgePairing = self.topBridgePairing {
                    BridgePairing.getAllWithFriends(ofUser: user, notShownOnly: true, withLimit: 1, notCheckedOutOnly: true, exceptFriend1WithID: topBridgePairing.user1ID, exceptFriend2WithID: topBridgePairing.user2ID) { (bridgePairings) in
                        if bridgePairings.count > 0 {
                            let bridgePairing = bridgePairings[0]
                            self.gotBridgePairing(bridgePairing: bridgePairing, user: user, swipeCard: swipeCard, top: top, noMoreBridgePairings: noMoreBridgePairings, completion: completion)
                        } else {
                            BridgePairing.getAllWithFriends(ofUser: user, notShownOnly: true, withLimit: 1, notCheckedOutOnly: true) { (bridgePairings) in
                                if bridgePairings.count > 0 {
                                    let bridgePairing = bridgePairings[0]
                                    self.gotBridgePairing(bridgePairing: bridgePairing, user: user, swipeCard: swipeCard, top: top, noMoreBridgePairings: noMoreBridgePairings, completion: completion)
                                } else {
                                    self.gotNoBridgePairings(swipeCard: swipeCard, top: top, noMoreBridgePairings: noMoreBridgePairings, completion: completion)
                                }
                            }
                        }
                    }
                } else {
                    BridgePairing.getAllWithFriends(ofUser: user, notShownOnly: true, withLimit: 1, notCheckedOutOnly: true) { (bridgePairings) in
                        if bridgePairings.count > 0 {
                            let bridgePairing = bridgePairings[0]
                            self.gotBridgePairing(bridgePairing: bridgePairing, user: user, swipeCard: swipeCard, top: top, noMoreBridgePairings: noMoreBridgePairings, completion: completion)
                        } else {
                            self.gotNoBridgePairings(swipeCard: swipeCard, top: top, noMoreBridgePairings: noMoreBridgePairings, completion: completion)
                        }
                    }
                }
            }
        }
    }
    
    private func gotBridgePairing(bridgePairing: BridgePairing, user: User, swipeCard: SwipeCard, top: Bool, noMoreBridgePairings: @escaping () -> Void, completion: (() -> Void)?) {
        if top {
            print("got top from parse")
        } else {
            print("got bottom from parse")
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
            bridgePairing.save()
        }
        
        bridgePairing.getUser1 { (user1) in
            if let user1PictureIDs = user1.pictureIDs {
                if user1PictureIDs.count > 0 { // user1 pic exists
                    bridgePairing.getUser2 { (user2) in
                        if let user2PictureIDs = user2.pictureIDs {
                            if user2PictureIDs.count > 0 { // user2 pic exists
                                if top {
                                    self.topBridgePairing = bridgePairing
                                    
                                    // store bridge pairing locally
                                    self.localBridgePairings.setBridgePairing1ID(bridgePairing.id)
                                } else {
                                    self.bottomBridgePairing = bridgePairing
                                    
                                    // store bridge pairing locally
                                    self.localBridgePairings.setBridgePairing2ID(bridgePairing.id)
                                }
                                
                                self.localBridgePairings.synchronize()
                                
                                bridgePairing.checkedOut = true
                                
                                bridgePairing.save()
                                
                                swipeCard.alpha = 1
                                
                                swipeCard.initialize(bridgePairing: bridgePairing)
                                if !top {
                                    swipeCard.addOverlay()
                                }
                                if let completion = completion {
                                    completion()
                                }
                            } else {
                                self.getNextBridgePairing(swipeCard: swipeCard, top: top, noMoreBridgePairings: noMoreBridgePairings, completion: completion)
                            }
                        } else {
                            self.getNextBridgePairing(swipeCard: swipeCard, top: top, noMoreBridgePairings: noMoreBridgePairings, completion: completion)
                        }
                    }
                } else {
                    self.getNextBridgePairing(swipeCard: swipeCard, top: top, noMoreBridgePairings: noMoreBridgePairings, completion: completion)
                }
            } else {
                self.getNextBridgePairing(swipeCard: swipeCard, top: top, noMoreBridgePairings: noMoreBridgePairings, completion: completion)
            }
        }
    }
    
    private func gotNoBridgePairings(swipeCard: SwipeCard, top: Bool, noMoreBridgePairings: @escaping () -> Void, completion: (() -> Void)?) {
        swipeCard.alpha = 0
        
        noMoreBridgePairings()
        
        if top {
            print("did not get top from parse")
        } else {
            print("did not get bottom from parse")
        }
        
        if top {
            self.topBridgePairing = nil
            
            // store bridge pairing locally
            self.localBridgePairings.setBridgePairing1ID(nil)
            
            // bottom should always be nil if top is
            self.localBridgePairings.setBridgePairing2ID(nil)
        } else {
            self.bottomBridgePairing = nil
            
            // store bridge pairing locally
            self.localBridgePairings.setBridgePairing2ID(nil)
        }
        
        self.localBridgePairings.synchronize()
        
        if let completion = completion {
            completion()
        }
    }
    
    /// set the bottom swipe card
    func setBottomSwipeCard(bottomSwipeCard: SwipeCard, noMoreBridgePairings: @escaping () -> Void) {
        
        // store old bottom as top locally
        topBridgePairing = bottomBridgePairing
        // store bridge pairing locally
        if let bridgePairing = topBridgePairing {
            localBridgePairings.setBridgePairing1ID(bridgePairing.id)
        } else {
            localBridgePairings.setBridgePairing1ID(nil)
            
            // bottom should always be nil if top is
            localBridgePairings.setBridgePairing2ID(nil)
        }
        localBridgePairings.synchronize()
        
        getNextBridgePairing(swipeCard: bottomSwipeCard, top: false, noMoreBridgePairings: noMoreBridgePairings)
    }
    
    /// set the top swipe card upon opening app
    func setInitialTopSwipeCard(topSwipeCard: SwipeCard, noMoreBridgePairings: @escaping () -> Void, completion: (() -> Void)? = nil) {
        if let bridgePairingID = localBridgePairings.getBridgePairing1ID() { // bridge pairing ID stored locally
            print("got top locally")
            BridgePairing.get(withID: bridgePairingID) { (bridgePairing) in
                self.topBridgePairing = bridgePairing
                topSwipeCard.initialize(bridgePairing: bridgePairing)
                if let completion = completion {
                    completion()
                }
            }
        } else {
            print("top not stored locally")
            getNextBridgePairing(swipeCard: topSwipeCard, top: true, noMoreBridgePairings: noMoreBridgePairings, completion: completion)
        }
    }
    
    /// set the bottom swipe card upon opening app
    func setInitialBottomSwipeCard(bottomSwipeCard: SwipeCard, noMoreBridgePairings: @escaping () -> Void) {
        if let bridgePairingID = localBridgePairings.getBridgePairing2ID() { // bridge pairing ID stored locally
            print("got bottom locally")
            BridgePairing.get(withID: bridgePairingID) { (bridgePairing) in
                self.bottomBridgePairing = bridgePairing
                bottomSwipeCard.initialize(bridgePairing: bridgePairing)
            }
        } else {
            print("bottom not stored locally")
            getNextBridgePairing(swipeCard: bottomSwipeCard, top: false, noMoreBridgePairings: noMoreBridgePairings)
        }
    }
    
    func checkIn() {
        print("checking in top card")
        if let topBridgePairing = topBridgePairing {
            topBridgePairing.checkedOut = false
            topBridgePairing.save()
        }
    }
}