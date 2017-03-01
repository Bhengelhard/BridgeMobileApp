//
//  CustomNavigationBar.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 11/2/16.
//  Copyright © 2016 BHE Ventures LLC. All rights reserved.
//
//  This class is for creating and updating the navigation bar
//

import UIKit

/// Navigation Bar Object for the MyProfileViewController
class NecterNavigationBar: UINavigationBar {
    
    let rightButton = UIButton()
    let leftButton = UIButton()
    let navItem = UINavigationItem()
    let titleImageView = UIImageView()
    
    init() {
        super.init(frame: CGRect())
        
        // Setting the color of the navigation bar to white
        self.backgroundColor = UIColor.white
        
        // Removing line at the bottom of the navigation bar
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        
        // Setting the navigation Bar Title Image
        titleImageView.frame.size = CGSize(width: 40, height: 40)
        titleImageView.contentMode = .scaleAspectFit
        
        // Setting the right Bar Button Item
        rightButton.titleLabel?.font = Constants.Fonts.bold16
        rightButton.frame.size = CGSize(width: 30, height: 30)
        let rightItem = UIBarButtonItem(customView: rightButton)
        navItem.rightBarButtonItem = rightItem
        
        // Setting the left Bar Button Item
        leftButton.titleLabel?.font = Constants.Fonts.bold16
        leftButton.frame.size = CGSize(width: 30, height: 30)
        let leftItem = UIBarButtonItem(customView: leftButton)
        navItem.leftBarButtonItem = leftItem
        
        // 
        titleTextAttributes = [NSFontAttributeName: Constants.Fonts.light24]
        // Adding the navigation items to the navigation bar
        self.setItems([navItem], animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func dismissViewController(_ sender
    
}

class CustomNavigationBar: UIView {

    var classRightBarButton = UIButton()
    var rightImageView = UIImageView()

    func createCustomNavigationBar (view: UIView, leftBarButtonIcon: String?, leftBarButtonSelectedIcon: String?, leftBarButton: UIButton?, rightBarButtonIcon: String?, rightBarButtonSelectedIcon: String?, rightBarButton: UIButton?, title: String?){
        self.frame = CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: 0.105*DisplayUtility.screenHeight)
        self.backgroundColor = UIColor.clear
        
        //Setting the navBar buttons
        if leftBarButtonIcon != nil && leftBarButton != nil {
            let leftBarButtonIconImage = UIImage(named: leftBarButtonIcon!)
            let leftImageView = UIImageView()
            leftImageView.image = leftBarButtonIconImage
            //leftBarButton?.setImage(leftBarButtonIconImage, for: .normal)
            if leftBarButtonIcon == "Right_Arrow" || leftBarButtonIcon == "Left_Arrow" {
                leftImageView.frame = CGRect(x: 0.02525*DisplayUtility.screenWidth, y: 0.05*DisplayUtility.screenHeight, width: 0.0532*DisplayUtility.screenWidth, height: 0.02181*DisplayUtility.screenHeight)
                leftBarButton?.frame = CGRect(x: 0.02525*DisplayUtility.screenWidth, y: 0.04633*DisplayUtility.screenHeight, width: 0.15*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenHeight)
            } else {
                leftBarButton?.frame = CGRect(x: 0.02525*DisplayUtility.screenWidth, y: 0.04633*DisplayUtility.screenHeight, width: 0.15*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenWidth)
                leftImageView.frame = CGRect(x: 0.02525*DisplayUtility.screenWidth, y: 0.04633*DisplayUtility.screenHeight, width: 0.1*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenWidth)
            }
            leftBarButton?.contentMode = UIViewContentMode.scaleAspectFill
            leftBarButton?.clipsToBounds = true
            
            view.addSubview(leftBarButton!)
            view.addSubview(leftImageView)
        }
        if rightBarButtonIcon != nil && rightBarButton != nil {
            classRightBarButton = rightBarButton!
            let rightBarButtonIconImage = UIImage(named: rightBarButtonIcon!)
            rightImageView.image = rightBarButtonIconImage
//            rightBarButton?.setImage(rightBarButtonIconImage, for: .normal)
            if rightBarButtonIcon == "Right_Arrow" || rightBarButtonIcon == "Left_Arrow" {
                rightImageView.frame = CGRect(x: 0.92155*DisplayUtility.screenWidth, y: 0.05*DisplayUtility.screenHeight, width: 0.0532*DisplayUtility.screenWidth, height: 0.02181*DisplayUtility.screenHeight)
                rightBarButton?.frame = CGRect(x: 0.87475*DisplayUtility.screenWidth, y: 0.04633*DisplayUtility.screenHeight, width: 0.15*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenWidth)
            } else if rightBarButtonIcon == "Leave_Conversation_Gray"{
                rightImageView.frame = CGRect(x: 0.92155*DisplayUtility.screenWidth, y: 0.04633*DisplayUtility.screenHeight, width: 0.0532*DisplayUtility.screenWidth, height: 0.0532*DisplayUtility.screenWidth)
                rightBarButton?.frame = CGRect(x: 0.87475*DisplayUtility.screenWidth, y: 0.04633*DisplayUtility.screenHeight, width: 0.15*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenWidth)
            } else {
                rightBarButton?.frame = CGRect(x: 0.87475*DisplayUtility.screenWidth, y: 0.04633*DisplayUtility.screenHeight, width: 0.15*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenWidth)
                rightImageView.frame = CGRect(x: 0.87475*DisplayUtility.screenWidth, y: 0.04633*DisplayUtility.screenHeight, width: 0.1*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenWidth)
            }
            rightBarButton?.contentMode = UIViewContentMode.scaleAspectFill
            rightBarButton?.clipsToBounds = true
            
            view.addSubview(rightBarButton!)
            view.addSubview(rightImageView)
        }
        
        // Setting the navBar title
        if let titleText = title {
            if titleText == "necter" {
                
                
                // Adding the title as a gradient text
                let font = UIFont(name: "Verdana", size: 40)
                var titleFrame = CGRect(x: 0, y: 0.04633*DisplayUtility.screenHeight, width: 0.5*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenWidth)
                // Placing the navbar title in line with the bottom of the rightBarButton
                if let barButton = rightBarButton {
                    titleFrame.origin.y = barButton.frame.minY //- titleFrame.size.height
                }
                
                let label = DisplayUtility.gradientLabel(text: titleText, frame: titleFrame, font: font!)
                label.center.x = view.center.x
                //label.center.y = rightBarButton!.center.y
                label.textAlignment = NSTextAlignment.center
                view.addSubview(label)
            } else if titleText == "Inbox" {
                let font = UIFont(name: "BentonSans-Light", size: 24)
                let titleFrame = CGRect(x: 0, y: 0.04633*DisplayUtility.screenHeight, width: 0.5*DisplayUtility.screenWidth, height: 0.04*DisplayUtility.screenHeight)
                let label = UILabel(frame: titleFrame)
                label.text = titleText
                label.textColor = UIColor.black
                label.font = font
                label.adjustsFontSizeToFitWidth = true
                label.textAlignment = NSTextAlignment.center
                label.center.x = view.center.x
                view.addSubview(label)
            } else {
                let font = UIFont(name: "BentonSans-Light", size: 21)
                let titleFrame = CGRect(x: 0, y: 0.04633*DisplayUtility.screenHeight, width: 0.5*DisplayUtility.screenWidth, height: 0.04*DisplayUtility.screenHeight)
                let label = UILabel(frame: titleFrame)
                label.text = titleText
                label.textColor = UIColor.black
                label.font = font
                label.adjustsFontSizeToFitWidth = true
                label.textAlignment = NSTextAlignment.center
                label.center.x = view.center.x
                view.addSubview(label)
            }
        }
        
    }
    
    
    
    func updateRightBarButton(newIcon: String, newSelectedIcon: String?) {
        print("updating right bar button icon")
        rightImageView.image = UIImage(named: newIcon)
    }

}
