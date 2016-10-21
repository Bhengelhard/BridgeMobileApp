//
//  SingleMessageViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 4/8/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class SingleMessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    //Creating the navigationBar
    let navigationBar = UINavigationBar()
    let navItem = UINavigationItem()
    let messagesButton = UIButton()
    let leaveConversation = UIButton()
    let navBarTitleButton =  UIButton(type: .custom)
    var userName1 = ""
    var userId1 = ""
    var userName2 = ""
    var userId2 = ""
    
    //Creating the tableView
    let singleMessageTableView = UITableView()
    let noMessagesLabel = UILabel()
    
    //Creating the toolBar
    let toolbar = UIToolbar()
    let messageText = UITextView()
    let sendButton = UIButton()
    var necterTypeColor = UIColor.gray
    
    //setting the height of the keyboard
    var keyboardHeight = CGFloat()
    
    //screen dimensions
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    //getting information on which viewController the user was on prior to this one
    var seguedFrom = ""
    var messageId = String()
    var singleMessageTitle = "Conversation"
    var firstTableAppearance = true
    
    //necter Colors
    let necterYellow = UIColor(red: 255/255, green: 230/255, blue: 57/255, alpha: 1.0)
    let businessBlue = UIColor(red: 36.0/255, green: 123.0/255, blue: 160.0/255, alpha: 1.0)
    let loveRed = UIColor(red: 242.0/255, green: 95.0/255, blue: 92.0/255, alpha: 1.0)
    let friendshipGreen = UIColor(red: 112.0/255, green: 193.0/255, blue: 179.0/255, alpha: 1.0)
    let necterGray = UIColor(red: 80.0/255.0, green: 81.0/255.0, blue: 79.0/255.0, alpha: 1.0)
    
    //var messageTextArray = [String]()
    var newMessageId = String()
    var isNotification = false
    var bridgeType =  String()
    var isSeguedFromNewMessage = false
    var isSeguedFromBridgePage = false
    var isSeguedFromMessages = false
    var objectIDToMessageContentArrayMapping = [String:[String:AnyObject]]()
