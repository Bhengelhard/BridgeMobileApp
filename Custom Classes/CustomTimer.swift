//
//  Timer.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 8/23/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation

class CustomTimer {
    typealias TimerFunction = (Int)->Bool
    fileprivate var handler: TimerFunction
    fileprivate var i = 0
    
    init(interval: TimeInterval, handler: @escaping TimerFunction) {
        self.handler = handler
        Foundation.Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(CustomTimer.timerFired(_:)), userInfo: nil, repeats: true)
    }
    
    @objc
    fileprivate func timerFired(_ timer:Foundation.Timer) {
        i = i + 1
        if !handler(i) {
            timer.invalidate()
        }
        //        if !timer.isValid {
        //            timer.invalidate()
        //        }
    }
}
