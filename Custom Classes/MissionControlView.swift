//
//  MissionControlView
//  MyBridgeApp
//
//  Created by Blake Engelhard on 11/2/16.
//  Copyright © 2016 BHE Ventures LLC. All rights reserved.
//

import UIKit

class MissionControlView {
    
    let displayUtility = DisplayUtility()
    let customKeyboard = CustomKeyboard()
    var currentView = UIView()
    
    
    var tabView = UIView()
    let tabViewButton = UIButton()
    var filtersView = UIView()
    var blurOverViewController = UIView()
    
    let businessButton = UIButton()
    let loveButton = UIButton()
    let friendshipButton = UIButton()

    func createTabView (view: UIView) {
        currentView = view
        tabView.frame = CGRect(x:0, y: 0.95*DisplayUtility.screenHeight, width: 0.4*DisplayUtility.screenWidth, height: 0.051*DisplayUtility.screenHeight)
        tabView.center.x = currentView.center.x
        tabView.layer.borderWidth = 0
        
        let maskPath = UIBezierPath(roundedRect: tabView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 5.0, height: 5.0))
        let tabViewShape = CAShapeLayer()
        tabViewShape.path = maskPath.cgPath
        tabView.layer.mask = tabViewShape
        
        displayUtility.setBlurredView(view: currentView, viewToBlur: tabView)
        view.addSubview(tabView)
        
        tabViewButton.addTarget(self, action: #selector(showFiltersView(_:)), for: .touchUpInside)
        tabViewButton.frame = CGRect(x: 0, y: 0, width: tabView.frame.width, height: tabView.frame.height)//tabView.frame
        tabViewButton.setTitle("^", for: .normal)
        tabView.addSubview(tabViewButton)
        
        print("createTabView")
        
    }
    
