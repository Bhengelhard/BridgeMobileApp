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
        missionControlTab.frame = CGRect(x:0, y: 0.95*DisplayUtility.screenHeight, width: 0.4*DisplayUtility.screenWidth, height: 0.051*DisplayUtility.screenHeight)
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
        
        missionControlFilters.frame = CGRect(x: 0, y: DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenHeight)
        view.addSubview(missionControlFilters)
        displayUtility.setBlurredView(view: view, viewToBlur: missionControlFilters)
        
    }
    
    func showMissionControlFilters(view: UIView, businessButton: UIButton, loveButton: UIButton, friendshipButton: UIButton) {
        print("showMissionControlFilters")
        
        UIView.animate(withDuration: 0.7, delay: 0.2, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            self.missionControlTab.frame.origin.y = 0.85*DisplayUtility.screenHeight
            self.missionControlFilters.frame.origin.y = 0.9*DisplayUtility.screenHeight
        })
        
        
        let maskPath = UIBezierPath(roundedRect: missionControlFilters.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 2.0, height: 2.0))
        let missionControlFiltersShape = CAShapeLayer()
        missionControlFiltersShape.path = maskPath.cgPath
        missionControlFilters.layer.mask = missionControlFiltersShape
        
        //adding the filterButtons
        businessButton.setImage(UIImage(named: "Business_Icon_Gray"), for: UIControlState())
        businessButton.setImage(UIImage(named:  "Business_Icon_Blue"), for: .selected)
        businessButton.frame = CGRect(x: 0, y: 0, width: 0.1*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenWidth)
        businessButton.center.y = missionControlFilters.center.y
        businessButton.center.x = missionControlFilters.center.x - 0.2*DisplayUtility.screenWidth
        businessButton.tag = 1
        
        loveButton.setImage(UIImage(named: "Love_Icon_Gray"), for: UIControlState())
        loveButton.setImage(UIImage(named: "Love_Icon_Red"), for: .selected)
        loveButton.frame = CGRect(x: 0, y: 0, width: 0.1*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenWidth)
        loveButton.center.y = missionControlFilters.center.y
        loveButton.center.x = missionControlFilters.center.x
        loveButton.tag = 2
        
        friendshipButton.setImage(UIImage(named: "Friendship_Icon_Gray"), for: UIControlState())
        friendshipButton.setImage(UIImage(named:  "Friendship_Icon_Green"), for: .selected)
        friendshipButton.frame = CGRect(x: 0, y: 0, width: 0.1*DisplayUtility.screenWidth, height: 0.1150*DisplayUtility.screenWidth)
        friendshipButton.center.y = missionControlFilters.center.y
        friendshipButton.center.x = missionControlFilters.center.x + 0.2*DisplayUtility.screenWidth
        friendshipButton.tag = 3
        
        view.addSubview(businessButton)
        view.addSubview(loveButton)
        view.addSubview(friendshipButton)

    }
    
    func showMissionControlPostStatus() {
        print("showMissionControlPostStatus")
    }
    
    func toggleFilters(type: String, businessButton: UIButton, loveButton: UIButton, friendshipButton: UIButton, noMessagesLabel: UILabel) {
            //updating which toolbar Button is selected and No Message Label Text
        if (type == "Business" && !businessButton.isSelected) {
            businessButton.isSelected = true
            loveButton.isSelected = false
            friendshipButton.isSelected = false
            noMessagesLabel.text = "You do not have any messages for business. Connect your friends for business to start a conversation."
        } else if (type == "Love" && !loveButton.isSelected) {
            loveButton.isSelected = true
            businessButton.isSelected = false
            friendshipButton.isSelected = false
            noMessagesLabel.text = "You do not have any messages for love. Connect your friends for love to start a conversation."
        } else if (type == "Friendship" && !friendshipButton.isSelected) {
            friendshipButton.isSelected = true
            businessButton.isSelected = false
            loveButton.isSelected = false
            noMessagesLabel.text = "You do not have any messages for friendship. Connect your friends for friendship to start a conversation."
        } else {
            businessButton.isSelected = false
            loveButton.isSelected = false
            friendshipButton.isSelected = false
        }
    }
    
    func drag(gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            let translation = gestureRecognizer.translation(in: missionControlTab)
            gestureRecognizer.view?.center = CGPoint(x: (gestureRecognizer.view?.center.x)!, y: max(0.85*DisplayUtility.screenWidth,(gestureRecognizer.view?.center.y)! + translation.y))
            gestureRecognizer.setTranslation(CGPoint.zero, in: missionControlTab)
        } else if gestureRecognizer.state == .ended {
            print(missionControlTab.frame.origin.y)
            if missionControlTab.frame.origin.y > 0.93*DisplayUtility.screenHeight {
                UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
                    self.missionControlTab.frame.origin.y = 0.95*DisplayUtility.screenHeight
                    self.missionControlFilters.frame.origin.y = DisplayUtility.screenHeight
                })
            } else if missionControlTab.frame.origin.y > 0.75*DisplayUtility.screenHeight {
                UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
                    self.missionControlTab.frame.origin.y = 0.85*DisplayUtility.screenHeight
                    self.missionControlFilters.frame.origin.y = 0.9*DisplayUtility.screenHeight
                })
            } else {//if missionControlTab.frame.origin.y > 0.9*DisplayUtility.screenHeight {
                UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
                    self.missionControlTab.frame.origin.y = 0.55*DisplayUtility.screenHeight
                })
            }
        }
    }

    func addGestureRecognizer(gestureRecognizer: UIPanGestureRecognizer) {
        missionControlTab.addGestureRecognizer(gestureRecognizer)
    }
    
}
