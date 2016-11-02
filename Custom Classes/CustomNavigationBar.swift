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

class CustomNavigationBar {
    
    let navBar = UINavigationBar()
    let navItem = UINavigationItem()
    var classRightBarButton = UIButton()
    
    func createCustomNavigationBar (view: UIView, leftBarButtonIcon: String?, leftBarButtonSelectedIcon: String?, leftBarButton: UIButton?, rightBarButtonIcon: String?, rightBarButtonSelectedIcon: String?, rightBarButton: UIButton?, title: String?){
        navBar.frame = CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: 0.11*DisplayUtility.screenHeight)
        navBar.barStyle = .black
        navBar.barTintColor = DisplayUtility.necterGray
        
        let maskPath = UIBezierPath(roundedRect: navBar.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 10.0, height: 10.0))
        let navBarShape = CAShapeLayer()
        navBarShape.path = maskPath.cgPath
        navBar.layer.mask = navBarShape
        
        let shadowView = UIView(frame: navBar.frame)
        shadowView.backgroundColor = UIColor.lightGray
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.7
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
        shadowView.layer.shadowRadius = 10
        shadowView.layer.shouldRasterize = true
        view.addSubview(shadowView)
        
        if leftBarButtonIcon != nil {
            let leftBarButtonIconImage = UIImage(named: leftBarButtonIcon!)
            leftBarButton?.setImage(leftBarButtonIconImage, for: .normal)
            if leftBarButtonSelectedIcon != nil {
                let leftBarButtonSelectedIconImage = UIImage(named: leftBarButtonSelectedIcon!)
                leftBarButton?.setImage(leftBarButtonSelectedIconImage, for: .highlighted)
                leftBarButton?.setImage(leftBarButtonSelectedIconImage, for: .selected)
            }
            leftBarButton?.frame = CGRect(x: 0, y: 0, width: 0.085*DisplayUtility.screenWidth, height: 0.085*DisplayUtility.screenWidth)
            leftBarButton?.contentMode = UIViewContentMode.scaleAspectFill
            leftBarButton?.clipsToBounds = true
            let leftBarButtonItem = UIBarButtonItem(customView: leftBarButton!)
            navItem.leftBarButtonItem = leftBarButtonItem
        }
        
        if rightBarButtonIcon != nil && rightBarButton != nil {
            let rightBarButtonIconImage = UIImage(named: rightBarButtonIcon!)
            rightBarButton?.setImage(rightBarButtonIconImage, for: .normal)
            if rightBarButtonSelectedIcon != nil {
                let rightBarButtonSelectedIconImage = UIImage(named: rightBarButtonSelectedIcon!)
                rightBarButton?.setImage(rightBarButtonSelectedIconImage, for: .highlighted)
                rightBarButton?.setImage(rightBarButtonSelectedIconImage, for: .selected)
            }
            rightBarButton?.frame = CGRect(x: 0, y: 0, width: 0.085*DisplayUtility.screenWidth, height: 0.085*DisplayUtility.screenWidth)
            rightBarButton?.contentMode = UIViewContentMode.scaleAspectFill
            rightBarButton?.clipsToBounds = true
            let rightBarButtonItem = UIBarButtonItem(customView: rightBarButton!)
            navItem.rightBarButtonItem = rightBarButtonItem
            
            classRightBarButton = rightBarButton!
        }
        
        navBar.setItems([navItem], animated: false)
        
        
        //setting the navBar title
        let navBarTitleView = UIView()
        navBarTitleView.frame = CGRect(x: 0, y: 0, width: 0.06*DisplayUtility.screenWidth, height: 0.06*DisplayUtility.screenHeight)
        //let titleImageView = UIImageView(image: UIImage(named: "Profile_Icon_Yellow"))
        let titleText = UILabel()
        titleText.text = "Profile"
        //titleImageView.frame = CGRect(x: 0, y: 0, width: 0.06*DisplayUtility.screenHeight, height: 0.06*DisplayUtility.screenHeight)
        //titleImageView.contentMode = UIViewContentMode.scaleAspectFill
        //titleImageView.clipsToBounds = true
        //navBarTitleView.addSubview(titleText)
        //navBar.topItem?.titleView = navBarTitleView
        navBar.topItem?.title = title
        navBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Verdana", size: 30)!, NSForegroundColorAttributeName: DisplayUtility.necterYellow]
        
        view.addSubview(navBar)

        

    }
    
    
    func updateRightBarButton(newIcon: String, newSelectedIcon: String?) {
        classRightBarButton.setImage(UIImage(named: newIcon), for: UIControlState())
        if newSelectedIcon != nil {
            classRightBarButton.setImage(UIImage(named: newSelectedIcon!), for: .highlighted)
            classRightBarButton.setImage(UIImage(named: newSelectedIcon!), for: .selected)
        }
        navItem.rightBarButtonItem = UIBarButtonItem(customView: self.classRightBarButton)
        navBar.setItems([self.navItem], animated: false)

    }

}
