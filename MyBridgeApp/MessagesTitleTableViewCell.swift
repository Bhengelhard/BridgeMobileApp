//
//  MessagesTitleTableViewCell.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/9/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit

class MessagesTitleTableViewCell: UITableViewCell {

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
        
        //Initialize Title for Inbox
        let newMatchesTitle = UILabel()
        newMatchesTitle.text = "MESSAGES"
        newMatchesTitle.font = UIFont(name: "BentonSans-Bold", size: 16)
        newMatchesTitle.textAlignment = NSTextAlignment.left
        newMatchesTitle.isHidden = true
        newMatchesTitle.frame = CGRect(x: 0.0463*frame.width, y: self.frame.minY + 0.02*frame.height, width: 0.8*frame.width, height: 0.05*frame.width)
        addSubview(newMatchesTitle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
