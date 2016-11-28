//
//  MissionControlView
//  MyBridgeApp
//
//  Created by Blake Engelhard on 11/2/16.
//  Copyright © 2016 BHE Ventures LLC. All rights reserved.
//

import UIKit

class MissionControlView: UIView{
    
    let displayUtility = DisplayUtility()
    let customKeyboard = CustomKeyboard()
    var currentView = UIView()
    var isMessagesViewController = Bool()
    
    //Post A Request and Filter Views
    var categoriesView = UIView()
    let categoriesLabel = UILabel()
    let postARequestView = UIView()
    let postBackgroundView = UIView()
    let businessButton = UIButton()
    let loveButton = UIButton()
    let friendshipButton = UIButton()
    //var isCategoriesViewDisplayed = Bool()
    //var isPostViewDisplayed = Bool()
    var customKeyboardHeight = CGFloat()
    var position = 0
    
    //Trending Views
    var trendingButton = UIButton()
    let trendingOptionsView = UIView()
    let dividingLine = UIView()
    let trendingLabel = UILabel()
    let trendingCarrot = UIImageView()
    let blackBackgroundView = UIView()
    var top6Options = [Int: [Any]]()
    
    //TrendingOptionButtons
    let trendingOption0 = UIButton()
    let trendingOption1 = UIButton()
    let trendingOption2 = UIButton()
    let trendingOption3 = UIButton()
    let trendingOption4 = UIButton()
    let trendingOption5 = UIButton()
    
    let initialFrameY = 0.94322*DisplayUtility.screenHeight
    
