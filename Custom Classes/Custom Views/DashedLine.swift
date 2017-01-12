//
//  DashedLine.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 11/21/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class DashedLine: UIView {
    
    var coordinates : [CGPoint] = [CGPoint]() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var color : CGColor = UIColor.white.cgColor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    class func initWithColors(colors :NSArray) {
        
    }

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {        
        // Context is the object used for drawing
        let context = UIGraphicsGetCurrentContext()

        context?.setLineWidth(1.5)
        context?.setStrokeColor(color)
        
        //Create a path
        context?.move(to: coordinates[0])
        context?.addLine(to: coordinates[1])
        context?.setLineDash(phase: 3.0, lengths: [8.0, 8.0])
        
        context?.strokePath()
        
    }

}
