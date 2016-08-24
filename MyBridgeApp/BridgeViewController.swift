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
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    //set to the height and width of the images in the superDeck
    let cardWidth = UIScreen.mainScreen().bounds.width - 0.06*UIScreen.mainScreen().bounds.width
    let cardHeight = 0.765*UIScreen.mainScreen().bounds.height*0.5
    //superDeck refers to the swipable rectangel containing the two images of the people to connect
    let superDeckX = 0.03*UIScreen.mainScreen().bounds.width
    let superDeckY = 0.12*UIScreen.mainScreen().bounds.height
    let superDeckWidth = UIScreen.mainScreen().bounds.width - 0.06*UIScreen.mainScreen().bounds.width
    let superDeckHeight = 0.765*UIScreen.mainScreen().bounds.height
    let necterColor = UIColor(red: 255/255, green: 230/255, blue: 57/255, alpha: 1.0)
    var totalNoOfCards = 0
    var stackOfCards = [UIView]()
    let localStorageUtility = LocalStorageUtility()
    var currentTypeOfCardsOnDisplay = typesOfCard.All
    var lastCardInStack:UIView = UIView() // used by downloadMoreCards() to add a card below this
    var displayNoMoreCardsView:UIView? = nil
    let displayNoMoreCardsLabel = UILabel()
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
    
    //navbar creation
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
    
    //necter Colors
    let necterYellow = UIColor(red: 255/255, green: 230/255, blue: 57/255, alpha: 1.0)
    let businessBlue = UIColor(red: 36.0/255, green: 123.0/255, blue: 160.0/255, alpha: 1.0)
    let loveRed = UIColor(red: 242.0/255, green: 95.0/255, blue: 92.0/255, alpha: 1.0)
    let friendshipGreen = UIColor(red: 112.0/255, green: 193.0/255, blue: 179.0/255, alpha: 1.0)
    let necterGray = UIColor(red: 80.0/255.0, green: 81.0/255.0, blue: 79.0/255.0, alpha: 1.0)
    
    enum typesOfCard {
        case All
        case Business
        case Love
        case Friendship
    }
    enum typesOfColor {
        case Business
        case Love
        case Friendship
    }
    func convertBridgeTypeEnumToBridgeTypeString(typeOfCard:typesOfCard) -> String {
        switch (typeOfCard) {
        case typesOfCard.All:
            return "All"
        case typesOfCard.Business:
                 return "Business"
        case typesOfCard.Love:
                return "Love"
        case typesOfCard.Friendship:
                return "Friendship"
        }
    }
    func convertBridgeTypeStringToBridgeTypeEnum(typeOfCard:String) -> typesOfCard {
        switch (typeOfCard) {
        case "All":
            return typesOfCard.All
        case "Business":
            return typesOfCard.Business
        case "Love":
            return typesOfCard.Love
        case "Friendship":
            return typesOfCard.Friendship
        default:
            return typesOfCard.Friendship
        }
    }
    func convertBridgeTypeStringToColorTypeEnum(typeOfCard:String) -> typesOfColor {
            switch (typeOfCard) {
                
            case "Business":
                return typesOfColor.Business
            case "Love":
                return typesOfColor.Love
            case "Friendship":
                return typesOfColor.Friendship
            default :
                return typesOfColor.Business
            }

    }
    func getCGColor (color:typesOfColor) -> CGColor {
        switch(color) {
        case typesOfColor.Business:
            return businessBlue.CGColor
        case typesOfColor.Love:
            return  loveRed.CGColor
        case typesOfColor.Friendship:
            return  friendshipGreen.CGColor
        }
        
    }
    func setCityName(locationLabel: UILabel, locationCoordinates:[Double], pairing:UserInfoPair) {
        // We will store the city names to LocalData.  Not required now. But will ne be needed in fututre when when optimize. 
        if locationLabel.tag == 0 && pairing.user1?.city != nil {
            dispatch_async(dispatch_get_main_queue(), {
                locationLabel.text = (pairing.user1?.city)!
            })
        }
        else if  locationLabel.tag == 1 && pairing.user2?.city != nil {
            dispatch_async(dispatch_get_main_queue(), {
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
                    dispatch_async(dispatch_get_main_queue(), {
                        locationLabel.text = pm.locality
                    })
                }
                else {
                    print("Problem with the data received from geocoder")
                }
            })
        }
    }
    func displayToolBar(){
        
        toolbar.frame = CGRectMake(0, 0.9*screenHeight, screenWidth, 0.1*screenHeight)
        toolbar.backgroundColor = UIColor(red: 247/255.0, green: 247/255.0, blue: 247/255.0, alpha: 1.0)

        //creating buttons to be added to the toolbar and evenly spaced across
        allTypesButton.setImage(UIImage(named: "All_Types_Icon_Gray"), forState: .Normal)
        allTypesButton.setImage(UIImage(named: "All_Types_Icon_Colors"), forState: .Disabled)
        allTypesButton.frame = CGRect(x: 0.07083*screenWidth, y: 0, width: 0.1*screenWidth, height: 0.1*screenWidth)
        allTypesButton.center.y = toolbar.center.y - 0.005*screenHeight
        allTypesButton.addTarget(self, action: #selector(filterTapped), forControlEvents: .TouchUpInside)
        allTypesButton.tag = 0
        
        //coloring allTypesText three different colors
        let allTypesText = "All Types" as NSString
        var allTypesAttributedText = NSMutableAttributedString(string: allTypesText as String, attributes: [NSFontAttributeName: UIFont.init(name: "BentonSans", size: 11)!])
        allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: businessBlue , range: allTypesText.rangeOfString("All"))
        allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: loveRed , range: allTypesText.rangeOfString("Ty"))
        allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: friendshipGreen , range: allTypesText.rangeOfString("pes"))
        
        //setting allTypesText
        allTypesLabel.attributedText = allTypesAttributedText
        allTypesLabel.textAlignment =  NSTextAlignment.Center
        allTypesLabel.frame = CGRect(x: 0, y: 0.975*screenHeight, width: 0.2*screenWidth, height: 0.02*screenHeight)
        allTypesLabel.center.x = allTypesButton.center.x

        
        businessButton.setImage(UIImage(named: "Business_Icon_Gray"), forState: .Normal)
        businessButton.setImage(UIImage(named:  "Business_Icon_Blue"), forState: .Disabled)
        businessButton.frame = CGRect(x: 0.24166*screenWidth, y: 0, width: 0.1*screenWidth, height: 0.1*screenWidth)
        businessButton.center.y = toolbar.center.y - 0.005*screenHeight
        businessButton.addTarget(self, action: #selector(filterTapped), forControlEvents: .TouchUpInside)
        businessButton.tag = 1
        
        businessLabel.text = "Business"
        businessLabel.textColor = necterGray
        businessLabel.font = UIFont(name: "BentonSans", size: 11)
        businessLabel.textAlignment =  NSTextAlignment.Center
        businessLabel.frame = CGRect(x: 0, y: 0.975*screenHeight, width: 0.2*screenWidth, height: 0.02*screenHeight)
        businessLabel.center.x = businessButton.center.x
        
        loveButton.setImage(UIImage(named: "Love_Icon_Gray"), forState: .Normal)
        loveButton.setImage(UIImage(named: "Love_Icon_Red"), forState: .Disabled)
        loveButton.frame = CGRect(x: 0.65832*screenWidth, y: 0, width: 0.1*screenWidth, height: 0.1*screenWidth)
        loveButton.center.y = toolbar.center.y - 0.005*screenHeight
        loveButton.addTarget(self, action: #selector(filterTapped), forControlEvents: .TouchUpInside)
        loveButton.tag = 2
        
        loveLabel.text = "Love"
        loveLabel.font = UIFont(name: "BentonSans", size: 11)
        loveLabel.textColor = necterGray
        loveLabel.textAlignment =  NSTextAlignment.Center
        loveLabel.frame = CGRect(x: 0, y: 0.975*screenHeight, width: 0.2*screenWidth, height: 0.02*screenHeight)
        loveLabel.center.x = loveButton.center.x
        
        friendshipButton.setImage(UIImage(named: "Friendship_Icon_Gray"), forState: .Normal)
        friendshipButton.setImage(UIImage(named:  "Friendship_Icon_Green"), forState: .Disabled)
        friendshipButton.frame = CGRect(x: 0.82915*screenWidth, y: 0, width: 0.1*screenWidth, height: 0.1150*screenWidth)
        friendshipButton.center.y = toolbar.center.y - 0.005*screenHeight
        friendshipButton.addTarget(self, action: #selector(filterTapped), forControlEvents: .TouchUpInside)
        friendshipButton.tag = 3
        
        friendshipLabel.text = "Friendship"
        friendshipLabel.font = UIFont(name: "BentonSans", size: 11)
        friendshipLabel.textColor = necterGray
        friendshipLabel.textAlignment =  NSTextAlignment.Center
        friendshipLabel.frame = CGRect(x: 0, y: 0.975*screenHeight, width: 0.2*screenWidth, height: 0.02*screenHeight)
        friendshipLabel.center.x = friendshipButton.center.x

        
        postStatusButton.frame = CGRect(x: 0, y: 0, width: 0.175*screenWidth, height: 0.175*screenWidth)
        postStatusButton.backgroundColor = necterYellow
        postStatusButton.showsTouchWhenHighlighted = true
        postStatusButton.layer.borderWidth = 2.0
        postStatusButton.layer.borderColor = UIColor.whiteColor().CGColor
        postStatusButton.layer.cornerRadius = postStatusButton.frame.size.width/2.0
        postStatusButton.clipsToBounds = true
        //loveButton.layer.borderColor =
        postStatusButton.center.y = toolbar.center.y - 0.25*0.175*screenWidth
        postStatusButton.center.x = view.center.x
        postStatusButton.setTitle("+", forState: .Normal)
        postStatusButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        postStatusButton.titleLabel?.font = UIFont(name: "Verdana", size: 26)
        postStatusButton.addTarget(self, action: #selector(postStatusTapped), forControlEvents: .TouchUpInside)
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
    
    func displayNoMoreCards() {
        let labelFrame: CGRect = CGRectMake(0,0, 0.8*screenWidth,screenHeight * 0.2)
        displayNoMoreCardsLabel.frame = labelFrame
        displayNoMoreCardsLabel.numberOfLines = 0
        
        if businessButton.enabled == false {
            displayNoMoreCardsLabel.text = "You ran out of people to connect for business. Please check back tomorrow."
        } else if loveButton.enabled == false {
            displayNoMoreCardsLabel.text = "You ran out of people to connect for love. Please check back tomorrow."
        } else if friendshipButton.enabled == false {
            displayNoMoreCardsLabel.text = "You ran out of people to connect for friendship. Please check back tomorrow."
        } else {
            displayNoMoreCardsLabel.text = "You ran out of people to connect. Please check back tomorrow."
        }
        
        displayNoMoreCardsLabel.font = UIFont(name: "BentonSans", size: 20)
        displayNoMoreCardsLabel.textAlignment = NSTextAlignment.Center
        displayNoMoreCardsLabel.center.y = view.center.y
        displayNoMoreCardsLabel.center.x = view.center.x
        displayNoMoreCardsLabel.layer.borderWidth = 2
        displayNoMoreCardsLabel.layer.borderColor = necterGray.CGColor
        displayNoMoreCardsLabel.layer.cornerRadius = 15

        view.addSubview(displayNoMoreCardsLabel)
        
    }
    func getUpperDeckCardFrame() -> CGRect {
        let upperDeckFrame : CGRect = CGRectMake(0, 0, superDeckWidth, 0.5*superDeckHeight)
        return upperDeckFrame
    }
    func getLowerDeckCardFrame() -> CGRect {
        let lowerDeckFrame : CGRect = CGRectMake(0, 0.5*superDeckHeight, superDeckWidth, 0.5*superDeckHeight)
        return lowerDeckFrame
    }
    func getUpperDeckCard(name:String, location:String, status:String, photo:NSData, cardColor:typesOfColor, locationCoordinates:[Double], pairing: UserInfoPair) -> UIView{
        let frame = getUpperDeckCardFrame()
        return getCard(frame, name: name, location: location, status: status, photo: photo, cardColor: cardColor, locationCoordinates:locationCoordinates, pairing: pairing, tag: 0)
        
    }
    func getLowerDeckCard(name:String, location:String, status:String, photo:NSData, cardColor:typesOfColor, locationCoordinates:[Double], pairing: UserInfoPair) -> UIView{
        let frame = getLowerDeckCardFrame()
        return getCard(frame, name: name, location: location, status: status, photo: photo, cardColor: cardColor, locationCoordinates:locationCoordinates, pairing: pairing, tag:1)
    }
    func getCard(deckFrame:CGRect, name:String, location:String, status:String, photo:NSData, cardColor:typesOfColor, locationCoordinates:[Double], pairing:UserInfoPair, tag:Int) -> UIView {
        
        let locationFrame = CGRectMake(0.05*cardWidth,0.17*cardHeight,0.8*cardWidth,0.075*cardHeight)
        let statusFrame = CGRectMake(0.05*cardWidth,0.65*cardHeight,0.9*cardWidth,0.3*cardHeight)
        let photoFrame = CGRectMake(0, 0, superDeckWidth, 0.5*superDeckHeight)
        
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.textAlignment = NSTextAlignment.Left
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.font = UIFont(name: "Verdana", size: 20)
        let adjustedNameSize = nameLabel.sizeThatFits(CGSize(width: 0.8*cardWidth, height: 0.12*cardHeight))
        var nameFrame = CGRectMake(0.05*cardWidth,0.05*cardHeight,0.8*cardWidth,0.1*cardHeight)
        nameFrame.size = adjustedNameSize
        nameFrame.size.height = 0.1*cardHeight
        nameLabel.frame = nameFrame
        nameLabel.layer.cornerRadius = 2
        nameLabel.clipsToBounds = true
        
        nameLabel.layer.shadowOpacity = 0.5
        nameLabel.layer.shadowRadius = 0.5
        nameLabel.layer.shadowColor = UIColor.blackColor().CGColor
        nameLabel.layer.shadowOffset = CGSizeMake(0.0, -0.5)
        
        
        let locationLabel = UILabel(frame: locationFrame)
        locationLabel.tag = tag
        if location == "" {
            setCityName(locationLabel, locationCoordinates: locationCoordinates, pairing:pairing)
        }
        locationLabel.text = location
        locationLabel.textAlignment = NSTextAlignment.Left
        locationLabel.textColor = UIColor.whiteColor()
        locationLabel.font = UIFont(name: "Verdana", size: 14)
        locationLabel.layer.shadowOpacity = 0.5
        locationLabel.layer.shadowRadius = 0.5
        locationLabel.layer.shadowColor = UIColor.blackColor().CGColor
        locationLabel.layer.shadowOffset = CGSizeMake(0.0, -0.5)
        
        let statusLabel = UILabel(frame: statusFrame)
        statusLabel.text = "\"\(status)\""
        statusLabel.textColor = UIColor.whiteColor()
        statusLabel.font = UIFont(name: "Verdana", size: 14)
        statusLabel.textAlignment = NSTextAlignment.Center
        statusLabel.numberOfLines = 0
        statusLabel.layer.shadowOpacity = 0.5
        statusLabel.layer.shadowRadius = 0.5
        statusLabel.layer.shadowColor = UIColor.blackColor().CGColor
        statusLabel.layer.shadowOffset = CGSizeMake(0.0, -0.5)
        
        let photoView = UIImageView(frame: photoFrame)
        photoView.image = UIImage(data: photo)
        photoView.contentMode = UIViewContentMode.ScaleAspectFill
        photoView.clipsToBounds = true
        
        let card = UIView(frame:deckFrame)
        
        card.addSubview(photoView)
        card.addSubview(nameLabel)
        card.addSubview(locationLabel)
        card.addSubview(statusLabel)
        
        return card
        
    }
    func addCardPairView(aboveView:UIView?, name:String, location:String, status:String, photo:NSData, locationCoordinates1:[Double], name2:String, location2:String, status2:String, photo2:NSData, locationCoordinates2:[Double], cardColor:typesOfColor, pairing:UserInfoPair) -> UIView{
        
        let upperDeckCard = getUpperDeckCard(name, location: location, status: status, photo: photo, cardColor: cardColor, locationCoordinates:locationCoordinates1, pairing:pairing)
        let lowerDeckCard = getLowerDeckCard(name2, location: location2, status: status2, photo: photo2, cardColor: cardColor,locationCoordinates:locationCoordinates2, pairing:pairing)
        let superDeckFrame : CGRect = CGRectMake(superDeckX, superDeckY, superDeckWidth, superDeckHeight)
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
        necterTypeIcon.contentMode = UIViewContentMode.ScaleAspectFill
        necterTypeIcon.clipsToBounds = true
        
        necterTypeIcon.layer.shadowOpacity = 0.5
        necterTypeIcon.layer.shadowRadius = 0.5
        necterTypeIcon.layer.shadowColor = UIColor.blackColor().CGColor
        necterTypeIcon.layer.shadowOffset = CGSizeMake(0.0, -0.5)
        
        if cardColor == typesOfColor.Business {
            necterTypeLine.backgroundColor = businessBlue
            //rightNecterTypeLine.backgroundColor = businessBlue
            necterTypeIcon.image = UIImage(named: "Business_Icon_Blue")
        } else if cardColor == typesOfColor.Love {
            necterTypeLine.backgroundColor = loveRed
            //rightNecterTypeLine.backgroundColor = loveRed
            necterTypeIcon.image = UIImage(named: "Love_Icon_Red")
        } else if cardColor == typesOfColor.Friendship{
            necterTypeLine.backgroundColor = friendshipGreen
            //rightNecterTypeLine.backgroundColor = friendshipGreen
            necterTypeIcon.image = UIImage(named: "Friendship_Icon_Green")
        }
        
        superDeckView.addSubview(necterTypeLine)
        //superDeckView.addSubview(rightNecterTypeLine)
        superDeckView.addSubview(necterTypeIcon)
        
        
        superDeckView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(1.0)
        //superDeckView.layer.borderWidth = 4
        //superDeckView.layer.borderColor = getCGColor(cardColor)
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(BridgeViewController.isDragged(_:)))
        superDeckView.addGestureRecognizer(gesture)
        superDeckView.userInteractionEnabled = true
        if let aboveView = aboveView {
            superDeckView.userInteractionEnabled = false
            self.view.insertSubview(superDeckView, belowSubview: aboveView)
        }
        else {
            self.view.insertSubview(superDeckView, belowSubview: self.toolbar)
        }
        arrayOfCardsInDeck.append(superDeckView)
        arrayOfCardColors.append(superDeckView.layer.borderColor!)
        stackOfCards.append(superDeckView)
        return superDeckView
    }
    
    func displayCards(){
        if let displayNoMoreCardsView = displayNoMoreCardsView {
            displayNoMoreCardsView.removeFromSuperview()
            
            self.displayNoMoreCardsView = nil
        }
        arrayOfCardsInDeck = [UIView]()
        arrayOfCardColors = [CGColor]()
        var j = 0
        let bridgePairings = LocalData().getPairings()
        if let bridgePairings = bridgePairings {
            var aboveView:UIView? = nil
        for i in 0..<bridgePairings.count {
            let pairing = bridgePairings[i]
            if self.currentTypeOfCardsOnDisplay != typesOfCard.All && pairing.user1?.bridgeType != convertBridgeTypeEnumToBridgeTypeString(self.currentTypeOfCardsOnDisplay) {
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
            var photo1 = NSData()
            var photo2 = NSData()
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
                status1 = "Nah"
            }
            if let bridgeStatus = pairing.user2?.bridgeStatus {
                status2 = bridgeStatus
            }
            else {
                status2 = "Nah"
            }
            if let mainProfilePicture = pairing.user1?.mainProfilePicture {
                photo1 = mainProfilePicture
            }
            else {
                //let mainProfilePicture = UIImagePNGRepresentation(UIImage(named: "bridgeVector.jpg")!)!
                //photo1 =  mainProfilePicture
            }
            if let mainProfilePicture = pairing.user2?.mainProfilePicture {
                photo2 = mainProfilePicture
            }
            else {
                //let mainProfilePicture = UIImagePNGRepresentation(UIImage(named: "bridgeVector.jpg")!)!
               // photo2 =  mainProfilePicture
            }
            let color = convertBridgeTypeStringToColorTypeEnum((pairing.user1?.bridgeType)!)
            
            aboveView = addCardPairView(aboveView, name: name1, location: location1, status: status1, photo: photo1,locationCoordinates1: locationCoordinates1, name2: name2, location2: location2, status2: status2, photo2: photo2,locationCoordinates2: locationCoordinates2, cardColor: color, pairing:pairing)
            lastCardInStack = aboveView!
        }
        
        }
        if  j == 0 {
            displayNoMoreCards()
        }
        
    }
    func getBridgePairingsFromCloud(maxNoOfCards:Int, typeOfCards:String){
        let q = PFQuery(className: "_User")
        var flist = [String]()
        do {
            let object = try q.getObjectWithId((PFUser.currentUser()?.objectId)!)
            //        q.getObjectInBackgroundWithId((PFUser.currentUser()?.objectId)!){
            //            (object, error) -> Void in
            //if error == nil && object != nil {
            if let fl = object["friend_list"] as? [String]{
                flist = fl
                let bridgePairings = LocalData().getPairings()
                var pairings = [UserInfoPair]()
                if (bridgePairings != nil) {
                    pairings = bridgePairings!
                }
                if let _ = PFUser.currentUser()?.objectId {
                    var getMorePairings = true
                    var i = 1
                    while getMorePairings {
                        let query = PFQuery(className:"BridgePairings")
                        
                        //                if let friendlist = (PFUser.currentUser()?["friend_list"] as? [String]) {
                        //                    flist = friendlist
                        //                }
                        query.whereKey("user_objectIds", containedIn :flist)
                        query.whereKey("user_objectIds", notEqualTo:(PFUser.currentUser()?.objectId)!) //change this to notEqualTo
                        query.whereKey("checked_out", equalTo: false)
                        query.whereKey("shown_to", notEqualTo:(PFUser.currentUser()?.objectId)!)
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
                        do {
                            let results = try query.findObjects()
                            
                            
                            // query.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                            //if let results = results {
                            print("Hi")
                            for result in results {
                                var user1:PairInfo? = nil
                                var user2:PairInfo? = nil
                                var name1:String? = nil
                                var name2:String? = nil
                                var userId1:String? = nil
                                var userId2:String? = nil
                                if let ob = result["user_objectIds"] as? [String] {
                                    userId1 =  ob[0]
                                    userId2 =  ob[1]
                                    /* Performing this important check here to make sure that each individual in the pair is friend's with the current user. Parse query -"query.whereKey("user_objectIds", containedIn :flist)" returns true even if anyone of those user's is friend with the current user - cIgAr - 08/18/16*/
//                                    if flist.indexOf(userId1!) == nil || flist.indexOf(userId2!) == nil {
//                                        continue
//                                    }
                                }
                                
                                if let ob = result["user1_name"] {
                                    name1 = ob as? String
                                    
                                }
                                if let ob = result["user2_name"] {
                                    name2 = ob as? String
                                }
                                print("name2 - \(name2)")
                                var location1:[Double]? = nil
                                var location2:[Double]? = nil
                                print(result["user_locations"])
                                
                                if let ob = result["user_locations"] as? [AnyObject]{
                                    if let x = ob[0] as? PFGeoPoint{
                                        location1 = [x.latitude,x.longitude]
                                    }
                                    if let x = ob[1] as? PFGeoPoint{
                                        location2 = [x.latitude,x.longitude]
                                    }
                                    print("location1-\(location1),location2- \(location2)")
                                }
                                print("location1 - \(location2)")
                                var profilePicture1:NSData? = nil
                                var profilePicture2:NSData? = nil
                                
                                
                                if let ob = result["user1_profile_picture"] {
                                    let main_profile_picture_file = ob as! PFFile
                                    profilePicture1 = try main_profile_picture_file.getData()
                                }
                                if let ob = result["user2_profile_picture"] {
                                    let main_profile_picture_file = ob as! PFFile
                                    profilePicture2 = try main_profile_picture_file.getData()
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
                                        let s = (PFUser.currentUser()?.objectId)! as String
                                        ar.append(s)
                                        result["shown_to"] = ar
                                    }
                                    else {
                                        result["shown_to"] = [(PFUser.currentUser()?.objectId)!]
                                    }
                                }
                                else {
                                    result["shown_to"] = [(PFUser.currentUser()?.objectId)!]
                                }
                                result.saveInBackground()
                                
                                user1 = PairInfo(name:name1, mainProfilePicture: profilePicture1, profilePictures: nil,location: location1, bridgeStatus: bridgeStatus1, objectId: objectId1,  bridgeType: bridgeType1, userId: userId1, city: city1)
                                user2 = PairInfo(name:name2, mainProfilePicture: profilePicture2, profilePictures: nil,location: location2, bridgeStatus: bridgeStatus2, objectId: objectId2,  bridgeType: bridgeType2, userId: userId2, city: city2)
                                let userInfoPair = UserInfoPair(user1: user1, user2: user2)
                                pairings.append(userInfoPair)
                                print("userId1, userId2 - \(userId1),\(userId2)")
                                
                            }
                            let localData = LocalData()
                            localData.setPairings(pairings)
                            localData.synchronize()
                            
                            
                        }
                        catch {
                            
                        }
                        i += 1
                        if i > 3 || typeOfCards != "EachOfAllType"{
                            getMorePairings = false
                        }
                        
                        
                    }
                }
            }
        }
        catch {
            
        }
        //}
        //}
    }
    func downloadMoreCards(noOfCards:Int, typeOfCards:String) -> Int{
        var count = 0
        let c = self.bridgePairings?.count
        if let c = c {
            if c > 0 {
                count = c
            }
        }
        getBridgePairingsFromCloud(noOfCards,typeOfCards: typeOfCards)
        bridgePairings = LocalData().getPairings()
        
        if let bridgePairings = bridgePairings {
        //print("bridgePairings.count - \(bridgePairings.count)")
        totalNoOfCards += bridgePairings.count - c!
        var aboveView = lastCardInStack
        for i in count ..< (bridgePairings.count) {
            let pairing = bridgePairings[i]
            if self.currentTypeOfCardsOnDisplay != typesOfCard.All && pairing.user1?.bridgeType != convertBridgeTypeEnumToBridgeTypeString(self.currentTypeOfCardsOnDisplay) {
                continue
            }
            var name1 = String()
            var name2 = String()
            var location1 = String()
            var location2 = String()
            var status1 = String()
            var status2 = String()
            var photo1 = NSData()
            var photo2 = NSData()
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
                location1 = "Location not set"
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
                status1 = "Nah"
            }
            if let bridgeStatus = pairing.user2?.bridgeStatus {
                status2 = bridgeStatus
            }
            else {
                status2 = "Nah"
            }
            if let mainProfilePicture = pairing.user1?.mainProfilePicture {
                photo1 = mainProfilePicture
            }
            else {
                let mainProfilePicture = UIImagePNGRepresentation(UIImage(named: "bridgeVector.jpg")!)!
                photo1 =  mainProfilePicture
            }
            if let mainProfilePicture = pairing.user2?.mainProfilePicture {
                photo2 = mainProfilePicture
            }
            else {
               // let mainProfilePicture = UIImagePNGRepresentation(UIImage(named: "bridgeVector.jpg")!)!
                //photo2 =  mainProfilePicture
            }
            let color = convertBridgeTypeStringToColorTypeEnum((pairing.user1?.bridgeType)!)
            
            aboveView = addCardPairView(aboveView, name: name1, location: location1, status: status1, photo: photo1, locationCoordinates1: locationCoordinates1, name2: name2, location2: location2, status2: status2, photo2: photo2, locationCoordinates2: locationCoordinates2, cardColor: color, pairing:pairing)
            lastCardInStack = aboveView
        }   
        }
        if let _ = bridgePairings{
            return bridgePairings!.count - count
        }
        else {
            return 0
        }
        
        
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
    func updateNoOfUnreadMessagesIcon(notification: NSNotification) {
        
        let aps = notification.userInfo!["aps"] as? NSDictionary
        badgeCount = (aps!["badge"] as? Int)!
        //print("Listened at updateNoOfUnreadMessagesIcon - \(badge)")
        dispatch_async(dispatch_get_main_queue(), {
            
            if self.badgeCount != 0 {
                //self.iconLabel.text = String(self.badgeCount)
                //self.displayNavigationBar()
                self.messagesButton.setImage(UIImage(named: "Messages_Icon_Gray_Notification"), forState: .Normal)
                self.messagesButton.setImage(UIImage(named: "Messages_Icon_Yellow_Notification"), forState: .Highlighted)
                self.messagesButton.setImage(UIImage(named: "Messages_Icon_Yellow_Notification"), forState: .Selected)
                self.navItem.rightBarButtonItem = UIBarButtonItem(customView: self.messagesButton)
                self.navigationBar.setItems([self.navItem], animated: false)
                print("got message")
            }
            
            
        })
        
        
    }
    func displayNavigationBar(){
        
        //setting the profileIcon to the leftBarButtonItem
        let profileIcon = UIImage(named: "Profile_Icon_Gray")
        profileButton.setImage(profileIcon, forState: .Normal)
        profileButton.setImage(UIImage(named: "Profile_Icon_Yellow"), forState: .Selected)
        profileButton.setImage(UIImage(named: "Profile_Icon_Yellow"), forState: .Highlighted)
        profileButton.addTarget(self, action: #selector(profileTapped(_:)), forControlEvents: .TouchUpInside)
        profileButton.frame = CGRect(x: 0, y: 0, width: 0.085*screenWidth, height: 0.085*screenWidth)
        var leftBarButton = UIBarButtonItem(customView: profileButton)
        navItem.leftBarButtonItem = leftBarButton
        
        //setting the messagesIcon to the rightBarButtonItem
        var messagesIcon = UIImage()
        //setting messagesIcon to the icon specifying if there are or are not notifications
        if badgeCount == 0 {
            messagesButton.setImage(UIImage(named: "Messages_Icon_Gray"), forState: .Normal)
            messagesButton.setImage(UIImage(named: "Messages_Icon_Yellow"), forState: .Selected)
            messagesButton.setImage(UIImage(named: "Messages_Icon_Yellow"), forState: .Highlighted)
        } else {
            messagesButton.setImage(UIImage(named: "Messages_Icon_Gray_Notification"), forState: .Normal)
            messagesButton.setImage(UIImage(named: "Messages_Icon_Yellow_Notification"), forState: .Highlighted)
            messagesButton.setImage(UIImage(named: "Messages_Icon_Yellow_Notification"), forState: .Selected)
        }
        
        messagesButton.addTarget(self, action: #selector(messagesTapped(_:)), forControlEvents: .TouchUpInside)
        messagesButton.frame = CGRect(x: 0, y: 0, width: 0.085*screenWidth, height: 0.085*screenWidth)
        messagesButton.contentMode = UIViewContentMode.ScaleAspectFill
        messagesButton.clipsToBounds = true
        var rightBarButton = UIBarButtonItem(customView: messagesButton)
        navItem.rightBarButtonItem = rightBarButton
        
        //setting the navBar color and title
        navigationBar.setItems([navItem], animated: false)
        //navigationBar.topItem?.title = "necter"
        let navBarTitle = UILabel()
        navBarTitle.frame = CGRect(x: 0, y: 0, width: 0.4*screenWidth, height: 0.1*screenHeight)
        navBarTitle.center.x = navigationBar.center.x
        navBarTitle.center.y = navigationBar.center.y
        navBarTitle.text = "necter"
        navBarTitle.font = UIFont(name: "Verdana", size: 34)
        navBarTitle.textColor = necterYellow
        navBarTitle.textAlignment = NSTextAlignment.Center
        
        navigationBar.topItem?.titleView = navBarTitle
        navigationBar.barStyle = .Black
        navigationBar.barTintColor = UIColor.whiteColor()
        
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
    func profileTapped(sender: UIBarButtonItem) {
        profileButton.selected = true
        performSegueWithIdentifier("showProfilePageFromBridgeView", sender: self)
    }
    
    func messagesTapped(sender: UIBarButtonItem) {
        messagesButton.selected = true
        performSegueWithIdentifier("showMessagesPageFromBridgeView", sender: self)
    }
    func displayMessageFromBot(notification: NSNotification) {
        let botNotificationView = UIView()
        botNotificationView.frame = CGRect(x: 0, y: -0.12*self.screenHeight, width: self.screenWidth, height: 0.12*self.screenHeight)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = botNotificationView.bounds
        //blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let messageLabel = UILabel(frame: CGRect(x: 0.05*screenWidth, y: 0.01*screenHeight, width: 0.9*screenWidth, height: 0.11*screenHeight))
        messageLabel.text = notification.userInfo!["message"] as? String ?? "No Message Came Up"
        messageLabel.textColor = UIColor.darkGrayColor()
        messageLabel.font = UIFont(name: "Verdana-Bold", size: 14)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = NSTextAlignment.Center
        //botNotificationView.backgroundColor = necterYellow
        
        //botNotificationView.addSubview(blurEffectView)
        botNotificationView.addSubview(messageLabel)
        botNotificationView.insertSubview(blurEffectView, belowSubview: messageLabel)
        view.insertSubview(botNotificationView, aboveSubview: navigationBar)
        
        
        UIView.animateWithDuration(0.7) {
            botNotificationView.frame.origin.y = 0
        }
        
        let _ = Timer(interval: 4) {i -> Bool in
            UIView.animateWithDuration(0.7, animations: {
                botNotificationView.frame.origin.y = -0.12*self.screenHeight
            })
            return i < 1
        }
        
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        //botNotificationView.removeFromSuperview()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //        while localStorageUtility.waitForCardsToBeDownloaded(){
        //
        //        }
        //
        
        
//        localStorageUtility.getBridgePairingsFromCloud()
//        bridgePairings = LocalData().getPairings()
        
        //NSNotificationCenter.defaultCenter().removeObserver(self, name: "updateBridgePage", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.displayMessageFromBot), name: "displayMessageFromBot", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updateNoOfUnreadMessagesIcon), name: "updateBridgePage", object: nil)

        bridgePairings = LocalData().getPairings()
        if (bridgePairings == nil || bridgePairings?.count < 1) {
            getBridgePairingsFromCloud(2,typeOfCards: "EachOfAllType")
            bridgePairings = LocalData().getPairings()
        }
        
        displayNavigationBar()
        displayToolBar()
        displayCards()
        allTypesButton.enabled = false
        let query: PFQuery = PFQuery(className: "Messages")
        query.whereKey("ids_in_message", containsString: PFUser.currentUser()?.objectId)
        query.cachePolicy = .NetworkElseCache
        query.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
            if error == nil {
                if let results = results {
                self.badgeCount = 0
                for i in 0..<results.count{
                    let result = results[i]
                    if var noOfSingleMessagesViewed = NSKeyedUnarchiver.unarchiveObjectWithData(result["no_of_single_messages_viewed"] as! NSData)! as? [String:Int] {
                        let noOfMessagesViewed = noOfSingleMessagesViewed[(PFUser.currentUser()?.objectId)!] ?? 0
                        self.badgeCount += (result["no_of_single_messages"] as! Int) - noOfMessagesViewed
                    }
                }
                    dispatch_async(dispatch_get_main_queue(), {
                        //self.badgeCount = 0
                        if self.badgeCount != 0 {
                            //setting the iconLabel to the number of notifications -> this has been removed
                            //self.iconLabel.text = String(self.badgeCount)
                            //setting the messagesIcon to the notification rightBarButtonItem
                            //self.displayNavigationBar()
                            self.messagesButton.setImage(UIImage(named: "Messages_Icon_Gray_Notification"), forState: .Normal)
                            self.messagesButton.setImage(UIImage(named: "Messages_Icon_Yellow_Notification"), forState: .Highlighted)
                            self.messagesButton.setImage(UIImage(named: "Messages_Icon_Yellow_Notification"), forState: .Selected)
                            self.navItem.rightBarButtonItem = UIBarButtonItem(customView: self.messagesButton)
                            self.navigationBar.setItems([self.navItem], animated: false)
                        } else {
                            //self.iconLabel.text = ""
                            //self.displayNavigationBar()
                            self.messagesButton.setImage(UIImage(named: "Messages_Icon_Gray"), forState: .Normal)
                            self.messagesButton.setImage(UIImage(named: "Messages_Icon_Yellow"), forState: .Highlighted)
                            self.messagesButton.setImage(UIImage(named: "Messages_Icon_Yellow"), forState: .Selected)

                            self.navItem.rightBarButtonItem = UIBarButtonItem(customView: self.messagesButton)
                            self.navigationBar.setItems([self.navItem], animated: false)
                        }
                    })

                }
            }
        })
        
        connectIcon.image = UIImage(named: "Necter_Icon")
        connectIcon.frame = CGRect(x: 0.6*screenWidth+10, y: 0.33*self.screenHeight, width: 0.4*screenWidth, height: 0.4*screenWidth)
        connectIcon.alpha = 0.0
        view.insertSubview(connectIcon, aboveSubview: self.toolbar)
        
        disconnectIcon.image = UIImage(named: "Disconnect_Icon")
        disconnectIcon.frame = CGRect(x: 0, y: 0.33*self.screenHeight, width: 0.4*self.screenWidth, height: 0.4*self.screenWidth)
        //CGRect(x: -10, y: 0.33*self.screenHeight, width: 0.4*self.screenWidth, height: 0.4*self.screenWidth)
        disconnectIcon.alpha = 0.0
        view.insertSubview(disconnectIcon, aboveSubview: self.toolbar)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidLayoutSubviews() {
   
        navigationBar.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 0.11*screenHeight)

    }
    
    func postStatusTapped(sender: UIButton ){
        print("Post Tapped")
        performSegueWithIdentifier("showNewStatusViewController", sender: self)
        //presentViewController(vc!, animated: true, completion: nil)
    }
    
    func filterTapped(sender: UIButton){
        //print(currentTypeOfCardsOnDisplay)
        let tag = sender.tag
        switch(tag){
            case 0:
                currentTypeOfCardsOnDisplay = convertBridgeTypeStringToBridgeTypeEnum("All")
                
                //updating which toolbar Button is selected
                allTypesButton.enabled = false
                businessButton.enabled = true
                loveButton.enabled = true
                friendshipButton.enabled = true
                
                //updating textColor necter-Type labels
                let allTypesText = "All Types" as NSString
                var allTypesAttributedText = NSMutableAttributedString(string: allTypesText as String, attributes: [NSFontAttributeName: UIFont.init(name: "BentonSans", size: 11)!])
                allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: businessBlue , range: allTypesText.rangeOfString("All"))
                allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: loveRed , range: allTypesText.rangeOfString("Ty"))
                allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: friendshipGreen , range: allTypesText.rangeOfString("pes"))
                allTypesLabel.attributedText = allTypesAttributedText
                businessLabel.textColor = necterGray
                loveLabel.textColor = necterGray
                friendshipLabel.textColor = necterGray
                    break
            case 1:
                currentTypeOfCardsOnDisplay = convertBridgeTypeStringToBridgeTypeEnum("Business")
                
                //updating which toolbar Button is selected
                allTypesButton.enabled = true
                businessButton.enabled = false
                loveButton.enabled = true
                friendshipButton.enabled = true
                
                //updating textColor necter-Type labels
                let allTypesText = "All Types" as NSString
                var allTypesAttributedText = NSMutableAttributedString(string: allTypesText as String, attributes: [NSFontAttributeName: UIFont.init(name: "BentonSans", size: 11)!])
                allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: necterGray , range: allTypesText.rangeOfString("All Types"))
                allTypesLabel.attributedText = allTypesAttributedText
                businessLabel.textColor = businessBlue
                loveLabel.textColor = necterGray
                friendshipLabel.textColor = necterGray
                
                print("business clicked")
                    break
            case 2:
                currentTypeOfCardsOnDisplay = convertBridgeTypeStringToBridgeTypeEnum("Love")
                
                //updating which toolbar Button is selected
                allTypesButton.enabled = true
                businessButton.enabled = true
                loveButton.enabled = false
                friendshipButton.enabled = true
                
                //updating textColor necter-Type labels
                let allTypesText = "All Types" as NSString
                var allTypesAttributedText = NSMutableAttributedString(string: allTypesText as String, attributes: [NSFontAttributeName: UIFont.init(name: "BentonSans", size: 11)!])
                allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: necterGray , range: allTypesText.rangeOfString("All Types"))
                allTypesLabel.attributedText = allTypesAttributedText
                businessLabel.textColor = necterGray
                loveLabel.textColor = loveRed
                friendshipLabel.textColor = necterGray
                    break
            case 3:
                currentTypeOfCardsOnDisplay = convertBridgeTypeStringToBridgeTypeEnum("Friendship")
                
                //updating which toolbar Button is selected
                allTypesButton.enabled = true
                businessButton.enabled = true
                loveButton.enabled = true
                friendshipButton.enabled = false
                
                
                //updating textColor necter-Type labels
                let allTypesText = "All Types" as NSString
                var allTypesAttributedText = NSMutableAttributedString(string: allTypesText as String, attributes: [NSFontAttributeName: UIFont.init(name: "BentonSans", size: 11)!])
                allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: necterGray , range: allTypesText.rangeOfString("All Types"))
                allTypesLabel.attributedText = allTypesAttributedText
                businessLabel.textColor = necterGray
                loveLabel.textColor = necterGray
                friendshipLabel.textColor = friendshipGreen
                    break
            default:
                currentTypeOfCardsOnDisplay = convertBridgeTypeStringToBridgeTypeEnum("All")
                
                //updating which toolbar Button is selected
                allTypesButton.enabled = false
                businessButton.enabled = true
                loveButton.enabled = true
                friendshipButton.enabled = true
                
                //updating textColor necter-Type labels
                let allTypesText = "All Types" as NSString
                var allTypesAttributedText = NSMutableAttributedString(string: allTypesText as String, attributes: [NSFontAttributeName: UIFont.init(name: "BentonSans", size: 11)!])
                allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: businessBlue , range: allTypesText.rangeOfString("All"))
                allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: loveRed , range: allTypesText.rangeOfString("Ty"))
                allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: friendshipGreen , range: allTypesText.rangeOfString("pes"))
                allTypesLabel.attributedText = allTypesAttributedText
                businessLabel.textColor = necterGray
                loveLabel.textColor = necterGray
                friendshipLabel.textColor = necterGray
        }
        
            for i in 0..<stackOfCards.count {
                stackOfCards[i].removeFromSuperview()
            }
            stackOfCards.removeAll()
            displayCards()
    }
    func bridged(){
        let bridgePairings = LocalData().getPairings()
        if var bridgePairings = bridgePairings {
            var x = 0
            for i in 0 ..< (bridgePairings.count) {
                if self.currentTypeOfCardsOnDisplay == typesOfCard.All || bridgePairings[x].user1?.bridgeType == convertBridgeTypeEnumToBridgeTypeString(self.currentTypeOfCardsOnDisplay) {
                    break
                }
                x = i
            }
            let message = PFObject(className: "Messages")
            let acl = PFACL()
            acl.publicReadAccess = true
            acl.publicWriteAccess = true
            message.ACL = acl

            let currentUserId = PFUser.currentUser()?.objectId
            let currentUserName = (PFUser.currentUser()?["name"] as? String) ?? ""
            message["ids_in_message"] = [(bridgePairings[x].user1?.userId)!, (bridgePairings[x].user2?.userId)!, currentUserId!]
            message["names_in_message"] = [(bridgePairings[x].user1?.name)!, (bridgePairings[x].user2?.name)!, currentUserName]
            let user1FirstName = (bridgePairings[x].user1?.name)!.componentsSeparatedByString(" ").first!
            let user2FirstName = (bridgePairings[x].user2?.name)!.componentsSeparatedByString(" ").first!
            singleMessageTitle = "\(user1FirstName) & \(user2FirstName)"
            message["bridge_builder"] = currentUserId
            var y = [String]()
            y.append(currentUserId as String!)
            message["message_viewed"] = y
            if let necterType = bridgePairings[x].user1?.bridgeType {
                message["message_type"] = necterType
                switch(necterType) {
                case "Business":
                    necterTypeColor = businessBlue
                case "Love":
                    necterTypeColor = loveRed
                case "Friendship":
                    necterTypeColor = friendshipGreen
                default:
                    necterTypeColor = necterGray
                }
                

            }
            else {
            message["message_type"] = "Friendship"
            }
            message["lastSingleMessageAt"] = NSDate()
            // update the no of message in a Thread - Start
            message["no_of_single_messages"] = 1
            var noOfSingleMessagesViewed = [String:Int]()
            noOfSingleMessagesViewed[PFUser.currentUser()!.objectId!] = 1
            message["no_of_single_messages_viewed"] = NSKeyedArchiver.archivedDataWithRootObject(noOfSingleMessagesViewed)
            //message.saveInBackground()
            // update the no of message in a Thread - End
            do {
                try message.save()
                let objectId = bridgePairings[x].user1?.objectId
                let query = PFQuery(className:"BridgePairings")
                query.getObjectInBackgroundWithId(objectId!, block: { (result, error) -> Void in
                    if let result = result {
                        result["checked_out"] = true
                        result["bridged"] = true
                        //result.saveInBackground()
                        let notificationMessage1 = PFUser.currentUser()!["name"] as! String + " has Bridged you with "+bridgePairings[x].user2!.name! + " for " + bridgePairings[x].user2!.bridgeType!
                        PFCloud.callFunctionInBackground("pushNotification", withParameters: ["userObjectId":bridgePairings[x].user1!.userId!,"alert":notificationMessage1, "badge": "Increment", "messageType" : "Bridge", "messageId": message.objectId!]) {
                            (response: AnyObject?, error: NSError?) -> Void in
                            if error == nil {
                                if let response = response as? String {
                                    //print(response)
                                }
                            }
                        }
                        let notificationMessage2 = PFUser.currentUser()!["name"] as! String + " has Bridged you with "+bridgePairings[x].user1!.name! + " for " + bridgePairings[x].user2!.bridgeType!
                        PFCloud.callFunctionInBackground("pushNotification", withParameters: ["userObjectId":bridgePairings[x].user2!.userId!,"alert":notificationMessage2, "badge": "Increment", "messageType" : "Bridge", "messageId": message.objectId!]) {
                            (response: AnyObject?, error: NSError?) -> Void in
                            if error == nil {
                                if let response = response as? String {
                                    //print(response)
                                }
                            }
                        }
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

            self.bridgePairings!.removeAtIndex(x)
            let localData = LocalData()
            localData.setPairings(self.bridgePairings!)
            localData.synchronize()
            downloadMoreCards(1, typeOfCards: bridgeType)
            segueToSingleMessage = true
            performSegueWithIdentifier("showSingleMessage", sender: nil)
        }
    }
    func nextPair(){
        if var bridgePairings = bridgePairings {
            var x = 0
            for i in 0 ..< (bridgePairings.count) {
                if self.currentTypeOfCardsOnDisplay == typesOfCard.All || bridgePairings[x].user1?.bridgeType == convertBridgeTypeEnumToBridgeTypeString(self.currentTypeOfCardsOnDisplay) {
                    break
                }
                x = i
                
            }
            let objectId = bridgePairings[x].user1?.objectId
            let query = PFQuery(className:"BridgePairings")
            query.getObjectInBackgroundWithId(objectId!, block: { (result, error) -> Void in
                if let result = result {
                    result["checked_out"] = false
                    result["bridged"] =  false
                    result.saveInBackground()
                }
            })
            var bridgeType = "All"
            if let bt = bridgePairings[x].user1?.bridgeType {
                bridgeType = bt
            }
            self.bridgePairings!.removeAtIndex(x)
            let localData = LocalData()
            localData.setPairings(self.bridgePairings!)
            localData.synchronize()
            

            downloadMoreCards(1, typeOfCards: bridgeType)
            if arrayOfCardsInDeck.count > 0 {
                arrayOfCardsInDeck.removeAtIndex(0)
                arrayOfCardColors.removeAtIndex(0)
                if arrayOfCardsInDeck.count > 0 {
                    arrayOfCardsInDeck[0].userInteractionEnabled = true
                }
                else {
                    
                    //create the alert controller
                    let alert = UIAlertController(title: "Recycle the pairs", message: "You have ran out of people to connect for today. Would you like to have a re-look at the pairs you didn't bridge?", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) in
                        self.displayNoMoreCards()
                        
                    }))
                    alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action) in
                        PFCloud.callFunctionInBackground("revitalizeMyPairs", withParameters: ["bridgeType":self.convertBridgeTypeEnumToBridgeTypeString(self.currentTypeOfCardsOnDisplay)]) {
                            (response: AnyObject?, error: NSError?) -> Void in
                            if error == nil {
                                if let response = response as? String {
                                    print(response)
                                }
                                self.lastCardInStack = UIView()
                                self.downloadMoreCards(2, typeOfCards: bridgeType)
                                if self.arrayOfCardsInDeck.count > 0 {
                                        self.arrayOfCardsInDeck[0].userInteractionEnabled = true
                                }
                                

//                                self.localStorageUtility.getBridgePairingsFromCloud(1,typeOfCards: "EachOfAllType")
//                                self.bridgePairings = LocalData().getPairings()
//                                for i in 0..<self.stackOfCards.count {
//                                    self.stackOfCards[i].removeFromSuperview()
//                                }
//                                self.stackOfCards.removeAll()
//                                self.displayCards()
                            }
                        }
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                }
            }
        }
    }
    func isDragged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translationInView(self.view)
        let superDeckView = gesture.view!
        superDeckView.center = CGPoint(x: self.screenWidth / 2 + translation.x, y: self.screenHeight / 2 + translation.y)
        let xFromCenter = superDeckView.center.x - self.view.bounds.width / 2
        let scale = min(CGFloat(1.0), 1)
        var rotation = CGAffineTransformMakeRotation(xFromCenter / 350)
        var stretch = CGAffineTransformScale(rotation, scale, scale)
        superDeckView.transform = stretch
        var removeCard = false
        
        //let disconnectIconX = min(CGFloat(0.25*self.screenWidth-superDeckView.center), CGFloat(0.25*screenWidth))
        
        let disconnectIconX = min((-1.66*(superDeckView.center.x/self.screenWidth)+0.66)*screenWidth, 0.25*screenWidth)
        let connectIconX = max((-1.66*(superDeckView.center.x/self.screenWidth)+1.6)*screenWidth, 0.35*screenWidth)
        
        //animating connect and disconnect icons from 0.4% of screenwidth to 0.25% of screenWidth
        if superDeckView.center.x < 0.4*screenWidth{
            //UIView.animateWithDuration(0.7, animations: {
                //fading in with swipe left from 0.4% of screenWidth to 0.25% of screen width
                self.disconnectIcon.alpha = -6.66*(superDeckView.center.x/self.screenWidth)+2.66
                self.disconnectIcon.frame = CGRect(x: disconnectIconX, y: 0.33*self.screenHeight, width: 0.4*self.screenWidth, height: 0.4*self.screenWidth)
            //})
        } else if superDeckView.center.x > 0.6*screenWidth {
            //UIView.animateWithDuration(0.7, animations: {
                //fading in with swipe right from 0.6% of screenWidth to 0.75% of screen width
                self.connectIcon.alpha = 6.66*(superDeckView.center.x/self.screenWidth)-4
                self.connectIcon.frame = CGRect(x: connectIconX, y: 0.33*self.screenHeight, width: 0.4*self.screenWidth, height: 0.4*self.screenWidth)
            //})
        } else {
            //UIView.animateWithDuration(0.7, animations: {
                    self.disconnectIcon.alpha = -6.66*(superDeckView.center.x/self.screenWidth)+2.66
                    self.disconnectIcon.frame = CGRect(x: disconnectIconX, y: 0.33*self.screenHeight, width: 0.4*self.screenWidth, height: 0.4*self.screenWidth)
                    self.connectIcon.frame = CGRect(x: connectIconX, y: 0.33*self.screenHeight, width: 0.4*self.screenWidth, height: 0.4*self.screenWidth)
                    self.connectIcon.alpha = 6.66*(superDeckView.center.x/self.screenWidth)-4
            //})
        }
        
        if gesture.state == UIGestureRecognizerState.Ended {
            
            if superDeckView.center.x < 0.25*screenWidth {
                
                UIView.animateWithDuration(0.2, animations: {
                    superDeckView.center.x = -1.0*self.screenWidth
                    self.disconnectIcon.center.x = -1.0*self.screenWidth
                    self.disconnectIcon.alpha = 0.0
                    }, completion: { (success) in
                        self.nextPair()
                })
                removeCard = true
            } else if superDeckView.center.x > 0.75*screenWidth {
                removeCard = true
                UIView.animateWithDuration(0.2, animations: {
                    superDeckView.center.x = 2.0*self.screenWidth
                    self.connectIcon.center.x = 2.0*self.screenWidth
                    self.connectIcon.alpha = 0.0
                })
                
                bridged()
            }
            if removeCard {
                superDeckView.removeFromSuperview()
            }
            else {
                UIView.animateWithDuration(0.7, animations: {
                    //var superDeckViewFrame = superDeckView.frame
                    superDeckView.layer.borderColor = self.arrayOfCardColors[0]
                    rotation = CGAffineTransformMakeRotation(0)
                    stretch = CGAffineTransformScale(rotation, 1, 1)
                    superDeckView.transform = stretch
                    superDeckView.frame = CGRect(x: self.superDeckX, y: self.superDeckY, width: self.superDeckWidth, height: self.superDeckHeight)
                    self.connectIcon.center.x = self.screenWidth
                    self.connectIcon.alpha = 0.0
                    self.disconnectIcon.center.x = 0.0
                    self.disconnectIcon.alpha = 0.0
                })
                
            }
        }
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        if segueToSingleMessage {
            //print("was Called")
            segueToSingleMessage = false
            let singleMessageVC:SingleMessageViewController = segue.destinationViewController as! SingleMessageViewController
            singleMessageVC.transitioningDelegate = self.transitionManager
            singleMessageVC.isSeguedFromBridgePage = true
            singleMessageVC.newMessageId = self.messageId
            singleMessageVC.singleMessageTitle = singleMessageTitle
            singleMessageVC.seguedFrom = "BridgeViewController"
            singleMessageVC.necterTypeColor = necterTypeColor
            self.transitionManager.animationDirection = "Right"
        }
        else {
            let vc = segue.destinationViewController
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

