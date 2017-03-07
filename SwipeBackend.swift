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
    
    private func getNextBridgePairing(swipeCard: SwipeCard, top: Bool, completion: (() -> Void)? = nil) {
        if !top {
            self.topBridgePairing = self.bottomBridgePairing
        }
        User.getCurrent { (user) in
            BridgePairing.getAllWithFriends(ofUser: user, notShownOnly: true, withLimit: 1, notCheckedOutOnly: true) { (bridgePairings) in
                if bridgePairings.count > 0 {
                    let bridgePairing = bridgePairings[0]
                    
                    if top {
                        self.topBridgePairing = bridgePairing
                    } else {
                        self.bottomBridgePairing = bridgePairing
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
                    
                    bridgePairing.checkedOut = true
                    
                    var user1:PairInfo? = nil
                    var user2:PairInfo? = nil
                    
                    let name1 = bridgePairing.user1Name ?? ""
                    let name2 = bridgePairing.user2Name ?? ""
                    let userId1 = bridgePairing.user1ID ?? ""
                    let userId2 = bridgePairing.user2ID ?? ""
                    
                    let location1 = [Double]()
                    let location2 = [Double]()
                    let bridgeStatus1 = ""
                    let bridgeStatus2 = ""
                    let city1 = ""
                    let city2 = ""
                    let bridgeType1 = ""
                    let bridgeType2 = ""
                    
                    let objectId1 = bridgePairing.id ?? ""
                    let objectId2 = bridgePairing.id ?? ""
                    
                    let profilePictureFile1:String? = nil
                    let profilePictureFile2:String? = nil
                    // Change this to profile picture id or image
//                        if let ob = result["user1_profile_picture_url"] as? String {
//                            profilePictureFile1 = ob
//                        }
//                        if let ob = result["user2_profile_picture_url"] as? String {
//                            profilePictureFile2 = ob
//                        }
                    bridgePairing.save()
                    
                    user1 = PairInfo(name:name1, mainProfilePicture: profilePictureFile1, profilePictures: nil,location: location1, bridgeStatus: bridgeStatus1, objectId: objectId1,  bridgeType: bridgeType1, userId: userId1, city: city1, savedProfilePicture: nil)
                    user2 = PairInfo(name:name2, mainProfilePicture: profilePictureFile2, profilePictures: nil,location: location2, bridgeStatus: bridgeStatus2, objectId: objectId2,  bridgeType: bridgeType2, userId: userId2, city: city2, savedProfilePicture: nil)
                    let userInfoPair = UserInfoPair(user1: user1, user2: user2)
                    
                    let localData = LocalData()
                    localData.addPair(userInfoPair)
                    localData.synchronize()
                    
                    swipeCard.initialize(bridgePairing: bridgePairing)
                    if !top {
                        swipeCard.addOverlay()
                    }
                }
                if let completion = completion {
                    completion()
                }
            }
        }
    }
    
    /// initialize the bottom swipe card
    func setBottomSwipeCard(bottomSwipeCard: SwipeCard) {
        getNextBridgePairing(swipeCard: bottomSwipeCard, top: false)
    }
    
    func setTopSwipeCard(topSwipeCard: SwipeCard, completion: (() -> Void)? = nil) {
        getNextBridgePairing(swipeCard: topSwipeCard, top: true, completion: completion)
    }
    
    
    func checkIn() {
        if let topBridgePairing = topBridgePairing {
            topBridgePairing.checkedOut = false
            topBridgePairing.save()
        }
    }
}
