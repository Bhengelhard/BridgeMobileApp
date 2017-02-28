//
//  ViewController.swift
//  play
//
//  Created by Sagar Sinha on 7/5/16.
//  Copyright © 2016 BHE Ventures LLC. All rights reserved.
//

import UIKit
import Parse
import MapKit

class BridgeViewController: UIViewController {
    // Initializing Custom Classes
    let localData = LocalData()
    let missionControlView = MissionControlView()
    let pfCloudFunctions = PFCloudFunctions()
    
    //set to the height and width of the images in the superDeck
    let cardWidth = 0.8586*DisplayUtility.screenWidth//UIScreen.main.bounds.width - 0.06*UIScreen.main.bounds.width
    let cardHeight = 0.8178*DisplayUtility.screenHeight//0.765*UIScreen.main.bounds.height*0.5
    
    //superDeck refers to the swipable rectangle containing the two images of the people to connect
    var swipeCardFrame = CGRect()
    var totalNoOfCards = 0
    let localStorageUtility = LocalStorageUtility()
    var currentTypeOfCardsOnDisplay = BridgeType.all
    var lastCardInStack:UIView? = nil // used by getB() to add a card below this
    var displayNoMoreCardsLabel = UILabel()
    var arrayOfCardsInDeck = [SwipeCard]()
    var arrayOfCardColors = [CGColor]()
    var segueToSingleMessage = false
    var messageId = ""
    let transitionManager = TransitionManager()
    var revisitButton = UIButton()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var wasLastSwipeInDeck = Bool()
    var shouldCheckInPair = Bool()
	var swipeCardView: SwipeCard = SwipeCard()
    var postTapped = Bool()
    //var darkLayer = UIView()
    var secondSwipeCard = SwipeCard()
    var secondSwipeCardSet = false
	let secondSwipeCardShrinkPercentage = 0.98

    //navigation bar creation
    var badgeCount = Int()
    let leftBarButton = UIButton()
    let rightBarButton = UIButton()
    let customNavigationBar = CustomNavigationBar()
    
    //Connect and disconnect Icons
    let connectIcon = UIImageView()
    let disconnectIcon = UIImageView()
    
    //Send title and title Color to singleMessageViewController
    var singleMessageTitle = ""
    var necterTypeColor = UIColor()
 
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
    
    func displayNoMoreCards() {
        displayNoMoreCardsLabel.alpha = 1
        revisitButton.alpha = 1
        revisitButton.isEnabled = true
    }
    
