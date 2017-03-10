//
//  ChatViewController.swift
//  SwiftExample
//
//  Created by Dan Leonard on 5/11/16.
//  Copyright © 2016 MacMeDan. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ThreadViewController: JSQMessagesViewController {
    var threadBackend = ThreadBackend()
    let layout = ThreadLayout()
    var messageID: String?
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    var incomingAvatar: ThreadAvatar!
    var outgoingAvatar: ThreadAvatar!
    fileprivate var displayName: String!
    
    var didSetupConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // these must be non-nil
        self.senderId = ""
        self.senderDisplayName = ""
        
        // Bubbles with tails
        //incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: Constants.Colors.singleMessages.incoming)
        outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: Constants.Colors.singleMessages.outgoing)
        
        automaticallyScrollsToMostRecentMessage = true
        
        // remove attachment button
        inputToolbar.contentView.leftBarButtonItem = nil
        
        if let collectionView = collectionView {
            collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault, height:kJSQMessagesCollectionViewAvatarSizeDefault)
            collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault, height:kJSQMessagesCollectionViewAvatarSizeDefault)
            
            // This is a beta feature that mostly works but to make things more stable it is diabled.
            collectionView.collectionViewLayout.springinessEnabled = false
            
            threadBackend.reloadSingleMessages(collectionView: collectionView, messageID: messageID)
            threadBackend.setSenderInfo(collectionView: collectionView) { (id, name) in
                if let id = id {
                    self.senderId = id
                }
                if let name = name {
                    self.senderDisplayName = name
                }
            }
            
            incomingAvatar = ThreadAvatar(messageID: messageID, currentUser: false, collectionView: collectionView)
            outgoingAvatar = ThreadAvatar(messageID: messageID, currentUser: true, collectionView: collectionView)
        }
        
        layout.navBar.leftButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.white
        
        view.setNeedsUpdateConstraints()
    }
    

    override func updateViewConstraints() {
        didSetupConstraints = layout.initialize(view: view, didSetupConstraints: didSetupConstraints)
        
        if let collectionView = collectionView {
            layout.layoutCollectionViewAndInputToolbar(view: view, collectionView: collectionView, inputToolbar: inputToolbar)
        }
        
        super.updateViewConstraints()
    }
    
    // MARK: JSQMessagesViewController method overrides
    override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
        
        if let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text) {
            threadBackend.jsqMessages.append(message)
            
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
            
            // make avatar circular
            cell.avatarImageView.clipsToBounds = true
            cell.avatarImageView.layer.cornerRadius = cell.avatarImageView.frame.height / 2
            
//            if threadBackend.jsqMessages[indexPath.item].senderId != threadBackend.senderID {
//                for constraint in cell.messageBubbleImageView.constraints {
//                    if constraint.firstItem as? NSObject == cell.avatarImageView || constraint.secondItem as? NSObject == cell.avatarImageView {
//                        cell.messageBubbleImageView.removeConstraint(constraint)
//                    }
//                }
//                cell.avatarImageView.autoPinEdge(.left, to: .right, of: cell.messageBubbleImageView, withOffset: 10)
//            }
//            
//            cell.layoutIfNeeded()
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
        //let message = messages[indexPath.item]
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
    
    // MARK: Setters
    
    func setMessageID(messageID: String?) {
        self.messageID = messageID
    }
    
    // MARK: Targets
    
    func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
}

class ThreadAvatar: NSObject, JSQMessageAvatarImageDataSource {
    
    let threadBackend = ThreadBackend()
    var image = UIImage()
    let collectionView: UICollectionView
    
    init(messageID: String?, currentUser: Bool, collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        
        if currentUser {
            threadBackend.getCurrentUserPicture(collectionView: collectionView) { (image) in
                self.image = image
            }
        } else {
            threadBackend.getOtherUserInMessagePicture(collectionView: collectionView, messageID: messageID) { (image) in
                self.image = image
            }
        }
    }
    
    /**
     *  @return The avatar image for a regular display state.
     *
     *  @discussion You may return `nil` from this method while the image is being downloaded.
     */
    func avatarImage() -> UIImage! {
        return image
    }
    
    
    /**
     *  @return The avatar image for a highlighted display state.
     *
     *  @discussion You may return `nil` from this method if this does not apply.
     */
    func avatarHighlightedImage() -> UIImage! {
        return UIImage()
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
