//
//  ProfileViews.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 1/23/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit

class ProfileNavBar: UIView {
    
    // action functions
    let leftButtonFunc: ((UIButton) -> Void)?
    let rightButtonFunc: ((UIButton) -> Void)?
    
    let mainLabel = UILabel()
    let subLabel = UILabel()

    init(leftButtonImageView: UIImageView?, leftButtonFunc: ((UIButton) -> Void)? = nil, rightButtonImageView: UIImageView?, rightButtonFunc: ((UIButton) -> Void)? = nil, mainText: String = "", mainTextColor: UIColor = .black, subText: String = "", subTextColor: UIColor = .black) {
        self.leftButtonFunc = leftButtonFunc
        self.rightButtonFunc = rightButtonFunc
        
        super.init(frame: .zero)
        
        // Formatting image for left button
        if let leftButtonImageView = leftButtonImageView {
            leftButtonImageView.frame = CGRect(x: 0.044*DisplayUtility.screenWidth, y: 0, width: leftButtonImageView.frame.width, height: leftButtonImageView.frame.height)
            leftButtonImageView.center.y = 0.0537*DisplayUtility.screenHeight
            addSubview(leftButtonImageView)
            
            // Formatting left button
            let leftButton = UIButton()
            leftButton.frame = CGRect(x: leftButtonImageView.frame.minX - 0.02*DisplayUtility.screenWidth, y: leftButtonImageView.frame.minY - 0.02*DisplayUtility.screenWidth, width: leftButtonImageView.frame.width + 0.04*DisplayUtility.screenWidth, height: leftButtonImageView.frame.height + 0.04*DisplayUtility.screenWidth)
            leftButton.showsTouchWhenHighlighted = false
            leftButton.addTarget(self, action: #selector(leftButtonPressed(_:)), for: .touchUpInside)
            addSubview(leftButton)
        }
        
        // Formatting image for right button
        if let rightButtonImageView = rightButtonImageView {
            rightButtonImageView.frame = CGRect(x: (1-0.044)*DisplayUtility.screenWidth - rightButtonImageView.frame.width, y: 0, width: rightButtonImageView.frame.width, height: rightButtonImageView.frame.height)
            rightButtonImageView.center.y = 0.0537*DisplayUtility.screenHeight
            addSubview(rightButtonImageView)
            
            // Formatting right button
            let rightButton = UIButton()
            rightButton.frame = CGRect(x: rightButtonImageView.frame.minX - 0.02*DisplayUtility.screenWidth, y: rightButtonImageView.frame.minY - 0.02*DisplayUtility.screenWidth, width: rightButtonImageView.frame.width + 0.04*DisplayUtility.screenWidth, height: rightButtonImageView.frame.height + 0.04*DisplayUtility.screenWidth)
            rightButton.showsTouchWhenHighlighted = false
            rightButton.addTarget(self, action: #selector(rightButtonPressed(_:)), for: .touchUpInside)
            addSubview(rightButton)
        }
        
        // Creating main label
        mainLabel.text = mainText
        mainLabel.textColor = mainTextColor
        mainLabel.textAlignment = .center
        mainLabel.font = UIFont(name: "BentonSans-Light", size: 21)
        mainLabel.sizeToFit()
        mainLabel.frame = CGRect(x: 0, y: 0.07969*DisplayUtility.screenHeight, width: mainLabel.frame.width, height: mainLabel.frame.height)
        mainLabel.center.x = DisplayUtility.screenWidth / 2
        addSubview(mainLabel)
        
        
        // Creating sub label
        subLabel.text = subText
        subLabel.textColor = subTextColor
        subLabel.textAlignment = .center
        subLabel.font = UIFont(name: "BentonSans-Light", size: 12)
        subLabel.sizeToFit()
        subLabel.frame = CGRect(x: 0, y: mainLabel.frame.maxY + 0.0075*DisplayUtility.screenHeight, width: subLabel.frame.width, height: subLabel.frame.height)
        subLabel.center.x = DisplayUtility.screenWidth / 2
        addSubview(subLabel)
        
        frame = CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: mainLabel.frame.maxY + 0.045*DisplayUtility.screenHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func leftButtonPressed(_ sender: UIButton) {
        if let leftButtonFunc = leftButtonFunc {
            leftButtonFunc(sender)
        }
    }
    
    func rightButtonPressed(_ sender: UIButton) {
        if let rightButtonFunc = rightButtonFunc {
            rightButtonFunc(sender)
        }
    }
    
    func updateMainLabel(mainText: String, mainTextColor: UIColor? = nil) {
        mainLabel.text = mainText
        if let mainTextColor = mainTextColor {
            mainLabel.textColor = mainTextColor
        }
        mainLabel.sizeToFit()
        mainLabel.frame = CGRect(x: 0, y: mainLabel.frame.minY, width: mainLabel.frame.width, height: mainLabel.frame.height)
        mainLabel.center.x = DisplayUtility.screenWidth / 2
    }
    
    func updateSubLabel(subText: String, subTextColor: UIColor? = nil) {
        subLabel.text = subText
        if let subTextColor = subTextColor {
            subLabel.textColor = subTextColor
        }
        subLabel.sizeToFit()
        subLabel.frame = CGRect(x: 0, y: subLabel.frame.minY, width: subLabel.frame.width, height: subLabel.frame.height)
        subLabel.center.x = DisplayUtility.screenWidth / 2
    }
}

class ProfileHexagons: UIView, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let minY: CGFloat
    let parentVC: UIViewController
    let shouldShowDefaultFrame: Bool
    let shouldBeEditable: Bool
    
    let leftHexView: HexagonView
    let topHexView: HexagonView
    let rightHexView: HexagonView
    let bottomHexView: HexagonView
    
    var uploadMenu: UIView?
    let imagePicker = UIImagePickerController()
    
    init(minY: CGFloat, parentVC: UIViewController, hexImages: [UIImage],  shouldShowDefaultFrame: Bool, shouldBeEditable: Bool) {
        // initialize min y and parent view controller
        self.minY = minY
        self.parentVC = parentVC
        
        // initialize booleans
        self.shouldShowDefaultFrame = shouldShowDefaultFrame
        self.shouldBeEditable = shouldBeEditable
        
        // initialize hex views
        self.leftHexView = HexagonView()
        self.topHexView = HexagonView()
        self.rightHexView = HexagonView()
        self.bottomHexView = HexagonView()
        
        super.init(frame: CGRect.zero)
        
        // set hex frames
        let hexWidth = 0.38154*DisplayUtility.screenWidth
        let hexHeight = hexWidth * sqrt(3) / 2
        
        topHexView.frame = CGRect(x: 0, y: 0, width: hexWidth, height: hexHeight)
        topHexView.center.x = DisplayUtility.screenWidth / 2
        
        leftHexView.frame = CGRect(x: topHexView.frame.minX - 0.75*hexWidth - 3, y: topHexView.frame.midY + 2, width: hexWidth, height: hexHeight)
        
        rightHexView.frame = CGRect(x: topHexView.frame.minX + 0.75*hexWidth + 3, y: topHexView.frame.midY + 2, width: hexWidth, height: hexHeight)
        
        bottomHexView.frame = CGRect(x: topHexView.frame.minX, y: topHexView.frame.maxY + 4, width: hexWidth, height: hexHeight)
        
        // set hex backgrounds
        let hexViews = [leftHexView, topHexView, rightHexView, bottomHexView]
        for i in 0..<hexViews.count {
            let hexView = hexViews[i]
            if hexImages.count > i {
                hexView.setBackgroundImage(image: hexImages[i])
            } else {
                hexView.setDefaultBackgorund()
            }
        }
        
        // possibly add frame to default hex
        if shouldShowDefaultFrame {
            let borderColor = DisplayUtility.gradientColor(size: leftHexView.frame.size)
            leftHexView.addBorder(width: 3.0, color: borderColor)
        }
        
        // add hexes to view
        addSubview(rightHexView)
        addSubview(topHexView)
        addSubview(leftHexView)
        addSubview(bottomHexView)
        
        // set frame of view
        frame = CGRect(x: 0, y: minY, width: DisplayUtility.screenWidth, height: bottomHexView.frame.maxY)
        
        // add gesture recognizers
        let leftHexGR = UITapGestureRecognizer(target: self, action: #selector(hexSelected(_:)))
        leftHexView.addGestureRecognizer(leftHexGR)
        
        let topHexGR = UITapGestureRecognizer(target: self, action: #selector(hexSelected(_:)))
        topHexView.addGestureRecognizer(topHexGR)
        
        let rightHexGR = UITapGestureRecognizer(target: self, action: #selector(hexSelected(_:)))
        rightHexView.addGestureRecognizer(rightHexGR)
        
        let bottomHexGR = UITapGestureRecognizer(target: self, action: #selector(hexSelected(_:)))
        bottomHexView.addGestureRecognizer(bottomHexGR)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addImage(hexImage: UIImage) {
        for hexView in [leftHexView, topHexView, rightHexView, bottomHexView] {
            if hexView.hexBackgroundImage == nil {
                hexView.setBackgroundImage(image: hexImage)
                break
            }
        }
    }
    
    func addHexImages(from picFiles: [PFFile], startingAt i: Int) {
        if i >= picFiles.count { // done adding
            return
        }
        let picFile = picFiles[i]
        picFile.getDataInBackground(block: { (data, error) in
            if error != nil {
                print(error!)
            } else {
                if let data = data {
                    if let image = UIImage(data: data) {
                        self.addImage(hexImage: image)
                    }
                }
            }
            self.addHexImages(from: picFiles, startingAt: i+1) // add rest of images
        })
    }
    
    func getImages() -> [UIImage] {
        var hexImages = [UIImage]()
        for hexView in [leftHexView, topHexView, rightHexView, bottomHexView] {
            if let hexImage = hexView.hexBackgroundImage {
                hexImages.append(hexImage)
            } else {
                break
            }
        }
        return hexImages
    }
    
    func setImages(hexImages: [UIImage]) {
        let hexViews = [leftHexView, topHexView, rightHexView, bottomHexView]
        for i in 0..<hexViews.count {
            if hexImages.count > i {
                hexViews[i].setBackgroundImage(image: hexImages[i])
            } else {
                hexViews[i].setDefaultBackgorund()
            }
        }
    }
    
    func hexSelected(_ gesture: UIGestureRecognizer) {
        if let hexView = gesture.view as? HexagonView {
            if hexView.hexBackgroundImage != nil {
                var images = [UIImage]()
                var originalHexFrames = [CGRect]()
                var startingIndex = 0
                let hexViews = [leftHexView, topHexView, rightHexView, bottomHexView]
                for i in 0..<hexViews.count {
                    if let image = hexViews[i].hexBackgroundImage {
                        images.append(image)
                    }
                    let hexFrame = convert(hexViews[i].frame, to: parentVC.view)
                    originalHexFrames.append(hexFrame)
                    if hexViews[i] == hexView {
                        startingIndex = i
                    }
                }
                let profilePicsView = ProfilePicturesView(images: images, originalHexFrames: originalHexFrames, hexViews: hexViews, startingIndex: startingIndex, shouldShowEditButtons: shouldBeEditable, parentVC: parentVC)
                parentVC.view.addSubview(profilePicsView)
                profilePicsView.animateIn()
            } else if shouldBeEditable && leftHexView.hexBackgroundImage == nil { // no images
                showUploadMenu()
            }
        }
    }
    
    func showUploadMenu() {
        if uploadMenu == nil { // layout upload menu
            uploadMenu = UIView()
            
            uploadMenu!.backgroundColor = .white
            
            uploadMenu!.frame = CGRect(x: 0, y: DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight)
            uploadMenu!.center.x = DisplayUtility.screenWidth / 2
            
            // add gesture recognizer to hide upload menu
            let hideUploadMenuGR = UITapGestureRecognizer(target: self, action: #selector(hideUploadMenu(_:)))
            uploadMenu!.addGestureRecognizer(hideUploadMenuGR)
            
            let uploadButtonWidth = 0.66*DisplayUtility.screenWidth
            let uploadButtonHeight = 0.14*DisplayUtility.screenWidth
            
            // layout upload from Facebook button
            let uploadFromFBButton = UIButton()
            uploadFromFBButton.frame = CGRect(x: 0, y: 0, width: uploadButtonWidth, height: uploadButtonHeight)
            uploadFromFBButton.center.x = uploadMenu!.frame.width / 2
            uploadFromFBButton.center.y = 0.4*uploadMenu!.frame.height
            uploadFromFBButton.setTitle("UPLOAD FROM FACEBOOK", for: .normal)
            uploadFromFBButton.setTitleColor(.black, for: .normal)
            uploadFromFBButton.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 13)
            uploadFromFBButton.titleLabel?.textAlignment = .center
            uploadFromFBButton.layer.borderWidth = 1
            uploadFromFBButton.layer.borderColor = UIColor.gray.cgColor
            uploadFromFBButton.layer.cornerRadius = 0.3*uploadFromFBButton.frame.height
            
            // add target to upload from Facebook button
            uploadFromFBButton.addTarget(self, action: #selector(uploadFromFB(_:)), for: .touchUpInside)
            
            uploadMenu!.addSubview(uploadFromFBButton)
            
            // layout upload from camera roll button
            let uploadFromCameraRollButton = UIButton()
            uploadFromCameraRollButton.frame = CGRect(x: 0, y: 0, width: uploadButtonWidth, height: uploadButtonHeight)
            uploadFromCameraRollButton.center.x = uploadMenu!.frame.width / 2
            uploadFromCameraRollButton.center.y = 0.6*uploadMenu!.frame.height
            uploadFromCameraRollButton.setTitle("UPLOAD FROM CAMERA ROLL", for: .normal)
            uploadFromCameraRollButton.setTitleColor(.black, for: .normal)
            uploadFromCameraRollButton.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 13)
            uploadFromCameraRollButton.titleLabel?.textAlignment = .center
            uploadFromCameraRollButton.layer.borderWidth = 1
            uploadFromCameraRollButton.layer.borderColor = UIColor.gray.cgColor
            uploadFromCameraRollButton.layer.cornerRadius = 0.3*uploadFromCameraRollButton.frame.height
            uploadMenu!.addSubview(uploadFromCameraRollButton)
            
            // add target to upload from camera roll button
            uploadFromCameraRollButton.addTarget(self, action: #selector(uploadFromCameraRoll(_:)), for: .touchUpInside)
        }
        
        // animate upload menu with move up effect
        uploadMenu!.frame = CGRect(x: 0, y: DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight)
        uploadMenu!.center.x = DisplayUtility.screenWidth / 2
        
        parentVC.view.addSubview(uploadMenu!)
        UIView.animate(withDuration: 0.5) {
            self.uploadMenu!.frame = self.parentVC.view.bounds
        }
    }
    
    func uploadFromFB(_ button: UIButton) {
        if let uploadMenu = uploadMenu {
            uploadMenu.removeFromSuperview()
        }
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name"])
        graphRequest?.start{ (_, result, error) -> Void in
            if error != nil {
                print(error!)
            }
            else if let result = result as? [String: AnyObject]{
                let userId = result["id"]! as! String
                let facebookProfilePictureUrl = "https://graph.facebook.com/" + userId + "/picture?type=large"
                if let fbpicUrl = URL(string: facebookProfilePictureUrl) {
                    if let data = try? Data(contentsOf: fbpicUrl) {
                        DispatchQueue.main.async(execute: {
                            if let image = UIImage(data: data) {
                                self.leftHexView.setBackgroundImage(image: image)
                            }
                            if let user = PFUser.current() {
                                if let picFile = PFFile(data: data) {
                                    user["profile_pictures"] = [picFile]
                                    user.saveInBackground()
                                }
                            }
                        })
                    }
                }
            }
        }
    }
    
    func uploadFromCameraRoll(_ button: UIButton) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        parentVC.present(imagePicker, animated: true, completion: nil)
    }
    
    //update the UIImageView once an image has been picked
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let uploadMenu = uploadMenu {
            uploadMenu.removeFromSuperview()
        }
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            leftHexView.setBackgroundImage(image: image)
            if let data = UIImageJPEGRepresentation(image, 1.0) {
                if let user = PFUser.current() {
                    if let picFile = PFFile(data: data) {
                        user["profile_pictures"] = [picFile]
                        user.saveInBackground()
                    }
                }
            }
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func hideUploadMenu(_ gesture: UIGestureRecognizer) {
        if let uploadMenu = uploadMenu {
            UIView.animate(withDuration: 0.5, animations: {
                uploadMenu.frame = CGRect(x: 0, y: DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight)
            }) { (finished) in
                if finished {
                    uploadMenu.removeFromSuperview()
                }
            }
        }
    }
}

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
}
