//
//  MessagesViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 3/30/16.
//  Copyright © 2016 BHE Ventures LLC. All rights reserved.
//

import UIKit
import Parse

//Change to MessagesTableViewController so other can be MessageViewController
func getWeekDay(_ num:Int)->String{
    switch num {
    case 1: return "Sun."
    case 2: return "Mon."
    case 3: return "Tues."
    case 4: return "Wed."
    case 5: return "Thurs."
    case 6: return "Fri."
    case 7: return "Sat."
    default : return "A good day to die hard!"
    }
}


class MessagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchResultsUpdating {
    
    @IBOutlet var tableView: UITableView!
    //let tableView = UITableView()
    
    //creating navigation Bar
    let leftBarButton = UIButton()
    
    //creating Mission Control
    let missionControlView = MissionControlView()
    
    //toolbar buttons
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
    
    let filterLabel = UILabel()
    let searchBarContainer = UIView()
    
    //new matches
    var newMatchesView = NewMatchesView()
    
    //filter info
    var currentFilter = "All Types"
    var filterInfo = [String: FilterInfo]()
    
    //message information
    let noMessagesLabel = UILabel()
    
    var names = [String : [String]]()
    var profilePicURLs = [String : [String: String]]()
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
    
    /*
     func addProfilePicURLsToMessages() {
     print("adding profile_pic_ulrs to Messages table")
     let query: PFQuery = PFQuery(className: "Messages")
     query.limit = 10000
     query.findObjectsInBackground(block: { (results, error) -> Void in
     
     if let error = error {
     print("refresh findObjectsInBackgroundWithBlock error - \(error)")
     }
     else if let results = results {
     for i in 0..<results.count{
     
     let result = results[i]
     if let id1 = result["user1_objectId"] {
     let query2 = PFQuery(className: "_User")
     query2.whereKey("objectId", equalTo: id1)
     query2.findObjectsInBackground(block: { (results2, error2) -> Void in
     
     if let error2 = error2 {
     print("refresh findObjectsInBackgroundWithBlock error - \(error2)")
     }
     else if let results2 = results2 {
     print(results2.count)
     if results2.count > 0 {
     result["user1_profile_picture_url"] = results2[0]["profile_picture_url"]
     result.saveInBackground()
     }
     }
     })
     }
     if let id2 = result["user2_objectId"] {
     let query2 = PFQuery(className: "_User")
     query2.whereKey("objectId", equalTo: id2)
     query2.findObjectsInBackground(block: { (results2, error2) -> Void in
     
     if let error2 = error2 {
     print("refresh findObjectsInBackgroundWithBlock error - \(error2)")
     }
     else if let results2 = results2 {
     if results2.count > 0 {
     result["user2_profile_picture_url"] = results2[0]["profile_picture_url"]
     result.saveInBackground()
     }
     }
     })
     }
     }
     }
     })
     }
     */
    
    /*
     func splitArraysInMessages() {
     let query: PFQuery = PFQuery(className: "Messages")
     query.limit = 10000
     
     query.findObjectsInBackground(block: { (results, error) -> Void in
     
     if let error = error {
     print("refresh findObjectsInBackgroundWithBlock error - \(error)")
     }
     else if let results = results {
     for i in 0..<results.count{
     
     let result = results[i]
     
     let bridge_builder_id = result["bridge_builder"] as! String
     let ids = result["ids_in_message"] as! [String]
     let names = result["names_in_message"] as! [String]
     var num = 1
     for i in 0..<ids.count {
     if ids[i] == bridge_builder_id {
     continue
     }
     result["user\(num)_objectId"] = ids[i]
     result["user\(num)_name"] = names[i]
     num = num+1
     }
     
     result.saveInBackground()
     }
     }
     })
     }
     */
    
