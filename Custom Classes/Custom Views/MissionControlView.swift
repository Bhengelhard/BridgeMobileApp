//
//  MissionControlView
//  MyBridgeApp
//
//  Created by Blake Engelhard on 11/2/16.
//  Copyright © 2016 BHE Ventures LLC. All rights reserved.
//

import UIKit
import Parse

class MissionControlView: UIView{
    
    let displayUtility = DisplayUtility()
    let customKeyboard = CustomKeyboard()
    var currentView = UIView()
    var currentRevisitButton = UIButton()
    var currentRevisitLabel = UILabel()
    let upperHalfView = UIView()
    let lowerHalfView = UIView()
    var tapGestureRecognizer = UITapGestureRecognizer()
    
    //Filter Views
    var categoriesView = UIView()
    let filterLabel = UILabel()
    let categoryLabel = UILabel()
    let businessButton = UIButton()
    let loveButton = UIButton()
    let friendshipButton = UIButton()
    let leftCategoriesArrow = UIImageView()
    let rightCategoriesArrow = UIImageView()
    var changedRevisitAlpha = false

    
    //Post A Request View
    let postARequestView = UIView()
    let postARequestLabel = UILabel()
    let leftArrow = UIImageView()
    let rightArrow = UIImageView()
    
    let arrow = UIImageView()
    let requestLabel = UILabel()
    var customKeyboardHeight = CGFloat()
    var position = 0
    let blackBackgroundView = UIView()
    
    //Trending Button
    let trendingOptionsView = TrendingView()
    var trendingButton = UIButton()
    let dividingLine = UIView()
    
    //Setting Previous Filter to return to after post
    var previousFilter = ""
    
    var wasDraggedUp = 0
    
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
    
    func initialize (view: UIView, revisitLabel: UILabel, revisitButton: UIButton) {
        //setting global variable for the view beneath the missionControlView
        currentView = view
        currentRevisitLabel = revisitLabel
        currentRevisitButton = revisitButton
        
        self.frame = CGRect(x: 0, y: initialFrameY, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight)
        
        blackBackgroundView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        blackBackgroundView.backgroundColor = UIColor.black
        blackBackgroundView.alpha = 0
        currentView.addSubview(blackBackgroundView)
        
        //adding MissionControlView in front of the blackBackgroundView
        currentView.addSubview(self)
        self.bringSubview(toFront: currentView)
        
        initializeFilters()
        initializePostRequest()
        createKeyboard()
        
        //Setting the topView
        upperHalfView.frame = CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight - customKeyboard.messageView.frame.height)
        upperHalfView.alpha = 0
        currentView.addSubview(upperHalfView)
        
