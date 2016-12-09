//
//  SingleMessageTableCell.swift
//  MyBridgeApp
//
//  Created by Sagar Sinha on 7/19/16.
//  Copyright © 2016 BHE Ventures LLC. All rights reserved.
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
                if (senderId != PFUser.current()?.objectId) && (singleMessageContent?.senderId != singleMessageContent?.previousSenderId )  {
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
        backgroundColor = UIColor(red: 234/255, green: 237/255, blue: 239/255, alpha: 1.0)//UIColor.clear
        selectionStyle = .none
        background = UIView(frame: CGRect.zero)
        background.alpha = 0.6
        //contentView.addSubview(background)
        
        
        messageTextLabel = UITextView(frame: CGRect.zero)
        messageTextLabel.textAlignment = .left
        messageTextLabel.textColor = necterGray
        messageTextLabel.font = UIFont(name: "Verdana", size: 16)
        messageTextLabel.isUserInteractionEnabled = false
        messageTextLabel.backgroundColor = UIColor.lightGray
        
        /*print("isNotification - from tableCell \(isNotification)" )
        if isNotification == false {
            print("contentView.addSubview(messageTextLabel)")
            contentView.addSubview(messageTextLabel)
        }*/
        
        senderNameLabel = UITextView(frame: CGRect.zero)
        senderNameLabel.textAlignment = .left
        senderNameLabel.textColor = necterGray
        senderNameLabel.font = UIFont(name: "Verdana", size: 12)
        senderNameLabel.isUserInteractionEnabled = false
        senderNameLabel.backgroundColor = UIColor.clear
        
        timestampLabel = UILabel(frame: CGRect.zero)
        timestampLabel.textAlignment = .center
        timestampLabel.textColor = UIColor.lightGray
        timestampLabel.font = UIFont(name: "BentonSans", size: 12)
        
        notificationLabel = UILabel(frame: CGRect.zero)
        notificationLabel.textAlignment = .center
        notificationLabel.textColor = UIColor.lightGray
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
        let screenWidth = UIScreen.main.bounds.width
        if addTimestamp == true {
            timestampLabel.frame = CGRect(x: UIScreen.main.bounds.width*0.35, y: y, width: UIScreen.main.bounds.width*0.30, height: 25)
            //timestampLabel.layer.borderWidth = 1
            //timestampLabel.layer.cornerRadius = 10
            //timestampLabel.layer.borderColor = senderNameLabel.backgroundColor?.CGColor
//            addTimestamp = false
            y += timestampLabel.frame.height + 2

        }
        if isNotification == true {
            notificationLabel.frame = CGRect(x: UIScreen.main.bounds.width*0.1, y: y, width: UIScreen.main.bounds.width*0.8, height: 25)
            y += notificationLabel.frame.height + 2
        }
        
        if addSenderName {
            var width = (UIScreen.main.bounds.width/3 )
            width += CGFloat(5)
            senderNameLabel.frame = CGRect(x: 0.05*screenWidth, y: y, width: width, height: 15)
            let fixedWidth = senderNameLabel.frame.size.width
            let newSize = senderNameLabel.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            var newFrame = senderNameLabel.frame
            newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
            senderNameLabel.frame = newFrame
            senderNameLabel.layer.borderWidth = 1
            senderNameLabel.layer.cornerRadius = 5
            senderNameLabel.layer.borderColor = senderNameLabel.backgroundColor?.cgColor
            y += newFrame.height + 2
//            addSenderName = false
        }
        if senderId == PFUser.current()?.objectId {
            messageTextLabel.frame = CGRect(x: UIScreen.main.bounds.width/3.0, y: y, width: UIScreen.main.bounds.width/1.5, height: 25)
        }
        else {
            var width = (UIScreen.main.bounds.width/1.5)
            width += CGFloat(5)
            messageTextLabel.frame = CGRect(x: 5, y: y, width: width, height: 25)
        }
        
        
        let fixedWidth = messageTextLabel.frame.size.width
        var newSize = messageTextLabel.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//        var newFrame = messageTextLabel.frame
//        //max(newSize.width, fixedWidth)
//        newFrame.size = CGSize(width: newSize.width, height: newSize.height)
        if newSize.width < 33 {
            newSize.width = 33
            messageTextLabel.textContainer.maximumNumberOfLines = 1
        }
        if newSize.height < 33 {
            newSize.height = 33
        }
        var x = 0.05*screenWidth
        if senderId == PFUser.current()?.objectId {
            x = 0.95*screenWidth - newSize.width
        }
        let newFrame = CGRect(x: x, y: y, width: newSize.width, height: newSize.height)
        messageTextLabel.frame = newFrame
        messageTextLabel.layer.borderWidth = 1
        if messageTextLabel.text.characters.count < 3 {
            messageTextLabel.layer.cornerRadius = messageTextLabel.frame.width/2.0
            messageTextLabel.textAlignment = NSTextAlignment.center
        } else {
            messageTextLabel.layer.cornerRadius = 15
        }
        messageTextLabel.layer.borderColor = messageTextLabel.backgroundColor?.cgColor
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
