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
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

class BridgeViewController: UIViewController {
    
    let localData = LocalData()
    let pfCloudFunctions = PFCloudFunctions()
    
    //set to the height and width of the images in the superDeck
    let cardWidth = UIScreen.main.bounds.width - 0.06*UIScreen.main.bounds.width
    let cardHeight = 0.765*UIScreen.main.bounds.height*0.5
    
    //superDeck refers to the swipable rectangel containing the two images of the people to connect
    let superDeckX = 0.03*UIScreen.main.bounds.width
    let superDeckY = 0.12*UIScreen.main.bounds.height
    let superDeckWidth = UIScreen.main.bounds.width - 0.06*UIScreen.main.bounds.width
    let superDeckHeight = 0.765*UIScreen.main.bounds.height
    let necterColor = UIColor(red: 255/255, green: 230/255, blue: 57/255, alpha: 1.0)
    var totalNoOfCards = 0
    let localStorageUtility = LocalStorageUtility()
    var currentTypeOfCardsOnDisplay = typesOfCard.all
    var lastCardInStack:UIView? = nil // used by getB() to add a card below this
    var displayNoMoreCardsLabel:UILabel? = nil
    var arrayOfCardsInDeck = [UIView]()
    var arrayOfCardColors = [CGColor]()
    var segueToSingleMessage = false
    var messageId = ""
    let transitionManager = TransitionManager()
    
    //toolbar buttons
    let toolbar = UIView()
    let allTypesButton = UIButton()
    let allTypesLabel = UILabel()
    let businessButton = UIButton()
    let businessLabel = UILabel()
    let loveButton = UIButton()
    let loveLabel = UILabel()
    let friendshipButton = UIButton()
    let friendshipLabel = UILabel()
    let postStatusButton = UIButton()
    
    //navigation bar creation
    let navigationBar = UINavigationBar()
    let navItem = UINavigationItem()
    var badgeCount = Int()
    let profileButton = UIButton()
    let messagesButton = UIButton()
    
    
    //Connect and disconnect Icons
    let connectIcon = UIImageView()
    let disconnectIcon = UIImageView()
    
    //Send title and title Color singleMessageViewController
    var singleMessageTitle = ""
    var necterTypeColor = UIColor()
    
