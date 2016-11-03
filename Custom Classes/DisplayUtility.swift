//
//  DisplayUtility.swift
//  MyBridgeApp
//
//  Created by Blake H. Engelhard on 10/13/16.
//  Copyright © 2016 BHE Ventures. All rights reserved.
//
//This class is meant as a helper class for displaying a message when there is no objects for the user on a viewController, for creating the buttons for different pages, and for revisiting Cards in the BridgeViewController as well as holding screenWidths, colors and other display objects that are commonly reused

import UIKit

class DisplayUtility {
    
    //static display properties
    //screen size
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    //necter colors
    //necter Colors
    static let necterYellow = UIColor(red: 255/255, green: 230/255, blue: 57/255, alpha: 1.0)
    static let businessBlue = UIColor(red: 36.0/255, green: 123.0/255, blue: 160.0/255, alpha: 1.0)
    static let loveRed = UIColor(red: 242.0/255, green: 95.0/255, blue: 92.0/255, alpha: 1.0)
    static let friendshipGreen = UIColor(red: 112.0/255, green: 193.0/255, blue: 179.0/255, alpha: 1.0)
    static let necterGray = UIColor(red: 80.0/255.0, green: 81.0/255.0, blue: 79.0/255.0, alpha: 1.0)
    
    //This is a helper function for the BridgeViewController to display a message when there are no more cards to display
    
    func displayNoMoreCards(view: UIView, businessButton: UIButton, loveButton: UIButton, friendshipButton: UIButton, displayNoMoreCardsLabel: UILabel?) {
        let labelFrame: CGRect = CGRect(x: 0, y: 0, width: 0.8*DisplayUtility.screenWidth, height: DisplayUtility.screenHeight * 0.2)//(0,0, 0.8*screenWidth,screenHeight * 0.2)
        let displayNoMoreCardsLabel = UILabel()
        displayNoMoreCardsLabel.frame = labelFrame
        displayNoMoreCardsLabel.numberOfLines = 0
        
        if businessButton.isEnabled == false {
            displayNoMoreCardsLabel.text = "You ran out of people to connect for business. Please check back tomorrow."
        } else if loveButton.isEnabled == false {
            displayNoMoreCardsLabel.text = "You ran out of people to connect for love. Please check back tomorrow."
        } else if friendshipButton.isEnabled == false {
            displayNoMoreCardsLabel.text = "You ran out of people to connect for friendship. Please check back tomorrow."
        } else {
            displayNoMoreCardsLabel.text = "You ran out of people to connect. Please check back tomorrow."
        }
        
        displayNoMoreCardsLabel.font = UIFont(name: "BentonSans", size: 20)
        displayNoMoreCardsLabel.textAlignment = NSTextAlignment.center
        displayNoMoreCardsLabel.center.y = view.center.y
        displayNoMoreCardsLabel.center.x = view.center.x
        
        //displayNoMoreCardsLabel!.layer.borderWidth = 2
        //displayNoMoreCardsLabel!.layer.borderColor = necterGray.CGColor
        //displayNoMoreCardsLabel!.layer.cornerRadius = 15
        
        view.addSubview(displayNoMoreCardsLabel)
        
    }
    
    //make displayNoMoreCards work and pass throughout the app
    
    //add functions using the buttons so that you don't have to pass anything to it
    
    //Add activity indicator design/function here with parameters of the frame of the activity indicator
    
    
    //setting a view to be blurred
    func setBlurredView (view: UIView, viewToBlur: UIView) {
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            viewToBlur.backgroundColor = UIColor.clear
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = viewToBlur.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            viewToBlur.addSubview(blurEffectView)
        } else {
            viewToBlur.backgroundColor = UIColor.black
        }
    }
    
}
