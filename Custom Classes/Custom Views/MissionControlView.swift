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
    
    //var tabView = UIView()
    //let tabViewButton = UIButton()
    //var filtersButton = UIButton()
    var categoriesView = UIView()
    let categoriesLabel = UILabel()
    let postARequestView = UIView()
    let postBackgroundView = UIView()
    var position = 0
    var trendingButton = UIButton()
    let trendingOptionsView = UIView()
    let dividingLine = UIView()
    let trendingLabel = UILabel()
    //var blurOverViewController = UIView()
    
    let businessButton = UIButton()
    let loveButton = UIButton()
    let friendshipButton = UIButton()
    
    var isCategoriesViewDisplayed = Bool()
    var isPostViewDisplayed = Bool()
    
    var customKeyboardHeight = CGFloat()
    
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
        
        //setting global variables
        currentView = view
        self.isMessagesViewController = isMessagesViewController
        
        //tabViewButton.removeTarget(self, action: #selector(showCategoriesView(_:)), for: .touchUpInside)
        //tabViewButton.addTarget(self,action:#selector(showPostView(_:)), for: .touchUpInside)
        
        categoriesView.frame.size = CGSize(width: 0.9651*DisplayUtility.screenWidth, height: 0.10626*DisplayUtility.screenHeight)
        categoriesView.center.x = currentView.center.x
        categoriesView.frame.origin.y = DisplayUtility.screenHeight - 0.5*categoriesView.frame.height
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
        
        
        isCategoriesViewDisplayed = false
        isPostViewDisplayed = false
        
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
        //Setting the frame of the MissionControlView on PostRequest
        self.bringSubview(toFront: currentView)
        self.frame = CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight)
        self.backgroundColor = UIColor.black
        
        //Add Arrow
        let arrow = UIImageView(frame: CGRect(x: 0.026*self.frame.width, y: 0.03962*self.frame.height, width: 0.0532*self.frame.width, height: 0.02181*self.frame.height))
        arrow.image = UIImage(named: "Back_Arrow")
        self.addSubview(arrow)
        
        //Setting the request text label
        let requestLabel = UILabel(frame: CGRect(x: 0.35*DisplayUtility.screenWidth, y: 0.04968*DisplayUtility.screenHeight, width: 0.6*DisplayUtility.screenWidth, height: 0.08*DisplayUtility.screenHeight))
        requestLabel.text = "Request"
        requestLabel.textColor = UIColor.white
        requestLabel.textAlignment = NSTextAlignment.right
        requestLabel.font = UIFont(name: "BentonSans-Light", size: 47.5)
        self.addSubview(requestLabel)
        
        //Setting trending label
        trendingLabel.frame = CGRect(x: 0.02573*DisplayUtility.screenWidth, y: 0.28213*DisplayUtility.screenHeight, width: 0.4*DisplayUtility.screenWidth, height: 0.04*DisplayUtility.screenHeight)
        trendingLabel.text = "Trending"
        trendingLabel.textColor = UIColor.white
        trendingLabel.font = UIFont(name: "BentonSans-Light", size: 22.5)
        self.addSubview(trendingLabel)
        
        //Setting trending options
        setTrendingOptions()
        
        //Set Menu Carrot
        let menuCarrot = UIImageView(frame: CGRect(x: 0.9015*self.frame.width, y: 0.28812*self.frame.height, width: 0.06037*self.frame.width, height: 0.01748*self.frame.height))
        menuCarrot.image = UIImage(named: "Down_Carrot")
        self.addSubview(menuCarrot)

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
    //TrendingButton Selector
    @objc func trendingTapped(_ sender: UIButton) {
        if trendingOptionsView.isHidden {
            trendingOptionsView.isHidden = false
            dividingLine.isHidden = true
            
            trendingButton.frame.origin.y = 0.12953*self.frame.height
            
        } else {
            trendingOptionsView.isHidden = true
            dividingLine.isHidden = false
        }
    }
    
    func setTrendingOptions() {
        trendingOptionsView.frame = CGRect(x: 0.02824*self.frame.width, y: 0.17325*self.frame.height, width: 0.465*self.frame.width, height: 0.1574*self.frame.height)
        trendingOptionsView.backgroundColor = UIColor.green
        trendingOptionsView.isHidden = true
        self.addSubview(trendingOptionsView)
    }
    
    
    func toggleFilters(type: String) {
        //updating which toolbar Button is selected
        if (type == "Business" && !businessButton.isSelected) {
            businessButton.isSelected = true
            loveButton.isSelected = false
            friendshipButton.isSelected = false
            customKeyboard.updatePostType(updatedPostType: "Business")
        } else if (type == "Love" && !loveButton.isSelected) {
            loveButton.isSelected = true
            businessButton.isSelected = false
            friendshipButton.isSelected = false
            customKeyboard.updatePostType(updatedPostType: "Love")
        } else if (type == "Friendship" && !friendshipButton.isSelected) {
            friendshipButton.isSelected = true
            businessButton.isSelected = false
            loveButton.isSelected = false
            customKeyboard.updatePostType(updatedPostType: "Friendship")
        } else {
            businessButton.isSelected = false
            loveButton.isSelected = false
            friendshipButton.isSelected = false
            customKeyboard.updatePostType(updatedPostType: "All Types")
        }
        
        position = 2
        
        //Filters tapped adjusts the swipeCards when in positions 1 and 2
        if position == 0 || position == 1 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "filtersTapped"), object: nil)
        }
    }
    
    func addGestureRecognizer(gestureRecognizer: UIPanGestureRecognizer) {
        categoriesView.addGestureRecognizer(gestureRecognizer)
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
}

    
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
    func drag(gestureRecognizer: UIPanGestureRecognizer) {
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
    }
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
