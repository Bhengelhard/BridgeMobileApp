//
//  EditProfilePicturesTableViewCell.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 3/7/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class EditProfilePicturesTableViewCell: UITableViewCell {
    
    var parentVC: UIViewController?
    
    var pictureBoxes = [PictureBox]()
    
    class PictureBox: UIImageView {
        
        let number: Int
        let numberImageView = UIImageView()
        let pictureButton: PictureButton
        
        init(sideLength: CGFloat, cornerRadius: CGFloat, number: Int, numberMaxSideLength: CGFloat, pictureButtonDiameter: CGFloat) {
            self.number = number
            pictureButton = PictureButton(diameter: pictureButtonDiameter)
            
            super.init(frame: CGRect())
            
            isUserInteractionEnabled = true
            
            let size = CGSize(width: sideLength, height: sideLength)
            autoSetDimensions(to: size)
            
            backgroundColor = UIColor(red: 223 / 255, green: 223 / 255, blue: 228 / 255, alpha: 1.0)
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
            
            addSubview(numberImageView)
            if let numberImage = UIImage(named: "Photo_Label_\(number)") {
                numberImageView.image = numberImage
                // set size of number image view not to exceed max size in either direction
                let numberImageWToHRatio = numberImage.size.width / numberImage.size.height
                let size: CGSize
                if numberImageWToHRatio >= 1 { // width >= height
                    size = CGSize(width: numberMaxSideLength, height: numberMaxSideLength / numberImageWToHRatio)
                } else { // height > width
                    size = CGSize(width: numberMaxSideLength * numberImageWToHRatio, height: numberMaxSideLength)
                }
                numberImageView.autoSetDimensions(to: size)
                numberImageView.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
                numberImageView.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
            }
            
            addSubview(pictureButton)
            pictureButton.autoPinEdge(toSuperviewEdge: .bottom)
            pictureButton.autoPinEdge(toSuperviewEdge: .trailing)

        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setImage(image: UIImage) {
            self.image = image
            pictureButton.setToDelete()
        }
        
        func removeImage() {
            image = nil
            pictureButton.setToAdd()
        }
    }
    
    class PictureButton: UIButton {
        init(diameter: CGFloat) {
            super.init(frame: CGRect())
            
            let size = CGSize(width: diameter, height: diameter)
            autoSetDimensions(to: size)
            
            layer.cornerRadius = diameter / 2
            backgroundColor = .clear
            clipsToBounds = true
            
            setToAdd()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setToAdd() {
            setImage(#imageLiteral(resourceName: "Add_Button"), for: .normal)
        }
        
        func setToDelete() {
            setImage(#imageLiteral(resourceName: "Delete_Button"), for: .normal)
        }
    
    }
    
    init() {
        super.init(style: .default, reuseIdentifier: "")
        
        self.backgroundColor = Constants.Colors.necter.backgroundGray
        self.selectionStyle = .none
        
        autoSetDimensions(to: CGSize(width: DisplayUtility.screenWidth, height: DisplayUtility.screenWidth))
        
        let largeSideLength = 0.97 * 2/3 * (frame.width - 40)
        let smallSideLength = 212.0/449.0 * largeSideLength
        
        let cornerRadius = 30.0/449.0 * largeSideLength
        
        let numberMaxSideLength = 41.0/449.0 * largeSideLength
        
        let pictureButtonDiameter = 69.0/449.0 * largeSideLength
        
        for i in 0...5 {
            let sideLength = i == 0 ? largeSideLength : smallSideLength
            let pictureBox = PictureBox(sideLength: sideLength, cornerRadius: cornerRadius, number: i+1,numberMaxSideLength: numberMaxSideLength,  pictureButtonDiameter: pictureButtonDiameter)
            pictureBox.pictureButton.addTarget(self, action: #selector(showAddImageMenu(_:)), for: .touchUpInside)
            addSubview(pictureBox)
            pictureBoxes.append(pictureBox)
            
            if i == 0 {
                pictureBox.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
                pictureBox.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
            } else if i == 1 {
                pictureBox.autoAlignAxis(.firstBaseline, toSameAxisOf: pictureBoxes[0])
                pictureBox.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
            } else if i == 2 {
                pictureBox.autoPinEdge(.bottom, to: .bottom, of: pictureBoxes[0])
                pictureBox.autoPinEdge(.trailing, to: .trailing, of: pictureBoxes[1])
            } else if i == 3 {
                pictureBox.autoPinEdge(toSuperviewEdge: .bottom, withInset: 20)
                pictureBox.autoPinEdge(.trailing, to: .trailing, of: pictureBoxes[2])
            } else if i == 4 {
                pictureBox.autoPinEdge(.bottom, to: .bottom, of: pictureBoxes[3])
                pictureBox.autoPinEdge(.trailing, to: .trailing, of: pictureBoxes[0])
            } else if i == 5 {
                pictureBox.autoPinEdge(.bottom, to: .bottom, of: pictureBoxes[4])
                pictureBox.autoPinEdge(.leading, to: .leading, of: pictureBoxes[0])
            }
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setParentVC(parentVC: UIViewController) {
        self.parentVC = parentVC
    }
    
    func setImage(image: UIImage, atIndex index: Int) {
        if index < pictureBoxes.count {
            pictureBoxes[index].setImage(image: image)
            pictureBoxes[index].pictureButton.removeTarget(self, action: #selector(showAddImageMenu(_:)), for: .touchUpInside)
            pictureBoxes[index].pictureButton.addTarget(self, action: #selector(showDeleteImageMenu(_:)), for: .touchUpInside)
        }
    }
    
    func deleteImage(atIndex index: Int) {
        for i in index..<pictureBoxes.count-1 {
            if let newImage = pictureBoxes[i+1].image {
                pictureBoxes[i].setImage(image: newImage)
                pictureBoxes[i].pictureButton.removeTarget(self, action: #selector(showDeleteImageMenu(_:)), for: .touchUpInside)
                pictureBoxes[i].pictureButton.addTarget(self, action: #selector(showAddImageMenu(_:)), for: .touchUpInside)
                
            } else {
                pictureBoxes[i].removeImage()
                pictureBoxes[i].pictureButton.removeTarget(self, action: #selector(showAddImageMenu(_:)), for: .touchUpInside)
                pictureBoxes[i].pictureButton.addTarget(self, action: #selector(showDeleteImageMenu(_:)), for: .touchUpInside)
            }
        }
        pictureBoxes[pictureBoxes.count-1].removeImage()
        pictureBoxes[pictureBoxes.count-1].pictureButton.removeTarget(self, action: #selector(showAddImageMenu(_:)), for: .touchUpInside)
        pictureBoxes[pictureBoxes.count-1].pictureButton.addTarget(self, action: #selector(showDeleteImageMenu(_:)), for: .touchUpInside)
    }
    
    func showAddImageMenu(_ sender: UIButton) {
        print("showing add menu")
        if let pictureBox = sender.superview as? PictureBox {
            print("number: \(pictureBox.number)")
        }
        let addImageMenu = UIAlertController(title: nil, message: "Add Image From:", preferredStyle: .actionSheet)
        
        let cameraRollAction = UIAlertAction(title: "Camera Roll", style: .default) { (alert) in
            print("adding from camera roll")
        }
        
        let facebookAction = UIAlertAction(title: "Facebook", style: .default) { (alert) in
            print("adding from facebook")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            print("cancelling")
        }
        
        addImageMenu.addAction(cameraRollAction)
        addImageMenu.addAction(facebookAction)
        addImageMenu.addAction(cancelAction)
        
        if let parentVC = parentVC {
            parentVC.present(addImageMenu, animated: true, completion: nil)
        }
    }
    
    func showDeleteImageMenu(_ sender: UIButton) {
        print("showing delete menu")
        let deleteImageMenu = UIAlertController(title: nil, message: "Delete This Image?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Yes", style: .default) { (alert) in
            print("deleting")
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .default) { (alert) in
            print("cancelling")
        }
        
        deleteImageMenu.addAction(deleteAction)
        deleteImageMenu.addAction(cancelAction)
        
        if let parentVC = parentVC {
            parentVC.present(deleteImageMenu, animated: true, completion: nil)
        }
    }

}
