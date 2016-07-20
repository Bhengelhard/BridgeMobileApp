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
    var isSeguedFromNewMessage = false
    var isSeguedFromBridgePage = false
    var isSeguedFromMessages = false
    var messageContentArrayMapping = [String:[String:AnyObject]]()
    var messageContentArray = [[String:AnyObject]]()
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
            singleMessage["message_text"] = messageText.text!
            singleMessage["sender"] = PFUser.currentUser()?.objectId
            //save users_in_message to singleMessage
            singleMessage["message_id"] = messageId
            
            singleMessage.saveInBackgroundWithBlock { (success, error) -> Void in
                
                if (success) {
                    self.updateMessages()
                    print("Object has been saved.")
                    
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
                    let CurrentNamesInMessage: NSArray = object!["names_in_message"] as! NSArray
                    
                    var updatedIdsInMessage = [String]()
                    var updatedNamesInMessage = [String]()
                    
                    for i in 0...(CurrentIdsInMessage.count - 1) {
                        
                        if CurrentIdsInMessage[i] as? String != PFUser.currentUser()?.objectId {
                            
                            updatedIdsInMessage.append(CurrentIdsInMessage[i] as! String)
                            updatedNamesInMessage.append(CurrentNamesInMessage[i] as! String)
                            
                        }
                        
                    }
                    
                    object!["ids_in_message"] = updatedIdsInMessage
                    object!["names_in_message"] = updatedNamesInMessage
                    
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
                print("newMessageId - \(self.newMessageId)")
                if let result = result {
                    let currentUserId = (PFUser.currentUser()?.objectId)! as String
                    let participantObjectIds = result["ids_in_message"] as! [String]
                    let participantObjectIdsWithoutCurentUser = participantObjectIds.filter({$0 != currentUserId})
                    print("participantObjectIdsWithoutCurentUser \(participantObjectIdsWithoutCurentUser)")
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
                            print(stringOfNames)
                            self.navigationBar.title = stringOfNames
                        })

                    })
                    
                }
            }
        }
    }
    
    func updateMessages() {
    
        print("messageId is \(messageId)")
        let query: PFQuery = PFQuery(className: "SingleMessages")
        query.whereKey("message_id", equalTo: messageId)
        query.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
            if let error = error {
                print(error)
                
            } else if let results = results {
                if results.count < 1 {
                    self.messageContentArrayMapping["(result.objectId!)"]=["messageText":"messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText","bridgeType":"Love","senderName":"senderName", "timestamp":"timestamp", "isNotification":"isNotification","senderId":"senderId","previousSenderName":"previousSenderName", "previousSenderId":"previousSenderId","showTimestamp":true]
                    self.messageContentArray.append(["messageText":"messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText","bridgeType":"Love","senderName":"senderName", "timestamp":"timestamp","isNotification":false,"senderId":"senderId","previousSenderName":"previousSenderName", "previousSenderId":"previousSenderId","showTimestamp":true])
                    
                    self.messageContentArrayMapping["(result.objectId!)"]=["messageText":"messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText","bridgeType":"Love","senderName":"senderName", "timestamp":"timestamp", "isNotification":"isNotification","senderId":(PFUser.currentUser()?.objectId)!,"previousSenderName":"previousSenderName", "previousSenderId":"previousSenderId","showTimestamp":false]
                    self.messageContentArray.append(["messageText":"messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText","bridgeType":"Love","senderName":"senderName", "timestamp":"timestamp","isNotification":false,"senderId":(PFUser.currentUser()?.objectId)!,"previousSenderName":"previousSenderName", "previousSenderId":"previousSenderId","showTimestamp":false])
                    
                    self.messageContentArrayMapping["(result.objectId!)"]=["messageText":"messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText","bridgeType":"Business","senderName":"senderName", "timestamp":"timestamp", "isNotification":"isNotification","senderId":"senderId","previousSenderName":"previousSenderName", "previousSenderId":"previousSenderId","showTimestamp":true]
                    self.messageContentArray.append(["messageText":"messageText messageText messageText messageText messageText messageText messageText messageText messageText messageText","bridgeType":"Business","senderName":"senderName", "timestamp":"timestamp","isNotification":false,"senderId":"senderId","previousSenderName":"previousSenderName", "previousSenderId":"previousSenderId","showTimestamp":true])
                }
                var previousSenderName = ""
                var previousSenderId = ""
                var showTimestamp = true
                var previousDate:NSDate? = nil
                for result in results {
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
                        let components = calendar.components([.Month, .Day, .Year, .WeekOfYear],
                            fromDate: previousDate, toDate: date, options: NSCalendarOptions.WrapComponents)
                        if components.minute > 10 {
                            showTimestamp = true
                        }
                        else{
                            showTimestamp = false
                        }
                    }
                    let components = calendar.components([.Month, .Day, .Year, .WeekOfYear],
                            fromDate: date, toDate: NSDate(), options: NSCalendarOptions.WrapComponents)
                    if components.day > 7 {
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "MM/dd/yyy"
                        timestamp = dateFormatter.stringFromDate(date)+">"
                    }
                    else if components.day > 2 {
                        let calendar = NSCalendar.currentCalendar()
                        let date = result.createdAt!
                        let components = calendar.components([.Weekday],
                            fromDate: date)
                        timestamp = String(getWeekDay(components.weekday))+">"
                    }
                    else if components.day > 1 {
                        timestamp = "Yesterday"+">"
                    }
                    else {
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "hh:mm:ss"
                        timestamp = dateFormatter.stringFromDate(date)+">"
                        
                    }
                    self.messageContentArrayMapping[(result.objectId!)]=["messageText":messageText,"bridgeType":bridgeType,"senderName":senderName, "timestamp":timestamp, "isNotification":isNotification, "senderId":senderId, "previousSenderName":previousSenderName, "previousSenderId":previousSenderId, "showTimestamp":showTimestamp ]
                    self.messageContentArray.append(["messageText":messageText,"bridgeType":bridgeType,"senderName":senderName, "timestamp":timestamp,"isNotification":isNotification, "senderId":senderId, "previousSenderName":previousSenderName, "previousSenderId":previousSenderId, "showTimestamp":showTimestamp])
                    previousSenderName = senderName
                    previousSenderId = senderId
                    previousDate = date
                }
                
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.singleMessageTableView.reloadData()
            })

        })
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.title = singleMessageTitle
        singleMessageTableView.registerClass(SingleMessageTableCell.self, forCellReuseIdentifier: NSStringFromClass(SingleMessageTableCell))
        if isSeguedFromMessages   {
            print("calling1")
            messageId = newMessageId
            updateMessages()
            self.updateTitle()
            
        }

        else if isSeguedFromNewMessage   {
            print("calling2")
            messageId = newMessageId
            updateMessages()
            self.updateTitle()
            
        }
        else if isSeguedFromBridgePage   {
            messageId = newMessageId
            print("calling3")
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

        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return messageTextArray.count
        print("messageContentArray.count - \(messageContentArray.count)")
        return messageContentArray.count
        
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var addSenderName = false
        let senderNameLabel = UITextView(frame: CGRectZero)
        if ( (messageContentArray[indexPath.row]["senderName"] as? String)! != (messageContentArray[indexPath.row]["previousSenderName"] as? String)!) {
            addSenderName = true
        }
        var addTimestamp = true
        if (messageContentArray[indexPath.row]["showTimestamp"] as? Bool)! {
            addTimestamp = true
        }
        else {
            addTimestamp = false
        }
        if addSenderName {
            senderNameLabel.text = (messageContentArray[indexPath.row]["senderName"] as? String)!
            senderNameLabel.frame = CGRectMake(1, 0, UIScreen.mainScreen().bounds.width/3, 15)
            let fixedWidth = senderNameLabel.frame.size.width
            senderNameLabel.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
            let newSize = senderNameLabel.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
            var newFrame = senderNameLabel.frame
            newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height + CGFloat(1))
            senderNameLabel.frame = newFrame
        }

        let messageTextLabel = UITextView(frame: CGRectZero)
        messageTextLabel.text = (messageContentArray[indexPath.row]["messageText"] as? String)!
        messageTextLabel.frame = CGRectMake(UIScreen.mainScreen().bounds.width/2, 0, UIScreen.mainScreen().bounds.width/2, 25)
        let fixedWidth = messageTextLabel.frame.size.width
        messageTextLabel.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        let newSize = messageTextLabel.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = messageTextLabel.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        
        let timestampLabel = UILabel(frame: CGRectZero)
        if addTimestamp {
            timestampLabel.frame = CGRectMake(UIScreen.mainScreen().bounds.width*0.35, 0, UIScreen.mainScreen().bounds.width*0.30, 25)
            timestampLabel.layer.borderWidth = 1
            timestampLabel.layer.cornerRadius = 5
            timestampLabel.layer.borderColor = senderNameLabel.backgroundColor?.CGColor
        }

        print("tableView \(indexPath.row) : \(newFrame.height)")
        return newFrame.height + senderNameLabel.frame.height + timestampLabel.frame.height + CGFloat(8)

        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(SingleMessageTableCell), forIndexPath: indexPath) as! SingleMessageTableCell
        let singleMessageContent = SingleMessageContent(messageContent: messageContentArray[indexPath.row])
        //print("messageContentArray[indexPath.row] - \(messageContentArray[indexPath.row])")
        cell.singleMessageContent = singleMessageContent
        //print("cell \(indexPath.row) \(cell.frame.height)")
        return cell
        
        
    }

}
