//
//  ViewController.swift
//  play
//
//  Created by Sagar Sinha on 7/5/16.
//  Copyright © 2016 SagarSinha. All rights reserved.
//

import UIKit
import Parse
import MapKit
class BridgeViewController: UIViewController {
    var bridgePairings:[UserInfoPair]? = nil
    var lowerDeckCards = [UIView?](count: 5, repeatedValue: nil)
    var upperDeckCards = [UIView?](count: 5, repeatedValue: nil)
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    let cardWidth = UIScreen.mainScreen().bounds.width*0.8
    let cardHeight = UIScreen.mainScreen().bounds.height*0.30
    var nameSet = ["Peter", "Jackson", "Johnny", "Bravo", "Dezz"]
    var nameSet2 = ["Peter", "Jackson", "Johnny", "Bravo", "Dezz"]
    var locationSet = ["Moscow", "Brlin", "Paris", "Mumbai", "Tel Aviv"]
    var locationSet2 = ["Moscow", "Brlin", "Paris", "Mumbai", "Tel Aviv"]
    var statusSet = ["Business","Love","Friendship","Business", "Love"]
    var statusSet2 = ["Business","Love","Friendship","Business", "Love"]
    var photoSet = [NSData]()
    var photoSet2 = [NSData]()
    var totalNoOfCards = 0
    var nextCardToShow = 0
    var noOfCardsThrown = 0
    let localStorageUtility = LocalStorageUtility()
    var colorSet = [ UIColor.init(red: 144.0/255, green: 207.0/255, blue: 214.0/255, alpha: 1.0), UIColor.init(red: 255.0/255, green: 129.0/255, blue: 125.0/255, alpha: 1.0), UIColor(red: 139.0/255, green: 217.0/255, blue: 176.0/255, alpha: 1.0), UIColor.init(red: 144.0/255, green: 207.0/255, blue: 214.0/255, alpha: 1.0)]
    let colorSetMaster = [ UIColor.init(red: 144.0/255, green: 207.0/255, blue: 214.0/255, alpha: 1.0), UIColor.init(red: 255.0/255, green: 129.0/255, blue: 125.0/255, alpha: 1.0), UIColor(red: 139.0/255, green: 217.0/255, blue: 176.0/255, alpha: 1.0), UIColor.init(red: 144.0/255, green: 207.0/255, blue: 214.0/255, alpha: 1.0), UIColor.init(red: 144.0/255, green: 207.0/255, blue: 214.0/255, alpha: 1.0), UIColor.init(red: 255.0/255, green: 129.0/255, blue: 125.0/255, alpha: 1.0), UIColor(red: 139.0/255, green: 217.0/255, blue: 176.0/255, alpha: 1.0), UIColor.init(red: 144.0/255, green: 207.0/255, blue: 214.0/255, alpha: 1.0), UIColor.init(red: 144.0/255, green: 207.0/255, blue: 214.0/255, alpha: 1.0), UIColor.init(red: 255.0/255, green: 129.0/255, blue: 125.0/255, alpha: 1.0), UIColor(red: 139.0/255, green: 217.0/255, blue: 176.0/255, alpha: 1.0), UIColor.init(red: 144.0/255, green: 207.0/255, blue: 214.0/255, alpha: 1.0)]
    var nextPairButton:UIButton? = nil
    var bridgeButton:UIButton? = nil
    var minimumCards = 4
    
    
    func downloadMoreCards() {
        var count = 0
        let c = self.bridgePairings?.count
        if let c = c {
            if c > 0 {
                count = c 
            }
        }
        localStorageUtility.getBridgePairingsFromCloud()
        bridgePairings = LocalData().getPairings()
        
        if let bridgePairings = bridgePairings {
        print("bridgePairings.count - \(bridgePairings.count)")
        totalNoOfCards += bridgePairings.count - c!
        for i in count ..< (bridgePairings.count) {
        let pairing = bridgePairings[i]
        if let name = pairing.user1?.name {
            print(name)
            nameSet.append(name)
        }
        else {
            nameSet.append("Man has no name")
        }
        if let name = pairing.user2?.name {
            print(name)
            nameSet2.append(name)
        }
        else {
            nameSet2.append("Man has no name")
        }
        if let location_values = pairing.user1?.location {
            locationSet.append("Location has no name")
            
            
        }
        else {
            locationSet.append("Location has no name")
        }
        if let location_values = pairing.user2?.location {
            locationSet2.append("Location has no name")
            
            
        }
        else {
            locationSet2.append("Location has no name")
        }
        
        if let bridgeStatus = pairing.user1?.bridgeStatus {
            statusSet.append(bridgeStatus)
        }
        else {
            statusSet.append("Nah")
        }
        if let bridgeStatus = pairing.user2?.bridgeStatus {
            statusSet2.append(bridgeStatus)
        }
        else {
            statusSet2.append("Nah")
        }
        if let mainProfilePicture = pairing.user1?.mainProfilePicture {
            photoSet.append(mainProfilePicture)
        }
        else {
            let mainProfilePicture = UIImagePNGRepresentation(UIImage(named: "bridgeVector.jpg")!)!
            photoSet.append(mainProfilePicture)
        }
        if let mainProfilePicture = pairing.user2?.mainProfilePicture {
            photoSet2.append(mainProfilePicture)
        }
        else {
            let mainProfilePicture = UIImagePNGRepresentation(UIImage(named: "bridgeVector.jpg")!)!
            photoSet2.append(mainProfilePicture)
        }
        
        
        colorSet.append(colorSetMaster[i])
        }
        }

    }
    func bridgeButtonTapped(sender: UIButton!) {
        bridgeButton?.userInteractionEnabled = false
        nextPairButton?.userInteractionEnabled = false
        var upperDeckCard = UIView()
        var lowerDeckCard = UIView()
        
        // add a new Card to the deck if one exists
        if noOfCardsThrown < totalNoOfCards {
            if var bridgePairings = bridgePairings {
                let objectId = bridgePairings[0].user1?.objectId
                let query = PFQuery(className:"BridgePairings")
                query.getObjectInBackgroundWithId(objectId!, block: { (result, error) -> Void in
                    if let result = result {
                        result["checked_out"] = true
                        result.saveInBackground()
                    }
                    
                })
                self.bridgePairings!.removeAtIndex(0)
                print("bridgePairings.count - \(bridgePairings.count)")
                let localData = LocalData()
                localData.setPairings(self.bridgePairings!)
                localData.synchronize()
                downloadMoreCards()
            }
        }
        
        if nextCardToShow < totalNoOfCards {
            let nameFrame = CGRectMake(0.05*cardWidth,0.10*cardHeight,0.55*cardWidth,0.20*cardHeight)
            let locationFrame = CGRectMake(0.60*cardWidth,0.10*cardHeight,0.40*cardWidth,0.20*cardHeight)
            let statusFrame = CGRectMake(0.05*cardWidth,0.31*cardHeight,0.95*cardWidth,0.34*cardHeight)
            let photoFrame = CGRectMake(0.34*cardWidth,0.55*cardHeight,0.32*cardWidth,0.32*cardHeight)
            let upperDeckFrame : CGRect = CGRectMake(screenWidth*(0.06),screenHeight*(0.16), screenWidth*0.8,screenHeight*0.30)
            let lowerDeckFrame : CGRect = CGRectMake(screenWidth*(0.06),screenHeight*(0.61), screenWidth*0.8,screenHeight*0.30)
            let upperDeckNameLabel = UILabel(frame: nameFrame)
            upperDeckNameLabel.text = nameSet[nextCardToShow]
            let upperDeckLocationLabel = UILabel(frame: locationFrame)
            upperDeckLocationLabel.text = locationSet[nextCardToShow]
            let upperDeckStatusLabel = UILabel(frame: statusFrame)
            upperDeckStatusLabel.text = statusSet[nextCardToShow]
            let upperDeckPhotoView = UIImageView(frame: photoFrame)
            
            let lowerDeckNameLabel = UILabel(frame: nameFrame)
            lowerDeckNameLabel.text = nameSet2[nextCardToShow]
            let lowerDeckLocationLabel = UILabel(frame: locationFrame)
            lowerDeckLocationLabel.text = locationSet2[nextCardToShow]
            let lowerDeckStatusLabel = UILabel(frame: statusFrame)
            lowerDeckStatusLabel.text = statusSet2[nextCardToShow]
            let lowerDeckPhotoView = UIImageView(frame: photoFrame)
            
            upperDeckCard = UIView(frame:upperDeckFrame)
            upperDeckCard.addSubview(upperDeckNameLabel)
            upperDeckCard.addSubview(upperDeckLocationLabel)
            upperDeckCard.addSubview(upperDeckStatusLabel)
            upperDeckCard.addSubview(upperDeckPhotoView)
            upperDeckCard.backgroundColor = colorSet[nextCardToShow]
            
            //upperDeckCards[minimumCards] = upperDeckCard
            
            
            lowerDeckCard = UIView(frame:lowerDeckFrame)
            lowerDeckCard.addSubview(lowerDeckNameLabel)
            lowerDeckCard.addSubview(lowerDeckLocationLabel)
            lowerDeckCard.addSubview(lowerDeckStatusLabel)
            lowerDeckCard.addSubview(lowerDeckPhotoView)
            lowerDeckCard.backgroundColor = colorSet[nextCardToShow]
            
            upperDeckCard.layer.cornerRadius = 8.0
            upperDeckCard.clipsToBounds = true
            lowerDeckCard.layer.cornerRadius = 8.0
            lowerDeckCard.clipsToBounds = true
            
            upperDeckCards[minimumCards] = upperDeckCard
            lowerDeckCards[minimumCards] = lowerDeckCard
        }
        
        print("nextCardToShow - \(nextCardToShow), self.minimumCards - \(self.minimumCards), noOfCardsThrown - \(noOfCardsThrown), totalNoOfCards - \(totalNoOfCards)  ")
        // save the positions of the top most card before it is shifted
        let upperDeckFrame0 = self.upperDeckCards[0]!.frame
        let lowerDeckFrame0 = self.lowerDeckCards[0]!.frame
        
        // animate the deck only if there are any cards
        if noOfCardsThrown < totalNoOfCards {
            
            // shift the top most card left
            UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
                
                print("trans")
                self.upperDeckCards[0]!.frame.origin.x = UIScreen.mainScreen().bounds.width
                self.lowerDeckCards[0]!.frame.origin.x = UIScreen.mainScreen().bounds.width
                }, completion: {  finished in
            })
            
            
            UIView.animateWithDuration(1.0, delay: 0.3, options: .CurveEaseOut, animations: {
                // place the new card in the 5th card's poition
                if self.nextCardToShow < self.totalNoOfCards{
                    self.view.insertSubview(upperDeckCard, belowSubview: self.upperDeckCards[self.minimumCards-1]!)
                    self.view.insertSubview(lowerDeckCard, belowSubview: self.lowerDeckCards[self.minimumCards-1]!)
                    // animate all but the first card one level forward
                    for i in (2..<self.minimumCards + 1).reverse() {
                        self.upperDeckCards[i]?.frame = self.upperDeckCards[i-1]!.frame
                        self.lowerDeckCards[i]?.frame = self.lowerDeckCards[i-1]!.frame
                    }
                    // animate the second card to the saved position
                    self.upperDeckCards[1]?.frame = upperDeckFrame0
                    self.lowerDeckCards[1]?.frame = lowerDeckFrame0
                    
                }
                    
                else {
                    // animate all but the first card one level forward
                    if self.minimumCards > 2 {
                        for i in (2..<self.minimumCards + 1).reverse() {
                            self.upperDeckCards[i]?.frame = self.upperDeckCards[i-1]!.frame
                            self.lowerDeckCards[i]?.frame = self.lowerDeckCards[i-1]!.frame
                        }
                    }
                    // animate the second card to the saved position
                    if self.minimumCards >= 2 {
                        self.upperDeckCards[1]?.frame = upperDeckFrame0
                        self.lowerDeckCards[1]?.frame = lowerDeckFrame0
                    }
                }
                }, completion: {  finished in
                    if self.minimumCards > 0 {
                        // remove the top most card from the deck
                        self.upperDeckCards[0]!.removeFromSuperview()
                        self.lowerDeckCards[0]!.removeFromSuperview()
                        
                        if self.nextCardToShow < self.totalNoOfCards || self.minimumCards > 1{
                            // move all cards in the deck one postion up
                            print("shifting")
                            for i in 0..<self.minimumCards {
                                self.upperDeckCards[i] = self.upperDeckCards[i+1]
                                self.lowerDeckCards[i] = self.lowerDeckCards[i+1]
                            }
                            
                        }
//                        else if self.minimumCards > 1 {
//                            // move all cards in the deck one postion up
//                            print("shifting")
//                            for i in 0..<self.minimumCards {
//                                self.upperDeckCards[i] = self.upperDeckCards[i+1]
//                                self.lowerDeckCards[i] = self.lowerDeckCards[i+1]
//                            }
//                        }
                    }
                    self.nextCardToShow += 1
                    if  self.nextCardToShow > self.totalNoOfCards {
                        self.minimumCards -= 1
                    }
                    self.bridgeButton?.userInteractionEnabled = true
                    self.nextPairButton?.userInteractionEnabled = true
                    
            })
        }
        noOfCardsThrown += 1
        
        

    }
    func nextPairButtonTapped(sender: UIButton!) {
        bridgeButton?.userInteractionEnabled = false
        nextPairButton?.userInteractionEnabled = false
        var upperDeckCard = UIView()
        var lowerDeckCard = UIView()
        
        // update Parse database and LocalStorage, download more cards
        if noOfCardsThrown < totalNoOfCards {
        if var bridgePairings = bridgePairings {
            let objectId = bridgePairings[0].user1?.objectId
            let query = PFQuery(className:"BridgePairings")
            query.getObjectInBackgroundWithId(objectId!, block: { (result, error) -> Void in
                if let result = result {
                    result["checked_out"] = false
                    result.saveInBackground()
                }
                
            })
            self.bridgePairings!.removeAtIndex(0)
            print("bridgePairings.count - \(bridgePairings.count)")
            let localData = LocalData()
            localData.setPairings(self.bridgePairings!)
            localData.synchronize()
            downloadMoreCards()
        }
        }
        // add a new Card to the deck if one exists
        if nextCardToShow < totalNoOfCards {
            let nameFrame = CGRectMake(0.05*cardWidth,0.10*cardHeight,0.55*cardWidth,0.20*cardHeight)
            let locationFrame = CGRectMake(0.60*cardWidth,0.10*cardHeight,0.40*cardWidth,0.20*cardHeight)
            let statusFrame = CGRectMake(0.05*cardWidth,0.31*cardHeight,0.95*cardWidth,0.34*cardHeight)
            let photoFrame = CGRectMake(0.34*cardWidth,0.55*cardHeight,0.32*cardWidth,0.32*cardHeight)
            let upperDeckFrame : CGRect = CGRectMake(screenWidth*(0.06),screenHeight*(0.16), screenWidth*0.8,screenHeight*0.30)
            let lowerDeckFrame : CGRect = CGRectMake(screenWidth*(0.06),screenHeight*(0.61), screenWidth*0.8,screenHeight*0.30)
            let upperDeckNameLabel = UILabel(frame: nameFrame)
            upperDeckNameLabel.text = nameSet[nextCardToShow]
            let upperDeckLocationLabel = UILabel(frame: locationFrame)
            upperDeckLocationLabel.text = locationSet[nextCardToShow]
            let upperDeckStatusLabel = UILabel(frame: statusFrame)
            upperDeckStatusLabel.text = statusSet[nextCardToShow]
            let upperDeckPhotoView = UIImageView(frame: photoFrame)
            upperDeckPhotoView.image = UIImage(data: photoSet[nextCardToShow])
            upperDeckPhotoView.layer.cornerRadius = upperDeckPhotoView.frame.size.width/2.0
            upperDeckPhotoView.clipsToBounds = true
            
            let lowerDeckNameLabel = UILabel(frame: nameFrame)
            lowerDeckNameLabel.text = nameSet2[nextCardToShow]
            let lowerDeckLocationLabel = UILabel(frame: locationFrame)
            lowerDeckLocationLabel.text = locationSet2[nextCardToShow]
            let lowerDeckStatusLabel = UILabel(frame: statusFrame)
            lowerDeckStatusLabel.text = statusSet2[nextCardToShow]
            let lowerDeckPhotoView = UIImageView(frame: photoFrame)
            lowerDeckPhotoView.image = UIImage(data: photoSet[nextCardToShow])
            lowerDeckPhotoView.layer.cornerRadius = lowerDeckPhotoView.frame.size.width/2.0
            lowerDeckPhotoView.clipsToBounds = true
            
            upperDeckCard = UIView(frame:upperDeckFrame)
            upperDeckCard.addSubview(upperDeckNameLabel)
            upperDeckCard.addSubview(upperDeckLocationLabel)
            upperDeckCard.addSubview(upperDeckStatusLabel)
            upperDeckCard.addSubview(upperDeckPhotoView)
            upperDeckCard.backgroundColor = colorSet[nextCardToShow]
            
            
            lowerDeckCard = UIView(frame:lowerDeckFrame)
            lowerDeckCard.addSubview(lowerDeckNameLabel)
            lowerDeckCard.addSubview(lowerDeckLocationLabel)
            lowerDeckCard.addSubview(lowerDeckStatusLabel)
            lowerDeckCard.addSubview(lowerDeckPhotoView)
            lowerDeckCard.backgroundColor = colorSet[nextCardToShow]
            
            upperDeckCard.layer.cornerRadius = 8.0
            upperDeckCard.clipsToBounds = true
            lowerDeckCard.layer.cornerRadius = 8.0
            lowerDeckCard.clipsToBounds = true
            
            upperDeckCards[minimumCards] = upperDeckCard
            lowerDeckCards[minimumCards] = lowerDeckCard
        }
        
        print("nextCardToShow - \(nextCardToShow), self.minimumCards - \(self.minimumCards), noOfCardsThrown - \(noOfCardsThrown), totalNoOfCards - \(totalNoOfCards)  ")
        // save the positions of the top most card before it is shifted
        let upperDeckFrame0 = self.upperDeckCards[0]!.frame
        let lowerDeckFrame0 = self.lowerDeckCards[0]!.frame
        
        // animate the deck only if there are any cards
        if noOfCardsThrown < totalNoOfCards {
            
            // shift the top most card left
            UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
                
                print("trans")
                self.upperDeckCards[0]!.frame.origin.x = -UIScreen.mainScreen().bounds.width
                self.lowerDeckCards[0]!.frame.origin.x = -UIScreen.mainScreen().bounds.width
                }, completion: {  finished in
            })
            
            
            UIView.animateWithDuration(1.0, delay: 0.3, options: .CurveEaseOut, animations: {
                // place the new card in the last + 1 card's poition
                // animate if a new card is added
                if self.nextCardToShow < self.totalNoOfCards{
                    self.view.insertSubview(upperDeckCard, belowSubview: self.upperDeckCards[self.minimumCards-1]!)
                    self.view.insertSubview(lowerDeckCard, belowSubview: self.lowerDeckCards[self.minimumCards-1]!)
                    // animate all but the first card one level forward
                    for i in (2..<self.minimumCards + 1).reverse() {
                        self.upperDeckCards[i]?.frame = self.upperDeckCards[i-1]!.frame
                        self.lowerDeckCards[i]?.frame = self.lowerDeckCards[i-1]!.frame
                    }
                    // animate the second card to the saved position
                    self.upperDeckCards[1]?.frame = upperDeckFrame0
                    self.lowerDeckCards[1]?.frame = lowerDeckFrame0

                }
                // animate if a new card is  not added; could do without "if else construct" it but if minimumCards is < 2 it will not work wiithout it
                else {
                // animate all but the first card one level forward
                if self.minimumCards > 2 {
                    for i in (2..<self.minimumCards + 1).reverse() {
                        self.upperDeckCards[i]?.frame = self.upperDeckCards[i-1]!.frame
                        self.lowerDeckCards[i]?.frame = self.lowerDeckCards[i-1]!.frame
                    }
                }
                // animate the second card to the saved position
                if self.minimumCards >= 2 {
                    self.upperDeckCards[1]?.frame = upperDeckFrame0
                    self.lowerDeckCards[1]?.frame = lowerDeckFrame0
                }
                }
                }, completion: {  finished in
                    if self.minimumCards > 0 {
                        // remove the top most card from the deck
                        self.upperDeckCards[0]!.removeFromSuperview()
                        self.lowerDeckCards[0]!.removeFromSuperview()
                        // move all cards in the deck one postion up
                        if self.nextCardToShow < self.totalNoOfCards || self.minimumCards > 1{
                            print("shifting")
                            for i in 0..<self.minimumCards {
                                self.upperDeckCards[i] = self.upperDeckCards[i+1]
                                self.lowerDeckCards[i] = self.lowerDeckCards[i+1]
                            }

                        }

                    }
                    self.nextCardToShow += 1
                    if  self.nextCardToShow > self.totalNoOfCards {
                        self.minimumCards -= 1
                    }
                    self.bridgeButton?.userInteractionEnabled = true
                    self.nextPairButton?.userInteractionEnabled = true
                    
            })
        }
        noOfCardsThrown += 1
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //        while localStorageUtility.waitForCardsToBeDownloaded(){
        //
        //        }
        //
        
        
