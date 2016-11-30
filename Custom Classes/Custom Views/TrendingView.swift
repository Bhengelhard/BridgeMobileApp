//
//  TrendingView.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 11/28/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class TrendingView: UIView {
    
    //Trending Views
    var top6Options = [Int: [Any]]()
    
    //TrendingOptionButtons
    let trendingOption0 = UIButton()
    let trendingOption1 = UIButton()
    let trendingOption2 = UIButton()
    let trendingOption3 = UIButton()
    let trendingOption4 = UIButton()
    let trendingOption5 = UIButton()
    
    //Parameters saved from MissionControlView
    var missionControlView: MissionControlView?
    var customKeyboard: CustomKeyboard?
    var trendingButton: UIButton?
    var dividingLine: UIView?

    override init (frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init () {
        self.init(frame: CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This is a fatal error message from CustomClasses/CustomViews/SwipeCard.swift")
    }

    //Setting the trending Options - pass through the MissionControlView and the customKeyboard
    func initialize(view: MissionControlView, keyboard: CustomKeyboard, button: UIButton, line: UIView) {
        //Setting global parameters
        missionControlView = view
        customKeyboard = keyboard
        trendingButton = button
        dividingLine = line
        
        self.frame.size = CGSize(width: (missionControlView?.frame.width)! /*categoriesView.frame.width*/, height: 0.1574*(missionControlView?.frame.height)!)
        self.isHidden = true
        missionControlView?.addSubview(self)
        
        trendingOption0.frame = CGRect(x: 0.02824*(missionControlView?.frame.width)!, y: 0, width: 0.465*(missionControlView?.frame.width)!, height: 0.04558*(missionControlView?.frame.height)!)
        trendingOption0.layer.borderWidth = 1.5
        trendingOption0.layer.cornerRadius = 5.5
        trendingOption0.setTitleColor(UIColor.white, for: .normal)
        trendingOption0.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 14)
        trendingOption0.titleLabel?.textAlignment = NSTextAlignment.center
        trendingOption0.backgroundColor = UIColor.clear
        trendingOption0.tag = 0
        trendingOption0.addTarget(missionControlView, action: #selector(trendingOptionTapped(_:)), for: .touchUpInside)
        self.addSubview(trendingOption0)
        
        trendingOption1.frame = CGRect(x: 0.02824*(missionControlView?.frame.width)!, y: 0.05609*(missionControlView?.frame.height)!, width: 0.465*(missionControlView?.frame.width)!, height: 0.04558*(missionControlView?.frame.height)!)
        trendingOption1.layer.borderWidth = 1.5
        trendingOption1.layer.cornerRadius = 5.5
        trendingOption1.setTitleColor(UIColor.white, for: .normal)
        trendingOption1.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 14)
        trendingOption1.titleLabel?.textAlignment = NSTextAlignment.center
        trendingOption1.backgroundColor = UIColor.clear
        trendingOption1.tag = 1
        trendingOption1.addTarget(missionControlView, action: #selector(trendingOptionTapped(_:)), for: .touchUpInside)
        self.addSubview(trendingOption1)
        
        trendingOption2.frame = CGRect(x: 0.02824*(missionControlView?.frame.width)!, y: 0.11218*(missionControlView?.frame.height)!, width: 0.465*(missionControlView?.frame.width)!, height: 0.04558*(missionControlView?.frame.height)!)
        trendingOption2.layer.borderWidth = 1.5
        trendingOption2.layer.cornerRadius = 5.5
        trendingOption2.setTitleColor(UIColor.white, for: .normal)
        trendingOption2.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 14)
        trendingOption2.titleLabel?.textAlignment = NSTextAlignment.center
        trendingOption2.backgroundColor = UIColor.clear
        trendingOption2.tag = 2
        trendingOption2.addTarget(missionControlView, action: #selector(trendingOptionTapped(_:)), for: .touchUpInside)
        self.addSubview(trendingOption2)
        
        trendingOption3.frame = CGRect(x: 0.50544*(missionControlView?.frame.width)!, y: 0, width: 0.465*(missionControlView?.frame.width)!, height: 0.04558*(missionControlView?.frame.height)!)
        trendingOption3.layer.borderWidth = 1.5
        trendingOption3.layer.cornerRadius = 5.5
        trendingOption3.setTitleColor(UIColor.white, for: .normal)
        trendingOption3.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 14)
        trendingOption3.titleLabel?.textAlignment = NSTextAlignment.center
        trendingOption3.backgroundColor = UIColor.clear
        trendingOption3.tag = 3
        trendingOption3.addTarget(missionControlView, action: #selector(trendingOptionTapped(_:)), for: .touchUpInside)
        self.addSubview(trendingOption3)
        
        trendingOption4.frame = CGRect(x: 0.50544*(missionControlView?.frame.width)!, y: 0.05609*(missionControlView?.frame.height)!, width: 0.465*(missionControlView?.frame.width)!, height: 0.04558*(missionControlView?.frame.height)!)
        trendingOption4.layer.borderWidth = 1.5
        trendingOption4.layer.cornerRadius = 5.5
        trendingOption4.setTitleColor(UIColor.white, for: .normal)
        trendingOption4.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 14)
        trendingOption4.titleLabel?.textAlignment = NSTextAlignment.center
        trendingOption4.backgroundColor = UIColor.clear
        trendingOption4.tag = 4
        trendingOption4.addTarget(missionControlView, action: #selector(trendingOptionTapped(_:)), for: .touchUpInside)
        self.addSubview(trendingOption4)
        
        trendingOption5.frame = CGRect(x: 0.50544*(missionControlView?.frame.width)!, y: 0.11218*(missionControlView?.frame.height)!, width: 0.465*(missionControlView?.frame.width)!, height: 0.04558*(missionControlView?.frame.height)!)
        trendingOption5.layer.borderWidth = 1.5
        trendingOption5.layer.cornerRadius = 5.5
        trendingOption5.setTitleColor(UIColor.white, for: .normal)
        trendingOption5.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 14)
        trendingOption5.titleLabel?.textAlignment = NSTextAlignment.center
        trendingOption5.backgroundColor = UIColor.clear
        trendingOption5.tag = 5
        trendingOption5.addTarget(missionControlView, action: #selector(trendingOptionTapped(_:)), for: .touchUpInside)
        self.addSubview(trendingOption5)
        
        let type = missionControlView?.whichFilter()
        getTop6TrendingOptions(type: type!)
        updateTrendingOptions()
    }
    
    func updateTrendingOptions() {
        trendingOption0.layer.borderColor = (top6Options[0]?[2] as! UIColor).cgColor
        trendingOption0.setTitle(top6Options[0]?[0] as? String, for: .normal)
        trendingOption0.setTitleColor(top6Options[0]?[2] as? UIColor, for: .highlighted)
        
        trendingOption1.layer.borderColor = (top6Options[1]?[2] as! UIColor).cgColor
        trendingOption1.setTitle(top6Options[1]?[0] as? String, for: .normal)
        trendingOption1.setTitleColor(top6Options[1]?[2] as? UIColor, for: .highlighted)
        
        trendingOption2.layer.borderColor = (top6Options[2]?[2] as! UIColor).cgColor
        trendingOption2.setTitle(top6Options[2]?[0] as? String, for: .normal)
        trendingOption2.setTitleColor(top6Options[2]?[2] as? UIColor, for: .highlighted)
        
        trendingOption3.layer.borderColor = (top6Options[3]?[2] as! UIColor).cgColor
        trendingOption3.setTitle(top6Options[3]?[0] as? String, for: .normal)
        trendingOption3.setTitleColor(top6Options[3]?[2] as? UIColor, for: .highlighted)
        
        trendingOption4.layer.borderColor = (top6Options[4]?[2] as! UIColor).cgColor
        trendingOption4.setTitle(top6Options[4]?[0] as? String, for: .normal)
        trendingOption4.setTitleColor(top6Options[4]?[2] as? UIColor, for: .highlighted)
        
        trendingOption5.layer.borderColor = (top6Options[5]?[2] as! UIColor).cgColor
        trendingOption5.setTitle(top6Options[5]?[0] as? String, for: .normal)
        trendingOption5.setTitleColor(top6Options[5]?[2] as? UIColor, for: .highlighted)
    }
    
    @objc func trendingOptionTapped (_ sender: UIButton) {
        print("trendingOptionTapped")
        
        //Adding the corresponding text to the CustomKeyboard.messageTextView
        if let trendingOptionText = top6Options[sender.tag]?[1] as? String {
            print(trendingOptionText)
            customKeyboard?.messageTextView.text = trendingOptionText
            customKeyboard?.updatePlaceholder()
            customKeyboard?.updateMessageHeights()
        }
        
        //Changing the button selection to the type of the trendingOption selected
        if let trendingOptionType = top6Options[sender.tag]?[2] as? UIColor {
            if trendingOptionType == DisplayUtility.businessBlue {
                missionControlView?.businessButton.isSelected = true
                missionControlView?.loveButton.isSelected = false
                missionControlView?.friendshipButton.isSelected = false
            } else if trendingOptionType == DisplayUtility.loveRed {
                missionControlView?.businessButton.isSelected = false
                missionControlView?.loveButton.isSelected = true
                missionControlView?.friendshipButton.isSelected = false
            } else if trendingOptionType == DisplayUtility.friendshipGreen {
                missionControlView?.businessButton.isSelected = false
                missionControlView?.loveButton.isSelected = false
                missionControlView?.friendshipButton.isSelected = true
            }
        }
    }
    
    //Finding the top 6 trending options and setting an Int: [Any] to each one where int represents the tag of the UIButton and the [Any] Array is set to [button title, text to display in customKeyboard.messageTextView on click of button, color of button]
    func getTop6TrendingOptions (type: String) {
        var option1 = [Any]()
        var option2 = [Any]()
        var option3 = [Any]()
        var option4 = [Any]()
        var option5 = [Any]()
        var option6 = [Any]()
        
        if type == "Business" {
            option1 = ["Study Group", "I'm looking for some people to study with for one of my classes", DisplayUtility.businessBlue]
            option2 = ["Internship", "I'm looking for an internship for the summer", DisplayUtility.businessBlue]
            option3 = ["Investor", "I am raising money for a venture I am working on", DisplayUtility.businessBlue]
            option4 = ["Investment", "I am looking to invest in something game-changing", DisplayUtility.businessBlue]
            option5 = ["Co-Founder", "I am looking for someone to join me for a venture", DisplayUtility.businessBlue]
            option6 = ["Intern", "I am looking for an intern for a venture I started", DisplayUtility.businessBlue]
        } else if type == "Love" {
            option1 = ["Formal Date", "I'm looking for some one to go to a formal with me", DisplayUtility.loveRed]
            option2 = ["See a Movie", "I want to take a date to see a cool new movie.", DisplayUtility.loveRed]
            option3 = ["Soulmate", "I'm looking for my soulmate. Set me up with someone awesome!", DisplayUtility.loveRed]
            option4 = ["Date Night", "I'm looking for someone to go to a date night with me", DisplayUtility.loveRed]
            option5 = ["Dinner", "I'm looking for someone to go to dinner with me", DisplayUtility.loveRed]
            option6 = ["Wine", "I'm looking for someone to open a bottle of wine with", DisplayUtility.loveRed]
        } else if type == "Friendship" {
            option1 = ["Running Partner", "I am trying to find someone to run with me", DisplayUtility.friendshipGreen]
            option2 = ["Roommate", "I need a roommate. Any suggestions?", DisplayUtility.friendshipGreen]
            option3 = ["Gym Buddy", "I am looking for someone to go to the gym with me", DisplayUtility.friendshipGreen]
            option4 = ["Drinking Buddy", "I just want to drink. Anyone else feel the same way?", DisplayUtility.friendshipGreen]
            option5 = ["Beer Pong Partner", "I'm playing beer pong and need a partner. I could ask a friend, but someone new seems more fun", DisplayUtility.friendshipGreen]
            option6 = ["Random", "Introduce me to someone random! I'm trying to meet some awesome people", DisplayUtility.friendshipGreen]
        } else {
            option1 = ["Gym Buddy", "I am looking for someone to go to the gym with me", DisplayUtility.friendshipGreen]
            option2 = ["Roommate", "I need a roommate. Any suggestions?", DisplayUtility.friendshipGreen]
            option3 = ["Date Night", "I'm looking for someone to go to a date night with me", DisplayUtility.loveRed]
            option4 = ["Internship", "I'm looking for an internship for the summer", DisplayUtility.businessBlue]
            option5 = ["Co-Founder", "I am looking for someone to join me for a venture", DisplayUtility.businessBlue]
            option6 = ["Random", "Introduce me to someone random! I'm trying to meet some awesome people", DisplayUtility.friendshipGreen]
        }
        
        top6Options = [0: option1, 1: option2, 2: option3, 3: option4, 4: option5, 5: option6]
        updateTrendingOptions()
    }
    
    //TrendingButton Selector
    func trendingTapped() {
        if self.isHidden {
            UIView.animate(withDuration: 0.4, animations: {
                self.isHidden = false
            })
            
            dividingLine?.isHidden = true
            
            //Adjusting Trending Views
            trendingButton?.frame.origin.y = 0.12953*(missionControlView?.frame.height)!
            print("Trending was hidden")
            
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                self.isHidden = true
            })
            
            dividingLine?.isHidden = false
            print("Trending was not hidden")
            
            //Adjusting Trending Views
            trendingButton?.frame.origin.y = 0.2812*(missionControlView?.frame.height)!
            
        }
    }

}