    /*
     func setUserStatusesTo1() {
     print("setting statuses")
     let query: PFQuery = PFQuery(className: "BridgePairings")
     query.whereKey("bridged", equalTo: true)
     query.limit = 10000
     query.findObjectsInBackground(block: { (results, error) -> Void in
     
     if let error = error {
     print("refresh findObjectsInBackgroundWithBlock error - \(error)")
     }
     else if let results = results {
     for i in 0..<results.count{
     
     let result = results[i]
     result["user1_response"] = 1
     result["user2_response"] = 1
     result.saveInBackground()
     print("status \(i) done")
     }
     }
     })
     }
     */
    
    /*
     func addProfilePicUrlsToMessages() {
     print("adding profile_pic_ulrs to Messages table")
     let query: PFQuery = PFQuery(className: "Messages")
     query.limit = 10000
     query.findObjectsInBackground(block: { (results, error) -> Void in
     
     if let error = error {
     print("refresh findObjectsInBackgroundWithBlock error - \(error)")
     }
     else if let results = results {
     for i in 0..<results.count{
     
     let result = results[i]
     let ids = result["ids_in_message"] as! [String]
     print("Message \(i): \(ids)")
     for id in ids {
     let query2: PFQuery = PFQuery(className: "_User")
     query2.whereKey("objectId", equalTo: id)
     query2.findObjectsInBackground(block: { (results2, error2) -> Void in
     if let error2 = error2 {
     print("refresh findObjectsInBackgroundWithBlock error - \(error2)")
     }
     else if let results2 = results2 {
     print(results2.count)
     if results2.count > 0 {
     print("!")
     var urls: [String]
     if let urls1 = result["profile_picture_urls"] {
     urls = urls1 as! [String]
     } else {
     urls = [String]()
     }
     let url = results2[0]["profile_picture_url"] as! String
     urls.append(url)
     print(urls.count)
     result["profile_picture_urls"] = urls
     result.saveInBackground()
     }
     /*
     if results2.count > 0 {
     profilePicURLs.append(results2[0]["profile_picture_url"] as! String)
     }
     if profilePicURLs.count == ids.count {
     result["profile_picture_urls"] = profilePicURLs
     result.saveInBackground()
     }
     */
     }
     })
     }
     }
     }
     })
     
     }
     */
    
    
    // refresh() fetches the data from Parse
    func refresh() {
        //self.refresher.endRefreshing()
        
        let currentFilterInfo = self.filterInfo[self.currentFilter]!
        
        let query: PFQuery = PFQuery(className: "Messages")
        query.whereKey("ids_in_message", contains: PFUser.current()?.objectId)
        if currentFilter != "All Types" {
            query.whereKey("message_type", equalTo: currentFilter)
        }
        query.order(byDescending: "lastSingleMessageAt")
        //query.skip = noOfElementsFetched
        query.skip = currentFilterInfo.noOfElementsFetched
        query.limit = noOfElementsPerRefresher
        query.cachePolicy = .networkElseCache
        query.findObjectsInBackground(block: { (results, error) -> Void in
            
            if let error = error {
                print("refresh findObjectsInBackgroundWithBlock error - \(error)")
            }
            else if let results = results {
                self.noOfElementsFetched += results.count
                currentFilterInfo.fetch(results.count)
                //print("self.noOfElementsFetched \(self.noOfElementsFetched)")
                for i in 0..<results.count{
                    
                    let result = results[i]
                    //self.messagePositionToMessageIdMapping[self.noOfElementsProcessed] = result.objectId!
                    currentFilterInfo.messagePositionToMessageIdMapping[currentFilterInfo.noOfElementsProcessed] = result.objectId!
                    currentFilterInfo.process()
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
                        let date = Date()
                        self.messageTimestamps[result.objectId!] = date
                    }
                    if let _ = result["message_viewed"] {
                        let whoViewed = result["message_viewed"] as! ([String])
                        if whoViewed.contains((PFUser.current()?.objectId)!) {
                            self.messageViewed[result.objectId!] = (true)
                        }
                        else {
                            self.messageViewed[result.objectId!] = (false)
                        }
                    }
                    else {
                        self.messageViewed[result.objectId!]=(false)
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
                    
                    self.profilePicURLs[result.objectId!] = [String: String]()
                    if let user1PhotoURL = result["user1_profile_picture_url"] {
                        self.profilePicURLs[result.objectId!]?[result["user1_objectId"] as! String] = user1PhotoURL as! String
                    }
                    
                    if let user2PhotoURL = result["user2_profile_picture_url"] {
                        self.profilePicURLs[result.objectId!]?[result["user2_objectId"] as! String] = user2PhotoURL as! String
                    }
                }
            }
            self.messagePositionToMessageIdMapping = currentFilterInfo.messagePositionToMessageIdMapping
            self.noOfElementsProcessed = currentFilterInfo.noOfElementsProcessed
            self.noOfElementsFetched = currentFilterInfo.noOfElementsFetched
            self.totalElements = currentFilterInfo.totalElements
            
            self.tableView.reloadData()
        })
    }
    // helper function for updateSearchResultsForSearchController
    func filterContentForSearchText(_ searchText:String, scope: String = "All"){
        filteredPositions = [Int]()
        for i in 0 ..< messagePositionToMessageIdMapping.count  {
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
        print("Listened at reloadMessageTable")
        
        initializeFilterInfo()
        
        names = [String : [String]]()
        messages = [String : String]()
        messageType = [String : String]()
        messageViewed = [String : Bool]()
        messageTimestamps = [String : Date?]()
        messagePositionToMessageIdMapping = [Int:String]()
        
        //Updating the Messages Table upon Push Notification
        refresh()
        //Updated the new matchesView upon Push Notification
        loadNewMatches()
        /*
        
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
        query.countObjectsInBackground {
            (count: Int32, error: Error?) in
            if error == nil {
                self.totalElements = Int(count)
                self.refresh()
            }
            else {
                print(" not alive")
            }
        }
         */
    }
    
    func initializeFilterInfo() {
        for type in ["All Types", "Business", "Love", "Friendship"] {
            filterInfo[type] = FilterInfo(type: type)
            
            let query: PFQuery = PFQuery(className: "Messages")
            query.whereKey("ids_in_message", contains: PFUser.current()?.objectId)
            if type != "All Types" {
                query.whereKey("message_type", equalTo: type)
            }
            query.order(byDescending: "lastSingleMessageAt")
            query.limit = 1000
            query.cachePolicy = .networkElseCache
            query.countObjectsInBackground{
                (count: Int32, error: Error?) in
                if error == nil {
                    self.filterInfo[type]?.setTotalElements(Int(count))
                }
                else {
                    print(" not alive")
                }
            }
        }
    }
    
    func filtersTapped(_ notification: Notification) {
        let type = missionControlView.whichFilter()
        currentFilter = type

        //toolbarTapped = true
        filteredPositions = [Int]()
        displayFilterLabel(type: type)
        
        /*
        if type != "All Types" {
            //displaying noMessagesLabel when there are no messages in the filtered message type
            for i in 0 ..< messageType.count{
                if messageType[messagePositionToMessageIdMapping[i]!]! == type {
                    filteredPositions.append(i)
                }
            }
        } else {
            for i in 0 ..< messageType.count{
                filteredPositions.append(i)
            }
        }
        if filteredPositions.count == 0 {
            displayNoMessages()
        } else {
            noMessagesLabel.isHidden = true
        }
         */
        refresh()
        self.tableView.tableHeaderView = nil
        newMatchesView.filterBy(type: type)
        self.tableView.tableHeaderView = newMatchesView
    }
    
    
    /*func displayToolBar(){
     
     postStatusButton.frame = CGRect(x: 0, y: 0, width: 0.175*DisplayUtility.screenWidth, height: 0.175*DisplayUtility.screenWidth)
     postStatusButton.backgroundColor = DisplayUtility.necterYellow
     postStatusButton.showsTouchWhenHighlighted = true
     postStatusButton.layer.borderWidth = 2.0
     postStatusButton.layer.borderColor = UIColor.white.cgColor
     postStatusButton.layer.cornerRadius = postStatusButton.frame.size.width/2.0
     postStatusButton.clipsToBounds = true
     postStatusButton.center.y = toolbar.center.y - 0.25*0.175*DisplayUtility.screenWidth
     postStatusButton.center.x = view.center.x
     postStatusButton.setTitle("+", for: UIControlState())
     postStatusButton.setTitleColor(UIColor.white, for: UIControlState())
     postStatusButton.titleLabel?.font = UIFont(name: "Verdana", size: 26)
     postStatusButton.addTarget(self, action: #selector(postStatusTapped), for: .touchUpInside)
     
     }
     func postStatusTapped(_ sender: UIButton ){
     print("Post Tapped")
     performSegue(withIdentifier: "showNewStatusViewControllerFromMessages", sender: self)
     }*/
    func displayNavigationBar(){
        leftBarButton.addTarget(self, action: #selector(leftBarButtonTapped(_:)), for: .touchUpInside)
        let customNavigationBar = CustomNavigationBar()
        customNavigationBar.createCustomNavigationBar(view: view, leftBarButtonIcon: "Left_Arrow", leftBarButtonSelectedIcon: "Left_Arrow", leftBarButton: leftBarButton, rightBarButtonIcon: nil, rightBarButtonSelectedIcon: nil, rightBarButton: nil, title: "Inbox")
    }
    func leftBarButtonTapped (_ sender: UIBarButtonItem){
        performSegue(withIdentifier: "showBridgeFromMessages", sender: self)
        leftBarButton.isSelected = true
    }
    func displayNoMessages() {
        print("displayNoMessages() called")
        let labelFrame: CGRect = CGRect(x: 0,y: 0, width: 0.85*DisplayUtility.screenWidth,height: DisplayUtility.screenHeight * 0.2)
        
        noMessagesLabel.frame = labelFrame
        noMessagesLabel.numberOfLines = 0
        noMessagesLabel.isHidden = false
        
        let type = missionControlView.whichFilter()
        if type == "All Types" {
            noMessagesLabel.text = "No active connections."
            //} else if businessButton.isEnabled && loveButton.isEnabled {
            //noMessagesLabel.text = "No active connections for business or dating."
            //} else if businessButton.isEnabled && friendshipButton.isEnabled {
            //noMessagesLabel.text = "No active connections for business or friendship."
            //} else if friendshipButton.isEnabled && loveButton.isEnabled {
            //noMessagesLabel.text = "No active connections for friendship or dating."
        } else if type == "Business" {
            //noMessagesLabel.text = "You do not have any messages for business. Connect your friends for business to start a conversation."
            noMessagesLabel.text = "No active connections for work. Be sweet and 'nect your friends to get the community buzzing!"
            print("business enabled = false")
        } else if type == "Love" {
            //noMessagesLabel.text = "You do not have any messages for love. Connect your friends for love to start a conversation."
            noMessagesLabel.text = "No active connections for dating. Be sweet and 'nect your friends to get the community buzzing!"
            print("love enabled = false")
        } else if type == "Friendship" {
            //noMessagesLabel.text = "You do not have any messages for friendship. Connect your friends for friendship to start a conversation."
            noMessagesLabel.text = "No active connections for friendship. Be sweet and 'nect your friends to get the community buzzing!"
        } else {
            noMessagesLabel.text = "You do not have any messages. Be sweet and 'nect your friends to get the community buzzing!"
        }
        noMessagesLabel.font = UIFont(name: "BentonSans-Light", size: 20)
        noMessagesLabel.textAlignment = .center
        noMessagesLabel.center.x = view.center.x
        noMessagesLabel.center.y = view.center.y
        //noMessagesLabel.textColor = .red
        noMessagesLabel.adjustsFontSizeToFitWidth = true
        
        /*
         noMessagesLabel.font = UIFont(name: "BentonSans", size: 20)
         noMessagesLabel.textAlignment = NSTextAlignment.center
         noMessagesLabel.center.y = view.center.y
         noMessagesLabel.center.x = view.center.x
         noMessagesLabel.layer.borderWidth = 2
         noMessagesLabel.layer.borderColor = DisplayUtility.necterGray.cgColor
         noMessagesLabel.layer.cornerRadius = 15
         */
        
        view.addSubview(noMessagesLabel)
    }
    func displayMessageFromBot(_ notification: Notification) {
        let sendingNotificationView = SendingNotificationView()
        sendingNotificationView.initialize(view: view, sendingText: "Sending...", successText: "Success")
        view.addSubview(sendingNotificationView)
        view.bringSubview(toFront: view)
//        let botNotificationView = UIView()
//        botNotificationView.frame = CGRect(x: 0, y: -0.12*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: 0.12*DisplayUtility.screenHeight)
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        //always fill the view
//        blurEffectView.frame = botNotificationView.bounds
//        
//        let messageLabel = UILabel(frame: CGRect(x: 0.05*DisplayUtility.screenWidth, y: 0.01*DisplayUtility.screenHeight, width: 0.9*DisplayUtility.screenWidth, height: 0.11*DisplayUtility.screenHeight))
//        messageLabel.text = (notification as NSNotification).userInfo!["message"] as? String ?? "No Message Came Up"
//        messageLabel.textColor = UIColor.darkGray
//        messageLabel.font = UIFont(name: "Verdana-Bold", size: 14)
//        messageLabel.numberOfLines = 0
//        messageLabel.textAlignment = NSTextAlignment.center
//        
//        botNotificationView.addSubview(messageLabel)
//        botNotificationView.insertSubview(blurEffectView, belowSubview: messageLabel)
//        view.addSubview(botNotificationView)
//        view.bringSubview(toFront: botNotificationView)
//        
//        UIView.animate(withDuration: 0.7, animations: {
//            botNotificationView.frame.origin.y = 0
//        })
//        
//        let _ = CustomTimer(interval: 4) {i -> Bool in
//            UIView.animate(withDuration: 0.7, animations: {
//                botNotificationView.frame.origin.y = -0.12*DisplayUtility.screenHeight
//            })
//            return i < 1
//        }
//        
//        
//        NotificationCenter.default.removeObserver(self)
        
    }
    func displayBackgroundView(){
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight))
        backgroundView.backgroundColor = UIColor(red: 234/255, green: 237/255, blue: 239/255, alpha: 1.0)
        view.addSubview(backgroundView)
        view.sendSubview(toBack: backgroundView)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.displayMessageFromBot), name: NSNotification.Name(rawValue: "displayMessageFromBot"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadMessageTable), name: NSNotification.Name(rawValue: "reloadTheMessageTable"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.filtersTapped), name: NSNotification.Name(rawValue: "filtersTapped"), object: nil)
        
        //view.addSubview(tableView)
        
        initializeFilterInfo()
        
        filterLabel.frame = CGRect(x: 0, y: searchBarContainer.frame.maxY, width: DisplayUtility.screenWidth, height: 0.06*DisplayUtility.screenHeight)
        filterLabel.font = UIFont(name: "BentonSans", size: 18)
        filterLabel.textAlignment = .center
        //view.addSubview(filterLabel)
        
        displayNavigationBar()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadNewMatches()
        
        tableView.tableHeaderView = newMatchesView
        
        let query: PFQuery = PFQuery(className: "Messages")
        query.whereKey("ids_in_message", contains: PFUser.current()?.objectId)
        
        query.order(byDescending: "lastSingleMessageAt")
        query.limit = 1000
        query.cachePolicy = .networkElseCache
        query.countObjectsInBackground{
            (count: Int32, error: Error?) in
            if error == nil {
                
                self.totalElements = Int(count)
                self.isElementCountNotFetched = false
                self.refresh()
                
                if self.totalElements == 0 {
                    self.displayNoMessages()
                } else {
                    self.noMessagesLabel.isHidden = true
                }
            }
            else {
                print(" not alive")
            }
        }
        
        searchBarContainer.addSubview(searchController.searchBar)
        searchBarContainer.frame = CGRect(x: 0, y: 0.1*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: 0.08*DisplayUtility.screenHeight)
        view.addSubview(searchBarContainer)
        view.addSubview(filterLabel)
        CustomSearchBar.customizeSearchController(searchController: searchController)
        searchController.searchResultsUpdater = self
        pagingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        pagingSpinner.color = UIColor.darkGray
        pagingSpinner.hidesWhenStopped = true
        tableView.tableFooterView = pagingSpinner
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(red: 234/255, green: 237/255, blue: 239/255, alpha: 1.0)
        
        missionControlView.initialize(view: view, revisitLabel: noMessagesLabel, revisitButton: UIButton())
        displayFilterLabel(type: "All Types")
        displayBackgroundView()
    }
    
    func displayFilterLabel(type : String) {
        if type == "All Types" {
            filterLabel.isHidden = true
            filterLabel.frame = CGRect(x: 0, y: searchBarContainer.frame.maxY, width: 0, height: 0)
        } else {
            filterLabel.isHidden = false
            filterLabel.frame = CGRect(x: 0, y: searchBarContainer.frame.maxY, width: DisplayUtility.screenWidth, height: 0.06*DisplayUtility.screenHeight)
            if type == "Business" {
                filterLabel.text = "BUSINESS"
                filterLabel.textColor = DisplayUtility.businessBlue
            }
            if type == "Love" {
                filterLabel.text = "LOVE"
                filterLabel.textColor = DisplayUtility.loveRed
            }
            if type == "Friendship" {
                filterLabel.text = "FRIENDSHIP"
                filterLabel.textColor = DisplayUtility.friendshipGreen
            }
        }
        
        tableView.frame = CGRect(x: 0, y: filterLabel.frame.maxY, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight-filterLabel.frame.maxY)
    }
    
    func loadNewMatches() {
        newMatchesView = NewMatchesView()
        newMatchesView.setVC(vc: self)
        self.tableView.tableHeaderView = self.newMatchesView
        let query: PFQuery = PFQuery(className: "BridgePairings")
        query.whereKey("bridged", equalTo: true)
        query.limit = 10000
        query.findObjectsInBackground(block: { (results, error) -> Void in
            
            if let error = error {
                print("refresh findObjectsInBackgroundWithBlock error - \(error)")
            }
            else if let results = results {
                print(results.count)
                for i in 0..<results.count{
                    let result = results[i]
                    let objectId = result.objectId
                    
                    var currentUser_objectId = ""
                    if let currentUser = PFUser.current() {
                        currentUser_objectId = currentUser.objectId!
                    }
                    
                    var user = ""
                    var otherUser = ""
                    if let user1_objectId = result["user_objectId1"] {
                        if (user1_objectId as! String) == currentUser_objectId {
                            user = "user1"
                            otherUser = "user2"
                        }
                    }
                    if let user2_objectId = result["user_objectId2"] {
                        if (user2_objectId as! String) == currentUser_objectId {
                            user = "user2"
                            otherUser = "user1"
                        }
                    }
                    
                    //These force unwraps need to be removed
                    if user != "" {
                        var userResponse = 0
                        if let UR = result["\(user)_response"] as? Int {
                            userResponse = UR
                        }
                        if userResponse != 1 {
                            if let profilePicURLString = result["\(otherUser)_profile_picture_url"] as? String {
                                if let name = result["\(otherUser)_name"] as? String {
                                    let dot = (userResponse == 0)
                                    if let type = result["connected_bridge_type"] as? String {
                                        var color: UIColor
                                        switch type {
                                        case "Business":
                                            color = DisplayUtility.businessBlue
                                        case "Love":
                                            color = DisplayUtility.loveRed
                                        case "Friendship":
                                            color = DisplayUtility.friendshipGreen
                                        default:
                                            color = .black
                                        }
                                        if let status = result["\(otherUser)_bridge_status"] as? String {
                                            let newMatch = NewMatch(user: user, objectId: objectId!, profilePicURL: profilePicURLString, name: name, type: type, color: color, dot: dot, status: status)
                                            let downloader = Downloader()
                                            if let profilePicURL = URL(string: profilePicURLString) {
                                                downloader.imageFromURL(URL: profilePicURL, callBack: { (image: UIImage) in
                                                    newMatch.profilePic = image
                                                    print ("profilePic set in callback")
                                                })
                                            }
                                            let connecterObjectId = result["connecter_objectId"] as? String
                                            let connecterName = result["connecter_name"] as? String
                                            let connecterPicURLString = result["connecter_profile_picture_url"] as? String
                                            let reasonForConnection = result["reason_for_connection"] as? String
                                            newMatch.setConnecterInfo(objectId: connecterObjectId, name: connecterName, profilePicURL: connecterPicURLString, reasonForConnection: reasonForConnection)
                                            if let connecterPicURLString = connecterPicURLString {
                                                if let connecterPicURL = URL(string: connecterPicURLString) {
                                                    downloader.imageFromURL(URL: connecterPicURL, callBack: { (image: UIImage) in
                                                        newMatch.connecterPic = image
                                                        print ("connecterPic set in callback")
                                                    })
                                                }
                                            }
                                            self.newMatchesView.addNewMatch(newMatch: newMatch)
                                            self.tableView.tableHeaderView = self.newMatchesView
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
                
        })
    }
        
    override func viewDidLayoutSubviews() {
        tableView.frame = CGRect(x: 0, y: filterLabel.frame.maxY, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight-filterLabel.frame.maxY)
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let currentFilterInfo = self.filterInfo[self.currentFilter]!
        if ((indexPath as NSIndexPath).row == messages.count - 1 && (noOfElementsFetched < currentFilterInfo.totalElements) ) {
            if self.encounteredBefore[self.noOfElementsFetched] == nil {
                self.encounteredBefore[self.noOfElementsFetched] = true
                refresh()
                pagingSpinner.startAnimating()
            }
        }
        else {
            self.pagingSpinner.stopAnimating()
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (searchController.isActive && searchController.searchBar.text != "") || toolbarTapped {
            return filteredPositions.count
        }
        let currentFilterInfo = self.filterInfo[self.currentFilter]!
        return currentFilterInfo.messagePositionToMessageIdMapping.count
    }
    
    func transitionToMessageWithID(_ id: String, color: UIColor, title: String) {
        self.singleMessageId = id
        self.necterTypeColor = color
        self.segueToSingleMessage = true
        self.singleMessageTitle = title
        self.performSegue(withIdentifier: "showSingleMessageFromMessages", sender: self)
    }

    // Data to be shown on an individual row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var messagePositionToMessageIdMapping = self.messagePositionToMessageIdMapping
        let cell = MessagesTableCell()
        cell.setSeparator = true
        
        cell.cellHeight = self.tableView(tableView, heightForRowAt: indexPath)
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
        
        var profilePicsDict = profilePicURLs[messagePositionToMessageIdMapping[(indexPath as NSIndexPath).row]!]!
        for id in profilePicsDict.keys {
            if id != PFUser.current()?.objectId {
                let url = URL(string: profilePicsDict[id]!)!
                let downloader = Downloader()
                downloader.imageFromURL(URL: url, imageView: cell.profilePic, callBack: nil)
                break
            }
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
        
        if messageViewed[messagePositionToMessageIdMapping[(indexPath as NSIndexPath).row]!]! {
            cell.notificationDot.isHidden = true
        } else {
            cell.notificationDot.isHidden = false
        }
        
        switch messageType[messagePositionToMessageIdMapping[(indexPath as NSIndexPath).row]!]!{
            
        case "Business":
            cell.color = DisplayUtility.businessBlue
            break
        case "Love":
            cell.color = DisplayUtility.loveRed
            break
        case "Friendship":
            cell.color = DisplayUtility.friendshipGreen
            break
        default: cell.color = DisplayUtility.friendshipGreen
            
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyy hh:mm:ss +zzzz"
        let calendar = Calendar.current
        let date = (messageTimestamps[messagePositionToMessageIdMapping[(indexPath as NSIndexPath).row]!]!)!
        let components = (calendar as NSCalendar).components([ .day],
                                                             from: date, to: Date(), options: NSCalendar.Options.wrapComponents)
        if components.day! > 7 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd"
            cell.messageTimestamp.text = dateFormatter.string(from: date)
        }
        else if components.day! >= 1 {
            let calendar = Calendar.current
            let date = (messageTimestamps[messagePositionToMessageIdMapping[(indexPath as NSIndexPath).row]!]!)!
            let components = (calendar as NSCalendar).components([.weekday],
                                                                 from: date)
            cell.messageTimestamp.text = String(getWeekDay(components.weekday!))
        }
        else {
            cell.messageTimestamp.text = "Today"
        }
        if indexPath.row == filteredPositions.count - 1 {
            toolbarTapped = false
        }
        cell.separatorInset = UIEdgeInsetsMake(0.0, cell.bounds.size.width, 0.0, 0.0);
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DisplayUtility.screenHeight/6.0
    }
    // A row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)! as! MessagesTableCell
        var messagePositionToMessageIdMapping = self.messagePositionToMessageIdMapping
        if (searchController.isActive && searchController.searchBar.text != "") || toolbarTapped {
            messagePositionToMessageIdMapping = [Int:String]()
            var i = 0
            for index in filteredPositions {
                messagePositionToMessageIdMapping[i] = self.messagePositionToMessageIdMapping[index]
                i += 1
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
            necterTypeColor = DisplayUtility.businessBlue
        case "Love":
            necterTypeColor = DisplayUtility.loveRed
        case "Friendship":
            necterTypeColor = DisplayUtility.friendshipGreen
        default:
            necterTypeColor = DisplayUtility.necterGray
        }
        toolbarTapped = false
        let query: PFQuery = PFQuery(className: "Messages")
        query.getObjectInBackground(withId: messageId) {
            (messageObject: PFObject?, error: Error?) in
            if error != nil {
                print(error ?? "message tapped and querying with error")
            }
            else if let messageObject = messageObject {
                if let _ = messageObject["message_viewed"] {
                    var whoViewed = messageObject["message_viewed"] as! [String]
                    if !whoViewed.contains((PFUser.current()?.objectId)!) {
                        whoViewed.append((PFUser.current()?.objectId)!)
                        messageObject["message_viewed"] = whoViewed
                        messageObject.saveInBackground(block: { (success, error) in
                            if success {
                                print("current user saved to the message")
                            } else if error != nil {
                                print(error)
                            }
                        })
                        
                        //decrease the badgeCount by 1
                        DBSavingFunctions.decrementBadge()
                    }
                }
                else {
                    messageObject["message_viewed"] = [(PFUser.current()?.objectId)!]
                    messageObject.saveInBackground()
                    print("message_viewed saved for single person")
                    
                    //decrease the badgeCount by 1
                    DBSavingFunctions.decrementBadge()
                }
            }
        }
        segueToSingleMessage = true
        performSegue(withIdentifier: "showSingleMessageFromMessages", sender: self)
    }
}


