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

func getWeekDay(_ num:Int)->String{
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
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
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
    var messageTimestamps = [String : Date?]()
    var messagePositionToMessageIdMapping = [Int:String]()
    var necterTypeColor = UIColor()
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredPositions = [Int]()
    var toolbarTapped = false
    var encounteredBefore: [Int:Bool] = [:]
    var noOfElementsProcessed = 0
    var noOfElementsPerRefresher = 5
    var noOfElementsFetched = 0
    var totalElements = 0
    var isElementCountNotFetched = true
    var refresher:UIRefreshControl!
    var pagingSpinner : UIActivityIndicatorView!
    
    var segueToSingleMessage = false
    var singleMessageId = ""
    let transitionManager = TransitionManager()
    
    var messageId = String()
    var singleMessageTitle = "Conversation"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            NotificationCenter.default.removeObserver(self)
        if segueToSingleMessage {
            //print(" prepareForSegue was Called")
            segueToSingleMessage = false
            let singleMessageVC:SingleMessageViewController = segue.destination as! SingleMessageViewController
            singleMessageVC.transitioningDelegate = self.transitionManager
            singleMessageVC.isSeguedFromMessages = true
            singleMessageVC.newMessageId = self.singleMessageId
            singleMessageVC.necterTypeColor = necterTypeColor
            singleMessageVC.singleMessageTitle = singleMessageTitle
           
        }
        else {
            let vc = segue.destination
            let mirror = Mirror(reflecting: vc)
            if mirror.subjectType == BridgeViewController.self {
                self.transitionManager.animationDirection = "Left"
            } else if mirror.subjectType == OptionsFromBotViewController.self {
                self.transitionManager.animationDirection = "Top"
                let vc2 = vc as! OptionsFromBotViewController
                vc2.seguedFrom = "MessagesViewController"
            } else if mirror.subjectType == SingleMessageViewController.self {
                self.transitionManager.animationDirection = "Right"
                let vc2 = vc as! SingleMessageViewController
                vc2.seguedFrom = "MessagesViewController"
            }
            vc.transitioningDelegate = self.transitionManager
        }
    }
    
    // refresh() fetches the data from Parse
    func refresh() {
        //self.refresher.endRefreshing()
        
        let query: PFQuery = PFQuery(className: "Messages")
        query.whereKey("ids_in_message", contains: PFUser.current()?.objectId)
        query.order(byDescending: "lastSingleMessageAt")
        query.skip = noOfElementsFetched
        query.limit = noOfElementsPerRefresher
        query.cachePolicy = .networkElseCache
        query.findObjectsInBackground(block: { (results, error) -> Void in
            
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
                    if let _ = result["message_type"] {
                        self.messageType[result.objectId!] = (result["message_type"] as! (String))
                    }
                    else {
                        self.messageType[result.objectId!] = ("Default")
                    }
                    if let _ = result["lastSingleMessageAt"] {
                        self.messageTimestamps[result.objectId!] =  (result["lastSingleMessageAt"] as! (Date))
                    }
                    else {
                        self.messageTimestamps[result.objectId!] = Date()
                    }
                    if let _ = result["message_viewed"] {
                        let whoViewed = result["message_viewed"] as! ([String])
                        if whoViewed.contains((PFUser.current()?.objectId)!) {
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
                    if let _ = result["last_single_message"] {
                        self.messages[result.objectId!] = (result["last_single_message"] as! (String))
                    }
                    else {
                        self.messages[result.objectId!] = "Your new connection awaits"
                    }
                    var names_per_message = [String]()
                    if let names = result["names_in_message"] as? [String] {
                        for name in names {
                            names_per_message.append(name)
                        }
                        
                    }
                    self.names[result.objectId!] = (names_per_message)
//                    let message_userids = result["ids_in_message"] as! [String]
//                    
//                    //get all those involved in this chat
//                    let userQuery = PFQuery(className:"_User")
//                    userQuery.whereKey("objectId", containedIn:message_userids)
//                    userQuery.cachePolicy = .NetworkElseCache
//                    userQuery.findObjectsInBackgroundWithBlock({(results, error) -> Void in
//                    var names_per_message = [String]()
//                    if (error == nil) {
//                        for userObject in results! {
//                            names_per_message.append(userObject["name"] as! String)
//                        }
//                    }
//                    self.names[result.objectId!] = (names_per_message)
//                    self.tableView.reloadData()
//                    })
                    // get the message
//                    let messageQuery = PFQuery(className:"SingleMessages")
//                    messageQuery.whereKey("message_id", equalTo:result.objectId!)
//                    messageQuery.orderByDescending("updatedAt")
//                    messageQuery.cachePolicy = .NetworkElseCache
//                    messageQuery.limit = 1
//                    messageQuery.findObjectsInBackgroundWithBlock({(objects, error) -> Void in
//                        if (error == nil) {
//                            if objects!.count == 0{
//
//                            //self.messages[result.objectId!] = ("Your new bridge awaits")
//                            //self.messageTimestamps[result.objectId!] = (result.createdAt!)
//                            self.messages[result.objectId!] = ("Your new connection awaits")
//                            //self.messageTimestamps[result.objectId!] = (result.createdAt!)
//                            }
//                            else {
//                                for messageObject in objects! {
//                                    if let _ = messageObject["message_text"] {
//                                        self.messages[result.objectId!] = (messageObject["message_text"] as! (String))
//                                        //hide no messages Label because there are messages in the View
//                                        print("got to messages")
//                                    }
//                                    else{
//                                        self.messages[result.objectId!] = ("")
//                                    }
//                                    //self.messageTimestamps[result.objectId!] = ((messageObject.createdAt))
//                                    break
//                                    //friendsArray.append(object.objectId!)
//                                }
//                            }
//                        }
//                        else {
//                            self.messages[result.objectId!] = ("")
//                        }
//                        self.tableView.reloadData()
//                    })
                }
            }
           self.tableView.reloadData()
        })
    }
       // helper function for updateSearchResultsForSearchController
    func filterContentForSearchText(_ searchText:String, scope: String = "All"){
        filteredPositions = [Int]()
        for i in 0 ..< names.count  {
            var flag = true
            for individualNames in names[messagePositionToMessageIdMapping[i]!]!{
                if individualNames.lowercased().contains(searchText.lowercased()){
                    filteredPositions.append(i)
                    flag = false
                    break
                }
            }
            
            if flag && messages[messagePositionToMessageIdMapping[i]!]!.lowercased().contains(searchText.lowercased()){
                filteredPositions.append(i)
            }
        }
        tableView.reloadData()
        
    }
    // update search reults
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    func reloadMessageTable(_ notification: Notification) {
         print("Listened at reloadMessageTable" )
         names = [String : [String]]()
         messages = [String : String]()
         messageType = [String : String]()
         messageViewed = [String : Bool]()
         messageTimestamps = [String : Date?]()
         messagePositionToMessageIdMapping = [Int:String]()
        
         filteredPositions = [Int]()
         toolbarTapped = false
         encounteredBefore = [:]
         noOfElementsProcessed = 0
         noOfElementsFetched = 0
         let query: PFQuery = PFQuery(className: "Messages")
         query.whereKey("ids_in_message", contains: PFUser.current()?.objectId)
         query.order(byDescending: "lastSingleMessageAt")
         query.limit = 1000
         query.cachePolicy = .networkElseCache
         query.countObjectsInBackground{
            (count: Int32, error: Error?) in
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
        
        toolbar.frame = CGRect(x: 0, y: 0.9*screenHeight, width: screenWidth, height: 0.1*screenHeight)
        toolbar.backgroundColor = UIColor(red: 247/255.0, green: 247/255.0, blue: 247/255.0, alpha: 1.0)
        
        //creating buttons to be added to the toolbar and evenly spaced across
        allTypesButton.setImage(UIImage(named: "All_Types_Icon_Gray"), for: UIControlState())
        allTypesButton.setImage(UIImage(named: "All_Types_Icon_Colors"), for: .disabled)
        allTypesButton.frame = CGRect(x: 0.07083*screenWidth, y: 0, width: 0.1*screenWidth, height: 0.1*screenWidth)
        allTypesButton.center.y = toolbar.center.y - 0.005*screenHeight
        allTypesButton.addTarget(self, action: #selector(filterTapped), for: .touchUpInside)
        allTypesButton.tag = 0
        
        //coloring allTypesText three different colors
        let allTypesText = "All Types" as NSString
        let allTypesAttributedText = NSMutableAttributedString(string: allTypesText as String, attributes: [NSFontAttributeName: UIFont.init(name: "BentonSans", size: 11)!])
        allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: businessBlue , range: allTypesText.range(of: "All"))
        allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: loveRed , range: allTypesText.range(of: "Ty"))
        allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: friendshipGreen , range: allTypesText.range(of: "pes"))
        //setting allTypesText
        allTypesLabel.attributedText = allTypesAttributedText
        allTypesLabel.textAlignment =  NSTextAlignment.center
        allTypesLabel.frame = CGRect(x: 0, y: 0.975*screenHeight, width: 0.2*screenWidth, height: 0.02*screenHeight)
        allTypesLabel.center.x = allTypesButton.center.x
        
        
        businessButton.setImage(UIImage(named: "Business_Icon_Gray"), for: UIControlState())
        businessButton.setImage(UIImage(named:  "Business_Icon_Blue"), for: .disabled)
        businessButton.frame = CGRect(x: 0.24166*screenWidth, y: 0, width: 0.1*screenWidth, height: 0.1*screenWidth)
        businessButton.center.y = toolbar.center.y - 0.005*screenHeight
        businessButton.addTarget(self, action: #selector(filterTapped), for: .touchUpInside)
        businessButton.tag = 1
        
        businessLabel.text = "Business"
        businessLabel.textColor = necterGray
        businessLabel.font = UIFont(name: "BentonSans", size: 11)
        businessLabel.textAlignment =  NSTextAlignment.center
        businessLabel.frame = CGRect(x: 0, y: 0.975*screenHeight, width: 0.2*screenWidth, height: 0.02*screenHeight)
        businessLabel.center.x = businessButton.center.x
        
        loveButton.setImage(UIImage(named: "Love_Icon_Gray"), for: UIControlState())
        loveButton.setImage(UIImage(named: "Love_Icon_Red"), for: .disabled)
        loveButton.frame = CGRect(x: 0.65832*screenWidth, y: 0, width: 0.1*screenWidth, height: 0.1*screenWidth)
        loveButton.center.y = toolbar.center.y - 0.005*screenHeight
        loveButton.addTarget(self, action: #selector(filterTapped), for: .touchUpInside)
        loveButton.tag = 2
        
        loveLabel.text = "Love"
        loveLabel.font = UIFont(name: "BentonSans", size: 11)
        loveLabel.textColor = necterGray
        loveLabel.textAlignment =  NSTextAlignment.center
        loveLabel.frame = CGRect(x: 0, y: 0.975*screenHeight, width: 0.2*screenWidth, height: 0.02*screenHeight)
        loveLabel.center.x = loveButton.center.x
        
        friendshipButton.setImage(UIImage(named: "Friendship_Icon_Gray"), for: UIControlState())
        friendshipButton.setImage(UIImage(named:  "Friendship_Icon_Green"), for: .disabled)
        friendshipButton.frame = CGRect(x: 0.82915*screenWidth, y: 0, width: 0.1*screenWidth, height: 0.1150*screenWidth)
        friendshipButton.center.y = toolbar.center.y - 0.005*screenHeight
        friendshipButton.addTarget(self, action: #selector(filterTapped), for: .touchUpInside)
        friendshipButton.tag = 3
        
        friendshipLabel.text = "Friendship"
        friendshipLabel.font = UIFont(name: "BentonSans", size: 11)
        friendshipLabel.textColor = necterGray
        friendshipLabel.textAlignment =  NSTextAlignment.center
        friendshipLabel.frame = CGRect(x: 0, y: 0.975*screenHeight, width: 0.2*screenWidth, height: 0.02*screenHeight)
        friendshipLabel.center.x = friendshipButton.center.x
        
        
        postStatusButton.frame = CGRect(x: 0, y: 0, width: 0.175*screenWidth, height: 0.175*screenWidth)
        postStatusButton.backgroundColor = necterYellow
        postStatusButton.showsTouchWhenHighlighted = true
        postStatusButton.layer.borderWidth = 2.0
        postStatusButton.layer.borderColor = UIColor.white.cgColor
        postStatusButton.layer.cornerRadius = postStatusButton.frame.size.width/2.0
        postStatusButton.clipsToBounds = true
        //loveButton.layer.borderColor =
        postStatusButton.center.y = toolbar.center.y - 0.25*0.175*screenWidth
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
    func postStatusTapped(_ sender: UIButton ){
        print("Post Tapped")
        performSegue(withIdentifier: "showNewStatusViewControllerFromMessages", sender: self)
    }
    
    func filterTapped(_ sender: UIButton){
        let tag = sender.tag
        switch(tag){
            
        //all types filter tapped
        case 0:
            //updating which toolbar Button is selected
            allTypesButton.isEnabled = false
            businessButton.isEnabled = true
            loveButton.isEnabled = true
            friendshipButton.isEnabled = true
            
            //updating No Message Label Text
            noMessagesLabel.text = "You do not have any messages. Connect your friends to start a conversation."
            
            //updating textColor necter-Type labels
            let allTypesText = "All Types" as NSString
            let allTypesAttributedText = NSMutableAttributedString(string: allTypesText as String, attributes: [NSFontAttributeName: UIFont.init(name: "BentonSans", size: 11)!])
            allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: businessBlue , range: allTypesText.range(of: "All"))
            allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: loveRed , range: allTypesText.range(of: "Ty"))
            allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: friendshipGreen , range: allTypesText.range(of: "pes"))
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
            allTypesButton.isEnabled = true
            businessButton.isEnabled = false
            loveButton.isEnabled = true
            friendshipButton.isEnabled = true
            
            //updating No Message Label Text
            noMessagesLabel.text = "You do not have any messages for business. Connect your friends for business to start a conversation."
            
            //updating textColor necter-Type labels
            let allTypesText = "All Types" as NSString
            let allTypesAttributedText = NSMutableAttributedString(string: allTypesText as String, attributes: [NSFontAttributeName: UIFont.init(name: "BentonSans", size: 11)!])
            allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: necterGray , range: allTypesText.range(of: "All Types"))
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
            allTypesButton.isEnabled = true
            businessButton.isEnabled = true
            loveButton.isEnabled = false
            friendshipButton.isEnabled = true
            
            //updating No Message Label Text
            noMessagesLabel.text = "You do not have any messages for love. Connect your friends for love to start a conversation."
            
            //updating textColor necter-Type labels
            let allTypesText = "All Types" as NSString
            let allTypesAttributedText = NSMutableAttributedString(string: allTypesText as String, attributes: [NSFontAttributeName: UIFont.init(name: "BentonSans", size: 11)!])
            allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: necterGray , range: allTypesText.range(of: "All Types"))
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
            allTypesButton.isEnabled = true
            businessButton.isEnabled = true
            loveButton.isEnabled = true
            friendshipButton.isEnabled = false
            
            //updating No Message Label Text
            noMessagesLabel.text = "You do not have any messages for friendship. Connect your friends for friendship to start a conversation."
            
            //updating textColor necter-Type labels
            let allTypesText = "All Types" as NSString
            let allTypesAttributedText = NSMutableAttributedString(string: allTypesText as String, attributes: [NSFontAttributeName: UIFont.init(name: "BentonSans", size: 11)!])
            allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: necterGray , range: allTypesText.range(of: "All Types"))
            allTypesLabel.attributedText = allTypesAttributedText
            businessLabel.textColor = necterGray
            loveLabel.textColor = necterGray
            friendshipLabel.textColor = friendshipGreen
            
            //filtering the messages table
            friendshipTapped()
            break
        default:
            //updating which toolbar Button is selected
            allTypesButton.isEnabled = false
            businessButton.isEnabled = true
            loveButton.isEnabled = true
            friendshipButton.isEnabled = true
            
            //updating No Message Label Text
            
            //updating textColor necter-Type labels
            let allTypesText = "All Types" as NSString
            let allTypesAttributedText = NSMutableAttributedString(string: allTypesText as String, attributes: [NSFontAttributeName: UIFont.init(name: "BentonSans", size: 11)!])
            allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: businessBlue , range: allTypesText.range(of: "All"))
            allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: loveRed , range: allTypesText.range(of: "Ty"))
            allTypesAttributedText.addAttribute(NSForegroundColorAttributeName, value: friendshipGreen , range: allTypesText.range(of: "pes"))
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
        necterButton.setImage(UIImage(named: "All_Types_Icon_Gray"), for: UIControlState())
        necterButton.setImage(UIImage(named: "Necter_Icon"), for: .selected)
        necterButton.setImage(UIImage(named: "Necter_Icon"), for: .highlighted)
        necterButton.addTarget(self, action: #selector(necterIconTapped(_:)), for: .touchUpInside)
        necterButton.frame = CGRect(x: 0, y: 0, width: 0.085*screenWidth, height: 0.085*screenWidth)
        necterButton.contentMode = UIViewContentMode.scaleAspectFill
        necterButton.clipsToBounds = true
        let rightBarButton = UIBarButtonItem(customView: necterButton)
        navItem.leftBarButtonItem = rightBarButton
        
        //setting the navBar color and title
        navigationBar.setItems([navItem], animated: false)
        
        let navBarTitleView = UIView()
        navBarTitleView.frame = CGRect(x: 0, y: 0, width: 0.06*screenHeight, height: 0.06*screenHeight)
        let titleImageView = UIImageView(image: UIImage(named: "Messages_Icon_Yellow"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: navBarTitleView.frame.size.width , height: navBarTitleView.frame.size.height)
        titleImageView.contentMode = UIViewContentMode.scaleAspectFill
        titleImageView.clipsToBounds = true
        navBarTitleView.addSubview(titleImageView)
        navigationBar.topItem?.titleView = navBarTitleView
        
        navigationBar.barStyle = .black
        navigationBar.barTintColor = UIColor.white
        
        self.view.addSubview(navigationBar)
    }
    func necterIconTapped (_ sender: UIBarButtonItem) {
        necterButton.isSelected = true
        performSegue(withIdentifier: "showBridgeFromMessages", sender: self)
    }
    func displayNoMessages() {
        let labelFrame: CGRect = CGRect(x: 0,y: 0, width: 0.85*screenWidth,height: screenHeight * 0.2)
        
        noMessagesLabel.frame = labelFrame
        noMessagesLabel.numberOfLines = 0
        noMessagesLabel.alpha = 1
        
        if businessButton.isEnabled == false {
            noMessagesLabel.text = "You do not have any messages for business. Connect your friends for business to start a conversation."
            print("business enabled = false")
        } else if loveButton.isEnabled == false {
            noMessagesLabel.text = "You do not have any messages for love. Connect your friends for love to start a conversation."
            print("love enabled = false")
        } else if friendshipButton.isEnabled == false {
            noMessagesLabel.text = "You do not have any messages for friendship. Connect your friends for friendship to start a conversation."
        } else {
            noMessagesLabel.text = "You do not have any messages. Connect your friends to start a conversation."
        }
        
        noMessagesLabel.font = UIFont(name: "BentonSans", size: 20)
        noMessagesLabel.textAlignment = NSTextAlignment.center
        noMessagesLabel.center.y = view.center.y
        noMessagesLabel.center.x = view.center.x
        noMessagesLabel.layer.borderWidth = 2
        noMessagesLabel.layer.borderColor = necterGray.cgColor
        noMessagesLabel.layer.cornerRadius = 15
        
        view.addSubview(noMessagesLabel)
        
    }
    func displayMessageFromBot(_ notification: Notification) {
        let botNotificationView = UIView()
        botNotificationView.frame = CGRect(x: 0, y: -0.12*self.screenHeight, width: self.screenWidth, height: 0.12*self.screenHeight)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = botNotificationView.bounds
        //blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let messageLabel = UILabel(frame: CGRect(x: 0.05*screenWidth, y: 0.01*screenHeight, width: 0.9*screenWidth, height: 0.11*screenHeight))
        messageLabel.text = (notification as NSNotification).userInfo!["message"] as? String ?? "No Message Came Up"
        messageLabel.textColor = UIColor.darkGray
        messageLabel.font = UIFont(name: "Verdana-Bold", size: 14)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = NSTextAlignment.center
        //botNotificationView.backgroundColor = necterYellow
        
        //botNotificationView.addSubview(blurEffectView)
        botNotificationView.addSubview(messageLabel)
        botNotificationView.insertSubview(blurEffectView, belowSubview: messageLabel)
        view.insertSubview(botNotificationView, aboveSubview: navigationBar)
        
        
        UIView.animate(withDuration: 0.7, animations: {
            botNotificationView.frame.origin.y = 0
        }) 
        
        let _ = CustomTimer(interval: 4) {i -> Bool in
            UIView.animate(withDuration: 0.7, animations: {
                botNotificationView.frame.origin.y = -0.12*self.screenHeight
            })
            return i < 1
        }
        
        
        NotificationCenter.default.removeObserver(self)
        //botNotificationView.removeFromSuperview()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.displayMessageFromBot), name: NSNotification.Name(rawValue: "displayMessageFromBot"), object: nil)
        
        //create NavigationBar
        displayNavigationBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadMessageTable), name: NSNotification.Name(rawValue: "reloadTheMessageTable"), object: nil)
        /*refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(MessagesViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refresher)*/
        
        
        let query: PFQuery = PFQuery(className: "Messages")
        query.whereKey("ids_in_message", contains: PFUser.current()?.objectId)
        
        query.order(byDescending: "lastSingleMessageAt")
        query.limit = 1000
        query.cachePolicy = .networkElseCache
        //print("\n starting return")
        query.countObjectsInBackground{
            (count: Int32, error: Error?) in
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
       
        tableView.delegate = self
        tableView.dataSource = self
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
        pagingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        pagingSpinner.color = UIColor.darkGray
        pagingSpinner.hidesWhenStopped = true
        tableView.tableFooterView = pagingSpinner
        tableView.separatorStyle = .none
        
        displayToolBar()
        allTypesButton.isEnabled = false

    }
    
    override func viewDidLayoutSubviews() {
        
        navigationBar.frame = CGRect(x: 0, y:0, width:screenWidth, height:0.11*screenHeight)
        tableView.frame = CGRect(x: 0, y:0.11*screenHeight, width:screenWidth, height:0.79*screenHeight)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //print ("indexPath - \(indexPath.row) & noOfElementsFetched - \(noOfElementsFetched)" )
//        if (indexPath.row == messages.count - 1 ) {
//            //print("refresh should be  called - \(noOfElementsFetched), \(totalElements)")
//            //print(messages)
//        }
        if ((indexPath as NSIndexPath).row == messages.count - 1 && (noOfElementsFetched < totalElements) ) {
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
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //print("numberOfRowsInSection \( IDsOfMessages.count + 1) \(LocalData().getUsername())")
        if (searchController.isActive && searchController.searchBar.text != "") || toolbarTapped {
            //print ("Search term is \(searchController.searchBar.text) and number of results is \(filteredPositions.count)")
            return filteredPositions.count
        }
        
        return messages.count
        
    }

    // Data to be shown on an individual row
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var messagePositionToMessageIdMapping = self.messagePositionToMessageIdMapping
        let cell = MessagesTableCell()//tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MessagesTableCell
        //if indexPath.row != 0 {
            cell.setSeparator = true
        //}

        cell.cellHeight = screenHeight/6.0
        cell.cellHeight = 0.15 * screenHeight
        if (searchController.isActive && searchController.searchBar.text != "") || toolbarTapped {
            var i = 0
            messagePositionToMessageIdMapping = [Int:String]()
            for index in filteredPositions {
                 messagePositionToMessageIdMapping[i] = self.messagePositionToMessageIdMapping[index]
                 i += 1
            }
        }
        if messagePositionToMessageIdMapping[(indexPath as NSIndexPath).row] == nil || names[messagePositionToMessageIdMapping[(indexPath as NSIndexPath).row]!] == nil || messages[messagePositionToMessageIdMapping[(indexPath as NSIndexPath).row]!] == nil || messageTimestamps[messagePositionToMessageIdMapping[(indexPath as NSIndexPath).row]!] == nil || messageType[messagePositionToMessageIdMapping[(indexPath as NSIndexPath).row]!] == nil{
            cell.participants.text = ""
            cell.messageSnapshot.text = ""
            cell.messageTimestamp.text = ""
            cell.backgroundColor = UIColor.white
            return cell
        }

        var stringOfNames = ""
        var users = names[messagePositionToMessageIdMapping[(indexPath as NSIndexPath).row]!]!
        users = users.filter { $0 != PFUser.current()?["name"] as! String }
        
        for i in 0 ..< users.count  {
            var name = users[i]
            if users.count > 2 && i < users.count - 2 {
                var fullNameArr = name.characters.split{$0 == " "}.map(String.init)
                stringOfNames = stringOfNames + fullNameArr[0] + ", "
                
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
        cell.messageSnapshot.text = messages[messagePositionToMessageIdMapping[(indexPath as NSIndexPath).row]!]!
        cell.arrow.text = ">"
        
        
        if messageViewed[messagePositionToMessageIdMapping[(indexPath as NSIndexPath).row]!]! {
            cell.notificationDot.isHidden = true
        } else {
            cell.notificationDot.isHidden = false
        }
        
        switch messageType[messagePositionToMessageIdMapping[(indexPath as NSIndexPath).row]!]!{
            
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyy hh:mm:ss +zzzz"
        let calendar = Calendar.current
        let date = (messageTimestamps[messagePositionToMessageIdMapping[(indexPath as NSIndexPath).row]!]!)!
        let components = (calendar as NSCalendar).components([ .day],
                                             from: date, to: Date(), options: NSCalendar.Options.wrapComponents)
        //print("row, date, day -\(indexPath.row) \(date) \(components.day)")
        if components.day! > 7 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyy"
            //print(dateFormatter.stringFromDate(date))
            cell.messageTimestamp.text = dateFormatter.string(from: date)
        }
        else if components.day! >= 2 {
            let calendar = Calendar.current
            let date = (messageTimestamps[messagePositionToMessageIdMapping[(indexPath as NSIndexPath).row]!]!)!
            let components = (calendar as NSCalendar).components([.weekday],
                                                 from: date)
            //print(components.weekday)
            cell.messageTimestamp.text = String(getWeekDay(components.weekday!))
        }
        else if components.day! >= 1 {
            //print ("Yesterday")
            cell.messageTimestamp.text = "Yesterday"
        }
        else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            cell.messageTimestamp.text = dateFormatter.string(from: date)
            //print(dateFormatter.stringFromDate(date))
            
        }
        if indexPath.row == filteredPositions.count - 1 {
            toolbarTapped = false
        }
        cell.separatorInset = UIEdgeInsetsMake(0.0, cell.bounds.size.width, 0.0, 0.0);
                return cell

        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight/6.0
    }
    // A row is selected
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //var IDsOfMessages = self.IDsOfMessages
        let currentCell = tableView.cellForRow(at: indexPath)! as! MessagesTableCell
        var messagePositionToMessageIdMapping = self.messagePositionToMessageIdMapping
        if (searchController.isActive && searchController.searchBar.text != "") || toolbarTapped {
            //IDsOfMessages = [String]()
            messagePositionToMessageIdMapping = [Int:String]()
            var i = 0
            for index in filteredPositions {
                messagePositionToMessageIdMapping[i] = self.messagePositionToMessageIdMapping[index]
                i += 1
                //IDsOfMessages.append(self.IDsOfMessages[index])
            }
        }

        if (currentCell.participants?.text)! != "" {
            singleMessageTitle = (currentCell.participants?.text)!
        } else {
            //singleMessageTitle stays as "Conversation"
        }
        
        singleMessageId = messagePositionToMessageIdMapping[(indexPath as NSIndexPath).row]!
        messageId = messagePositionToMessageIdMapping[(indexPath as NSIndexPath).row ]!
        let necterTypeForMessage = messageType[messagePositionToMessageIdMapping[(indexPath as NSIndexPath).row ]!]!
        switch(necterTypeForMessage) {
        case "Business":
            necterTypeColor = businessBlue
        case "Love":
            necterTypeColor = loveRed
        case "Friendship":
            necterTypeColor = friendshipGreen
        default:
            necterTypeColor = necterGray
        }
        
         //previousViewController = "MessagesViewController"
        toolbarTapped = false
        let query: PFQuery = PFQuery(className: "Messages")
        query.getObjectInBackground(withId: messageId) {
            (messageObject: PFObject?, error: Error?) in
            if error != nil {
                print(error)
            }
            else if let messageObject = messageObject {
                if let _ = messageObject["message_viewed"] {
                    var whoViewed = messageObject["message_viewed"] as! [String]
                    if !whoViewed.contains((PFUser.current()?.objectId)!) {
                        whoViewed.append((PFUser.current()?.objectId)!)
                        messageObject["message_viewed"] = whoViewed
                        messageObject.saveInBackground()
                        //print("1")
                    }
                }
                else {
                    //print ("messageObject[\"message_viewed\"] -\(messageObject["message_viewed"]) \(messageObject.objectId )")
                    messageObject["message_viewed"] = [ (PFUser.current()?.objectId)! ]
                    messageObject.saveInBackground()
                    //print("2 \(messageId)")
                }
            }
        }
        segueToSingleMessage = true
        performSegue(withIdentifier: "showSingleMessageFromMessages", sender: self)
    
        
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