    enum typesOfCard {
        case all
        case business
        case love
        case friendship
    }
    enum typesOfColor {
        case business
        case love
        case friendship
    }
    func convertBridgeTypeEnumToBridgeTypeString(_ typeOfCard:typesOfCard) -> String {
        switch (typeOfCard) {
        case typesOfCard.all:
            return "All"
        case typesOfCard.business:
                 return "Business"
        case typesOfCard.love:
                return "Love"
        case typesOfCard.friendship:
                return "Friendship"
        }
    }
    func convertBridgeTypeStringToBridgeTypeEnum(_ typeOfCard:String) -> typesOfCard {
        switch (typeOfCard) {
        case "All":
            return typesOfCard.all
        case "Business":
            return typesOfCard.business
        case "Love":
            return typesOfCard.love
        case "Friendship":
            return typesOfCard.friendship
        default:
            return typesOfCard.friendship
        }
    }
    func convertBridgeTypeStringToColorTypeEnum(_ typeOfCard:String) -> typesOfColor {
            switch (typeOfCard) {
                
            case "Business":
                return typesOfColor.business
            case "Love":
                return typesOfColor.love
            case "Friendship":
                return typesOfColor.friendship
            default :
                return typesOfColor.business
            }

    }
    func getCGColor (_ color:typesOfColor) -> CGColor {
        switch(color) {
        case typesOfColor.business:
            return DisplayUtility.businessBlue.cgColor
        case typesOfColor.love:
            return  DisplayUtility.loveRed.cgColor
        case typesOfColor.friendship:
            return  DisplayUtility.friendshipGreen.cgColor
        }
        
    }
    func setCityName(_ locationLabel: UILabel, locationCoordinates:[Double], pairing:UserInfoPair) {
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
            var longitude :CLLocationDegrees = -122.0312186//locationCoordinates[0]//-122.0312186
            var latitude :CLLocationDegrees = 37.33233141//locationCoordinates[1]//37.33233141
            if locationCoordinates.count == 2{
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
    
    func displayRevisitButton() {
        print("displayRevisitButton")
        let revisitButtonY = (displayNoMoreCardsLabel?.frame.origin.y)! + (displayNoMoreCardsLabel?.frame.height)!
        let labelFrame: CGRect = CGRect(x: 0,y: revisitButtonY, width: 0.45*DisplayUtility.screenWidth,height: DisplayUtility.screenHeight * 0.06)
        let revisitButton = UIButton()
        revisitButton.frame = labelFrame
        revisitButton.setTitle("Revisit Matches", for: .normal)
        revisitButton.setTitleColor(UIColor.black, for: .normal)
        revisitButton.setTitleColor(DisplayUtility.necterYellow, for: .highlighted)
        revisitButton.titleLabel?.font = UIFont(name: "BentonSans", size: 20)
        revisitButton.titleLabel?.textAlignment = NSTextAlignment.center
        revisitButton.center.x = view.center.x
        //revisitButton.center.y = view.center.y + DisplayUtility.screenHeight*0.1
        revisitButton.addTarget(self, action: #selector(revitalizeMyPairs(_:)), for: .touchUpInside)
        
        revisitButton.layer.borderWidth = 4
        revisitButton.layer.borderColor = DisplayUtility.necterGray.cgColor
        revisitButton.layer.cornerRadius = 7
        revisitButton.clipsToBounds = true
        
        view.addSubview(revisitButton)
        
        
//        displayNoMoreCardsLabel!.frame = labelFrame
//        displayNoMoreCardsLabel!.numberOfLines = 0
//        
//        displayNoMoreCardsLabel!.font = UIFont(name: "BentonSans", size: 20)
//        displayNoMoreCardsLabel!.textAlignment = NSTextAlignment.center
//        displayNoMoreCardsLabel!.center.y = view.center.y
//        displayNoMoreCardsLabel!.center.x = view.center.x
//
//        displayNoMoreCardsLabel!.layer.borderWidth = 2
//        displayNoMoreCardsLabel!.layer.borderColor = DisplayUtility.necterGray.cgColor
//        displayNoMoreCardsLabel!.layer.cornerRadius = 15
    }
    func displayNoMoreCards() {
        let labelFrame: CGRect = CGRect(x: 0,y: 0, width: 0.8*DisplayUtility.screenWidth,height: DisplayUtility.screenHeight * 0.1)
        displayNoMoreCardsLabel = UILabel()
        displayNoMoreCardsLabel!.frame = labelFrame
        displayNoMoreCardsLabel!.numberOfLines = 0
        
        if businessButton.isEnabled == false {
            displayNoMoreCardsLabel!.text = "You ran out of people to connect for business. Please check back tomorrow."
        } else if loveButton.isEnabled == false {
            displayNoMoreCardsLabel!.text = "You ran out of people to connect for love. Please check back tomorrow."
        } else if friendshipButton.isEnabled == false {
            displayNoMoreCardsLabel!.text = "You ran out of people to connect for friendship. Please check back tomorrow."
        } else {
            displayNoMoreCardsLabel!.text = "You ran out of people to connect. Please check back tomorrow."
        }
        
        displayNoMoreCardsLabel!.font = UIFont(name: "BentonSans", size: 20)
        displayNoMoreCardsLabel!.textAlignment = NSTextAlignment.center
        displayNoMoreCardsLabel!.center.y = view.center.y - DisplayUtility.screenHeight*0.05
        displayNoMoreCardsLabel!.center.x = view.center.x
//        displayNoMoreCardsLabel!.layer.borderWidth = 2
//        displayNoMoreCardsLabel!.layer.borderColor = DisplayUtility.necterGray.cgColor
//        displayNoMoreCardsLabel!.layer.cornerRadius = 15

        view.addSubview(displayNoMoreCardsLabel!)
        
        displayRevisitButton()
        
    }
    func getUpperDeckCardFrame() -> CGRect {
        let upperDeckFrame : CGRect = CGRect(x: 0, y: 0, width: superDeckWidth, height: 0.5*superDeckHeight)
        return upperDeckFrame
    }
    func getLowerDeckCardFrame() -> CGRect {
        let lowerDeckFrame : CGRect = CGRect(x: 0, y: 0.5*superDeckHeight, width: superDeckWidth, height: 0.5*superDeckHeight)
        return lowerDeckFrame
    }
    func getUpperDeckCard(_ name:String?, location:String?, status:String?, photo:String?, cardColor:typesOfColor?, locationCoordinates:[Double]?, pairing: UserInfoPair) -> UIView{
        let frame = getUpperDeckCardFrame()
        return getCard(frame, name: name, location: location, status: status, photo: photo, cardColor: cardColor, locationCoordinates:locationCoordinates, pairing: pairing, tag: 0, isUpperDeckCard: true)
        
    }
    func getLowerDeckCard(_ name:String?, location:String?, status:String?, photo:String?, cardColor:typesOfColor?, locationCoordinates:[Double]?, pairing: UserInfoPair) -> UIView{
        let frame = getLowerDeckCardFrame()
        return getCard(frame, name: name, location: location, status: status, photo: photo, cardColor: cardColor, locationCoordinates:locationCoordinates, pairing: pairing, tag:1, isUpperDeckCard: false)
    }
    func getCard(_ deckFrame:CGRect, name:String?, location:String?, status:String?, photo:String?, cardColor:typesOfColor?, locationCoordinates:[Double]?, pairing:UserInfoPair, tag:Int, isUpperDeckCard: Bool) -> UIView {
        
        let locationFrame = CGRect(x: 0.05*cardWidth,y: 0.18*cardHeight,width: 0.8*cardWidth,height: 0.075*cardHeight)
        let statusFrame = CGRect(x: 0.05*cardWidth,y: 0.65*cardHeight,width: 0.9*cardWidth,height: 0.3*cardHeight)
        let photoFrame = CGRect(x: 0, y: 0, width: superDeckWidth, height: 0.5*superDeckHeight)
        
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.textAlignment = NSTextAlignment.left
        nameLabel.textColor = UIColor.white
        nameLabel.font = UIFont(name: "Verdana", size: 20)
        //let adjustedNameSize = nameLabel.sizeThatFits(CGSize(width: 0.8*cardWidth, height: 0.12*cardHeight))
        var nameFrame = CGRect(x: 0.05*cardWidth,y: 0.05*cardHeight,width: 0.8*cardWidth,height: 0.12*cardHeight)
        //nameFrame.size = adjustedNameSize
        //nameFrame.size.height = 0.12*cardHeight
        nameLabel.frame = nameFrame
        nameLabel.layer.cornerRadius = 2
        nameLabel.clipsToBounds = true
        
        nameLabel.layer.shadowOpacity = 0.5
        nameLabel.layer.shadowRadius = 0.5
        nameLabel.layer.shadowColor = UIColor.black.cgColor
        nameLabel.layer.shadowOffset = CGSize(width: 0.0, height: -0.5)
        let locationCoordinates = locationCoordinates ?? [-122.0,37.0]
        
        let locationLabel = UILabel(frame: locationFrame)
        locationLabel.tag = tag
        if location == "" {
            setCityName(locationLabel, locationCoordinates: locationCoordinates, pairing:pairing)
        }
        locationLabel.text = location
        locationLabel.textAlignment = NSTextAlignment.left
        locationLabel.textColor = UIColor.white
        locationLabel.font = UIFont(name: "Verdana", size: 14)
        locationLabel.layer.shadowOpacity = 0.5
        locationLabel.layer.shadowRadius = 0.5
        locationLabel.layer.shadowColor = UIColor.black.cgColor
        locationLabel.layer.shadowOffset = CGSize(width: 0.0, height: -0.5)
        
        var statusText = ""
        
        if let status = status {
            if status != "" {
                statusText = "\"\(status)\""
            }
            
        }
        let statusLabel = UILabel(frame: statusFrame)
        statusLabel.text = statusText
        statusLabel.textColor = UIColor.white
        statusLabel.font = UIFont(name: "Verdana", size: 14)
        statusLabel.textAlignment = NSTextAlignment.center
        statusLabel.numberOfLines = 0
        statusLabel.layer.shadowOpacity = 0.5
        statusLabel.layer.shadowRadius = 0.5
        statusLabel.layer.shadowColor = UIColor.black.cgColor
        statusLabel.layer.shadowOffset = CGSize(width: 0.0, height: -0.5)
        
        //card's profile pictures are retrieved if they are already saved to the phone using mapping to the associated bridgePairing objectId and the position of the card (i.e. either upperDeckCard or not)
        let photoView = UIImageView(frame: photoFrame)
        //photoView.image = UIImage(named: "Profile_Icon_Gray")
        
        if isUpperDeckCard {
            if let data = pairing.user1?.savedProfilePicture {
                //applying filter to make the white text more legible
                let beginImage = CIImage(data: data as Data)
                let edgeDetectFilter = CIFilter(name: "CIVignetteEffect")!
                edgeDetectFilter.setValue(beginImage, forKey: kCIInputImageKey)
                edgeDetectFilter.setValue(0.2, forKey: "inputIntensity")
                edgeDetectFilter.setValue(0.2, forKey: "inputRadius")
                
                let newCGImage = CIContext(options: nil).createCGImage(edgeDetectFilter.outputImage!, from: (edgeDetectFilter.outputImage?.extent)!)
                
                let newImage = UIImage(cgImage: newCGImage!)
                photoView.image = newImage
                photoView.contentMode = UIViewContentMode.scaleAspectFill
                photoView.clipsToBounds = true
            }
            else {
                if let photo = photo{
                    if let URL = URL(string: photo) {
                        Downloader.load(URL, imageView: photoView, bridgePairingObjectId: pairing.user1?.objectId, isUpperDeckCard: isUpperDeckCard)
                    }
                }
            }
        }
        else {
            if let data = pairing.user2?.savedProfilePicture {
                //applying filter to make the white text more legible
                let beginImage = CIImage(data: data as Data)
                let edgeDetectFilter = CIFilter(name: "CIVignetteEffect")!
                edgeDetectFilter.setValue(beginImage, forKey: kCIInputImageKey)
                edgeDetectFilter.setValue(0.2, forKey: "inputIntensity")
                edgeDetectFilter.setValue(0.2, forKey: "inputRadius")
                
                let newCGImage = CIContext(options: nil).createCGImage(edgeDetectFilter.outputImage!, from: (edgeDetectFilter.outputImage?.extent)!)
                
                let newImage = UIImage(cgImage: newCGImage!)
                photoView.image = newImage
                photoView.contentMode = UIViewContentMode.scaleAspectFill
                photoView.clipsToBounds = true
            }
            else {
                if let photo = photo{
                    if let URL = URL(string: photo) {
                        Downloader.load(URL, imageView: photoView, bridgePairingObjectId: pairing.user2?.objectId, isUpperDeckCard: isUpperDeckCard)
                    }
                }
            }
            
        }
        

//        if photo != nil {
//            photo!.getDataInBackgroundWithBlock({ (data, error) in
//                if error == nil && data != nil {
//                    dispatch_async(dispatch_get_main_queue(), {
//                        photoView.image = UIImage(data: data!)
//                    })
//                    
//                }
//                }
//            )
//        }
        //photoView.image = UIImage(data: photo)
        //photoView.contentMode = UIViewContentMode.ScaleAspectFill
        //photoView.contentMode = UIViewContentMode.Center
        //photoView.clipsToBounds = true
        
        let card = UIView(frame:deckFrame)
        
        card.addSubview(photoView)
        card.addSubview(nameLabel)
        card.addSubview(locationLabel)
        card.addSubview(statusLabel)
        
        return card
        
    }
    func addCardPairView(_ aboveView:UIView?, name:String?, location:String?, status:String?, photo:String?, locationCoordinates1:[Double]?, name2:String?, location2:String?, status2:String?, photo2:String?, locationCoordinates2:[Double]?, cardColor:typesOfColor?, pairing:UserInfoPair) -> UIView{
        
        let upperDeckCard = getUpperDeckCard(name, location: location, status: status, photo: photo, cardColor: cardColor, locationCoordinates:locationCoordinates1, pairing:pairing)
        let lowerDeckCard = getLowerDeckCard(name2, location: location2, status: status2, photo: photo2, cardColor: cardColor,locationCoordinates:locationCoordinates2, pairing:pairing)
        let superDeckFrame : CGRect = CGRect(x: superDeckX, y: superDeckY, width: superDeckWidth, height: superDeckHeight)
        let superDeckView = UIView(frame:superDeckFrame)
        superDeckView.layer.cornerRadius = 15
        upperDeckCard.clipsToBounds = true
        lowerDeckCard.clipsToBounds = true
        superDeckView.clipsToBounds = true
        superDeckView.addSubview(upperDeckCard)
        superDeckView.addSubview(lowerDeckCard)
        
        let necterTypeLine = UIView()
        //leftNecterTypeLine.alpha = 1.0
        necterTypeLine.frame = CGRect(x: 0, y: superDeckHeight/2.0 - 2, width: superDeckWidth, height: 4)
        
        /*let rightNecterTypeLine = UIView()
        rightNecterTypeLine.alpha = 1.0
        rightNecterTypeLine.frame = CGRect(x:  0.55*superDeckWidth, y: superDeckHeight/2.0  - 2, width: 0.2*superDeckWidth, height: 4)*/
        
        let necterTypeIcon = UIImageView()
        //necterTypeIcon.alpha = 1.0
        necterTypeIcon.frame = CGRect(x: 0.45*superDeckWidth, y: superDeckHeight/2.0 - 0.08*superDeckWidth, width: 0.12*superDeckWidth, height: 0.12*superDeckWidth)
        necterTypeIcon.contentMode = UIViewContentMode.scaleAspectFill
        necterTypeIcon.clipsToBounds = true
        
        necterTypeIcon.layer.shadowOpacity = 0.5
        necterTypeIcon.layer.shadowRadius = 0.5
        necterTypeIcon.layer.shadowColor = UIColor.black.cgColor
        necterTypeIcon.layer.shadowOffset = CGSize(width: 0.0, height: -0.5)
        
        if cardColor == typesOfColor.business {
            necterTypeLine.backgroundColor = DisplayUtility.businessBlue
            //rightNecterTypeLine.backgroundColor = DisplayUtility.businessBlue
            necterTypeIcon.image = UIImage(named: "Business_Icon_Blue")
        } else if cardColor == typesOfColor.love {
            necterTypeLine.backgroundColor = DisplayUtility.loveRed
            //rightNecterTypeLine.backgroundColor = DisplayUtility.loveRed
            necterTypeIcon.image = UIImage(named: "Love_Icon_Red")
        } else if cardColor == typesOfColor.friendship{
            necterTypeLine.backgroundColor = DisplayUtility.friendshipGreen
            //rightNecterTypeLine.backgroundColor = DisplayUtility.friendshipGreen
            necterTypeIcon.image = UIImage(named: "Friendship_Icon_Green")
        }
        
        superDeckView.addSubview(necterTypeLine)
        //superDeckView.addSubview(rightNecterTypeLine)
        superDeckView.addSubview(necterTypeIcon)
        
        
        superDeckView.backgroundColor = UIColor.white.withAlphaComponent(1.0)
        //superDeckView.layer.borderWidth = 4
        //superDeckView.layer.borderColor = getCGColor(cardColor)
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(BridgeViewController.isDragged(_:)))
        superDeckView.addGestureRecognizer(gesture)
        superDeckView.isUserInteractionEnabled = true
        if let aboveView = aboveView {
            superDeckView.isUserInteractionEnabled = false
            self.view.insertSubview(superDeckView, belowSubview: aboveView)
        }
        else {
            self.view.insertSubview(superDeckView, belowSubview: self.toolbar)
        }
        arrayOfCardsInDeck.append(superDeckView)
        arrayOfCardColors.append(superDeckView.layer.borderColor!)
        return superDeckView
    }
    
    // Does not download bridge pairings. Only presents the existing ones in the localData to the user
    func displayCards(){
        if let displayNoMoreCardsLabel = displayNoMoreCardsLabel {
            displayNoMoreCardsLabel.removeFromSuperview()
            
            self.displayNoMoreCardsLabel = nil
        }
        arrayOfCardsInDeck = [UIView]()
        arrayOfCardColors = [CGColor]()
        var j = 0
        let bridgePairings = localData.getPairings()
        if let bridgePairings = bridgePairings {
            var aboveView:UIView? = nil
        for i in 0..<bridgePairings.count {
            let pairing = bridgePairings[i]
            if self.currentTypeOfCardsOnDisplay != typesOfCard.all && pairing.user1?.bridgeType != convertBridgeTypeEnumToBridgeTypeString(self.currentTypeOfCardsOnDisplay) {
                //print ("continue")
                continue
            }
            j += 1
            var name1 = String()
            var name2 = String()
            var location1 = String()
            var location2 = String()
            var status1 = String()
            var status2 = String()
            var photoFile1: String? = nil
            var photoFile2: String? = nil
            var locationCoordinates1 = [Double]()
            var locationCoordinates2 = [Double]()
            if let name = pairing.user1?.name {
                //print(name)
                name1 = name
            }
            else {
                name1 = "Man has no name"
            }
            if let name = pairing.user2?.name {
                //print(name)
                name2 = name
            }
            else {
                name2 = "Man has no name"
            }
            if let location_values1 = pairing.user1?.location {
                locationCoordinates1 = location_values1
            }
            else {
            }
            if let location_values2 = pairing.user2?.location {
                locationCoordinates2 = location_values2
            }
            else {
            }
            
            if let city = pairing.user1?.city {
                location1 = city
            }
            else {
                location1 = ""
            }
            if let city = pairing.user2?.city {
                location2 = city
            }
            else {
                location2 = ""
            }
            
            
            if let bridgeStatus = pairing.user1?.bridgeStatus {
                status1 = bridgeStatus
            }
            else {
                status1 = ""
            }
            if let bridgeStatus = pairing.user2?.bridgeStatus {
                status2 = bridgeStatus
            }
            else {
                status2 = ""
            }
            if let mainProfilePicture = pairing.user1?.mainProfilePicture {
                photoFile1 = mainProfilePicture
            }
            if let mainProfilePicture = pairing.user2?.mainProfilePicture {
                photoFile2 = mainProfilePicture
            }
            let color = convertBridgeTypeStringToColorTypeEnum((pairing.user1?.bridgeType)!)
            
            aboveView = addCardPairView(aboveView, name: name1, location: location1, status: status1, photo: photoFile1,locationCoordinates1: locationCoordinates1, name2: name2, location2: location2, status2: status2, photo2: photoFile2,locationCoordinates2: locationCoordinates2, cardColor: color, pairing:pairing)
            lastCardInStack = aboveView!
        }
        
        }
        if  j == 0 {
            displayNoMoreCards()
            
        }
        
    }
    func displayNavigationBar(){
        
        //setting the profileIcon to the leftBarButtonItem
        let profileIcon = UIImage(named: "Profile_Icon_Gray")
        profileButton.setImage(profileIcon, for: UIControlState())
        profileButton.setImage(UIImage(named: "Profile_Icon_Yellow"), for: .selected)
        profileButton.setImage(UIImage(named: "Profile_Icon_Yellow"), for: .highlighted)
        profileButton.addTarget(self, action: #selector(profileTapped(_:)), for: .touchUpInside)
        profileButton.frame = CGRect(x: 0, y: 0, width: 0.085*DisplayUtility.screenWidth, height: 0.085*DisplayUtility.screenWidth)
        let leftBarButton = UIBarButtonItem(customView: profileButton)
        navItem.leftBarButtonItem = leftBarButton
        
        //setting the messagesIcon to the rightBarButtonItem
        var messagesIcon = UIImage()
        //setting messagesIcon to the icon specifying if there are or are not notifications
        if badgeCount > 0 {
            messagesButton.setImage(UIImage(named: "Messages_Icon_Gray_Notification"), for: UIControlState())
            messagesButton.setImage(UIImage(named: "Messages_Icon_Yellow_Notification"), for: .highlighted)
            messagesButton.setImage(UIImage(named: "Messages_Icon_Yellow_Notification"), for: .selected)
        } else {
            messagesButton.setImage(UIImage(named: "Messages_Icon_Gray"), for: UIControlState())
            messagesButton.setImage(UIImage(named: "Messages_Icon_Yellow"), for: .selected)
            messagesButton.setImage(UIImage(named: "Messages_Icon_Yellow"), for: .highlighted)
        }
        
        messagesButton.addTarget(self, action: #selector(messagesTapped(_:)), for: .touchUpInside)
        messagesButton.frame = CGRect(x: 0, y: 0, width: 0.085*DisplayUtility.screenWidth, height: 0.085*DisplayUtility.screenWidth)
        messagesButton.contentMode = UIViewContentMode.scaleAspectFill
        messagesButton.clipsToBounds = true
        let rightBarButton = UIBarButtonItem(customView: messagesButton)
        navItem.rightBarButtonItem = rightBarButton
        
        //setting the navBar color and title
        navigationBar.setItems([navItem], animated: false)
        //navigationBar.topItem?.title = "necter"
        let navBarTitle = UILabel()
        navBarTitle.frame = CGRect(x: 0, y: 0, width: 0.4*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenHeight)
        navBarTitle.center.x = navigationBar.center.x
        navBarTitle.center.y = navigationBar.center.y
        navBarTitle.text = "necter"
        navBarTitle.font = UIFont(name: "Verdana", size: 34)
        navBarTitle.textColor = DisplayUtility.necterYellow
        navBarTitle.textAlignment = NSTextAlignment.center
        
        navigationBar.topItem?.titleView = navBarTitle
        navigationBar.barStyle = .black
        navigationBar.barTintColor = UIColor.white
        
        self.view.addSubview(navigationBar)
        
        //setting the number of notifications to the iconLabel -> this has been removed
        /*iconLabel = UILabel(frame: messagesButton.frame)
         iconLabel.center.x = messagesButton.center.x
         iconLabel.center.y = messagesButton.center.y
         //iconLabel.font = UIFont(name: "BentonSans", size: 14)
         iconLabel.textColor = necterColor
         //iconLabel.text = String(badgeCount)
         //view.addSubview(iconLabel)*/
    }
    func displayToolBar(){
        
        toolbar.frame = CGRect(x: 0, y: 0.9*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenHeight)
        toolbar.backgroundColor = UIColor(red: 247/255.0, green: 247/255.0, blue: 247/255.0, alpha: 1.0)
        
        //creating buttons to be added to the toolbar and evenly spaced across
        allTypesButton.setImage(UIImage(named: "All_Types_Icon_Gray"), for: UIControlState())
        allTypesButton.setImage(UIImage(named: "All_Types_Icon_Colors"), for: .disabled)
        allTypesButton.frame = CGRect(x: 0.07083*DisplayUtility.screenWidth, y: 0, width: 0.1*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenWidth)
        allTypesButton.center.y = toolbar.center.y - 0.005*DisplayUtility.screenHeight
        allTypesButton.addTarget(self, action: #selector(filterTapped), for: .touchUpInside)
        allTypesButton.tag = 0
        
        //coloring allTypesText three different colors
        let allTypesText = "All Types" as NSString
        let allTypesAttributedText = NSMutableAttributedString(string: allTypesText as String, attributes: [NSFontAttributeName: UIFont.init(name: "BentonSans", size: 11)!])
        allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: DisplayUtility.businessBlue , range: allTypesText.range(of: "All"))
        allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: DisplayUtility.loveRed , range: allTypesText.range(of: "Ty"))
        allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: DisplayUtility.friendshipGreen , range: allTypesText.range(of: "pes"))
        
        //setting allTypesText
        allTypesLabel.attributedText = allTypesAttributedText
        allTypesLabel.textAlignment =  NSTextAlignment.center
        allTypesLabel.frame = CGRect(x: 0, y: 0.975*DisplayUtility.screenHeight, width: 0.2*DisplayUtility.screenWidth, height: 0.02*DisplayUtility.screenHeight)
        allTypesLabel.center.x = allTypesButton.center.x
        
        
        businessButton.setImage(UIImage(named: "Business_Icon_Gray"), for: UIControlState())
        businessButton.setImage(UIImage(named:  "Business_Icon_Blue"), for: .disabled)
        businessButton.frame = CGRect(x: 0.24166*DisplayUtility.screenWidth, y: 0, width: 0.1*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenWidth)
        businessButton.center.y = toolbar.center.y - 0.005*DisplayUtility.screenHeight
        businessButton.addTarget(self, action: #selector(filterTapped), for: .touchUpInside)
        businessButton.tag = 1
        
        businessLabel.text = "Business"
        businessLabel.textColor = DisplayUtility.necterGray
        businessLabel.font = UIFont(name: "BentonSans", size: 11)
        businessLabel.textAlignment =  NSTextAlignment.center
        businessLabel.frame = CGRect(x: 0, y: 0.975*DisplayUtility.screenHeight, width: 0.2*DisplayUtility.screenWidth, height: 0.02*DisplayUtility.screenHeight)
        businessLabel.center.x = businessButton.center.x
        
        loveButton.setImage(UIImage(named: "Love_Icon_Gray"), for: UIControlState())
        loveButton.setImage(UIImage(named: "Love_Icon_Red"), for: .disabled)
        loveButton.frame = CGRect(x: 0.65832*DisplayUtility.screenWidth, y: 0, width: 0.1*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenWidth)
        loveButton.center.y = toolbar.center.y - 0.005*DisplayUtility.screenHeight
        loveButton.addTarget(self, action: #selector(filterTapped), for: .touchUpInside)
        loveButton.tag = 2
        
        loveLabel.text = "Love"
        loveLabel.font = UIFont(name: "BentonSans", size: 11)
        loveLabel.textColor = DisplayUtility.necterGray
        loveLabel.textAlignment =  NSTextAlignment.center
        loveLabel.frame = CGRect(x: 0, y: 0.975*DisplayUtility.screenHeight, width: 0.2*DisplayUtility.screenWidth, height: 0.02*DisplayUtility.screenHeight)
        loveLabel.center.x = loveButton.center.x
        
        friendshipButton.setImage(UIImage(named: "Friendship_Icon_Gray"), for: UIControlState())
        friendshipButton.setImage(UIImage(named:  "Friendship_Icon_Green"), for: .disabled)
        friendshipButton.frame = CGRect(x: 0.82915*DisplayUtility.screenWidth, y: 0, width: 0.1*DisplayUtility.screenWidth, height: 0.1150*DisplayUtility.screenWidth)
        friendshipButton.center.y = toolbar.center.y - 0.005*DisplayUtility.screenHeight
        friendshipButton.addTarget(self, action: #selector(filterTapped), for: .touchUpInside)
        friendshipButton.tag = 3
        
        friendshipLabel.text = "Friendship"
        friendshipLabel.font = UIFont(name: "BentonSans", size: 11)
        friendshipLabel.textColor = DisplayUtility.necterGray
        friendshipLabel.textAlignment =  NSTextAlignment.center
        friendshipLabel.frame = CGRect(x: 0, y: 0.975*DisplayUtility.screenHeight, width: 0.2*DisplayUtility.screenWidth, height: 0.02*DisplayUtility.screenHeight)
        friendshipLabel.center.x = friendshipButton.center.x
        
        
        postStatusButton.frame = CGRect(x: 0, y: 0, width: 0.175*DisplayUtility.screenWidth, height: 0.175*DisplayUtility.screenWidth)
        postStatusButton.backgroundColor = DisplayUtility.necterYellow
        postStatusButton.showsTouchWhenHighlighted = true
        postStatusButton.layer.borderWidth = 2.0
        postStatusButton.layer.borderColor = UIColor.white.cgColor
        postStatusButton.layer.cornerRadius = postStatusButton.frame.size.width/2.0
        postStatusButton.clipsToBounds = true
        //loveButton.layer.borderColor =
        postStatusButton.center.y = toolbar.center.y - 0.25*0.175*DisplayUtility.screenWidth
        postStatusButton.center.x = view.center.x
        postStatusButton.setTitle("+", for: UIControlState())
        postStatusButton.setTitleColor(UIColor.white, for: UIControlState())
        postStatusButton.titleLabel?.font = UIFont(name: "Verdana", size: 26)
        postStatusButton.addTarget(self, action: #selector(postStatusTapped), for: .touchUpInside)
        //loveButton.addTarget(self, action: #selector(filterTapped(_:)), forControlEvents: .TouchUpInside)
        //loveButton.tag = 2
        
        
        view.addSubview(toolbar)
        view.addSubview(allTypesButton)
        view.addSubview(allTypesLabel)
        view.addSubview(businessButton)
        view.addSubview(businessLabel)
        view.addSubview(loveButton)
        view.addSubview(loveLabel)
        view.addSubview(friendshipButton)
        view.addSubview(friendshipLabel)
        view.addSubview(postStatusButton)
    }
    // downloads  bridge pairings of different types depending upon the typeOfCards
    func getBridgePairings(_ maxNoOfCards:Int, typeOfCards:String, callBack: ((_ bridgeType: String)->Void)?, bridgeType: String?){
        if let displayNoMoreCardsLabel = self.displayNoMoreCardsLabel {
            displayNoMoreCardsLabel.removeFromSuperview()
            self.displayNoMoreCardsLabel = nil
        }

        let q = PFQuery(className: "_User")
        var flist = [String]()
            q.getObjectInBackground(withId: (PFUser.current()?.objectId)!){
            (object, error) -> Void in
            if error == nil && object != nil {
            if let fl = object!["friend_list"] as? [String]{
                flist = fl
                if let _ = PFUser.current()?.objectId {
                    var getMorePairings = true
                    var i = 1
                    while getMorePairings {
                        let query = PFQuery(className:"BridgePairings")
                        query.whereKey("user_objectId1", containedIn :flist)
                        query.whereKey("user_objectId2", containedIn :flist)
                        query.whereKey("user_objectId1", notEqualTo:(PFUser.current()?.objectId)!)
                        query.whereKey("user_objectId2", notEqualTo:(PFUser.current()?.objectId)!)
                        
                        query.whereKey("checked_out", equalTo: false)
                        query.whereKey("shown_to", notEqualTo:(PFUser.current()?.objectId)!)
                        if (typeOfCards != "All" && typeOfCards != "EachOfAllType") {
                            query.whereKey("bridge_type", equalTo: typeOfCards)
                        }
                        if typeOfCards == "EachOfAllType" {
                            switch i {
                            case 1:
                                query.whereKey("bridge_type", equalTo: "Business")
                            case 2:
                                query.whereKey("bridge_type", equalTo: "Love")
                            case 3:
                                query.whereKey("bridge_type", equalTo: "Friendship")
                            default: break
                            }
                            
                        }
                        query.limit = maxNoOfCards
                        query.findObjectsInBackground (block: { (results, error) -> Void in
                            var noOfResults = 0
                                if let results = results {
                                
                                for result in results {
                                    noOfResults += 1
                                    var user1:PairInfo? = nil
                                    var user2:PairInfo? = nil
                                    var name1:String? = nil
                                    var name2:String? = nil
                                    var userId1:String? = nil
                                    var userId2:String? = nil
                                    if let ob = result["user_objectIds"] as? [String] {
                                        userId1 =  ob[0]
                                        userId2 =  ob[1]
                                    }
                                    if let ob = result["user1_name"] {
                                        name1 = ob as? String
                                        
                                    }
                                    if let ob = result["user2_name"] {
                                        name2 = ob as? String
                                    }
                                    var location1:[Double]? = nil
                                    var location2:[Double]? = nil
                                    if let ob = result["user_locations"] as? [AnyObject]{
                                        if let x = ob[0] as? PFGeoPoint{
                                            location1 = [x.latitude,x.longitude]
                                        }
                                        if let x = ob[1] as? PFGeoPoint{
                                            location2 = [x.latitude,x.longitude]
                                        }
                                    }
                                    var bridgeStatus1:String? = nil
                                    var bridgeStatus2:String? = nil
                                    if let ob = result["user1_bridge_status"] {
                                        bridgeStatus1 =  ob as? String
                                    }
                                    if let ob = result["user2_bridge_status"] {
                                        bridgeStatus2 =  ob as? String
                                    }
                                    var city1:String? = nil
                                    var city2:String? = nil
                                    if let ob = result["user1_city"] {
                                        city1 =  ob as? String
                                    }
                                    if let ob = result["user2_city"] {
                                        city2 =  ob as? String
                                    }
                                    
                                    var bridgeType1:String? = nil
                                    var bridgeType2:String? = nil
                                    if let ob = result["bridge_type"] {
                                        bridgeType1 =  ob as? String
                                        bridgeType2 =  ob as? String
                                    }
                                    
                                    var objectId1:String? = nil
                                    var objectId2:String? = nil
                                    if let ob = result.objectId {
                                        objectId1 =  ob as String
                                        objectId2 =  ob as String
                                    }
                                    
                                    
                                    result["checked_out"]  = true
                                    if let _ = result["shown_to"] {
                                        if var ar = result["shown_to"] as? [String] {
                                            let s = (PFUser.current()?.objectId)! as String
                                            ar.append(s)
                                            result["shown_to"] = ar
                                        }
                                        else {
                                            result["shown_to"] = [(PFUser.current()?.objectId)!]
                                        }
                                    }
                                    else {
                                        result["shown_to"] = [(PFUser.current()?.objectId)!]
                                    }
                                    var profilePictureFile1:String? = nil
                                    var profilePictureFile2:String? = nil
                                    if let ob = result["user1_profile_picture"] as? PFFile {
                                        profilePictureFile1 = ob.url
                                    }
                                    if let ob = result["user2_profile_picture"] as? PFFile {
                                        profilePictureFile2 = ob.url
                                    }
                                    result.saveInBackground()
                                    user1 = PairInfo(name:name1, mainProfilePicture: profilePictureFile1, profilePictures: nil,location: location1, bridgeStatus: bridgeStatus1, objectId: objectId1,  bridgeType: bridgeType1, userId: userId1, city: city1, savedProfilePicture: nil)
                                    user2 = PairInfo(name:name2, mainProfilePicture: profilePictureFile2, profilePictures: nil,location: location2, bridgeStatus: bridgeStatus2, objectId: objectId2,  bridgeType: bridgeType2, userId: userId2, city: city2, savedProfilePicture: nil)
                                    let userInfoPair = UserInfoPair(user1: user1, user2: user2)
                                    let bridgePairings = self.localData.getPairings()
                                    var pairings = [UserInfoPair]()
                                    if (bridgePairings != nil) {
                                        pairings = bridgePairings!
                                    }

                                    pairings.append(userInfoPair)
                                    
                                    self.localData.setPairings(pairings)
                                    self.localData.synchronize()
                                    let localData2 = LocalData()
                                    
                                    DispatchQueue.main.async(execute: {
                                        if let displayNoMoreCardsLabel = self.displayNoMoreCardsLabel {
                                            displayNoMoreCardsLabel.removeFromSuperview()
                                            self.displayNoMoreCardsLabel = nil
                                        }
                                        let bridgeType = bridgeType1 ?? "Business"
                                        let color = self.convertBridgeTypeStringToColorTypeEnum(bridgeType)
                                        var aboveView:UIView? = self.lastCardInStack
                                        aboveView = self.addCardPairView(aboveView, name: name1, location: city1, status: bridgeStatus1, photo: profilePictureFile1,locationCoordinates1: location1, name2: name2, location2: city2, status2: bridgeStatus2, photo2: profilePictureFile2,locationCoordinates2: location2, cardColor: color, pairing:userInfoPair)
                                        self.lastCardInStack = aboveView!
                                        

                                    })
                                }
                            }
                            DispatchQueue.main.async(execute: {
                            if noOfResults == 0 && self.lastCardInStack == nil && self.displayNoMoreCardsLabel == nil{
                                self.displayNoMoreCards()
                            }
                            })
                            
                            if callBack != nil && bridgeType != nil {
                                callBack!(bridgeType!)
                            }

                        })
                        i += 1
                        print("i is \(i)")
                        if i > 3 || typeOfCards != "EachOfAllType"{
                            getMorePairings = false
                        }
                    }
                }
            }

        }
        }
    }
    func updateNoOfUnreadMessagesIcon(_ notification: Notification) {
        print("updateNoOfUnreadMessagesIcon called")
        let aps = (notification as NSNotification).userInfo!["aps"] as? NSDictionary
        badgeCount = (aps!["badge"] as? Int)!
        DispatchQueue.main.async(execute: {
            
            if self.badgeCount > 0 {
                //self.iconLabel.text = String(self.badgeCount)
                //self.displayNavigationBar()
                self.messagesButton.setImage(UIImage(named: "Messages_Icon_Gray_Notification"), for: UIControlState())
                self.messagesButton.setImage(UIImage(named: "Messages_Icon_Yellow_Notification"), for: .highlighted)
                self.messagesButton.setImage(UIImage(named: "Messages_Icon_Yellow_Notification"), for: .selected)
                self.navItem.rightBarButtonItem = UIBarButtonItem(customView: self.messagesButton)
                self.navigationBar.setItems([self.navItem], animated: false)
            }
            
            
        })
        
        
    }
    func displayMessageFromBot(_ notification: Notification) {
        let botNotificationView = UIView()
        botNotificationView.frame = CGRect(x: 0, y: -0.12*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: 0.12*DisplayUtility.screenHeight)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = botNotificationView.bounds
        //blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let messageLabel = UILabel(frame: CGRect(x: 0.05*DisplayUtility.screenWidth, y: 0.01*DisplayUtility.screenHeight, width: 0.9*DisplayUtility.screenWidth, height: 0.11*DisplayUtility.screenHeight))
        messageLabel.text = (notification as NSNotification).userInfo!["message"] as? String ?? "No Message Came Up"
        messageLabel.textColor = UIColor.darkGray
        messageLabel.font = UIFont(name: "Verdana-Bold", size: 14)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = NSTextAlignment.center
        //botNotificationView.backgroundColor = DisplayUtility.necterYellow
        
        //botNotificationView.addSubview(blurEffectView)
        botNotificationView.addSubview(messageLabel)
        botNotificationView.insertSubview(blurEffectView, belowSubview: messageLabel)
        view.insertSubview(botNotificationView, aboveSubview: navigationBar)
        
        
        UIView.animate(withDuration: 0.7, animations: {
            botNotificationView.frame.origin.y = 0
        }) 
        
        let _ = CustomTimer(interval: 4) {i -> Bool in
            UIView.animate(withDuration: 0.7, animations: {
                botNotificationView.frame.origin.y = -0.12*DisplayUtility.screenHeight
            })
            return i < 1
        }
        
        
        NotificationCenter.default.removeObserver(self)
        //botNotificationView.removeFromSuperview()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.displayMessageFromBot), name: NSNotification.Name(rawValue: "displayMessageFromBot"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateNoOfUnreadMessagesIcon), name: NSNotification.Name(rawValue: "updateNoOfUnreadMessagesIcon"), object: nil)
        displayNavigationBar()
        displayToolBar()
        allTypesButton.isEnabled = false
        let query: PFQuery = PFQuery(className: "Messages")
        query.whereKey("ids_in_message", contains: PFUser.current()?.objectId)
        query.cachePolicy = .networkElseCache
        query.findObjectsInBackground(block: { (results, error) -> Void in
            if error == nil {
                if let results = results {
                    self.badgeCount = 0
                    for i in 0..<results.count{
                        let result = results[i]
                        if let _ = result["message_viewed"] {
                            let whoViewed = result["message_viewed"] as! ([String])
                            if whoViewed.contains((PFUser.current()?.objectId)!) {
                                self.badgeCount += 0 //(true)
                                //print("1")
                            }
                            else {
                                self.badgeCount += 1//(false)
                                //print("2")
                            }
                        }
                        else {
                            self.badgeCount += 1//(false)
                            //print("3")
                        }
                        
                        /*if var noOfSingleMessagesViewed = NSKeyedUnarchiver.unarchiveObjectWithData(result["no_of_single_messages_viewed"] as! NSData)! as? [String:Int] {
                            let noOfMessagesViewed = noOfSingleMessagesViewed[(PFUser.currentUser()?.objectId)!] ?? 0
                            print("noOfMessagesViewed \(noOfMessagesViewed)")
                            self.badgeCount += (result["no_of_single_messages"] as! Int) - noOfMessagesViewed
                            print("result[no_of_single_messages] \(result["no_of_single_messages"])")
                            print(result.objectId)
                        }*/
                    }
                    DispatchQueue.main.async(execute: {
                        //self.badgeCount = 0
                        if self.badgeCount > 0 {
                            //setting the iconLabel to the number of notifications -> this has been removed
                            //self.iconLabel.text = String(self.badgeCount)
                            //setting the messagesIcon to the notification rightBarButtonItem
                            //self.displayNavigationBar()
                            self.messagesButton.setImage(UIImage(named: "Messages_Icon_Gray_Notification"), for: UIControlState())
                            self.messagesButton.setImage(UIImage(named: "Messages_Icon_Yellow_Notification"), for: .highlighted)
                            self.messagesButton.setImage(UIImage(named: "Messages_Icon_Yellow_Notification"), for: .selected)
                            self.navItem.rightBarButtonItem = UIBarButtonItem(customView: self.messagesButton)
                            self.navigationBar.setItems([self.navItem], animated: false)
                        } else {
                            //self.iconLabel.text = ""
                            //self.displayNavigationBar()
                            self.messagesButton.setImage(UIImage(named: "Messages_Icon_Gray"), for: UIControlState())
                            self.messagesButton.setImage(UIImage(named: "Messages_Icon_Yellow"), for: .highlighted)
                            self.messagesButton.setImage(UIImage(named: "Messages_Icon_Yellow"), for: .selected)
                            
                            self.navItem.rightBarButtonItem = UIBarButtonItem(customView: self.messagesButton)
                            self.navigationBar.setItems([self.navItem], animated: false)
                        }
                    })
                    
                }
            }
        })
        
        
        let bridgePairings = localData.getPairings()
        if (bridgePairings == nil || bridgePairings?.count < 1) {
            getBridgePairings(2,typeOfCards: "EachOfAllType", callBack: nil, bridgeType: nil)
        }
        else {
            displayCards()
        }
        
        
        connectIcon.image = UIImage(named: "Necter_Icon")
        //connectIcon.frame = CGRect(x: 0.6*DisplayUtility.screenWidth+10, y: 0.33*DisplayUtility.screenHeight, width: 0.1*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenWidth)
        connectIcon.alpha = 0.0
        view.insertSubview(connectIcon, aboveSubview: self.toolbar)
        
        disconnectIcon.image = UIImage(named: "Disconnect_Icon")
        //disconnectIcon.frame = CGRect(x: 0, y: 0.33*DisplayUtility.screenHeight, width: 0.1*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenWidth)
        //CGRect(x: -10, y: 0.33*DisplayUtility.screenHeight, width: 0.4*DisplayUtility.screenWidth, height: 0.4*DisplayUtility.screenWidth)
        disconnectIcon.alpha = 0.0
        view.insertSubview(disconnectIcon, aboveSubview: self.toolbar)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidLayoutSubviews() {
   
        navigationBar.frame = CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: 0.11*DisplayUtility.screenHeight)

    }
    
    func postStatusTapped(_ sender: UIButton ){
        performSegue(withIdentifier: "showNewStatusViewController", sender: self)
        //presentViewController(vc!, animated: true, completion: nil)
    }
    func filterTapped(_ sender: UIButton){
        let tag = sender.tag
        switch(tag){
            case 0:
                currentTypeOfCardsOnDisplay = convertBridgeTypeStringToBridgeTypeEnum("All")
                
                //updating which toolbar Button is selected
                allTypesButton.isEnabled = false
                businessButton.isEnabled = true
                loveButton.isEnabled = true
                friendshipButton.isEnabled = true
                
                //updating textColor necter-Type labels
                let allTypesText = "All Types" as NSString
                let allTypesAttributedText = NSMutableAttributedString(string: allTypesText as String, attributes: [NSFontAttributeName: UIFont.init(name: "BentonSans", size: 11)!])
                allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: DisplayUtility.businessBlue , range: allTypesText.range(of: "All"))
                allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: DisplayUtility.loveRed , range: allTypesText.range(of: "Ty"))
                allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: DisplayUtility.friendshipGreen , range: allTypesText.range(of: "pes"))
                allTypesLabel.attributedText = allTypesAttributedText
                businessLabel.textColor = DisplayUtility.necterGray
                loveLabel.textColor = DisplayUtility.necterGray
                friendshipLabel.textColor = DisplayUtility.necterGray
                    break
            case 1:
                currentTypeOfCardsOnDisplay = convertBridgeTypeStringToBridgeTypeEnum("Business")
                
                //updating which toolbar Button is selected
                allTypesButton.isEnabled = true
                businessButton.isEnabled = false
                loveButton.isEnabled = true
                friendshipButton.isEnabled = true
                
                //updating textColor necter-Type labels
                let allTypesText = "All Types" as NSString
                let allTypesAttributedText = NSMutableAttributedString(string: allTypesText as String, attributes: [NSFontAttributeName: UIFont.init(name: "BentonSans", size: 11)!])
                allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: DisplayUtility.necterGray , range: allTypesText.range(of: "All Types"))
                allTypesLabel.attributedText = allTypesAttributedText
                businessLabel.textColor = DisplayUtility.businessBlue
                loveLabel.textColor = DisplayUtility.necterGray
                friendshipLabel.textColor = DisplayUtility.necterGray
                
                    break
            case 2:
                currentTypeOfCardsOnDisplay = convertBridgeTypeStringToBridgeTypeEnum("Love")
                
                //updating which toolbar Button is selected
                allTypesButton.isEnabled = true
                businessButton.isEnabled = true
                loveButton.isEnabled = false
                friendshipButton.isEnabled = true
                
                //updating textColor necter-Type labels
                let allTypesText = "All Types" as NSString
                let allTypesAttributedText = NSMutableAttributedString(string: allTypesText as String, attributes: [NSFontAttributeName: UIFont.init(name: "BentonSans", size: 11)!])
                allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: DisplayUtility.necterGray , range: allTypesText.range(of: "All Types"))
                allTypesLabel.attributedText = allTypesAttributedText
                businessLabel.textColor = DisplayUtility.necterGray
                loveLabel.textColor = DisplayUtility.loveRed
                friendshipLabel.textColor = DisplayUtility.necterGray
                    break
            case 3:
                currentTypeOfCardsOnDisplay = convertBridgeTypeStringToBridgeTypeEnum("Friendship")
                
                //updating which toolbar Button is selected
                allTypesButton.isEnabled = true
                businessButton.isEnabled = true
                loveButton.isEnabled = true
                friendshipButton.isEnabled = false
                
                
                //updating textColor necter-Type labels
                let allTypesText = "All Types" as NSString
                let allTypesAttributedText = NSMutableAttributedString(string: allTypesText as String, attributes: [NSFontAttributeName: UIFont.init(name: "BentonSans", size: 11)!])
                allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: DisplayUtility.necterGray , range: allTypesText.range(of: "All Types"))
                allTypesLabel.attributedText = allTypesAttributedText
                businessLabel.textColor = DisplayUtility.necterGray
                loveLabel.textColor = DisplayUtility.necterGray
                friendshipLabel.textColor = DisplayUtility.friendshipGreen
                    break
            default:
                currentTypeOfCardsOnDisplay = convertBridgeTypeStringToBridgeTypeEnum("All")
                
                //updating which toolbar Button is selected
                allTypesButton.isEnabled = false
                businessButton.isEnabled = true
                loveButton.isEnabled = true
                friendshipButton.isEnabled = true
                
                //updating textColor necter-Type labels
                let allTypesText = "All Types" as NSString
                let allTypesAttributedText = NSMutableAttributedString(string: allTypesText as String, attributes: [NSFontAttributeName: UIFont.init(name: "BentonSans", size: 11)!])
                allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: DisplayUtility.businessBlue , range: allTypesText.range(of: "All"))
                allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: DisplayUtility.loveRed , range: allTypesText.range(of: "Ty"))
                allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: DisplayUtility.friendshipGreen , range: allTypesText.range(of: "pes"))
                allTypesLabel.attributedText = allTypesAttributedText
                businessLabel.textColor = DisplayUtility.necterGray
                loveLabel.textColor = DisplayUtility.necterGray
                friendshipLabel.textColor = DisplayUtility.necterGray
        }
        for i in 0..<arrayOfCardsInDeck.count {
            arrayOfCardsInDeck[i].removeFromSuperview()
        }
        arrayOfCardsInDeck.removeAll()
        arrayOfCardColors.removeAll()
        displayCards()
    }
    func profileTapped(_ sender: UIBarButtonItem) {
        profileButton.isSelected = true
        performSegue(withIdentifier: "showProfilePageFromBridgeView", sender: self)
    }
    func messagesTapped(_ sender: UIBarButtonItem) {
        messagesButton.isSelected = true
        performSegue(withIdentifier: "showMessagesPageFromBridgeView", sender: self)
    }
    func isDragged(_ gesture: UIPanGestureRecognizer) {

        let translation = gesture.translation(in: self.view)
        let superDeckView = gesture.view!
        superDeckView.center = CGPoint(x: DisplayUtility.screenWidth / 2 + translation.x, y: DisplayUtility.screenHeight / 2 + translation.y)
        let xFromCenter = superDeckView.center.x - self.view.bounds.width / 2
        let scale = min(CGFloat(1.0), 1)
        var rotation = CGAffineTransform(rotationAngle: -xFromCenter / 1000)
        var stretch = rotation.scaledBy(x: scale, y: scale)
        superDeckView.transform = stretch
        var removeCard = false
        
        //let disconnectIconSize = max(min((-2.0*(superDeckView.center.x/DisplayUtility.screenWidth)+0.9)*DisplayUtility.screenWidth, 0.4*DisplayUtility.screenWidth), 0.1*DisplayUtility.screenWidth)
        //let connectIconSize = max(min((2.0*(superDeckView.center.x/DisplayUtility.screenWidth))*DisplayUtility.screenWidth, 0.4*DisplayUtility.screenWidth), 0.1*DisplayUtility.screenWidth)
        //let disconnectIconX = min((-1.66*(superDeckView.center.x/DisplayUtility.screenWidth)+0.66)*DisplayUtility.screenWidth, 0.15*DisplayUtility.screenWidth)
        
        let disconnectIconX = max(min((-1.5*(superDeckView.center.x/DisplayUtility.screenWidth)+0.6)*DisplayUtility.screenWidth, 0.1*DisplayUtility.screenWidth), 0)
        //let connectIconX = max((-1.66*(superDeckView.center.x/DisplayUtility.screenWidth)+1.6)*DisplayUtility.screenWidth, 0.35*DisplayUtility.screenWidth)
        let connectIconX = max(min(((-2.0/3.0)*(superDeckView.center.x/DisplayUtility.screenWidth)+1.0)*DisplayUtility.screenWidth, 0.6*DisplayUtility.screenWidth), 0.5*DisplayUtility.screenWidth)
        
        

        //animating connect and disconnect icons when card is positioned from 0.4% of DisplayUtility.screenWidth to 0.25% of DisplayUtility.screenWidth
        if superDeckView.center.x < 0.4*DisplayUtility.screenWidth{
            //fading in with swipe left from 0.4% of DisplayUtility.screenWidth to 0.25% of screen width
            self.disconnectIcon.alpha = -6.66*(superDeckView.center.x/DisplayUtility.screenWidth)+2.66
            //self.disconnectIcon.alpha = 6.66*(superDeckView.center.x/DisplayUtility.screenWidth)
            //self.disconnectIcon.frame = CGRect(x: disconnectIconX, y: 0.33*DisplayUtility.screenHeight, width: 0.4*DisplayUtility.screenWidth, height: 0.4*DisplayUtility.screenWidth)
            self.disconnectIcon.frame = CGRect(x: disconnectIconX, y: 0.33*DisplayUtility.screenHeight, width: 0.4*DisplayUtility.screenWidth, height: 0.4*DisplayUtility.screenWidth)
            //})
        } else if superDeckView.center.x > 0.6*DisplayUtility.screenWidth {
            
            //fading in with swipe right from 0.6% of DisplayUtility.screenWidth to 0.75% of screen width
            self.connectIcon.alpha = 6.66*(superDeckView.center.x/DisplayUtility.screenWidth)-4
            //self.connectIcon.frame = CGRect(x: connectIconX, y: 0.33*DisplayUtility.screenHeight, width: 0.4*DisplayUtility.screenWidth, height: 0.4*DisplayUtility.screenWidth)
            self.connectIcon.frame = CGRect(x: connectIconX, y: 0.33*DisplayUtility.screenHeight, width: 0.4*DisplayUtility.screenWidth, height: 0.4*DisplayUtility.screenWidth)
        } else {
            self.disconnectIcon.alpha = -6.66*(superDeckView.center.x/DisplayUtility.screenWidth)+2.66
            //self.disconnectIcon.frame = CGRect(x: disconnectIconX, y: 0.33*DisplayUtility.screenHeight, width: 0.4*DisplayUtility.screenWidth, height: 0.4*DisplayUtility.screenWidth)
            self.disconnectIcon.frame = CGRect(x: disconnectIconX, y: 0.33*DisplayUtility.screenHeight, width: 0.4*DisplayUtility.screenWidth, height: 0.4*DisplayUtility.screenWidth)
           // self.connectIcon.frame = CGRect(x: connectIconX, y: 0.33*DisplayUtility.screenHeight, width: 0.4*DisplayUtility.screenWidth, height: 0.4*DisplayUtility.screenWidth)
            self.connectIcon.frame = CGRect(x: connectIconX, y: 0.33*DisplayUtility.screenHeight, width: 0.4*DisplayUtility.screenWidth, height: 0.4*DisplayUtility.screenWidth)

            self.connectIcon.alpha = 6.66*(superDeckView.center.x/DisplayUtility.screenWidth)-4
        }
        
        if gesture.state == UIGestureRecognizerState.ended {
            
            if superDeckView.center.x < 0.25*DisplayUtility.screenWidth {
                
                
                let isFirstTimeSwipedLeft : Bool = localData.getFirstTimeSwipingLeft()!
                if isFirstTimeSwipedLeft {
                    //show alert for swiping right here and then bridging or not
                    let alert = UIAlertController(title: "Don't Connect?", message: "Dragging a pair of pictures to the left indicates you do not want to introduce the friends shown.", preferredStyle: UIAlertControllerStyle.alert)
                    //Create the actions
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                        
                    }))
                    alert.addAction(UIAlertAction(title: "Don't Connect", style: .default, handler: { (action) in
                        UIView.animate(withDuration: 0.2, animations: {
                            superDeckView.center.x = -1.0*DisplayUtility.screenWidth
                            self.disconnectIcon.center.x = -1.0*DisplayUtility.screenWidth
                            self.disconnectIcon.alpha = 0.0
                            }, completion: { (success) in
                                self.nextPair()
                        })
                        removeCard = true
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    self.localData.setFirstTimeSwipingLeft(false)
                    self.localData.synchronize()
                } else {
                    UIView.animate(withDuration: 0.2, animations: {
                        superDeckView.center.x = -1.0*DisplayUtility.screenWidth
                        self.disconnectIcon.center.x = -1.0*DisplayUtility.screenWidth
                        self.disconnectIcon.alpha = 0.0
                        }, completion: { (success) in
                            self.nextPair()
                    })
                    removeCard = true
                }
            } else if superDeckView.center.x > 0.75*DisplayUtility.screenWidth {
                
                let isFirstTimeSwipedRight : Bool = localData.getFirstTimeSwipingRight()!
                if isFirstTimeSwipedRight{
                    //show alert for swiping right here and then bridging or not
                    let alert = UIAlertController(title: "Connect?", message: "Dragging a pair of pictures to the right indicates you want to introduce the friends shown.", preferredStyle: UIAlertControllerStyle.alert)
                    //Create the actions
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                        
                    }))
                    alert.addAction(UIAlertAction(title: "Connect", style: .default, handler: { (action) in
                        UIView.animate(withDuration: 0.2, animations: {
                            superDeckView.center.x = 1.6*DisplayUtility.screenWidth
                            superDeckView.alpha = 0.0
                            self.connectIcon.center.x = 1.6*DisplayUtility.screenWidth
                            self.connectIcon.alpha = 0.0
                            }, completion: { (success) in
                                self.connectIcon.removeFromSuperview()
                        })
                        self.bridged()
                        removeCard = true
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    self.localData.setFirstTimeSwipingRight(false)
                    self.localData.synchronize()
                } else {
                    UIView.animate(withDuration: 0.2, animations: {
                        superDeckView.center.x = 1.6*DisplayUtility.screenWidth
                        self.connectIcon.center.x = 1.6*DisplayUtility.screenWidth
                        self.connectIcon.alpha = 0.0
                        }, completion: { (success) in
                            self.connectIcon.removeFromSuperview()
                            self.bridged()
                    })
                    removeCard = true
                }
            }
            if removeCard {
                superDeckView.removeFromSuperview()
            }
            else {
                UIView.animate(withDuration: 0.7, animations: {
                    //var superDeckViewFrame = superDeckView.frame
                    rotation = CGAffineTransform(rotationAngle: 0)
                    stretch = rotation.scaledBy(x: 1, y: 1)
                    superDeckView.transform = stretch
                    superDeckView.frame = CGRect(x: self.superDeckX, y: self.superDeckY, width: self.superDeckWidth, height: self.superDeckHeight)
                    self.disconnectIcon.center.x = -1.0*DisplayUtility.screenWidth
                    self.disconnectIcon.alpha = 0.0
                    self.connectIcon.center.x = 1.6*DisplayUtility.screenWidth
                    self.connectIcon.alpha = 0.0
                })
                
            }
        }
    }
    func bridged(){
        /*var pagingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        pagingSpinner.color = UIColor.lightGrayColor()
        pagingSpinner.hidesWhenStopped = true
        pagingSpinner.center.x = view.center.x
        pagingSpinner.center.y = view.center.y
        view.insertSubview(pagingSpinner, aboveSubview: toolbar)
        pagingSpinner.startAnimating()*/
        let bridgePairings = localData.getPairings()
        if var bridgePairings = bridgePairings {
            var x = 0
            for i in 0 ..< (bridgePairings.count) {
                if self.currentTypeOfCardsOnDisplay == typesOfCard.all || bridgePairings[x].user1?.bridgeType == convertBridgeTypeEnumToBridgeTypeString(self.currentTypeOfCardsOnDisplay) {
                    break
                }
                x = i
            }
            let message = PFObject(className: "Messages")
            let acl = PFACL()
            acl.getPublicReadAccess = true
            acl.getPublicWriteAccess = true
            message.acl = acl

            let currentUserId = PFUser.current()?.objectId
            let currentUserName = (PFUser.current()?["name"] as? String) ?? ""
            message["ids_in_message"] = [(bridgePairings[x].user1?.userId)!, (bridgePairings[x].user2?.userId)!, currentUserId!]
            message["names_in_message"] = [(bridgePairings[x].user1?.name)!, (bridgePairings[x].user2?.name)!, currentUserName]
            let user1FirstName = (bridgePairings[x].user1?.name)!.components(separatedBy: " ").first!
            let user2FirstName = (bridgePairings[x].user2?.name)!.components(separatedBy: " ").first!
            singleMessageTitle = "\(user1FirstName) & \(user2FirstName)"
            message["bridge_builder"] = currentUserId
            var y = [String]()
            y.append(currentUserId as String!)
            message["message_viewed"] = y
            if let necterType = bridgePairings[x].user1?.bridgeType {
                message["message_type"] = necterType
                switch(necterType) {
                case "Business":
                    necterTypeColor = DisplayUtility.businessBlue
                case "Love":
                    necterTypeColor = DisplayUtility.loveRed
                case "Friendship":
                    necterTypeColor = DisplayUtility.friendshipGreen
                default:
                    necterTypeColor = DisplayUtility.necterGray
                }
                

            }
            else {
            message["message_type"] = "Friendship"
            }
            message["lastSingleMessageAt"] = Date()
            // update the no of message in a Thread - Start
            message["no_of_single_messages"] = 1
            var noOfSingleMessagesViewed = [String:Int]()
            noOfSingleMessagesViewed[PFUser.current()!.objectId!] = 1
            message["no_of_single_messages_viewed"] = NSKeyedArchiver.archivedData(withRootObject: noOfSingleMessagesViewed)
            //message.saveInBackground()
            // update the no of message in a Thread - End
            do {
                try message.save()
                let objectId = bridgePairings[x].user1?.objectId
                let query = PFQuery(className:"BridgePairings")
                let notificationMessage1 = PFUser.current()!["name"] as! String + " has connected you with "+bridgePairings[x].user2!.name! + " for " + bridgePairings[x].user2!.bridgeType!
                let notificationMessage2 = PFUser.current()!["name"] as! String + " has connected you with "+bridgePairings[x].user1!.name! + " for " + bridgePairings[x].user2!.bridgeType!
                let userObjectId1 = bridgePairings[x].user1!.userId!
                let userObjectId2 = bridgePairings[x].user2!.userId!
                query.getObjectInBackground(withId: objectId!, block: { (result, error) -> Void in
                    //this should only happen if result can equal result - i.e. in the result if let statement, but the code was not allow for this, so it was taken out and should be tested.
                    if let result = result as? PFObject?{
                        result?["checked_out"] = true
                        result?["bridged"] = true
                        result?.saveInBackground()
                        //when users are introduced, they are added to eachother's friend_lists in the _User table (i.e. they become friends)
                        self.pfCloudFunctions.addIntroducedUsersToEachothersFriendLists(parameters: ["userObjectId1": userObjectId1, "userObjectId2": userObjectId2])
                        self.pfCloudFunctions.pushNotification(parameters: ["userObjectId":userObjectId1,"alert":notificationMessage1, "badge": "Increment", "messageType" : "Bridge", "messageId": message.objectId!])
                        self.pfCloudFunctions.pushNotification(parameters: ["userObjectId":userObjectId2,"alert":notificationMessage2, "badge": "Increment", "messageType" : "Bridge", "messageId": message.objectId!])
                    }
                })
                self.messageId = message.objectId!
            }
            catch {
                
            }
            
            var bridgeType = "All"
            if let bt = bridgePairings[x].user1?.bridgeType {
                bridgeType = bt
            }

            bridgePairings.remove(at: x)
            localData.setPairings(bridgePairings)
            localData.synchronize()
            getBridgePairings(1,typeOfCards: bridgeType, callBack: nil, bridgeType: nil)
            segueToSingleMessage = true
            performSegue(withIdentifier: "showSingleMessage", sender: nil)
            //pagingSpinner.stopAnimating()
            //pagingSpinner.removeFromSuperview()
        }
    }
    func callbackForNextPair(_ bridgeType:String) -> Void {
        if arrayOfCardsInDeck.count > 0 {
            arrayOfCardsInDeck.remove(at: 0)
            arrayOfCardColors.remove(at: 0)
            if arrayOfCardsInDeck.count > 0 {
                arrayOfCardsInDeck[0].isUserInteractionEnabled = true
            }
            else {
                lastCardInStack = nil
                //check if a bridgePairing is already stored in localData
                var bridgePairingAlreadyStored = false
                if currentTypeOfCardsOnDisplay == typesOfCard.all {
                    let pairings = localData.getPairings()
                    if pairings != nil && pairings?.count > 0 {
                        print("bridgePairingAlreadyStored set to true " + String(describing: pairings?.count))
                        bridgePairingAlreadyStored = true
                    }
                }
                else {
                    if let bridgePairings = localData.getPairings() {
                        for pair in bridgePairings {
                            if pair.user1?.bridgeType == convertBridgeTypeEnumToBridgeTypeString(currentTypeOfCardsOnDisplay) {
                                bridgePairingAlreadyStored = true
                            }
                        }
                    }
                }
                
                if bridgePairingAlreadyStored == false {
                    self.displayNoMoreCards()
                    /*//create the alert controller
                    let alert = UIAlertController(title: "Revisit Pairs of Friends?", message: "You have ran out of pairs to connect. Would you like to revisit the ones you passed on?", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                        self.displayNoMoreCards()
                    }))
                    alert.addAction(UIAlertAction(title: "Revisit", style: .default, handler: { (action) in
                        /*NotificationCenter.default.addObserver(self, selector: #selector(self.revitalizeMyPairsHelper), name: NSNotification.Name(rawValue: "revitalizeMyPairsHelper"), object: nil)
                        self.pfCloudFunctions.revitalizeMyPairs(parameters: ["bridgeType":self.convertBridgeTypeEnumToBridgeTypeString(self.currentTypeOfCardsOnDisplay)])
                        self.lastCardInStack = nil
                        self.getBridgePairings(2, typeOfCards: bridgeType, callBack:nil, bridgeType:nil)*/
                        //self.revitalizeMyPairs(bridgeType: bridgeType)
                        self.displayNoMoreCards()
                    }))
                    self.present(alert, animated: true, completion: nil)*/
                }
            }
        }

    }
    func revitalizeMyPairs(_ sender: UIButton!) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.revitalizeMyPairsHelper), name: NSNotification.Name(rawValue: "revitalizeMyPairsHelper"), object: nil)
        self.pfCloudFunctions.revitalizeMyPairs(parameters: ["bridgeType":self.convertBridgeTypeEnumToBridgeTypeString(self.currentTypeOfCardsOnDisplay)])
        self.lastCardInStack = nil
        self.getBridgePairings(2, typeOfCards: self.convertBridgeTypeEnumToBridgeTypeString(self.currentTypeOfCardsOnDisplay), callBack:nil, bridgeType:nil)
    }
    //after response from revitalize pairs, run this code
    func revitalizeMyPairsHelper(_ notification: Notification) {
        print("revitalize pairs from PFCloudFunctions works")
        let message = (notification as NSNotification).userInfo!["message"] as? String
        print(message)
        NotificationCenter.default.removeObserver(self)
    }
    func nextPair(){
        // Remove the pair only from bridgePairings in LocalData but not from arrayOfCards. That would be taken care of in callbackForNextPair. cIgAr - 08/25/16
        let bridgePairings = localData.getPairings()
        if var bridgePairings = bridgePairings {
            var x = 0
            for i in 0 ..< (bridgePairings.count) {
                if self.currentTypeOfCardsOnDisplay == typesOfCard.all || bridgePairings[x].user1?.bridgeType == convertBridgeTypeEnumToBridgeTypeString(self.currentTypeOfCardsOnDisplay) {
                    break
                }
                x = i
                
            }
            let objectId = bridgePairings[x].user1?.objectId
            let query = PFQuery(className:"BridgePairings")
            query.getObjectInBackground(withId: objectId!, block: { (result, error) -> Void in
                if let result = result {
                    result["checked_out"] = false
                    result["bridged"] =  false
                    result.saveInBackground()
                }
            })
            var bridgeType = "All"
            bridgeType = convertBridgeTypeEnumToBridgeTypeString(self.currentTypeOfCardsOnDisplay)
//            if let bt = bridgePairings[x].user1?.bridgeType {
//                bridgeType = bt
//            }
            bridgePairings.remove(at: x)
            
            localData.setPairings(bridgePairings)
            localData.synchronize()
            
            getBridgePairings(1, typeOfCards: bridgeType, callBack: callbackForNextPair, bridgeType:bridgeType)
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NotificationCenter.default.removeObserver(self)
        if segueToSingleMessage {
            segueToSingleMessage = false
            let singleMessageVC:SingleMessageViewController = segue.destination as! SingleMessageViewController
            singleMessageVC.transitioningDelegate = self.transitionManager
            singleMessageVC.isSeguedFromBridgePage = true
            singleMessageVC.newMessageId = self.messageId
            singleMessageVC.singleMessageTitle = singleMessageTitle
            singleMessageVC.seguedFrom = "BridgeViewController"
            singleMessageVC.necterTypeColor = necterTypeColor
            self.transitionManager.animationDirection = "Right"
        }
        else {
            let vc = segue.destination
            let mirror = Mirror(reflecting: vc)
            if mirror.subjectType == ProfileViewController.self {
                self.transitionManager.animationDirection = "Left"
            } else if mirror.subjectType == OptionsFromBotViewController.self {
                self.transitionManager.animationDirection = "Top"
                let vc2 = vc as! OptionsFromBotViewController
                vc2.seguedFrom = "BridgeViewController"
            } else if mirror.subjectType == MessagesViewController.self {
                self.transitionManager.animationDirection = "Right"
            }
            vc.transitioningDelegate = self.transitionManager
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

