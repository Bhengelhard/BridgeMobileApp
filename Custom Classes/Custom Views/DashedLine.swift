//
//  DashedLine.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 11/18/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class DashedLine: UIView {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    /*override func draw(_ rect: CGRect) {
        let  path = UIBezierPath()
        
        let p1 = CGPoint(x: 100, y: 100)
        path.move(to: p1)
        
        let  p2 = CGPoint(x: 500, y: 500)
        path.addLine(to: p2)
        
        let  dashes: [ CGFloat ] = [ 16.0, 32.0 ]
        path.setLineDash(dashes, count: dashes.count, phase: 0.0)
        
        path.lineWidth = 8.0
        path.lineCapStyle = .butt
        UIColor.white.set()
        path.stroke()

    }*/
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        
        // Create a CAShapeLayer
        let shapeLayer = CAShapeLayer()
        
        // The Bezier path that we made needs to be converted to
        // a CGPath before it can be used on a layer.
        shapeLayer.path = createBezierPath().cgPath
        
        // apply other properties related to the path
        shapeLayer.strokeColor = UIColor.white.cgColor
        //shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 3.0
        //shapeLayer.position = CGPoint(x: 10, y: 10)
        
    
        // add the new layer to our custom view
        self.layer.addSublayer(shapeLayer)
    }
    
    func createBezierPath() -> UIBezierPath {
        let  path = UIBezierPath()
        
        let p1 = CGPoint(x: 100, y: 100)
        path.move(to: p1)
        
        let  p2 = CGPoint(x: 200, y: 200)
        path.addLine(to: p2)
        
        
        let lineDash: [CGFloat] = [40.0, 12.0, 8.0, 12.0, 8.0, 12.0]
        
        path.setLineDash(lineDash, count: 6, phase: 0.0)
        //[thePath setLineDash:lineDash count:6 phase:0.0];
        //let  dashes: [ CGFloat ] = [ 10.0, 20.0, 10.0, 20.0, 10.0, 20.0, 10.0 ]
        //path.setLineDash(dashes, count: dashes.count, phase: 0.0)
        
        //path.lineWidth = 8.0
        path.lineCapStyle = .butt
        //UIColor.white.set()
        path.stroke()
//        // create a new path
//        let path = UIBezierPath()
//        
//        // starting point for the path (bottom left)
//        path.move(to: CGPoint(x: 2, y: 26))
//        
//        // *********************
//        // ***** Left side *****
//        // *********************
//        
//        // segment 1: line
//        path.addLine(to: CGPoint(x: 2, y: 15))
//        
//        // segment 2: curve
//        path.addCurve(to: CGPoint(x: 0, y: 12), // ending point
//            controlPoint1: CGPoint(x: 2, y: 14),
//            controlPoint2: CGPoint(x: 0, y: 14))
//        
//        // segment 3: line
//        path.addLine(to: CGPoint(x: 0, y: 2))
//        
//        // *********************
//        // ****** Top side *****
//        // *********************
//        
//        // segment 4: arc
//        path.addArc(withCenter: CGPoint(x: 2, y: 2), // center point of circle
//            radius: 2, // this will make it meet our path line
//            startAngle: CGFloat(M_PI), // π radians = 180 degrees = straight left
//            endAngle: CGFloat(3*M_PI_2), // 3π/2 radians = 270 degrees = straight up
//            clockwise: true) // startAngle to endAngle goes in a clockwise direction
//        
//        // segment 5: line
//        path.addLine(to: CGPoint(x: 8, y: 0))
//        
//        // segment 6: arc
//        path.addArc(withCenter: CGPoint(x: 8, y: 2),
//                    radius: 2,
//                    startAngle: CGFloat(3*M_PI_2), // straight up
//            endAngle: CGFloat(0), // 0 radians = straight right
//            clockwise: true)
//        
//        // *********************
//        // ***** Right side ****
//        // *********************
//        
//        // segment 7: line
//        path.addLine(to: CGPoint(x: 10, y: 12))
//        
//        // segment 8: curve
//        path.addCurve(to: CGPoint(x: 8, y: 15), // ending point
//            controlPoint1: CGPoint(x: 10, y: 14),
//            controlPoint2: CGPoint(x: 8, y: 14))
//        
//        // segment 9: line
//        path.addLine(to: CGPoint(x: 8, y: 26))
//        
//        // *********************
//        // **** Bottom side ****
//        // *********************
//        
//        // segment 10: line
//        path.close() // draws the final line to close the path
        
        return path
    }

}
