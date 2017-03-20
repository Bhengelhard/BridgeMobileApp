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
    
    var didSetupConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background color
        view.backgroundColor = .white
        
        layout.navBar.leftButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        layout.navBar.rightButton.addTarget(self, action: #selector(moreButtonTapped(_:)), for: .touchUpInside)
    }
    
    override func loadView() {
        view = UIView()

        view.setNeedsUpdateConstraints()
    }
    
    
    override func updateViewConstraints() {
        didSetupConstraints = layout.initialize(view: view, messagesView: messagesVC.view, didSetupConstraints: didSetupConstraints)
        
        
        super.updateViewConstraints()
    }
    
    func setMessageID(messageID: String?) {
        messagesVC.messageID = messageID
        
        threadBackend.getOtherUserInMessagePicture(messageID: messageID) { (image) in
            let imageView = self.layout.navBar.titleImageView
            imageView.image = image
        }
    }
    
    // MARK: - Targets
    func backButtonTapped(_ sender: UIButton) {
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
    
}

class NecterJSQMessagesViewController: JSQMessagesViewController {
    var threadBackend = ThreadBackend()
    var messageID: String?
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    var incomingAvatar: NecterJSQMessageAvatar!
    var outgoingAvatar: NecterJSQMessageAvatar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // these must be non-nil
        senderId = ""
        senderDisplayName = ""
        
        // Bubbles with tails
        incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: Constants.Colors.singleMessages.incoming)
        outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: Constants.Colors.singleMessages.outgoing)
        
        automaticallyScrollsToMostRecentMessage = true
        
        // remove attachment button
        inputToolbar.contentView.leftBarButtonItem = nil
        
        if let collectionView = collectionView {
            
            // This is a beta feature that mostly works but to make things more stable it is diabled.
            collectionView.collectionViewLayout.springinessEnabled = false
            
            // reload collection view
            threadBackend.reloadSingleMessages(collectionView: collectionView, messageID: messageID)
            
            // set id and name of current user
            threadBackend.setSenderInfo(collectionView: collectionView) { (id, name) in
                if let id = id {
                    self.senderId = id
                }
                if let name = name {
                    self.senderDisplayName = name
                }
            }
            
            //collectionView.backgroundColor = DisplayUtility.gradientColor(size: collectionView.frame.size)
            
            incomingAvatar = NecterJSQMessageAvatar(messageID: messageID, currentUser: false, collectionView: collectionView)
            outgoingAvatar = NecterJSQMessageAvatar(messageID: messageID, currentUser: true, collectionView: collectionView)
        }
    }
    
    
    // MARK: JSQMessagesViewController method overrides
    
    override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
        
        if let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text) {
            threadBackend.jsqMessages.append(message)
            
            // save single message
            threadBackend.jsqMessageToSingleMessage(jsqMessage: message, messageID: messageID) { (singleMessage) in
                singleMessage.save()
            }
            
            // save single message text as message snapshot
            threadBackend.updateMessageSnapshot(messageID: messageID, snapshot: message.text)
            
            // FIXME: Add push notification to other user
            
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
        return threadBackend.jsqMessages[indexPath.item].senderId == senderId ? outgoingAvatar : incomingAvatar
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        let message = threadBackend.jsqMessages[indexPath.item]
        return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        let message = threadBackend.jsqMessages[indexPath.item]
        
        // Displaying names above messages
        return NSAttributedString(string: message.senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAt indexPath: IndexPath) -> CGFloat {
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForMessageBubbleTopLabelAt indexPath: IndexPath) -> CGFloat {
        
        let currentMessage = threadBackend.jsqMessages[indexPath.item]
        
        if indexPath.item - 1 > 0 {
            let previousMessage = threadBackend.jsqMessages[indexPath.item - 1]
            if previousMessage.senderId == currentMessage.senderId {
                return 0.0
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
}

class NecterJSQMessageAvatar: NSObject, JSQMessageAvatarImageDataSource {
    
    let threadBackend = ThreadBackend()
    var image = UIImage()
    let collectionView: UICollectionView
    
    init(messageID: String?, currentUser: Bool, collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        
        if currentUser {
            threadBackend.getCurrentUserPicture { (image) in
                self.image = image
                self.collectionView.reloadData()
            }
        } else {
            threadBackend.getOtherUserInMessagePicture(messageID: messageID) { (image) in
                self.image = image
                self.collectionView.reloadData()
            }
        }
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
