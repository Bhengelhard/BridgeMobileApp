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
import Parse

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
                leftBarButton?.frame = CGRect(x: 0.02525*DisplayUtility.screenWidth, y: 0.04633*DisplayUtility.screenHeight, width: 0.1*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenHeight)
            } else {
                leftBarButton?.frame = CGRect(x: 0.02525*DisplayUtility.screenWidth, y: 0.04633*DisplayUtility.screenHeight, width: 0.1*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenWidth)
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
                rightBarButton?.frame = CGRect(x: 0.87475*DisplayUtility.screenWidth, y: 0.04633*DisplayUtility.screenHeight, width: 0.1*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenWidth)
            } else if rightBarButtonIcon == "Leave_Conversation_Gray"{
                rightImageView.frame = CGRect(x: 0.92155*DisplayUtility.screenWidth, y: 0.04633*DisplayUtility.screenHeight, width: 0.0532*DisplayUtility.screenWidth, height: 0.0532*DisplayUtility.screenWidth)
                rightBarButton?.frame = CGRect(x: 0.87475*DisplayUtility.screenWidth, y: 0.04633*DisplayUtility.screenHeight, width: 0.1*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenWidth)
            } else {
                rightBarButton?.frame = CGRect(x: 0.87475*DisplayUtility.screenWidth, y: 0.04633*DisplayUtility.screenHeight, width: 0.1*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenWidth)
                rightImageView.frame = CGRect(x: 0.87475*DisplayUtility.screenWidth, y: 0.04633*DisplayUtility.screenHeight, width: 0.1*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenWidth)
            }
            rightBarButton?.contentMode = UIViewContentMode.scaleAspectFill
            rightBarButton?.clipsToBounds = true
            
            view.addSubview(rightBarButton!)
            view.addSubview(rightImageView)
        }
        
        //setting the navBar title
        if let titleText = title {
            if titleText == "necter" {
                //Adding the title as a gradient text
                let font = UIFont(name: "Verdana", size: 48)
                let titleFrame = CGRect(x: 0, y: 0.04633*DisplayUtility.screenHeight, width: 0.5*DisplayUtility.screenWidth, height: 0.105*DisplayUtility.screenWidth)
                let label = DisplayUtility.gradientLabel(text: titleText, frame: titleFrame, font: font!)
                label.center.x = view.center.x
                label.center.y = rightBarButton!.center.y
                label.textAlignment = NSTextAlignment.center
                view.addSubview(label)
//                //Adding the title as an imageView
//                let titleFrame = CGRect(x: 0, y: 0.04633*DisplayUtility.screenHeight, width: 0.3*DisplayUtility.screenWidth, height: 0.04*DisplayUtility.screenHeight)
//                let imageView = UIImageView(frame: titleFrame)
//                imageView.center.x = view.center.x
//                imageView.image = #imageLiteral(resourceName: "Necter_Navbar_Logo")
//                view.addSubview(imageView)
            } else {
                //Adding the title as a gradient text
                let font = UIFont(name: "Verdana", size: 28)
                let titleFrame = CGRect(x: 0, y: 0.04633*DisplayUtility.screenHeight, width: 0.5*DisplayUtility.screenWidth, height: 0.04*DisplayUtility.screenHeight)
                let label = DisplayUtility.gradientLabel(text: titleText, frame: titleFrame, font: font!)
                label.center.x = view.center.x
                label.textAlignment = NSTextAlignment.center
                view.addSubview(label)
            }
        }
        
    }
    
    
    
    func updateRightBarButton(newIcon: String, newSelectedIcon: String?) {
        print("updating right bar button icon")
        classRightBarButton.setImage(UIImage(named: newIcon), for: UIControlState())
    }

}
