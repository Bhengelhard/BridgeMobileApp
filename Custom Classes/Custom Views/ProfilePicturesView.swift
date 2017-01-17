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
    let rectView = UIView()
    let editButtonsView = UIView()
    let shouldShowEditButtons: Bool
    
    let pageVC = ProfilePicturesViewController()

    var shouldDisplayDefaultButton = true
    var shouldDisplayDeleteButton = true
    
    init(hexView: HexagonView, shouldShowEditButtons: Bool) {
        self.hexView = hexView
        self.shouldShowEditButtons = shouldShowEditButtons
        super.init(frame: CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight))
        backgroundColor = .white
        addSubview(hexView)
        
        let rectWidth = DisplayUtility.screenWidth
        let rectHeight = rectWidth * hexView.frame.height / hexView.frame.width
        rectView.frame = CGRect(x: 0, y: 0.2*DisplayUtility.screenHeight, width: rectWidth, height: rectHeight)
        rectView.center.x = DisplayUtility.screenWidth / 2
        
        if let image = self.hexView.hexBackgroundImage {
            let viewSize = CGSize(width: rectView.frame.width, height: rectView.frame.width)
            if let newImage = self.fitImageToView(image: image, viewSize: viewSize) {
                rectView.backgroundColor = UIColor(patternImage: newImage)
            } else {
                rectView.backgroundColor = UIColor(patternImage: image)
            }
        } else {
            rectView.backgroundColor = self.hexView.hexBackgroundColor
        }
        rectView.layer.borderWidth = 1
        rectView.layer.borderColor = UIColor.black.cgColor
        let gr = UITapGestureRecognizer(target: self, action: #selector(exit(_:)))
        //rectView.addGestureRecognizer(gr)
        rectView.isUserInteractionEnabled = true
        rectView.alpha = 0
        //addSubview(rectView)
        pageVC.view.frame = CGRect(x: 0, y: 0.2*DisplayUtility.screenHeight, width: rectWidth, height: rectHeight)
        pageVC.view.center.x = DisplayUtility.screenWidth / 2
        addSubview(pageVC.view)
        let page1 = UIViewController()
        page1.view.frame = pageVC.view.frame
        if let image = hexView.hexBackgroundImage {
            let viewSize = CGSize(width: page1.view.frame.width, height: page1.view.frame.width)
            if let newImage = fitImageToView(image: image, viewSize: viewSize) {
                page1.view.backgroundColor = UIColor(patternImage: newImage)
            } else {
                page1.view.backgroundColor = UIColor(patternImage: image)
            }
        } else {
            page1.view.backgroundColor = hexView.hexBackgroundColor
        }
        pageVC.view.addGestureRecognizer(gr)
        let page2 = UIViewController()
        page2.view.frame = pageVC.view.frame
        page2.view.backgroundColor = .green
        pageVC.setVCs(vcs: [page1, page2], initialVC: page1)
        pageVC.view.alpha = 0
        
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
            
            editButtonsView.frame = CGRect(x: 0, y: rectView.frame.maxY + 0.045*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: uploadButton.frame.maxY)
            editButtonsView.alpha = 0
            addSubview(editButtonsView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate() {
        UIView.animate(withDuration: 0.5, animations: { 
            self.hexView.frame = self.rectView.frame
            self.hexView.resetBackgroundImage()
        }) { (finished) in
            if finished {
                UIView.animate(withDuration: 1.0, animations: {
                    self.rectView.alpha = 1
                    self.pageVC.view.alpha = 1
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
