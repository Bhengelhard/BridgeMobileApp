//
//  NewMatchesView.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 11/15/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class NewMatchesView: UIScrollView {

    var profilePics: [UIView]!
    var names: [String]!
    
    
    init(frame:CGRect, profilePics:[UIView], names:[String]) {
        super.init(frame: frame)
        self.profilePics = profilePics
        self.names = names
        self.contentSize = CGSize(width: max(DisplayUtility.screenWidth, CGFloat(profilePics.count)*0.2243*DisplayUtility.screenWidth), height: 0.17*DisplayUtility.screenHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutNewMatches() {
        for i in 0...profilePics.count {
            let profilePic = profilePics[i]
            let name = names[i]
        }
    }

}
