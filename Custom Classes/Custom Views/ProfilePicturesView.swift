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

class ProfilePicturesView: UIView, UIImagePickerControllerDelegate, FacebookImagePickerControllerDelegate, UINavigationControllerDelegate, CropImageViewControllerDelegate {
    
    let originalHexFrames: [CGRect]
    var images: [UIImage]
    let hexViews: [HexagonView]
    let startingIndex: Int
    let shouldShowEditButtons: Bool
    let allPicsVC: ProfilePicturesViewController
    let picFrame: CGRect
    let parentVC: UIViewController
    
    var singlePicVCs = [UIViewController]()
    let editButtonsView = UIView()
    let uploadMenu = UIView()
    var cropButton = UIButton()
    var uploadButton = UIButton()
    var defaultButton = UIButton()
    var deleteButton = UIButton()
    let fbImagePicker = FacebookImagePickerController()
    let imagePicker = UIImagePickerController()
    
    init(images: [UIImage], originalHexFrames: [CGRect], hexViews: [HexagonView], startingIndex: Int, shouldShowEditButtons: Bool, parentVC: UIViewController) {
        self.images = images
        self.originalHexFrames = originalHexFrames
        self.hexViews = hexViews
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
        
        self.allPicsVC = ProfilePicturesViewController(vcs: singlePicVCs, initialVC: singlePicVCs[startingIndex])
        
        super.init(frame: parentVC.view.bounds)
        
        backgroundColor = .white
        
        fbImagePicker.delegate = self
        imagePicker.delegate = self
        
        // add gesture recognizer to exit
        let exitGR = UITapGestureRecognizer(target: self, action: #selector(exit(_:)))
        addGestureRecognizer(exitGR)
                
        resetImagesForVCs()
        
        allPicsVC.view.alpha = 0
        allPicsVC.view.frame = CGRect(x: picFrame.minX, y: picFrame.minY - allPicsVC.pageControl.frame.maxY, width: picFrame.width, height: picFrame.height + allPicsVC.pageControl.frame.maxY)
        
        addSubview(allPicsVC.view)
        
        if shouldShowEditButtons {
            layoutEditButtonsView()
        }
        
    }
    
    func layoutEditButtonsView() {
        
        let buttonWidth = 0.33*DisplayUtility.screenWidth
        let buttonHeight = 0.07*DisplayUtility.screenWidth
        
        let spaceBetweenButtons = 0.015*DisplayUtility.screenHeight
        var buttonY: CGFloat = 0.0
        
        // create crop button
        let cropButtonFrame = CGRect(x: 0, y: buttonY, width: buttonWidth, height: buttonHeight)
        cropButton = DisplayUtility.plainButton(frame: cropButtonFrame, text: "CROP", fontSize: 13)
        cropButton.center.x = DisplayUtility.screenWidth / 2
        editButtonsView.addSubview(cropButton)
        
        // add target for crop button
        cropButton.addTarget(self, action: #selector(cropButtonPressed(_:)), for: .touchUpInside)
        
        // update buttonY
        buttonY = buttonY + buttonHeight + spaceBetweenButtons
        
        
        // create upload button
        let uploadButtonFrame = CGRect(x: 0, y: buttonY, width: buttonWidth, height: buttonHeight)
        uploadButton = DisplayUtility.plainButton(frame: uploadButtonFrame, text: "UPLOAD", fontSize: 13)
        uploadButton.center.x = DisplayUtility.screenWidth / 2
        editButtonsView.addSubview(uploadButton)
        
        // add target for upload button
        uploadButton.addTarget(self, action: #selector(uploadButtonPressed(_:)), for: .touchUpInside)
        
        // update buttonY
        buttonY = buttonY + buttonHeight + spaceBetweenButtons
        
        
        // create default button
        let defaultButtonFrame = CGRect(x: 0, y: buttonY, width: buttonWidth, height: buttonHeight)
        defaultButton = DisplayUtility.plainButton(frame: defaultButtonFrame, text: "SET DEFAULT", fontSize: 13)
        defaultButton.center.x = DisplayUtility.screenWidth / 2
        editButtonsView.addSubview(defaultButton)
        
        // add target for default button
        defaultButton.addTarget(self, action: #selector(defaultButtonPressed(_:)), for: .touchUpInside)
        
        // update buttonY
        buttonY = buttonY + buttonHeight + spaceBetweenButtons
        
        
        // create delete button
        let deleteButtonFrame = CGRect(x: 0, y: buttonY, width: buttonWidth, height: buttonHeight)
        deleteButton = DisplayUtility.plainButton(frame: deleteButtonFrame, text: "DELETE", fontSize: 13)
        deleteButton.center.x = DisplayUtility.screenWidth / 2
        editButtonsView.addSubview(deleteButton)
        
        // add target for delete button
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed(_:)), for: .touchUpInside)
        
        // update buttonY
        buttonY = buttonY + buttonHeight + spaceBetweenButtons
        
        
        editButtonsView.frame = CGRect(x: 0, y: allPicsVC.view.frame.maxY + 0.03*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: buttonY)
        editButtonsView.alpha = 0
        addSubview(editButtonsView)
    }
    
    func resetImagesForVCs() {
        // add vcs if not enough
        for _ in singlePicVCs.count..<images.count {
            let singlePicVC = UIViewController()
            singlePicVCs.append(singlePicVC)
        }
        for i in 0..<singlePicVCs.count {
            let singlePicVC = singlePicVCs[i]
            let image = images[i]
            let picView = UIImageView()
            picView.contentMode = .scaleAspectFill
            picView.clipsToBounds = true
            picView.frame = CGRect(x: 0, y: allPicsVC.pageControl.frame.maxY, width: picFrame.width, height: picFrame.height)
            picView.image = image
            singlePicVC.view.addSubview(picView)
        }
        allPicsVC.vcs = singlePicVCs
        allPicsVC.profilePicturesDelegate?.profilePicturesViewController(allPicsVC, didUpdatePageCount: singlePicVCs.count)
        
        if singlePicVCs.count <= 1 {
            deleteButton.alpha = 0
        } else {
            deleteButton.alpha = 1
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
        
        let rectView = UIImageView()
        rectView.frame = hexView.frame
        rectView.contentMode = .scaleAspectFill
        rectView.clipsToBounds = true
        rectView.image = images[startingIndex]
        rectView.alpha = 0
        addSubview(rectView)

        UIView.animate(withDuration: 0.5, animations: {
            hexView.frame = CGRect(x: 0, y: self.picFrame.minY, width: self.picFrame.width, height: self.picFrame.height)
            hexView.resetBackgroundImage()
            rectView.frame = CGRect(x: 0, y: self.picFrame.minY, width: self.picFrame.width, height: self.picFrame.height)
            rectView.alpha = 1
        }) { (finished) in
            if finished {
                hexView.removeFromSuperview()
                rectView.removeFromSuperview()
                self.allPicsVC.view.alpha = 1
                self.editButtonsView.alpha = 1
            }
        }
    }
    
    func animateOut(completion: ((Bool) -> Void)?) {
        let index = allPicsVC.pageControl.currentPage
        
        let hexView = HexagonView()
        hexView.frame = CGRect(x: 0, y: self.picFrame.minY, width: self.picFrame.width, height: self.picFrame.height)
        hexView.setBackgroundImage(image: images[index])
        addSubview(hexView)
        
        let rectView = UIImageView()
        rectView.frame = hexView.frame
        rectView.contentMode = .scaleAspectFill
        rectView.clipsToBounds = true
        rectView.image = images[index]
        rectView.alpha = 1
        addSubview(rectView)
        
        self.allPicsVC.view.alpha = 0
        self.editButtonsView.alpha = 0
        UIView.animate(withDuration: 0.5, animations: { 
            hexView.frame = self.originalHexFrames[index]
            hexView.resetBackgroundImage()
            rectView.frame = self.originalHexFrames[index]
            rectView.alpha = 0
        }) { (finished) in
            if (finished) {
                hexView.removeFromSuperview()
                rectView.removeFromSuperview()
            }
            if let completion = completion {
                completion(finished)
            }
        }
    }
    
    func exit(_ gesture: UIGestureRecognizer) {
        for i in 0..<hexViews.count {
            if i < images.count {
                hexViews[i].setBackgroundImage(image: images[i])
            } else {
                hexViews[i].setDefaultBackground()
            }
        }
        self.animateOut { (finished) in
            if finished {
                self.removeFromSuperview()
            }
        }
    }
    
    func cropButtonPressed(_ gesture: UIGestureRecognizer) {
        var croppedImageFrame: CGRect?
        if let user = PFUser.current() {
            let index = allPicsVC.pageControl.currentPage
            if let croppedImageFrames = user["cropped_image_frames"] as? [[String: CGFloat]?] {
                if croppedImageFrames.count > index {
                    if let croppedImageFrameDict = croppedImageFrames[index] {
                        if let x = croppedImageFrameDict["X"], let y = croppedImageFrameDict["Y"],
                            let width = croppedImageFrameDict["Width"], let height = croppedImageFrameDict["Height"] {
                            croppedImageFrame = CGRect(x: x, y: y, width: width, height: height)
                        }
                    }
                }
            }
            if let profilePictureFiles = user["profile_pictures"] as? [PFFile] {
                let profilePictureFile = profilePictureFiles[index]
                profilePictureFile.getDataInBackground(block: { (data, error) in
                    if let error = error {
                        print("error - getting propic data - \(error)")
                    } else if let data = data {
                        if let image = UIImage(data: data) {
                            let cropImageVC = CropImageViewController(image: image, croppedImageFrame: croppedImageFrame)
                            cropImageVC.delegate = self
                            self.parentVC.present(cropImageVC, animated: true, completion: nil)
                        }
                    }
                })
            }
        }
        /*
        let cropImageVC = CropImageViewController(image: images[allPicsVC.pageControl.currentPage], croppedImageFrame: croppedImageFrame)
        cropImageVC.delegate = self
        parentVC.present(cropImageVC, animated: true, completion: nil)
 */
    }
    
    func cropImageViewController(cropImageViewController: CropImageViewController, didCropImageTo croppedImage: UIImage, withCroppedImageFrame croppedImageFrame: CGRect) {
        let index = allPicsVC.pageControl.currentPage

        if let user = PFUser.current() {
            // save cropped picture to user
            if let data = UIImageJPEGRepresentation(croppedImage, 1.0) {
                if let croppedImageFile = PFFile(data: data) {
                    var croppedImages: [PFFile?]
                    if let croppedProfilePictures = user["cropped_profile_pictures"] as? [PFFile?] {
                        croppedImages = croppedProfilePictures
                    } else {
                        croppedImages = [PFFile?]()
                    }
                    while croppedImages.count <= index {
                        croppedImages.append(nil)
                    }
                    croppedImages[index] = croppedImageFile
                    user["cropped_profile_pictures"] = croppedImages
                }
            }
            
            // save frame of crop box to user
            if let croppedImageFrameDict = croppedImageFrame.dictionaryRepresentation as? [String: CGFloat] {
                var croppedImageFrames: [[String: CGFloat]?]
                if let userCroppedImageFrames = user["cropped_image_frames"] as? [[String: CGFloat]?] {
                    croppedImageFrames = userCroppedImageFrames
                } else {
                    croppedImageFrames = [[String:CGFloat]?]()
                }
                while croppedImageFrames.count <= index {
                    croppedImageFrames.append(nil)
                }
                croppedImageFrames[index] = croppedImageFrameDict
                user["cropped_image_frames"] = croppedImageFrames
            }
            
            user.saveInBackground(block: { (succeeded, error) in
                if let error = error {
                    print("error - saving user's cropped pic - \(error)")
                } else if succeeded {
                    print("successfully saved user's cropped pic")
                } else {
                    print("did not successfully save user's cropped pic")
                }
            })
        }
        
        images[index] = croppedImage
        resetImagesForVCs()
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
        
        
        // create upload from Facebook button
        let uploadFBButtonFrame = CGRect(x: 0, y: 0, width: uploadButtonWidth, height: uploadButtonHeight)
        let uploadFBButton = DisplayUtility.plainButton(frame: uploadFBButtonFrame, text: "UPLOAD FROM FACEBOOK", fontSize: 13)
        uploadFBButton.center = CGPoint(x: 0.5*uploadMenu.frame.width, y: 0.4*uploadMenu.frame.height)
        uploadMenu.addSubview(uploadFBButton)

        // add target to upload from Facebook button
        uploadFBButton.addTarget(self, action: #selector(uploadFromFB(_:)), for: .touchUpInside)
        
        
        // create upload from camera roll button
        let uploadCameraRollButtonFrame = CGRect(x: 0, y: 0, width: uploadButtonWidth, height: uploadButtonHeight)
        let uploadCameraRollButton = DisplayUtility.plainButton(frame: uploadCameraRollButtonFrame, text: "UPLOAD FROM CAMERA ROLL", fontSize: 13)
        uploadCameraRollButton.center = CGPoint(x: 0.5*uploadMenu.frame.width, y: 0.6*uploadMenu.frame.height)
        uploadMenu.addSubview(uploadCameraRollButton)
        
        // add target to upload from camera roll button
        uploadCameraRollButton.addTarget(self, action: #selector(uploadFromCameraRoll(_:)), for: .touchUpInside)
        
        UIView.animate(withDuration: 0.5) {
            self.uploadMenu.frame = self.bounds
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
    
    func uploadFromFB(_ button: UIButton) {
        parentVC.present(fbImagePicker, animated: true, completion: nil)
    }
    
    // update the UIImageView once an image has been picked
    func fbImagePickerController(_ picker: FacebookImagePickerController, didPickImage image: UIImage) {
        uploadMenu.removeFromSuperview()
        
        let index = self.allPicsVC.pageControl.currentPage
        var nextPageNum = index
        if self.images.count == 4 {
            self.images[index] = image
        } else {
            self.images.append(image)
            nextPageNum = self.images.count-1
        }
        self.resetImagesForVCs()
        if let data = UIImageJPEGRepresentation(image, 1.0) {
            if let user = PFUser.current() {
                if let picFile = PFFile(data: data) {
                    if var profilePictures = user["profile_pictures"] as? [PFFile] {
                        if profilePictures.count == 4 {
                            profilePictures[index] = picFile
                        } else {
                            profilePictures.append(picFile)
                        }
                        user["profile_pictures"] = profilePictures
                        user.saveInBackground()
                    }
                }
            }
        }
        self.allPicsVC.profilePicturesDelegate?.profilePicturesViewController(self.allPicsVC, didUpdatePageCount: self.images.count)
        self.allPicsVC.goToPage(index: nextPageNum)
        
        parentVC.dismiss(animated: true, completion: nil)
    }
    
    func uploadFromCameraRoll(_ button: UIButton) {
        imagePicker.sourceType = .photoLibrary
        parentVC.present(imagePicker, animated: true, completion: nil)
    }
    
    //update the UIImageView once an image has been picked
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        uploadMenu.removeFromSuperview()
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let index = self.allPicsVC.pageControl.currentPage
            var nextPageNum = index
            if self.images.count == 4 {
                self.images[index] = image
            } else {
                self.images.append(image)
                nextPageNum = self.images.count-1
            }
            self.resetImagesForVCs()
            if let data = UIImageJPEGRepresentation(image, 1.0) {
                if let user = PFUser.current() {
                    if let picFile = PFFile(data: data) {
                        if var profilePictures = user["profile_pictures"] as? [PFFile] {
                            if profilePictures.count == 4 {
                                profilePictures[index] = picFile
                            } else {
                                profilePictures.append(picFile)
                            }
                            user["profile_pictures"] = profilePictures
                            user.saveInBackground()
                        }
                    }
                }
            }
            self.allPicsVC.profilePicturesDelegate?.profilePicturesViewController(self.allPicsVC, didUpdatePageCount: self.images.count)
            self.allPicsVC.goToPage(index: nextPageNum)
        }
        parentVC.dismiss(animated: true, completion: nil)

    }
    
    func defaultButtonPressed(_ button: UIButton) {
        let index = allPicsVC.pageControl.currentPage
        if images.count > index {
            let oldDefaultPic = images[0]
            images[0] = images[index]
            images[index] = oldDefaultPic
            resetImagesForVCs()
            if let user = PFUser.current() {
                if var profilePics = user["profile_pictures"] as? [PFFile] {
                    if profilePics.count > index {
                        let oldDefaultPic = profilePics[0]
                        profilePics[0] = profilePics[index]
                        profilePics[index] = oldDefaultPic
                        user["profile_pictures"] = profilePics
                    }
                }
                if var profilePicsUrls = user["profile_pictures_urls"] as? [String] {
                    if profilePicsUrls.count > index {
                        let oldDefaultPicUrl = profilePicsUrls[0]
                        profilePicsUrls[0] = profilePicsUrls[index]
                        profilePicsUrls[index] = oldDefaultPicUrl
                        user["profile_pictures_urls"] = profilePicsUrls
                    }
                }
                user.saveInBackground()
            }
            allPicsVC.goToPage(index: 0)
        }
    }
    
    func deleteButtonPressed(_ button: UIButton) {
        if images.count <= 1 {
            return
        }
        let index = allPicsVC.pageControl.currentPage
        if images.count > index {
            images.remove(at: index)
            singlePicVCs.remove(at: index)
            resetImagesForVCs()
            if let user = PFUser.current() {
                if var profilePics = user["profile_pictures"] as? [PFFile] {
                    if profilePics.count > index {
                        profilePics.remove(at: index)
                        user["profile_pictures"] = profilePics
                    }
                }
                if var profilePicsUrls = user["profile_pictures_urls"] as? [String] {
                    if profilePicsUrls.count > index {
                        profilePicsUrls.remove(at: index)
                        user["profile_pictures_urls"] = profilePicsUrls
                    }
                }
                user.saveInBackground()
            }
        }
        if index == images.count && index > 0 {
            allPicsVC.goToPage(index: index-1)
        } else {
            allPicsVC.goToPage(index: index)
        }
        
    }
    
    
}
