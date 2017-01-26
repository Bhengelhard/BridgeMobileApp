//
//  ProfileStatusButtons.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 1/26/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class ProfileStatusButtons: UIView {
    
    // min y of frame
    let minY: CGFloat
    
    // select type function
    let selectType: (String?) -> Void // takes in type or nil, selects that type or unselects all types
    
    // whether to show visibility buttons
    let shouldShowVisibilityButtons: Bool
    
    // visibility button images
    let businessVisibleImage = UIImage(named: "Profile_Selected_Work_Bubble")
    let loveVisibleImage = UIImage(named: "Profile_Selected_Dating_Bubble")
    let friendshipVisibleImage = UIImage(named: "Profile_Selected_Friends_Bubble")
    let businessInvisibleImage = UIImage(named: "Profile_Unselected_Work_Bubble")
    let loveInvisibleImage = UIImage(named: "Profile_Unselected_Dating_Bubble")
    let friendshipInvisibleImage = UIImage(named: "Profile_Unselected_Friends_Bubble")
    
    // visibility buttons
    let businessVisibilityButton = UIButton()
    let loveVisibilityButton = UIButton()
    let friendshipVisibilityButton = UIButton()
    
    // status button images
    let businessSelectedImage = UIImage(named: "Profile_Selected_Work_Icon")
    let loveSelectedImage = UIImage(named: "Profile_Selected_Dating_Icon")
    let friendshipSelectedImage = UIImage(named: "Profile_Selected_Friends_Icon")
    let businessUnselectedImage = UIImage(named: "Profile_Unselected_Work_Icon")
    let loveUnselectedImage = UIImage(named: "Profile_Unselected_Dating_Icon")
    let friendshipUnselectedImage = UIImage(named: "Profile_Unselected_Friends_Icon")
    
    // status buttons
    let businessButton = UIButton()
    let loveButton = UIButton()
    let friendshipButton = UIButton()
    
    init(minY: CGFloat, selectType: @escaping (String?) -> Void, shouldShowVisibilityButtons: Bool = false, businessVisible: Bool = false, loveVisible: Bool = false, friendshipVisible: Bool = false) {
        
        // initialize fields
        self.minY = minY
        self.selectType = selectType
        self.shouldShowVisibilityButtons = shouldShowVisibilityButtons
        
        super.init(frame: CGRect.zero)
        
        // center x values for buttons
        let businessButtonsCenterX = 0.235*DisplayUtility.screenWidth
        let loveButtonsCenterX = 0.5*DisplayUtility.screenWidth
        let friendshipButtonsCenterX = 0.765*DisplayUtility.screenWidth
        
        // set minY for status buttons
        var statusButtonMinY: CGFloat = 0
        
        if shouldShowVisibilityButtons {
            // set initial images for visibility buttons
            if businessVisible {
                businessVisibilityButton.setImage(businessVisibleImage, for: .normal)
            } else {
                businessVisibilityButton.setImage(businessInvisibleImage, for: .normal)
            }
            if loveVisible {
                loveVisibilityButton.setImage(loveVisibleImage, for: .normal)
            } else {
                loveVisibilityButton.setImage(loveInvisibleImage, for: .normal)
            }
            if friendshipVisible {
                friendshipVisibilityButton.setImage(friendshipVisibleImage, for: .normal)
            } else {
                friendshipVisibilityButton.setImage(friendshipInvisibleImage, for: .normal)
            }
            
            // layout and add targets to visibility buttons
            let visibilityButtonWidth = 0.076*DisplayUtility.screenWidth
            let visibilityButtonHeight = visibilityButtonWidth
            
            businessVisibilityButton.frame = CGRect(x: 0, y: 0, width: visibilityButtonWidth, height: visibilityButtonHeight)
            businessVisibilityButton.center.x = businessButtonsCenterX
            businessVisibilityButton.addTarget(self, action: #selector(visibilityButtonSelected(_:)), for: .touchUpInside)
            addSubview(businessVisibilityButton)
            
            loveVisibilityButton.frame = CGRect(x: 0, y: businessVisibilityButton.frame.minY, width: visibilityButtonWidth, height: visibilityButtonHeight)
            loveVisibilityButton.center.x = loveButtonsCenterX
            loveVisibilityButton.addTarget(self, action: #selector(visibilityButtonSelected(_:)), for: .touchUpInside)
            addSubview(loveVisibilityButton)
            
            friendshipVisibilityButton.frame = CGRect(x: 0, y: businessVisibilityButton.frame.minY, width: visibilityButtonWidth, height: visibilityButtonHeight)
            friendshipVisibilityButton.center.x = friendshipButtonsCenterX
            friendshipVisibilityButton.addTarget(self, action: #selector(visibilityButtonSelected(_:)), for: .touchUpInside)
            addSubview(friendshipVisibilityButton)
            
            let line = DisplayUtility.gradientLine(minY: businessVisibilityButton.frame.maxY + 0.02*DisplayUtility.screenHeight, width: 0.8*DisplayUtility.screenWidth)
            addSubview(line)
            
            statusButtonMinY = line.frame.maxY + 0.02*DisplayUtility.screenHeight
        }
        
        // set initial images for status buttons
        businessButton.setImage(businessUnselectedImage, for: .normal)
        loveButton.setImage(loveUnselectedImage, for: .normal)
        friendshipButton.setImage(friendshipUnselectedImage, for: .normal)
        
        // layout and add targets to status buttons
        let statusButtonWidth = 0.11596*DisplayUtility.screenWidth
        let statusButtonHeight = statusButtonWidth
        
        businessButton.frame = CGRect(x: 0, y: statusButtonMinY, width: statusButtonWidth, height: statusButtonHeight)
        businessButton.center.x = businessButtonsCenterX
        businessButton.addTarget(self, action: #selector(statusButtonSelected(_:)), for: .touchUpInside)
        addSubview(businessButton)
        
        loveButton.frame = CGRect(x: 0, y: businessButton.frame.minY, width: statusButtonWidth, height: statusButtonHeight)
        loveButton.center.x = loveButtonsCenterX
        loveButton.addTarget(self, action: #selector(statusButtonSelected(_:)), for: .touchUpInside)
        addSubview(loveButton)
        
        friendshipButton.frame = CGRect(x: 0, y: businessButton.frame.minY, width: statusButtonWidth, height: statusButtonHeight)
        friendshipButton.center.x = friendshipButtonsCenterX
        friendshipButton.addTarget(self, action: #selector(statusButtonSelected(_:)), for: .touchUpInside)
        addSubview(friendshipButton)
        
        // set frame
        frame = CGRect(x: 0, y: minY, width: DisplayUtility.screenWidth, height: businessButton.frame.maxY)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func visibilityButtonSelected(_ sender: UIButton) {
        var visibleImage: UIImage?
        var invisibleImage: UIImage?
        if sender == businessVisibilityButton {
            visibleImage = businessVisibleImage
            invisibleImage = businessInvisibleImage
        } else if sender == loveVisibilityButton {
            visibleImage = loveVisibleImage
            invisibleImage = loveInvisibleImage
        } else if sender == friendshipVisibilityButton {
            visibleImage = friendshipVisibleImage
            invisibleImage = friendshipInvisibleImage
        }
        
        if let invisibleImage = invisibleImage,
            let visibleImage = visibleImage {
            if sender.image(for: .normal) == invisibleImage {
                sender.setImage(visibleImage, for: .normal)
            } else {
                sender.setImage(invisibleImage, for: .normal)
            }
        }
    }
    
    func isInterestedInBusiness() -> Bool? {
        if !shouldShowVisibilityButtons {
            return nil
        }
        return businessVisibilityButton.image(for: .normal) == businessVisibleImage
    }
    
    func isInterestedInLove() -> Bool? {
        if !shouldShowVisibilityButtons {
            return nil
        }
        return loveVisibilityButton.image(for: .normal) == loveVisibleImage
    }
    
    func isInterestedInFriendship() -> Bool? {
        if !shouldShowVisibilityButtons {
            return nil
        }
        return friendshipVisibilityButton.image(for: .normal) == friendshipVisibleImage
    }
    
    func statusButtonSelected(_ sender: UIButton) {
        for statusButton in [businessButton, loveButton, friendshipButton] {
            var selectedImage: UIImage?
            var unselectedImage: UIImage?
            if statusButton == businessButton {
                selectedImage = businessSelectedImage
                unselectedImage = businessUnselectedImage
            } else if statusButton == loveButton {
                selectedImage = loveSelectedImage
                unselectedImage = loveUnselectedImage
            } else if statusButton == friendshipButton {
                selectedImage = friendshipSelectedImage
                unselectedImage = friendshipUnselectedImage
            }
            if sender == statusButton { // selected button
                if let unselectedImage = unselectedImage,
                    let selectedImage = selectedImage {
                    // selecting unselected type
                    if statusButton.image(for: .normal) == unselectedImage {
                        statusButton.setImage(selectedImage, for: .normal)
                        if statusButton == businessButton {
                            selectType("Business")
                        } else if statusButton == loveButton {
                            selectType("Love")
                        } else if statusButton == friendshipButton {
                            selectType("Friendship")
                        }
                    } else { // unselecting selected type
                        statusButton.setImage(unselectedImage, for: .normal)
                        selectType(nil)
                    }
                }
            } else { // not selected button
                if let unselectedImage = unselectedImage {
                    statusButton.setImage(unselectedImage, for: .normal)
                }
            }
        }
    }
    
    func unselectAllStatusButtons() {
        for statusButton in [businessButton, loveButton, friendshipButton] {
            var selectedImage: UIImage?
            if statusButton == businessButton {
                selectedImage = businessSelectedImage
            } else if statusButton == loveButton {
                selectedImage = loveSelectedImage
            } else if statusButton == friendshipButton {
                selectedImage = friendshipSelectedImage
            }
            if statusButton.image(for: .normal) == selectedImage {
                statusButtonSelected(statusButton)
            }
        }
    }
}