//    var messageContentArray = [[String:AnyObject]]()
    var singleMessagePositionToObjectIDMapping = [Int:String]()
    var refresher = UIRefreshControl()
    let transitionManager = TransitionManager()
    
   
    func updateNoOfPushNotificationsOnBadge(){
        let messageQuery = PFQuery(className: "Messages")
        messageQuery.getObjectInBackground(withId: messageId, block: { (object, error) in
            if error == nil {
                if let object = object {
                    // update the no of messages viewed in a Thread by the current user - Start
                    if var ob = object["message_viewed"] as? [String] {
                        if !ob.contains((PFUser.current()?.objectId)!) {
                            ob.append((PFUser.current()?.objectId)!)
                            object["message_viewed"] = ob
                        }
                        
                    }
                    else {
                        object["message_viewed"] = [(PFUser.current()?.objectId)!]
                    }
                    let installation = PFInstallation.current()
                    if let noOfSingleMessages = object["no_of_single_messages"] as? Int {
                        if var noOfSingleMessagesViewed = NSKeyedUnarchiver.unarchiveObject(with: object["no_of_single_messages_viewed"] as! Data)! as? [String:Int] {
                            if noOfSingleMessagesViewed[PFUser.current()!.objectId!] == nil {
                                noOfSingleMessagesViewed[PFUser.current()!.objectId!] = 0
                            }
                            
                            installation.badge = installation.badge - (noOfSingleMessages - noOfSingleMessagesViewed[PFUser.current()!.objectId!]!)
                            
                            noOfSingleMessagesViewed[PFUser.current()!.objectId!] = noOfSingleMessages
                            object["no_of_single_messages_viewed"] = NSKeyedArchiver.archivedData(withRootObject: noOfSingleMessagesViewed)
                            object.saveInBackground(block: { (success, error) in
                                if error == nil && success {
                                    installation.saveInBackground()
                                    
                                }
                            })
                        }
                    }
                    
                    
                    // update the no of messages viewed in a Thread by the current user - End
                }
            }
        })

    }
    func reloadThread(_ notification: Notification) {
        self.objectIDToMessageContentArrayMapping = [String:[String:AnyObject]]()
        self.singleMessagePositionToObjectIDMapping = [Int:String]()
        self.updateMessages()
    }
    
    func updateMessages() {
        singleMessageTableView.isUserInteractionEnabled = false
        
        let query: PFQuery = PFQuery(className: "SingleMessages")
        query.whereKey("message_id", equalTo: messageId)
        query.order(byDescending: "createdAt")
        query.limit = 10
        query.skip = objectIDToMessageContentArrayMapping.count
        query.findObjectsInBackground(block: { (results, error) -> Void in
            if let error = error {
                print(error)
                
            } else if let results = results {
                if results.count > 0{
                    DispatchQueue.main.async(execute: {
                        self.noMessagesLabel.alpha = 0
                    })
                var singleMessagePosition = 0
                for i in (0..<self.singleMessagePositionToObjectIDMapping.count).reversed(){
                    let temp = self.singleMessagePositionToObjectIDMapping[i]
                    self.singleMessagePositionToObjectIDMapping[i+results.count] = temp
                }
                var previousSenderName = ""
                var previousSenderId = ""
                var showTimestamp = true
                var previousDate:Date? = nil

                for i in (0..<results.count).reversed() {
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
                    }
                    if let ob = result["sender_name"] as? String {
                        senderName = ob
                    }
                    var timestamp = ""
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "EEE, dd MMM yyy hh:mm:ss +zzzz"
                    let calendar = Calendar.current
                    let date = result.createdAt!
                    if let previousDate = previousDate {
                        let components = (calendar as NSCalendar).components([.minute],
                            from: previousDate, to: date, options: NSCalendar.Options.wrapComponents)
                        if components.minute! > 2 {
                            showTimestamp = true
                        }
                        else{
                            showTimestamp = false
                        }
                    }
                    let components = (calendar as NSCalendar).components([.day],
                            from: date, to: Date(), options: [])
                    if components.day! > 7 {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM/dd/yyy"
                        timestamp = dateFormatter.string(from: date)
                    }
                    else if components.day! >= 2 {
                        let calendar = Calendar.current
                        let date = result.createdAt!
                        let components2 = (calendar as NSCalendar).components([.weekday],
                            from: date)
                        timestamp = String(getWeekDay(components2.weekday!))
                    }
                    else if components.day! >= 1 {
                        timestamp = "Yesterday"
                    }
                    else {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "hh:mm a"
                        timestamp = dateFormatter.string(from: date)
                        
                    }
                    let objectIDToMessageContentArrayMappingFirstHalf = ["messageText":messageText as AnyObject,"bridgeType":bridgeType as AnyObject,"senderName":senderName as AnyObject, "timestamp":timestamp as AnyObject, "isNotification":isNotification as AnyObject, "senderId":senderId as AnyObject, "previousSenderName":previousSenderName as AnyObject, "previousSenderId":previousSenderId as AnyObject, "showTimestamp":showTimestamp as AnyObject, "date":date as AnyObject]
                    self.objectIDToMessageContentArrayMapping[(result.objectId!)] = objectIDToMessageContentArrayMappingFirstHalf
                    //self.objectIDToMessageContentArrayMapping[(result.objectId!)]=["messageText":messageText as AnyObject,"bridgeType":bridgeType as AnyObject,"senderName":senderName as AnyObject, "timestamp":timestamp as AnyObject, "isNotification":isNotification as AnyObject, "senderId":senderId as AnyObject, "previousSenderName":previousSenderName as AnyObject, "previousSenderId":previousSenderId as AnyObject, "showTimestamp":showTimestamp as AnyObject, "date":date as AnyObject]
                    self.singleMessagePositionToObjectIDMapping[singleMessagePosition] = (result.objectId!)
                    singleMessagePosition += 1
                    previousSenderName = senderName
                    previousSenderId = senderId
                    previousDate = date
                    if (i == 0 && self.objectIDToMessageContentArrayMapping.count > results.count){
                        var show = false
                        let temp = self.objectIDToMessageContentArrayMapping[self.singleMessagePositionToObjectIDMapping[results.count]!]!
                        let components = (calendar as NSCalendar).components([.minute],
                                from: date, to: temp["date"]! as! Date, options: NSCalendar.Options.wrapComponents)
                        if components.minute! > 2 {
                            show = true
                        }
                        else{
                            show = false
                        }
                        self.objectIDToMessageContentArrayMapping[self.singleMessagePositionToObjectIDMapping[results.count]!] = ["messageText":temp["messageText"]!,"bridgeType":temp["bridgeType"]!,"senderName":temp["senderName"]!, "timestamp":temp["timestamp"]!, "isNotification":temp["isNotification"]!, "senderId":temp["senderId"]!, "previousSenderName":senderName as AnyObject, "previousSenderId":senderId as AnyObject, "showTimestamp":show as AnyObject, "date":temp["date"]! ]
                    }

                }
                }
                else {
                    //results.count <= 0, so no messages label should be displayed since there are no messages to add with the update and there are no messages currently displayed
                    query.countObjectsInBackground{
                        (count: Int32, error: Error?) in
                        //print("returned")
                        if error == nil {
                            
                            let totalElements = Int(count)
                            if totalElements == 0 {
                                self.displayNoMessages()
                            } else {
                                self.noMessagesLabel.alpha = 0
                            }
                        }
                        else {
                            print(error)
                        }
                    }
                }
                
            }
            self.updateNoOfPushNotificationsOnBadge()
            DispatchQueue.main.async(execute: {
                self.refresher.endRefreshing()
                self.singleMessageTableView.reloadData()
                if self.firstTableAppearance && self.objectIDToMessageContentArrayMapping.count >= 1 {
                    self.singleMessageTableView.scrollToRow(at: IndexPath(row: self.objectIDToMessageContentArrayMapping.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: false)
                    self.firstTableAppearance = false
                }
                self.singleMessageTableView.isUserInteractionEnabled = true
            })

        })
        
    }
    func displayToolbar() {
        //setting the text field
        messageText.delegate = self
        messageText.frame.size = CGSize(width: 0.675*screenWidth, height: 35.5)
        messageText.frame.origin.x = 0.025*screenWidth
        messageText.center.y = toolbar.center.y
        //messageText.placeholder = " Write Message"
        messageText.layer.borderWidth = 1
        messageText.layer.borderColor = UIColor.lightGray.cgColor
        messageText.layer.cornerRadius = 7
        messageText.font = UIFont(name: "Verdana", size: 16)
        messageText.isScrollEnabled = false
        messageText.text = "Type a message..."
        messageText.textColor = UIColor.lightGray
        //messageText.addTarget(self, action: #selector(messageTextDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        //messageText.addTarget(self, action: #selector(messageTextTapped(_:)), forControlEvents: .TouchUpInside)
        //messageTextRecorder
        let messageTextButton = UIBarButtonItem(customView: messageText)
        
        UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: nil)

        //adding the flexible space
        //Flexible Space
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        //setting the send button
        sendButton.frame = CGRect(x: 0.7*screenWidth, y: 0, width: 0.2*screenWidth, height: 0.0605*screenHeight)
        sendButton.center.y = toolbar.center.y
        sendButton.setTitle("Send", for: UIControlState())
        sendButton.setTitleColor(necterYellow, for: UIControlState())
        sendButton.setTitleColor(necterGray, for: .disabled)
        sendButton.titleLabel?.textAlignment = NSTextAlignment.right
        sendButton.titleLabel!.font = UIFont(name: "Verdana", size: 16)
        //sendButton.layer.borderWidth = 4
        //sendButton.layer.borderColor = UIColor.blackColor().CGColor
        sendButton.addTarget(self, action: #selector(sendTapped(_:)), for: .touchUpInside)
        let sendBarButton = UIBarButtonItem(customView: sendButton)
        
        toolbar.frame = CGRect(x: 0, y: 0.925*screenHeight, width: screenWidth, height: 0.075*screenHeight)
        
        toolbar.sizeToFit()
        //toolbar.translucent = false
        toolbar.barTintColor = UIColor.white
        toolbar.items = [messageTextButton, flexibleSpace, sendBarButton]
        //toolbar.addSubview(messageText)
        view.addSubview(toolbar)
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if messageText.text != "" {
            sendButton.isEnabled = true
            
            //changing the height of the messageText based on the content
            let messageTextFixedWidth = messageText.frame.size.width
            let messageTextNewSize = messageText.sizeThatFits(CGSize(width: messageTextFixedWidth, height: CGFloat.greatestFiniteMagnitude))
            var messageTextNewFrame = messageText.frame
            messageTextNewFrame.size = CGSize(width: max(messageTextNewSize.width, messageTextFixedWidth), height: messageTextNewSize.height)
            
            let toolbarFixedHeight = 0.89*screenHeight-keyboardHeight
            
            
            if toolbarFixedHeight < messageTextNewFrame.size.height + 8.5 {
                
                print("reached the navBar")
                messageText.isScrollEnabled = true
                //messageText.frame.size.height = previousMessageHeight
                //toolbar.frame.size.height = previousToolbarHeight
            } else {
                
                messageText.frame = messageTextNewFrame
                
                //changing the height of the toolbar based on the content
                let previousToolbarHeight = toolbar.frame.height
                let newToolbarHeight = messageTextNewFrame.size.height + 8.5
                let changeInToolbarHeight = newToolbarHeight - previousToolbarHeight
                let toolbarFixedWidth = toolbar.frame.size.width
               
                //toolbar.sizeThatFits(CGSize(width: toolbarFixedWidth, height: toolbarFixedHeight))
                let toolbarNewSize = toolbar.sizeThatFits(CGSize(width: toolbarFixedWidth, height: toolbarFixedHeight))
                var toolbarNewFrame = toolbar.frame
                toolbarNewFrame.size = CGSize(width: max(toolbarNewSize.width, toolbarFixedWidth), height: min(messageTextNewFrame.size.height + 8.5, toolbarFixedHeight))
                toolbarNewFrame.origin.y = toolbar.frame.origin.y - changeInToolbarHeight
                //if the toolbar has grown to the size where it is just below the navigation bar then enable the textView to scroll
                toolbar.frame = toolbarNewFrame
            }

            
        } else {
            sendButton.isEnabled = false
        }

        
    }
    //taking away the placeholder to begin editing the textView
    func textViewDidBeginEditing(_ textView: UITextView) {
        if messageText.textColor == UIColor.lightGray {
            messageText.text = nil
            messageText.textColor = UIColor.black
        }
    }
    //adding a placeholder when the user is not editing the textView
    func textViewDidEndEditing(_ textView: UITextView) {
        if messageText.text.isEmpty {
            messageText.text = "Type a message..."
            messageText.textColor = UIColor.lightGray
        }
    }
    
    
    
    func sendTapped(_ sender: UIBarButtonItem) {
        if messageText.text != "" {
            messageText.resignFirstResponder()
            toolbar.frame = CGRect(x: 0, y: 0.925*screenHeight, width: screenWidth, height: 0.075*screenHeight)
            messageText.frame = CGRect(x: 0.025*screenWidth, y: 0, width: 0.675*screenWidth, height: 35.5)
            messageText.isScrollEnabled = false
            sendButton.isEnabled = false
            sendMessageAndNotification()
            messageText.text = ""
        }

    }
    
    func sendMessageAndNotification() {
        print("got to sendMessageAndNotification")
        var sendingMessageText = ""
        var senderName = ""
        let singleMessage = PFObject(className: "SingleMessages")
        if isNotification == true {
            if let username = PFUser.current()?["name"] as? String {
                sendingMessageText = username + " left the conversation."
                senderName = username
            }
            singleMessage["is_notification"] = true
            print("is notification == true in sendMessageAndNotification")
        } else {
            senderName = (PFUser.current()?["name"] as? String) ?? ""
            sendingMessageText = messageText.text
            print("messageText.text is set to \(messageText.text)")
            print("else reached in sendMessageAndNotification")
        }
        print(sendingMessageText)
        let acl = PFACL()
        acl.getPublicReadAccess = true
        acl.getPublicWriteAccess = true
        
        singleMessage.acl = acl
        singleMessage["message_text"] = sendingMessageText
        singleMessage["sender"] = PFUser.current()?.objectId
        singleMessage["sender_name"] = senderName
        //save users_in_message to singleMessage
        singleMessage["message_id"] = messageId
        singleMessage["bridge_type"] = bridgeType
        singleMessage.saveInBackground { (success, error) -> Void in
            
            if (success) {
                //taking the noMessagesLabel off of the screen upon the first message sent
                UIView.animate(withDuration: 0.05, animations: {
                    self.noMessagesLabel.alpha = 0
                    }, completion: { (success) in
                        self.noMessagesLabel.removeFromSuperview()
                })
                
                // push notification starts
                let singleMessagePosition = self.objectIDToMessageContentArrayMapping.count
                var previousSenderName = ""
                var previousSenderId = ""
                var previousDate:Date? = nil
                if singleMessagePosition > 0 {
                    let temp = self.objectIDToMessageContentArrayMapping[self.singleMessagePositionToObjectIDMapping[singleMessagePosition - 1]!]!
                    previousDate = (temp["date"] as? Date)!
                    previousSenderName = temp["senderName"]! as! String
                    previousSenderId = temp["senderId"]! as! String
                }
                
                let currentdate = singleMessage.createdAt!
                let calendar = Calendar.current
                var showTimestamp = true
                var timestamp = ""
                let df = DateFormatter()
                df.dateFormat = "hh:mm a"
                timestamp = df.string(from: currentdate)
                if let previousDate = previousDate {
                    var components = (calendar as NSCalendar).components([.minute],
                        from: previousDate, to: currentdate, options: NSCalendar.Options.wrapComponents)
                    if components.minute! > 2 {
                        showTimestamp = true
                    }
                    else{
                        showTimestamp = false
                    }
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "EEE, dd MMM yyy hh:mm:ss +zzzz"
                    
                    components = (calendar as NSCalendar).components([.day],
                        from: previousDate, to: currentdate, options: [])
                    if components.day! > 7 {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM/dd/yyy"
                        timestamp = dateFormatter.string(from: currentdate)
                    }
                    else if components.day! >= 2 {
                        let calendar = Calendar.current
                        let components2 = (calendar as NSCalendar).components([.weekday],
                            from: currentdate)
                        timestamp = String(getWeekDay(components2.weekday!))!
                    }
                    else if components.day! >= 1 {
                        timestamp = "Yesterday"
                    }
                    else {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "hh:mm a"
                        timestamp = dateFormatter.string(from: currentdate)
                        
                    }
                }
                
                //if the message is not a notification of the current User leaving the message then add it to user's view
                if self.isNotification == false {
                    self.objectIDToMessageContentArrayMapping[(singleMessage.objectId!)]=["messageText":sendingMessageText as AnyObject,"bridgeType":self.bridgeType as AnyObject,"senderName":senderName as AnyObject, "timestamp":timestamp as AnyObject, "isNotification":false as AnyObject, "senderId":(PFUser.current()?.objectId)! as AnyObject, "previousSenderName":previousSenderName as AnyObject, "previousSenderId":previousSenderId as AnyObject, "showTimestamp":showTimestamp as AnyObject, "date":singleMessage.createdAt! as AnyObject]
                    self.singleMessagePositionToObjectIDMapping[singleMessagePosition] = (singleMessage.objectId!)
                    self.singleMessageTableView.reloadData()
                    if self.objectIDToMessageContentArrayMapping.count >= 1 {
                        self.singleMessageTableView.scrollToRow(at: IndexPath(row: self.objectIDToMessageContentArrayMapping.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: true)
                    }
                }
                
                
                //self.singleMessageTableView.setContentOffset(CGPointZero, animated:true)
                let messageQuery = PFQuery(className: "Messages")
                messageQuery.getObjectInBackground(withId: self.messageId, block: { (object, error) in
                    if error == nil {
                        if let object = object {
                            // update the no of message in a Thread - Start
                            if let noOfSingleMessages = object["no_of_single_messages"] as? Int {
                                object["no_of_single_messages"] = noOfSingleMessages + 1
                            }
                            else {
                                object["no_of_single_messages"] = 1
                            }
                            if var noOfSingleMessagesViewed = NSKeyedUnarchiver.unarchiveObject(with: object["no_of_single_messages_viewed"] as! Data)! as? [String:Int] {
                                noOfSingleMessagesViewed[PFUser.current()!.objectId!] = (object["no_of_single_messages"] as! Int)
                                object["no_of_single_messages_viewed"] = NSKeyedArchiver.archivedData(withRootObject: noOfSingleMessagesViewed)
                            }
                            object["last_single_message"] = sendingMessageText
                            object["lastSingleMessageAt"] = Date()
                            object["message_viewed"] = [(PFUser.current()?.objectId)!]
                            object.saveInBackground{
                                (success, error) -> Void in
                                if error == nil {
                                    for userId in object["ids_in_message"] as! [String] {
                                        // Skip sending the current user a notification
                                        if userId == PFUser.current()!.objectId {
                                            continue
                                        }
                                        // Skip sending a notification to a user who hasn't viewed the bridge notification yet.
                                        // But in order to mainatain sync with other users set no of meesages viewed by this user to 1
                                        if object["no_of_single_messages"] as! Int == 2 {
                                            if var noOfSingleMessagesViewed = NSKeyedUnarchiver.unarchiveObject(with: object["no_of_single_messages_viewed"] as! Data)! as? [String:Int] {
                                                if noOfSingleMessagesViewed[userId] == nil {
                                                    noOfSingleMessagesViewed[userId] = 1
                                                    object["no_of_single_messages_viewed"] = NSKeyedArchiver.archivedData(withRootObject: noOfSingleMessagesViewed)
                                                    object.saveInBackground()
                                                    continue
                                                }
                                            }
                                            
                                        }
                                        let notificationMessage = "Message from " + (PFUser.current()!["name"] as! String)
                                        print("userId that we are looking for is \(userId)")
                                        let pfCloudFunctions = PFCloudFunctions()
                                        pfCloudFunctions.pushNotification(parameters: ["userObjectId":userId,"alert":notificationMessage, "badge": "Increment", "messageType" : "SingleMessage",  "messageId": self.newMessageId])
                                    }
                                    //self.updateNoOfPushNotificationsOnBadge()
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
        }
    }
    
    func displayNavigationBar(){
        
        //setting the messagesIcon to the leftBarButtonItem
        messagesButton.setImage(UIImage(named: "Messages_Icon_Gray"), for: UIControlState())
        messagesButton.setImage(UIImage(named: "Messages_Icon_Yellow"), for: .selected)
        messagesButton.setImage(UIImage(named: "Messages_Icon_Yellow"), for: .highlighted)
        messagesButton.addTarget(self, action: #selector(messagesTapped(_:)), for: .touchUpInside)
        messagesButton.frame = CGRect(x: 0, y: 0, width: 0.085*screenWidth, height: 0.085*screenWidth)
        messagesButton.contentMode = UIViewContentMode.scaleAspectFill
        messagesButton.clipsToBounds = true
        let leftBarButton = UIBarButtonItem(customView: messagesButton)
        navItem.leftBarButtonItem = leftBarButton
        
        //setting the leave conversation button to the rightBarButtonItem
        //let leaveConversationIcon = UIImage(named: "Profile_Icon_Gray")
        leaveConversation.setImage(UIImage(named: "Leave_Conversation_Gray"), for: UIControlState())
        leaveConversation.setImage(UIImage(named: "Leave_Conversation_Yellow"), for: .highlighted)
        leaveConversation.setImage(UIImage(named: "Leave_Conversation_Yellow"), for: .selected)
        //leaveConversation.titleLabel!.font = UIFont(name: "Verdana-Bold", size: 24)!
        //leaveConversation.setImage(UIImage(named: "Profile_Icon_Yellow"), forState: .Selected)
        //leaveConversation.setImage(UIImage(named: "Profile_Icon_Yellow"), forState: .Highlighted)
        leaveConversation.addTarget(self, action: #selector(leaveConversationTapped(_:)), for: .touchUpInside)
        leaveConversation.frame = CGRect(x: 0, y: 0, width: 0.085*screenWidth, height: 0.085*screenWidth)
        let rightBarButton = UIBarButtonItem(customView: leaveConversation)
        navItem.rightBarButtonItem = rightBarButton

        
        //setting the navBar color and title
        navigationBar.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 0.11*screenHeight)
        navigationBar.setItems([navItem], animated: false)
        navigationBar.topItem?.title = "Conversation"
        navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Verdana", size: 24)!, NSForegroundColorAttributeName: necterTypeColor]
        navigationBar.barStyle = .black
        navigationBar.barTintColor = UIColor.white
        
        /*navBarTitleButton.frame.size = CGSize(width: 0.6*screenWidth, height: navigationBar.frame.height)
        navBarTitleButton.center.x = navigationBar.center.x
        navBarTitleButton.center.y = navigationBar.center.y
        navBarTitleButton.setTitle(singleMessageTitle, forState: UIControlState.Normal)
        navBarTitleButton.titleLabel?.font = UIFont(name: "Verdana", size: 24)
        navBarTitleButton.setTitleColor(necterTypeColor, forState: .Normal)
        navBarTitleButton.setTitleColor(necterYellow, forState: .Highlighted)
        navBarTitleButton.setTitleColor(necterYellow, forState: .Selected)
        navBarTitleButton.addTarget(self, action: #selector(navBarTitleButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        navigationBar.topItem?.titleView = navBarTitleButton*/
        
        self.view.addSubview(navigationBar)
        
    }
    
    func navBarTitleButtonTapped(_ sender: UIButton) {
        //navBarTitleButton.titleColor
        navBarTitleButton.isSelected = true
        performSegue(withIdentifier: "showExternalProfileFromSingleMessage", sender: self)
    }
    
    func leaveConversationTapped(_ sender: UIBarButtonItem) {
        leaveConversation.isSelected = true
        //create the alert controller
        let alert = UIAlertController(title: "Leaving the Conversation", message: "Are you sure you want to leave this conversation? You will not be able to return.", preferredStyle: UIAlertControllerStyle.alert)
        //Create the actions
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            self.leaveConversation.isSelected = false
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            //send notification that user has left the message
            self.isNotification = true
            self.sendMessageAndNotification()
            
            //take currentUser out of the current ids_in_message
            let messageQuery = PFQuery(className: "Messages")
            messageQuery.getObjectInBackground(withId: self.messageId, block: { (object, error) in
                if error != nil {
                    print(error)
                } else {
                    let CurrentIdsInMessage: NSArray = object!["ids_in_message"] as! NSArray
                    let CurrentNamesInMessage: NSArray = object!["names_in_message"] as! NSArray
                    var updatedIdsInMessage = [String]()
                    var updatedNamesInMessage = [String]()
                    for i in 0...(CurrentIdsInMessage.count - 1) {
                        if CurrentIdsInMessage[i] as? String != PFUser.current()?.objectId {
                            updatedIdsInMessage.append(CurrentIdsInMessage[i] as! String)
                            updatedNamesInMessage.append(CurrentNamesInMessage[i] as! String)
                        }
                    }
                    object!["ids_in_message"] = updatedIdsInMessage
                    object!["names_in_message"] = updatedNamesInMessage
                    object!.saveInBackground(block: { (success, error) in
                        if error != nil {
                            print(error)
                        } else if success {
                            if self.seguedFrom == "BridgeViewController" {
                                self.performSegue(withIdentifier: "showBridgeFromSingleMessage", sender: self)
                            } else {
                                self.performSegue(withIdentifier: "showMessagesTableFromSingleMessage", sender: self)
                            }
                        }
                    })
                }
            })
            
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func messagesTapped(_ sender: UIBarButtonItem) {
        messagesButton.isSelected = true
        toolbar.frame = CGRect(x: 0, y: 0.925*screenHeight, width: screenWidth, height: 0.075*screenHeight)
        performSegue(withIdentifier: "showMessagesTableFromSingleMessage", sender: self)
    }
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            if self.objectIDToMessageContentArrayMapping.count >= 1 {
                self.singleMessageTableView.scrollToRow(at: IndexPath(row: self.objectIDToMessageContentArrayMapping.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: true)
            }
            toolbar.frame.origin.y -= keyboardSize.height
            singleMessageTableView.frame.origin.y -= keyboardSize.height
        }
        
    }
    func keyboardWillHide(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            singleMessageTableView.frame.origin.y = 0.11*screenHeight
            if messageText.text.isEmpty {
                toolbar.frame = CGRect(x: 0, y: 0.925*screenHeight, width: screenWidth, height: 0.075*screenHeight)
                messageText.frame.size.height = 35.5
            } else {
                toolbar.frame.origin.y += keyboardHeight//keyboardSize.height
            }
        }
    }
    // Tapped anywhere on the main view oustside of the messageText Textfield
    func tappedOutside(){
        if messageText.isFirstResponder {
            messageText.endEditing(true)
        }
    }
    func updateMessagesViewed() {
        let messageQuery = PFQuery(className: "Messages")
        messageQuery.getObjectInBackground(withId: messageId, block: { (object, error) in
            if error == nil {
                if let object = object {
                    if var ob = object["message_viewed"] as? [String] {
                        if !ob.contains((PFUser.current()?.objectId)!) {
                            ob.append((PFUser.current()?.objectId)!)
                            object["message_viewed"] = ob
                        }
                    }
                    else {
                        object["message_viewed"] = [(PFUser.current()?.objectId)!]
                    }
                    if var noOfSingleMessagesViewed = NSKeyedUnarchiver.unarchiveObject(with: object["no_of_single_messages_viewed"] as! Data)! as? [String:Int] {
                        noOfSingleMessagesViewed[PFUser.current()!.objectId!] = (object["no_of_single_messages"] as! Int)
                        object["no_of_single_messages_viewed"] = NSKeyedArchiver.archivedData(withRootObject: noOfSingleMessagesViewed)
                    }
                    object.saveInBackground()
                }
            }
        })
    }
    func displayNoMessages() {
        let labelFrame: CGRect = CGRect(x: 0,y: 0, width: 0.85*screenWidth,height: screenHeight * 0.2)
        
        noMessagesLabel.frame = labelFrame
        noMessagesLabel.numberOfLines = 0
        noMessagesLabel.alpha = 1
        
        noMessagesLabel.text = "\"All of life is rooted in relationships.\"\n- Lee A. Harris"
        
        noMessagesLabel.font = UIFont(name: "BentonSans", size: 20)
        noMessagesLabel.textAlignment = NSTextAlignment.center
        noMessagesLabel.center.y = view.center.y
        noMessagesLabel.center.x = view.center.x
        noMessagesLabel.layer.borderWidth = 2
        noMessagesLabel.layer.borderColor = necterGray.cgColor
        noMessagesLabel.layer.cornerRadius = 15
        
        view.insertSubview(noMessagesLabel, belowSubview: toolbar)
        
    }
    
    func tableViewIsDragged (_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        let draggedTableView = gesture.view!
        let tableViewY = draggedTableView.frame.origin.y
        let tableViewHeight = draggedTableView.frame.height
        toolbar.frame.origin.y = tableViewY + tableViewHeight
    }
    // Dismiss keyboard when scrolling
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        messageText.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        singleMessageTableView.delegate = self
        singleMessageTableView.dataSource = self
        singleMessageTableView.frame = CGRect(x: 0, y: 0.11*screenHeight, width: screenWidth, height: 0.8*screenHeight)
        singleMessageTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        singleMessageTableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        view.addSubview(singleMessageTableView)
        
        displayNavigationBar()
        
        displayToolbar()
        sendButton.isEnabled = false
//        let tableViewIsDraggedGesture = UIPanGestureRecognizer(target: self, action: #selector(tableViewIsDragged(_:)))
//
//        singleMessageTableView.addGestureRecognizer(tableViewIsDraggedGesture)
        
        let outSelector : Selector = #selector(SingleMessageViewController.tappedOutside)
        let outsideTapGesture = UITapGestureRecognizer(target: self, action: outSelector)
        outsideTapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(outsideTapGesture)
        
        let messageQuery = PFQuery(className: "Messages")
        messageQuery.getObjectInBackground(withId: newMessageId, block: { (object, error) in
            if error == nil {
                if let object = object {
                    if let x = object["message_type"] as? String? {
                        if let x = x {
                            self.bridgeType = x
                        }
                        else {
                        self.bridgeType = "Friendship"
                        }
                    }
                    else {
                        self.bridgeType = "Friendship"
                    }
                    switch (self.bridgeType) {
                        case "Business":
                            self.necterTypeColor = self.businessBlue
                        case "Love":
                            self.necterTypeColor = self.loveRed
                        case "Friendship":
                            self.necterTypeColor = self.friendshipGreen
                        default:
                            self.necterTypeColor = self.friendshipGreen
                            print("necterTypeColor is set to default")
                    }
                    
                    //setting the singleMessageTitle
                    if self.singleMessageTitle == "Conversation" {
                        var stringOfNames = ""
                        if var users = object["names_in_message"] as? [String] {
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
                            self.singleMessageTitle = stringOfNames
                        }
                        DispatchQueue.main.async(execute: {
                            self.navigationBar.topItem?.title = self.singleMessageTitle
                            self.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Verdana", size: 24)!, NSForegroundColorAttributeName: self.necterTypeColor]
                        })
                    }
                    
                    
                    
                }
                //self.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Verdana", size: 24)!, NSForegroundColorAttributeName: self.necterTypeColor]
                //self.navBarTitleButton.titleLabel?.textColor = self.necterTypeColor
            }
        })
        NotificationCenter.default.removeObserver("reloadTheThread")
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadThread), name: NSNotification.Name(rawValue: "reloadTheThread"), object: nil)
        refresher.attributedTitle = NSAttributedString(string:"Pull to see older messages")
        refresher.addTarget(self, action: #selector(SingleMessageViewController.updateMessages), for: UIControlEvents.valueChanged)
        singleMessageTableView.addSubview(refresher)

        navigationBar.topItem?.title = singleMessageTitle
        
        //navBarTitleButton.setTitle(singleMessageTitle, forState: UIControlState.Normal)
        singleMessageTableView.register(SingleMessageTableCell.self, forCellReuseIdentifier: NSStringFromClass(SingleMessageTableCell))
        messageId = newMessageId
        updateMessages()
        
        
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //This prevents rare crashes which happens when you are changing your view.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Update the fact that you have viewed the message Thread when you segue
        // Segue is not the best place to put this. If you are about to close the view this should get called
        NotificationCenter.default.removeObserver(self)
        let vc = segue.destination
        let mirror = Mirror(reflecting: vc)
        if mirror.subjectType == BridgeViewController.self || mirror.subjectType == MessagesViewController.self {
            self.transitionManager.animationDirection = "Left"
        } else if mirror.subjectType == ExternalProfileViewController.self {
            let vc2 = vc as! ExternalProfileViewController
            vc2.singleMessageTitle = singleMessageTitle
            vc2.necterTypeColor = necterTypeColor
            vc2.seguedFrom = seguedFrom
            //send which button was clicked
            //send the user's objectId
            self.transitionManager.animationDirection = "Bottom"
        }
        vc.transitioningDelegate = self.transitionManager
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectIDToMessageContentArrayMapping.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var addSenderName = false
        let messageContent = objectIDToMessageContentArrayMapping[singleMessagePositionToObjectIDMapping[(indexPath as NSIndexPath).row]!]!
        
        let senderNameLabel = UITextView(frame: CGRect.zero)
        let messageTextLabel = UITextView(frame: CGRect.zero)
        let timestampLabel = UILabel(frame: CGRect.zero)
        let notificationLabel = UILabel(frame: CGRect.zero)
        messageTextLabel.font = UIFont(name: "Verdana", size: 16)
        senderNameLabel.font = UIFont(name: "Verdana", size: 12)
        timestampLabel.font = UIFont(name: "BentonSans", size: 10)
        notificationLabel.font = UIFont(name: "BentonSans", size: 10)
        
        if ((messageContent["senderId"] as? String)! != (PFUser.current()?.objectId)!)  {
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
            timestampLabel.frame = CGRect(x: UIScreen.main.bounds.width*0.35, y: 0, width: UIScreen.main.bounds.width*0.30, height: 27)
            timestampLabel.layer.borderWidth = 1
            timestampLabel.layer.cornerRadius = 5
            timestampLabel.layer.borderColor = senderNameLabel.backgroundColor?.cgColor
        }
        if addSenderName {
            senderNameLabel.text = (messageContent["senderName"] as? String)!
            var width = (UIScreen.main.bounds.width/3 )
            width += CGFloat(5)
            senderNameLabel.frame = CGRect(x: 5, y: 0, width: width, height: 15)
            let fixedWidth = senderNameLabel.frame.size.width
            let newSize = senderNameLabel.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            var newFrame = senderNameLabel.frame
            newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height + 1)
            senderNameLabel.frame = newFrame
        }
        
        var addNotification = false
        if (messageContent["isNotification"] as? Bool)! {
            addNotification = true
        }
        else {
            addNotification = false
        }
        
        var messageHeight = CGFloat()
        if addNotification {
            notificationLabel.text = (messageContent["messageText"] as? String)!
            notificationLabel.frame = CGRect(x: UIScreen.main.bounds.width*0.35, y: 0, width: UIScreen.main.bounds.width*0.30, height: 27)
            messageHeight = notificationLabel.frame.height
        }
        else {
            messageTextLabel.text = (messageContent["messageText"] as? String)!
            messageTextLabel.frame = CGRect(x: UIScreen.main.bounds.width/3.0, y: 0, width: UIScreen.main.bounds.width/1.5, height: 25)
            let fixedWidth = messageTextLabel.frame.size.width
            let newSize = messageTextLabel.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            var newFrame = messageTextLabel.frame
            newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
            messageTextLabel.frame = newFrame
            messageHeight = messageTextLabel.frame.height
        }
        return messageHeight + senderNameLabel.frame.height + timestampLabel.frame.height + CGFloat(2)
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(SingleMessageTableCell), forIndexPath: indexPath) as! SingleMessageTableCell
        let cell = SingleMessageTableCell()
        let messageContent = objectIDToMessageContentArrayMapping[singleMessagePositionToObjectIDMapping[(indexPath as NSIndexPath).row]!]!
        let singleMessageContent = SingleMessageContent(messageContent: messageContent)
        //print("senderName - \(singleMessageContent.senderName!) previousSenderName - \(singleMessageContent.previousSenderName!) messageText -  \(singleMessageContent.messageText!) ")
        //print("")
        //print("messageContentArray[indexPath.row] - \(messageContentArray[indexPath.row])")
        cell.singleMessageContent = singleMessageContent
        //print("cell \(indexPath.row) \(cell.frame.height)")
        return cell
        
    }

}
