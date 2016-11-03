//
//  MissionControlView.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 11/2/16.
//  Copyright © 2016 BHE Ventures LLC. All rights reserved.
//

import UIKit

class MissionControlView {
    
    let displayUtility = DisplayUtility()
    
    let missionControlTab = UIView()
    let missionControlFilters = UIView()
    let missionControlPostStatus = UIView()
    //let tabShadowView = UIView()

    func createMissionControlTab (view: UIView, missionControlTabButton: UIButton) {
        missionControlTab.frame = CGRect(x:0, y: 0.95*DisplayUtility.screenHeight, width: 0.4*DisplayUtility.screenWidth, height: 0.06*DisplayUtility.screenHeight)
        missionControlTab.center.x = view.center.x
        missionControlTab.layer.borderWidth = 0
        
        let maskPath = UIBezierPath(roundedRect: missionControlTab.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 5.0, height: 5.0))
        let missionControlTabShape = CAShapeLayer()
        missionControlTabShape.path = maskPath.cgPath
        missionControlTab.layer.mask = missionControlTabShape
        
        /*let shadowView = UIView(frame: missionControlTab.frame)
         shadowView.backgroundColor = UIColor.lightGray
         shadowView.layer.masksToBounds = false
         shadowView.layer.shadowColor = UIColor.black.cgColor
         shadowView.layer.shadowOpacity = 0.7
         shadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
         shadowView.layer.shadowRadius = 10
         shadowView.layer.shouldRasterize = true
         view.addSubview(shadowView)*/
        
        view.addSubview(missionControlTab)
        displayUtility.setBlurredView(view: view, viewToBlur: missionControlTab)
        
        missionControlTabButton.frame = CGRect(x: 0, y: 0, width: missionControlTab.frame.width, height: missionControlTab.frame.height)//missionControlTab.frame
        missionControlTabButton.setTitle("^", for: .normal)
        missionControlTab.addSubview(missionControlTabButton)
        
        
        
    }
    
    func showMissionControlFilters(view: UIView, businessButton: UIButton, loveButton: UIButton, friendshipButton: UIButton) {
        print("showMissionControlFilters")
        missionControlTab.frame = CGRect(x: 0, y: 0.85*DisplayUtility.screenHeight, width: 0.4*DisplayUtility.screenWidth, height: 0.051*DisplayUtility.screenHeight)
        missionControlTab.center.x = view.center.x
        missionControlFilters.frame = CGRect(x: 0, y: 0.9*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenHeight)
        missionControlFilters.layer.borderWidth = 0
        
        let maskPath = UIBezierPath(roundedRect: missionControlFilters.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 2.0, height: 2.0))
        let missionControlFiltersShape = CAShapeLayer()
        missionControlFiltersShape.path = maskPath.cgPath
        missionControlFilters.layer.mask = missionControlFiltersShape
        
        //adding the filterButtons
        businessButton.setImage(UIImage(named: "Business_Icon_Gray"), for: UIControlState())
        businessButton.setImage(UIImage(named:  "Business_Icon_Blue"), for: .disabled)
        businessButton.frame = CGRect(x: 0, y: 0, width: 0.1*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenWidth)
        businessButton.center.y = missionControlFilters.center.y
        businessButton.center.x = missionControlFilters.center.x - 0.2*DisplayUtility.screenWidth
        businessButton.tag = 1
        
        loveButton.setImage(UIImage(named: "Love_Icon_Gray"), for: UIControlState())
        loveButton.setImage(UIImage(named: "Love_Icon_Red"), for: .disabled)
        loveButton.frame = CGRect(x: 0, y: 0, width: 0.1*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenWidth)
        loveButton.center.y = missionControlFilters.center.y
        loveButton.center.x = missionControlFilters.center.x
        loveButton.tag = 2
        
        friendshipButton.setImage(UIImage(named: "Friendship_Icon_Gray"), for: UIControlState())
        friendshipButton.setImage(UIImage(named:  "Friendship_Icon_Green"), for: .disabled)
        friendshipButton.frame = CGRect(x: 0, y: 0, width: 0.1*DisplayUtility.screenWidth, height: 0.1150*DisplayUtility.screenWidth)
        friendshipButton.center.y = missionControlFilters.center.y
        friendshipButton.center.x = missionControlFilters.center.x + 0.2*DisplayUtility.screenWidth
        friendshipButton.tag = 3

        view.addSubview(missionControlFilters)
        displayUtility.setBlurredView(view: view, viewToBlur: missionControlFilters)
        
        view.addSubview(businessButton)
        view.addSubview(loveButton)
        view.addSubview(friendshipButton)

    }
    
    func showMissionControlPostStatus() {
        print("showMissionControlPostStatus")
    }

}
