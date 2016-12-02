//
//  CircleView.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 11/22/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class CircleView: UIView {

    var circleLayer: CAShapeLayer!
    var currentView = UIView()
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        print("circle view created")
        
        // Use UIBezierPath as an easy way to create the CGPath for the layer.
        // The path should be the entire circle.
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width)/2, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: true)
        
        // Setup the CAShapeLayer with the path, colors, and line width
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.white.cgColor
        circleLayer.lineWidth = 1.5;
        
        // Don't draw the circle initially
        circleLayer.strokeEnd = 0.0
        
        // Add the circleLayer to the view's layer's sublayers
        layer.addSublayer(circleLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateCircle(duration: TimeInterval, notificationView: UIView, notificationLabel: UILabel) {
        
        //setting label so it can be changed after animation
        label = notificationLabel
        
        //setting currentView so it can be removed after animation
        currentView = notificationView
        
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 1
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        circleLayer.strokeEnd = 1.0
        
        // Do the actual animation
        circleLayer.add(animation, forKey: "animateCircle")
        
        perform(#selector(successfullySent(_:)), with: self, afterDelay: duration)
        perform(#selector(removeCurrentView(_:)), with: self, afterDelay: duration + 0.7)
        
        //let timer = Timer.scheduledTimer(timeInterval: duration*2, target: self, selector: #selector(showCheckMark(_:)), userInfo: nil, repeats: false)
        
        //timer.fire()
        //animation.perform(#selector(showCheckMark(_:)), with: self, afterDelay: duration)
    }
    
    func successfullySent(_ sender: CABasicAnimation) {
        label.text = "Success!"
        
        let checkMark = UIImageView()
        checkMark.frame = CGRect(x: 0.2*self.frame.width, y: 0.2*self.frame.height, width: 0.6*self.frame.width, height: 0.6*self.frame.width)
        checkMark.image = UIImage(named: "White_Check")
        self.addSubview(checkMark)
    }
    
    func removeCurrentView(_ sender: CABasicAnimation) {
        
        
        UIView.animate(withDuration: 0.5, animations: {
            self.currentView.alpha = 0
        }) { (success) in
            self.currentView.removeFromSuperview()
        }
        
        
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
