//
//  MessagesViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 3/30/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

//Change to MessagesTableViewController so other can be MessageViewController

func getWeekDay(num:Int)->String{
    switch num {
    case 1: return "Sunday"
    case 2: return "Monday"
    case 3: return "Tuesday"
    case 4: return "Wednesday"
    case 5: return "Thursday"
    case 6: return "Friday"
    case 7: return "Saturday"
    default : return "A good day to die hard!"
    }
}


class MessagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchResultsUpdating {
    @IBOutlet var tableView: UITableView!
    
    //screen proportions
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    //necter colors
    let necterYellow = UIColor(red: 255/255, green: 230/255, blue: 57/255, alpha: 1.0)
    let businessBlue = UIColor(red: 36.0/255, green: 123.0/255, blue: 160.0/255, alpha: 1.0)
    let loveRed = UIColor(red: 242.0/255, green: 95.0/255, blue: 92.0/255, alpha: 1.0)
    let friendshipGreen = UIColor(red: 112.0/255, green: 193.0/255, blue: 179.0/255, alpha: 1.0)
    let necterGray = UIColor(red: 80.0/255.0, green: 81.0/255.0, blue: 79.0/255.0, alpha: 1.0)
    
    //creating navigation Bar
    let navigationBar = UINavigationBar()
    let necterButton = UIButton()
    
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
    
    //message information
    let noMessagesLabel = UILabel()
    var names = [String : [String]]()
    var messages = [String : String]()
    var messageType = [String : String]()
    var messageViewed = [String : Bool]()
    var messageTimestamps = [String : NSDate?]()
    var messagePositionToMessageIdMapping = [Int:String]()
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredPositions = [Int]()
    var toolbarTapped = false
    var encounteredBefore: [Int:Bool] = [:]
    var noOfElementsProcessed = 0
    var noOfElementsPerRefresher = 2
    var noOfElementsFetched = 0
    var totalElements = 0
    var isElementCountNotFetched = true
    var refresher:UIRefreshControl!
    var pagingSpinner : UIActivityIndicatorView!
    var runBackgroundThread = true
    
    var segueToSingleMessage = false
    var singleMessageId = ""
    let transitionManager = TransitionManager()
    
    var messageId = String()
    var singleMessageTitle = "Conversation"
    
