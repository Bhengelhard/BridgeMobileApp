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
    @IBOutlet weak var navigationBar: UINavigationBar!
    var bridgePairings:[UserInfoPair]? = nil
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    let cardWidth = UIScreen.mainScreen().bounds.height*0.45
    let cardHeight = UIScreen.mainScreen().bounds.height*0.45
    let superDeckX = 0.03*UIScreen.mainScreen().bounds.width
    let superDeckY = 0.12*UIScreen.mainScreen().bounds.height
    let superDeckWidth = UIScreen.mainScreen().bounds.width - 2*0.03*UIScreen.mainScreen().bounds.width
    let superDeckHeight = 0.765*UIScreen.mainScreen().bounds.height
    var totalNoOfCards = 0
    var stackOfCards = [UIView]()
    let localStorageUtility = LocalStorageUtility()
    var currentTypeOfCardsOnDisplay = typesOfCard.All
    var lastCardInStack:UIView = UIView()
    var displayNoMoreCardsView:UIView? = nil
    var arrayOfCardsInDeck = [UIView]()
    var arrayOfCardColors = [CGColor]()
    var segueToSingleMessage = false
    var messageId = ""
    let transitionManager = TransitionManager()
    var iconFrame = CGRectMake(0,0,0,0)
    var iconLabel = UILabel()
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
            return UIColor.init(red: 144.0/255, green: 207.0/255, blue: 214.0/255, alpha: 1.0).CGColor
        case typesOfColor.Love:
            return  UIColor.init(red: 255.0/255, green: 129.0/255, blue: 125.0/255, alpha: 1.0).CGColor
        case typesOfColor.Friendship:
            return  UIColor(red: 139.0/255, green: 217.0/255, blue: 176.0/255, alpha: 1.0).CGColor
        }
        
    }
    func displayToolBar(){
        var items = [UIBarButtonItem]()
        
        items.append( UIBarButtonItem(title: "Filter", style: .Plain, target: nil, action:#selector(filterTapped(_:)) ))
        items[0].tintColor = UIColor.darkGrayColor()
        items[0].tag = 0
        items.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil))
        items.append( UIBarButtonItem(image: UIImage(named: "Business-33x33.png"), style: .Plain, target: nil, action: #selector(filterTapped(_:))))
        items[2].tintColor = UIColor(red: 39/255, green: 103/255, blue: 143/255, alpha: 1.0)
        items[2].tag = 1
        items.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil))
        items.append( UIBarButtonItem(image: UIImage(named: "Love-33x33.png"), style: .Plain, target: nil, action: #selector(filterTapped(_:))))
        items[4].tintColor = UIColor(red: 227/255, green: 70/255, blue: 73/255, alpha: 1.0)
        items[4].tag = 2
        items.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil))
        items.append( UIBarButtonItem(image: UIImage(named: "Friendship-44x44.png"), style: .Plain, target: nil, action: #selector(filterTapped(_:))))
        items[6].tintColor = UIColor(red: 96/255, green: 182/255, blue: 163/255, alpha: 1.0)
        items[6].tag = 3

        
        let toolbar = UIToolbar()
        toolbar.frame = CGRectMake(0, 0.9*screenHeight, screenWidth, 0.1*screenHeight)
        //toolbar.sizeToFit()
        toolbar.setItems(items, animated: true)
        toolbar.tintColor = UIColor.whiteColor()
        self.view.addSubview(toolbar)
    }
    func displayNoMoreCards() {
        let frame1: CGRect = CGRectMake(0,screenHeight*0.2, screenWidth,screenHeight*0.8)
        let frame2: CGRect = CGRectMake(screenWidth * 0.08,screenHeight*0.1, screenWidth*0.9,screenHeight * 0.5)
        let view1 = UIView(frame:frame1)
        let label = UILabel(frame: frame2)
        label.numberOfLines = 0
        label.text = "You see to have run out of potential Bridges for the day. Please check back tomorrow!"
        view1.addSubview(label)
        self.view.insertSubview(view1, aboveSubview: self.view)
        displayNoMoreCardsView = view1
        
    }
    func getUpperDeckCardFrame() -> CGRect {
        let upperDeckFrame : CGRect = CGRectMake(0, 0, superDeckWidth, 0.5*superDeckHeight)
        return upperDeckFrame
    }
    func getLowerDeckCardFrame() -> CGRect {
        let lowerDeckFrame : CGRect = CGRectMake(0, 0.5*superDeckHeight, superDeckWidth, 0.5*superDeckHeight)
        return lowerDeckFrame
    }
    func getUpperDeckCard(name:String, location:String, status:String, photo:NSData, cardColor:typesOfColor) -> UIView{
        let frame = getUpperDeckCardFrame()
        return getCard(frame, name: name, location: location, status: status, photo: photo, cardColor: cardColor)
        
    }
    func getLowerDeckCard(name:String, location:String, status:String, photo:NSData, cardColor:typesOfColor) -> UIView{
        let frame = getLowerDeckCardFrame()
        return getCard(frame, name: name, location: location, status: status, photo: photo, cardColor: cardColor)
    }
    func getCard(deckFrame:CGRect, name:String, location:String, status:String, photo:NSData, cardColor:typesOfColor) -> UIView {
        let nameFrame = CGRectMake(0.05*cardWidth,0.10*cardHeight,0.55*cardWidth,0.20*cardHeight)
        let locationFrame = CGRectMake(0.05*cardWidth,0.31*cardHeight,0.55*cardWidth,0.20*cardHeight)
        let statusFrame = CGRectMake(0.05*cardWidth,0.55*cardHeight,0.95*cardWidth,0.45*cardHeight)
        let photoFrame = CGRectMake(0, 0, superDeckWidth, 0.5*superDeckHeight)
        
        let nameLabel = UILabel(frame: nameFrame)
        nameLabel.text = name
        nameLabel.textColor = UIColor.whiteColor()
        
        let locationLabel = UILabel(frame: locationFrame)
        locationLabel.text = location
        locationLabel.textColor = UIColor.whiteColor()
        
        let statusLabel = UILabel(frame: statusFrame)
        statusLabel.text = status
        statusLabel.textColor = UIColor.whiteColor()
        
        let photoView = UIImageView(frame: photoFrame)
        photoView.image = UIImage(data: photo)
        //photoView.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleWidth
        photoView.contentMode = UIViewContentMode.ScaleAspectFill
        photoView.clipsToBounds = true
        
        let card = UIView(frame:deckFrame)
        card.addSubview(photoView)
        card.addSubview(nameLabel)
        card.addSubview(locationLabel)
        card.addSubview(statusLabel)
//        card.layer.borderWidth = 3
//        card.layer.borderColor = getCGColor(cardColor)
        return card
        
    }
    func addCardPairView(aboveView:UIView?, name:String, location:String, status:String, photo:NSData, name2:String, location2:String, status2:String, photo2:NSData, cardColor:typesOfColor) -> UIView{
        
        let upperDeckCard = getUpperDeckCard(name, location: location, status: status, photo: photo, cardColor: cardColor)
        let lowerDeckCard = getLowerDeckCard(name2, location: location2, status: status2, photo: photo2, cardColor: cardColor)
        let superDeckFrame : CGRect = CGRectMake(superDeckX, superDeckY, superDeckWidth, superDeckHeight)
        let superDeckView = UIView(frame:superDeckFrame)
        superDeckView.layer.cornerRadius = 15
        upperDeckCard.clipsToBounds = true
        lowerDeckCard.clipsToBounds = true
        superDeckView.clipsToBounds = true
        superDeckView.addSubview(upperDeckCard)
        superDeckView.addSubview(lowerDeckCard)
        superDeckView.backgroundColor = UIColor.whiteColor()
        superDeckView.layer.borderWidth = 4
        superDeckView.layer.borderColor = getCGColor(cardColor)
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(BridgeViewController.isDragged(_:)))
        superDeckView.addGestureRecognizer(gesture)
        superDeckView.userInteractionEnabled = true
        if let aboveView = aboveView {
            superDeckView.userInteractionEnabled = false
            self.view.insertSubview(superDeckView, belowSubview: aboveView)
        }
        else {
            self.view.insertSubview(superDeckView, aboveSubview: self.view)
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
                print ("continue")
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
            if let name = pairing.user1?.name {
                print(name)
                name1 = name
            }
            else {
                name1 = "Man has no name"
            }
            if let name = pairing.user2?.name {
                print(name)
                name2 = name
            }
            else {
                name2 = "Man has no name"
            }
            if let location_values = pairing.user1?.location {
                location1 = "Location has no name"
            }
            else {
                location1 = "Location has no name"
            }
            if let location_values = pairing.user2?.location {
                location2 = "Location has no name"
            }
            else {
                location2 = "Location has no name"
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
            
            aboveView = addCardPairView(aboveView, name: name1, location: location1, status: status1, photo: photo1, name2: name2, location2: location2, status2: status2, photo2: photo2, cardColor: color)
            lastCardInStack = aboveView!
        }
        
    }
        if  j == 0 {
            displayNoMoreCards()
        }
        
    
    }
    func downloadMoreCards(noOfCards:Int) -> Int{
        var count = 0
        let c = self.bridgePairings?.count
        if let c = c {
            if c > 0 {
                count = c
            }
        }
        localStorageUtility.getBridgePairingsFromCloud(noOfCards,typeOfCards: convertBridgeTypeEnumToBridgeTypeString(currentTypeOfCardsOnDisplay))
        bridgePairings = LocalData().getPairings()
        
        if let bridgePairings = bridgePairings {
        print("bridgePairings.count - \(bridgePairings.count)")
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
            if let name = pairing.user1?.name {
                print(name)
                name1 = name
            }
            else {
                name1 = "Man has no name"
            }
            if let name = pairing.user2?.name {
                print(name)
                name2 = name
            }
            else {
                name2 = "Man has no name"
            }
            if let location_values = pairing.user1?.location {
                location1 = "Location has no name"
            }
            else {
                location1 = "Location has no name"
            }
            if let location_values = pairing.user2?.location {
                location2 = "Location has no name"
            }
            else {
                location2 = "Location has no name"
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
                let mainProfilePicture = UIImagePNGRepresentation(UIImage(named: "bridgeVector.jpg")!)!
                photo2 =  mainProfilePicture
            }
            let color = convertBridgeTypeStringToColorTypeEnum((pairing.user1?.bridgeType)!)
            
            aboveView = addCardPairView(aboveView, name: name1, location: location1, status: status1, photo: photo1, name2: name2, location2: location2, status2: status2, photo2: photo2, cardColor: color)
            lastCardInStack = aboveView
        }   
        }
        if let _ = bridgePairings{
            return bridgePairings!.count - count
        }
        else {
            return 0
        }
    }
    func updateNoOfUnreadMessagesIcon(notification: NSNotification) {
        
        let aps = notification.userInfo!["aps"] as? NSDictionary
        let badge = aps!["badge"] as? Int
        print("Listened at updateNoOfUnreadMessagesIcon - \(badge)")
        dispatch_async(dispatch_get_main_queue(), {
            self.iconLabel.text = String(badge!)
            self.iconLabel.layer.backgroundColor = UIColor.redColor().CGColor
            self.iconLabel.layer.cornerRadius = 12
            
        })
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //        while localStorageUtility.waitForCardsToBeDownloaded(){
        //
        //        }
        //
        
        
//        localStorageUtility.getBridgePairingsFromCloud()
//        bridgePairings = LocalData().getPairings()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "updateBridgePage", object: nil)
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updateNoOfUnreadMessagesIcon), name: "updateBridgePage", object: nil)
        
        bridgePairings = LocalData().getPairings()
        if (bridgePairings == nil || bridgePairings?.count < 1) {
        localStorageUtility.getBridgePairingsFromCloud(2,typeOfCards: "EachOfAllType")
        bridgePairings = LocalData().getPairings()
        }
        displayCards()
        displayToolBar()
        self.iconFrame = CGRectMake(0.97*self.screenWidth,0.03*self.screenHeight,0.03*self.screenWidth,0.03*self.screenHeight)
        self.iconLabel = UILabel(frame: iconFrame)
        self.view.addSubview(self.iconLabel)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidLayoutSubviews() {
   
        navigationBar.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 0.1*screenHeight)

    }
    
    func filterTapped(sender: UIBarButtonItem ){
        print(currentTypeOfCardsOnDisplay)
        let tag = sender.tag
        switch(tag){
            case 0: currentTypeOfCardsOnDisplay = convertBridgeTypeStringToBridgeTypeEnum("All")
                    break
            case 1: currentTypeOfCardsOnDisplay = convertBridgeTypeStringToBridgeTypeEnum("Business")
                    break
            case 2: currentTypeOfCardsOnDisplay = convertBridgeTypeStringToBridgeTypeEnum("Love")
                    break
            case 3: currentTypeOfCardsOnDisplay = convertBridgeTypeStringToBridgeTypeEnum("Friendship")
                    break
            default:currentTypeOfCardsOnDisplay = convertBridgeTypeStringToBridgeTypeEnum("All")
        }
            /*if tag == UIImage(named: "Business-33x33.png") {
                currentTypeOfCardsOnDisplay = convertBridgeTypeStringToBridgeTypeEnum("Business")
                print(currentTypeOfCardsOnDisplay)
            } else if image == UIImage(named: "Love-33x33.png") {
                currentTypeOfCardsOnDisplay = convertBridgeTypeStringToBridgeTypeEnum("Love")
                print(currentTypeOfCardsOnDisplay)
            } else if image == UIImage(named: "Friendship-44x44.png") {
                currentTypeOfCardsOnDisplay = convertBridgeTypeStringToBridgeTypeEnum("Friendship")
                print(currentTypeOfCardsOnDisplay)
            } else if{
                currentTypeOfCardsOnDisplay = convertBridgeTypeStringToBridgeTypeEnum("All")
                print(currentTypeOfCardsOnDisplay)
            }*/
            for i in 0..<stackOfCards.count {
                stackOfCards[i].removeFromSuperview()
            }
            stackOfCards.removeAll()
            displayCards()
            displayToolBar()
            self.iconFrame = CGRectMake(0.97*self.screenWidth,0.03*self.screenHeight,0.03*self.screenWidth,0.03*self.screenHeight)
            self.iconLabel = UILabel(frame: iconFrame)
            self.view.addSubview(self.iconLabel)
    
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
            message["ids_in_message"] = [(bridgePairings[x].user1?.userId)!, (bridgePairings[x].user2?.userId)!, currentUserId!]
            print("userId1, userId2 - \((bridgePairings[x].user1?.userId)!),\((bridgePairings[x].user2?.userId)!)")
            message["bridge_builder"] = currentUserId
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
                                    print(response)
                                }
                            }
                        }
                        let notificationMessage2 = PFUser.currentUser()!["name"] as! String + " has Bridged you with "+bridgePairings[x].user1!.name! + " for " + bridgePairings[x].user2!.bridgeType!
                        PFCloud.callFunctionInBackground("pushNotification", withParameters: ["userObjectId":bridgePairings[x].user2!.userId!,"alert":notificationMessage2, "badge": "Increment", "messageType" : "Bridge", "messageId": message.objectId!]) {
                            (response: AnyObject?, error: NSError?) -> Void in
                            if error == nil {
                                if let response = response as? String {
                                    print(response)
                                }
                            }
                        }
                    }
                })

                self.messageId = message.objectId!
            }
            catch {
                
            }
