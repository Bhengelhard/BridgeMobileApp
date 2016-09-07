//
//  SingleMessageTableCell.swift
//  MyBridgeApp
//
//  Created by Sagar Sinha on 7/19/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
class SingleMessageTableCell: UITableViewCell {
    //let padding: CGFloat = 5
    var background: UIView!
    var senderNameLabel: UITextView!
    var messageTextLabel: UITextView!
    var timestampLabel: UILabel!
    var notificationLabel: UILabel!
    var senderId:String = ""
    var addSenderName = false
    var addTimestamp = false
    var isNotification = false
    let necterGray = UIColor(red: 80.0/255.0, green: 81.0/255.0, blue: 79.0/255.0, alpha: 1.0)
    var singleMessageContent: SingleMessageContent? {
        didSet {
            if let s = singleMessageContent {
                messageTextLabel.backgroundColor = s.backgroundColor
                timestampLabel.text = s.timestamp
                senderNameLabel.text = s.senderName
                messageTextLabel.text = s.messageText
                senderId = s.senderId!
                notificationLabel.text = s.messageText
                isNotification = s.isNotification
                if (senderId != PFUser.currentUser()?.objectId) && (singleMessageContent?.senderId != singleMessageContent?.previousSenderId )  {
                    addSenderName = true
                    contentView.addSubview(senderNameLabel)
                }
                if let t = s.showTimestamp{
                    if t == true{
                        addTimestamp = true
                        contentView.addSubview(timestampLabel)
                    }
                }
                if isNotification {
                    print("n was true")
                    contentView.addSubview(notificationLabel)
                }
                else {
                    contentView.addSubview(messageTextLabel)
                }
                setNeedsLayout()
            }
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clearColor()
        selectionStyle = .None
        background = UIView(frame: CGRectZero)
        background.alpha = 0.6
        //contentView.addSubview(background)
        
        
        messageTextLabel = UITextView(frame: CGRectZero)
        messageTextLabel.textAlignment = .Left
        messageTextLabel.textColor = necterGray
        messageTextLabel.font = UIFont(name: "Verdana", size: 16)
        messageTextLabel.userInteractionEnabled = false
        messageTextLabel.backgroundColor = UIColor.lightGrayColor()
        
        /*print("isNotification - from tableCell \(isNotification)" )
        if isNotification == false {
            print("contentView.addSubview(messageTextLabel)")
            contentView.addSubview(messageTextLabel)
        }*/
        
        senderNameLabel = UITextView(frame: CGRectZero)
        senderNameLabel.textAlignment = .Left
        senderNameLabel.textColor = necterGray
        senderNameLabel.font = UIFont(name: "Verdana", size: 12)
        senderNameLabel.userInteractionEnabled = false
        
        timestampLabel = UILabel(frame: CGRectZero)
        timestampLabel.textAlignment = .Center
        timestampLabel.textColor = UIColor.lightGrayColor()
        timestampLabel.font = UIFont(name: "BentonSans", size: 12)
        
        notificationLabel = UILabel(frame: CGRectZero)
        notificationLabel.textAlignment = .Center
        notificationLabel.textColor = UIColor.lightGrayColor()
        notificationLabel.font = UIFont(name: "BentonSans", size: 12)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var y = CGFloat(0)
        let screenWidth = UIScreen.mainScreen().bounds.width
        if addTimestamp == true {
            timestampLabel.frame = CGRectMake(UIScreen.mainScreen().bounds.width*0.35, y, UIScreen.mainScreen().bounds.width*0.30, 25)
            //timestampLabel.layer.borderWidth = 1
            //timestampLabel.layer.cornerRadius = 10
            //timestampLabel.layer.borderColor = senderNameLabel.backgroundColor?.CGColor
//            addTimestamp = false
            y += timestampLabel.frame.height + 2

        }
        if isNotification == true {
            notificationLabel.frame = CGRectMake(UIScreen.mainScreen().bounds.width*0.1, y, UIScreen.mainScreen().bounds.width*0.8, 25)
            y += notificationLabel.frame.height + 2
        }
        
        if addSenderName {
            var width = (UIScreen.mainScreen().bounds.width/3 )
            width += CGFloat(5)
            senderNameLabel.frame = CGRectMake(0.05*screenWidth, y, width, 15)
            let fixedWidth = senderNameLabel.frame.size.width
            let newSize = senderNameLabel.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
            var newFrame = senderNameLabel.frame
            newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
            senderNameLabel.frame = newFrame
            senderNameLabel.layer.borderWidth = 1
            senderNameLabel.layer.cornerRadius = 5
            senderNameLabel.layer.borderColor = senderNameLabel.backgroundColor?.CGColor
            y += newFrame.height + 2
//            addSenderName = false
        }
        if senderId == PFUser.currentUser()?.objectId {
        messageTextLabel.frame = CGRectMake(UIScreen.mainScreen().bounds.width/3.0, y, UIScreen.mainScreen().bounds.width/1.5, 25)
        }
        else {
            var width = (UIScreen.mainScreen().bounds.width/1.5)
            width += CGFloat(5)
            messageTextLabel.frame = CGRectMake(5, y, width, 25)
        }
        
        
        let fixedWidth = messageTextLabel.frame.size.width
        var newSize = messageTextLabel.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
//        var newFrame = messageTextLabel.frame
//        //max(newSize.width, fixedWidth)
//        newFrame.size = CGSize(width: newSize.width, height: newSize.height)
        if newSize.width < 33 {
            newSize.width = 33
            messageTextLabel.textContainer.maximumNumberOfLines = 1
        }
        var x = 0.05*screenWidth
        if senderId == PFUser.currentUser()?.objectId {
            x = 0.95*screenWidth - newSize.width
        }
        let newFrame = CGRectMake(x, y, newSize.width, newSize.height)
        messageTextLabel.frame = newFrame
        messageTextLabel.layer.borderWidth = 1
        if messageTextLabel.text.characters.count < 3 {
            messageTextLabel.layer.cornerRadius = messageTextLabel.frame.width/2.0
             messageTextLabel.textAlignment = NSTextAlignment.Center
        } else {
            messageTextLabel.layer.cornerRadius = 15
        }
        messageTextLabel.layer.borderColor = messageTextLabel.backgroundColor?.CGColor
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