    /*@IBAction func segueToBridgeViewController(sender: AnyObject) {
        self.runBackgroundThread = false
        navigationController?.popViewControllerAnimated(true)
        
    }
    @IBAction func composeMessage(sender: AnyObject) {
        performSegueWithIdentifier("showNewMessageFromMessages", sender: self)
    }
    
    // startBackgroundThread() reloads the table when the 3 async Parse tasks are complete
    @IBAction func bridgeTapped(sender: AnyObject) {
        performSegueWithIdentifier("showBridgeFromMessages", sender: self)
    }*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            NSNotificationCenter.defaultCenter().removeObserver(self)
           self.runBackgroundThread = false
        if segueToSingleMessage {
            //print(" prepareForSegue was Called")
            segueToSingleMessage = false
            let singleMessageVC:SingleMessageViewController = segue.destinationViewController as! SingleMessageViewController
            singleMessageVC.transitioningDelegate = self.transitionManager
            singleMessageVC.isSeguedFromMessages = true
            singleMessageVC.newMessageId = self.singleMessageId
           
        }
        else {
            let vc = segue.destinationViewController
            let mirror = Mirror(reflecting: vc)
            if mirror.subjectType == BridgeViewController.self {
                self.transitionManager.animationDirection = "Left"
            } else if mirror.subjectType == NewBridgeStatusViewController.self {
                self.transitionManager.animationDirection = "Top"
                let vc2 = vc as! NewBridgeStatusViewController
                vc2.seguedFrom = "MessagesViewController"
            } else if mirror.subjectType == SingleMessageViewController.self {
                self.transitionManager.animationDirection = "Right"
                let vc2 = vc as! SingleMessageViewController
                vc2.seguedFrom = "MessagesViewController"
            }
            vc.transitioningDelegate = self.transitionManager
            
        }

//        if let _ = self.navigationController{
//            print("no - \(navigationController?.viewControllers.count)")
//            if (navigationController?.viewControllers.count)! > 1 {
//            for _ in (1..<(navigationController?.viewControllers.count)!).reverse()  {
//                navigationController?.viewControllers.removeAtIndex(0)
//            }
//            }
//            
//            navigationController?.viewControllers.removeAll()
//        }

    }
    func startBackgroundThread() {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
//            while self.runBackgroundThread && (self.isElementCountNotFetched || self.names.count < self.totalElements || self.messageTimestamps.count < self.totalElements ||  self.messages.count <  self.totalElements   ) {
//
//                if self.encounteredBefore[self.noOfElementsFetched] == nil && self.noOfElementsFetched > 0 && self.names.count == self.noOfElementsFetched && self.messages.count == self.noOfElementsFetched && self.messageTimestamps.count == self.noOfElementsFetched{
//                    self.encounteredBefore[self.noOfElementsFetched] = true
//                    dispatch_async(dispatch_get_main_queue(), {
//                        //self.refresher.endRefreshing()
//                        //print("reloadData")
//                        self.tableView.reloadData()
//                        print("stop animating")
//                        self.pagingSpinner.stopAnimating()
//                    })
//                }
//                
//            }
//            //print("backgroundThread stopped")
//        }
    }
    // refresh() fetches the data from Parse
    func refresh() {
        //self.refresher.endRefreshing()
        
        let query: PFQuery = PFQuery(className: "Messages")
        query.whereKey("ids_in_message", containsString: PFUser.currentUser()?.objectId)
        query.orderByDescending("lastSingleMessageAt")
        query.skip = noOfElementsFetched
        query.limit = noOfElementsPerRefresher
        query.cachePolicy = .NetworkElseCache
        query.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
            
            if let error = error {
                print("refresh findObjectsInBackgroundWithBlock error - \(error)")
            }
            else if let results = results {
                self.noOfElementsFetched += results.count
                //print("self.noOfElementsFetched \(self.noOfElementsFetched)")
                for i in 0..<results.count{
                    
                    let result = results[i]
                    self.messagePositionToMessageIdMapping[self.noOfElementsProcessed] = result.objectId!
                    self.noOfElementsProcessed += 1
                    //print( "\(self.noOfElementsProcessed) - \(result["lastSingleMessageAt"] as! (NSDate))")
                    //self.IDsOfMessages.append(result.objectId!)
                    if let _ = result["message_type"] {
                        self.messageType[result.objectId!] = (result["message_type"] as! (String))
                    }
                    else {
                        self.messageType[result.objectId!] = ("Default")
                    }
                    if let _ = result["lastSingleMessageAt"] {
                        self.messageTimestamps[result.objectId!] =  (result["lastSingleMessageAt"] as! (NSDate))
                    }
                    else {
                        self.messageTimestamps[result.objectId!] = NSDate()
                    }
                    if let _ = result["message_viewed"] {
                        let whoViewed = result["message_viewed"] as! ([String])
                        if whoViewed.contains((PFUser.currentUser()?.objectId)!) {
                            self.messageViewed[result.objectId!] = (true)
                            //print("1")
                        }
                        else {
                            self.messageViewed[result.objectId!] = (false)
                            //print("2")
                        }
                    }
                    else {
                        self.messageViewed[result.objectId!]=(false)
                        //print("3")
                    }

                    let message_userids = result["ids_in_message"] as! [String]
                    
                    //get all those involved in this chat
                    let userQuery = PFQuery(className:"_User")
                    userQuery.whereKey("objectId", containedIn:message_userids)
                    userQuery.cachePolicy = .NetworkElseCache
                    userQuery.findObjectsInBackgroundWithBlock({(results, error) -> Void in
                    var names_per_message = [String]()
                    if (error == nil) {
                        for userObject in results! {
                            names_per_message.append(userObject["name"] as! String)
                        }
                    }
                    self.names[result.objectId!] = (names_per_message)
                    self.tableView.reloadData()
                    })
                    // get the message
                    let messageQuery = PFQuery(className:"SingleMessages")
                    messageQuery.whereKey("message_id", equalTo:result.objectId!)
                    messageQuery.orderByDescending("updatedAt")
                    messageQuery.cachePolicy = .NetworkElseCache
                    messageQuery.limit = 1
                    messageQuery.findObjectsInBackgroundWithBlock({(objects, error) -> Void in
                        if (error == nil) {
                            if objects!.count == 0{

                            //self.messages[result.objectId!] = ("Your new bridge awaits")
                            //self.messageTimestamps[result.objectId!] = (result.createdAt!)
                            self.messages[result.objectId!] = ("Your new connection awaits")
                            //self.messageTimestamps[result.objectId!] = (result.createdAt!)
                            }
                            else {
                                for messageObject in objects! {
                                    if let _ = messageObject["message_text"] {
                                        self.messages[result.objectId!] = (messageObject["message_text"] as! (String))
                                        //hide no messages Label because there are messages in the View
                                        print("got to messages")
                                    }
                                    else{
                                        self.messages[result.objectId!] = ("")
                                    }
                                    //self.messageTimestamps[result.objectId!] = ((messageObject.createdAt))
                                    break
                                    //friendsArray.append(object.objectId!)
                                }
                            }
                        }
                        else {
                            self.messages[result.objectId!] = ("")
                        }
                        self.tableView.reloadData()
                    })
                }
            }
           self.tableView.reloadData()
        })
    }
       // helper function for updateSearchResultsForSearchController
    func filterContentForSearchText(searchText:String, scope: String = "All"){
        filteredPositions = [Int]()
        for i in 0 ..< names.count  {
            var flag = true
            for individualNames in names[messagePositionToMessageIdMapping[i]!]!{
                if individualNames.lowercaseString.containsString(searchText.lowercaseString){
                    filteredPositions.append(i)
                    flag = false
                    break
                }
            }
            
            if flag && messages[messagePositionToMessageIdMapping[i]!]!.lowercaseString.containsString(searchText.lowercaseString){
                filteredPositions.append(i)
            }
        }
        tableView.reloadData()
        
    }
    // update search reults
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    func reloadMessageTable(notification: NSNotification) {
         print("Listened at reloadMessageTable" )
         names = [String : [String]]()
         messages = [String : String]()
         messageType = [String : String]()
         messageViewed = [String : Bool]()
         messageTimestamps = [String : NSDate?]()
         messagePositionToMessageIdMapping = [Int:String]()
        
         filteredPositions = [Int]()
         toolbarTapped = false
         encounteredBefore = [:]
         noOfElementsProcessed = 0
         noOfElementsFetched = 0
         let query: PFQuery = PFQuery(className: "Messages")
         query.whereKey("ids_in_message", containsString: PFUser.currentUser()?.objectId)
         query.orderByDescending("lastSingleMessageAt")
         query.limit = 1000
         query.cachePolicy = .NetworkElseCache
         query.countObjectsInBackgroundWithBlock{
            (count: Int32, error: NSError?) -> Void in
            if error == nil {
                self.totalElements = Int(count)
                self.refresh()
            }
            else {
                print(" not alive")
            }
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
    func postStatusTapped(sender: UIButton ){
        print("Post Tapped")
        performSegueWithIdentifier("showNewStatusViewControllerFromMessages", sender: self)
    }
    
    func filterTapped(sender: UIButton){
        let tag = sender.tag
        switch(tag){
            
        //all types filter tapped
        case 0:
            //updating which toolbar Button is selected
            allTypesButton.enabled = false
            businessButton.enabled = true
            loveButton.enabled = true
            friendshipButton.enabled = true
            
            //updating No Message Label Text
            noMessagesLabel.text = "You do not have any messages. Connect your friends to start a conversation."
            
            //updating textColor necter-Type labels
            let allTypesText = "All Types" as NSString
            let allTypesAttributedText = NSMutableAttributedString(string: allTypesText as String, attributes: [NSFontAttributeName: UIFont.init(name: "BentonSans", size: 11)!])
            allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: businessBlue , range: allTypesText.rangeOfString("All"))
            allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: loveRed , range: allTypesText.rangeOfString("Ty"))
            allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: friendshipGreen , range: allTypesText.rangeOfString("pes"))
            allTypesLabel.attributedText = allTypesAttributedText
            businessLabel.textColor = necterGray
            loveLabel.textColor = necterGray
            friendshipLabel.textColor = necterGray
            
            //filtering the messages table
            allBridgesTapped()
            break
            
        //business filter tapped
        case 1:
            //updating which toolbar Button is selected
            allTypesButton.enabled = true
            businessButton.enabled = false
            loveButton.enabled = true
            friendshipButton.enabled = true
            
            //updating No Message Label Text
            noMessagesLabel.text = "You do not have any messages for business. Connect your friends for business to start a conversation."
            
            //updating textColor necter-Type labels
            let allTypesText = "All Types" as NSString
            let allTypesAttributedText = NSMutableAttributedString(string: allTypesText as String, attributes: [NSFontAttributeName: UIFont.init(name: "BentonSans", size: 11)!])
            allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: necterGray , range: allTypesText.rangeOfString("All Types"))
            allTypesLabel.attributedText = allTypesAttributedText
            businessLabel.textColor = businessBlue
            loveLabel.textColor = necterGray
            friendshipLabel.textColor = necterGray
            
            //filtering the messages table
            businessTapped()
            break
            
        //love filter tapped
        case 2:
            //updating which toolbar Button is selected
            allTypesButton.enabled = true
            businessButton.enabled = true
            loveButton.enabled = false
            friendshipButton.enabled = true
            
            //updating No Message Label Text
            noMessagesLabel.text = "You do not have any messages for love. Connect your friends for love to start a conversation."
            
            //updating textColor necter-Type labels
            let allTypesText = "All Types" as NSString
            let allTypesAttributedText = NSMutableAttributedString(string: allTypesText as String, attributes: [NSFontAttributeName: UIFont.init(name: "BentonSans", size: 11)!])
            allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: necterGray , range: allTypesText.rangeOfString("All Types"))
            allTypesLabel.attributedText = allTypesAttributedText
            businessLabel.textColor = necterGray
            loveLabel.textColor = loveRed
            friendshipLabel.textColor = necterGray
            
            //filtering the messages table
            loveTapped()
            break
        
        //friendship filter tapped
        case 3:
            //updating which toolbar Button is selected
            allTypesButton.enabled = true
            businessButton.enabled = true
            loveButton.enabled = true
            friendshipButton.enabled = false
            
            //updating No Message Label Text
            noMessagesLabel.text = "You do not have any messages for friendship. Connect your friends for friendship to start a conversation."
            
            //updating textColor necter-Type labels
            let allTypesText = "All Types" as NSString
            let allTypesAttributedText = NSMutableAttributedString(string: allTypesText as String, attributes: [NSFontAttributeName: UIFont.init(name: "BentonSans", size: 11)!])
            allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: necterGray , range: allTypesText.rangeOfString("All Types"))
            allTypesLabel.attributedText = allTypesAttributedText
            businessLabel.textColor = necterGray
            loveLabel.textColor = necterGray
            friendshipLabel.textColor = friendshipGreen
            
            //filtering the messages table
            friendshipTapped()
            break
        default:
            //updating which toolbar Button is selected
            allTypesButton.enabled = false
            businessButton.enabled = true
            loveButton.enabled = true
            friendshipButton.enabled = true
            
            //updating No Message Label Text
            
            //updating textColor necter-Type labels
            let allTypesText = "All Types" as NSString
            let allTypesAttributedText = NSMutableAttributedString(string: allTypesText as String, attributes: [NSFontAttributeName: UIFont.init(name: "BentonSans", size: 11)!])
            allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: businessBlue , range: allTypesText.rangeOfString("All"))
            allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: loveRed , range: allTypesText.rangeOfString("Ty"))
            allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: friendshipGreen , range: allTypesText.rangeOfString("pes"))
            allTypesLabel.attributedText = allTypesAttributedText
            businessLabel.textColor = necterGray
            loveLabel.textColor = necterGray
            friendshipLabel.textColor = necterGray
            
            //filtering the messages table
            allBridgesTapped()
        }
    }
    func friendshipTapped() {
        toolbarTapped = true
        filteredPositions = [Int]()
        
        //displaying noMessagesLabel when there are no messages in the filtered message type
        noMessagesLabel.alpha = 1
        for i in 0 ..< messageType.count{
            if messageType[messagePositionToMessageIdMapping[i]!]! == "Friendship" {
                filteredPositions.append(i)
                noMessagesLabel.alpha = 0
            }
        }
        self.tableView.reloadData()
    }
    func loveTapped() {
        toolbarTapped = true
        filteredPositions = [Int]()
        print("loveButtonClicked")
        noMessagesLabel.alpha = 1
        for i in 0 ..< messageType.count{
            if messageType[messagePositionToMessageIdMapping[i]!]! == "Love" {
                filteredPositions.append(i)
                noMessagesLabel.alpha = 0
            }
        }
        self.tableView.reloadData()
    }
    func businessTapped() {
        toolbarTapped = true
        filteredPositions = [Int]()
        noMessagesLabel.alpha = 1
        for i in 0 ..< messageType.count{
            if messageType[messagePositionToMessageIdMapping[i]!]! == "Business" {
                filteredPositions.append(i)
                noMessagesLabel.alpha = 0
            }
        }
        //print("Filtered positions count is \(messageType.count)")
        self.tableView.reloadData()
    }
    
    func allBridgesTapped() {
        toolbarTapped = true
        filteredPositions = [Int]()
        noMessagesLabel.alpha = 1
        for i in 0 ..< messageType.count{
            filteredPositions.append(i)
            noMessagesLabel.alpha = 0
        }
        
        self.tableView.reloadData()
    }
    func displayNavigationBar(){
        
        let navItem = UINavigationItem()
        
        //setting the necterIcon to the rightBarButtonItem
        //setting messagesIcon to the icon specifying if there are or are not notifications
        necterButton.setImage(UIImage(named: "All_Types_Icon_Gray"), forState: .Normal)
        necterButton.setImage(UIImage(named: "Necter_Icon"), forState: .Selected)
        necterButton.setImage(UIImage(named: "Necter_Icon"), forState: .Highlighted)
        necterButton.addTarget(self, action: #selector(necterIconTapped(_:)), forControlEvents: .TouchUpInside)
        necterButton.frame = CGRect(x: 0, y: 0, width: 0.085*screenWidth, height: 0.085*screenWidth)
        necterButton.contentMode = UIViewContentMode.ScaleAspectFill
        necterButton.clipsToBounds = true
        let rightBarButton = UIBarButtonItem(customView: necterButton)
        navItem.leftBarButtonItem = rightBarButton
        
        //setting the navBar color and title
        navigationBar.setItems([navItem], animated: false)
        
        let navBarTitleView = UIView()
        navBarTitleView.frame = CGRect(x: 0, y: 0, width: 0.06*screenHeight, height: 0.06*screenHeight)
        let titleImageView = UIImageView(image: UIImage(named: "Messages_Icon_Yellow"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: navBarTitleView.frame.size.width , height: navBarTitleView.frame.size.height)
        titleImageView.contentMode = UIViewContentMode.ScaleAspectFill
        titleImageView.clipsToBounds = true
        navBarTitleView.addSubview(titleImageView)
        navigationBar.topItem?.titleView = navBarTitleView
        
        navigationBar.barStyle = .Black
        navigationBar.barTintColor = UIColor.whiteColor()
        
        self.view.addSubview(navigationBar)
    }
    func necterIconTapped (sender: UIBarButtonItem) {
        necterButton.selected = true
        performSegueWithIdentifier("showBridgeFromMessages", sender: self)
    }
    func displayNoMessages() {
        let labelFrame: CGRect = CGRectMake(0,0, 0.85*screenWidth,screenHeight * 0.2)
        
        noMessagesLabel.frame = labelFrame
        noMessagesLabel.numberOfLines = 0
        noMessagesLabel.alpha = 1
        
        if businessButton.enabled == false {
            noMessagesLabel.text = "You do not have any messages for business. Connect your friends for business to start a conversation."
            print("business enabled = false")
        } else if loveButton.enabled == false {
            noMessagesLabel.text = "You do not have any messages for love. Connect your friends for love to start a conversation."
            print("love enabled = false")
        } else if friendshipButton.enabled == false {
            noMessagesLabel.text = "You do not have any messages for friendship. Connect your friends for friendship to start a conversation."
        } else {
            noMessagesLabel.text = "You do not have any messages. Connect your friends to start a conversation."
        }
        
        noMessagesLabel.font = UIFont(name: "BentonSans", size: 20)
        noMessagesLabel.textAlignment = NSTextAlignment.Center
        noMessagesLabel.center.y = view.center.y
        noMessagesLabel.center.x = view.center.x
        noMessagesLabel.layer.borderWidth = 2
        noMessagesLabel.layer.borderColor = necterGray.CGColor
        noMessagesLabel.layer.cornerRadius = 15
        
        view.addSubview(noMessagesLabel)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create NavigationBar
        displayNavigationBar()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.reloadMessageTable), name: "reloadTheMessageTable", object: nil)
        /*refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(MessagesViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refresher)*/
        
        
        let query: PFQuery = PFQuery(className: "Messages")
        query.whereKey("ids_in_message", containsString: PFUser.currentUser()?.objectId)
        
