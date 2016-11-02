//
//  MissionControlView.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 11/2/16.
//  Copyright © 2016 BHE Ventures LLC. All rights reserved.
//

import UIKit

class MissionControlView {

    func createMissionControlTab (view: UIView, missionControlTabButton: UIButton) {
        let missionControlTab = UIView()
        missionControlTab.frame = CGRect(x:0, y: 0.95*DisplayUtility.screenHeight, width: 0.4*DisplayUtility.screenWidth, height: 0.05*DisplayUtility.screenHeight)
        missionControlTab.center.x = view.center.x
        missionControlTab.backgroundColor = DisplayUtility.necterGray
        
        let maskPath = UIBezierPath(roundedRect: missionControlTab.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10.0, height: 10.0))
        let missionControlTabShape = CAShapeLayer()
        missionControlTabShape.path = maskPath.cgPath
        missionControlTab.layer.mask = missionControlTabShape
        
        let shadowView = UIView(frame: missionControlTab.frame)
        shadowView.backgroundColor = UIColor.lightGray
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.7
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
        shadowView.layer.shadowRadius = 10
        shadowView.layer.shouldRasterize = true
        view.addSubview(shadowView)
        
        missionControlTabButton.frame = missionControlTab.frame
        missionControlTabButton.setTitle("^", for: .normal)
        
        
        view.addSubview(missionControlTab)
        view.addSubview(missionControlTabButton)
    }
    
    func showMissionControlFilters() {
        print("showMissionControlFilters")
        
    }
    
    func showMissionControlPostStatus() {
        
    }

}
