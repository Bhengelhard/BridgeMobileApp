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
    fileprivate var displayName: String!
    
    var didSetupConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // these must be non-nil
        self.senderId = ""
        self.senderDisplayName = ""
        
        // Bubbles with tails
        //incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: .yellow)
        outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: .lightGray)
        
        automaticallyScrollsToMostRecentMessage = true
        
        // remove attachment button
        inputToolbar.contentView.leftBarButtonItem = nil
        
        if let collectionView = collectionView {
            collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault, height:kJSQMessagesCollectionViewAvatarSizeDefault)
            collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault, height:kJSQMessagesCollectionViewAvatarSizeDefault)
            
            // This is a beta feature that mostly works but to make things more stable it is diabled.
            collectionView.collectionViewLayout.springinessEnabled = false
            
            threadBackend.reloadSingleMessages(collectionView: collectionView, messageID: messageID)
            threadBackend.setSenderInfo(collectionView: collectionView, messageID: messageID)
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
            
            if message.senderId == threadBackend.senderID { // outgoing message
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
        return threadBackend.jsqMessages[indexPath.item].senderId == threadBackend.senderID ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, avatarImageDataForItemAt indexPath: IndexPath) -> JSQMessageAvatarImageDataSource? {
        //let message = messages[indexPath.item]
        return nil
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