        //Adding Gesture recognizer for swiping up the mission control
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(drag(_:)))
        self.addGestureRecognizer(panGestureRecognizer)
        
        //Adding Gesture recognizer for tapping the mission control to switch between positions
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        upperHalfView.addGestureRecognizer(tapGestureRecognizer)
        self.addGestureRecognizer(tapGestureRecognizer)
        
        lowerHalfView.frame = CGRect(x: 0, y: 0.6*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: 0.4*DisplayUtility.screenHeight)
        lowerHalfView.alpha = 0
        self.insertSubview(lowerHalfView, aboveSubview: upperHalfView)
    }
    
    func createKeyboard() {
        
        //Adding customKeyboard
        let placeholder = retrieveStatusForType()
        customKeyboard.display(view: lowerHalfView, placeholder: placeholder/*"I am looking for..."*/, buttonTitle: "post", buttonTarget: "postStatus")
        customKeyboard.maxNumCharacters = 80
        let type = whichFilter()
        customKeyboard.updateMessageEnablement(updatedPostType: type)
        customKeyboardHeight = customKeyboard.height()
        customKeyboard.messageView.frame.origin.y = postARequestView.frame.minY + self.frame.minY
        customKeyboard.messageView.alpha = 0
        //customKeyboard.messageTextView.isScrollEnabled = true
        //customKeyboard.messageTextView.keyboardDismissMode = .interactive
    }
    
    //Initialize postARequestView and animate postARequestView and CategoriesView to FiltersView Position
    func initializeFilters() {
        categoriesView.frame.size = CGSize(width: 0.9651*DisplayUtility.screenWidth, height: 0.10626*DisplayUtility.screenHeight)
        categoriesView.center.x = currentView.center.x
        categoriesView.frame.origin.y = 0
        categoriesView.layer.cornerRadius = 5.5
        categoriesView.layer.masksToBounds = true
        categoriesView.backgroundColor = DisplayUtility.necterGray
        self.addSubview(categoriesView)
        
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
        
        //Adding categoriesView objects to the categoriesView
        categoriesView.addSubview(businessButton)
        categoriesView.addSubview(loveButton)
        categoriesView.addSubview(friendshipButton)
        
        //Creating Filter label
        filterLabel.frame = CGRect(x: categoriesView.frame.origin.x + 0.11469*categoriesView.frame.width, y: 0, width: 0.4*self.frame.width, height: 0.04*self.frame.height)
        filterLabel.center.y = categoriesView.center.y
        filterLabel.text = "FILTER"
        filterLabel.font = UIFont(name: "BentonSans-Light", size: 19)
        filterLabel.textColor = UIColor.lightText
        filterLabel.textAlignment = NSTextAlignment.left
        //Adding subview to self so label can transition off of the categories view
        categoriesView.addSubview(filterLabel)
        
        postARequestView.frame = CGRect(x: 0, y: categoriesView.frame.height + 0.01295*self.frame.height, width: categoriesView.frame.width, height: 0.05259*self.frame.height)
        postARequestView.center.x = currentView.center.x
        postARequestView.backgroundColor = DisplayUtility.necterGray
        self.addSubview(postARequestView)
        
        postARequestLabel.frame.size = CGSize(width: 0.7*postARequestView.frame.width, height: 0.05259*self.frame.height)
        postARequestLabel.center = CGPoint(x: postARequestView.center.x, y: 0.5*postARequestView.frame.height)
        postARequestLabel.text = "POST A REQUEST"
        postARequestLabel.textColor = UIColor.white
        postARequestLabel.textAlignment = NSTextAlignment.center
        postARequestLabel.font = UIFont(name: "BentonSans-Light", size: 19)
        postARequestView.addSubview(postARequestLabel)
        
        let maskPath = UIBezierPath(roundedRect: categoriesView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 5.5, height: 5.5))
        let postARequestViewShape = CAShapeLayer()
        postARequestViewShape.path = maskPath.cgPath
        postARequestView.layer.mask = postARequestViewShape
        
        //Adding Arrows to postARequestView
        leftArrow.frame = CGRect(x: 0.01481*postARequestView.frame.width, y: 0.1167*postARequestView.frame.height, width: 0.04*postARequestView.frame.width, height: 0.5621*postARequestView.frame.height)
        leftArrow.image = UIImage(named: "Up_Arrow")
        postARequestView.addSubview(leftArrow)
       
        rightArrow.frame = CGRect(x: 0.94245*postARequestView.frame.width, y: 0.1167*postARequestView.frame.height, width: 0.04*postARequestView.frame.width, height: 0.5621*postARequestView.frame.height)
        rightArrow.image = UIImage(named: "Up_Arrow")
        postARequestView.addSubview(rightArrow)
        
        //Adding arrows to the categories View
        leftCategoriesArrow.frame = CGRect(x: 0.01481*categoriesView.frame.width, y: 0.1167*categoriesView.frame.height, width: 0.04*postARequestView.frame.width, height: 0.5621*postARequestView.frame.height)
        leftCategoriesArrow.image = UIImage(named: "Up_Arrow")
        categoriesView.addSubview(leftCategoriesArrow)
        
        rightCategoriesArrow.frame = CGRect(x: 0.94245*categoriesView.frame.width, y: 0.1167*categoriesView.frame.height, width: 0.04*postARequestView.frame.width, height: 0.5621*postARequestView.frame.height)
        rightCategoriesArrow.image = UIImage(named: "Up_Arrow")
        categoriesView.addSubview(rightCategoriesArrow)
    }
    
    //Initialize Post Request Features, remove PostARequestView in fade to keyboard and AnimateBackground to black as objects move into position
    func initializePostRequest() {
        //Add Arrow to background view so it stays still
        arrow.frame = CGRect(x: 0.026*self.frame.width, y: 0.03962*self.frame.height, width: 0.0532*self.frame.width, height: 0.02181*self.frame.height)
        arrow.image = UIImage(named: "Back_Arrow")
        arrow.alpha = 0
        blackBackgroundView.addSubview(arrow)
        
        //Setting the request text label
        requestLabel.frame = CGRect(x: 0.35*DisplayUtility.screenWidth, y: self.frame.minY - 0.35924*self.frame.height, width: 0.6*DisplayUtility.screenWidth, height: 0.08*DisplayUtility.screenHeight)
        requestLabel.text = "Request"
        requestLabel.textColor = UIColor.white
        requestLabel.textAlignment = NSTextAlignment.right
        requestLabel.font = UIFont(name: "BentonSans-Light", size: 36)
        requestLabel.alpha = 0
        blackBackgroundView.addSubview(requestLabel)
        
        //Adding Trending Button with clickable Area over the trendingLabel, carrot, and dividing line
        trendingButton.frame = CGRect(x: 0, y: self.frame.minY - 0.12772*self.frame.height, width:self.frame.width, height: 0.07*self.frame.height)
        trendingButton.addTarget(self, action: #selector(trendingTapped(_:)), for: .touchUpInside)
        trendingButton.alpha = 0
        trendingButton.isEnabled = false
        upperHalfView.addSubview(trendingButton)
        
        //Setting trending label
        let trendingLabel = UILabel()
        trendingLabel.frame = CGRect(x: 0.02573*DisplayUtility.screenWidth, y: 0, width: 0.4*DisplayUtility.screenWidth, height: 0.04*DisplayUtility.screenHeight)
        trendingLabel.text = "Trending"
        trendingLabel.textColor = UIColor.white
        trendingLabel.font = UIFont(name: "BentonSans-Light", size: 22.5)
        trendingLabel.textAlignment = NSTextAlignment.left
        trendingButton.addSubview(trendingLabel)
        
        //Set Menu Carrot for Trending Feature
        let trendingCarrot = UIImageView()
        trendingCarrot.frame = CGRect(x: 0.9015*self.frame.width, y: 0, width: 0.06037*self.frame.width, height: 0.01748*self.frame.height)
        trendingCarrot.center.y = trendingLabel.center.y
        trendingCarrot.image = UIImage(named: "Down_Carrot")
        trendingButton.addSubview(trendingCarrot)

        //Setting Dividing Line
        dividingLine.frame = CGRect(x: 0, y: trendingButton.frame.height, width: 0.92842*DisplayUtility.screenWidth, height: 0.5)
        //setting dividingLineY to the midpoint of the trendingLabel and the categories label
        let dividingLineCenter = trendingLabel.frame.height + 0.0175*self.frame.height
        dividingLine.center.y = dividingLineCenter
        dividingLine.center.x = self.center.x
        dividingLine.backgroundColor = UIColor.white
        trendingButton.addSubview(dividingLine)
        
        //Setting trending options
        trendingOptionsView.initialize(view: self, keyboard: customKeyboard, button: trendingButton, line: dividingLine, topView: upperHalfView)
        
        //Setting Category Label
        categoryLabel.frame = CGRect(x: trendingLabel.frame.minX, y: self.frame.minY - 0.05179*self.frame.height, width: 0.4*self.frame.width, height: 0.04*self.frame.height)
        categoryLabel.text = "Category"
        categoryLabel.font = UIFont(name: "BentonSans-Light", size: 22.5)
        categoryLabel.textColor = UIColor.white
        categoryLabel.textAlignment = NSTextAlignment.left
        upperHalfView.addSubview(categoryLabel)
    }
    
    @objc func trendingTapped (_ sender: UIButton) {
        trendingOptionsView.frame.origin.y = dividingLine.center.y + trendingButton.frame.origin.y - trendingOptionsView.frame.height
        trendingOptionsView.trendingTapped()
        print(trendingOptionsView.frame)
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
    
    //updates the selection of the filters based on what was tapped
    func toggleFilters(type: String) {
        //update status text based on toggledFilters
        customKeyboard.messageTextView.text = retrieveStatusForType()
        
        //updating which toolbar Button is selected
        if (type == "Business" && !businessButton.isSelected) {
            businessButton.isSelected = true
            loveButton.isSelected = false
            friendshipButton.isSelected = false
            customKeyboard.updateMessageEnablement(updatedPostType: "Business")
            trendingOptionsView.getTop6TrendingOptions(type: type)
        } else if (type == "Love" && !loveButton.isSelected) {
            loveButton.isSelected = true
            businessButton.isSelected = false
            friendshipButton.isSelected = false
            customKeyboard.updateMessageEnablement(updatedPostType: "Love")
            trendingOptionsView.getTop6TrendingOptions(type: type)
        } else if (type == "Friendship" && !friendshipButton.isSelected) {
            friendshipButton.isSelected = true
            businessButton.isSelected = false
            loveButton.isSelected = false
            customKeyboard.updateMessageEnablement(updatedPostType: "Friendship")
            trendingOptionsView.getTop6TrendingOptions(type: type)
        } else {
            businessButton.isSelected = false
            loveButton.isSelected = false
            friendshipButton.isSelected = false
            customKeyboard.updateMessageEnablement(updatedPostType: "All Types")
            trendingOptionsView.getTop6TrendingOptions(type: "All Types")
        }
        
        //Filters tapped adjusts the swipeCards when in positions 1 and 2
        if position == 0 || position == 1 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "filtersTapped"), object: nil)
            previousFilter = whichFilter()
        }
    }
    
    //Returns the category/filters button that is currently selected
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
    
    //Setting actions upon user tapping the mission control view
    func tap(_ gestureRecognizer: UITapGestureRecognizer) {
        //If MissionControlView is closed, then open to filters
        if position == 0 {
            displayFilters()
        }
        //If MissionControlView is opened to filters, then open to postRequest
        else if position == 1 {
            displayPostRequest()

        }
        //If MissionControlView is opened to postRequest, then close
        else {
            close()
            if trendingOptionsView.isHidden == false {
                trendingOptionsView.trendingTapped()
            }
        }
    }
    
    //Setting actions upon user swiping the mission control view
    func drag(_ gestureRecognizer: UIPanGestureRecognizer) {
        //Animate during drag
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            let translation = gestureRecognizer.translation(in: self)
            gestureRecognizer.view?.center = CGPoint(x: (gestureRecognizer.view?.center.x)!, y: max(0,(gestureRecognizer.view?.center.y)! + translation.y))
            gestureRecognizer.setTranslation(CGPoint.zero, in: self)
            
            // Set Upper Limit for Screen
            if self.frame.minY < 0 {
                self.frame.origin.y = 0
            }
            // Set Lower Limit for Screen
            else if self.frame.minY > 0.94322*DisplayUtility.screenHeight {
                self.frame.origin.y = 0.94322*DisplayUtility.screenHeight
            } else if self.frame.minY < 0.35713*self.frame.height {
                //categoriesLabel.frame.origin.y = 0.35713*self.frame.height
            }
            
            //setting alphas based on change in background color to black
            let backgroundAlpha = min(max(-5.9453*((self.frame.minY + categoriesView.frame.minY)/self.frame.height) + 4.9239, 0),1)
            blackBackgroundView.alpha = backgroundAlpha
            requestLabel.alpha = backgroundAlpha
            arrow.alpha = backgroundAlpha
            trendingButton.alpha = backgroundAlpha
            categoryLabel.alpha = backgroundAlpha
            customKeyboard.messageView.alpha = backgroundAlpha
            upperHalfView.alpha = backgroundAlpha
            lowerHalfView.alpha = backgroundAlpha
            filterLabel.alpha = 1 - backgroundAlpha
            
            
            let vel = gestureRecognizer.velocity(in: self)
            //User is dragging up
            if vel.y < 0 {
                categoriesView.removeFromSuperview()
                self.addSubview(categoriesView)
                upperHalfView.removeFromSuperview()
                currentView.addSubview(upperHalfView)
                
                wasDraggedUp += 1
                if self.frame.minY < 0.94322*DisplayUtility.screenHeight && self.frame.minY > 0.40892*self.frame.height{
                    trendingButton.frame.origin.y += translation.y
                    requestLabel.frame.origin.y += translation.y
                    categoryLabel.frame.origin.y += translation.y
                    customKeyboard.messageView.frame.origin.y += translation.y
                }
                if loveButton.center.x > categoriesView.center.x && filterLabel.alpha == 0 {
                    loveButton.frame.origin.x -= 1
                    businessButton.frame.origin.x -= 1
                    friendshipButton.frame.origin.x -= 1
                }
            }
                //User is dragging down
            else if vel.y > 0 {
                categoriesView.removeFromSuperview()
                self.addSubview(categoriesView)
                upperHalfView.removeFromSuperview()
                currentView.addSubview(upperHalfView)
                
                //Adjust Category View on the way dragging Down
                wasDraggedUp -= 1
                if self.frame.minY < initialFrameY {
                    trendingButton.frame.origin.y += translation.y
                    requestLabel.frame.origin.y += translation.y
                    categoryLabel.frame.origin.y += translation.y
                    customKeyboard.messageView.frame.origin.y += translation.y
                    customKeyboard.messageTextView.resignFirstResponder()
                }
                
                if loveButton.frame.minX < 0.5474*DisplayUtility.screenWidth && filterLabel.alpha == 0 {
                    loveButton.frame.origin.x += 1
                    businessButton.frame.origin.x += 1
                    friendshipButton.frame.origin.x += 1
                }
            }
            
            //Adjust Category View when dragging past CategoriesView's y placement in the postView
            if self.frame.minY < 0.40892*DisplayUtility.screenHeight && position != 2 {
                categoriesView.frame.origin.y = 0.40892*DisplayUtility.screenHeight - self.frame.minY
            }
        
            //Set upper and lower limits for dragging the postARequestView
            if postARequestView.frame.maxY < DisplayUtility.screenHeight - self.frame.origin.y {
                postARequestView.frame.origin.y = DisplayUtility.screenHeight - self.frame.minY - self.postARequestView.frame.height
                //change size as user drags up
                postARequestView.center.x = self.center.x
                if postARequestView.frame.width < DisplayUtility.screenWidth {
                    postARequestView.frame.size.width += 1
                } else {
                }
                let maskPath = UIBezierPath(roundedRect: postARequestView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 5.5, height: 5.5))
                let postARequestViewShape = CAShapeLayer()
                postARequestViewShape.path = maskPath.cgPath
                postARequestView.layer.mask = postARequestViewShape
                
            } else {
                postARequestView.center.x = self.center.x
                if postARequestView.frame.width > categoriesView.frame.width {
                    postARequestView.frame.size.width -= 1
                }
                let maskPath = UIBezierPath(roundedRect: postARequestView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 5.5, height: 5.5))
                let postARequestViewShape = CAShapeLayer()
                postARequestViewShape.path = maskPath.cgPath
                postARequestView.layer.mask = postARequestViewShape
            }
        }
        //Adjusting Positions upon end of swiping of the Mission Control View
        else if gestureRecognizer.state == .ended {
            // Close Mission Control
            if (wasDraggedUp < 5 && (position == 0 || position == 2)) || self.frame.origin.y > 0.9*DisplayUtility.screenHeight {
                close()
                if trendingOptionsView.isHidden == false {
                    trendingOptionsView.trendingTapped()
                }
            }
            //Display Filters View
            else if (position == 0 && self.frame.origin.y > 0.75*DisplayUtility.screenHeight) || (position == 1 && self.frame.origin.y > 0.75*DisplayUtility.screenHeight){
                displayFilters()
            }
            //Display Post View
            else {
                displayPostRequest()
            }
             wasDraggedUp = 0
        }
    }
    //Animate closure of MissionControlView (Position 0)
    func close() {
        
        //returning to the selected filter type in case it was changed for the post
        toggleFilters(type: previousFilter)
        
        position = 0
        trendingButton.isEnabled = false
        trendingOptionsView.isHidden = true
        dividingLine.isHidden = false
        
        upperHalfView.removeFromSuperview()
        currentView.addSubview(upperHalfView)
        
        self.addGestureRecognizer(tapGestureRecognizer)
        upperHalfView.removeGestureRecognizer(tapGestureRecognizer)
        categoriesView.removeFromSuperview()
        self.addSubview(categoriesView)
        
        UIView.animate(withDuration: 0.4) {
            
            //reorienting the categories View with filters
            self.frame.origin.y = self.initialFrameY
            self.categoriesView.frame.origin.y = 0
            self.businessButton.frame.origin.x = 0.37932*DisplayUtility.screenWidth
            self.loveButton.frame.origin.x = 0.5474*DisplayUtility.screenWidth
            self.friendshipButton.frame.origin.x = 0.7195*DisplayUtility.screenWidth
            
            //reposition postARequestView
            self.postARequestView.frame.origin.y = self.categoriesView.frame.height + 0.01295*self.frame.height
            self.postARequestView.frame.size.width = self.categoriesView.frame.width
            self.postARequestView.center.x = self.center.x
            let maskPath = UIBezierPath(roundedRect: self.postARequestView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 5.5, height: 5.5))
            let postARequestViewShape = CAShapeLayer()
            postARequestViewShape.path = maskPath.cgPath
            self.postARequestView.layer.mask = postARequestViewShape
            
            //Closing the Keyboard
            self.customKeyboard.messageTextView.resignFirstResponder()
            self.customKeyboard.messageView.frame.origin.y = self.postARequestView.frame.minY + self.frame.minY

            
            //Adjusting Alphas of fading in/out components
            self.blackBackgroundView.alpha = 0
            self.requestLabel.alpha = 0
            self.arrow.alpha = 0
            self.trendingButton.alpha = 0
            self.postARequestView.alpha = 1
            self.filterLabel.alpha = 1
            self.categoryLabel.alpha = 0
            self.customKeyboard.messageView.alpha = 0
            self.categoryLabel.alpha = 0
            self.customKeyboard.messageView.alpha = 0
            self.upperHalfView.alpha = 0
            self.lowerHalfView.alpha = 0
            self.leftCategoriesArrow.alpha = 1
            self.rightCategoriesArrow.alpha = 1
            if self.changedRevisitAlpha {
                self.currentRevisitLabel.alpha = 1
                self.currentRevisitButton.alpha = 1
            }
            
            //reposition PostView for when next time it is called again
            self.requestLabel.frame.origin.y = self.frame.minY - 0.35924*self.frame.height
            self.trendingButton.frame.origin.y = self.frame.minY - 0.12772*self.frame.height
            self.categoryLabel.frame.origin.y = self.frame.minY - 0.05179*self.frame.height
            
        }
    }
    //Animate display of Mission Control Filters (Position 1)
    func displayFilters(){
        
        upperHalfView.removeFromSuperview()
        currentView.addSubview(upperHalfView)
        
        position = 1
        //create and remove objects
        trendingButton.isEnabled = false
        
        self.addGestureRecognizer(tapGestureRecognizer)
        upperHalfView.removeGestureRecognizer(tapGestureRecognizer)
        categoriesView.removeFromSuperview()
        self.addSubview(categoriesView)
        
        UIView.animate(withDuration: 0.4) {
            //reorienting the categories View with filters
            self.frame.origin.y = 0.8282*DisplayUtility.screenHeight
            self.categoriesView.frame.origin.y = 0
            self.businessButton.frame.origin.x = 0.37932*DisplayUtility.screenWidth
            self.loveButton.frame.origin.x = 0.5474*DisplayUtility.screenWidth
            self.friendshipButton.frame.origin.x = 0.7195*DisplayUtility.screenWidth
            
            //reposition postARequestView
            self.postARequestView.frame.origin.y = self.categoriesView.frame.height + 0.01295*self.frame.height
            self.postARequestView.frame.size.width = self.categoriesView.frame.width
            self.postARequestView.center.x = self.center.x
            let maskPath = UIBezierPath(roundedRect: self.postARequestView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 5.5, height: 5.5))
            let postARequestViewShape = CAShapeLayer()
            postARequestViewShape.path = maskPath.cgPath
            self.postARequestView.layer.mask = postARequestViewShape
            
            //Adjusting Alphas of fading in/out components
            self.blackBackgroundView.alpha = 0
            self.requestLabel.alpha = 0
            self.arrow.alpha = 0
            self.trendingButton.alpha = 0
            self.postARequestView.alpha = 1
            self.filterLabel.alpha = 1
            self.categoryLabel.alpha = 0
            self.customKeyboard.messageView.alpha = 0
            self.upperHalfView.alpha = 0
            self.lowerHalfView.alpha = 0
            self.leftCategoriesArrow.alpha = 0
            self.rightCategoriesArrow.alpha = 0
            
            //reposition PostView for when next time it is called again
            self.requestLabel.frame.origin.y = self.frame.minY - 0.35924*self.frame.height
            self.trendingButton.frame.origin.y = self.frame.minY - 0.12772*self.frame.height
            self.categoryLabel.frame.origin.y = self.frame.minY - 0.05179*self.frame.height
        }
    }
    //Animate display of Mission Control Filters (Position 2)
    func displayPostRequest(){
        upperHalfView.removeFromSuperview()
        self.insertSubview(upperHalfView, belowSubview: lowerHalfView)
        
        self.bringSubview(toFront: currentView)
        
        position = 2
        trendingButton.isEnabled = true
        let distanceBetweenButtons = businessButton.center.x - loveButton.center.x
        //Displaying the Keyboard
        self.customKeyboard.messageTextView.becomeFirstResponder()
        //self.upperHalfView.frame.size.height = DisplayUtility.screenHeight - self.customKeyboard.keyboardHeight - self.customKeyboard.messageView.frame.height
        self.lowerHalfView.frame.size.height = self.customKeyboard.keyboardHeight + self.customKeyboard.messageView.frame.height
        self.lowerHalfView.frame.origin.y = DisplayUtility.screenHeight - self.lowerHalfView.frame.height
        self.removeGestureRecognizer(tapGestureRecognizer)
        upperHalfView.addGestureRecognizer(tapGestureRecognizer)
        categoriesView.removeFromSuperview()
        upperHalfView.addSubview(categoriesView)
        
        UIView.animate(withDuration: 0.4) {
            self.postARequestView.alpha = 0
            self.frame.origin.y = 0
            self.categoriesView.frame.origin.y = 0.40892*DisplayUtility.screenHeight
            self.categoryLabel.frame.origin.y = 0.35713*self.frame.height
            //self.customKeyboard.messageView.frame.origin.y = self.frame.height - self.customKeyboard.keyboardHeight - self.customKeyboard.messageView.frame.height
            
            //Adjusting the Buttons on the Categories View
            self.loveButton.center.x = self.categoriesView.center.x
            self.businessButton.center.x = self.categoriesView.center.x + distanceBetweenButtons
            self.friendshipButton.center.x = self.categoriesView.center.x - distanceBetweenButtons
            
            //Adjusting Alphas of fading in/out components
            self.blackBackgroundView.alpha = 1
            self.trendingButton.alpha = 1
            self.trendingButton.frame.origin.y = 0.2812*self.frame.height
            self.requestLabel.alpha = 1
            self.requestLabel.frame.origin.y = 0.04968*self.frame.height
            self.arrow.alpha = 1
            self.filterLabel.alpha = 0
            self.categoryLabel.alpha = 1
            self.customKeyboard.messageView.alpha = 1
            self.upperHalfView.alpha = 1
            self.lowerHalfView.alpha = 1
            self.leftCategoriesArrow.alpha = 0
            self.rightCategoriesArrow.alpha = 0
            
            if self.currentRevisitLabel.alpha == 1 {
                self.currentRevisitLabel.alpha = 0
                self.currentRevisitButton.alpha = 0
                self.changedRevisitAlpha = true
            }
            
            
            self.frame.origin.y = 0
            
            self.customKeyboard.messageView.frame.origin.y = 0
        }
        
    }
    
    
    //getting status from the currentUser's most recent status
    func retrieveStatusForType() -> String {
        var necterStatusForType = "I am looking for..."
        let type = whichFilter()
        let localData = LocalData()
        if type == "Business" {
            if let status = localData.getBusinessStatus() {
                necterStatusForType = status
            } else {
                //query for current user in userId, limit to 1, and find most recently posted "Business" bridge_type
                let query: PFQuery = PFQuery(className: "BridgeStatus")
                query.whereKey("userId", equalTo: (PFUser.current()?.objectId)!)
                query.whereKey("bridge_type", equalTo: "Business")
                query.order(byDescending: "createdAt")
                query.limit = 1
                do {
                    print("getting business objects")
                    let objects = try query.findObjects()
                    for object in objects {
                        necterStatusForType = object["bridge_status"] as! String
                        localData.setBusinessStatus(necterStatusForType)
                    }
                } catch {
                    print("Error in catch getting status")
                }
            }
        } else if type == "Love" {
            if let status = localData.getLoveStatus() {
                necterStatusForType = status
            } else {
                //query for current user in userId, limit to 1, and find most recently posted "Business" bridge_type
                let query: PFQuery = PFQuery(className: "BridgeStatus")
                query.whereKey("userId", equalTo: (PFUser.current()?.objectId)!)
                query.whereKey("bridge_type", equalTo: "Love")
                query.order(byDescending: "createdAt")
                query.limit = 1
                do {
                    let objects = try query.findObjects()
                    for object in objects {
                        necterStatusForType = object["bridge_status"] as! String
                        localData.setLoveStatus(necterStatusForType)
                    }
                } catch {
                    print("Error in catch getting status")
                }
            }
        } else if type == "Friendship" {
            if let status = localData.getFriendshipStatus() {
                necterStatusForType = status
            } else {
                //query for current user in userId, limit to 1, and find most recently posted "Business" bridge_type
                let query: PFQuery = PFQuery(className: "BridgeStatus")
                query.whereKey("userId", equalTo: (PFUser.current()?.objectId)!)
                query.whereKey("bridge_type", equalTo: "Friendship")
                query.order(byDescending: "createdAt")
                query.limit = 1
                do {
                    let objects = try query.findObjects()
                    for object in objects {
                        necterStatusForType = object["bridge_status"] as! String
                        localData.setFriendshipStatus(necterStatusForType)
                    }
                } catch {
                    print("Error in catch getting status")
                }
            }
        }
        /*if necterStatusForType != "I am looking for..." {
            print("isFirstPost set to \(isFirstPost)")
            isFirstPost = false
        }*/
        print(necterStatusForType)
        return necterStatusForType
    }

}









