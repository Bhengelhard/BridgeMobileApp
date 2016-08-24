//
//  Timer.swift
//  MyBridgeApp
//
//  Created by Daniel Fine on 8/23/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation

class Timer {
    typealias TimerFunction = (Int)->Bool
    private var handler: TimerFunction
    private var i = 0
    
    init(interval: NSTimeInterval, handler: TimerFunction) {
        self.handler = handler
        NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: "timerFired:", userInfo: nil, repeats: true)
    }
    
    @objc
    private func timerFired(timer:NSTimer) {
        if !handler(i++) {
            timer.invalidate()
        }
    }
}