    override init (frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init () {
        self.init(frame: CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This is a fatal error message from CustomClasses/CustomViews/SwipeCard.swift")
    }
    
    func initialize (view: UIView, isMessagesViewController: Bool) {
        //Setting the frame of the missionControlView
        //self.frame = view.frame
        
        //tabViewButton.removeTarget(self, action: #selector(showCategoriesView(_:)), for: .touchUpInside)
        //tabViewButton.addTarget(self,action:#selector(showPostView(_:)), for: .touchUpInside)

        
        
        //setting global variables
        currentView = view
        self.isMessagesViewController = isMessagesViewController
        self.frame = CGRect(x: 0, y: initialFrameY, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight)
        
        blackBackgroundView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        blackBackgroundView.backgroundColor = UIColor.black
        blackBackgroundView.alpha = 0
        self.addSubview(blackBackgroundView)
        
        
        /*(categoriesView.frame.size = CGSize(width: 0.9651*DisplayUtility.screenWidth, height: 0.10626*DisplayUtility.screenHeight)
        categoriesView.center.x = currentView.center.x
        categoriesView.frame.origin.y = DisplayUtility.screenHeight - 0.5*categoriesView.frame.height*/
        categoriesView.frame.size = CGSize(width: 0.9651*DisplayUtility.screenWidth, height: 0.10626*DisplayUtility.screenHeight)
        categoriesView.center.x = currentView.center.x
        categoriesView.frame.origin.y = 0
        categoriesView.layer.cornerRadius = 5.5
        categoriesView.layer.masksToBounds = true
        categoriesView.backgroundColor = DisplayUtility.necterGray
        //let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(filtersTapped(_:)))
        //categoriesView.addGestureRecognizer(tapGestureRecognizer)
        
        
        //setting the MissionControlView to start at the top of the filter
        //self.frame.origin.y = DisplayUtility.screenHeight - 0.5*categoriesView.frame.height
        
        self.addSubview(categoriesView)
        //displayUtility.setBlurredView(viewToBlur: categoriesView)

        //adding filterButtons placement
        businessButton.frame = CGRect(x: 0.37932*DisplayUtility.screenWidth, y: 0, width: 0.13271*DisplayUtility.screenWidth, height: 0.13271*DisplayUtility.screenWidth)
        businessButton.center.y = 0.5*categoriesView.frame.height
        
        loveButton.frame.size = businessButton.frame.size
        loveButton.frame.origin.x = 0.5474*DisplayUtility.screenWidth
        loveButton.center.y = businessButton.center.y
        
        friendshipButton.frame.size = businessButton.frame.size
        friendshipButton.frame.origin.x = 0.7195*DisplayUtility.screenWidth
        friendshipButton.center.y = businessButton.center.y
        
        //adding the filterButtons targets and images
        businessButton.addTarget(self, action: #selector(businessTapped(_:)), for: .touchUpInside)
        businessButton.setImage(UIImage(named: "Unselected_Business_Icon"), for: .normal)
        businessButton.setImage(UIImage(named:  "Selected_Business_Icon"), for: .selected)
        //businessButton.setImage(UIImage(named:  "Selected_Business_Icon"), for: .highlighted)
        businessButton.adjustsImageWhenHighlighted = false
        
        loveButton.addTarget(self, action: #selector(loveTapped(_:)), for: .touchUpInside)
        loveButton.setImage(UIImage(named: "Unselected_Love_Icon"), for: .normal)
        loveButton.setImage(UIImage(named: "Selected_Love_Icon"), for: .selected)
        //loveButton.setImage(UIImage(named:  "Selected_Love_Icon"), for: .highlighted)
        loveButton.adjustsImageWhenHighlighted = false
        
        friendshipButton.addTarget(self, action: #selector(friendshipTapped(_:)), for: .touchUpInside)
        friendshipButton.setImage(UIImage(named: "Unselected_Friendship_Icon"), for: .normal)
        friendshipButton.setImage(UIImage(named:  "Selected_Friendship_Icon"), for: .selected)
        //friendshipButton.setImage(UIImage(named:  "Selected_Friendship_Icon"), for: .highlighted)
        friendshipButton.adjustsImageWhenHighlighted = false
        
        //Creating Categories View label
        categoriesLabel.frame = CGRect(x: categoriesView.frame.origin.x + 0.11469*DisplayUtility.screenWidth, y: 0, width: 0.1711*DisplayUtility.screenWidth, height: 0.2882*DisplayUtility.screenHeight)
        categoriesLabel.center.y = categoriesView.center.y
        categoriesLabel.text = "Filter"
        categoriesLabel.font = UIFont(name: "BentonSans-Light", size: 19)
        categoriesLabel.textColor = UIColor.white
        //Adding subview to self so label can transition off of the categories view
        self.addSubview(categoriesLabel)
        
        //Adding categoriesView objects to the categoriesView
        categoriesView.addSubview(businessButton)
        categoriesView.addSubview(loveButton)
        categoriesView.addSubview(friendshipButton)
        
        
        //isCategoriesViewDisplayed = false
        //isPostViewDisplayed = false
        
    }
    
    @objc func filtersTapped(_ sender: UITapGestureRecognizer) {
        print("displayFilters")
        
        //Position is at Closed Position
        if position == 0 {
            position = 1
            displayFilters()
        }
        //Position is at FiltersView Displayed Position
        else if position == 1 {
            position = 2
            displayPostRequest()
        }
        //Position is at Post Request Displayed Position
        else {
            position = 0
            close()
        }
    }
    
    //Initialize postARequestView and animate postARequestView and CategoriesView to FiltersView Position
    func displayFilters() {
        postARequestView.frame = CGRect(x: 0, y: categoriesView.frame.maxY + 0.01295*self.frame.height, width: categoriesView.frame.width, height: 0.57445*DisplayUtility.screenHeight)
        postARequestView.center.x = currentView.center.x
        //postARequestView.backgroundColor = UIColor.black
        currentView.addSubview(postARequestView)
        displayUtility.setBlurredView(viewToBlur: postARequestView)
        
        
        let postARequestLabel = UILabel()
        postARequestLabel.frame.size = CGSize(width: 0.39648*postARequestView.frame.width, height: 0.57445*postARequestView.frame.height)
        postARequestLabel.center = CGPoint(x: postARequestView.center.x, y: 0.5*postARequestView.frame.height)
        postARequestLabel.text = "POST A REQUEST"
        postARequestLabel.textColor = UIColor.white
        postARequestLabel.font = UIFont(name: "BentonSans-Light", size: 19)
        postARequestView.addSubview(postARequestLabel)
        
        let maskPath = UIBezierPath(roundedRect: categoriesView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 5.5, height: 5.5))
        let postARequestViewShape = CAShapeLayer()
        postARequestViewShape.path = maskPath.cgPath
        postARequestView.layer.mask = postARequestViewShape
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            //self.tabView.frame.origin.y = 0.85*DisplayUtility.screenHeight
            self.categoriesView.frame.origin.y = 0.8282*DisplayUtility.screenHeight
            self.postBackgroundView.frame.origin.y = 0.94741*DisplayUtility.screenHeight
            self.postARequestView.frame.origin.y = self.categoriesView.frame.maxY + 0.01295*self.frame.height
        })
        
        print(DisplayUtility.screenHeight)
        print(postARequestView.frame.origin.y)
    }
    
    //Initialize Post Request Features, remove PostARequestView in fade to keyboard and AnimateBackground to black as objects move into position
    func displayPostRequest() {
        
        position = 2
        
        //Setting the frame of the MissionControlView on PostRequest
        //self.bringSubview(toFront: currentView)
        //self.frame = CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight)
        
        //Add Arrow
        let arrow = UIImageView(frame: CGRect(x: 0.026*self.frame.width, y: 0.03962*self.frame.height, width: 0.0532*self.frame.width, height: 0.02181*self.frame.height))
        arrow.image = UIImage(named: "Back_Arrow")
        self.addSubview(arrow)
        
        //Setting the request text label
        let requestLabel = UILabel(frame: CGRect(x: 0.35*DisplayUtility.screenWidth, y: 0.04968*DisplayUtility.screenHeight, width: 0.6*DisplayUtility.screenWidth, height: 0.08*DisplayUtility.screenHeight))
        requestLabel.text = "Request"
        requestLabel.textColor = UIColor.white
        requestLabel.textAlignment = NSTextAlignment.right
        requestLabel.font = UIFont(name: "BentonSans-Light", size: 45)
        self.addSubview(requestLabel)
        
        //Setting trending label
        trendingLabel.frame = CGRect(x: 0.02573*DisplayUtility.screenWidth, y: 0.28812*DisplayUtility.screenHeight, width: 0.4*DisplayUtility.screenWidth, height: 0.04*DisplayUtility.screenHeight)
        trendingLabel.text = "Trending"
        trendingLabel.textColor = UIColor.white
        trendingLabel.font = UIFont(name: "BentonSans-Light", size: 22.5)
        self.addSubview(trendingLabel)
        
        //Setting trending options
        setTrendingOptions()
        
        //Set Menu Carrot for Trending Feature
        trendingCarrot.frame = CGRect(x: 0.9015*self.frame.width, y: 0, width: 0.06037*self.frame.width, height: 0.01748*self.frame.height)
        trendingCarrot.frame.origin.y = trendingLabel.frame.maxY - trendingCarrot.frame.height
        trendingCarrot.image = UIImage(named: "Down_Carrot")
        self.addSubview(trendingCarrot)

        //Setting Dividing Line
        dividingLine.frame = CGRect(x: 0, y: 0.33787*DisplayUtility.screenHeight, width: 0.92842*DisplayUtility.screenWidth, height: 0.5)
        dividingLine.center.x = self.center.x
        dividingLine.backgroundColor = UIColor.white
        self.addSubview(dividingLine)
        
        //Adding Trending Button with clickable Area over the trendingLabel, carrot, and dividing line
        trendingButton.frame = CGRect(x: 0, y: trendingLabel.frame.origin.y, width:DisplayUtility.screenWidth, height: 0.07*DisplayUtility.screenHeight)
        trendingButton.addTarget(self, action: #selector(trendingTapped(_:)), for: .touchUpInside)
        self.addSubview(trendingButton)
        
        //Adjusting the CategoriesLabel - this moves off of the categoriesView and onto the black background
        categoriesLabel.frame = CGRect(x: 0.02573*self.frame.width, y: 0.35713*self.frame.height, width: 0.4*self.frame.width, height: 0.04*self.frame.height)
        categoriesLabel.text = "Category"
        categoriesLabel.font =  UIFont(name: "BentonSans-Light", size: 22.5)
        
        //Adjusting Categories View Placement
        categoriesView.frame.origin.y = 0.40892*DisplayUtility.screenHeight
        businessButton.frame.origin.x = 0.2626*categoriesView.frame.width
        loveButton.frame.origin.x = 0.43134*categoriesView.frame.width
        friendshipButton.frame.origin.x = 0.60462*categoriesView.frame.width
        
        //Adding customKeyboard
        customKeyboard.display(view: currentView, placeholder: "I am looking for...", buttonTitle: "post", buttonTarget: "postStatus")
        customKeyboard.maxNumCharacters = 80
        let type = whichFilter()
        customKeyboard.messageTextView.becomeFirstResponder()
        customKeyboard.updatePostType(updatedPostType: type)
        customKeyboardHeight = customKeyboard.height()
        
        //fading background to black
        //self.alpha = 0.0
        
        
        
        /*//postBackgroundView.frame.size.height = customKeyboardHeight
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            self.alpha = 1.0
            self.categoriesView.frame.origin.y = self.postBackgroundView.frame.origin.y - self.categoriesView.frame.height
        })*/
        
    }
    
    //Remove PostRequest and Filters - specific objects and animate filtersView to closed position
    func close() {
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            self.categoriesView.frame.origin.y = DisplayUtility.screenHeight - 0.5*self.categoriesView.frame.height
            self.trendingButton.frame.origin.y = 0.26787*DisplayUtility.screenHeight
            self.postARequestView.frame.origin.y = self.categoriesView.frame.maxY + 0.01295*DisplayUtility.screenHeight
        })
        
        //Removing PostRequest and Filters - specific objects
        customKeyboard.messageView.removeFromSuperview()
        postARequestView.removeFromSuperview()
    }
    
    //Filter Selectors
    @objc func businessTapped(_ sender: UIButton) {
        toggleFilters(type: "Business")
    }
    @objc func loveTapped(_ sender: UIButton) {
        toggleFilters(type: "Love")
    }
    @objc func friendshipTapped(_ sender: UIButton) {
        toggleFilters(type: "Friendship")
    }
    
    //Setting the trending Options
    func setTrendingOptions() {
        trendingOptionsView.frame = CGRect(x: 0, y: 0.17325*self.frame.height, width: self.frame.width /*categoriesView.frame.width*/, height: 0.1574*self.frame.height)
        trendingButton.frame.origin.y += trendingOptionsView.frame.height
        //trendingOptionsView.backgroundColor = UIColor.green
        trendingOptionsView.isHidden = true
        self.addSubview(trendingOptionsView)
        
        trendingOption0.frame = CGRect(x: 0.02824*self.frame.width, y: 0, width: 0.465*self.frame.width, height: 0.04558*self.frame.height)
        trendingOption0.layer.borderWidth = 1.5
        trendingOption0.layer.cornerRadius = 5.5
        trendingOption0.setTitleColor(UIColor.white, for: .normal)
        trendingOption0.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 14)
        trendingOption0.titleLabel?.textAlignment = NSTextAlignment.center
        trendingOption0.backgroundColor = UIColor.clear
        trendingOption0.tag = 0
        trendingOption0.addTarget(self, action: #selector(trendingOptionTapped(_:)), for: .touchUpInside)
        trendingOptionsView.addSubview(trendingOption0)
        
        trendingOption1.frame = CGRect(x: 0.02824*self.frame.width, y: 0.05609*self.frame.height, width: 0.465*self.frame.width, height: 0.04558*self.frame.height)
        trendingOption1.layer.borderWidth = 1.5
        trendingOption1.layer.cornerRadius = 5.5
        trendingOption1.setTitleColor(UIColor.white, for: .normal)
        trendingOption1.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 14)
        trendingOption1.titleLabel?.textAlignment = NSTextAlignment.center
        trendingOption1.backgroundColor = UIColor.clear
        trendingOption1.tag = 1
        trendingOption1.addTarget(self, action: #selector(trendingOptionTapped(_:)), for: .touchUpInside)
        trendingOptionsView.addSubview(trendingOption1)
 
        trendingOption2.frame = CGRect(x: 0.02824*self.frame.width, y: 0.11218*self.frame.height, width: 0.465*self.frame.width, height: 0.04558*self.frame.height)
        trendingOption2.layer.borderWidth = 1.5
        trendingOption2.layer.cornerRadius = 5.5
        trendingOption2.setTitleColor(UIColor.white, for: .normal)
        trendingOption2.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 14)
        trendingOption2.titleLabel?.textAlignment = NSTextAlignment.center
        trendingOption2.backgroundColor = UIColor.clear
        trendingOption2.tag = 2
        trendingOption2.addTarget(self, action: #selector(trendingOptionTapped(_:)), for: .touchUpInside)
        trendingOptionsView.addSubview(trendingOption2)
      
        trendingOption3.frame = CGRect(x: 0.50544*self.frame.width, y: 0, width: 0.465*self.frame.width, height: 0.04558*self.frame.height)
        trendingOption3.layer.borderWidth = 1.5
        trendingOption3.layer.cornerRadius = 5.5
        trendingOption3.setTitleColor(UIColor.white, for: .normal)
        trendingOption3.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 14)
        trendingOption3.titleLabel?.textAlignment = NSTextAlignment.center
        trendingOption3.backgroundColor = UIColor.clear
        trendingOption3.tag = 3
        trendingOption3.addTarget(self, action: #selector(trendingOptionTapped(_:)), for: .touchUpInside)
        trendingOptionsView.addSubview(trendingOption3)
    
        trendingOption4.frame = CGRect(x: 0.50544*self.frame.width, y: 0.05609*self.frame.height, width: 0.465*self.frame.width, height: 0.04558*self.frame.height)
        trendingOption4.layer.borderWidth = 1.5
        trendingOption4.layer.cornerRadius = 5.5
        trendingOption4.setTitleColor(UIColor.white, for: .normal)
        trendingOption4.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 14)
        trendingOption4.titleLabel?.textAlignment = NSTextAlignment.center
        trendingOption4.backgroundColor = UIColor.clear
        trendingOption4.tag = 4
        trendingOption4.addTarget(self, action: #selector(trendingOptionTapped(_:)), for: .touchUpInside)
        trendingOptionsView.addSubview(trendingOption4)
       
        trendingOption5.frame = CGRect(x: 0.50544*self.frame.width, y: 0.11218*self.frame.height, width: 0.465*self.frame.width, height: 0.04558*self.frame.height)
        trendingOption5.layer.borderWidth = 1.5
        trendingOption5.layer.cornerRadius = 5.5
        trendingOption5.setTitleColor(UIColor.white, for: .normal)
        trendingOption5.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 14)
        trendingOption5.titleLabel?.textAlignment = NSTextAlignment.center
        trendingOption5.backgroundColor = UIColor.clear
        trendingOption5.tag = 5
        trendingOption5.addTarget(self, action: #selector(trendingOptionTapped(_:)), for: .touchUpInside)
        trendingOptionsView.addSubview(trendingOption5)
        
        
        let type = whichFilter()
        getTop6TrendingOptions(type: type)
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
    
    func trendingOptionTapped (_ sender: UIButton) {
        print("trendingOptionTapped")
        
        //Adding the corresponding text to the CustomKeyboard.messageTextView
        if let trendingOptionText = top6Options[sender.tag]?[1] as? String {
            print(trendingOptionText)
            customKeyboard.messageTextView.text = trendingOptionText
            customKeyboard.updatePlaceholder()
            customKeyboard.updateMessageHeights()
        }
        
        //Changing the button selection to the type of the trendingOption selected
        if let trendingOptionType = top6Options[sender.tag]?[2] as? UIColor {
            var type = String()
            if trendingOptionType == DisplayUtility.businessBlue {
                businessButton.isSelected = true
                loveButton.isSelected = false
                friendshipButton.isSelected = false
                type = "Business"
            } else if trendingOptionType == DisplayUtility.loveRed {
                businessButton.isSelected = false
                loveButton.isSelected = true
                friendshipButton.isSelected = false
                type = "Love"
            } else if trendingOptionType == DisplayUtility.friendshipGreen {
                businessButton.isSelected = false
                loveButton.isSelected = false
                friendshipButton.isSelected = true
                type = "Friendship"
            }
            //getTop6TrendingOptions(type: type)
            //updateTrendingOptions()
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
    }
    
    //TrendingButton Selector
    @objc func trendingTapped(_ sender: UIButton) {
        if trendingOptionsView.isHidden {
            trendingOptionsView.isHidden = false
            dividingLine.isHidden = true
            
            //Adjusting Trending Views
            trendingButton.frame.origin.y = 0.12953*self.frame.height
            trendingLabel.frame.origin.y = 0.12953*self.frame.height
            trendingCarrot.frame.origin.y = trendingLabel.frame.maxY - trendingCarrot.frame.height
            print("Trending was hidden")
            
        } else {
            trendingOptionsView.isHidden = true
            dividingLine.isHidden = false
            print("Trending was not hidden")
            
            //Adjusting Trending Views
            trendingButton.frame.origin.y = 0.28812*self.frame.height
            trendingLabel.frame.origin.y = 0.28812*self.frame.height
            trendingCarrot.frame.origin.y = trendingLabel.frame.maxY - trendingCarrot.frame.height
            
        }
    }
    
    func toggleFilters(type: String) {
        //updating which toolbar Button is selected
        if (type == "Business" && !businessButton.isSelected) {
            businessButton.isSelected = true
            loveButton.isSelected = false
            friendshipButton.isSelected = false
            customKeyboard.updatePostType(updatedPostType: "Business")
            getTop6TrendingOptions(type: type)
        } else if (type == "Love" && !loveButton.isSelected) {
            loveButton.isSelected = true
            businessButton.isSelected = false
            friendshipButton.isSelected = false
            customKeyboard.updatePostType(updatedPostType: "Love")
            getTop6TrendingOptions(type: type)
        } else if (type == "Friendship" && !friendshipButton.isSelected) {
            friendshipButton.isSelected = true
            businessButton.isSelected = false
            loveButton.isSelected = false
            customKeyboard.updatePostType(updatedPostType: "Friendship")
            getTop6TrendingOptions(type: type)
        } else {
            businessButton.isSelected = false
            loveButton.isSelected = false
            friendshipButton.isSelected = false
            customKeyboard.updatePostType(updatedPostType: "All Types")
            getTop6TrendingOptions(type: "All Types")
        }
        
        updateTrendingOptions()
        
        //Filters tapped adjusts the swipeCards when in positions 1 and 2
        if position == 0 || position == 1 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "filtersTapped"), object: nil)
        }
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
    func drag(gestureRecognizer: UIPanGestureRecognizer) {
        print("dragged")
        
        //set alpha for background
        let backgroundAlpha = (-1/0.6262)*self.frame.origin.y + (0.2/0.6262) + 1 //(self.frame.origin.y)*(-1/(initialFrameY-0.2))-0.2*(-1/(initialFrameY-0.2))+1
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            let translation = gestureRecognizer.translation(in: self)
            gestureRecognizer.view?.center = CGPoint(x: (gestureRecognizer.view?.center.x)!, y: max(0,(gestureRecognizer.view?.center.y)! + translation.y))
            gestureRecognizer.setTranslation(CGPoint.zero, in: self)
            
            // Set Upper Limit for Dragging
            if self.frame.origin.y < 0 {
                self.frame.origin.y = 0
                self.blackBackgroundView.alpha = max(min(backgroundAlpha, 0),1)
                print(self.blackBackgroundView.alpha)
            }
            // Set Lower Limit for Dragging
            else if self.frame.origin.y > 0.94322*DisplayUtility.screenHeight {
                self.frame.origin.y = 0.94322*DisplayUtility.screenHeight
                self.blackBackgroundView.alpha = max(min(backgroundAlpha, 0),1)
                print(self.blackBackgroundView.alpha)
            }
        }
        //Adjusting heights based on if the dragging has ended
        else if gestureRecognizer.state == .ended {
            // Close Mission Control
            if self.frame.origin.y > 0.85*DisplayUtility.screenHeight {
                //animateCloseMissionControl()
                customKeyboard.remove()
                customKeyboard.messageView.removeFromSuperview()
                //print("animateCloseMissionControl")
                
                //create objects and remove objects
                
                UIView.animate(withDuration: 0.4) {
                    //animate positions during drag
                    self.frame.origin.y = self.initialFrameY
                    self.blackBackgroundView.alpha = max(min(backgroundAlpha, 0),1)
                    print(self.blackBackgroundView.alpha)
                }
            }
            //Display Filters View
            else if self.frame.origin.y > 0.5*DisplayUtility.screenHeight {
                //animateDisplayCategoriesView()
                customKeyboard.remove()
                print("animateDisplayCategoriesView")
                
                //create and remove objects
                
                UIView.animate(withDuration: 0.4) {
                    self.frame.origin.y = 0.8282*DisplayUtility.screenHeight
                    self.blackBackgroundView.alpha = max(min(backgroundAlpha, 0),1)
                    print(self.blackBackgroundView.alpha)
                }
                
            }
            //Display Post View
            else {
                //animateDisplayPostView()
                print("animateDisplayPostView")
                
                //create and remove objects
                
                UIView.animate(withDuration: 0.4) {
                    self.frame.origin.y = 0
                    self.blackBackgroundView.alpha = max(min(backgroundAlpha, 0),1)
                    print(self.blackBackgroundView.alpha)
                }
                displayPostRequest()
            }
        }
        
        
        /*UIView.animate(withDuration: 0.4) {
            
        }*/
        
        
            // Move PostView and CategoriesView with TabView when applicable
            //            else if tabView.frame.origin.y < DisplayUtility.screenHeight - tabView.frame.height - categoriesView.frame.height{
            //                if isPostViewDisplayed == false {
            //                    addPostView()
            //                }
            //                if isCategoriesViewDisplayed == false {
            //                    addCategoriesView()
            //                }
            //                categoriesView.frame.origin.y = tabView.frame.origin.y + tabView.frame.height
            //                postBackgroundView.frame.origin.y = categoriesView.frame.origin.y + categoriesView.frame.height
            //
            //            }
            //            // Move categoriesView with TabView when applicable
            //            else if tabView.frame.origin.y < DisplayUtility.screenHeight - tabView.frame.height {
            //                if isCategoriesViewDisplayed == false {
            //                    addcategoriesView()
            //                }
            //                categoriesView.frame.origin.y = tabView.frame.origin.y + tabView.frame.height
            //            }
            //

    }
}

