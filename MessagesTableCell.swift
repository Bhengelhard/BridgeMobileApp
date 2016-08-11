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
    var messageSnapshot: UILabel!
    var arrow: UILabel!
    var notificationDot: UIView!
    
    let cellWidth = UIScreen.mainScreen().bounds.width
    let cellHeight:CGFloat = 80.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        //notificationDot.hidden = true
        participants.frame = CGRect(x: 0.1*cellWidth, y: 0.1*cellHeight, width: 0.55*cellWidth, height: 0.25*cellHeight)
        messageTimestamp.frame = CGRect(x: 0.65*cellWidth, y: 0.15*cellHeight, width: 0.2*cellWidth, height: 0.2*cellHeight)
        arrow.frame = CGRect(x: 0.9*cellWidth, y: 0.375*cellHeight, width: 0.05*cellWidth, height: 0.25*cellHeight)
        messageSnapshot.frame = CGRect(x: 0.1*cellWidth, y: 0.425*cellHeight, width: 0.8*cellWidth, height: 0.4*cellHeight)
        messageSnapshot.sizeToFit()
        notificationDot.frame = CGRect(x: 0.025*cellWidth, y: 0.425*cellHeight, width: 0.15*cellHeight, height: 0.15*cellHeight)
        notificationDot.layer.cornerRadius = notificationDot.frame.size.width/2
        notificationDot.layer.cornerRadius = notificationDot.frame.size.height/2
        notificationDot.clipsToBounds = true
        
        
    }

}
