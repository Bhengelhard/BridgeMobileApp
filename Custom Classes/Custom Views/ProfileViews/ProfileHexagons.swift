//
//  ProfileHexagons.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 1/26/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Parse

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
