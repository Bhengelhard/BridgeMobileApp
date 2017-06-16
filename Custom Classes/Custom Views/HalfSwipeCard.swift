//
//  HalfSwipeCard.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 11/11/16.
//  Copyright © 2016 Parse. All rights reserved.
//
//// Create View for Half of Swipe Card that includes the inputted user info

import UIKit

class HalfSwipeCard: UIView {
    var photo: UIImage?
    let nameLabel = UILabel()
    let photoView = UIImageView()
    var nameLabelWidthConstraint: NSLayoutConstraint?
    var nameLabelHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    func initialize(name: String) {
        layer.masksToBounds = true
        backgroundColor = UIColor(red: 234/255, green: 237/255, blue: 239/255, alpha: 1.0)
        
        nameLabel.textColor = UIColor.white
        nameLabel.font = UIFont(name: "BentonSans-Bold", size: 22)
        nameLabel.textAlignment = NSTextAlignment.left
        nameLabel.layer.shadowOpacity = 0.5
        nameLabel.layer.shadowRadius = 0.5
        nameLabel.layer.shadowColor = UIColor.black.cgColor
        nameLabel.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        
        photoView.contentMode = .scaleAspectFill
        photoView.clipsToBounds = true
        
        photoView.image = #imageLiteral(resourceName: "No_Profile_Picture")
        
    }
    
    func setName(name: String) {
        nameLabel.text = name
        layoutHalfCard()
    }
    
    func setImage(image: UIImage?) {
        photoView.image = image
    }
    
    func layoutHalfCard() {
        addSubview(photoView)
        photoView.autoPinEdgesToSuperviewEdges()
        
        addSubview(nameLabel)
        
        // Setting origin y value of nameLabel based on placement of connectionTypeIcon which is based on whether there is a status
        nameLabel.sizeToFit()
        
        if let constraint = nameLabelWidthConstraint {
            constraint.constant = nameLabel.frame.width
        } else {
            nameLabelWidthConstraint = nameLabel.autoSetDimension(.width, toSize: nameLabel.frame.width)
        }
        
        if let constraint = nameLabelHeightConstraint {
            constraint.constant = nameLabel.frame.height
        } else {
            nameLabelHeightConstraint = nameLabel.autoSetDimension(.height, toSize: nameLabel.frame.height)
        }

        nameLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
        nameLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
        setNeedsLayout()
    }
    
    func callbackToSetPhoto(_ image: UIImage) -> Void {
        photo = image
    }
}