    @objc func showFiltersView(_ sender: UIButton) {
        print("showMissionControlFilters")
        businessButton.addTarget(self, action: #selector(businessTapped(_:)), for: .touchUpInside)
        loveButton.addTarget(self, action: #selector(loveTapped(_:)), for: .touchUpInside)
        friendshipButton.addTarget(self, action: #selector(friendshipTapped(_:)), for: .touchUpInside)
        
        tabViewButton.removeTarget(self, action: #selector(showFiltersView(_:)), for: .touchUpInside)
        tabViewButton.addTarget(self,action:#selector(showPostView(_:)), for: .touchUpInside)
        
        filtersView.frame = CGRect(x: 0, y: DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenHeight)
        currentView.addSubview(filtersView)
        displayUtility.setBlurredView(view: currentView, viewToBlur: filtersView)
        
        let maskPath = UIBezierPath(roundedRect: filtersView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 2.0, height: 2.0))
        let filtersViewShape = CAShapeLayer()
        filtersViewShape.path = maskPath.cgPath
        filtersView.layer.mask = filtersViewShape
        
        //adding the filterButtons
        businessButton.addTarget(self, action: #selector(businessTapped(_:)), for: .touchUpInside)
        businessButton.setImage(UIImage(named: "Business_Icon_Gray"), for: UIControlState())
        businessButton.setImage(UIImage(named:  "Business_Icon_Blue"), for: .selected)
        businessButton.tag = 1
        
        loveButton.addTarget(self, action: #selector(loveTapped(_:)), for: .touchUpInside)
        loveButton.setImage(UIImage(named: "Love_Icon_Gray"), for: UIControlState())
        loveButton.setImage(UIImage(named: "Love_Icon_Red"), for: .selected)
        loveButton.tag = 2
        
        friendshipButton.addTarget(self, action: #selector(friendshipTapped(_:)), for: .touchUpInside)
        friendshipButton.setImage(UIImage(named: "Friendship_Icon_Gray"), for: UIControlState())
        friendshipButton.setImage(UIImage(named:  "Friendship_Icon_Green"), for: .selected)
        friendshipButton.tag = 3
        
        businessButton.frame.size = CGSize(width: 0.1*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenWidth)
        businessButton.center = CGPoint(x: filtersView.center.x - 0.2*DisplayUtility.screenWidth, y: filtersView.frame.height/2)
        loveButton.frame.size = CGSize(width: 0.1*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenWidth)
        loveButton.center = CGPoint(x: filtersView.center.x, y: filtersView.frame.height/2)
        friendshipButton.frame.size = CGSize(width: 0.1*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenWidth)
        friendshipButton.center = CGPoint(x: filtersView.center.x + 0.2*DisplayUtility.screenWidth, y: filtersView.frame.height/2)
        
        filtersView.addSubview(businessButton)
        filtersView.addSubview(loveButton)
        filtersView.addSubview(friendshipButton)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            self.tabView.frame.origin.y = 0.85*DisplayUtility.screenHeight
            self.filtersView.frame.origin.y = 0.9*DisplayUtility.screenHeight
        })
        if tabView.frame.origin.y == 0.45*DisplayUtility.screenHeight {
            customKeyboard.resign()
        }
        
        blurOverViewController.removeFromSuperview()
    }
    
    @objc func showPostView(_ sender: UIButton) {
        print("showMissionControlPostStatus")
        //creating this here with intention to move it over to CustomKeyboard so the keyboard, with text field and button can be reused
        //add screen over back
        //disable table and search bar
        //if user clicks on back screen, the mission control will close
        //if user clicks return, the mission control will close
        
        blurOverViewController.frame = CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight)
        blurOverViewController.alpha = 0
        displayUtility.setBlurredView(view: currentView, viewToBlur: blurOverViewController)
        //currentView.insertSubview(blurOverViewController, belowSubview: tabView)
        
        
        tabViewButton.removeTarget(self, action: #selector(showPostView(_:)), for: .touchUpInside)
        tabViewButton.addTarget(self,action:#selector(closeMissionControl(_:)), for: .touchUpInside)
        
        
        //add custom keyboard
        customKeyboard.display(view: currentView)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            self.tabView.frame.origin.y = 0.45*DisplayUtility.screenHeight
            self.filtersView.frame.origin.y = 0.5*DisplayUtility.screenHeight
            self.blurOverViewController.alpha = 1.0
        })
    }
    
    @objc func closeMissionControl(_ sender: UIButton) {
        customKeyboard.resign()
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            self.tabView.frame.origin.y = 0.95*DisplayUtility.screenHeight
            self.filtersView.frame.origin.y = DisplayUtility.screenHeight
        })
        
        blurOverViewController.removeFromSuperview()
        filtersView.removeFromSuperview()
        tabViewButton.removeTarget(self, action: #selector(closeMissionControl(_:)), for: .touchUpInside)
        tabViewButton.addTarget(self,action:#selector(showFiltersView(_:)), for: .touchUpInside)
    }

    @objc func businessTapped(_ sender: UIButton) {
        toggleFilters(type: "Business")
        //messagesViewController.filtersTapped(type: "Business", businessButton: businessButton, loveButton: loveButton, friendshipButton: friendshipButton)
    }
    @objc func loveTapped(_ sender: UIButton) {
        toggleFilters(type: "Love")
        //messagesViewController.filtersTapped(type: "Love", businessButton: businessButton, loveButton: loveButton, friendshipButton: friendshipButton)
    }
    @objc func friendshipTapped(_ sender: UIButton) {
        toggleFilters(type: "Friendship")
        //messagesViewController.filtersTapped(type: "Friendship", businessButton: businessButton, loveButton: loveButton, friendshipButton: friendshipButton)
    }
    
    func toggleFilters(type: String) {
            //updating which toolbar Button is selected
        if (type == "Business" && !businessButton.isSelected) {
            businessButton.isSelected = true
            loveButton.isSelected = false
            friendshipButton.isSelected = false
        } else if (type == "Love" && !loveButton.isSelected) {
            loveButton.isSelected = true
            businessButton.isSelected = false
            friendshipButton.isSelected = false
        } else if (type == "Friendship" && !friendshipButton.isSelected) {
            friendshipButton.isSelected = true
            businessButton.isSelected = false
            loveButton.isSelected = false
        } else {
            businessButton.isSelected = false
            loveButton.isSelected = false
            friendshipButton.isSelected = false
        }
        
        if tabView.frame.origin.y > 0.95*DisplayUtility.screenHeight {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "filtersTapped"), object: nil)
        }
        
    }
    
    func drag(gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            let translation = gestureRecognizer.translation(in: tabView)
            gestureRecognizer.view?.center = CGPoint(x: (gestureRecognizer.view?.center.x)!, y: max(0.85*DisplayUtility.screenWidth,(gestureRecognizer.view?.center.y)! + translation.y))
            gestureRecognizer.setTranslation(CGPoint.zero, in: tabView)
        } else if gestureRecognizer.state == .ended {
            print(tabView.frame.origin.y)
            if tabView.frame.origin.y > 0.93*DisplayUtility.screenHeight {
                UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
                    self.tabView.frame.origin.y = 0.95*DisplayUtility.screenHeight
                    self.filtersView.frame.origin.y = DisplayUtility.screenHeight
                })
            } else if tabView.frame.origin.y > 0.75*DisplayUtility.screenHeight {
                UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
                    self.tabView.frame.origin.y = 0.85*DisplayUtility.screenHeight
                    self.filtersView.frame.origin.y = 0.9*DisplayUtility.screenHeight
                })
            } else {//if tabView.frame.origin.y > 0.9*DisplayUtility.screenHeight {
                UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
                    self.tabView.frame.origin.y = 0.55*DisplayUtility.screenHeight
                })
            }
        }
    }

    func addGestureRecognizer(gestureRecognizer: UIPanGestureRecognizer) {
        tabView.addGestureRecognizer(gestureRecognizer)
    }
    
    func whichFilter() -> String {
        if businessButton.isSelected {
            return "Business"
        } else if loveButton.isSelected {
            return "Love"
        } else if friendshipButton.isSelected {
            return "Friendship"
        } else {
            return "All Types"
        }
    }
    
    
    /*let shadowView = UIView(frame: tabView.frame)
     shadowView.backgroundColor = UIColor.lightGray
     shadowView.layer.masksToBounds = false
     shadowView.layer.shadowColor = UIColor.black.cgColor
     shadowView.layer.shadowOpacity = 0.7
     shadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
     shadowView.layer.shadowRadius = 10
     shadowView.layer.shouldRasterize = true
     view.addSubview(shadowView)*/
    
}