//            message.saveInBackgroundWithBlock({ (success, error) in
//                print("new Message Created")
            
//            })
            self.bridgePairings!.removeAtIndex(x)
            print("bridgePairings.count - \(bridgePairings.count)")
            let localData = LocalData()
            localData.setPairings(self.bridgePairings!)
            localData.synchronize()
            downloadMoreCards(1)
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
            self.bridgePairings!.removeAtIndex(x)
            if arrayOfCardsInDeck.count > 0 {
                arrayOfCardsInDeck.removeAtIndex(0)
                arrayOfCardColors.removeAtIndex(0)
                if arrayOfCardsInDeck.count > 0 {
                    arrayOfCardsInDeck[0].userInteractionEnabled = true
                }
            }
            
            print("bridgePairings.count - \(bridgePairings.count)")
            let localData = LocalData()
            localData.setPairings(self.bridgePairings!)
            localData.synchronize()
            let c = downloadMoreCards(1)
            if c == 0 {
                displayNoMoreCards()
            }
            
        }
        

        
    }
    func isDragged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translationInView(self.view)
        let superDeckView = gesture.view!
        //superDeckView.center = CGPoint(x: self.screenWidth / 2 + translation.x, y: self.screenHeight*0.087 + (screenHeight*0.85*0.5) + translation.y)
        superDeckView.center = CGPoint(x: self.screenWidth / 2 + translation.x, y: self.screenHeight / 2 + translation.y)
        let xFromCenter = superDeckView.center.x - self.view.bounds.width / 2
        let scale = min(100 / abs(xFromCenter), 1)
        var rotation = CGAffineTransformMakeRotation(xFromCenter / 200)
        var stretch = CGAffineTransformScale(rotation, scale, scale)
        superDeckView.transform = stretch
        var removeCard = false
        if superDeckView.center.x < 0.25*screenWidth{
            superDeckView.layer.borderColor = UIColor.lightGrayColor().CGColor
        } else if superDeckView.center.x > 0.75*screenWidth {
            superDeckView.layer.borderColor = UIColor(red: 255/255, green: 230/255, blue: 57/255, alpha: 1.0).CGColor
        } else {
            superDeckView.layer.borderColor = arrayOfCardColors[0]
        }
        
        if gesture.state == UIGestureRecognizerState.Ended {
            
            if superDeckView.center.x < 0.25*screenWidth {
                print("nextPair")
                nextPair()
                removeCard = true
            } else if superDeckView.center.x > 0.75*screenWidth {
                removeCard = true
                print("bridged")
                bridged()
            }
            if removeCard {
                superDeckView.removeFromSuperview()
            }
            else {
                
                
                //superDeckView.center = CGPoint(x: self.screenWidth / 2, y: self.screenHeight*0.087 + (screenHeight*0.85*0.5))
                UIView.animateWithDuration(0.7, animations: {
                    //var superDeckViewFrame = superDeckView.frame
                    superDeckView.layer.borderColor = self.arrayOfCardColors[0]
                    rotation = CGAffineTransformMakeRotation(0)
                    stretch = CGAffineTransformScale(rotation, 1, 1)
                    superDeckView.transform = stretch
                    superDeckView.center.x = self.screenWidth/2
                    superDeckView.center.y = self.screenHeight/2
                })
                //superDeckView.center = CGPoint(x: self.screenWidth / 2, y: self.screenHeight / 2)
                
            }
        }
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segueToSingleMessage {
            print("was Called")
            segueToSingleMessage = false
            let singleMessageVC:SingleMessageViewController = segue.destinationViewController as! SingleMessageViewController
            singleMessageVC.transitioningDelegate = self.transitionManager
            singleMessageVC.isSeguedFromBridgePage = true
            singleMessageVC.newMessageId = self.messageId
        }
        if let _ = self.navigationController{
            print("no - \(navigationController?.viewControllers.count)")
            if (navigationController?.viewControllers.count)! > 1 {
            for _ in (1..<(navigationController?.viewControllers.count)!).reverse()  {
                navigationController?.viewControllers.removeAtIndex(0)
            }
            }
            
            //navigationController?.viewControllers.removeAll()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

