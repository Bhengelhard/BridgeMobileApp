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
    //set to the height and width of the images in the superDeck
    let cardWidth = UIScreen.mainScreen().bounds.width - 2*0.03*UIScreen.mainScreen().bounds.width
    let cardHeight = 0.765*UIScreen.mainScreen().bounds.height*0.5
    //superDeck refers to the swipable rectangel containing the two images of the people to connect
    let superDeckX = 0.03*UIScreen.mainScreen().bounds.width
    let superDeckY = 0.12*UIScreen.mainScreen().bounds.height
    let superDeckWidth = UIScreen.mainScreen().bounds.width - 2*0.03*UIScreen.mainScreen().bounds.width
    let superDeckHeight = 0.765*UIScreen.mainScreen().bounds.height
    let necterColor = UIColor(red: 255/255, green: 230/255, blue: 57/255, alpha: 1.0)
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
    func displayToolBar(){
        var items = [UIBarButtonItem]()
        
        items.append( UIBarButtonItem(title: "Filter", style: .Plain, target: nil, action:#selector(filterTapped(_:)) ))
        items[0].tintColor = UIColor.darkGrayColor()
        items[0].tag = 0
        items.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil))
        items.append( UIBarButtonItem(image: UIImage(named: "Business-33x33.png"), style: .Plain, target: nil, action: #selector(filterTapped(_:))))
        items[2].tintColor = businessBlue
        items[2].tag = 1
        items.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil))
        items.append( UIBarButtonItem(image: UIImage(named: "Love-33x33.png"), style: .Plain, target: nil, action: #selector(filterTapped(_:))))
        items[4].tintColor = loveRed
        items[4].tag = 2
        items.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil))
        items.append( UIBarButtonItem(image: UIImage(named: "Friendship-44x44.png"), style: .Plain, target: nil, action: #selector(filterTapped(_:))))
        items[6].tintColor = friendshipGreen
        items[6].tag = 3

        
        let toolbar = UIToolbar()
        toolbar.frame = CGRectMake(0, 0.9*screenHeight, screenWidth, 0.1*screenHeight)
        //toolbar.sizeToFit()
        toolbar.setItems(items, animated: true)
        toolbar.tintColor = UIColor.whiteColor()
        self.view.addSubview(toolbar)
    }
    func displayNoMoreCards() {
        let frame1: CGRect = CGRectMake(superDeckX, superDeckY, superDeckWidth, superDeckHeight)
        let frame2: CGRect = CGRectMake(screenWidth * 0.08,screenHeight*0.1, screenWidth*0.9,screenHeight * 0.5)
        let view1 = UIView(frame:frame1)
        let label = UILabel(frame: frame2)
        label.numberOfLines = 0
        label.text = "You seem to have run out of people to connect for the day. Please check back tomorrow!"
        label.font = UIFont(name: "BentonSans", size: 20)
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
        let nameFrame = CGRectMake(0.05*cardWidth,0.05*cardHeight,0.8*cardWidth,0.1*cardHeight)
        let locationFrame = CGRectMake(0.05*cardWidth,0.17*cardHeight,0.8*cardWidth,0.10*cardHeight)
        let statusFrame = CGRectMake(0.05*cardWidth,0.65*cardHeight,0.9*cardWidth,0.3*cardHeight)
        let photoFrame = CGRectMake(0, 0, superDeckWidth, 0.5*superDeckHeight)
        //Creating the transparency screens
        let screenUnderTopFrame = CGRectMake(0,0,cardWidth,0.3*cardHeight)
        let screenUnderBottomFrame = CGRectMake(0, 0.65*cardHeight, cardWidth, 0.35*cardHeight)
        
        let nameLabel = UILabel(frame: nameFrame)
        nameLabel.text = name
        nameLabel.textAlignment = NSTextAlignment.Left
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.font = UIFont(name: "Verdana", size: 20)
        
        let locationLabel = UILabel(frame: locationFrame)
        locationLabel.text = location
        locationLabel.textAlignment = NSTextAlignment.Left
        locationLabel.textColor = UIColor.whiteColor()
        locationLabel.font = UIFont(name: "Verdana", size: 16)
        
        let statusLabel = UILabel(frame: statusFrame)
        statusLabel.text = status
        statusLabel.textColor = businessBlue//UIColor.whiteColor()
        statusLabel.font = UIFont(name: "BentonSans", size: 18)
        statusLabel.numberOfLines = 0
        
        let photoView = UIImageView(frame: photoFrame)
        photoView.image = UIImage(data: photo)
        //photoView.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleWidth
        photoView.contentMode = UIViewContentMode.ScaleAspectFill
        photoView.clipsToBounds = true
        
        let screenUnderTop = UIImageView(frame: screenUnderTopFrame)
        screenUnderTop.image = UIImage(named: "Screen over Image.png")
        //screenUnderTop.layer.cornerRadius = 15
        screenUnderTop.contentMode = UIViewContentMode.ScaleAspectFill
        screenUnderTop.clipsToBounds = true
        
        let screenUnderBottom = UIImageView(frame: screenUnderBottomFrame)
        screenUnderBottom.image = UIImage(named: "Screen over Image.png")
        //screenUnderBottom.layer.cornerRadius = 15
        screenUnderBottom.contentMode = UIViewContentMode.ScaleAspectFill
        screenUnderBottom.clipsToBounds = true
        
        let card = UIView(frame:deckFrame)
        card.addSubview(photoView)
        card.addSubview(screenUnderTop)
        card.addSubview(screenUnderBottom)
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
               // let mainProfilePicture = UIImagePNGRepresentation(UIImage(named: "bridgeVector.jpg")!)!
                //photo2 =  mainProfilePicture
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
        self.iconFrame = CGRectMake(0.74*self.screenWidth,0.04*self.screenHeight,0.03*self.screenWidth,0.02*self.screenHeight)
        self.iconLabel = UILabel(frame: iconFrame)
        self.iconLabel.layer.backgroundColor = UIColor.redColor().CGColor
        self.iconLabel.layer.cornerRadius = 5
        self.iconLabel.textColor = necterColor
        self.view.addSubview(self.iconLabel)

        bridgePairings = LocalData().getPairings()
        if (bridgePairings == nil || bridgePairings?.count < 1) {
        localStorageUtility.getBridgePairingsFromCloud(2,typeOfCards: "EachOfAllType")
        bridgePairings = LocalData().getPairings()
        }
        displayCards()
        displayToolBar()
        let query: PFQuery = PFQuery(className: "Messages")
        query.whereKey("ids_in_message", containsString: PFUser.currentUser()?.objectId)
        query.cachePolicy = .NetworkElseCache
        query.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
            if error == nil {
                if let results = results {
                var badgeCount = 0
                for i in 0..<results.count{
                    let result = results[i]
                    if var noOfSingleMessagesViewed = NSKeyedUnarchiver.unarchiveObjectWithData(result["no_of_single_messages_viewed"] as! NSData)! as? [String:Int] {
                        let noOfMessagesViewed = noOfSingleMessagesViewed[(PFUser.currentUser()?.objectId)!] ?? 0
                        badgeCount += (result["no_of_single_messages"] as! Int) - noOfMessagesViewed
                    }
                    
                }
                    dispatch_async(dispatch_get_main_queue(), {
                        self.iconLabel.text = String(badgeCount)
                        
                        
                    })

                }
            }
        })
        
        
        
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
            /*if tag == UIImage(named: "business-33x33.png") {
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
            
            print("bridgePairings.count - \(bridgePairings.count)")
            let localData = LocalData()
            localData.setPairings(self.bridgePairings!)
            localData.synchronize()
            let c = downloadMoreCards(1)
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
                                self.localStorageUtility.getBridgePairingsFromCloud(2,typeOfCards: "EachOfAllType")
                                self.bridgePairings = LocalData().getPairings()
                                for i in 0..<self.stackOfCards.count {
                                    self.stackOfCards[i].removeFromSuperview()
                                }
                                self.stackOfCards.removeAll()
                                self.displayCards()
                            }
                        }
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                }
            }
            

//            if c == 0 {
//                
//            }
            
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

