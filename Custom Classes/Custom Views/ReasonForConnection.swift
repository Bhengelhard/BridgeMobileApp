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
    var businessButton = UIButton()
    var loveButton = UIButton()
    var friendshipButton = UIButton()
    var selectedButtonLabel = UILabel()
    
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
        } else if (sender == loveButton && !sender.isSelected) {
            loveButton.isSelected = true
            loveButton.isUserInteractionEnabled = false
            businessButton.isSelected = false
            businessButton.isUserInteractionEnabled = true
            friendshipButton.isSelected = false
            friendshipButton.isUserInteractionEnabled = true
            selectedButtonLabel.text = "DATING"
            selectedButtonLabel.textColor = DisplayUtility.loveRed
        } else if (sender == friendshipButton && !sender.isSelected) {
            friendshipButton.isSelected = true
            friendshipButton.isUserInteractionEnabled = false
            businessButton.isSelected = false
            businessButton.isUserInteractionEnabled = true
            loveButton.isSelected = false
            loveButton.isUserInteractionEnabled = true
            selectedButtonLabel.text = "FRIENDSHIP"
            selectedButtonLabel.textColor = DisplayUtility.friendshipGreen
        }
    }
    
    func displayCustomKeyboard() {
        //add custom keyboard
        let customKeyboard = CustomKeyboard()
        customKeyboard.display(view: self)
        customKeyboard.resign()
        //let type = whichFilter()
        //customKeyboard.updatePostType(updatedPostType: type)
        //customKeyboardHeight = customKeyboard.height()
        //postBackgroundView.frame.size.height = customKeyboardHeight

    }
    
    /*func updateSuggestedReasons() {
        if businessButton.isSelected {
            selectedButtonLabel.text = "WORK"
            selectedButtonLabel.textColor = DisplayUtility.businessBlue
        } else if loveButton.isSelected {
            selectedButtonLabel.text = "DATING"
            selectedButtonLabel.textColor = DisplayUtility.loveRed
        } else if friendshipButton.isSelected {
            selectedButtonLabel.text = "FRIENDSHIP"
            selectedButtonLabel.textColor = DisplayUtility.friendshipGreen
        }
    }*/
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */


}
