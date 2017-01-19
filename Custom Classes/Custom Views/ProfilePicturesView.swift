//
//  EditProfilePictureView.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 1/16/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class ProfilePicturesView: UIView {
    
    let originalHexFrames: [CGRect]
    let images: [UIImage]
    let startingIndex: Int
    let shouldShowEditButtons: Bool
    let allPicsVC: ProfilePicturesViewController
    let picFrame: CGRect
    
    let editButtonsView = UIView()

    var shouldDisplayDefaultButton = true
    var shouldDisplayDeleteButton = true
    
    init(images: [UIImage], originalHexFrames: [CGRect], startingIndex: Int, shouldShowEditButtons: Bool) {
        self.images = images
        self.originalHexFrames = originalHexFrames
        self.startingIndex = startingIndex
        self.shouldShowEditButtons = shouldShowEditButtons
        
        let picWidth = DisplayUtility.screenWidth
        let picHeight = picWidth * originalHexFrames[startingIndex].height / originalHexFrames[startingIndex].width
        
        picFrame = CGRect(x: 0, y: 0.2*DisplayUtility.screenHeight, width: picWidth, height: picHeight)
        
        var singlePicVCs = [UIViewController]()
        for _ in 0..<images.count {
            let singlePicVC = UIViewController()
            singlePicVCs.append(singlePicVC)
        }
        
        allPicsVC = ProfilePicturesViewController(vcs: singlePicVCs, initialVC: singlePicVCs[startingIndex])
        
        super.init(frame: CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight))
        
        backgroundColor = .white
                
        for i in 0..<singlePicVCs.count {
            let singlePicVC = singlePicVCs[i]
            let image = images[i]
            let picView = UIView()
            print(allPicsVC.pageControl.frame)
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
        
        allPicsVC.view.alpha = 0
        allPicsVC.view.frame = CGRect(x: picFrame.minX, y: picFrame.minY - allPicsVC.pageControl.frame.maxY, width: picFrame.width, height: picFrame.height + allPicsVC.pageControl.frame.maxY)
        //allPicsVC.view.center.x = DisplayUtility.screenWidth / 2
        
        let exitGR = UITapGestureRecognizer(target: self, action: #selector(exit(_:)))
        allPicsVC.view.addGestureRecognizer(exitGR)
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
                defaultButton.layer.cornerRadius = 0.3*uploadButton.frame.height
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
                deleteButton.layer.cornerRadius = 0.3*uploadButton.frame.height
                editButtonsView.addSubview(deleteButton)
                
                buttonY = buttonY + buttonHeight + spaceBetweenButtons
            }
            
            editButtonsView.frame = CGRect(x: 0, y: allPicsVC.view.frame.maxY + 0.045*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: uploadButton.frame.maxY)
            editButtonsView.alpha = 0
            addSubview(editButtonsView)
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
    
    
}
