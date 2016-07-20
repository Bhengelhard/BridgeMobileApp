//
//  SingleMessageTableCell.swift
//  MyBridgeApp
//
//  Created by Sagar Sinha on 7/19/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class SingleMessageTableCell: UITableViewCell {
    let padding: CGFloat = 5
    var background: UIView!
    var senderNameLabel: UITextView!
    var messageTextLabel: UILabel!
    var timestampLabel: UILabel!
    
    var singleMessageContent: SingleMessageContent? {
        didSet {
            if let s = singleMessageContent {
                background.backgroundColor = s.backgroundColor
                timestampLabel.text = s.timestamp
                senderNameLabel.text = s.senderName
                messageTextLabel.text = s.messageText
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
        contentView.addSubview(background)
        
        messageTextLabel = UILabel(frame: CGRectZero)
        messageTextLabel.textAlignment = .Left
        messageTextLabel.textColor = UIColor.blackColor()
        contentView.addSubview(messageTextLabel)
        
        senderNameLabel = UITextView(frame: CGRectZero)
        senderNameLabel.textAlignment = .Center
        senderNameLabel.textColor = UIColor.blackColor()
        senderNameLabel.userInteractionEnabled = false
        contentView.addSubview(senderNameLabel)
        
        timestampLabel = UILabel(frame: CGRectZero)
        timestampLabel.textAlignment = .Center
        timestampLabel.textColor = UIColor.whiteColor()
        contentView.addSubview(timestampLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        background.frame = CGRectMake(0, padding, frame.width, frame.height - 2 * padding)
        senderNameLabel.frame = CGRectMake(padding, (frame.height - 25)/2, 40, 25)
        let fixedWidth = senderNameLabel.frame.size.width
        senderNameLabel.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        let newSize = senderNameLabel.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = senderNameLabel.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        senderNameLabel.frame = newFrame;

        timestampLabel.frame = CGRectMake(frame.width - 100, padding, 100, frame.height - 2 * padding)
        messageTextLabel.frame = CGRectMake(CGRectGetMaxX(senderNameLabel.frame) + 10, 0, frame.width - timestampLabel.frame.width - (CGRectGetMaxX(senderNameLabel.frame) + 10), frame.height)
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