//        localStorageUtility.getBridgePairingsFromCloud()
//        bridgePairings = LocalData().getPairings()

        bridgePairings = LocalData().getPairings()
        if (bridgePairings == nil || bridgePairings?.count < 1) {
        localStorageUtility.getBridgePairingsFromCloud()
        bridgePairings = LocalData().getPairings()
        }
        if let bridgePairings = bridgePairings {
            nameSet = [String]()
            nameSet2 = [String]()
            locationSet = [String]()
            locationSet2 = [String]()
            statusSet = [String]()
            statusSet2 = [String]()
            colorSet = [ UIColor]()
         
            totalNoOfCards = bridgePairings.count
            for i in 0..<bridgePairings.count {
                let pairing = bridgePairings[i]
                if let name = pairing.user1?.name {
                    print(name)
                    nameSet.append(name)
                }
                else {
                    nameSet.append("Man has no name")
                }
                if let name = pairing.user2?.name {
                    print(name)
                    nameSet2.append(name)
                }
                else {
                    nameSet2.append("Man has no name")
                }
                if let location_values = pairing.user1?.location {
                    locationSet.append("Location has no name")
//                    let geoCoder = CLGeocoder()
//                    let location = CLLocation(latitude: location_values[0], longitude: location_values[1])
//                    geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
//                        
//                        var placeMark: CLPlacemark!
//                        placeMark = placemarks?[0]
//                        if let city = placeMark.addressDictionary!["City"] as? NSString {
//                            self.locationSet.append(city as String)
//                        }
//                        
//                    })
                    
                    
                }
                else {
                    locationSet.append("Location has no name")
                }
                if let location_values = pairing.user2?.location {
                    locationSet2.append("Location has no name")
                    //                    let geoCoder = CLGeocoder()
                    //                    let location = CLLocation(latitude: location_values[0], longitude: location_values[1])
                    //                    geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                    //
                    //                        var placeMark: CLPlacemark!
                    //                        placeMark = placemarks?[0]
                    //                        if let city = placeMark.addressDictionary!["City"] as? NSString {
                    //                            self.locationSet.append(city as String)
                    //                        }
                    //
                    //                    })
                    
                    
                }
                else {
                    locationSet2.append("Location has no name")
                }

                if let bridgeStatus = pairing.user1?.bridgeStatus {
                    statusSet.append(bridgeStatus)
                }
                else {
                    statusSet.append("Nah")
                }
                if let bridgeStatus = pairing.user2?.bridgeStatus {
                    statusSet2.append(bridgeStatus)
                }
                else {
                    statusSet2.append("Nah")
                }
                if let mainProfilePicture = pairing.user1?.mainProfilePicture {
                    photoSet.append(mainProfilePicture)
                }
                else {
                    let mainProfilePicture = UIImagePNGRepresentation(UIImage(named: "bridgeVector.jpg")!)!
                    photoSet.append(mainProfilePicture)
                }
                if let mainProfilePicture = pairing.user2?.mainProfilePicture {
                    photoSet2.append(mainProfilePicture)
                }
                else {
                    let mainProfilePicture = UIImagePNGRepresentation(UIImage(named: "bridgeVector.jpg")!)!
                    photoSet2.append(mainProfilePicture)
                }

//                if let profilePicturePFFile = pairing.user1?.profilePicturePFFile {
//                    do {
//                    let data = try profilePicturePFFile.getData()
//                    photoSet.append(data)
//                    }
//                    catch {
//                        print("Photo not downloaded")
//                    }
//                }
//                else {
//                    //statusSet2.append("Nah")
//                }
//                if let profilePicturePFFile = pairing.user2?.profilePicturePFFile {
//                    do {
//                        let data = try profilePicturePFFile.getData()
//                        photoSet2.append(data)
//                    }
//                    catch {
//                        print("Photo not downloaded")
//                    }
//                }
//                else {
//                    //statusSet2.append("Nah")
//                }


                colorSet.append(colorSetMaster[i])
                
            }
            
            if bridgePairings.count > 4 {
                nextCardToShow = 4
                minimumCards = 4
            }
            else {
                nextCardToShow = bridgePairings.count
                minimumCards = bridgePairings.count
            }

        }
        
         lowerDeckCards = [UIView?](count: colorSet.count + 1, repeatedValue: nil)
         upperDeckCards = [UIView?](count: colorSet.count + 1, repeatedValue: nil)
        let nameFrame = CGRectMake(0.05*cardWidth,0.10*cardHeight,0.55*cardWidth,0.20*cardHeight)
        let locationFrame = CGRectMake(0.60*cardWidth,0.10*cardHeight,0.40*cardWidth,0.20*cardHeight)
        let statusFrame = CGRectMake(0.05*cardWidth,0.31*cardHeight,0.95*cardWidth,0.34*cardHeight)
        let photoFrame = CGRectMake(0.39*cardWidth,0.55*cardHeight,0.22*cardWidth,0.32*cardHeight)
        
        for i in (0..<nextCardToShow).reverse() {
            let upperDeckFrame : CGRect = CGRectMake(screenWidth*(0.08 + ( CGFloat(nextCardToShow - i + 1) * 0.02)),screenHeight*(0.17 - ( CGFloat(nextCardToShow - i + 1) * 0.01)), screenWidth*0.8,screenHeight*0.30)
            
            let lowerDeckFrame : CGRect = CGRectMake(screenWidth*(0.08 + ( CGFloat(nextCardToShow - i + 1) * 0.02)),screenHeight*(0.60 - ( CGFloat(nextCardToShow - i + 1) * 0.01)), screenWidth*0.8,screenHeight*0.30)
            
            let upperDeckNameLabel = UILabel(frame: nameFrame)
            upperDeckNameLabel.text = nameSet[i]
            let upperDeckLocationLabel = UILabel(frame: locationFrame)
            upperDeckLocationLabel.text = locationSet[i]
            let upperDeckStatusLabel = UILabel(frame: statusFrame)
            upperDeckStatusLabel.text = statusSet[i]
            let upperDeckPhotoView = UIImageView(frame: photoFrame)
            upperDeckPhotoView.image = UIImage(data: photoSet[i])
            upperDeckPhotoView.layer.cornerRadius = upperDeckPhotoView.frame.size.width/2.0
            upperDeckPhotoView.clipsToBounds = true
            
            let lowerDeckNameLabel = UILabel(frame: nameFrame)
            lowerDeckNameLabel.text = nameSet2[i]
            let lowerDeckLocationLabel = UILabel(frame: locationFrame)
            lowerDeckLocationLabel.text = locationSet2[i]
            let lowerDeckStatusLabel = UILabel(frame: statusFrame)
            lowerDeckStatusLabel.text = statusSet2[i]
            let lowerDeckPhotoView = UIImageView(frame: photoFrame)
            lowerDeckPhotoView.image = UIImage(data: photoSet2[i])
            lowerDeckPhotoView.layer.cornerRadius = lowerDeckPhotoView.frame.size.width/2.0
            lowerDeckPhotoView.clipsToBounds = true
            
            let upperDeckCard = UIView(frame:upperDeckFrame)
            upperDeckCard.addSubview(upperDeckNameLabel)
            upperDeckCard.addSubview(upperDeckLocationLabel)
            upperDeckCard.addSubview(upperDeckStatusLabel)
            upperDeckCard.addSubview(upperDeckPhotoView)
            upperDeckCard.backgroundColor = colorSet[i]
            upperDeckCards[i] = upperDeckCard
            
            
            let lowerDeckCard = UIView(frame:lowerDeckFrame)
            lowerDeckCard.addSubview(lowerDeckNameLabel)
            lowerDeckCard.addSubview(lowerDeckLocationLabel)
            lowerDeckCard.addSubview(lowerDeckStatusLabel)
            lowerDeckCard.addSubview(lowerDeckPhotoView)
            lowerDeckCard.backgroundColor = colorSet[i]
            lowerDeckCards[i] = lowerDeckCard
            
            upperDeckCard.layer.cornerRadius = 8.0
            upperDeckCard.clipsToBounds = true
            lowerDeckCard.layer.cornerRadius = 8.0
            lowerDeckCard.clipsToBounds = true
            
            view.addSubview(upperDeckCard)
            view.addSubview(lowerDeckCard)
            
        }
        nextPairButton = UIButton(frame: CGRectMake(screenWidth*0.08 ,screenHeight*0.47, screenWidth*0.4,screenHeight*0.07))
        nextPairButton!.backgroundColor = .grayColor()
        
        nextPairButton!.setTitle("Next Pair", forState: .Normal)
        nextPairButton!.addTarget(self, action: #selector(BridgeViewController.nextPairButtonTapped), forControlEvents: .TouchUpInside)
        self.view.addSubview(nextPairButton!)
        
        bridgeButton = UIButton(frame: CGRectMake(screenWidth*0.52 ,screenHeight*0.47, screenWidth*0.4,screenHeight*0.07))
        bridgeButton!.backgroundColor = .blueColor()
        bridgeButton!.setTitle("Bridge", forState: .Normal)
        bridgeButton!.addTarget(self, action: #selector(BridgeViewController.bridgeButtonTapped), forControlEvents: .TouchUpInside)
        self.view.addSubview(bridgeButton!)
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

