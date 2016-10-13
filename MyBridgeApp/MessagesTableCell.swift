//
//  MessagesTableCellTableViewCell.swift
//  MyBridgeApp
//
//  Created by Sagar Sinha on 6/22/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class MessagesTableCell: UITableViewCell {
    
    var participants: UILabel!
    var messageTimestamp: UILabel!
    var messageSnapshot: UITextView!
    var arrow: UILabel!
    var notificationDot: UIView!
    var line: UIView!
    var cellWidth:CGFloat?
    var cellHeight:CGFloat?
    var setSeparator:Bool? {
        didSet{
            //print("setSeparator")
            setNeedsLayout()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cellWidth = cellWidth ?? contentView.frame.width
        cellHeight = cellHeight ?? contentView.frame.height
        participants = UILabel(frame: CGRect.zero)
        participants.font = UIFont(name: "Verdana", size: 18)
        
        messageTimestamp = UILabel(frame:CGRect.zero)
        messageTimestamp.font = UIFont(name: "BentonSans", size: 16)
        messageTimestamp.textAlignment = NSTextAlignment.right
        
        messageSnapshot = UITextView(frame:CGRect.zero)
        messageSnapshot.font = UIFont(name: "BentonSans", size: 16)
        messageSnapshot.textContainer.maximumNumberOfLines = 2
        messageSnapshot.textContainer.lineBreakMode = NSLineBreakMode.byTruncatingTail
        messageSnapshot.sizeToFit()
        messageSnapshot.isUserInteractionEnabled = false
        messageSnapshot.contentInset = UIEdgeInsetsMake(-7.0,0.0,0,0.0)
        
        arrow = UILabel(frame:CGRect.zero)
        arrow.font = UIFont(name: "Mishafi Regular", size: 30)
        
        notificationDot = UIView(frame:CGRect.zero)
        line = UIView(frame:CGRect.zero)
        line.backgroundColor = UIColor.gray
        contentView.addSubview(participants)
        contentView.addSubview(messageTimestamp)
        contentView.addSubview(messageSnapshot)
        contentView.addSubview(arrow)
        contentView.addSubview(notificationDot)
        //contentView.addSubview(line)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        cellWidth = bounds.size.width//cellWidth ?? contentView.frame.width
        cellHeight = cellHeight ?? contentView.frame.height
        if let _ = setSeparator {
           // print("setSeparator")
            line.frame = CGRect(x: 0.025*cellWidth! + 0.15*cellHeight!, y: 0, width: bounds.size.width, height: 1)
            contentView.addSubview(line)
        }
        //setting line to begin with text and go to end of frame
        participants.frame = CGRect(x: 0.1*cellWidth!, y: 0.1*cellHeight!, width: 0.55*cellWidth!, height: 0.25*cellHeight!)
        messageTimestamp.frame = CGRect(x: 0.65*cellWidth!, y: 0.15*cellHeight!, width: 0.35*cellWidth!, height: 0.2*cellHeight!)
        
        //setting line to begin with text and go to end of frame
        line.frame = CGRect(x: 0.05*cellWidth! + 0.15*cellHeight!, y: 0.99*cellHeight!, width: bounds.size.width, height: 1)
        
        participants.frame = CGRect(x: 0.05*cellWidth! + 0.15*cellHeight!, y: 0.1*cellHeight!, width: 0.55*cellWidth!, height: 0.25*cellHeight!)
        
        messageTimestamp.frame = CGRect(x: 0.7*cellWidth!, y: 0.15*cellHeight!, width: 0.25*cellWidth!, height: 0.2*cellHeight!)
        arrow.frame = CGRect(x: 0.9*cellWidth!, y: 0.375*cellHeight!, width: 0.05*cellWidth!, height: 0.25*cellHeight!)
        
        messageSnapshot.frame = CGRect(x: 0.05*cellWidth! + 0.15*cellHeight!, y: 0.4*cellHeight!, width: 0.8*cellWidth!-0.15*cellHeight!, height: 0.65*cellHeight!)
        
        notificationDot.frame = CGRect(x: 0.025*cellWidth!, y: 0.4375*cellHeight!, width: 0.15*cellHeight!, height: 0.15*cellHeight!)
        notificationDot.layer.backgroundColor = UIColor(red: 255/255, green: 230/255, blue: 57/255, alpha: 1.0).cgColor
        notificationDot.layer.cornerRadius = notificationDot.frame.size.height/2
        notificationDot.clipsToBounds = true
        

//        guard let superview = contentView.superview else {
//            return
//        }
//        for subview in superview.subviews {
//            if String(subview.dynamicType).hasSuffix("SeparatorView") {
//                subview.hidden = false
//            }
//        }
//
    }

}
