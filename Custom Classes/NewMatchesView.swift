//
//  NewMatchesView.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 11/15/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class NewMatchesView: UIScrollView {

    var profilePics: [UIImage]!
    var names: [String]!
    
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    init(frame:CGRect, profilePics:[UIImage], names:[String]) {
        super.init(frame: frame)
        self.profilePics = profilePics
        self.names = names
        self.contentSize = CGSize(width: max(DisplayUtility.screenWidth, CGFloat(profilePics.count)*0.2243*DisplayUtility.screenWidth), height: 0.17*DisplayUtility.screenHeight)
        layoutNewMatches()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutNewMatches() {
        for i in 0...profilePics.count-1 {
            let profilePic = profilePics[i]
            let profilePicView = UIImageView(image: profilePic)
            profilePicView.frame = CGRect(x: CGFloat(i)*0.2243*frame.width + 0.0563*frame.width, y: self.frame.minY, width: 0.168*frame.width, height: 0.168*frame.width)
            profilePicView.layer.cornerRadius = profilePicView.frame.height/2
            profilePicView.layer.borderWidth = 2
            profilePicView.clipsToBounds = true
            let name = names[i]
            let nameLabel = UILabel(frame: CGRect(x: profilePicView.frame.minX, y: profilePicView.frame.maxY + 0.1*frame.height, width: 0, height: 0.2*frame.height))
            nameLabel.text = name
            nameLabel.sizeToFit()
            nameLabel.frame = CGRect(x: profilePicView.frame.midX - nameLabel.frame.width/2, y: nameLabel.frame.minY, width: nameLabel.frame.width, height: nameLabel.frame.height)
            addSubview(profilePicView)
            addSubview(nameLabel)
        }
    }

}