//func addGestureRecognizer(gestureRecognizer: UIPanGestureRecognizer) {
//    categoriesView.addGestureRecognizer(gestureRecognizer)
//}
//    func animateDisplayCategoriesView() {
//
//        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
//            //self.tabView.frame.origin.y = 0.85*DisplayUtility.screenHeight
//            self.categoriesView.frame.origin.y = 0.9*DisplayUtility.screenHeight
//            self.postBackgroundView.frame.origin.y = DisplayUtility.screenHeight
//        })
//        //if tabView.frame.origin.y == 0.45*DisplayUtility.screenHeight {
//            customKeyboard.resign()
//        //}
//        isCategoriesViewDisplayed = true
//        isPostViewDisplayed = false
//    }
//    
//    @objc func showCategoriesView(_ sender: UIButton) {
//        //addCategoriesView()
//        animateDisplayCategoriesView()
//        //blurOverViewController.removeFromSuperview()
//    }
//    
//    func addPostView() {
//        /*blurOverViewController.frame = CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight)
//         blurOverViewController.alpha = 0
//         displayUtility.setBlurredView(viewToBlur: blurOverViewController)
//         //currentView.insertSubview(blurOverViewController, belowSubview: tabView)*/
//        //tabViewButton.removeTarget(self, action: #selector(showPostView(_:)), for: .touchUpInside)
//        //tabViewButton.addTarget(self,action:#selector(closeMissionControl(_:)), for: .touchUpInside)
//        
//        postBackgroundView.frame = CGRect(x: 0, y: DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: 0.4*DisplayUtility.screenHeight)
//        postBackgroundView.backgroundColor = UIColor.black
//        let maskPath = UIBezierPath(roundedRect: postBackgroundView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 5.0, height: 5.0))
//        let postViewShape = CAShapeLayer()
//        postViewShape.path = maskPath.cgPath
//        postBackgroundView.layer.mask = postViewShape
//        currentView.addSubview(postBackgroundView)
//        
//        //setting the label to inform the user to choose a type
//        let selectTypeLabel = UILabel()
//        selectTypeLabel.text = "^ CHOOSE CATEGORY FROM ABOVE ^"
//        selectTypeLabel.textColor = UIColor.white
//        selectTypeLabel.font =  UIFont(name: "BentonSans-light", size: 18)
//        selectTypeLabel.frame.size = CGSize(width: 0.9*postBackgroundView.frame.width, height: 0.2*postBackgroundView.frame.height)
//        selectTypeLabel.frame.origin.x = 0.05*DisplayUtility.screenWidth
//        selectTypeLabel.numberOfLines = 3
//        selectTypeLabel.textAlignment = NSTextAlignment.center
//        postBackgroundView.addSubview(selectTypeLabel)
//    }
//    
//    func animateDisplayPostView() {
//        //add custom keyboard
//        customKeyboard.display(view: currentView, placeholder: "I am looking for...", buttonTitle: "post", buttonTarget: "postStatus")
//        customKeyboard.maxNumCharacters = 80
//        let type = whichFilter()
//        customKeyboard.messageTextView.becomeFirstResponder()
//        customKeyboard.updatePostType(updatedPostType: type)
//        customKeyboardHeight = customKeyboard.height()
//        postBackgroundView.frame.size.height = customKeyboardHeight
//        
//        //postBackgroundView.frame.size.height = customKeyboardHeight
//        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
//            self.postBackgroundView.frame.origin.y = DisplayUtility.screenHeight - self.customKeyboardHeight
//            self.categoriesView.frame.origin.y = self.postBackgroundView.frame.origin.y - self.categoriesView.frame.height
//            //self.tabView.frame.origin.y = self.categoriesView.frame.origin.y - self.tabView.frame.height
//            //self.blurOverViewController.alpha = 1.0
//        })
//        isCategoriesViewDisplayed = true
//        isPostViewDisplayed = true
//    }
//    
//    @objc func showPostView(_ sender: UIButton) {
//        addPostView()
//        animateDisplayPostView()
//    }
//    
//    func animateCloseMissionControl() {
//        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
//            //self.tabView.frame.origin.y = 0.95*DisplayUtility.screenHeight
//            self.categoriesView.frame.origin.y = DisplayUtility.screenHeight
//            self.postBackgroundView.frame.origin.y = DisplayUtility.screenHeight
//        })
//        isPostViewDisplayed = false
//        isCategoriesViewDisplayed = false
//    }
//    @objc func closeMissionControl(_ sender: UIButton) {
//        customKeyboard.resign()
//        animateCloseMissionControl()
//        
//        //blurOverViewController.removeFromSuperview()
//        categoriesView.removeFromSuperview()
////        tabViewButton.removeTarget(self, action: #selector(closeMissionControl(_:)), for: .touchUpInside)
////        tabViewButton.addTarget(self,action:#selector(showCategoriesView(_:)), for: .touchUpInside)
//    }
//
   /* func drag(gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            //let tabTranslation = gestureRecognizer.translation(in: tabView)
            //gestureRecognizer.view?.center = CGPoint(x: (gestureRecognizer.view?.center.x)!, y: max(0.85*DisplayUtility.screenWidth,(gestureRecognizer.view?.center.y)! + tabTranslation.y))
            //gestureRecognizer.setTranslation(CGPoint.zero, in: tabView)
            
            // Set Bottom of View as Lower Limit for TabView Dragging
//            if tabView.frame.origin.y > DisplayUtility.screenHeight - tabView.frame.height {
//                tabView.frame.origin.y = DisplayUtility.screenHeight - tabView.frame.height
//            }
            // Move PostView and CategoriesView with TabView when applicable
//            else if tabView.frame.origin.y < DisplayUtility.screenHeight - tabView.frame.height - categoriesView.frame.height{
//                if isPostViewDisplayed == false {
//                    addPostView()
//                }
//                if isCategoriesViewDisplayed == false {
//                    addCategoriesView()
//                }
//                categoriesView.frame.origin.y = tabView.frame.origin.y + tabView.frame.height
//                postBackgroundView.frame.origin.y = categoriesView.frame.origin.y + categoriesView.frame.height
//                
//            }
//            // Move categoriesView with TabView when applicable
//            else if tabView.frame.origin.y < DisplayUtility.screenHeight - tabView.frame.height {
//                if isCategoriesViewDisplayed == false {
//                    addcategoriesView()
//                }
//                categoriesView.frame.origin.y = tabView.frame.origin.y + tabView.frame.height
//            }
//        } else if gestureRecognizer.state == .ended {
//            //Close Mission Control
//            if tabView.frame.origin.y > 0.93*DisplayUtility.screenHeight {
//                animateCloseMissionControl()
//                customKeyboard.resign()
//                print("animateCloseMissionControl")
//            }
//            //Display Filters View
//            else if tabView.frame.origin.y > 0.65*DisplayUtility.screenHeight {
//                animateDisplayCategoriesView()
//                customKeyboard.resign()
//                print("animateDisplayCategoriesView")
//            }
//            //Display Post View
//            else {
//                animateDisplayPostView()
//                print("animateDisplayPostView")
//            }
        }
    }*/
