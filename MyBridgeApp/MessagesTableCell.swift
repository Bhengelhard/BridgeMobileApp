//
//  MessagesTableCellTableViewCell.swift
//  MyBridgeApp
//
//  Created by Sagar Sinha on 6/22/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class MessagesTableCell: UITableViewCell {
    

//    @IBOutlet weak var participants: UILabel!
//    @IBOutlet weak var messageTimestamp: UILabel!
//    @IBOutlet weak var messageSnapshot: UILabel!
//    @IBOutlet weak var arrow: UILabel!
//    @IBOutlet weak var notificationDot: UIView!
    var participants: UILabel!
    var messageTimestamp: UILabel!
    //var messageSnapshot: UILabel!
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

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cellWidth = cellWidth ?? contentView.frame.width
        cellHeight = cellHeight ?? contentView.frame.height
        participants = UILabel(frame: CGRectZero)
        participants.font = UIFont(name: "Verdana", size: 18)
        
        messageTimestamp = UILabel(frame:CGRectZero)
        messageTimestamp.font = UIFont(name: "BentonSans", size: 16)
        messageTimestamp.textAlignment = NSTextAlignment.Right
        
        //messageSnapshot = UILabel(frame:CGRectZero)
        messageSnapshot = UITextView(frame:CGRectZero)
        messageSnapshot.font = UIFont(name: "BentonSans", size: 16)
        //messageSnapshot.numberOfLines = 2
        messageSnapshot.textContainer.maximumNumberOfLines = 2
        messageSnapshot.textContainer.lineBreakMode = NSLineBreakMode.ByTruncatingTail//NSLineBreakByTruncatingTail
        messageSnapshot.sizeToFit()
        messageSnapshot.userInteractionEnabled = false
        messageSnapshot.contentInset = UIEdgeInsetsMake(-7.0,0.0,0,0.0)
        
        arrow = UILabel(frame:CGRectZero)
        arrow.font = UIFont(name: "Mishafi Regular", size: 30)
        
        notificationDot = UIView(frame:CGRectZero)
        line = UIView(frame:CGRectZero)
        line.backgroundColor = UIColor.grayColor()
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
        line.frame = CGRectMake(0.025*cellWidth! + 0.15*cellHeight!, 0, bounds.size.width, 1)
        contentView.addSubview(line)
        }
        //setting line to begin with text and go to end of frame
        participants.frame = CGRect(x: 0.1*cellWidth!, y: 0.1*cellHeight!, width: 0.55*cellWidth!, height: 0.25*cellHeight!)
        messageTimestamp.frame = CGRect(x: 0.65*cellWidth!, y: 0.15*cellHeight!, width: 0.35*cellWidth!, height: 0.2*cellHeight!)
        
        //setting line to begin with text and go to end of frame
        line.frame = CGRectMake(0.05*cellWidth! + 0.15*cellHeight!, 0.99*cellHeight!, bounds.size.width, 1)
        
        participants.frame = CGRect(x: 0.05*cellWidth! + 0.15*cellHeight!, y: 0.1*cellHeight!, width: 0.55*cellWidth!, height: 0.25*cellHeight!)
        
        messageTimestamp.frame = CGRect(x: 0.7*cellWidth!, y: 0.15*cellHeight!, width: 0.25*cellWidth!, height: 0.2*cellHeight!)
        arrow.frame = CGRect(x: 0.9*cellWidth!, y: 0.375*cellHeight!, width: 0.05*cellWidth!, height: 0.25*cellHeight!)
        
        messageSnapshot.frame = CGRect(x: 0.05*cellWidth! + 0.15*cellHeight!, y: 0.4*cellHeight!, width: 0.8*cellWidth!-0.15*cellHeight!, height: 0.4*cellHeight!)
        
        notificationDot.frame = CGRect(x: 0.025*cellWidth!, y: 0.4375*cellHeight!, width: 0.15*cellHeight!, height: 0.15*cellHeight!)
        notificationDot.layer.backgroundColor = UIColor(red: 255/255, green: 230/255, blue: 57/255, alpha: 1.0).CGColor
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
