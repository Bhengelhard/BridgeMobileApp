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
    var topSwipeCard: SwipeCard?
    var bottomSwipeCard: SwipeCard?
    
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
            var longitude :CLLocationDegrees = -122.0312186
            var latitude :CLLocationDegrees = 37.33233141
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
    
    func getBridgePairing(forCard swipeCard: SwipeCard) {
        
        User.getCurrent { (user) in
            BridgePairing.getAllWithFriends(ofUser: user, withLimit: 1) { (bridgePairings) in
                for bridgePairing in bridgePairings {
                    var user1:PairInfo? = nil
                    var user2:PairInfo? = nil
                    
                    let name1 = bridgePairing.user1Name
                    let name2 = bridgePairing.user2Name
                    let userId1 = bridgePairing.user1ID
                    let userId2 = bridgePairing.user2ID
                    
                    let location1:[Double]? = nil
                    let location2:[Double]? = nil
                    let bridgeStatus1:String? = nil
                    let bridgeStatus2:String? = nil
                    let city1:String? = nil
                    let city2:String? = nil
                    let bridgeType1:String? = nil
                    let bridgeType2:String? = nil
                    
                    let objectId1 = bridgePairing.id
                    let objectId2 = bridgePairing.id
                    
//                    result["checked_out"]  = true
//                    if let _ = result["shown_to"] {
//                        if var ar = result["shown_to"] as? [String] {
//                            let s = (PFUser.current()?.objectId)! as String
//                            ar.append(s)
//                            result["shown_to"] = ar
//                        }
//                        else {
//                            result["shown_to"] = [(PFUser.current()?.objectId)!]
//                        }
//                    }
//                    else {
//                        result["shown_to"] = [(PFUser.current()?.objectId)!]
//                    }
                    let profilePictureFile1:String? = nil
                    let profilePictureFile2:String? = nil
//                    if let ob = result["user1_profile_picture_url"] as? String {
//                        profilePictureFile1 = ob
//                    }
//                    if let ob = result["user2_profile_picture_url"] as? String {
//                        profilePictureFile2 = ob
//                    }
                    bridgePairing.save()
                    user1 = PairInfo(name:name1, mainProfilePicture: profilePictureFile1, profilePictures: nil,location: location1, bridgeStatus: bridgeStatus1, objectId: objectId1,  bridgeType: bridgeType1, userId: userId1, city: city1, savedProfilePicture: nil)
                    user2 = PairInfo(name:name2, mainProfilePicture: profilePictureFile2, profilePictures: nil,location: location2, bridgeStatus: bridgeStatus2, objectId: objectId2,  bridgeType: bridgeType2, userId: userId2, city: city2, savedProfilePicture: nil)
                    let userInfoPair = UserInfoPair(user1: user1, user2: user2)
                    
                    let localData = LocalData()
                    localData.addPair(userInfoPair)
                    localData.synchronize()
                    
                    DispatchQueue.main.async(execute: {
                        
                        let aboveView = self.addCardPairView(id: userId1,
                                                             name: name1,
                                                             location: city1,
                                                             status: bridgeStatus1,
                                                             photo: profilePictureFile1,
                                                             locationCoordinates1: location1,
                                                             id2: userId2,
                                                             name2: name2,
                                                             location2: city2,
                                                             status2: bridgeStatus2,
                                                             photo2: profilePictureFile2,
                                                             locationCoordinates2: location2,
                                                             pairing: userInfoPair)
                        
                        self.lastCardInStack = aboveView
                    })
                
                }
            }
        }
    }
    
    func addCardPairView (id: String?,
                          name: String?,
                          location: String?,
                          status: String?,
                          photo: String?,
                          locationCoordinates1: [Double]?,
                          id2: String?,
                          name2: String?,
                          location2: String?,
                          status2: String?,
                          photo2: String?,
                          locationCoordinates2: [Double]?,
                          pairing: UserInfoPair) -> UIView {
        let swipeCardView = SwipeCard()
        
        if bottomSwipeCard == nil {
            bottomSwipeCard = swipeCardView
        }
            
        swipeCardView.initialize(user1Id: id, user1PhotoURL: photo, user1Name: name!, user1Status: status!, user1City: location, user2Id: id2, user2PhotoURL: photo2, user2Name: name2!, user2Status: status2!, user2City: location2, connectionType: BridgeType.business.rawValue)
        
        return swipeCardView
    }
    
    func moveBottomSwipeCardToTop() -> UIView? {
        let oldTopSwipeCard = topSwipeCard
        topSwipeCard = bottomSwipeCard
        bottomSwipeCard = nil
        return oldTopSwipeCard
    }
}
