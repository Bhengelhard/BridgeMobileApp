//
//  NewMessageTableCell.swift
//  MyBridgeApp
//
//  Created by Sagar Sinha on 6/23/16.
//  Copyright © 2016 BHE Ventures LLC. All rights reserved.
//

import UIKit

class NewMessageTableCell: UITableViewCell {

    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
