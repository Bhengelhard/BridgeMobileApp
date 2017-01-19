//
//  EditProfilePictureView.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 1/16/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Parse

class ProfilePicturesView: UIView, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let originalHexFrames: [CGRect]
    var images: [UIImage]
    let startingIndex: Int
    let shouldShowEditButtons: Bool
    let allPicsVC: ProfilePicturesViewController
    let picFrame: CGRect
    let parentVC: UIViewController
    
    var singlePicVCs = [UIViewController]()
    let editButtonsView = UIView()
    let uploadMenu = UIView()
    let imagePicker = UIImagePickerController()
    
    var shouldDisplayDefaultButton = true
    var shouldDisplayDeleteButton = true
    
    init(images: [UIImage], originalHexFrames: [CGRect], startingIndex: Int, shouldShowEditButtons: Bool, parentVC: UIViewController) {
        self.images = images
        self.originalHexFrames = originalHexFrames
        self.startingIndex = startingIndex
        self.shouldShowEditButtons = shouldShowEditButtons
        self.parentVC = parentVC
        
        let picWidth = DisplayUtility.screenWidth
        let picHeight = picWidth * originalHexFrames[startingIndex].height / originalHexFrames[startingIndex].width
        
        picFrame = CGRect(x: 0, y: 0.2*DisplayUtility.screenHeight, width: picWidth, height: picHeight)
        
        for _ in 0..<images.count {
            let singlePicVC = UIViewController()
            singlePicVCs.append(singlePicVC)
        }
        
        allPicsVC = ProfilePicturesViewController(vcs: singlePicVCs, initialVC: singlePicVCs[startingIndex])
        
        super.init(frame: CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight))
        
        backgroundColor = .white
        
        imagePicker.delegate = self
        
        // add gesture recognizer to exit
        let exitGR = UITapGestureRecognizer(target: self, action: #selector(exit(_:)))
        addGestureRecognizer(exitGR)
        
        // add gesture recognizer to prevent exit
        let doNothingGR = UITapGestureRecognizer(target: self, action: nil)
        allPicsVC.view.addGestureRecognizer(doNothingGR)
        
        resetImagesForVCs()
        
        allPicsVC.view.alpha = 0
        allPicsVC.view.frame = CGRect(x: picFrame.minX, y: picFrame.minY - allPicsVC.pageControl.frame.maxY, width: picFrame.width, height: picFrame.height + allPicsVC.pageControl.frame.maxY)
        
        addSubview(allPicsVC.view)
        
        
        if shouldShowEditButtons {
        
            let buttonWidth = 0.33*DisplayUtility.screenWidth
            let buttonHeight = 0.07*DisplayUtility.screenWidth
            
            let spaceBetweenButtons = 0.03*DisplayUtility.screenHeight
            var buttonY: CGFloat = 0.0
            
            let uploadButton = UIButton()
            uploadButton.frame = CGRect(x: 0, y: buttonY, width: buttonWidth, height: buttonHeight)
            uploadButton.center.x = DisplayUtility.screenWidth / 2
            uploadButton.contentVerticalAlignment = .fill
            uploadButton.setTitle("UPLOAD", for: .normal)
            uploadButton.setTitleColor(.black, for: .normal)
            uploadButton.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 13)
            uploadButton.titleLabel?.textAlignment = .center
            uploadButton.layer.borderWidth = 1
            uploadButton.layer.borderColor = UIColor.gray.cgColor
            uploadButton.layer.cornerRadius = 0.3*uploadButton.frame.height
            uploadButton.addTarget(self, action: #selector(uploadButtonPressed(_:)), for: .touchUpInside)
            editButtonsView.addSubview(uploadButton)
            
            buttonY = buttonY + buttonHeight + spaceBetweenButtons
            
            if shouldDisplayDefaultButton {
                let defaultButton = UIButton()
                defaultButton.frame = CGRect(x: 0, y: buttonY, width: buttonWidth, height: buttonHeight)
                defaultButton.center.x = DisplayUtility.screenWidth / 2
                defaultButton.contentVerticalAlignment = .fill
                defaultButton.setTitle("SET DEFAULT", for: .normal)
                defaultButton.setTitleColor(.black, for: .normal)
                defaultButton.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 13)
                defaultButton.titleLabel?.textAlignment = .center
                defaultButton.layer.borderWidth = 1
                defaultButton.layer.borderColor = UIColor.gray.cgColor
                defaultButton.layer.cornerRadius = 0.3*defaultButton.frame.height
                editButtonsView.addSubview(defaultButton)
                
                buttonY = buttonY + buttonHeight + spaceBetweenButtons
            }
            
            if shouldDisplayDeleteButton {
                let deleteButton = UIButton()
                deleteButton.frame = CGRect(x: 0, y: buttonY, width: buttonWidth, height: buttonHeight)
                deleteButton.center.x = DisplayUtility.screenWidth / 2
                deleteButton.contentVerticalAlignment = .fill
                deleteButton.setTitle("DELETE", for: .normal)
                deleteButton.setTitleColor(.black, for: .normal)
                deleteButton.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 13)
                deleteButton.titleLabel?.textAlignment = .center
                deleteButton.layer.borderWidth = 1
                deleteButton.layer.borderColor = UIColor.gray.cgColor
                deleteButton.layer.cornerRadius = 0.3*deleteButton.frame.height
                editButtonsView.addSubview(deleteButton)
                
                buttonY = buttonY + buttonHeight + spaceBetweenButtons
            }
            
            editButtonsView.frame = CGRect(x: 0, y: allPicsVC.view.frame.maxY + 0.045*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: uploadButton.frame.maxY)
            editButtonsView.alpha = 0
            addSubview(editButtonsView)
        }
    }
    
    func resetImagesForVCs() {
        for i in 0..<singlePicVCs.count {
            let singlePicVC = singlePicVCs[i]
            let image = images[i]
            let picView = UIView()
            picView.frame = CGRect(x: 0, y: allPicsVC.pageControl.frame.maxY, width: picFrame.width, height: picFrame.height)
            let viewSize = CGSize(width: singlePicVC.view.frame.width, height: singlePicVC.view.frame.width)
            if let newImage = fitImageToView(image: image, viewSize: viewSize) {
                picView.backgroundColor = UIColor(patternImage: newImage)
            } else {
                picView.backgroundColor = UIColor(patternImage: image)
            }
            picView.layer.borderWidth = 1
            picView.layer.borderColor = UIColor.black.cgColor
            singlePicVC.view.addSubview(picView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateIn() {
        let hexView = HexagonView()
        hexView.frame = originalHexFrames[startingIndex]
        hexView.setBackgroundImage(image: images[startingIndex])
        addSubview(hexView)
        UIView.animate(withDuration: 0.5, animations: {
            hexView.frame = CGRect(x: 0, y: self.picFrame.minY, width: self.picFrame.width, height: self.picFrame.height)
            hexView.resetBackgroundImage()
        }) { (finished) in
            if finished {
                hexView.removeFromSuperview()
                self.allPicsVC.view.alpha = 1
                self.editButtonsView.alpha = 1
            }
        }
    }
    
    func animateOut(completion: ((Bool) -> Void)?) {
        let hexView = HexagonView()
        hexView.frame = CGRect(x: 0, y: self.picFrame.minY, width: self.picFrame.width, height: self.picFrame.height)
        let index = allPicsVC.pageControl.currentPage
        hexView.setBackgroundImage(image: images[index])
        addSubview(hexView)
        self.allPicsVC.view.alpha = 0
        self.editButtonsView.alpha = 0
        UIView.animate(withDuration: 0.5, animations: { 
            hexView.frame = self.originalHexFrames[index]
            hexView.resetBackgroundImage()
        }, completion: completion)
    }
    
    func exit(_ gesture: UIGestureRecognizer) {
        self.animateOut { (finished) in
            if finished {
                self.removeFromSuperview()
            }
        }
    }
    
    func fitImageToView(image: UIImage, viewSize: CGSize) -> UIImage? {
        var resultImage: UIImage?
        UIGraphicsBeginImageContext(viewSize)
        image.draw(in: CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height))
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return resultImage;
    }
    
    func uploadButtonPressed(_ button: UIButton) {
        uploadMenu.frame = CGRect(x: 0, y: DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight)
        uploadMenu.center.x = DisplayUtility.screenWidth / 2
        uploadMenu.backgroundColor = .white
        addSubview(uploadMenu)
        
        // add gesture recognizer to hide upload menu
        let hideUploadMenuGR = UITapGestureRecognizer(target: self, action: #selector(hideUploadMenu(_:)))
        uploadMenu.addGestureRecognizer(hideUploadMenuGR)
        
        let uploadButtonWidth = 0.66*DisplayUtility.screenWidth
        let uploadButtonHeight = 0.14*DisplayUtility.screenWidth
        
        // layout upload from Facebook button
        let uploadFromFBButton = UIButton()
        uploadFromFBButton.frame = CGRect(x: 0, y: 0, width: uploadButtonWidth, height: uploadButtonHeight)
        uploadFromFBButton.center.x = uploadMenu.frame.width / 2
        uploadFromFBButton.center.y = 0.4*uploadMenu.frame.height
        uploadFromFBButton.setTitle("UPLOAD FROM FACEBOOK", for: .normal)
        uploadFromFBButton.setTitleColor(.black, for: .normal)
        uploadFromFBButton.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 13)
        uploadFromFBButton.titleLabel?.textAlignment = .center
        uploadFromFBButton.layer.borderWidth = 1
        uploadFromFBButton.layer.borderColor = UIColor.gray.cgColor
        uploadFromFBButton.layer.cornerRadius = 0.3*uploadFromFBButton.frame.height
        
        // add target to upload from Facebook button
        uploadFromFBButton.addTarget(self, action: #selector(uploadFromFB(_:)), for: .touchUpInside)
        
        uploadMenu.addSubview(uploadFromFBButton)
        
        // layout upload from camera roll button
        let uploadFromCameraRollButton = UIButton()
        uploadFromCameraRollButton.frame = CGRect(x: 0, y: 0, width: uploadButtonWidth, height: uploadButtonHeight)
        uploadFromCameraRollButton.center.x = uploadMenu.frame.width / 2
        uploadFromCameraRollButton.center.y = 0.6*uploadMenu.frame.height
        uploadFromCameraRollButton.setTitle("UPLOAD FROM CAMERA ROLL", for: .normal)
        uploadFromCameraRollButton.setTitleColor(.black, for: .normal)
        uploadFromCameraRollButton.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 13)
        uploadFromCameraRollButton.titleLabel?.textAlignment = .center
        uploadFromCameraRollButton.layer.borderWidth = 1
        uploadFromCameraRollButton.layer.borderColor = UIColor.gray.cgColor
        uploadFromCameraRollButton.layer.cornerRadius = 0.3*uploadFromCameraRollButton.frame.height
        uploadMenu.addSubview(uploadFromCameraRollButton)
        
        // add target to upload from camera roll button
        uploadFromCameraRollButton.addTarget(self, action: #selector(uploadFromCameraRoll(_:)), for: .touchUpInside)
        
        UIView.animate(withDuration: 0.5) { 
            self.uploadMenu.frame = self.bounds
        }
    }
    
    func uploadFromFB(_ button: UIButton) {
        uploadMenu.removeFromSuperview()
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name"])
        graphRequest?.start{ (connection, result, error) -> Void in
            if error != nil {
                print(error)
            }
            else if let result = result as? [String: AnyObject]{
                let userId = result["id"]! as! String
                let facebookProfilePictureUrl = "https://graph.facebook.com/" + userId + "/picture?type=large"
                if let fbpicUrl = URL(string: facebookProfilePictureUrl) {
                    if let data = try? Data(contentsOf: fbpicUrl) {
                        DispatchQueue.main.async(execute: {
                            if let image = UIImage(data: data) {
                                self.images[self.allPicsVC.pageControl.currentPage] = image
                                self.resetImagesForVCs()
                            }
                            if let user = PFUser.current() {
                                if let picFile = PFFile(data: data) {
                                    if var profilePictures = user["profile_pictures"] as? [PFFile] {
                                        profilePictures[self.allPicsVC.pageControl.currentPage] = picFile
                                        user["profile_pictures"] = profilePictures
                                        user.saveInBackground()
                                    }
                                }
                            }
                        })
                    }
                }
            }
        }
    }
    
    func hideUploadMenu(_ gesture: UIGestureRecognizer) {
        UIView.animate(withDuration: 0.5, animations: { 
            self.uploadMenu.frame = CGRect(x: 0, y: DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight)
        }) { (finished) in
            if finished {
                self.uploadMenu.removeFromSuperview()
            }
        }
    }
    
    func uploadFromCameraRoll(_ button: UIButton) {
        imagePicker.sourceType = .photoLibrary
        parentVC.present(imagePicker, animated: true, completion: nil)
    }
    
    //update the UIImageView once an image has been picked
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        uploadMenu.removeFromSuperview()
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.images[self.allPicsVC.pageControl.currentPage] = pickedImage
            self.resetImagesForVCs()
            if let data = UIImageJPEGRepresentation(pickedImage, 1.0) {
                if let user = PFUser.current() {
                    if let picFile = PFFile(data: data) {
                        if var profilePictures = user["profile_pictures"] as? [PFFile] {
                            profilePictures[self.allPicsVC.pageControl.currentPage] = picFile
                            user["profile_pictures"] = profilePictures
                            user.saveInBackground()
                        }
                    }
                }
            }
        }
        parentVC.dismiss(animated: true, completion: nil)

    }
    
    
}
