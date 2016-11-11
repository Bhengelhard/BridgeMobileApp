//
//  SwipeCard.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 11/10/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class SwipeCard: UIView {
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    convenience init () {
        self.init(frame: CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This is a fatal error message from CustomClasses/CustomViews/SwipeCard.swift")
    }
    
    func initialize() {
        self.frame = CGRect(x: 0.071*DisplayUtility.screenWidth, y: 0.1178*DisplayUtility.screenHeight, width: 0.8586*DisplayUtility.screenWidth, height: 0.8178*DisplayUtility.screenHeight)
        self.layer.cornerRadius = 13.379
        self.backgroundColor = UIColor.black
        
        let topHalf = HalfSwipeCard(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 0.5*self.frame.height))
        topHalf.initialize(name: "Top Half", status: "Status", photoURL: "URL", connectionType: "Business")
        let bottomHalf = HalfSwipeCard(frame: CGRect(x: 0, y: 0.5*self.frame.height, width: self.frame.width, height: 0.5*self.frame.height))
        bottomHalf.initialize(name: "Bottom Half", status: "Status", photoURL: "URL", connectionType: "Business")
        self.addSubview(topHalf)
        self.addSubview(bottomHalf)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