        query.orderByDescending("lastSingleMessageAt")
        query.limit = 1000
        query.cachePolicy = .NetworkElseCache
        //print("\n starting return")
        query.countObjectsInBackgroundWithBlock{
            (count: Int32, error: NSError?) -> Void in
            //print("returned")
            if error == nil {
                
                self.totalElements = Int(count)
                self.isElementCountNotFetched = false
                self.refresh()
                
                if self.totalElements == 0 {
                    self.displayNoMessages()
                } else {
                    self.noMessagesLabel.alpha = 0
                }
            }
            else {
                print(" not alive")
            }
        }
        startBackgroundThread()
       
        tableView.delegate = self
        tableView.dataSource = self
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
        pagingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        pagingSpinner.color = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        pagingSpinner.hidesWhenStopped = true
        tableView.tableFooterView = pagingSpinner
        tableView.separatorStyle = .None
        
        displayToolBar()
        allTypesButton.enabled = false

    }
    
    override func viewDidLayoutSubviews() {
        
        navigationBar.frame = CGRect(x: 0, y:0, width:screenWidth, height:0.11*screenHeight)
        tableView.frame = CGRect(x: 0, y:0.11*screenHeight, width:screenWidth, height:0.79*screenHeight)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //print ("indexPath - \(indexPath.row) & noOfElementsFetched - \(noOfElementsFetched)" )
//        if (indexPath.row == messages.count - 1 ) {
//            //print("refresh should be  called - \(noOfElementsFetched), \(totalElements)")
//            //print(messages)
//        }
        if (indexPath.row == messages.count - 1 && (noOfElementsFetched < totalElements) ) {
            if self.encounteredBefore[self.noOfElementsFetched] == nil {
                self.encounteredBefore[self.noOfElementsFetched] = true
                refresh()
                pagingSpinner.startAnimating()
                // setting whether no messages text should be displayed
                
            }

        }
//        if (indexPath.row == noOfElementsFetched - 1) && (noOfElementsFetched < totalElements) {
//        //print ("noOfElementsFetched, totalElements = \(noOfElementsFetched) & \(totalElements)")
//        //print("start animating")
//        pagingSpinner.startAnimating()
//        print("\(indexPath.row) - refresh called")
//        refresh()
//        }
        else {
            self.pagingSpinner.stopAnimating()
        }
//        if (indexPath.row == noOfElementsFetched - 1) && (noOfElementsFetched == totalElements) {
//        self.pagingSpinner.stopAnimating()
//        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //print("numberOfRowsInSection \( IDsOfMessages.count + 1) \(LocalData().getUsername())")
        if (searchController.active && searchController.searchBar.text != "") || toolbarTapped {
            //print ("Search term is \(searchController.searchBar.text) and number of results is \(filteredPositions.count)")
            return filteredPositions.count
        }
        
        return messages.count
        
    }

    // Data to be shown on an individual row
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //print("Row is \(indexPath.row) \(messageViewed)")
//        var names = self.names
//        var messages = self.messages
//        var messageType = self.messageType
//        var messageTimestamps = self.messageTimestamps
        var messagePositionToMessageIdMapping = self.messagePositionToMessageIdMapping
        let cell = MessagesTableCell()//tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MessagesTableCell
        //if indexPath.row != 0 {
            cell.setSeparator = true
        //}

        cell.cellHeight = screenHeight/6.0
        cell.cellHeight = 0.15 * screenHeight
        if (searchController.active && searchController.searchBar.text != "") || toolbarTapped {
//             names = [[String]]()
//             messages = [String]()
//             messageType = [String]()
//             messageTimestamps = [NSDate?]()
            var i = 0
            messagePositionToMessageIdMapping = [Int:String]()
            for index in filteredPositions {
                 messagePositionToMessageIdMapping[i] = self.messagePositionToMessageIdMapping[index]
                 i += 1
//                names.append(self.names[index])
//                messages.append(self.messages[index])
//                messageType.append(self.messageType[index])
//                messageTimestamps.append(self.messageTimestamps[index])
            }
        }
        if messagePositionToMessageIdMapping[indexPath.row] == nil || names[messagePositionToMessageIdMapping[indexPath.row]!] == nil || messages[messagePositionToMessageIdMapping[indexPath.row]!] == nil || messageTimestamps[messagePositionToMessageIdMapping[indexPath.row]!] == nil || messageType[messagePositionToMessageIdMapping[indexPath.row]!] == nil{
            cell.participants.text = ""
            cell.messageSnapshot.text = ""
            cell.messageTimestamp.text = ""
            cell.backgroundColor = UIColor.whiteColor()
            return cell
        }

        var stringOfNames = ""
        var users = names[messagePositionToMessageIdMapping[indexPath.row]!]!
        users = users.filter { $0 != PFUser.currentUser()?["name"] as! String }
        
        for i in 0 ..< users.count  {
            
            var name = users[i]
            if users.count > 2 && i < users.count - 2 {
                var fullNameArr = name.characters.split{$0 == " "}.map(String.init)
                stringOfNames = stringOfNames + fullNameArr[0] + " , "
                
            } else if users.count >= 2 && i == users.count - 2 {
                var fullNameArr = name.characters.split{$0 == " "}.map(String.init)
                stringOfNames = stringOfNames + fullNameArr[0] + " & "
                
            }
            else {
                if users.count > 1{
                    name = name.characters.split{$0 == " "}.map(String.init)[0]
                }
                stringOfNames = stringOfNames + name
            }
            
        }
        
        cell.participants.text = stringOfNames
        cell.messageSnapshot.text = messages[messagePositionToMessageIdMapping[indexPath.row]!]!
        cell.arrow.text = ">"
        
        
        if messageViewed[messagePositionToMessageIdMapping[indexPath.row]!]! {
            cell.notificationDot.hidden = true
        } else {
            cell.notificationDot.hidden = false
        }
        switch messageType[messagePositionToMessageIdMapping[indexPath.row]!]!{
            
        case "Business":
            cell.participants.textColor = businessBlue
            cell.arrow.textColor = businessBlue
            //cell.line.backgroundColor = businessBlue
            break
        case "Love":
            cell.participants.textColor = loveRed
            cell.arrow.textColor = loveRed
            //cell.line.backgroundColor = loveRed
            break
        case "Friendship":
            cell.participants.textColor = friendshipGreen
            cell.arrow.textColor = friendshipGreen
            //cell.line.backgroundColor = friendshipGreen
            break
        default: cell.participants.textColor = friendshipGreen
            cell.arrow.textColor = friendshipGreen
            //cell.line.backgroundColor = friendshipGreen
            
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyy hh:mm:ss +zzzz"
        let calendar = NSCalendar.currentCalendar()
        let date = (messageTimestamps[messagePositionToMessageIdMapping[indexPath.row]!]!)!
        let components = calendar.components([ .Day],
                                             fromDate: date, toDate: NSDate(), options: NSCalendarOptions.WrapComponents)
        //print("row, date, day -\(indexPath.row) \(date) \(components.day)")
        if components.day > 7 {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyy"
            //print(dateFormatter.stringFromDate(date))
            cell.messageTimestamp.text = dateFormatter.stringFromDate(date)
        }
        else if components.day >= 2 {
            let calendar = NSCalendar.currentCalendar()
            let date = (messageTimestamps[messagePositionToMessageIdMapping[indexPath.row]!]!)!
            let components = calendar.components([.Weekday],
                                                 fromDate: date)
            //print(components.weekday)
            cell.messageTimestamp.text = String(getWeekDay(components.weekday))
        }
        else if components.day >= 1 {
            //print ("Yesterday")
            cell.messageTimestamp.text = "Yesterday"
        }
        else {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            cell.messageTimestamp.text = dateFormatter.stringFromDate(date)
            //print(dateFormatter.stringFromDate(date))
            
        }
        if indexPath == filteredPositions.count - 1 {
            toolbarTapped = false
        }
        cell.separatorInset = UIEdgeInsetsMake(0.0, cell.bounds.size.width, 0.0, 0.0);
                return cell

        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return screenHeight/6.0
    }
    // A row is selected
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //var IDsOfMessages = self.IDsOfMessages
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as! MessagesTableCell
        var messagePositionToMessageIdMapping = self.messagePositionToMessageIdMapping
        if (searchController.active && searchController.searchBar.text != "") || toolbarTapped {
            //IDsOfMessages = [String]()
            messagePositionToMessageIdMapping = [Int:String]()
            var i = 0
            for index in filteredPositions {
                messagePositionToMessageIdMapping[i] = self.messagePositionToMessageIdMapping[index]
                i += 1
                //IDsOfMessages.append(self.IDsOfMessages[index])
            }
        }

        singleMessageTitle = (currentCell.participants?.text)!
        singleMessageId = messagePositionToMessageIdMapping[indexPath.row]!
        messageId = messagePositionToMessageIdMapping[indexPath.row ]!
        
        //previousViewController = "MessagesViewController"
        toolbarTapped = false
        self.runBackgroundThread = false
        let query: PFQuery = PFQuery(className: "Messages")
        query.getObjectInBackgroundWithId(messageId) {
            (messageObject: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            }
            else if let messageObject = messageObject {
                if let _ = messageObject["message_viewed"] {
                    var whoViewed = messageObject["message_viewed"] as! [String]
                    if !whoViewed.contains((PFUser.currentUser()?.objectId)!) {
                        whoViewed.append((PFUser.currentUser()?.objectId)!)
                        messageObject["message_viewed"] = whoViewed
                        messageObject.saveInBackground()
                        //print("1")
                    }
                }
                else {
                    //print ("messageObject[\"message_viewed\"] -\(messageObject["message_viewed"]) \(messageObject.objectId )")
                    messageObject["message_viewed"] = [ (PFUser.currentUser()?.objectId)! ]
                    messageObject.saveInBackground()
                    //print("2 \(messageId)")
                }
            }
        }
        segueToSingleMessage = true
        performSegueWithIdentifier("showSingleMessageFromMessages", sender: self)
    
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
