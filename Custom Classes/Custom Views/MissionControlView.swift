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
    
    //Filter Views
    var categoriesView = UIView()
    let filterLabel = UILabel()
    let categoryLabel = UILabel()
    let businessButton = UIButton()
    let loveButton = UIButton()
    let friendshipButton = UIButton()

    
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
        currentView.addSubview(blackBackgroundView)
        
        //adding MissionControlView in front of the blackBackgroundView
        currentView.addSubview(self)
        self.bringSubview(toFront: currentView)
        
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
        
        
        //isCategoriesViewDisplayed = false
        //isPostViewDisplayed = false
        
        displayFilters()
        displayPostRequest()
        createKeyboard()
        
    }
    
    @objc func filtersTapped(_ sender: UITapGestureRecognizer) {
        //Position is at Closed Position
        if position == 0 {
            position = 1
            //displayFilters()
        }
        //Position is at FiltersView Displayed Position
        else if position == 1 {
            position = 2
            //displayPostRequest()
        }
        //Position is at Post Request Displayed Position
        else {
            position = 0
            close()
        }
    }
    
    func createKeyboard() {
        //Adding customKeyboard
        customKeyboard.display(view: self, placeholder: "I am looking for...", buttonTitle: "post", buttonTarget: "postStatus")
        customKeyboard.maxNumCharacters = 80
        let type = whichFilter()
        customKeyboard.messageTextView.becomeFirstResponder()
        customKeyboard.updatePostType(updatedPostType: type)
        customKeyboardHeight = customKeyboard.height()
        //customKeyboard.messageTextView.keyboardDismissMode = .interactive
        customKeyboard.messageTextView.resignFirstResponder()
        //customKeyboard.messageView.frame.origin.y = self.frame.height - customKeyboardHeight - customKeyboard.messageView.frame.height
        customKeyboard.messageView.alpha = 0
    }
    
    //Initialize postARequestView and animate postARequestView and CategoriesView to FiltersView Position
    func displayFilters() {
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
        
        leftArrow.frame = CGRect(x: 0.01481*postARequestView.frame.width, y: 0.1167*postARequestView.frame.height, width: 0.04*postARequestView.frame.width, height: 0.5621*postARequestView.frame.height)
        leftArrow.image = UIImage(named: "Up_Arrow")
        postARequestView.addSubview(leftArrow)
        
       
        rightArrow.frame = CGRect(x: 0.94245*postARequestView.frame.width, y: 0.1167*postARequestView.frame.height, width: 0.04*postARequestView.frame.width, height: 0.5621*postARequestView.frame.height)
        rightArrow.image = UIImage(named: "Up_Arrow")
        postARequestView.addSubview(rightArrow)
    }
    
    //Initialize Post Request Features, remove PostARequestView in fade to keyboard and AnimateBackground to black as objects move into position
    func displayPostRequest() {
        
        //Setting the frame of the MissionControlView on PostRequest
        //self.bringSubview(toFront: currentView)
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
        
        //Adjusting Categories View Placement
        //categoriesView.frame.origin.y = 0.40892*DisplayUtility.screenHeight
        //businessButton.frame.origin.x = 0.2626*categoriesView.frame.width
        //loveButton.frame.origin.x = 0.43134*categoriesView.frame.width
        //friendshipButton.frame.origin.x = 0.60462*categoriesView.frame.width
        
        //Adding Trending Button with clickable Area over the trendingLabel, carrot, and dividing line
        trendingButton.frame = CGRect(x: 0, y: self.frame.minY - 0.12772*self.frame.height, width:self.frame.width, height: 0.07*self.frame.height)
        trendingButton.addTarget(self, action: #selector(trendingTapped(_:)), for: .touchUpInside)
        trendingButton.alpha = 0
        trendingButton.isEnabled = false
        blackBackgroundView.addSubview(trendingButton)
        
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
        //trendingCarrot.frame.origin.y = trendingLabel.frame.maxY - trendingCarrot.frame.height
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
        trendingOptionsView.initialize(view: self, keyboard: customKeyboard, button: trendingButton, line: dividingLine)
        trendingOptionsView.frame.origin.y = dividingLine.center.y + trendingButton.frame.origin.y - trendingOptionsView.frame.height
        
        //Setting Category Label
        categoryLabel.frame = CGRect(x: trendingLabel.frame.minX, y: self.frame.minY - 0.05179*self.frame.height, width: 0.4*self.frame.width, height: 0.04*self.frame.height)
        categoryLabel.text = "Category"
        categoryLabel.font = UIFont(name: "BentonSans-Light", size: 22.5)
        categoryLabel.textColor = UIColor.white
        categoryLabel.textAlignment = NSTextAlignment.left
        blackBackgroundView.addSubview(categoryLabel)
        
    }
    
    @objc func trendingTapped (_ sender: UIButton) {
        trendingOptionsView.trendingTapped()
        print("trendingTapped")
    }
    
    //Remove PostRequest and Filters - specific objects and animate filtersView to closed position
    func close() {
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            self.categoriesView.frame.origin.y = DisplayUtility.screenHeight - 0.5*self.categoriesView.frame.height
            //self.trendingButton.frame.origin.y = 0.26787*DisplayUtility.screenHeight
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
    
    func toggleFilters(type: String) {
        //updating which toolbar Button is selected
        if (type == "Business" && !businessButton.isSelected) {
            businessButton.isSelected = true
            loveButton.isSelected = false
            friendshipButton.isSelected = false
            customKeyboard.updatePostType(updatedPostType: "Business")
            //trendingOptionsView.getTop6TrendingOptions(type: type)
        } else if (type == "Love" && !loveButton.isSelected) {
            loveButton.isSelected = true
            businessButton.isSelected = false
            friendshipButton.isSelected = false
            customKeyboard.updatePostType(updatedPostType: "Love")
            //trendingOptionsView.getTop6TrendingOptions(type: type)
        } else if (type == "Friendship" && !friendshipButton.isSelected) {
            friendshipButton.isSelected = true
            businessButton.isSelected = false
            loveButton.isSelected = false
            customKeyboard.updatePostType(updatedPostType: "Friendship")
            //trendingOptionsView.getTop6TrendingOptions(type: type)
        } else {
            businessButton.isSelected = false
            loveButton.isSelected = false
            friendshipButton.isSelected = false
            customKeyboard.updatePostType(updatedPostType: "All Types")
            //trendingOptionsView.getTop6TrendingOptions(type: "All Types")
        }
        
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
            filterLabel.alpha = 1 - backgroundAlpha
            
            let vel = gestureRecognizer.velocity(in: self)
            //User is dragging up
            if vel.y < 0 {
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
                //categoriesLabel.frame.origin.y = 0.35713*DisplayUtility.screenHeight
                print(1)
            }
            
            
            
            
            //Set upper and lower limits for dragging the postARequestView
            if postARequestView.frame.maxY < DisplayUtility.screenHeight - self.frame.origin.y {
                postARequestView.frame.origin.y = DisplayUtility.screenHeight - self.frame.minY - self.postARequestView.frame.height
                
                //change size as user drags up
                postARequestView.center.x = self.center.x
                if postARequestView.frame.width < DisplayUtility.screenWidth {
                    postARequestView.frame.size.width += 1
                } else {
                    customKeyboard.messageView.alpha = 1
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
        //Adjusting heights based on if the dragging has ended
        else if gestureRecognizer.state == .ended {
            // Close Mission Control
            if (wasDraggedUp < 5 && (position == 0 || position == 2)) || self.frame.origin.y > 0.9*DisplayUtility.screenHeight {
                position = 0
                trendingButton.isEnabled = false
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
                    
                    //repositionPostView
                    self.requestLabel.frame.origin.y = self.frame.minY - 0.35924*self.frame.height
                    self.trendingButton.frame.origin.y = self.frame.minY - 0.12772*self.frame.height
                    self.categoryLabel.frame.origin.y = self.frame.minY - 0.05179*self.frame.height

                    self.blackBackgroundView.alpha = 0
                    self.requestLabel.alpha = 0
                    self.arrow.alpha = 0
                    self.trendingButton.alpha = 0
                    self.postARequestView.alpha = 1
                    self.filterLabel.alpha = 1
                    self.categoryLabel.alpha = 0
                    
                }
            }
            //Display Filters View
            else if (position == 0 && self.frame.origin.y > 0.75*DisplayUtility.screenHeight) || (position == 1 && self.frame.origin.y > 0.75*DisplayUtility.screenHeight){
                position = 1

                //animateDisplayCategoriesView()
                //customKeyboard.remove()
                //displayFilters()
                //create and remove objects
                trendingButton.isEnabled = false
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
                    
                    //repositionPostView
                    self.requestLabel.frame.origin.y = self.frame.minY - 0.35924*self.frame.height
                    self.trendingButton.frame.origin.y = self.frame.minY - 0.12772*self.frame.height
                    self.categoryLabel.frame.origin.y = self.frame.minY - 0.05179*self.frame.height
                    
                    self.blackBackgroundView.alpha = 0
                    self.requestLabel.alpha = 0
                    self.arrow.alpha = 0
                    self.trendingButton.alpha = 0
                    self.postARequestView.alpha = 1
                    self.filterLabel.alpha = 1
                    self.categoryLabel.alpha = 0
                }
                
            }
            //Display Post View
            else {
                //animateDisplayPostView()
                
                //create and remove objects
                position = 2
                
                trendingButton.isEnabled = true
                
                //categoriesLabel.font = UIFont(name: "BentonSans-Light", size: 22.5)
                
                let distanceBetweenButtons = businessButton.center.x - loveButton.center.x
                
                UIView.animate(withDuration: 0.4) {
                    self.postARequestView.alpha = 0
                    self.frame.origin.y = 0
                    self.categoriesView.frame.origin.y = 0.40892*DisplayUtility.screenHeight
                    //Adjusting the CategoriesLabel - this moves off of the categoriesView and onto the black background
                    self.categoryLabel.frame.origin.y = 0.35713*self.frame.height
                    
                    //Adjusting the Buttons on the Categories View
                    self.loveButton.center.x = self.categoriesView.center.x
                    self.businessButton.center.x = self.categoriesView.center.x + distanceBetweenButtons
                    self.friendshipButton.center.x = self.categoriesView.center.x - distanceBetweenButtons
                    //self.customKeyboard.messageView.frame.origin.y = self.frame.height - self.customKeyboardHeight - self.customKeyboard.messageView.frame.height
                    self.customKeyboard.messageTextView.becomeFirstResponder()

                    self.blackBackgroundView.alpha = 1
                    self.trendingButton.alpha = 1
                    self.trendingButton.frame.origin.y = 0.2812*self.frame.height
                    self.requestLabel.alpha = 1
                    self.requestLabel.frame.origin.y = 0.04968*self.frame.height
                    self.arrow.alpha = 1
                    self.filterLabel.alpha = 0
                    self.categoryLabel.alpha = 1
                    
                    self.frame.origin.y = 0
                }
            }
             wasDraggedUp = 0
        }
    }
}









