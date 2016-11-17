//
//  MessagesTableCellTableViewCell.swift
//  MyBridgeApp
//
//  Created by Sagar Sinha on 6/22/16.
//  Copyright © 2016 BHE Ventures LLC. All rights reserved.
//

import UIKit

class MessagesTableCell: UITableViewCell {
    
    var color: UIColor!
    
    var participants: UILabel!
    var messageTimestamp: UILabel!
    var messageSnapshot: UITextView!
    var profilePic: UIImageView!
    var arrow: UILabel!
    var notificationDot: UIImageView!
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
        participants.font = UIFont(name: "BentonSans", size: 18.5)
        
        profilePic = UIImageView()
        profilePic.backgroundColor = .black
        profilePic.layer.borderWidth = 2
        
        messageTimestamp = UILabel(frame:CGRect.zero)
        messageTimestamp.font = UIFont(name: "BentonSans", size: 18.5)
        messageTimestamp.textAlignment = NSTextAlignment.right
        
        messageSnapshot = UITextView(frame:CGRect.zero)
        messageSnapshot.font = UIFont(name: "BentonSans", size: 16.5)
        messageSnapshot.textContainer.maximumNumberOfLines = 2
        messageSnapshot.textContainer.lineBreakMode = NSLineBreakMode.byTruncatingTail
        messageSnapshot.sizeToFit()
        messageSnapshot.isUserInteractionEnabled = false
        messageSnapshot.contentInset = UIEdgeInsetsMake(-7.0,0.0,0,0.0)
        
        arrow = UILabel(frame:CGRect.zero)
        arrow.font = UIFont(name: "Mishafi Regular", size: 30)
        
        notificationDot = UIImageView(frame:CGRect.zero)
        line = UIView(frame:CGRect.zero)
        line.backgroundColor = UIColor.gray
        contentView.addSubview(participants)
        contentView.addSubview(profilePic)
        contentView.addSubview(messageTimestamp)
        contentView.addSubview(messageSnapshot)
        contentView.addSubview(notificationDot)
        contentView.addSubview(line)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        cellWidth = bounds.size.width//cellWidth ?? contentView.frame.width
        cellHeight = cellHeight ?? contentView.frame.height
        /*
<<<<<<< HEAD
        if let _ = setSeparator {
            // print("setSeparator")
            line.frame = CGRect(x: 0.025*cellWidth! + 0.15*cellHeight!, y: 0, width: bounds.size.width, height: 1)
            contentView.addSubview(line)
        }
        */
=======
         if let _ = setSeparator {
         // print("setSeparator")
         line.frame = CGRect(x: 0.025*cellWidth! + 0.15*cellHeight!, y: 0, width: bounds.size.width, height: 1)
         contentView.addSubview(line)
         }
         */
>>>>>>> fcbbe143edff857e1e0cc2b99dfb320c325f9b1a
        
        profilePic.frame = CGRect(x: 0.0708*cellWidth!, y: 0.5*cellHeight!-0.168*cellWidth!/2, width: 0.168*cellWidth!, height: 0.168*cellWidth!)
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.layer.borderColor = color.cgColor
        
        //setting line to begin with text and go to end of frame
        participants.frame = CGRect(x: profilePic.frame.maxX + 0.02*cellWidth!, y: profilePic.frame.minY, width: 0.2682*cellWidth!, height: 0.25*cellHeight!)
        participants.sizeToFit()
        messageTimestamp.frame = CGRect(x: 0.7554*cellWidth!, y: participants.frame.minY, width: 0.35*cellWidth!, height: 0.2*cellHeight!)
        messageTimestamp.sizeToFit()
        messageTimestamp.frame = CGRect(x: cellWidth! - messageTimestamp.frame.width - 0.02*cellWidth!, y: messageTimestamp.frame.minY, width: messageTimestamp.frame.width, height: messageTimestamp.frame.height)
        messageTimestamp.textColor = color
        
        messageSnapshot.frame = CGRect(x: participants.frame.minX, y: participants.frame.maxY + 0.05*cellHeight!, width: 0.8*cellWidth!-0.15*cellHeight!, height: 0.65*cellHeight!)
        messageSnapshot.textContainer.lineFragmentPadding = 0
        
        //setting line to begin with text and go to end of frame
        line.frame = CGRect(x: profilePic.frame.minX, y: 0.99*cellHeight!, width: cellWidth! - profilePic.frame.minX, height: 1)
        
        //participants.frame = CGRect(x: 0.05*cellWidth! + 0.15*cellHeight!, y: 0.1*cellHeight!, width: 0.55*cellWidth!, height: 0.25*cellHeight!)
        
        //messageTimestamp.frame = CGRect(x: 0.7*cellWidth!, y: 0.15*cellHeight!, width: 0.25*cellWidth!, height: 0.2*cellHeight!)
        arrow.frame = CGRect(x: 0.9*cellWidth!, y: 0.375*cellHeight!, width: 0.05*cellWidth!, height: 0.25*cellHeight!)
        
        
        notificationDot.frame = CGRect(x: 0.0199*cellWidth!, y: profilePic.frame.midY - 0.065*cellHeight!, width: 0.13*cellHeight!, height: 0.13*cellHeight!)
        //notificationDot.layer.backgroundColor = UIColor(red: 255/255, green: 230/255, blue: 57/255, alpha: 1.0).cgColor
        notificationDot.image = UIImage(named: "Inbox_Notification_Icon")
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
