//
//  SingleMessageViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 4/8/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

//var segueFromExitedMessage = false

class SingleMessageViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var messageText: UITextField!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    var messageTextArray = [String]()
    var newMessageId = String()
    var bridgeType =  String()
    var isSeguedFromNewMessage = false
    var isSeguedFromBridgePage = false
    var isSeguedFromMessages = false
    var objectIDToMessageContentArrayMapping = [String:[String:AnyObject]]()
//    var messageContentArray = [[String:AnyObject]]()
    var singleMessagePositionToObjectIDMapping = [Int:String]()
    var refresher = UIRefreshControl()
    let transitionManager = TransitionManager()
    
    @IBOutlet weak var singleMessageTableView: UITableView!
    @IBOutlet weak var sendButton: UIBarButtonItem!
    @IBAction func sendMessage(sender: UIButton) {
        
        if messageText.text != "" {
            
            //call the end editing method for the text field
            messageText.endEditing(true)
            
            //disable the  textfield and sendButton
            
            messageText.enabled = false
            sendButton.enabled = false
            
            let singleMessage = PFObject(className: "SingleMessages")
            let acl = PFACL()
            acl.publicReadAccess = true
            acl.publicWriteAccess = true
            singleMessage.ACL = acl
            singleMessage["message_text"] = messageText.text!
            singleMessage["sender"] = PFUser.currentUser()?.objectId
            //save users_in_message to singleMessage
            singleMessage["message_id"] = messageId
            singleMessage["bridge_type"] = bridgeType
            singleMessage.saveInBackgroundWithBlock { (success, error) -> Void in
                
                if (success) {
                    
                    self.objectIDToMessageContentArrayMapping = [String:[String:AnyObject]]()
                    self.singleMessagePositionToObjectIDMapping = [Int:String]()
                    self.updateMessages()
                    //print("Object has been saved.")
                    // push notification starts
                    let messageQuery = PFQuery(className: "Messages")
                    messageQuery.getObjectInBackgroundWithId(messageId, block: { (object, error) in
                        if error == nil {
                            if let object = object {
                                // update the no of message in a Thread - Start
                                if let noOfSingleMessages = object["no_of_single_messages"] as? Int {
                                    object["no_of_single_messages"] = noOfSingleMessages + 1
                                }
                                else {
                                    object["no_of_single_messages"] = 1
                                }
                                if var noOfSingleMessagesViewed = NSKeyedUnarchiver.unarchiveObjectWithData(object["no_of_single_messages_viewed"] as! NSData)! as? [String:Int] {
                                    noOfSingleMessagesViewed[PFUser.currentUser()!.objectId!] = (object["no_of_single_messages"] as! Int)
                                    object["no_of_single_messages_viewed"] = NSKeyedArchiver.archivedDataWithRootObject(noOfSingleMessagesViewed)
                                }
                                object["lastSingleMessageAt"] = NSDate()
                                object["message_viewed"] = [(PFUser.currentUser()?.objectId)!]
                                object.saveInBackgroundWithBlock{
                                    (success, error) -> Void in
                                    if error == nil {
                                    for userId in object["ids_in_message"] as! [String] {
                                    // Skip sending the current user a notification
                                    if userId == PFUser.currentUser()!.objectId {
                                    continue
                                    }
                                    // Skip sending a notification to a user who hasn't viewed the bridge notification yet.
                                    // But in order to mainatain sync with other users set no of meesages viewed by this user to 1
                                    if object["no_of_single_messages"] as! Int == 2 {
                                    if var noOfSingleMessagesViewed = NSKeyedUnarchiver.unarchiveObjectWithData(object["no_of_single_messages_viewed"] as! NSData)! as? [String:Int] {
                                    if noOfSingleMessagesViewed[userId] == nil {
                                    noOfSingleMessagesViewed[userId] = 1
                                    object["no_of_single_messages_viewed"] = NSKeyedArchiver.archivedDataWithRootObject(noOfSingleMessagesViewed)
                                    object.saveInBackground()
                                    continue
                                    }
                                    }
                                    
                                    }
                                    let notificationMessage = "Message from " + (PFUser.currentUser()!["name"] as! String)
                                    PFCloud.callFunctionInBackground("pushNotification", withParameters: ["userObjectId":userId,"alert":notificationMessage, "badge": "Increment", "messageType" : "SingleMessage",  "messageId": self.newMessageId]) {
                                    (response: AnyObject?, error: NSError?) -> Void in
                                    if error == nil {
                                    if let response = response as? String {
                                    print(response)
                                    }
                                    }
                                    }
                                    }
                                    self.updatePushNotifications()
                                    }
                                }
                                // update the no of message in a Thread - End
                                
                            }
                        }
                    })
                    // push notification ends
                    
                } else {
                    
                    print(error)
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    //enable the textfield and sendButton
                    self.messageText.enabled = true
                    self.sendButton.enabled = true
                    self.messageText.text = ""
                    
                })
                
            }

        }
        
    }
    @IBAction func exitMessage(sender: AnyObject) {
        
        //create the alert controller
        let alert = UIAlertController(title: "Exiting the Message", message: "Are you sure you want to leave this conversation?", preferredStyle: UIAlertControllerStyle.Alert)
        
        //Create the actions
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) in
            
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action) in
            
            //take currentUser out of the current ids_in_message
            
            let messageQuery = PFQuery(className: "Messages")
            messageQuery.getObjectInBackgroundWithId(messageId, block: { (object, error) in
                
                if error != nil {
                    
                    print(error)
                    
                } else {
                    
                    /*dispatch_async(dispatch_get_main_queue(), {
                     
                     segueFromExitedMessage = true
                     
                     })*/
                    
                    let CurrentIdsInMessage: NSArray = object!["ids_in_message"] as! NSArray
                    //let CurrentNamesInMessage: NSArray = object!["names_in_message"] as! NSArray
                    
                    var updatedIdsInMessage = [String]()
                   // var updatedNamesInMessage = [String]()
                    
                    for i in 0...(CurrentIdsInMessage.count - 1) {
                        
                        if CurrentIdsInMessage[i] as? String != PFUser.currentUser()?.objectId {
                            
                            updatedIdsInMessage.append(CurrentIdsInMessage[i] as! String)
                         //   updatedNamesInMessage.append(CurrentNamesInMessage[i] as! String)
                            
                        }
                        
                    }
                    
                    object!["ids_in_message"] = updatedIdsInMessage
                   // object!["names_in_message"] = updatedNamesInMessage
                    
                    object!.saveInBackgroundWithBlock({ (success, error) in
                        
                        print("message updated for exited user")
                        
                    })
                    
                }
                
                
                
            })
            
            dispatch_async(dispatch_get_main_queue(), {
                
                //pop-up/drop-down segue for BridgeViewController Message creations
                self.performSegueWithIdentifier("showBridgeFromSingleMessage", sender: self)
                
                //slide in and slide back segue from Messages message access.
                
                //self.performSegueWithIdentifier("showMessagesFromSingleMessage", sender: self)
                
            })
            
            
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    func updateTitle(){
        var stringOfNames = ""
        let query: PFQuery = PFQuery(className: "Messages")
        query.getObjectInBackgroundWithId(newMessageId) { (result: PFObject?, error: NSError?) -> Void in
            if error == nil {
                //print("newMessageId - \(self.newMessageId)")
                if let result = result {
                    let currentUserId = (PFUser.currentUser()?.objectId)! as String
                    let participantObjectIds = result["ids_in_message"] as! [String]
                    let participantObjectIdsWithoutCurentUser = participantObjectIds.filter({$0 != currentUserId})
                    //print("participantObjectIdsWithoutCurentUser \(participantObjectIdsWithoutCurentUser)")
                    let query: PFQuery = PFQuery(className: "_User")
                    query.whereKey("objectId", containedIn: participantObjectIdsWithoutCurentUser)
                    query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, err: NSError?) in
                        if err == nil {
                            if let objects = objects {
                                var i = 0
                                for object in objects {
                                    if var name = object["name"] as? String{
                                        if objects.count > 2 && i < objects.count - 2 {
                                            var fullNameArr = name.characters.split{$0 == " "}.map(String.init)
                                            stringOfNames = stringOfNames + fullNameArr[0] + " , "
                                            
                                        } else if objects.count >= 2 && i == objects.count - 2 {
                                            var fullNameArr = name.characters.split{$0 == " "}.map(String.init)
                                            stringOfNames = stringOfNames + fullNameArr[0] + " & "
                                            
                                        }
                                        else {
                                            if objects.count > 1{
                                                name = name.characters.split{$0 == " "}.map(String.init)[0]
                                            }
                                            stringOfNames = stringOfNames + name
                                        }
                                        i += 1

                                    }
                                }
                            }
                        }
                        dispatch_async(dispatch_get_main_queue(), {
                            //print(stringOfNames)
                            self.navigationBar.title = stringOfNames
                        })

                    })
                    
                }
            }
        }
    }
    func updatePushNotifications(){
        let messageQuery = PFQuery(className: "Messages")
        messageQuery.getObjectInBackgroundWithId(messageId, block: { (object, error) in
            if error == nil {
                if let object = object {
                    // update the no of messages viewed in a Thread by the current user - Start
                    let installation = PFInstallation.currentInstallation()
                    if let noOfSingleMessages = object["no_of_single_messages"] as? Int {
                        if var noOfSingleMessagesViewed = NSKeyedUnarchiver.unarchiveObjectWithData(object["no_of_single_messages_viewed"] as! NSData)! as? [String:Int] {
                            if noOfSingleMessagesViewed[PFUser.currentUser()!.objectId!] == nil {
                                noOfSingleMessagesViewed[PFUser.currentUser()!.objectId!] = 0
                            }
                            
                            print("installation.badge, noOfSingleMessages, noOfSingleMessagesViewed[PFUser.currentUser()!.objectId!]! are \(installation.badge), \(noOfSingleMessages), \(noOfSingleMessagesViewed[PFUser.currentUser()!.objectId!]!) ")
                            installation.badge = installation.badge - (noOfSingleMessages - noOfSingleMessagesViewed[PFUser.currentUser()!.objectId!]!)
                            
                            noOfSingleMessagesViewed[PFUser.currentUser()!.objectId!] = noOfSingleMessages
                            object["no_of_single_messages_viewed"] = NSKeyedArchiver.archivedDataWithRootObject(noOfSingleMessagesViewed)
                            object.saveInBackground()
                        }
                    }
                    
                    installation.saveInBackground()
                    // update the no of messages viewed in a Thread by the current user - End
                }
            }
        })

    }
    func reloadThread(notification: NSNotification) {
        print("Yes, received notification at reload the thread")
        self.objectIDToMessageContentArrayMapping = [String:[String:AnyObject]]()
        self.singleMessagePositionToObjectIDMapping = [Int:String]()
        self.updateMessages()
    }
    func updateMessages() {
       singleMessageTableView.userInteractionEnabled = false
        //print("messageId is \(messageId)")
        let query: PFQuery = PFQuery(className: "SingleMessages")
        query.whereKey("message_id", equalTo: messageId)
        query.orderByDescending("createdAt")
        query.limit = 10
        query.skip = objectIDToMessageContentArrayMapping.count
        query.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
            if let error = error {
                print(error)
                
            } else if let results = results {
                 //self.objectIDToMessageContentArrayMapping = [String:[String:AnyObject]]()
                 //self.messageContentArray = [[String:AnyObject]]()

//                if results.count < 1 {
//                    self.objectIDToMessageContentArrayMapping["(result.objectId!)"]=["messageText":"messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText","bridgeType":"Love","senderName":"senderName", "timestamp":"timestamp", "isNotification":"isNotification","senderId":"senderId","previousSenderName":"previousSenderName", "previousSenderId":"previousSenderId","showTimestamp":true]
//                    self.messageContentArray.append(["messageText":"messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText","bridgeType":"Love","senderName":"senderName", "timestamp":"timestamp","isNotification":false,"senderId":"senderId","previousSenderName":"previousSenderName", "previousSenderId":"previousSenderId","showTimestamp":true])
//                    
//                    self.objectIDToMessageContentArrayMapping["(result.objectId!)"]=["messageText":"messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText","bridgeType":"Love","senderName":"senderName", "timestamp":"timestamp", "isNotification":"isNotification","senderId":(PFUser.currentUser()?.objectId)!,"previousSenderName":"previousSenderName", "previousSenderId":"previousSenderId","showTimestamp":false]
//                    self.messageContentArray.append(["messageText":"messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText","bridgeType":"Love","senderName":"senderName", "timestamp":"timestamp","isNotification":false,"senderId":(PFUser.currentUser()?.objectId)!,"previousSenderName":"previousSenderName", "previousSenderId":"previousSenderId","showTimestamp":false])
//                    
//                    self.objectIDToMessageContentArrayMapping["(result.objectId!)"]=["messageText":"messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText","bridgeType":"Business","senderName":"senderName", "timestamp":"timestamp", "isNotification":"isNotification","senderId":"senderId","previousSenderName":"previousSenderName", "previousSenderId":"previousSenderId","showTimestamp":true]
//                    self.messageContentArray.append(["messageText":"messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText","bridgeType":"Business","senderName":"senderName", "timestamp":"timestamp","isNotification":false,"senderId":"senderId","previousSenderName":"previousSenderName", "previousSenderId":"previousSenderId","showTimestamp":true])
//                }
                if results.count > 0{
                var singleMessagePosition = 0
                for i in (0..<self.singleMessagePositionToObjectIDMapping.count).reverse(){
                    let temp = self.singleMessagePositionToObjectIDMapping[i]
                    self.singleMessagePositionToObjectIDMapping[i+results.count] = temp
                }
                var previousSenderName = ""
                var previousSenderId = ""
                var showTimestamp = true
                var previousDate:NSDate? = nil

                for i in (0..<results.count).reverse() {
                    let result = results[i]
                    var messageText = ""
                    if let ob = result["message_text"] as? String {
                        messageText = ob
                    }
                    var bridgeType = ""
                    if let ob = result["bridge_type"] as? String {
                        bridgeType = ob
                    }
                    var isNotification = false
                    if let ob = result["is_notification"] as? Bool {
                        isNotification = ob
                    }
                    var senderName = ""
                    var senderId = ""
                    if let ob = result["sender"] as? String {
                        senderId = ob
                        
                        let queryForName = PFQuery(className: "_User")
                        do{
                            let userObject = try queryForName.getObjectWithId(ob)
                            if let name = userObject["name"] as? String {
                                senderName = name
                            }
                        }
                        catch{
                            
                        }
                        
                    }
                    var timestamp = ""
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "EEE, dd MMM yyy hh:mm:ss +zzzz"
                    let calendar = NSCalendar.currentCalendar()
                    let date = result.createdAt!
                    if let previousDate = previousDate {
                        let components = calendar.components([.Month, .Day, .Year, .WeekOfYear, .Minute],
                            fromDate: previousDate, toDate: date, options: NSCalendarOptions.WrapComponents)
                        //print("components.minute - \(components.minute)")
                        if components.minute > 10 {
                            showTimestamp = true
                        }
                        else{
                            showTimestamp = false
                        }
                    }
                    //print("date - \(date), toDate - \(NSDate())")
                    let components = calendar.components([.Day],
                            fromDate: date, toDate: NSDate(), options: [])
                    //print(components)
                    if components.day > 7 {
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "MM/dd/yyy"
                        timestamp = dateFormatter.stringFromDate(date)+">"
                    }
                    else if components.day >= 2 {
                        let calendar = NSCalendar.currentCalendar()
                        let date = result.createdAt!
                        let components2 = calendar.components([.Weekday],
                            fromDate: date)
                        timestamp = String(getWeekDay(components2.weekday))+">"
                    }
                    else if components.day >= 1 {
                        timestamp = "Yesterday"+">"
                    }
                    else {
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "hh:mm:ss a"
                        timestamp = dateFormatter.stringFromDate(date)+">"
                        
                    }
                    self.objectIDToMessageContentArrayMapping[(result.objectId!)]=["messageText":messageText,"bridgeType":bridgeType,"senderName":senderName, "timestamp":timestamp, "isNotification":isNotification, "senderId":senderId, "previousSenderName":previousSenderName, "previousSenderId":previousSenderId, "showTimestamp":showTimestamp, "date":date ]
                    self.singleMessagePositionToObjectIDMapping[singleMessagePosition] = (result.objectId!)
                    singleMessagePosition += 1
                    previousSenderName = senderName
                    previousSenderId = senderId
                    previousDate = date
                    //update the older entry's previousSenderName, Id and timestamp
                    if (i == 0 && self.objectIDToMessageContentArrayMapping.count > results.count){
                        var show = false
                        let temp = self.objectIDToMessageContentArrayMapping[self.singleMessagePositionToObjectIDMapping[results.count]!]!
                        let components = calendar.components([.Month, .Day, .Year, .WeekOfYear, .Minute],
                                fromDate: date, toDate: temp["date"]! as! NSDate, options: NSCalendarOptions.WrapComponents)
                        if components.minute > 10 {
                            show = true
                        }
                        else{
                            show = false
                        }
                        self.objectIDToMessageContentArrayMapping[self.singleMessagePositionToObjectIDMapping[results.count]!] = ["messageText":temp["messageText"]!,"bridgeType":temp["bridgeType"]!,"senderName":temp["senderName"]!, "timestamp":temp["timestamp"]!, "isNotification":temp["isNotification"]!, "senderId":temp["senderId"]!, "previousSenderName":senderName, "previousSenderId":senderId, "showTimestamp":show, "date":temp["date"]! ]
                    }

                }
                }
                
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.refresher.endRefreshing()
                self.singleMessageTableView.reloadData()
                self.singleMessageTableView.userInteractionEnabled = true
            })

        })
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePushNotifications()
        let messageQuery = PFQuery(className: "Messages")
        messageQuery.getObjectInBackgroundWithId(newMessageId, block: { (object, error) in
            if error == nil {
                if let object = object {
                    if let x = object["message_type"] as? String? {
                        self.bridgeType = x!
                    }
                    else {
                        self.bridgeType = "Friendship"
                    }
                }
            }
        })
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.reloadThread), name: "reloadTheThread", object: nil)
        refresher.attributedTitle = NSAttributedString(string:"Pull to see older messages")
        refresher.addTarget(self, action: #selector(SingleMessageViewController.updateMessages), forControlEvents: UIControlEvents.ValueChanged)
        singleMessageTableView.addSubview(refresher)
        navigationBar.title = singleMessageTitle
        singleMessageTableView.registerClass(SingleMessageTableCell.self, forCellReuseIdentifier: NSStringFromClass(SingleMessageTableCell))
        if isSeguedFromMessages   {
            //print("calling1")
            messageId = newMessageId
            updateMessages()
            self.updateTitle()
            
        }

        else if isSeguedFromNewMessage   {
            //print("calling2")
            messageId = newMessageId
            updateMessages()
            self.updateTitle()
            
        }
        else if isSeguedFromBridgePage   {
            messageId = newMessageId
            //print("calling3")
            updateMessages()
            self.updateTitle()
//            let seconds = 4.0
//            let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
//            let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
//            
//            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
//                
//            })
        }
        else {
            messageId = newMessageId
            updateMessages()
            self.updateTitle()
        }

        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Update the fact that you have viewed the message Thread when you segue
        // Segue is not the best place to put this. If you are about to close the view this should get called
        print("segue Called")
        let vc = segue.destinationViewController
        let mirror = Mirror(reflecting: vc)
        if mirror.subjectType == BridgeViewController.self || mirror.subjectType == MessagesViewController.self {
            self.transitionManager.animateRightToLeft = false
        }
        vc.transitioningDelegate = self.transitionManager
        let messageQuery = PFQuery(className: "Messages")
        messageQuery.getObjectInBackgroundWithId(messageId, block: { (object, error) in
            if error == nil {
                if let object = object {
                    if var ob = object["message_viewed"] as? [String] {
                        if !ob.contains((PFUser.currentUser()?.objectId)!) {
                            ob.append((PFUser.currentUser()?.objectId)!)
                            object["message_viewed"] = ob
                        }
                        
                    }
                    else {
                        object["message_viewed"] = [(PFUser.currentUser()?.objectId)!]
                    }
                    if var noOfSingleMessagesViewed = NSKeyedUnarchiver.unarchiveObjectWithData(object["no_of_single_messages_viewed"] as! NSData)! as? [String:Int] {
                        noOfSingleMessagesViewed[PFUser.currentUser()!.objectId!] = (object["no_of_single_messages"] as! Int)
                        object["no_of_single_messages_viewed"] = NSKeyedArchiver.archivedDataWithRootObject(noOfSingleMessagesViewed)
                    }

                    object.saveInBackground()
                }
            }
        })
//        if let _ = self.navigationController{
//            print("no - \(navigationController?.viewControllers.count)")
//            if (navigationController?.viewControllers.count)! > 1 {
//                for _ in (1..<(navigationController?.viewControllers.count)!).reverse()  {
//                    navigationController?.viewControllers.removeAtIndex(0)
//                }
//            }
//            
//            navigationController?.viewControllers.removeAll()
//        }

        
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return messageTextArray.count
        //print("objectIDToMessageContentArrayMapping.count - \(objectIDToMessageContentArrayMapping.count)")
        return objectIDToMessageContentArrayMapping.count
        
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var addSenderName = false
        let messageContent = objectIDToMessageContentArrayMapping[singleMessagePositionToObjectIDMapping[indexPath.row]!]!
        
        let senderNameLabel = UITextView(frame: CGRectZero)
        let messageTextLabel = UITextView(frame: CGRectZero)
        let timestampLabel = UILabel(frame: CGRectZero)
        
        if ((messageContent["senderId"] as? String)! != (PFUser.currentUser()?.objectId)!)  {
            if ( (messageContent["senderName"] as? String)! != (messageContent["previousSenderName"] as? String)!) {
            addSenderName = true
            }
        }
        var addTimestamp = false
        if (messageContent["showTimestamp"] as? Bool)! {
            addTimestamp = true
        }
        else {
            addTimestamp = false
        }
        
        
        if addTimestamp {
            timestampLabel.frame = CGRectMake(UIScreen.mainScreen().bounds.width*0.35, 0, UIScreen.mainScreen().bounds.width*0.30, 27)
            timestampLabel.layer.borderWidth = 1
            timestampLabel.layer.cornerRadius = 5
            timestampLabel.layer.borderColor = senderNameLabel.backgroundColor?.CGColor
        }
        if addSenderName {
            senderNameLabel.text = (messageContent["senderName"] as? String)!
            var width = (UIScreen.mainScreen().bounds.width/3 )
            width += CGFloat(5)
            senderNameLabel.frame = CGRectMake(5, 0, width, 15)
            let fixedWidth = senderNameLabel.frame.size.width
            let newSize = senderNameLabel.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
            var newFrame = senderNameLabel.frame
            newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height + 1)
            senderNameLabel.frame = newFrame
        }

        
        
        messageTextLabel.text = (messageContent["messageText"] as? String)!
        messageTextLabel.frame = CGRectMake(UIScreen.mainScreen().bounds.width/2, 0, UIScreen.mainScreen().bounds.width/2, 25)
        let fixedWidth = messageTextLabel.frame.size.width
        let newSize = messageTextLabel.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = messageTextLabel.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        messageTextLabel.frame = newFrame
        

        //print("tableView \(indexPath.row) : \(newFrame.height)")
        return messageTextLabel.frame.height + senderNameLabel.frame.height + timestampLabel.frame.height + CGFloat(2)

        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(SingleMessageTableCell), forIndexPath: indexPath) as! SingleMessageTableCell
        let cell = SingleMessageTableCell()
        let messageContent = objectIDToMessageContentArrayMapping[singleMessagePositionToObjectIDMapping[indexPath.row]!]!
        let singleMessageContent = SingleMessageContent(messageContent: messageContent)
        //print("senderName - \(singleMessageContent.senderName!) previousSenderName - \(singleMessageContent.previousSenderName!) messageText -  \(singleMessageContent.messageText!) ")
        //print("")
        //print("messageContentArray[indexPath.row] - \(messageContentArray[indexPath.row])")
        cell.singleMessageContent = singleMessageContent
        //print("cell \(indexPath.row) \(cell.frame.height)")
        return cell
        
        
    }

}
