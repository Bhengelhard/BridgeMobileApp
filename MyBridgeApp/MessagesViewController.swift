//
//  MessagesViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 3/30/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

var singleMessageTitle = "Message"
var messageId = String()
//var messageID =

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
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var loveButton: UIBarButtonItem!
    @IBOutlet weak var businessButton: UIBarButtonItem!
    @IBOutlet weak var friendshipButton: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    let necterYellow = UIColor(red: 255/255, green: 230/255, blue: 57/255, alpha: 1.0)
    let businessBlue = UIColor(red: 36.0/255, green: 123.0/255, blue: 160.0/255, alpha: 1.0)
    let loveRed = UIColor(red: 242.0/255, green: 95.0/255, blue: 92.0/255, alpha: 1.0)
    let friendshipGreen = UIColor(red: 112.0/255, green: 193.0/255, blue: 179.0/255, alpha: 1.0)
    let necterGray = UIColor(red: 80.0/255.0, green: 81.0/255.0, blue: 79.0/255.0, alpha: 1.0)
    
    
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
    
    @IBAction func friendshipTapped(sender: AnyObject) {
       toolbarTapped = true
        filteredPositions = [Int]()
        for i in 0 ..< messageType.count{
            if messageType[messagePositionToMessageIdMapping[i]!]! == "Friendship" {
                filteredPositions.append(i)
            }
        }
        self.tableView.reloadData()
    }
    @IBAction func loveTapped(sender: AnyObject) {
        toolbarTapped = true
        filteredPositions = [Int]()
        print("loveButtonClicked")
        for i in 0 ..< messageType.count{
            if messageType[messagePositionToMessageIdMapping[i]!]! == "Love" {
                filteredPositions.append(i)
            }
        }
        self.tableView.reloadData()
    }
    @IBAction func businessTapped(sender: AnyObject) {
        toolbarTapped = true
        filteredPositions = [Int]()
        for i in 0 ..< messageType.count{
            if messageType[messagePositionToMessageIdMapping[i]!]! == "Business" {
                filteredPositions.append(i)
            }
        }
        //print("Filtered positions count is \(messageType.count)")
        self.tableView.reloadData()
    }
   
    @IBAction func allBridgesTapped(sender: AnyObject) {
        toolbarTapped = true
        filteredPositions = [Int]()
        for i in 0 ..< messageType.count{
            filteredPositions.append(i)
        }

        self.tableView.reloadData()
    }
    @IBAction func segueToBridgeViewController(sender: AnyObject) {
        self.runBackgroundThread = false
        navigationController?.popViewControllerAnimated(true)
        
    }
    @IBAction func composeMessage(sender: AnyObject) {
        performSegueWithIdentifier("showNewMessageFromMessages", sender: self)
    }
    
    // startBackgroundThread() reloads the table when the 3 async Parse tasks are complete
    @IBAction func bridgeTapped(sender: AnyObject) {
        performSegueWithIdentifier("showBridgeFromMessages", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
           self.runBackgroundThread = false
        if segueToSingleMessage {
            //print(" prepareForSegue was Called")
            segueToSingleMessage = false
            let singleMessageVC:SingleMessageViewController = segue.destinationViewController as! SingleMessageViewController
            singleMessageVC.transitioningDelegate = self.transitionManager
            singleMessageVC.isSeguedFromMessages = true
            singleMessageVC.newMessageId = self.singleMessageId
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
    func startBackgroundThread() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            while self.runBackgroundThread && (self.isElementCountNotFetched || self.names.count < self.totalElements || self.messageTimestamps.count < self.totalElements ||  self.messages.count <  self.totalElements   ) {

                if self.encounteredBefore[self.noOfElementsFetched] == nil && self.noOfElementsFetched > 0 && self.names.count == self.noOfElementsFetched && self.messages.count == self.noOfElementsFetched && self.messageTimestamps.count == self.noOfElementsFetched{
                    self.encounteredBefore[self.noOfElementsFetched] = true
                    dispatch_async(dispatch_get_main_queue(), {
                        //self.refresher.endRefreshing()
                        //print("reloadData")
                        self.tableView.reloadData()
                        self.pagingSpinner.stopAnimating()
                    })
                }
                
            }
            //print("backgroundThread stopped")
        }
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

                        self.messages[result.objectId!] = ("Your new bridge awaits")
                        //self.messageTimestamps[result.objectId!] = (result.createdAt!)
                        self.messages[result.objectId!] = ("Your new connection awaits")
                        //self.messageTimestamps[result.objectId!] = (result.createdAt!)
                    }
                    else {
                        for messageObject in objects! {
                            if let _ = messageObject["message_text"] {
                                self.messages[result.objectId!] = (messageObject["message_text"] as! (String))
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
                    })
                    
                }
            }
           
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create NavigationBar
        
        
        
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

    }
    
    override func viewDidLayoutSubviews() {
        
        navigationBar.frame = CGRect(x: 0, y:0, width:screenWidth, height:0.1*screenHeight)
        tableView.frame = CGRect(x: 0, y:0.1*screenHeight, width:screenWidth, height:0.825*screenHeight)
        toolBar.frame = CGRect(x: 0, y:0.9*screenHeight, width:screenWidth, height:0.1*screenHeight)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //print ("indexPath - \(indexPath.row) & noOfElementsFetched - \(noOfElementsFetched)" )
        if (indexPath.row == noOfElementsFetched - 1) && (noOfElementsFetched < totalElements) {
        //print ("noOfElementsFetched, totalElements = \(noOfElementsFetched) & \(totalElements)")
        pagingSpinner.startAnimating()
        refresh()
        }
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
        if indexPath.row != 0 {
            cell.setSeparator = true
        }

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
