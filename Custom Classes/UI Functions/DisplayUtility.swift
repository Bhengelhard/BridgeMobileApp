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
    static let necterYellow = UIColor(red: 237/255, green: 203/255, blue: 116/255, alpha: 1.0)//UIColor(red: 255/255, green: 230/255, blue: 57/255, alpha: 1.0)
    static let businessBlue = UIColor(red: 36.0/255, green: 123.0/255, blue: 160.0/255, alpha: 1.0)
    static let loveRed = UIColor(red: 242.0/255, green: 95.0/255, blue: 92.0/255, alpha: 1.0)
    static let friendshipGreen = UIColor(red: 112.0/255, green: 193.0/255, blue: 179.0/255, alpha: 1.0)
    static let necterGray = UIColor(red: 76.0/255.0, green: 76.0/255.0, blue: 77.0/255.0, alpha: 1.0)
    
    //gradient colors
    static let color1 = UIColor(red: 247.0/255.0, green: 237.0/255.0, blue: 144.0/255.0, alpha: 1).cgColor
    static let color2 = UIColor(red: 255.0/255.0, green: 204.0/255.0, blue: 0.0/255.0, alpha: 1).cgColor
    static let color3 = UIColor(red: 243.0/255.0, green: 144.0/255.0, blue: 63.0/255.0, alpha: 1).cgColor
    static let color4 = UIColor(red: 237.0/255.0, green: 104.0/255.0, blue: 60.0/255.0, alpha: 1).cgColor
    static let color5 = UIColor(red: 233.0/255.0, green: 62.0/255.0, blue: 58.0/255.0, alpha: 1).cgColor
    
    
    static func getGradient() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [color1, color2, color3, color4, color5]
        gradientLayer.locations = [0.0, 0.25, 0.5, 0.75, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        return gradientLayer
    }
    
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
    func setBlurredView (viewToBlur: UIView) {
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
    
    //set the height of the text view based on its content
    func setViewHeightFromContent(view: UITextView) {
        let viewFixedWidth = view.frame.size.width
        let viewNewSize = view.sizeThatFits(CGSize(width: viewFixedWidth, height: CGFloat.greatestFiniteMagnitude))
        view.frame.size.height = viewNewSize.height
    }
    
}
