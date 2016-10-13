//
//  StatusTableViewCell.swift
//  MyBridgeApp
//
//  Created by Daniel Fine on 8/10/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class StatusTableViewCell: UITableViewCell {
    
    var optionLabel = UILabel()
    var optionImage = UIImageView()
    var cellHeight: CGFloat? {
        didSet {
            //setNeedsLayout()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        cellHeight = cellHeight ?? self.frame.height
        optionImage.frame = CGRect(x: 0.1*self.frame.width, y: 0.1*cellHeight!, width: 0.6*cellHeight!, height: 0.6*cellHeight!)
        optionImage.contentMode = UIViewContentMode.scaleToFill
        optionImage.clipsToBounds = true
        
        //optionImage.center.y = self.center.y
        optionLabel.frame = CGRect(x: 0.15*self.frame.width + 0.6*cellHeight!, y: 0, width: 0.5*self.frame.width, height: self.frame.height)
        optionLabel.textAlignment = NSTextAlignment.left
        optionLabel.center.y = optionImage.center.y
        optionLabel.font = UIFont(name: "BentonSans", size: 26)
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(optionImage)
        contentView.addSubview(optionLabel)
        
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
