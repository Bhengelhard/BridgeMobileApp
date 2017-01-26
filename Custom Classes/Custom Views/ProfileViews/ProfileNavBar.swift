//
//  ProfileNavBar.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 1/26/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class ProfileNavBar: UIView {
    
    // action functions
    let leftButtonFunc: ((UIButton) -> Void)?
    let rightButtonFunc: ((UIButton) -> Void)?
    
    let mainLabel = UILabel()
    let subLabel = UILabel()
    
    init(leftButtonImageView: UIImageView?, leftButtonFunc: ((UIButton) -> Void)? = nil, rightButtonImageView: UIImageView?, rightButtonFunc: ((UIButton) -> Void)? = nil, mainText: String = "", mainTextColor: UIColor = .black, subText: String = "", subTextColor: UIColor = .black) {
        self.leftButtonFunc = leftButtonFunc
        self.rightButtonFunc = rightButtonFunc
        
        super.init(frame: .zero)
        
        // Formatting image for left button
        if let leftButtonImageView = leftButtonImageView {
            leftButtonImageView.frame = CGRect(x: 0.044*DisplayUtility.screenWidth, y: 0, width: leftButtonImageView.frame.width, height: leftButtonImageView.frame.height)
            leftButtonImageView.center.y = 0.0537*DisplayUtility.screenHeight
            addSubview(leftButtonImageView)
            
            // Formatting left button
            let leftButton = UIButton()
            leftButton.frame = CGRect(x: leftButtonImageView.frame.minX - 0.02*DisplayUtility.screenWidth, y: leftButtonImageView.frame.minY - 0.02*DisplayUtility.screenWidth, width: leftButtonImageView.frame.width + 0.04*DisplayUtility.screenWidth, height: leftButtonImageView.frame.height + 0.04*DisplayUtility.screenWidth)
            leftButton.showsTouchWhenHighlighted = false
            leftButton.addTarget(self, action: #selector(leftButtonPressed(_:)), for: .touchUpInside)
            addSubview(leftButton)
        }
        
        // Formatting image for right button
        if let rightButtonImageView = rightButtonImageView {
            rightButtonImageView.frame = CGRect(x: (1-0.044)*DisplayUtility.screenWidth - rightButtonImageView.frame.width, y: 0, width: rightButtonImageView.frame.width, height: rightButtonImageView.frame.height)
            rightButtonImageView.center.y = 0.0537*DisplayUtility.screenHeight
            addSubview(rightButtonImageView)
            
            // Formatting right button
            let rightButton = UIButton()
            rightButton.frame = CGRect(x: rightButtonImageView.frame.minX - 0.02*DisplayUtility.screenWidth, y: rightButtonImageView.frame.minY - 0.02*DisplayUtility.screenWidth, width: rightButtonImageView.frame.width + 0.04*DisplayUtility.screenWidth, height: rightButtonImageView.frame.height + 0.04*DisplayUtility.screenWidth)
            rightButton.showsTouchWhenHighlighted = false
            rightButton.addTarget(self, action: #selector(rightButtonPressed(_:)), for: .touchUpInside)
            addSubview(rightButton)
        }
        
        // Creating main label
        mainLabel.text = mainText
        mainLabel.textColor = mainTextColor
        mainLabel.textAlignment = .center
        mainLabel.font = UIFont(name: "BentonSans-Light", size: 21)
        mainLabel.sizeToFit()
        mainLabel.frame = CGRect(x: 0, y: 0.07969*DisplayUtility.screenHeight, width: mainLabel.frame.width, height: mainLabel.frame.height)
        mainLabel.center.x = DisplayUtility.screenWidth / 2
        addSubview(mainLabel)
        
        
        // Creating sub label
        subLabel.text = subText
        subLabel.textColor = subTextColor
        subLabel.textAlignment = .center
        subLabel.font = UIFont(name: "BentonSans-Light", size: 12)
        subLabel.sizeToFit()
        subLabel.frame = CGRect(x: 0, y: mainLabel.frame.maxY + 0.0075*DisplayUtility.screenHeight, width: subLabel.frame.width, height: subLabel.frame.height)
        subLabel.center.x = DisplayUtility.screenWidth / 2
        addSubview(subLabel)
        
        frame = CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: mainLabel.frame.maxY + 0.045*DisplayUtility.screenHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func leftButtonPressed(_ sender: UIButton) {
        if let leftButtonFunc = leftButtonFunc {
            leftButtonFunc(sender)
        }
    }
    
    func rightButtonPressed(_ sender: UIButton) {
        if let rightButtonFunc = rightButtonFunc {
            rightButtonFunc(sender)
        }
    }
    
    func updateMainLabel(mainText: String, mainTextColor: UIColor? = nil) {
        mainLabel.text = mainText
        if let mainTextColor = mainTextColor {
            mainLabel.textColor = mainTextColor
        }
        mainLabel.sizeToFit()
        mainLabel.frame = CGRect(x: 0, y: mainLabel.frame.minY, width: mainLabel.frame.width, height: mainLabel.frame.height)
        mainLabel.center.x = DisplayUtility.screenWidth / 2
    }
    
    func updateSubLabel(subText: String, subTextColor: UIColor? = nil) {
        subLabel.text = subText
        if let subTextColor = subTextColor {
            subLabel.textColor = subTextColor
        }
        subLabel.sizeToFit()
        subLabel.frame = CGRect(x: 0, y: subLabel.frame.minY, width: subLabel.frame.width, height: subLabel.frame.height)
        subLabel.center.x = DisplayUtility.screenWidth / 2
    }
}
