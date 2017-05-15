//
//  EditProfilePicturesTableViewCell.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 3/7/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class EditProfilePicturesTableViewCell: UITableViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FacebookImagePickerControllerDelegate {
    
    var parentVC: UIViewController?
    
    var pictureBoxes = [PictureBox]()
    var containerViews = [UIView]()
    
    var smallSideLength = CGFloat(0)
    var largeSideLength = CGFloat(0)
    let margin = CGFloat(7)
    
    let imagePicker = UIImagePickerController()
    let facebookImagePicker = FacebookImagePickerController()
    
    var shouldUpdateConstraints = true
    
    class PictureBox: UIImageView {
        
        let number: Int
        let numberImageView = UIImageView()
        let pictureButton: PictureButton
        var pictureID: String?
        
        var empty = true
        
        init(cornerRadius: CGFloat, number: Int, numberMaxSideLength: CGFloat, pictureButtonDiameter: CGFloat) {
            self.number = number
            pictureButton = PictureButton(diameter: pictureButtonDiameter)
            
            super.init(frame: CGRect())
            
            self.contentMode = .scaleAspectFill
            self.clipsToBounds = true
            
            isUserInteractionEnabled = true
            
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
        
        func setImage(image: UIImage, pictureID: String?) {
            self.image = image
            self.pictureID = pictureID
            pictureButton.setToDelete()
            empty = false
        }
        
        func removeImage() {
            image = nil
            pictureID = nil
            pictureButton.setToAdd()
            empty = true
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
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        facebookImagePicker.delegate = self
        
        smallSideLength = (frame.width - 4*margin)/3
        largeSideLength = 2*smallSideLength + margin
        
        let cornerRadius = 30.0/449.0 * largeSideLength
        
        let numberMaxSideLength = 41.0/449.0 * largeSideLength
        
        let pictureButtonDiameter = 69.0/449.0 * largeSideLength
        
        for i in 0...5 {
            let pictureBox = PictureBox(cornerRadius: cornerRadius, number: i+1, numberMaxSideLength: numberMaxSideLength, pictureButtonDiameter: pictureButtonDiameter)
            pictureBoxes.append(pictureBox)

            pictureBox.pictureButton.addTarget(self, action: #selector(showMenu(_:)), for: .touchUpInside)
            
            let showMenuFromDragGR = UIPanGestureRecognizer(target: self, action: #selector(showMenuFromPictureBox(_:)))
            pictureBox.addGestureRecognizer(showMenuFromDragGR)
            pictureBox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showMenuFromPictureBox(_:))))
            
            containerViews.append(UIView())
        }
        
        layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        if shouldUpdateConstraints {            
            for i in 0..<containerViews.count {
                let containerView = containerViews[i]
                
                addSubview(containerView)
                
                if i == 0 {
                    containerView.autoMatch(.width, to: .width, of: self, withMultiplier: 2/3)
                } else {
                    containerView.autoMatch(.width, to: .width, of: self, withMultiplier: 1/3)
                }
                
                containerView.autoMatch(.height, to: .width, of: containerView)
                
                if i == 0 {
                    containerView.autoPinEdge(toSuperviewEdge: .left)
                    containerView.autoPinEdge(toSuperviewEdge: .top)
                } else if i == 1 {
                    containerView.autoPinEdge(toSuperviewEdge: .right)
                    containerView.autoPinEdge(toSuperviewEdge: .top)
                } else if i == 2 {
                    containerView.autoPinEdge(toSuperviewEdge: .right)
                    containerView.autoAlignAxis(toSuperviewAxis: .horizontal)
                } else if i == 3 {
                    containerView.autoPinEdge(toSuperviewEdge: .right)
                    containerView.autoPinEdge(toSuperviewEdge: .bottom)
                } else if i == 4 {
                    containerView.autoAlignAxis(toSuperviewAxis: .vertical)
                    containerView.autoPinEdge(toSuperviewEdge: .bottom)
                } else if i == 5 {
                    containerView.autoPinEdge(toSuperviewEdge: .left)
                    containerView.autoPinEdge(toSuperviewEdge: .bottom)
                }
                
                let pictureBox = pictureBoxes[i]
                
                containerView.addSubview(pictureBox)
                let edgeInsets = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
                pictureBox.autoPinEdgesToSuperviewEdges(with: edgeInsets)
            }
            
            shouldUpdateConstraints = false
        }
        
        super.updateConstraints()
        layoutIfNeeded()
    }
    
    func setParentVC(parentVC: UIViewController) {
        self.parentVC = parentVC
    }
    
    // set image at lowest available index
    func addImage(image: UIImage, pictureID: String?) {
        for pictureBox in pictureBoxes {
            if pictureBox.empty {
                pictureBox.setImage(image: image, pictureID: pictureID)
                break
            }
        }
    }
    
    func addPicture(picture: Picture) {
        for pictureBox in pictureBoxes {
            if pictureBox.empty {
                pictureBox.empty = false
                picture.getImage { (image) in
                    pictureBox.setImage(image: image, pictureID: picture.id)
                }
                break
            }
        }
    }
    
    // delete image and move all remaining images to lowest available index
    func deleteImage(atIndex index: Int) {
        for i in index..<pictureBoxes.count-1 {
            if let image = pictureBoxes[i+1].image {
                pictureBoxes[i].setImage(image: image, pictureID: pictureBoxes[i+1].pictureID)
            } else {
                pictureBoxes[i].removeImage()
            }
        }
        pictureBoxes[pictureBoxes.count-1].removeImage()
    }
    
    func switchImage(atIndex index1: Int, withIndex index2: Int) {
        if let image1 = pictureBoxes[index1].image, let image2 = pictureBoxes[index2].image {
            let pictureBox1PictureID = pictureBoxes[index1].pictureID
            let pictureBox2PictureID = pictureBoxes[index2].pictureID
            pictureBoxes[index1].setImage(image: image2, pictureID: pictureBox2PictureID)
            pictureBoxes[index2].setImage(image: image1, pictureID: pictureBox1PictureID)
        }
    }
    
    func showMenu(_ sender: UIButton) {
        if let pictureBox = sender.superview as? PictureBox {
            if pictureBox.empty {
                showAddImageMenu(index: pictureBox.number-1)
            } else {
                showDeleteImageMenu(index: pictureBox.number-1)
            }
        }
    }
    
    func showMenuFromPictureBox(_ gesture: UIGestureRecognizer) {
        if let pictureBox = gesture.view as? PictureBox {
            if pictureBox.empty {
                showAddImageMenu(index: pictureBox.number-1)
            } else {
                showDeleteImageMenu(index: pictureBox.number-1)
            }
        }
    }
    
    func showAddImageMenu(index: Int) {
        let addImageMenu = UIAlertController(title: nil, message: "Add Image From:", preferredStyle: .actionSheet)
        
        let cameraRollAction = UIAlertAction(title: "Camera Roll", style: .default) { (alert) in
            if let parentVC = self.parentVC {
                parentVC.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        let facebookAction = UIAlertAction(title: "Facebook", style: .default) { (alert) in
            if let parentVC = self.parentVC {
                parentVC.present(self.facebookImagePicker, animated: true, completion: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            addImageMenu.dismiss(animated: true, completion: nil)
        }
        
        addImageMenu.addAction(cameraRollAction)
        addImageMenu.addAction(facebookAction)
        addImageMenu.addAction(cancelAction)
        
        if let parentVC = parentVC {
            parentVC.present(addImageMenu, animated: true, completion: nil)
        }
    }
    
    func showDeleteImageMenu(index: Int) {
        let deleteImageMenu = UIAlertController(title: nil, message: "What would you like to do with this image?", preferredStyle: .actionSheet)
        
        // delete image
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (alert) in
            self.deleteImage(atIndex: index)
        }
        
        // move image up by 1 box
        let moveUpAction = UIAlertAction(title: "Move Up", style: .default) { (alert) in
            self.switchImage(atIndex: index, withIndex: index-1)
        }
        
        // move image down by 1 box
        let moveDownAction = UIAlertAction(title: "Move Down", style: .default) { (alert) in
            self.switchImage(atIndex: index, withIndex: index+1)
        }
        
        // don't do anything
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            deleteImageMenu.dismiss(animated: true, completion: nil)
        }
        
        deleteImageMenu.addAction(deleteAction)
        
        if index > 0 {
            deleteImageMenu.addAction(moveUpAction)
        }
        
        if index < pictureBoxes.count && !pictureBoxes[index+1].empty {
            deleteImageMenu.addAction(moveDownAction)
        }
        
        deleteImageMenu.addAction(cancelAction)
        
        if let parentVC = parentVC {
            parentVC.present(deleteImageMenu, animated: true, completion: nil)
        }
    }
    
    //update the UIImageView once an image has been picked
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            addImage(image: image, pictureID: nil)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func fbImagePickerController(_ picker: FacebookImagePickerController, didPickImage image: UIImage) {
        addImage(image: image, pictureID: nil)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func setPicturesToUser(user: User, completion: (() -> Void)? = nil) {
        var pictureIDs = [String?]()
        var images = [UIImage]()
        for pictureBox in pictureBoxes {
            if !pictureBox.empty {
                if let image = pictureBox.image {
                    pictureIDs.append(pictureBox.pictureID)
                    images.append(image)
                }
            }
        }
        let editProfileBackend = EditProfileBackend()
        editProfileBackend.setPicturesToUser(user: user, pictureIDs: pictureIDs, images: images, completion: completion)
    }

}
