//
//  ReasonForConnection.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 11/14/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class ReasonForConnection: UIView {

    var swipeCard = SwipeCard()
    let customKeyboard = CustomKeyboard()
    
    //Reason for Connection necter Type Buttons
    var businessButton = UIButton()
    var loveButton = UIButton()
    var friendshipButton = UIButton()
    var selectedButtonLabel = UILabel()
    
    //Reason for Connection Suggested Reasons labels
    var suggestion1Label = UILabel()
    var suggestion2Label = UILabel()
    var suggestion3Label = UILabel()
    
    //Reason for Connection Suggested Reason Selection Circles
    var suggestion1Circle = UIImageView()
    var suggestion2Circle = UIImageView()
    var suggestion3Circle = UIImageView()
    
    //Reason for Connection Suggested Reasons Arrays
    var businessSuggestions = [String]()
    var loveSuggestions = [String]()
    var friendshipSuggestions = [String]()
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight)
        self.alpha = 0
        let displayUtility = DisplayUtility()
        displayUtility.setBlurredView(viewToBlur: self)
        
        UIView.animate(withDuration: 0.4, animations: {
           self.alpha = 1
        })
        
        displayNavBar()
        displayButtons()
        decideSuggestedReasons()
        displaySuggestedReasons()
        displayCustomKeyboard()
    }
    
    convenience init () {
        self.init(frame: CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This is a fatal error message from CustomClasses/CustomViews/SwipeCard.swift")
    }
    
    func sendSwipeCard(swipeCardView: SwipeCard) {
        swipeCard = swipeCardView
        //Adding User's Profile Photos
        let user1Photo = UIImageView()
        user1Photo.frame = CGRect(x: 0.0744*DisplayUtility.screenWidth, y: 0.1321*DisplayUtility.screenHeight, width: 0.3123*DisplayUtility.screenWidth, height: 0.3123*DisplayUtility.screenWidth)
        user1Photo.layer.cornerRadius = user1Photo.frame.size.width/2
        user1Photo.contentMode = UIViewContentMode.scaleAspectFill
        user1Photo.clipsToBounds = true
        user1Photo.layer.borderColor = UIColor.white.cgColor
        user1Photo.layer.borderWidth = 3
        
        let user2Photo = UIImageView()
        user2Photo.frame = CGRect(x: 0.6017*DisplayUtility.screenWidth, y: 0, width: 0.3123*DisplayUtility.screenWidth, height: 0.3123*DisplayUtility.screenWidth)
        user2Photo.center.y = user1Photo.center.y
        user2Photo.layer.cornerRadius = user1Photo.frame.size.width/2
        user2Photo.contentMode = UIViewContentMode.scaleAspectFill
        user2Photo.clipsToBounds = true
        user2Photo.layer.borderColor = UIColor.white.cgColor
        user2Photo.layer.borderWidth = 3
        
        let downloader = Downloader()
        let localData = LocalData()
        if let pairings:[UserInfoPair] = localData.getPairings() {
            for pair in pairings {
                if self.frame.origin.y == 0 {
                    if let data = pair.user1?.savedProfilePicture {
                        //applying filter to make the white text more legible
                        let beginImage = CIImage(data: data as Data)
                        let edgeDetectFilter = CIFilter(name: "CIVignetteEffect")!
                        edgeDetectFilter.setValue(beginImage, forKey: kCIInputImageKey)
                        edgeDetectFilter.setValue(0.2, forKey: "inputIntensity")
                        edgeDetectFilter.setValue(0.2, forKey: "inputRadius")
                        
                        let newCGImage = CIContext(options: nil).createCGImage(edgeDetectFilter.outputImage!, from: (edgeDetectFilter.outputImage?.extent)!)
                        
                        let newImage = UIImage(cgImage: newCGImage!)
                        user1Photo.image = newImage
                        user1Photo.contentMode = UIViewContentMode.scaleAspectFill
                        user1Photo.clipsToBounds = true
                    }
                    else {
                        if let photoURLString = swipeCardView.cardsUser1PhotoURL {
                            if let photoURL = URL(string: photoURLString) {
                                downloader.imageFromURL(URL: photoURL, imageView: user1Photo)
                            }
                        }
                        
                    }
                }
                    print("got to else statement")
                if let data = pair.user2?.savedProfilePicture {
                        //applying filter to make the white text more legible
                        let beginImage = CIImage(data: data as Data)
                        let edgeDetectFilter = CIFilter(name: "CIVignetteEffect")!
                        edgeDetectFilter.setValue(beginImage, forKey: kCIInputImageKey)
                        edgeDetectFilter.setValue(0.2, forKey: "inputIntensity")
                        edgeDetectFilter.setValue(0.2, forKey: "inputRadius")
                        
                        let newCGImage = CIContext(options: nil).createCGImage(edgeDetectFilter.outputImage!, from: (edgeDetectFilter.outputImage?.extent)!)
                        
                        let newImage = UIImage(cgImage: newCGImage!)
                        user2Photo.image = newImage
                        user2Photo.contentMode = UIViewContentMode.scaleAspectFill
                        user2Photo.clipsToBounds = true
                        print("Got data for user 2")
                    }
                    else {
                        if let photoURLString = swipeCardView.cardsUser2PhotoURL {
                            if let photoURL = URL(string: photoURLString) {
                                downloader.imageFromURL(URL: photoURL, imageView: user2Photo)
                                print("tried downloading image 2")
                            }
                        }
                        
                    }
                }
            }
        
        self.addSubview(user1Photo)
        self.addSubview(user2Photo)
        
    }
    
    func displayNavBar() {
        let cancelButton = UIButton()
        cancelButton.frame = CGRect(x: 0, y: 0, width: 0.1*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenHeight)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        self.addSubview(cancelButton)
        
        let cancelIcon = UIImageView()
        cancelIcon.frame = CGRect(x: 0.05*DisplayUtility.screenWidth, y: 0.05*DisplayUtility.screenHeight, width: 0.0328*DisplayUtility.screenWidth, height: 0.0206*DisplayUtility.screenHeight)
        cancelIcon.image = #imageLiteral(resourceName: "X_Icon")
        self.addSubview(cancelIcon)
        
        let title = UILabel()
        title.frame = CGRect(x: 0, y: 0.08*DisplayUtility.screenHeight, width: 0.8606*DisplayUtility.screenWidth, height: 0.0382*DisplayUtility.screenHeight)
        title.center.x = self.center.x
        title.text = "Sweet! You're almost there."
        title.textColor = UIColor.white
        title.font = UIFont(name: "BentonSans-Light", size: 20)
        title.textAlignment = NSTextAlignment.center
        self.addSubview(title)
        
    }
    
    @objc func cancelButtonTapped(_ sender: UIButton) {
        /*UIView.animate(withDuration: 0.4, animations: {
            self.alpha = 0
        })*/
        self.removeFromSuperview()
        
        //bring back last card into place
        let bridgeVC = BridgeViewController()
        bridgeVC.connectionCanceled(swipeCardView: swipeCard)
    }
    
    func displayUserPhotos() {
       
        //user1Photo.layer.borderWidth = 1
        //user1Photo.layer.borderColor = UIColor.white.cgColor
        
        
    }
    
    func displayButtons() {
        businessButton.frame = CGRect(x: 0.1522*DisplayUtility.screenWidth, y: 0.3635*DisplayUtility.screenHeight, width: 0.1956*DisplayUtility.screenWidth, height: 0.1956*DisplayUtility.screenWidth)
        businessButton.setImage(#imageLiteral(resourceName: "Unselected_Business_Icon"), for: .normal)
        businessButton.setImage(#imageLiteral(resourceName: "Selected_Business_Icon"), for: .selected)
        businessButton.showsTouchWhenHighlighted = false
        businessButton.addTarget(self, action: #selector(typeButtonTapped(_:)), for: .touchUpInside)
        self.addSubview(businessButton)

        loveButton.frame = CGRect(x: 0.391*DisplayUtility.screenWidth, y: 0, width: 0.1956*DisplayUtility.screenWidth, height: 0.1956*DisplayUtility.screenWidth)
        loveButton.center.y = businessButton.center.y
        loveButton.setImage(#imageLiteral(resourceName: "Unselected_Love_Icon"), for: .normal)
        loveButton.setImage(#imageLiteral(resourceName: "Selected_Love_Icon"), for: .selected)
        loveButton.showsTouchWhenHighlighted = false
        loveButton.addTarget(self, action: #selector(typeButtonTapped(_:)), for: .touchUpInside)
        self.addSubview(loveButton)
        
        friendshipButton.frame = CGRect(x: 0.6292*DisplayUtility.screenWidth, y: 0, width: 0.1956*DisplayUtility.screenWidth, height: 0.1956*DisplayUtility.screenWidth)
        friendshipButton.center.y = businessButton.center.y
        friendshipButton.setImage(#imageLiteral(resourceName: "Unselected_Friendship_Icon"), for: .normal)
        friendshipButton.setImage(#imageLiteral(resourceName: "Selected_Friendship_Icon"), for: .selected)
        friendshipButton.showsTouchWhenHighlighted = false
        friendshipButton.addTarget(self, action: #selector(typeButtonTapped(_:)), for: .touchUpInside)
        self.addSubview(friendshipButton)
        
        //need to add info pulled from card for type
        businessButton.isSelected = true
        selectedButtonLabel.frame = CGRect(x: 0, y: businessButton.frame.origin.y + businessButton.frame.height + 0.025*DisplayUtility.screenHeight, width: 0.8*DisplayUtility.screenWidth, height: 0.05*DisplayUtility.screenHeight)
        selectedButtonLabel.center.x = self.center.x
        selectedButtonLabel.textAlignment = NSTextAlignment.center
        selectedButtonLabel.text = "WORK"
        selectedButtonLabel.font = UIFont(name: "BentonSans-Light", size: 26)
        selectedButtonLabel.textColor = DisplayUtility.businessBlue
        self.addSubview(selectedButtonLabel)
    }
    @objc func typeButtonTapped(_ sender: UIButton) {
        
        //updating which toolbar Button is selected
        if (sender == businessButton && !sender.isSelected) {
            businessButton.isSelected = true
            businessButton.isUserInteractionEnabled = false
            loveButton.isSelected = false
            loveButton.isUserInteractionEnabled = true
            friendshipButton.isSelected = false
            friendshipButton.isUserInteractionEnabled = true
            selectedButtonLabel.text = "WORK"
            selectedButtonLabel.textColor = DisplayUtility.businessBlue
            updateSuggestedReasons()
        } else if (sender == loveButton && !sender.isSelected) {
            loveButton.isSelected = true
            loveButton.isUserInteractionEnabled = false
            businessButton.isSelected = false
            businessButton.isUserInteractionEnabled = true
            friendshipButton.isSelected = false
            friendshipButton.isUserInteractionEnabled = true
            selectedButtonLabel.text = "DATING"
            selectedButtonLabel.textColor = DisplayUtility.loveRed
            updateSuggestedReasons()
        } else if (sender == friendshipButton && !sender.isSelected) {
            friendshipButton.isSelected = true
            friendshipButton.isUserInteractionEnabled = false
            businessButton.isSelected = false
            businessButton.isUserInteractionEnabled = true
            loveButton.isSelected = false
            loveButton.isUserInteractionEnabled = true
            selectedButtonLabel.text = "FRIENDSHIP"
            selectedButtonLabel.textColor = DisplayUtility.friendshipGreen
            updateSuggestedReasons()
        }
    }
    
    func displayCustomKeyboard() {
        //add custom keyboard
        
        customKeyboard.display(view: self, placeholder: "Why should they 'nect?", buttonTitle: "send", buttonTarget: "bridgeUsers")
        customKeyboard.resign()
        //let type = whichFilter()
        //customKeyboard.updatePostType(updatedPostType: type)
        //customKeyboardHeight = customKeyboard.height()
        //postBackgroundView.frame.size.height = customKeyboardHeight

    }
    
    func displaySuggestedReasons() {
        
        //Creating lines dividing suggested reasons
        let line1 = UIView()
        line1.frame = CGRect(x: 0, y: 0.558*DisplayUtility.screenHeight, width: 0.4604*DisplayUtility.screenWidth, height: 1.0)
        line1.center.x = self.center.x
        line1.backgroundColor = UIColor.white
        self.addSubview(line1)
        
        let line2 = UIView()
        line2.frame = CGRect(x: 0, y: 0.666*DisplayUtility.screenHeight, width: 0.4604*DisplayUtility.screenWidth, height: 1.0)
        line2.center.x = self.center.x
        line2.backgroundColor = UIColor.white
        self.addSubview(line2)
        
        let line3 = UIView()
        line3.frame = CGRect(x: 0, y: 0.7679*DisplayUtility.screenHeight, width: 0.4604*DisplayUtility.screenWidth, height: 1.0)
        line3.center.x = self.center.x
        line3.backgroundColor = UIColor.white
        self.addSubview(line3)
        
        let line4 = UIView()
        line4.frame = CGRect(x: 0, y: 0.8717*DisplayUtility.screenHeight, width: 0.4604*DisplayUtility.screenWidth, height: 1.0)
        line4.center.x = self.center.x
        line4.backgroundColor = UIColor.white
        self.addSubview(line4)
        
        //Creating clickable spaces between lines to select suggested reasons
        let suggestion1Button = UIButton()
        suggestion1Button.frame = CGRect(x: 0, y: line1.frame.maxY, width: DisplayUtility.screenWidth, height: line2.frame.origin.y - line1.frame.maxY)
        suggestion1Button.addTarget(self, action: #selector(suggestedReasonChosen(_:)), for: .touchUpInside)
        suggestion1Button.tag = 1
        self.addSubview(suggestion1Button)
        
        let suggestion2Button = UIButton()
        suggestion2Button.frame = CGRect(x: 0, y: line2.frame.maxY, width: DisplayUtility.screenWidth, height: line3.frame.origin.y - line2.frame.maxY)
        suggestion2Button.addTarget(self, action: #selector(suggestedReasonChosen(_:)), for: .touchUpInside)
        suggestion2Button.tag = 2
        self.addSubview(suggestion2Button)
        
        let suggestion3Button = UIButton()
        suggestion3Button.frame = CGRect(x: 0, y: line3.frame.maxY, width: DisplayUtility.screenWidth, height: line4.frame.origin.y - line3.frame.maxY)
        suggestion3Button.addTarget(self, action: #selector(suggestedReasonChosen(_:)), for: .touchUpInside)
        suggestion3Button.tag = 3
        self.addSubview(suggestion3Button)
        
        //Creating Parameters for Suggested Reason Labels
        suggestion1Label.frame = CGRect(x: 0.05*DisplayUtility.screenWidth, y: suggestion1Button.frame.origin.y, width: 0.8*DisplayUtility.screenWidth, height: suggestion1Button.frame.height)
        suggestion1Label.textColor = UIColor.white
        suggestion1Label.font = UIFont(name: "BentonSans-Light", size: 18)
        suggestion1Label.textAlignment = NSTextAlignment.justified
        suggestion1Label.numberOfLines = 2
        self.addSubview(suggestion1Label)
        
        suggestion2Label.frame = CGRect(x: 0.05*DisplayUtility.screenWidth, y: suggestion2Button.frame.origin.y, width: 0.8*DisplayUtility.screenWidth, height: suggestion2Button.frame.height)
        suggestion2Label.textColor = UIColor.white
        suggestion2Label.font = UIFont(name: "BentonSans-Light", size: 18)
        suggestion2Label.textAlignment = NSTextAlignment.justified
        suggestion2Label.numberOfLines = 2
        self.addSubview(suggestion2Label)
        
        suggestion3Label.frame = CGRect(x: 0.05*DisplayUtility.screenWidth, y: suggestion3Button.frame.origin.y, width: 0.8*DisplayUtility.screenWidth, height: suggestion3Button.frame.height)
        suggestion3Label.textColor = UIColor.white
        suggestion3Label.font = UIFont(name: "BentonSans-Light", size: 18)
        suggestion3Label.textAlignment = NSTextAlignment.justified
        suggestion3Label.numberOfLines = 2
        self.addSubview(suggestion3Label)
        
        //Creating Parameters for Suggested Reason Circles
        suggestion1Circle.frame = CGRect(x: 0.8852*DisplayUtility.screenWidth, y: 0, width: 0.0754*DisplayUtility.screenWidth, height: 0.0754*DisplayUtility.screenWidth)
        suggestion1Circle.center.y = suggestion1Button.center.y
        
        self.addSubview(suggestion1Circle)
        
        suggestion2Circle.frame = CGRect(x: 0.8852*DisplayUtility.screenWidth, y: 0, width: 0.0754*DisplayUtility.screenWidth, height: 0.0754*DisplayUtility.screenWidth)
        suggestion2Circle.center.y = suggestion2Button.center.y
        self.addSubview(suggestion2Circle)
        
        suggestion3Circle.frame = CGRect(x: 0.8852*DisplayUtility.screenWidth, y: 0, width: 0.0754*DisplayUtility.screenWidth, height: 0.0754*DisplayUtility.screenWidth)
        suggestion3Circle.center.y = suggestion3Button.center.y
        self.addSubview(suggestion3Circle)
        
        //Creating Arrays of suggested reasons to connect
        
        updateSuggestedReasons()
    }
    
    //Algorithm to decide which suggested reasons to display
    func decideSuggestedReasons() {
        if false { //are the two users in the same city
            businessSuggestions.append("You two are in the same city and are both great at what you do.")
            businessSuggestions.append("Both of you have an interest in working to make the world a better place.")
            
            loveSuggestions.append("You two are in the same city and would go well together.")
            loveSuggestions.append("Wine nights would be regular if you two met.")
            
            friendshipSuggestions.append("You two are in the same city and would make good friends.")
            friendshipSuggestions.append("You both have similar interests and should hang out.")

        } else {
            businessSuggestions.append("Both of you have an interest making the world a better place.")
            businessSuggestions.append("Both of you have interests and experience to help eachother.")
            
            loveSuggestions.append("Wine nights would be regular if you two met.")
            loveSuggestions.append("Looks & personality, you've both got it. What are you waiting for?")

            friendshipSuggestions.append("You both have similar interests and should hang out.")
            friendshipSuggestions.append("Both of you are awesome and definitely need to meet.")
        }

        businessSuggestions.append("I think you'd make a meaningful connection.")
        loveSuggestions.append("I think you'd make a meaningful connection.")
        friendshipSuggestions.append("I think you'd make a meaningful connection.")
    }
    
    func suggestedReasonChosen(_ sender: UIButton) {
        if sender.tag == 1 && !suggestion1Circle.isHighlighted{
            print("suggestion1Button")
            suggestion1Circle.isHighlighted = true
            suggestion2Circle.isHighlighted = false
            suggestion3Circle.isHighlighted = false
        } else if sender.tag == 2 && !suggestion2Circle.isHighlighted{
            print("suggestion2Button")
            suggestion1Circle.isHighlighted = false
            suggestion2Circle.isHighlighted = true
            suggestion3Circle.isHighlighted = false
        } else if sender.tag == 3 && !suggestion3Circle.isHighlighted {
            print("suggestion3Button")
            suggestion1Circle.isHighlighted = false
            suggestion2Circle.isHighlighted = false
            suggestion3Circle.isHighlighted = true
        } else {
            deselectCircles()
        }
        
    }
    
    func deselectCircles() {
        suggestion1Circle.isHighlighted = false
        suggestion2Circle.isHighlighted = false
        suggestion3Circle.isHighlighted = false
    }
    
    //Sets suggested Reasons text and circles based on which necter type button is selected
    func updateSuggestedReasons() {
        if businessButton.isSelected {
            suggestion1Label.text = businessSuggestions[0]
            suggestion2Label.text = businessSuggestions[1]
            suggestion3Label.text = businessSuggestions[2]
            
            deselectCircles()
            suggestion1Circle.image = UIImage(named: "Unselected_Business_Circle")
            suggestion1Circle.highlightedImage = UIImage(named: "Selected_Business_Circle")
            suggestion2Circle.image = UIImage(named: "Unselected_Business_Circle")
            suggestion2Circle.highlightedImage = UIImage(named: "Selected_Business_Circle")
            suggestion3Circle.image = UIImage(named: "Unselected_Business_Circle")
            suggestion3Circle.highlightedImage = UIImage(named: "Selected_Business_Circle")
        } else if loveButton.isSelected {
            suggestion1Label.text = loveSuggestions[0]
            suggestion2Label.text = loveSuggestions[1]
            suggestion3Label.text = loveSuggestions[2]
            
            deselectCircles()
            suggestion1Circle.image = UIImage(named: "Unselected_Love_Circle")
            suggestion1Circle.highlightedImage = UIImage(named: "Selected_Love_Circle")
            suggestion2Circle.image = UIImage(named: "Unselected_Love_Circle")
            suggestion2Circle.highlightedImage = UIImage(named: "Selected_Love_Circle")
            suggestion3Circle.image = UIImage(named: "Unselected_Love_Circle")
            suggestion3Circle.highlightedImage = UIImage(named: "Selected_Love_Circle")
        } else if friendshipButton.isSelected {
            suggestion1Label.text = friendshipSuggestions[0]
            suggestion2Label.text = friendshipSuggestions[1]
            suggestion3Label.text = friendshipSuggestions[2]
            
            deselectCircles()
            suggestion1Circle.image = UIImage(named: "Unselected_Friendship_Circle")
            suggestion1Circle.highlightedImage = UIImage(named: "Selected_Friendship_Circle")
            suggestion2Circle.image = UIImage(named: "Unselected_Friendship_Circle")
            suggestion2Circle.highlightedImage = UIImage(named: "Selected_Friendship_Circle")
            suggestion3Circle.image = UIImage(named: "Unselected_Friendship_Circle")
            suggestion3Circle.highlightedImage = UIImage(named: "Selected_Friendship_Circle")
        }
    }
}
