//
//  EditProfilePictureView.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 1/16/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class ProfilePicturesView: UIView {
    
    let hexView: HexagonView
    let images: [UIImage]
    let startingImageIndex: Int
    let shouldShowEditButtons: Bool
    let allPicsVC: ProfilePicturesViewController
    
    let editButtonsView = UIView()

    var shouldDisplayDefaultButton = true
    var shouldDisplayDeleteButton = true
    
    init(hexView: HexagonView, images: [UIImage], startingImageIndex: Int, shouldShowEditButtons: Bool) {
        self.hexView = hexView
        self.images = images
        self.startingImageIndex = startingImageIndex
        self.shouldShowEditButtons = shouldShowEditButtons
        
        let picWidth = DisplayUtility.screenWidth
        let picHeight = picWidth * hexView.frame.height / hexView.frame.width
        
        let VCViewFrame = CGRect(x: 0, y: 0.2*DisplayUtility.screenHeight, width: picWidth, height: picHeight)
        
        var singlePicVCs = [UIViewController]()
        for _ in 0..<images.count {
            let singlePicVC = UIViewController()
            singlePicVC.view.frame = VCViewFrame
            singlePicVCs.append(singlePicVC)
        }
        
        allPicsVC = ProfilePicturesViewController(vcs: singlePicVCs, initialVC: singlePicVCs[startingImageIndex])
        
        super.init(frame: CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight))
        
        backgroundColor = .white
        
        addSubview(hexView)
        
        for i in 0..<singlePicVCs.count {
            let singlePicVC = singlePicVCs[i]
            let image = images[i]
            let viewSize = CGSize(width: singlePicVC.view.frame.width, height: singlePicVC.view.frame.width)
            if let newImage = fitImageToView(image: image, viewSize: viewSize) {
                singlePicVC.view.backgroundColor = UIColor(patternImage: newImage)
            } else {
                singlePicVC.view.backgroundColor = UIColor(patternImage: image)
            }
        }
        
        allPicsVC.view.alpha = 0
        allPicsVC.view.frame = VCViewFrame
        allPicsVC.view.center.x = DisplayUtility.screenWidth / 2
        
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
    
    func animate() {
        UIView.animate(withDuration: 0.5, animations: { 
            self.hexView.frame = self.allPicsVC.view.frame
            self.hexView.resetBackgroundImage()
        }) { (finished) in
            if finished {
                UIView.animate(withDuration: 1.0, animations: {
                    self.allPicsVC.view.alpha = 1
                    self.editButtonsView.alpha = 1
                }, completion: { (finished) in
                    if finished {
                        self.hexView.alpha = 0
                    }
                })
            }
        }
    }
    
    func exit(_ gesture: UIGestureRecognizer) {
        self.removeFromSuperview()
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
