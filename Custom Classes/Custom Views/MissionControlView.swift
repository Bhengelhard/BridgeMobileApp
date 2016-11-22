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
    let postBackgroundView = UIView()
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
        //setting global variables
        currentView = view
        self.isMessagesViewController = isMessagesViewController
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(displayFilters(_:)))
        currentView.addGestureRecognizer(tapGestureRecognizer)
        
        //tabViewButton.removeTarget(self, action: #selector(showCategoriesView(_:)), for: .touchUpInside)
        //tabViewButton.addTarget(self,action:#selector(showPostView(_:)), for: .touchUpInside)
        
        categoriesView.frame.size = CGSize(width: 0.9651*DisplayUtility.screenWidth, height: 0.10626*DisplayUtility.screenHeight)
        categoriesView.center.x = currentView.center.x
        categoriesView.frame.origin.y = DisplayUtility.screenHeight - 0.5*categoriesView.frame.height
        currentView.addSubview(categoriesView)
        displayUtility.setBlurredView(viewToBlur: categoriesView)
        
        let maskPath = UIBezierPath(roundedRect: categoriesView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 5.5, height: 5.5))
        let categoriesViewShape = CAShapeLayer()
        categoriesViewShape.path = maskPath.cgPath
        categoriesView.layer.mask = categoriesViewShape
        
        //adding filterButtons placement
        businessButton.frame = CGRect(x: 0.37932*DisplayUtility.screenWidth, y: 0, width: 0.13271*DisplayUtility.screenWidth, height: 0.13271*DisplayUtility.screenWidth)
        businessButton.center.y = 0.5*categoriesView.frame.height //- 0.5*businessButton.frame.height
        //businessButton.center.y = categoriesView.center.y
        
        loveButton.frame.size = businessButton.frame.size
        loveButton.frame.origin.x = 0.5474*DisplayUtility.screenWidth
        loveButton.center.y = businessButton.center.y
        
        friendshipButton.frame.size = businessButton.frame.size
        friendshipButton.frame.origin.x = 0.7195*DisplayUtility.screenWidth
        friendshipButton.center.y = businessButton.center.y
        
        //adding the filterButtons targets
        businessButton.addTarget(self, action: #selector(businessTapped(_:)), for: .touchUpInside)
        businessButton.setImage(UIImage(named: "Unselected_Business_Icon"), for: UIControlState())
        businessButton.setImage(UIImage(named:  "Selected_Business_Icon"), for: .selected)
        businessButton.tag = 1
        
        loveButton.addTarget(self, action: #selector(loveTapped(_:)), for: .touchUpInside)
        loveButton.setImage(UIImage(named: "Unselected_Love_Icon"), for: UIControlState())
        loveButton.setImage(UIImage(named: "Selected_Love_Icon"), for: .selected)
        loveButton.tag = 2
        
        friendshipButton.addTarget(self, action: #selector(friendshipTapped(_:)), for: .touchUpInside)
        friendshipButton.setImage(UIImage(named: "Unselected_Friendship_Icon"), for: UIControlState())
        friendshipButton.setImage(UIImage(named:  "Selected_Friendship_Icon"), for: .selected)
        friendshipButton.tag = 3
        
        //Creating Categories View label
        let categoriesLabel = UILabel()
        categoriesLabel.frame = CGRect(x: 0.11469*DisplayUtility.screenWidth, y: 0, width: 0.1711*DisplayUtility.screenWidth, height: 0.2882*DisplayUtility.screenHeight)
        categoriesLabel.center.y = businessButton.center.y
        categoriesLabel.text = "Filter"
        categoriesLabel.font = UIFont(name: "BentonSans-Light", size: 19)
        categoriesLabel.textColor = UIColor.white
        
        //Adding categoriesView objects to the categoriesView
        categoriesView.addSubview(businessButton)
        categoriesView.addSubview(loveButton)
        categoriesView.addSubview(friendshipButton)
        categoriesView.addSubview(categoriesLabel)
        
        isCategoriesViewDisplayed = false
        isPostViewDisplayed = false
        
    }
    
    @objc func displayFilters(_ sender: UITapGestureRecognizer) {
        print("displayFilters")
    }
    
    func animateDisplayCategoriesView() {
        //tabView.bringSubview(toFront: currentView)

        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            //self.tabView.frame.origin.y = 0.85*DisplayUtility.screenHeight
            self.categoriesView.frame.origin.y = 0.9*DisplayUtility.screenHeight
            self.postBackgroundView.frame.origin.y = DisplayUtility.screenHeight
        })
        //if tabView.frame.origin.y == 0.45*DisplayUtility.screenHeight {
            customKeyboard.resign()
        //}
        isCategoriesViewDisplayed = true
        isPostViewDisplayed = false
    }
    
    @objc func showCategoriesView(_ sender: UIButton) {
        //addCategoriesView()
        animateDisplayCategoriesView()
        //blurOverViewController.removeFromSuperview()
    }
    
    func addPostView() {
        /*blurOverViewController.frame = CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight)
         blurOverViewController.alpha = 0
         displayUtility.setBlurredView(viewToBlur: blurOverViewController)
         //currentView.insertSubview(blurOverViewController, belowSubview: tabView)*/
        //tabViewButton.removeTarget(self, action: #selector(showPostView(_:)), for: .touchUpInside)
        //tabViewButton.addTarget(self,action:#selector(closeMissionControl(_:)), for: .touchUpInside)
        
        postBackgroundView.frame = CGRect(x: 0, y: DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: 0.4*DisplayUtility.screenHeight)
        postBackgroundView.backgroundColor = UIColor.black
        let maskPath = UIBezierPath(roundedRect: postBackgroundView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 5.0, height: 5.0))
        let postViewShape = CAShapeLayer()
        postViewShape.path = maskPath.cgPath
        postBackgroundView.layer.mask = postViewShape
        currentView.addSubview(postBackgroundView)
        
        //setting the label to inform the user to choose a type
        let selectTypeLabel = UILabel()
        selectTypeLabel.text = "^ CHOOSE CATEGORY FROM ABOVE ^"
        selectTypeLabel.textColor = UIColor.white
        selectTypeLabel.font =  UIFont(name: "BentonSans-light", size: 18)
        selectTypeLabel.frame.size = CGSize(width: 0.9*postBackgroundView.frame.width, height: 0.2*postBackgroundView.frame.height)
        selectTypeLabel.frame.origin.x = 0.05*DisplayUtility.screenWidth
        selectTypeLabel.numberOfLines = 3
        selectTypeLabel.textAlignment = NSTextAlignment.center
        postBackgroundView.addSubview(selectTypeLabel)
    }
    
    func animateDisplayPostView() {
        //add custom keyboard
        customKeyboard.display(view: currentView, placeholder: "I am looking for...", buttonTitle: "post", buttonTarget: "postStatus")
        customKeyboard.maxNumCharacters = 80
        let type = whichFilter()
        customKeyboard.messageTextView.becomeFirstResponder()
        customKeyboard.updatePostType(updatedPostType: type)
        customKeyboardHeight = customKeyboard.height()
        postBackgroundView.frame.size.height = customKeyboardHeight
        
        //postBackgroundView.frame.size.height = customKeyboardHeight
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            self.postBackgroundView.frame.origin.y = DisplayUtility.screenHeight - self.customKeyboardHeight
            self.categoriesView.frame.origin.y = self.postBackgroundView.frame.origin.y - self.categoriesView.frame.height
            //self.tabView.frame.origin.y = self.categoriesView.frame.origin.y - self.tabView.frame.height
            //self.blurOverViewController.alpha = 1.0
        })
        isCategoriesViewDisplayed = true
        isPostViewDisplayed = true
    }
    
    @objc func showPostView(_ sender: UIButton) {
        addPostView()
        animateDisplayPostView()
    }
    
    func animateCloseMissionControl() {
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            //self.tabView.frame.origin.y = 0.95*DisplayUtility.screenHeight
            self.categoriesView.frame.origin.y = DisplayUtility.screenHeight
            self.postBackgroundView.frame.origin.y = DisplayUtility.screenHeight
        })
        isPostViewDisplayed = false
        isCategoriesViewDisplayed = false
    }
    @objc func closeMissionControl(_ sender: UIButton) {
        customKeyboard.resign()
        animateCloseMissionControl()
        
        //blurOverViewController.removeFromSuperview()
        categoriesView.removeFromSuperview()
//        tabViewButton.removeTarget(self, action: #selector(closeMissionControl(_:)), for: .touchUpInside)
//        tabViewButton.addTarget(self,action:#selector(showCategoriesView(_:)), for: .touchUpInside)
    }
    
    @objc func businessTapped(_ sender: UIButton) {
        toggleFilters(type: "Business")
        print("Business")
        //if currentViewController == MessagesViewController {
            //let vc = currentViewController as! MessagesViewController
            //vc.filtersTapped(type: "Business", businessButton: businessButton, loveButton: loveButton, friendshipButton: friendshipButton)
        //}
        
        //if isMessagesViewController {
            
        //}
        
    }
    @objc func loveTapped(_ sender: UIButton) {
        toggleFilters(type: "Love")
        //currentViewController.filtersTapped(type: "Love", businessButton: businessButton, loveButton: loveButton, friendshipButton: friendshipButton)
    }
    @objc func friendshipTapped(_ sender: UIButton) {
        toggleFilters(type: "Friendship")
        //currentViewController.filtersTapped(type: "Friendship", businessButton: businessButton, loveButton: loveButton, friendshipButton: friendshipButton)
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
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "filtersTapped"), object: nil)
        
    }
    
    func drag(gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
//            let tabTranslation = gestureRecognizer.translation(in: tabView)
//            gestureRecognizer.view?.center = CGPoint(x: (gestureRecognizer.view?.center.x)!, y: max(0.85*DisplayUtility.screenWidth,(gestureRecognizer.view?.center.y)! + tabTranslation.y))
//            gestureRecognizer.setTranslation(CGPoint.zero, in: tabView)
//            
//            // Set Bottom of View as Lower Limit for TabView Dragging
//            if tabView.frame.origin.y > DisplayUtility.screenHeight - tabView.frame.height {
//                tabView.frame.origin.y = DisplayUtility.screenHeight - tabView.frame.height
//            }
//            // Move PostView and CategoriesView with TabView when applicable
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
//        }
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
    
    
    /*let shadowView = UIView(frame: tabView.frame)
     shadowView.backgroundColor = UIColor.lightGray
     shadowView.layer.masksToBounds = false
     shadowView.layer.shadowColor = UIColor.black.cgColor
     shadowView.layer.shadowOpacity = 0.7
     shadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
     shadowView.layer.shadowRadius = 10
     shadowView.layer.shouldRasterize = true
     view.addSubview(shadowView)*/
    

}

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
