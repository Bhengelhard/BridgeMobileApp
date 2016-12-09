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

class CustomNavigationBar: UINavigationBar {
    
    //let navBar = UINavigationBar()
    let navItem = UINavigationItem()
    var classRightBarButton = UIButton()
    
    func createCustomNavigationBar (view: UIView, leftBarButtonIcon: String?, leftBarButtonSelectedIcon: String?, leftBarButton: UIButton?, rightBarButtonIcon: String?, rightBarButtonSelectedIcon: String?, rightBarButton: UIButton?, title: String?){
        self.frame = CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: 0.105*DisplayUtility.screenHeight)
        self.barStyle = .black
        //self.barStyle = UIBarStyle.
        //self.UIStatusBarStyle.lightContent
        self.isTranslucent = true
        //navBar.barTintColor = DisplayUtility.necterGray
        
        //let displayUtility = DisplayUtility()
        //navBar = displayUtility.setBlurredView(viewToBlur: navBar as UIView) as! UINavigationBar
        self.backgroundColor = DisplayUtility.necterGray
        //view.addSubview(self)
        
        /*let maskPath = UIBezierPath(roundedRect: navBar.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 10.0, height: 10.0))
        let navBarShape = CAShapeLayer()
        navBarShape.path = maskPath.cgPath
        navBar.layer.mask = navBarShape*/
        
        let shadowView = UIView(frame: self.frame)
        shadowView.backgroundColor = UIColor.white
        shadowView.layer.borderWidth = 0
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.8
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        shadowView.layer.shadowRadius = 2
        view.addSubview(shadowView)
        
        //Setting the navBar buttons
        if leftBarButtonIcon != nil {
            let leftBarButtonIconImage = UIImage(named: leftBarButtonIcon!)
            leftBarButton?.setImage(leftBarButtonIconImage, for: .normal)
//            if leftBarButtonSelectedIcon != nil {
//                let leftBarButtonSelectedIconImage = UIImage(named: leftBarButtonSelectedIcon!)
//                //leftBarButton?.setImage(leftBarButtonSelectedIconImage, for: .highlighted)
//                //leftBarButton?.setImage(leftBarButtonSelectedIconImage, for: .selected)
//            }
            if leftBarButtonIcon == "Right_Arrow" || leftBarButtonIcon == "Left_Arrow" {
                leftBarButton?.frame = CGRect(x: 0, y: 0, width: 0.0353*DisplayUtility.screenWidth, height: 0.0385*DisplayUtility.screenHeight)
            } else {
                leftBarButton?.frame = CGRect(x: 0, y: 0, width: 0.085*DisplayUtility.screenWidth, height: 0.085*DisplayUtility.screenWidth)
            }
            leftBarButton?.contentMode = UIViewContentMode.scaleAspectFill
            leftBarButton?.clipsToBounds = true
            let leftBarButtonItem = UIBarButtonItem(customView: leftBarButton!)
            navItem.leftBarButtonItem = leftBarButtonItem
        }
        if rightBarButtonIcon != nil && rightBarButton != nil {
            let rightBarButtonIconImage = UIImage(named: rightBarButtonIcon!)
            rightBarButton?.setImage(rightBarButtonIconImage, for: .normal)
//            if rightBarButtonSelectedIcon != nil {
//                let rightBarButtonSelectedIconImage = UIImage(named: rightBarButtonSelectedIcon!)
//                //rightBarButton?.setImage(rightBarButtonSelectedIconImage, for: .highlighted)
//                //rightBarButton?.setImage(rightBarButtonSelectedIconImage, for: .selected)
//            }
            if rightBarButtonIcon == "Right_Arrow" || rightBarButtonIcon == "Left_Arrow" {
                rightBarButton?.frame = CGRect(x: 0, y: 0, width: 0.0353*DisplayUtility.screenWidth, height: 0.0385*DisplayUtility.screenHeight)
            } else {
                rightBarButton?.frame = CGRect(x: 0, y: 0, width: 0.085*DisplayUtility.screenWidth, height: 0.085*DisplayUtility.screenWidth)
            }
            
            rightBarButton?.contentMode = UIViewContentMode.scaleAspectFill
            rightBarButton?.clipsToBounds = true
            let rightBarButtonItem = UIBarButtonItem(customView: rightBarButton!)
            navItem.rightBarButtonItem = rightBarButtonItem
            
            classRightBarButton = rightBarButton!
        }
        self.setItems([navItem], animated: false)
        
        
        //setting the navBar title
        let navBarTitleView = UIView()
        navBarTitleView.frame = CGRect(x: 0, y: 0, width: 0.5*DisplayUtility.screenWidth, height: 0.06*DisplayUtility.screenHeight)
        if let titleText = title {
            let font = UIFont(name: "Verdana", size: 28)
            let label = DisplayUtility.gradientLabel(text: titleText, frame: navBarTitleView.frame, font: font!)
            navBarTitleView.addSubview(label)
        }
        self.topItem?.titleView = navBarTitleView
        
        view.addSubview(self)
        view.bringSubview(toFront: self)
    }
    
    
    
    func updateRightBarButton(newIcon: String, newSelectedIcon: String?) {
        
        classRightBarButton.setImage(UIImage(named: newIcon), for: UIControlState())
        //if newSelectedIcon != nil {
            //classRightBarButton.setImage(UIImage(named: newSelectedIcon!), for: .highlighted)
            //classRightBarButton.setImage(UIImage(named: newSelectedIcon!), for: .selected)
        //}
        navItem.rightBarButtonItem = UIBarButtonItem(customView: self.classRightBarButton)
        self.setItems([self.navItem], animated: false)

    }

}