//    }
//    
    /*let shadowView = UIView(frame: tabView.frame)
     shadowView.backgroundColor = UIColor.lightGray
     shadowView.layer.masksToBounds = false
     shadowView.layer.shadowColor = UIColor.black.cgColor
     shadowView.layer.shadowOpacity = 0.7
     shadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
     shadowView.layer.shadowRadius = 10
     shadowView.layer.shouldRasterize = true
     view.addSubview(shadowView)*/

//        tabView.frame = CGRect(x:0, y: 0.95*DisplayUtility.screenHeight, width: 0.4*DisplayUtility.screenWidth, height: 0.051*DisplayUtility.screenHeight)
//        tabView.center.x = currentView.center.x
//        tabView.layer.borderWidth = 0
//
//        let maskPath = UIBezierPath(roundedRect: tabView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 5.0, height: 5.0))
//        let tabViewShape = CAShapeLayer()
//        tabViewShape.path = maskPath.cgPath
//        tabView.layer.mask = tabViewShape
//
//        displayUtility.setBlurredView(viewToBlur: tabView)
//        view.addSubview(tabView)
//
//        tabViewButton.addTarget(self, action: #selector(showCategoriesView(_:)), for: .touchUpInside)
//        tabViewButton.frame = CGRect(x: 0, y: 0, width: tabView.frame.width, height: tabView.frame.height)//tabView.frame
//        tabViewButton.setTitle("^", for: .normal)
//        tabView.addSubview(tabViewButton)
