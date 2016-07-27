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
    let cardWidth = UIScreen.mainScreen().bounds.width*0.8
    let cardHeight = UIScreen.mainScreen().bounds.height*0.37
    var totalNoOfCards = 0
    var stackOfCards = [UIView]()
    let localStorageUtility = LocalStorageUtility()
    var currentTypeOfCardsOnDisplay = typesOfCard.All
    var lastCardInStack:UIView = UIView()
    var displayNoMoreCardsView:UIView? = nil
    var arrayOfCardsInDeck = [UIView]()
    var segueToSingleMessage = false
    var messageId = ""
    let transitionManager = TransitionManager()
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
        
        items.append( UIBarButtonItem(title: "All", style: .Plain, target: nil, action:#selector(filterTapped(_:)) ))
        items.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil))
        items.append( UIBarButtonItem(title: "Business", style: .Plain, target: nil, action: #selector(filterTapped(_:))))
        items.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil))
        items.append( UIBarButtonItem(title: "Love", style: .Plain, target: nil, action: #selector(filterTapped(_:))))
        items.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil))
        items.append( UIBarButtonItem(title: "Friendship", style: .Plain, target: nil, action: #selector(filterTapped(_:))))
        
        let toolbar = UIToolbar()
        toolbar.frame = CGRectMake(0, self.view.frame.size.height - 46, self.view.frame.size.width, 46)
        toolbar.sizeToFit()
        toolbar.setItems(items, animated: true)
        toolbar.backgroundColor = UIColor.redColor()
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
        let upperDeckFrame : CGRect = CGRectMake(screenWidth*(0.08),screenHeight*0.87*(0.16), screenWidth*0.8,screenHeight*0.87*0.37)
        return upperDeckFrame
    }
    func getLowerDeckCardFrame() -> CGRect {
        let lowerDeckFrame : CGRect = CGRectMake(screenWidth*(0.08),screenHeight*0.87*(0.54), screenWidth*0.8,screenHeight*0.87*0.37)
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
        let photoFrame = CGRectMake(0,0, cardWidth, cardHeight)
        
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
        let superDeckFrame : CGRect = CGRectMake(0,screenHeight*0.087, screenWidth,screenHeight*0.85)
        let superDeckView = UIView(frame:superDeckFrame)
        superDeckView.addSubview(upperDeckCard)
        superDeckView.addSubview(lowerDeckCard)
        superDeckView.layer.borderWidth = 3
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
        stackOfCards.append(superDeckView)
        return superDeckView
    }
    func displayCards(){
        if let displayNoMoreCardsView = displayNoMoreCardsView {
            displayNoMoreCardsView.removeFromSuperview()
            self.displayNoMoreCardsView = nil
        }
        arrayOfCardsInDeck = [UIView]()
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
        localStorageUtility.getBridgePairingsFromCloud(2,typeOfCards: "All")
        bridgePairings = LocalData().getPairings()
        }
        displayCards()
        displayToolBar()
        

        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func filterTapped(sender: UIBarButtonItem ){
        print(currentTypeOfCardsOnDisplay)
        if let title = sender.title {
            currentTypeOfCardsOnDisplay = convertBridgeTypeStringToBridgeTypeEnum(title)
            print(currentTypeOfCardsOnDisplay)
            for i in 0..<stackOfCards.count {
                stackOfCards[i].removeFromSuperview()
            }
            stackOfCards.removeAll()
            displayCards()
            displayToolBar()
            
        }
        
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
            let objectId = bridgePairings[x].user1?.objectId
            let query = PFQuery(className:"BridgePairings")
            query.getObjectInBackgroundWithId(objectId!, block: { (result, error) -> Void in
                if let result = result {
                    result["checked_out"] = true
                    result["bridged"] = true
                    result.saveInBackground()
                }
            })
            let message = PFObject(className: "Messages")
            let currentUserId = PFUser.currentUser()?.objectId
            message["ids_in_message"] = [(bridgePairings[x].user1?.userId)!, (bridgePairings[x].user2?.userId)!, currentUserId!]
            print("userId1, userId2 - \((bridgePairings[x].user1?.userId)!),\((bridgePairings[x].user2?.userId)!)")
            message["bridge_builder"] = currentUserId
            do {
                try message.save()
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
        superDeckView.center = CGPoint(x: self.screenWidth / 2 + translation.x, y: self.screenHeight*0.087 + (screenHeight*0.85*0.5) + translation.y)
        let xFromCenter = superDeckView.center.x - self.view.bounds.width / 2
        let scale = min(100 / abs(xFromCenter), 1)
        var rotation = CGAffineTransformMakeRotation(xFromCenter / 200)
        var stretch = CGAffineTransformScale(rotation, scale, scale)
        superDeckView.transform = stretch
        var removeCard = false
        if gesture.state == UIGestureRecognizerState.Ended {
            
            if superDeckView.center.x < 100 {
                removeCard = true
                print("nextPair")
                nextPair()
            } else if superDeckView.center.x > self.view.bounds.width - 100 {
                removeCard = true
                print("bridged")
                bridged()
            }
            if removeCard {
                superDeckView.removeFromSuperview()
            }
            else {
            rotation = CGAffineTransformMakeRotation(0)
            stretch = CGAffineTransformScale(rotation, 1, 1)
            superDeckView.transform = stretch
            superDeckView.center = CGPoint(x: self.screenWidth / 2, y: self.screenHeight*0.087 + (screenHeight*0.85*0.5))
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

