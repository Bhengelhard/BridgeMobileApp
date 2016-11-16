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
    var newMatchesView = NewMatchesView()

    
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
                    self.names[result.objectId!] = (names_per_message)                }
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
    func handlePanOfMissionControl(_ gestureRecognizer: UIPanGestureRecognizer) {
        missionControlView.drag(gestureRecognizer: gestureRecognizer)
    }
    func filtersTapped(_ notification: Notification) {
        let type = missionControlView.whichFilter()
        toolbarTapped = true
        filteredPositions = [Int]()
        if !(type == "All Types") {
            //displaying noMessagesLabel when there are no messages in the filtered message type
            noMessagesLabel.alpha = 1
            for i in 0 ..< messageType.count{
                if messageType[messagePositionToMessageIdMapping[i]!]! == type {
                    filteredPositions.append(i)
                    noMessagesLabel.alpha = 0
                }
            }
        } else {
            noMessagesLabel.alpha = 1
            for i in 0 ..< messageType.count{
                filteredPositions.append(i)
                noMessagesLabel.alpha = 0
            }
        }
        tableView.reloadData()
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
        customNavigationBar.createCustomNavigationBar(view: view, leftBarButtonIcon: "All_Types_Icon_Gray", leftBarButtonSelectedIcon: "Necter_Icon", leftBarButton: leftBarButton, rightBarButtonIcon: nil, rightBarButtonSelectedIcon: nil, rightBarButton: nil, title: "Inbox")
    }
    func leftBarButtonTapped (_ sender: UIBarButtonItem){
        performSegue(withIdentifier: "showBridgeFromMessages", sender: self)
        leftBarButton.isSelected = true
    }
    func displayNoMessages() {
        let labelFrame: CGRect = CGRect(x: 0,y: 0, width: 0.85*DisplayUtility.screenWidth,height: DisplayUtility.screenHeight * 0.2)
        
        noMessagesLabel.frame = labelFrame
        noMessagesLabel.numberOfLines = 0
        noMessagesLabel.alpha = 1
        
        if businessButton.isEnabled && loveButton.isEnabled && friendshipButton.isEnabled {
            noMessagesLabel.text = "No active connections."
        } else if businessButton.isEnabled && loveButton.isEnabled {
            noMessagesLabel.text = "No active connections for business or dating."
        } else if businessButton.isEnabled && friendshipButton.isEnabled {
            noMessagesLabel.text = "No active connections for business or friendship."
        } else if friendshipButton.isEnabled && loveButton.isEnabled {
            noMessagesLabel.text = "No active connections for friendship or dating."
        }else if businessButton.isEnabled == false {
            //noMessagesLabel.text = "You do not have any messages for business. Connect your friends for business to start a conversation."
            noMessagesLabel.text = "No active connections for business."
            print("business enabled = false")
        } else if loveButton.isEnabled == false {
            //noMessagesLabel.text = "You do not have any messages for love. Connect your friends for love to start a conversation."
            noMessagesLabel.text = "No active connections for love."
            print("love enabled = false")
        } else if friendshipButton.isEnabled == false {
            noMessagesLabel.text = "You do not have any messages for friendship. Connect your friends for friendship to start a conversation."
            noMessagesLabel.text = "No active connections for friendship."
        } else {
            noMessagesLabel.text = "You do not have any messages. Connect your friends to start a conversation."
        }
        
        noMessagesLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 16)
        noMessagesLabel.textAlignment = .center
        noMessagesLabel.center.x = view.center.x
        noMessagesLabel.center.y = view.center.y
        noMessagesLabel.textColor = .red
        
        
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
        let botNotificationView = UIView()
        botNotificationView.frame = CGRect(x: 0, y: -0.12*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: 0.12*DisplayUtility.screenHeight)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = botNotificationView.bounds
        
        let messageLabel = UILabel(frame: CGRect(x: 0.05*DisplayUtility.screenWidth, y: 0.01*DisplayUtility.screenHeight, width: 0.9*DisplayUtility.screenWidth, height: 0.11*DisplayUtility.screenHeight))
        messageLabel.text = (notification as NSNotification).userInfo!["message"] as? String ?? "No Message Came Up"
        messageLabel.textColor = UIColor.darkGray
        messageLabel.font = UIFont(name: "Verdana-Bold", size: 14)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = NSTextAlignment.center
        
        botNotificationView.addSubview(messageLabel)
        botNotificationView.insertSubview(blurEffectView, belowSubview: messageLabel)
        view.addSubview(botNotificationView)
        view.bringSubview(toFront: botNotificationView)
        
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
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.displayMessageFromBot), name: NSNotification.Name(rawValue: "displayMessageFromBot"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadMessageTable), name: NSNotification.Name(rawValue: "reloadTheMessageTable"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.filtersTapped), name: NSNotification.Name(rawValue: "filtersTapped"), object: nil)
        
        //view.addSubview(tableView)
        
        filterLabel.frame = CGRect(x: 0, y: 0.18*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: 0.06*DisplayUtility.screenHeight)
        filterLabel.font = UIFont(name: "BentonSans", size: 18)
        filterLabel.textAlignment = .center
        displayFilterLabel(type: "All Types")

        
        displayNavigationBar()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        var profilePics = [UIImage]()
        var names = [String]()
        
        for _ in 0...9 {
            let profilePic = UIImage(named: "Business_Icon_Blue")
            profilePics.append(profilePic!)
            names.append("Doug")
        }
        
        newMatchesView = NewMatchesView(frame: CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: 0.17*DisplayUtility.screenHeight), profilePics: profilePics, names: names)
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
                    self.noMessagesLabel.alpha = 0
                }
            }
            else {
                print(" not alive")
            }
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        CustomSearchBar.customizeSearchController(searchController: searchController)
        searchController.searchResultsUpdater = self
        self.tableView.tableHeaderView = searchController.searchBar
        pagingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        pagingSpinner.color = UIColor.darkGray
        pagingSpinner.hidesWhenStopped = true
        tableView.tableFooterView = pagingSpinner
        tableView.separatorStyle = .none
        
        //displayToolBar()
        // Create Mission Control
        missionControlView.createTabView(view: view)
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanOfMissionControl(_:)))
        missionControlView.addGestureRecognizer(gestureRecognizer: gestureRecognizer)
        
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
    
    override func viewDidLayoutSubviews() {
        tableView.frame = CGRect(x: 0, y:0.11*DisplayUtility.screenHeight, width:DisplayUtility.screenWidth, height:0.89*DisplayUtility.screenHeight)
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if ((indexPath as NSIndexPath).row == messages.count - 1 && (noOfElementsFetched < totalElements) ) {
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
        
        return messages.count
        
    }
    
    // Data to be shown on an individual row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var messagePositionToMessageIdMapping = self.messagePositionToMessageIdMapping
        let cell = MessagesTableCell()
        cell.setSeparator = true
        
        cell.cellHeight = DisplayUtility.screenHeight/6.0
        cell.cellHeight = 0.15 * DisplayUtility.screenHeight
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
            //cell.participants.textColor = DisplayUtility.businessBlue
            //cell.arrow.textColor = DisplayUtility.businessBlue
            cell.color = DisplayUtility.businessBlue
            break
        case "Love":
            //cell.participants.textColor = DisplayUtility.loveRed
            //cell.arrow.textColor = DisplayUtility.loveRed
            cell.color = DisplayUtility.loveRed
            break
        case "Friendship":
            cell.participants.textColor = DisplayUtility.friendshipGreen
            cell.arrow.textColor = DisplayUtility.friendshipGreen
            cell.color = DisplayUtility.friendshipGreen
            break
        default: cell.participants.textColor = DisplayUtility.friendshipGreen
        cell.arrow.textColor = DisplayUtility.friendshipGreen
            
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyy hh:mm:ss +zzzz"
        let calendar = Calendar.current
        let date = (messageTimestamps[messagePositionToMessageIdMapping[(indexPath as NSIndexPath).row]!]!)!
        let components = (calendar as NSCalendar).components([ .day],
                                                             from: date, to: Date(), options: NSCalendar.Options.wrapComponents)
        if components.day! > 7 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyy"
            cell.messageTimestamp.text = dateFormatter.string(from: date)
        }
        else if components.day! >= 2 {
            let calendar = Calendar.current
            let date = (messageTimestamps[messagePositionToMessageIdMapping[(indexPath as NSIndexPath).row]!]!)!
            let components = (calendar as NSCalendar).components([.weekday],
                                                                 from: date)
            cell.messageTimestamp.text = String(getWeekDay(components.weekday!))
        }
        else if components.day! >= 1 {
            cell.messageTimestamp.text = "Yesterday"
        }
        else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            cell.messageTimestamp.text = dateFormatter.string(from: date)
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
                    messageObject["message_viewed"] = [ (PFUser.current()?.objectId)! ]
                    messageObject.saveInBackground()
                }
            }
        }
        segueToSingleMessage = true
        performSegue(withIdentifier: "showSingleMessageFromMessages", sender: self)
        
        
    }
    
}
