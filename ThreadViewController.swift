//
//  ThreadViewController.swift
//
//  Created by Doug Dolitsky on 3/10/17.
//  Copyright © 2017 MacMeDan. All rights reserved.
//
//  Some code taken from Dan Leonard from 5/11/16.
//  Copyright © 2016 MacMeDan. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ThreadViewController: UIViewController {
    var messagesVC = NecterJSQMessagesViewController()
    let layout = ThreadLayout()
    let threadBackend = ThreadBackend()
    
    var messagesBackend: MessagesBackend?
    var messagesTableView: UITableView?
    var newMatchesTableViewCell: NewMatchesTableViewCell?
    
    var didSetupConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background color
        view.backgroundColor = .white
        
        layout.navBar.leftButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        layout.navBar.rightButton.addTarget(self, action: #selector(moreButtonTapped(_:)), for: .touchUpInside)
        messagesVC.layout = layout
    }
    
    override func loadView() {
        view = UIView()

        view.setNeedsUpdateConstraints()
        
    }
    
    
    override func updateViewConstraints() {
        didSetupConstraints = layout.initialize(view: view, messagesVC: messagesVC, didSetupConstraints: didSetupConstraints)
        
        
        super.updateViewConstraints()
    }
    
    func setMessageID(messageID: String?) {
        messagesVC.messageID = messageID
        
        // set nav bar image
        let imageView = self.layout.navBar.titleImageView
        
        threadBackend.getOtherUserInMessagePicture(messageID: messageID) { (image) in
            imageView.image = image
            imageView.layer.cornerRadius = imageView.frame.height/2
            imageView.clipsToBounds = true
        }
        
        // add target to bring to external profile
        let showProfileGR = UITapGestureRecognizer(target: self, action: #selector(self.showOtherUserProfile(_:)))
        imageView.addGestureRecognizer(showProfileGR)
        imageView.isUserInteractionEnabled = true
        
        // save user has seen last single message
        threadBackend.updateHasSeenLastSingleMessage(messageID: messageID)
    }
    

    // MARK: Targets
    func backButtonTapped(_ sender: UIButton) {
        // reload messages table
        if let messagesBackend = messagesBackend, let messagesTableView = messagesTableView {
            messagesBackend.reloadMessagesTable(tableView: messagesTableView)
        }
        
        // reload new matches view
        if let messagesBackend = messagesBackend, let newMatchesTableViewCell = newMatchesTableViewCell {
            messagesBackend.loadNewMatches(newMatchesTableViewCell: newMatchesTableViewCell)
        }
        
        dismiss(animated: false, completion: nil)
    }
    
    func moreButtonTapped(_ sender: UIButton) {
        
        let moreOptions = MoreOptions()
        moreOptions.displayMoreAlertController(vc: self)

    }
    
//    func areTheyFriends() -> Bool {
//        User.getCurrent { (user) in
//            if let friendlist = user.friendList {
//                Message.get(withID: self.messagesVC.messageID!, withBlock: { (message) in
//                    message.getNonCurrentUser(withBlock: { (otherUser) in
//                        if let otherUserID = otherUser.id {
//                            if friendlist.contains(otherUserID) {
//                                print("Users are already friends")
//                                let followAction = UIAlertAction(title: "Unfollow", style: .destructive) { (alert) in
//                                    print("follow")
//                                }
//                                addMoreMenu.addAction(followAction)
//                                
//                            } else {
//                                let followAction = UIAlertAction(title: "Follow", style: .default) { (alert) in
//                                    print("follow")
//                                }
//                                addMoreMenu.addAction(followAction)
//                            }
//                        }
//                    })
//                })
//            }
//        }
//    }
    
    func showOtherUserProfile(_ gesture: UIGestureRecognizer) {
        if let messageID = messagesVC.messageID {
            Message.get(withID: messageID) { (message) in
                message.getNonCurrentUser { (user) in
                    if let userID = user.id {
                        let externalProfileVC = ExternalProfileViewController()
                        externalProfileVC.setUserID(userID: userID)
                        self.present(externalProfileVC, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

class NecterJSQMessagesViewController: JSQMessagesViewController {
    var threadBackend = ThreadBackend()
    var messageID: String?
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    var layout: ThreadLayout?

    var otherId = String()
    var otherDisplayName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // these must be non-nil
        senderId = ""
        senderDisplayName = ""
        
        // Bubbles with tails
        incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: Constants.Colors.singleMessages.incoming)
        outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: Constants.Colors.singleMessages.outgoing)
        
        
        // remove attachment button
        inputToolbar.contentView.leftBarButtonItem = nil
        
        if let collectionView = collectionView {
            
            // This is a beta feature that mostly works but to make things more stable it is diabled.
            collectionView.collectionViewLayout.springinessEnabled = false
            
            // reload collection view
            threadBackend.reloadSingleMessages(collectionView: collectionView, messageID: messageID) {
                self.scrollToBottom(animated: true)
                if self.threadBackend.jsqMessages.count > 0 {
                    if let layout = self.layout {
                        layout.noMessagesView.alpha = 0
                    }
                }
            }
            
            // set id and name of current user
            threadBackend.setSenderInfo { (id, name) in
                if let id = id {
                    self.senderId = id
                }
                if let name = name {
                    self.senderDisplayName = name
                }
                
                collectionView.reloadData()
            }
            
            threadBackend.setOtherInfo(messageID: messageID) { (id, name) in
                if let id = id {
                    self.otherId = id
                }
                if let name = name {
                    self.otherDisplayName = name
                }
                
                collectionView.reloadData()
            }
            //collectionView.backgroundColor = DisplayUtility.gradientColor(size: collectionView.frame.size)
        }
    }
    
    
    // MARK: JSQMessagesViewController method overrides
    
    override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
        
        print("pressed send")
        
        if let layout = layout {
            layout.noMessagesView.alpha = 0
        }
        
        if let jsqMessage = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text) {
            threadBackend.jsqMessages.append(jsqMessage)
            
            // save single message
            threadBackend.jsqMessageToSingleMessage(jsqMessage: jsqMessage, messageID: messageID) { (singleMessage) in
                singleMessage.save()
                
            }
            print("jsqMessage")
            
            // update message's snapshot and info about user has sent and user has seen last single message
            threadBackend.updateMessageAfterSingleMessageSent(messageID: messageID, snapshot: jsqMessage.text, withBothHavePostedForFirstTimeBlock: { 
                
                
            })
            
            if let id = messageID {
                Message.get(withID: id, withBlock: { (message) in
                    // Getting information for push notification
                    var otherUserID: String?
                    if senderId == message.user1ID {
                        otherUserID = message.user2ID
                    } else {
                        otherUserID = message.user1ID
                    }
                    
                    // Push notification to other user
                    let pfCloudFunctions = PFCloudFunctions()
                    pfCloudFunctions.pushNotification(parameters: ["userObjectId": otherUserID,"alert":"\(senderDisplayName) has sent you a message: \(text)", "badge": "Increment",  "messageType" : "SingleMessage",  "messageId": self.messageID])
                    
                    print("sent the push notification")
                    
                })
            }
            
            
            
            
            
                        // BOTH HAVE POSTED FOR FIRST TIME
            
            // Send Push notification to connecter to let them know the conversation has begun
            
            // Add user's to eachother's friendlists
            
            // Show notification that user's are now friends and can introduce eachother if they want
            
            self.finishSendingMessage(animated: true)
        }
    }
    
    // MARK: JSQMessages CollectionView DataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return threadBackend.jsqMessages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
        if let cell = cell as? JSQMessagesCollectionViewCell {
            let message = threadBackend.jsqMessages[indexPath.item]
            
            // set message text color
            if message.senderId == senderId { // outgoing message
                cell.textView.textColor = .white
            } else { // incoming message
                cell.textView.textColor = .black
            }
            
            if message.senderId == "" {
                cell.cellBottomLabel.textColor = .black
                cell.cellBottomLabel.textAlignment = .center
                cell.messageBubbleImageView.image = nil
                cell.textView.text = ""
            }
            
            //cell.cellBottomLabel.textAlignment = .center
        }
        return cell;
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
        return threadBackend.jsqMessages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource {
        return threadBackend.jsqMessages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, avatarImageDataForItemAt indexPath: IndexPath) -> JSQMessageAvatarImageDataSource? {
        let message = threadBackend.jsqMessages[indexPath.item]
        
        if let image = threadBackend.avatarImagesDict[message.senderId] {
            return NecterJSQMessageAvatar(image: image)
        }
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        let message = threadBackend.jsqMessages[indexPath.item]
        return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        
        // if sender is not in thread, put in label
        let message = threadBackend.jsqMessages[indexPath.item]
        if message.senderId != senderId && message.senderId != otherId && message.senderId != "" {
            if let senderDisplayName = message.senderDisplayName {
                let firstName = DisplayUtility.firstName(name: senderDisplayName)
                return NSAttributedString(string: "*\(firstName) cannot view this thread.")
            }
        } else if message.senderId == "" {
            return NSAttributedString(string: message.text)
        }
        return NSAttributedString()
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        let message = threadBackend.jsqMessages[indexPath.item]
        
        // Displaying names above messages
        return NSAttributedString(string: message.senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAt indexPath: IndexPath) -> CGFloat {
        let currentMessage = threadBackend.jsqMessages[indexPath.item]
        
        if currentMessage.senderId == "" {
            return 0.0
        }
        
        // don't display timestamp if less than 3 minutes have elapsed since previous message
        if indexPath.item > 0 {
            let previousMessage = threadBackend.jsqMessages[indexPath.item - 1]
            
            if currentMessage.date.timeIntervalSince(previousMessage.date) < 180 {
                return 0.0
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForMessageBubbleTopLabelAt indexPath: IndexPath) -> CGFloat {
        
        let currentMessage = threadBackend.jsqMessages[indexPath.item]
        
        if currentMessage.senderId == "" {
            return 0.0
        }
        
        if indexPath.item > 0 {
            let previousMessage = threadBackend.jsqMessages[indexPath.item - 1]
            if previousMessage.senderId == currentMessage.senderId {
                return 0.0
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellBottomLabelAt indexPath: IndexPath) -> CGFloat {
        let message = threadBackend.jsqMessages[indexPath.item]
        if message.senderId != senderId && message.senderId != otherId && message.senderId != "" {
            if message.senderDisplayName != nil {
                return kJSQMessagesCollectionViewCellLabelHeightDefault
            }
        } else if message.senderId == "" {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        return 0.0
    }
}

class NecterJSQMessageAvatar: NSObject, JSQMessageAvatarImageDataSource {
    
    let image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
    
    /**
     *  @return The avatar image for a regular display state.
     *
     *  @discussion You may return `nil` from this method while the image is being downloaded.
     */
    func avatarImage() -> UIImage! {
        //return image
        return JSQMessagesAvatarImageFactory.circularAvatarImage(image, withDiameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
    }
    
    
    /**
     *  @return The avatar image for a highlighted display state.
     *
     *  @discussion You may return `nil` from this method if this does not apply.
     */
    func avatarHighlightedImage() -> UIImage! {
        return nil
    }
    
    
    /**
     *  @return A placeholder avatar image to be displayed if avatarImage is not yet available, or `nil`.
     *  For example, if avatarImage needs to be downloaded, this placeholder image
     *  will be used until avatarImage is not `nil`.
     *
     *  @discussion If you do not need support for a placeholder image, that is, your images
     *  are stored locally on the device, then you may simply return the same value as avatarImage here.
     *
     *  @warning You must not return `nil` from this method.
     */
    func avatarPlaceholderImage() -> UIImage! {
        return UIImage()
    }
    
}