    func initializeNoMoreCards() {
        //Display no more cards label
        let labelFrame: CGRect = CGRect(x: 0,y: 0, width: 0.8*DisplayUtility.screenWidth,height: DisplayUtility.screenHeight * 0.1)
        displayNoMoreCardsLabel.frame = labelFrame
        displayNoMoreCardsLabel.numberOfLines = 0
        let type = missionControlView.whichFilter()
        if type == "Business" {
            displayNoMoreCardsLabel.text = "No active matches to 'nect for work. Please check back tomorrow."
        } else if type == "Love" {
            displayNoMoreCardsLabel.text = "No active matches to 'nect for dating. Please check back tomorrow."
        } else if type == "Friendship" {
            displayNoMoreCardsLabel.text = "No active matches to 'nect for friendship. Please check back tomorrow."
        } else {
            displayNoMoreCardsLabel.text = "No active matches to 'nect. Please check back tomorrow."
        }
        displayNoMoreCardsLabel.font = UIFont(name: "BentonSans-Light", size: 20)
        displayNoMoreCardsLabel.textAlignment = NSTextAlignment.center
        displayNoMoreCardsLabel.center.y = view.center.y - DisplayUtility.screenHeight*0.05
        displayNoMoreCardsLabel.center.x = view.center.x
        displayNoMoreCardsLabel.adjustsFontSizeToFitWidth = true
        displayNoMoreCardsLabel.alpha = 0
        
        //view.insertSubview(displayNoMoreCardsLabel!, belowSubview: customNavigationBar)
        view.addSubview(displayNoMoreCardsLabel)
        displayNoMoreCardsLabel.sendSubview(toBack: view)
        
        //Display Revisit Button so user can run through their previously seen matches
        let revisitButtonY = displayNoMoreCardsLabel.frame.maxY + 0.02*DisplayUtility.screenHeight
        let revisitButtonFrame: CGRect = CGRect(x: 0.25*DisplayUtility.screenWidth, y: revisitButtonY, width: 0.5*DisplayUtility.screenWidth,height: DisplayUtility.screenHeight * 0.06)
        revisitButton = DisplayUtility.gradientButton(frame: revisitButtonFrame, text: "Revisit Matches", textColor: UIColor.black, fontSize: 20)
        revisitButton.addTarget(self, action: #selector(revitalizeMyPairs(_:)), for: .touchUpInside)
        revisitButton.alpha = 0
        revisitButton.isEnabled = false
        
        //view.insertSubview(revisitButton, belowSubview: customNavigationBar)
        view.insertSubview(revisitButton, belowSubview: customNavigationBar)
    }
    
    
    // Does not download bridge pairings. Only presents the existing ones in the localData to the user
    func displayCards(){
        //if let displayNoMoreCardsLabel = displayNoMoreCardsLabel {
        //displayNoMoreCardsLabel.removeFromSuperview()
        //revisitButton.removeFromSuperview()
        //}
        //Turning noMoreCards Label and Button off if they are displayed
        if displayNoMoreCardsLabel.alpha == 1 {
            displayNoMoreCardsLabel.alpha = 0
            revisitButton.alpha = 0
        }
        arrayOfCardsInDeck = [SwipeCard]()
        arrayOfCardColors = [CGColor]()
        var j = 0
		// FIXME: Missing/invalid data causes crashes
        let bridgePairings = localData.getPairings()
        if let bridgePairings = bridgePairings {
            var aboveView:UIView? = nil
            for i in 0..<bridgePairings.count {
                let pairing = bridgePairings[i]
                if self.currentTypeOfCardsOnDisplay != .all && pairing.user1?.bridgeType != currentTypeOfCardsOnDisplay.parseValue {
                    continue
                }
                j += 1
                var id1 = String()
                var id2 = String()
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
                if let id = pairing.user1?.userId {
                    id1 = id
                }
                if let id = pairing.user2?.userId {
                    id2 = id
                }
                if let name = pairing.user1?.name {
                    name1 = name
                }
                else {
                    name1 = "Unnamed User"
                }
                if let name = pairing.user2?.name {
                    name2 = name
                }
                else {
                    name2 = "Unnamed User"
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

				var type = BridgeType.business

				if let user1BridgeType = pairing.user1?.bridgeType
				{
					type = BridgeType(fromParseValue: user1BridgeType)
				}

				aboveView = addCardPairView(aboveView, 
				                            id: id1, 
                                            name: name1, 
                                            location: location1, 
                                            status: status1, 
                                            photo: photoFile1, 
                                            locationCoordinates1: locationCoordinates1,
											id2: id2, 
                                            name2: name2, 
                                            location2: location2, 
                                            status2: status2, 
                                            photo2: photoFile2, 
                                            locationCoordinates2: locationCoordinates2, 
                                            type: type, 
                                            pairing: pairing)
                lastCardInStack = aboveView!
            }
            
        }
        
        if  j == 0 {
            self.displayNoMoreCards()
        }
    }

	func addCardPairView (_ aboveView: UIView?, 
	                      id: String?, 
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
	                      type: BridgeType, 
	                      pairing: UserInfoPair) -> UIView
	{
        let connectionType = type.parseValue
        let swipeCardView = SwipeCard()

        //superDeckView.backgroundColor = UIColor.white.withAlphaComponent(1.0)
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(BridgeViewController.isDragged(_:)))
        swipeCardView.addGestureRecognizer(gesture)
        swipeCardView.isUserInteractionEnabled = true

        if let aboveView = aboveView {
            if secondSwipeCardSet == false {
                secondSwipeCard = swipeCardView
                secondSwipeCardSet = true
                
                //Second card should also have dark layer that fades away with swipe of first card in deck.
                swipeCardView.frame.size = CGSize(width: swipeCardFrame.size.width, height: /*0.95**/swipeCardFrame.size.height)
                swipeCardView.center = aboveView.center
                swipeCardView.initialize(user1Id: id, user1PhotoURL: photo, user1Name: name!, user1Status: status!, user1City: location, user2Id: id2, user2PhotoURL: photo2, user2Name: name2!, user2Status: status2!, user2City: location2, connectionType: connectionType)
                swipeCardView.isUserInteractionEnabled = false
                swipeCardView.frame = smallestSwipeCardFrame()
                swipeCardView.center.x = view.center.x
                self.view.insertSubview(swipeCardView, belowSubview: aboveView)
                
            } else {
                //Second card should also have dark layer that fades away with swipe of first card in deck.
                swipeCardView.frame.size = CGSize(width: swipeCardFrame.size.width, height: /*0.95**/swipeCardFrame.size.height)
                swipeCardView.center = aboveView.center
                swipeCardView.initialize(user1Id: id, user1PhotoURL: photo, user1Name: name!, user1Status: status!, user1City: location, user2Id: id2, user2PhotoURL: photo2, user2Name: name2!, user2Status: status2!, user2City: location2, connectionType: connectionType)
                swipeCardView.isUserInteractionEnabled = false
                swipeCardView.frame = smallestSwipeCardFrame()
                swipeCardView.center.x = view.center.x
                self.view.insertSubview(swipeCardView, belowSubview: aboveView)
            }
        }
        else {
            swipeCardView.frame = swipeCardView.swipeCardFrame()
            swipeCardView.center.x = view.center.x
            swipeCardView.initialize(user1Id: id, user1PhotoURL: photo, user1Name: name!, user1Status: status!, user1City: location, user2Id: id2, user2PhotoURL: photo2, user2Name: name2!, user2Status: status2!, user2City: location2, connectionType: connectionType)
            swipeCardFrame = swipeCardView.frame
            
            self.view.insertSubview(swipeCardView, belowSubview: connectIcon)

			swipeCardView.overlay.removeFromSuperlayer()
        }
        
        // add gesture recognizers for displaying user profile
        let showProfileTopGR = UITapGestureRecognizer(target: self, action: #selector(showProfileTop(_:)))
        swipeCardView.topHalf.addGestureRecognizer(showProfileTopGR)
        
        let showProfileBottomGR = UITapGestureRecognizer(target: self, action: #selector(showProfileBottom(_:)))
        swipeCardView.bottomHalf.addGestureRecognizer(showProfileBottomGR)
        
        //Making sure disconnect and connect Icons are at the front of the view
        arrayOfCardsInDeck.append(swipeCardView)
        arrayOfCardColors.append(swipeCardView.layer.borderColor!)

        return swipeCardView
    }
    
    func showProfileTop(_ gesture: UIGestureRecognizer) {
        let topHalf = gesture.view
        if let swipeCard = topHalf?.superview as? SwipeCard {
            if let user1Id = swipeCard.cardsUser1Id {
                let profileVC = OtherProfileViewController(userId: user1Id)
                present(profileVC, animated: false, completion: nil)
            }
        }
    }
    
    func showProfileBottom(_ gesture: UIGestureRecognizer) {
        let bottomHalf = gesture.view
        if let swipeCard = bottomHalf?.superview as? SwipeCard {
            if let user2Id = swipeCard.cardsUser2Id {
                let profileVC = OtherProfileViewController(userId: user2Id)
                present(profileVC, animated: false, completion: nil)
            }
        }
    }
    
    func checkForNotification(){
        self.badgeCount = 0
        let query: PFQuery = PFQuery(className: "Messages")
        query.whereKey("ids_in_message", contains: PFUser.current()?.objectId)
        query.cachePolicy = .networkElseCache
        query.findObjectsInBackground(block: { (results, error) -> Void in
            if error == nil {
                if let results = results {
                    for i in 0..<results.count{
                        let result = results[i]
                        if let _ = result["message_viewed"] {
                            let whoViewed = result["message_viewed"] as! ([String])
                            if whoViewed.contains((PFUser.current()?.objectId)!) {
                                self.badgeCount += 0 //current user viewed the message
                            }
                            else {
                                self.badgeCount += 1//current user did not view the message
                                break
                            }
                        }
                        else {
                            self.badgeCount += 1//current user did not view the message
                            break
                        }
                    }
                    if self.badgeCount > 0 {
                        DispatchQueue.main.async(execute: {
                            self.customNavigationBar.updateRightBarButton(newIcon: "Inbox_Navbar_Icon_Notification", newSelectedIcon: "Inbox_Navbar_Icon_Notification")
                        })
                    }
                }
            }
        })
    }
    func displayNavigationBar(){
        rightBarButton.addTarget(self, action: #selector(rightBarButtonTapped(_:)), for: .touchUpInside)
        leftBarButton.addTarget(self, action: #selector(leftBarButtonTapped(_:)), for: .touchUpInside)
        
        //setting messagesIcon to the icon specifying if there are or are not notifications
        let rightBarButtonIcon = "Inbox_Navbar_Icon"
        let rightBarButtonSelectedIcon = "Inbox_Navbar_Icon"

        customNavigationBar.createCustomNavigationBar(view: view, leftBarButtonIcon: "Profile_Navbar_Icon", leftBarButtonSelectedIcon: "Profile_Icon_Yellow", leftBarButton: leftBarButton, rightBarButtonIcon: rightBarButtonIcon, rightBarButtonSelectedIcon: rightBarButtonSelectedIcon, rightBarButton: rightBarButton, title: "necter")
        checkForNotification()
    }
    func leftBarButtonTapped (_ sender: UIBarButtonItem){
        performSegue(withIdentifier: "showMyProfileFromBridgePage", sender: self)
        leftBarButton.isSelected = true
    }
    func rightBarButtonTapped (_ sender: UIBarButtonItem){
        performSegue(withIdentifier: "showMessagesPageFromBridgeView", sender: self)
        rightBarButton.isSelected = true
    }
    
    // downloads  bridge pairings of different types depending upon the typeOfCards
    func getBridgePairings(_ maxNoOfCards:Int, typeOfCards:String, callBack: ((_ bridgeType: String)->Void)?, bridgeType: String?){
        
        //Turning noMoreCards Label and Button off if they are displayed
        if displayNoMoreCardsLabel.alpha == 1 {
            displayNoMoreCardsLabel.alpha = 0
            revisitButton.alpha = 0
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
                        query.addDescendingOrder("score")
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
                                    if let ob = result["user1_profile_picture_url"] as? String {
                                        profilePictureFile1 = ob
                                    }
                                    if let ob = result["user2_profile_picture_url"] as? String {
                                        profilePictureFile2 = ob
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
                                    
                                    DispatchQueue.main.async(execute: {
                                        
                                        //Turning noMoreCards Label and Button off if they are displayed
                                        if self.displayNoMoreCardsLabel.alpha == 1 {
                                            self.displayNoMoreCardsLabel.alpha = 0
                                            self.revisitButton.alpha = 0
                                        }

										var bridgeType = BridgeType.business

										if bridgeType1 != nil
										{
											bridgeType = BridgeType(fromParseValue: bridgeType1!)
										}

										var aboveView: UIView? = self.lastCardInStack

										aboveView = self.addCardPairView(aboveView, 
										                                 id: userId1, 
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
										                                 type: bridgeType, 
										                                 pairing: userInfoPair)

										self.lastCardInStack = aboveView!
                                    })
                                }
                            }
                            
                            DispatchQueue.main.async(execute: {
                            if noOfResults == 0 && self.lastCardInStack == nil && self.displayNoMoreCardsLabel.alpha == 0{
                                self.displayNoMoreCards()
                            }
                            })
                            
                            if callBack != nil && bridgeType != nil {
                                callBack!(bridgeType!)
                            }
                        })
                        
                        i += 1
                        if i > 3 || typeOfCards != "EachOfAllType"{
                            getMorePairings = false
                        }
                    }
                }
            } else {
                self.displayNoMoreCards()
            }
            }
        }
    }
    func updateBridgePage(_ notification: Notification) {
        let aps = (notification as NSNotification).userInfo!["aps"] as? NSDictionary
        badgeCount = (aps!["badge"] as? Int)!
        DispatchQueue.main.async(execute: {
            
            if self.badgeCount > 0 {
                self.customNavigationBar.updateRightBarButton(newIcon: "Inbox_Navbar_Icon_Notification", newSelectedIcon: "Inbox_Navbar_Icon_Notification")
            }
        })
    }
    func displayMessageFromBot(_ notification: Notification) {
        missionControlView.close()
        
        let sendingNotificationView = SendingNotificationView()
        sendingNotificationView.initialize(view: view, sendingText: "Sending...", successText: "Success")
        view.addSubview(sendingNotificationView)
        view.bringSubview(toFront: view)
    }
    func displayBackgroundView(){
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight))
        backgroundView.backgroundColor = .white
        view.addSubview(backgroundView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        secondSwipeCard.tag = 0
        
        //Creating Notifications
        //Listener for Post Status Notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.displayMessageFromBot), name: NSNotification.Name(rawValue: "displayMessageFromBot"), object: nil)
        //Listener for updating messages Icon with notifications
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateBridgePage), name: NSNotification.Name(rawValue: "updateBridgePage"), object: nil)
        //Lister for updating filter from Mission Control being tapped
        NotificationCenter.default.addObserver(self, selector: #selector(self.filtersTapped), name: NSNotification.Name(rawValue: "filtersTapped"), object: nil)
        
        // Displaying UI Features
        displayBackgroundView()
        displayNavigationBar()
        
        initializeNoMoreCards()

		let bridgePairings = localData.getPairings()

		if (bridgePairings == nil || bridgePairings!.count < 1)
		{
			getBridgePairings(2,typeOfCards: "EachOfAllType", callBack: nil, bridgeType: nil)
		}
		else if bridgePairings != nil && bridgePairings!.count < 2
		{
			getBridgePairings(1,typeOfCards: "EachOfAllType", callBack: nil, bridgeType: nil)
		}
		else
		{
			displayCards()
		}

        connectIcon.image = UIImage(named: "Necter_Icon")
        connectIcon.alpha = 0.0
        view.insertSubview(connectIcon, belowSubview: missionControlView.blackBackgroundView)
        
        disconnectIcon.image = UIImage(named: "Disconnect_Icon")
        disconnectIcon.alpha = 0.0
        view.insertSubview(disconnectIcon, belowSubview: missionControlView.blackBackgroundView)

        wasLastSwipeInDeck = false
        
        //Create Mission Control
        //missionControlView.initialize(view: view, revisitLabel: displayNoMoreCardsLabel, revisitButton: revisitButton)
        
        //Check for AcceptedConnectionNotification
        let dbRetrievingFunctions = DBRetrievingFunctions()
        dbRetrievingFunctions.queryForAcceptedConnectionNotifications(vc: self)
        //Set Notification for PushNotification Listener
        
    }
    override func viewDidLayoutSubviews() {
        
    }
    override func viewDidAppear(_ animated: Bool) {
		PFCloudFunctions().updateApplicationBadge()

        // Display the swipe tutorial popup if it has yet to be shown
        if let hasSeenSwipeTutorialPopup = localData.getFirstTimeOnBridgeVC() {
            if hasSeenSwipeTutorialPopup {
                let alert = UIAlertController(title: "How to 'nect!", message: "Our algorithm pairs two of your friends. Swipe right to introduce them. Swipe left to see the next pair.", preferredStyle: UIAlertControllerStyle.alert)
                //Create the actions
                alert.addAction(UIAlertAction(title: "Got it", style: .default, handler: { (action) in
                    self.localData.setFirstTimeOnBridgeVC(false)
                    self.localData.synchronize()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }

    }

	func smallestSwipeCardFrame () -> CGRect {
		let maxFrame = swipeCardView.swipeCardFrame()
		let percent = CGFloat(secondSwipeCardShrinkPercentage)
		let inset = CGSize(width: maxFrame.size.width * percent, 
		                   height: maxFrame.size.height * percent)

		return CGRect(x: maxFrame.origin.x + inset.width, 
		              y: maxFrame.origin.y + inset.height, 
		              width: maxFrame.size.width - (inset.width * 2), 
		              height: maxFrame.size.height - (inset.height * 2))
	}

    func isDragged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        swipeCardView = gesture.view as! SwipeCard
        swipeCardView.center = CGPoint(x: DisplayUtility.screenWidth / 2 + translation.x, y: DisplayUtility.screenHeight / 2 + translation.y)
        let xFromCenter = swipeCardView.center.x - self.view.bounds.width / 2
        let scale = min(CGFloat(1.0), 1)
        var rotation = CGAffineTransform(rotationAngle: -xFromCenter / 1000)
        var stretch = rotation.scaledBy(x: scale, y: scale)
        swipeCardView.transform = stretch
        var removeCard = false
        var showReasonForConnection = false

        //Displaying and Removing the connect and disconnect icons
        let disconnectIconX = max(min((-1.5*(swipeCardView.center.x/DisplayUtility.screenWidth)+0.6)*DisplayUtility.screenWidth, 0.1*DisplayUtility.screenWidth), 0)
        let connectIconX = max(min(((-2.0/3.0)*(swipeCardView.center.x/DisplayUtility.screenWidth)+1.0)*DisplayUtility.screenWidth, 0.6*DisplayUtility.screenWidth), 0.5*DisplayUtility.screenWidth)
        
        //Limiting Y axis of swipe
        if swipeCardView.center.y > swipeCardFrame.origin.y + 0.5*swipeCardFrame.height  {
            swipeCardView.center.y = swipeCardFrame.origin.y + 0.5*swipeCardFrame.height
        } else if swipeCardView.center.y < swipeCardFrame.origin.y + 0.5*swipeCardFrame.height  {
            swipeCardView.center.y = swipeCardFrame.origin.y + 0.5*swipeCardFrame.height
        }
        
        //animating connect and disconnect icons when card is positioned from 0.4% of DisplayUtility.screenWidth to 0.25% of DisplayUtility.screenWidth
        if swipeCardView.center.x < 0.4*DisplayUtility.screenWidth{
            
            //fading in with swipe left from 0.4% of DisplayUtility.screenWidth to 0.25% of screen width
            self.disconnectIcon.alpha = -6.66*(swipeCardView.center.x/DisplayUtility.screenWidth)+2.66
            self.disconnectIcon.frame = CGRect(x: disconnectIconX, y: 0.33*DisplayUtility.screenHeight, width: 0.4*DisplayUtility.screenWidth, height: 0.4*DisplayUtility.screenWidth)
            
        } else if swipeCardView.center.x > 0.6*DisplayUtility.screenWidth {
            
            //fading in with swipe right from 0.6% of DisplayUtility.screenWidth to 0.75% of screen width
            self.connectIcon.alpha = 6.66*(swipeCardView.center.x/DisplayUtility.screenWidth)-4
            self.connectIcon.frame = CGRect(x: connectIconX, y: 0.33*DisplayUtility.screenHeight, width: 0.4*DisplayUtility.screenWidth, height: 0.4*DisplayUtility.screenWidth)
            
        } else {
            
            self.disconnectIcon.alpha = -6.66*(swipeCardView.center.x/DisplayUtility.screenWidth)+2.66
            self.disconnectIcon.frame = CGRect(x: disconnectIconX, y: 0.33*DisplayUtility.screenHeight, width: 0.4*DisplayUtility.screenWidth, height: 0.4*DisplayUtility.screenWidth)
            self.connectIcon.frame = CGRect(x: connectIconX, y: 0.33*DisplayUtility.screenHeight, width: 0.4*DisplayUtility.screenWidth, height: 0.4*DisplayUtility.screenWidth)

            self.connectIcon.alpha = 6.66*(swipeCardView.center.x/DisplayUtility.screenWidth)-4
            
        }

		if gesture.state == .began {
			secondSwipeCard.frame = smallestSwipeCardFrame()
			secondSwipeCard.center.x = view.center.x
		}

		if gesture.state == .changed {
			let multiplier = CGFloat(secondSwipeCardShrinkPercentage)
			let cardCenterX = swipeCardView.center.x
			let screenMiddleX = DisplayUtility.screenWidth / 2
			let direction: CGFloat = cardCenterX <= screenMiddleX ? screenMiddleX - cardCenterX : cardCenterX - screenMiddleX
			let percent: CGFloat = min(max(0.05 * (direction / screenMiddleX) + multiplier, multiplier), 1.0)
			let maxFrame = swipeCardView.swipeCardFrame()
			let inset = CGSize(width: maxFrame.width * percent, 
			                   height: maxFrame.height * percent)
			let differential = CGSize(width: maxFrame.size.width - inset.width, 
			                          height: maxFrame.size.height - inset.height)

			secondSwipeCard.frame = CGRect(origin: CGPoint(x: max(maxFrame.origin.x + differential.width, maxFrame.origin.x), 
			                                               y: max(maxFrame.origin.y + differential.height, maxFrame.origin.y)), 
			                               size: CGSize(width: min(abs(maxFrame.width - (inset.width * 2)), maxFrame.width), 
			                                            height: min(abs(maxFrame.height - (inset.height * 2)), maxFrame.height)))

			let overlayMultiplier = CGFloat(secondSwipeCard.defaultOverlayOpacity)
			var overlayPercent: CGFloat = 2.0 * (direction / screenMiddleX) - overlayMultiplier

			if overlayPercent < 0 {
				overlayPercent = abs(overlayPercent)

				secondSwipeCard.overlay.opacity = Float(overlayPercent)
			}
		}

		if gesture.state == .ended {
            
            //User Swiped Left
            if swipeCardView.center.x < 0.25*DisplayUtility.screenWidth {
                let isFirstTimeSwipedLeft : Bool = localData.getFirstTimeSwipingLeft()!
                if isFirstTimeSwipedLeft {
                    //show alert for swiping right here and then bridging or not
                    let alert = UIAlertController(title: "Don't Connect?", message: "Dragging a pair of pictures to the left indicates you do not want to introduce the friends shown.", preferredStyle: UIAlertControllerStyle.alert)
                    //Create the actions
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                        
                    }))
                    alert.addAction(UIAlertAction(title: "Don't Connect", style: .default, handler: { (action) in
                        UIView.animate(withDuration: 0.2, animations: {
                            self.swipeCardView.center.x = -1.0*DisplayUtility.screenWidth
                            self.disconnectIcon.center.x = -1.0*DisplayUtility.screenWidth
                            self.disconnectIcon.alpha = 0.0
                            self.swipeCardView.overlay.opacity = 0.0
                            }, completion: { (success) in
                                self.nextPair()
                        })
                        removeCard = true
                        self.shouldCheckInPair = true
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    self.localData.setFirstTimeSwipingLeft(false)
                    self.localData.synchronize()
                } else {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.swipeCardView.center.x = -1.0*DisplayUtility.screenWidth
                        self.disconnectIcon.center.x = -1.0*DisplayUtility.screenWidth
                        self.disconnectIcon.alpha = 0.0
                        self.swipeCardView.overlay.opacity = 0.0
                        }, completion: { (success) in
                            self.nextPair()
                    })
                    removeCard = true
                    shouldCheckInPair = true
                }
            }
            //User Swiped Right
            else if swipeCardView.center.x > 0.75*DisplayUtility.screenWidth {
                UIView.animate(withDuration: 0.4, animations: {
                    self.swipeCardView.center.x = 1.6*DisplayUtility.screenWidth
                    self.connectIcon.center.x = 1.6*DisplayUtility.screenWidth
                    self.connectIcon.alpha = 0.0
                    self.swipeCardView.overlay.opacity = 0.0
                    }, completion: { (success) in
                        self.bridged()
                })
                removeCard = false
                showReasonForConnection = true
            }

			if removeCard
			{
				swipeCardView.removeFromSuperview()

				if arrayOfCardsInDeck.count > 1
				{
					swipeCardView = arrayOfCardsInDeck[0]
					swipeCardView.overlay.removeFromSuperlayer()
					secondSwipeCard = arrayOfCardsInDeck.indices.contains(1) ? arrayOfCardsInDeck[1] : SwipeCard()
                }
                
            } else if showReasonForConnection {
                
            }
			else
			{
				// Reset the cards
				self.disconnectIcon.center.x = -1.0 * DisplayUtility.screenWidth
				self.disconnectIcon.alpha = 0.0
				self.connectIcon.center.x = 1.6 * DisplayUtility.screenWidth
				self.connectIcon.alpha = 0.0

                UIView.animate( withDuration: 0.7, 
                                delay: 0, 
                                options: .allowUserInteraction, 
                                animations:
					{
						rotation = CGAffineTransform(rotationAngle: 0)
						stretch = rotation.scaledBy(x: 1, y: 1)
						self.swipeCardView.transform = stretch
						self.swipeCardView.frame = self.swipeCardFrame
						self.secondSwipeCard.frame = self.smallestSwipeCardFrame()
						self.secondSwipeCard.center.x = self.view.center.x
					}, 
                                completion: nil
				)
            }
        }
    }

    func bridged() {
        if let swipeCard = arrayOfCardsInDeck.first{
            let reasonForConnectionView = ReasonForConnection()
            reasonForConnectionView.initialize(vc: self)
            reasonForConnectionView.sendSwipeCard(swipeCardView: swipeCard)
            view.addSubview(reasonForConnectionView)
        }
    }
    func reasonForConnectionSent() {
        view.bringSubview(toFront: connectIcon)
        view.bringSubview(toFront: disconnectIcon)
        swipeCardView.removeFromSuperview()
        nextPair()
        let sendingNotificationView = SendingNotificationView()
        sendingNotificationView.initialize(view: view, sendingText: "Sending...", successText: "Success")
        view.addSubview(sendingNotificationView)
        view.bringSubview(toFront: sendingNotificationView)
        
    }
    func nextPair(){
        // Remove the pair only from bridgePairings in LocalData but not from arrayOfCards. That would be taken care of in callbackForNextPair. cIgAr - 08/25/16
        
        let bridgePairings = localData.getPairings()
        
        if var bridgePairings = bridgePairings {
            var x = 0
            for i in 0 ..< (bridgePairings.count) {
                if currentTypeOfCardsOnDisplay == .all || bridgePairings[x].user1?.bridgeType == currentTypeOfCardsOnDisplay.parseValue {
                    break
                }
                x = i
                
            }
            var objectId = String()
            if bridgePairings.count > 0  {
                objectId = (bridgePairings[x].user1?.objectId)!
                //If current user has swiped left then turn checked out to false
                if shouldCheckInPair {
                    let query = PFQuery(className:"BridgePairings")
                    query.getObjectInBackground(withId: objectId, block: { (result, error) -> Void in
                        if let result = result {
                            result["checked_out"] = false
                            result.saveInBackground()
                        }
                    })
                    shouldCheckInPair = false
                }
                bridgePairings.remove(at: x)
            } else {
                objectId = "no object to search for"
            }
            var bridgeType = "All"
            bridgeType = currentTypeOfCardsOnDisplay.parseValue
            
            localData.setPairings(bridgePairings)
            localData.synchronize()
            
            getBridgePairings(1, typeOfCards: bridgeType, callBack: callbackForNextPair, bridgeType:bridgeType)
        }
    }
    func callbackForNextPair(_ bridgeType:String) -> Void {
        if arrayOfCardsInDeck.count > 0 {
            
            //Enhancement Needed: This process should happen upon swipe left instead of after the callback
            arrayOfCardsInDeck.remove(at: 0)
            arrayOfCardColors.remove(at: 0)
            if arrayOfCardsInDeck.count > 0 {
                arrayOfCardsInDeck[0].isUserInteractionEnabled = true
				swipeCardView = arrayOfCardsInDeck[0]
				swipeCardView.overlay.removeFromSuperlayer()
				secondSwipeCard = arrayOfCardsInDeck.indices.contains(1) ? arrayOfCardsInDeck[1] : SwipeCard()
            }
            else {
                lastCardInStack = nil
                secondSwipeCardSet = false
                
                let bridgePairings = localData.getPairings()
                
                if (bridgePairings == nil || bridgePairings!.count < 1)
                {
                    getBridgePairings(2,typeOfCards: "EachOfAllType", callBack: nil, bridgeType: nil)
                }
                else if bridgePairings != nil && bridgePairings!.count < 2
                {
                    getBridgePairings(1,typeOfCards: "EachOfAllType", callBack: nil, bridgeType: nil)
                }
                else
                {
                    displayCards()
                }
//                //check if a bridgePairing is already stored in localData
//                var bridgePairingAlreadyStored = false
//                if currentTypeOfCardsOnDisplay == .all {
//                    let pairings = localData.getPairings()
//                    if pairings != nil && pairings!.count > 0 {
//                        bridgePairingAlreadyStored = true
//                    }
//                }
//                else {
//                    if let bridgePairings = localData.getPairings() {
//                        for pair in bridgePairings {
//                            if pair.user1?.bridgeType == currentTypeOfCardsOnDisplay.parseValue {
//                                bridgePairingAlreadyStored = true
//                            }
//                        }
//                    }
//                }
//                if bridgePairingAlreadyStored == false {
//                    print(1)
//                    self.displayNoMoreCards()
//                    PFUser.current()?.incrementKey("ran_out_of_pairs")
//                    PFUser.current()?.saveInBackground()
//                }
            }
        }
    }
    func postStatusTapped(_ sender: UIButton ){
        performSegue(withIdentifier: "showNewStatusViewController", sender: self)
    }
    func filtersTapped(_ notification: Notification){
        let type = missionControlView.whichFilter()
        switch(type){
        case "All Types":
            currentTypeOfCardsOnDisplay = .all
            displayNoMoreCardsLabel.text = "No active matches to 'nect. Please check back tomorrow."
            break
        case "Business":
            currentTypeOfCardsOnDisplay = .business
            displayNoMoreCardsLabel.text = "No active matches to 'nect for work. Please check back tomorrow."
            break
        case "Love":
            currentTypeOfCardsOnDisplay = .love
            displayNoMoreCardsLabel.text = "No active matches to 'nect for dating. Please check back tomorrow."
            break
        case "Friendship":
            currentTypeOfCardsOnDisplay = .friendship
            displayNoMoreCardsLabel.text = "No active matches to 'nect for friendship. Please check back tomorrow."
            break
        default:
            currentTypeOfCardsOnDisplay = .all
        }
        for i in 0..<arrayOfCardsInDeck.count {
            arrayOfCardsInDeck[i].removeFromSuperview()
        }
        arrayOfCardsInDeck.removeAll()
        arrayOfCardColors.removeAll()
        displayCards()
    }
    func revitalizeMyPairs(_ sender: UIButton!) {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 0.05*DisplayUtility.screenWidth,height: 0.05*DisplayUtility.screenWidth))
        activityIndicator.center.x = revisitButton.center.x
        activityIndicator.center.y = revisitButton.center.y
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.color = DisplayUtility.necterGray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        revisitButton.removeFromSuperview()
        NotificationCenter.default.addObserver(self, selector: #selector(self.revitalizeMyPairsHelper), name: NSNotification.Name(rawValue: "revitalizeMyPairsHelper"), object: nil)
        self.pfCloudFunctions.revitalizeMyPairs(parameters: ["bridgeType":currentTypeOfCardsOnDisplay.parseValue])
        self.lastCardInStack = nil
    }
    //after response from revitalize pairs, run this code
    func revitalizeMyPairsHelper(_ notification: Notification) {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        //displayNoMoreCardsLabel.removeFromSuperview()
        //Turning noMoreCards Label and Button off if they are displayed
        if displayNoMoreCardsLabel.alpha == 1 {
            displayNoMoreCardsLabel.alpha = 0
            revisitButton.alpha = 0
        }

        NotificationCenter.default.removeObserver(self)
        self.getBridgePairings(2, typeOfCards: currentTypeOfCardsOnDisplay.parseValue, callBack:nil, bridgeType:nil)
        PFUser.current()?.incrementKey("revitalized_pairs_count")
        PFUser.current()?.saveInBackground()
    }
    func connectionCanceled(swipeCardView: SwipeCard) {
        view.bringSubview(toFront: connectIcon)
        view.bringSubview(toFront: disconnectIcon)
        swipeCardView.alpha = 1
        connectIcon.center.x = 1.6*DisplayUtility.screenWidth
        connectIcon.alpha = 0.0
        //Put swipeCard back into place
        let rotation = CGAffineTransform(rotationAngle: 0)
        let stretch = rotation.scaledBy(x: 1, y: 1)
        UIView.animate(withDuration: 0.7, animations: {
            swipeCardView.transform = stretch
            swipeCardView.frame = self.swipeCardFrame
			self.secondSwipeCard.frame = self.swipeCardView.frame
        })
    }
    
    func transitionToMessageWithID(_ id: String, color: UIColor, title: String) {
        self.messageId = id
        self.necterTypeColor = color
        self.singleMessageTitle = title
        self.segueToSingleMessage = true
        self.performSegue(withIdentifier: "showSingleMessage", sender: self)
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
            if mirror.subjectType == MyProfileViewController.self {
                self.transitionManager.animationDirection = "Left"
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
