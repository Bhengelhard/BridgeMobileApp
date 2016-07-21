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
    let padding: CGFloat = 5
    var background: UIView!
    var senderNameLabel: UITextView!
    var messageTextLabel: UITextView!
    var timestampLabel: UILabel!
    var senderId:String = ""
    var addSenderName = false
    var addTimestamp = false
    var singleMessageContent: SingleMessageContent? {
        didSet {
            if let s = singleMessageContent {
                messageTextLabel.backgroundColor = s.backgroundColor
                timestampLabel.text = s.timestamp
                senderNameLabel.text = s.senderName
                messageTextLabel.text = s.messageText
                senderId = s.senderId!
                if (senderId != PFUser.currentUser()?.objectId) && (singleMessageContent?.senderId != singleMessageContent?.previousSenderId )  {
                    print("")
                    print ("senderId - \(senderId), PFUser.currentUser()?.objectId - \(PFUser.currentUser()?.objectId), singleMessageContent?.senderId- \(singleMessageContent?.senderId), singleMessageContent?.previousSenderId - \(singleMessageContent?.previousSenderId)   ")
                    
                    addSenderName = true
                    contentView.addSubview(senderNameLabel)
                }
                if let t = s.showTimestamp{
                    if t == true{
                        //print("timeStamp after \(s.messageText)")
                        addTimestamp = true
                        contentView.addSubview(timestampLabel)
                        
                    }
                    
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
        messageTextLabel.textColor = UIColor.blackColor()
        messageTextLabel.userInteractionEnabled = false
        contentView.addSubview(messageTextLabel)
        
        senderNameLabel = UITextView(frame: CGRectZero)
        senderNameLabel.textAlignment = .Left
        senderNameLabel.textColor = UIColor.whiteColor()
        senderNameLabel.userInteractionEnabled = false
        senderNameLabel.backgroundColor = UIColor.lightGrayColor()
        
        timestampLabel = UILabel(frame: CGRectZero)
        timestampLabel.textAlignment = .Center
        timestampLabel.textColor = UIColor.lightGrayColor()
        timestampLabel.font = timestampLabel.font.fontWithSize(10)

        //contentView.addSubview(timestampLabel)
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
        if addSenderName {
            var width = (UIScreen.mainScreen().bounds.width/3 )
            width += CGFloat(5)
            senderNameLabel.frame = CGRectMake(5, 0, width, 15)
            let fixedWidth = senderNameLabel.frame.size.width
            let newSize = senderNameLabel.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
            var newFrame = senderNameLabel.frame
            newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
            senderNameLabel.frame = newFrame
            senderNameLabel.layer.borderWidth = 1
            senderNameLabel.layer.cornerRadius = 5
            senderNameLabel.layer.borderColor = senderNameLabel.backgroundColor?.CGColor
            y = newFrame.height + 1
            addSenderName = false
        }
        if senderId == PFUser.currentUser()?.objectId {
        messageTextLabel.frame = CGRectMake(UIScreen.mainScreen().bounds.width/2, y, UIScreen.mainScreen().bounds.width/2, 25)
        }
        else {
            var width = (UIScreen.mainScreen().bounds.width/2 )
            width += CGFloat(5)
            messageTextLabel.frame = CGRectMake(5, y, width, 25)
        }
        let fixedWidth = messageTextLabel.frame.size.width
        let newSize = messageTextLabel.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = messageTextLabel.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        messageTextLabel.frame = newFrame
        messageTextLabel.layer.borderWidth = 1
        messageTextLabel.layer.cornerRadius = 5
        messageTextLabel.layer.borderColor = messageTextLabel.backgroundColor?.CGColor
        y += newFrame.height + 2
        if addTimestamp == true {
            print("timeStampLabel for  \(messageTextLabel.text) is \(timestampLabel.text)")
            timestampLabel.frame = CGRectMake(UIScreen.mainScreen().bounds.width*0.35, y, UIScreen.mainScreen().bounds.width*0.30, 25)
            timestampLabel.layer.borderWidth = 1
            timestampLabel.layer.cornerRadius = 10
            timestampLabel.layer.borderColor = senderNameLabel.backgroundColor?.CGColor
            addTimestamp = false
        }

       // print("Cell : \(newFrame.height)")
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
