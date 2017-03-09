//
//  EditProfilePicturesTableViewCell.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 3/7/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class EditProfilePicturesTableViewCell: UITableViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var parentVC: UIViewController?
    
    var pictureBoxes = [PictureBox]()
    
    let imagePicker = UIImagePickerController()
    var indexForNewImage: Int?
    
    class PictureBox: UIImageView {
        
        let number: Int
        let numberImageView = UIImageView()
        let pictureButton: PictureButton
        var pictureID: String?
        
        var empty = true
        
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
        
        autoSetDimensions(to: CGSize(width: DisplayUtility.screenWidth, height: DisplayUtility.screenWidth))
        
        let largeSideLength = 0.97 * 2/3 * (frame.width - 40)
        let smallSideLength = 212.0/449.0 * largeSideLength
        
        let cornerRadius = 30.0/449.0 * largeSideLength
        
        let numberMaxSideLength = 41.0/449.0 * largeSideLength
        
        let pictureButtonDiameter = 69.0/449.0 * largeSideLength
        
        for i in 0...5 {
            let sideLength = i == 0 ? largeSideLength : smallSideLength
            let pictureBox = PictureBox(sideLength: sideLength, cornerRadius: cornerRadius, number: i+1,numberMaxSideLength: numberMaxSideLength,  pictureButtonDiameter: pictureButtonDiameter)
            addSubview(pictureBox)
            pictureBoxes.append(pictureBox)

            pictureBox.pictureButton.addTarget(self, action: #selector(showMenu(_:)), for: .touchUpInside)
            
            // layout picture box
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
    
    func showMenu(_ sender: UIButton) {
        if let pictureBox = sender.superview as? PictureBox {
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
                parentVC.present(self.imagePicker, animated: true)
            }
        }
        
        let facebookAction = UIAlertAction(title: "Facebook", style: .default) { (alert) in
            print("adding from facebook")
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
        print("showing delete menu")
        let deleteImageMenu = UIAlertController(title: nil, message: "Delete This Image?", preferredStyle: .actionSheet)
        
        // delete image
        let deleteAction = UIAlertAction(title: "Yes", style: .default) { (alert) in
            self.deleteImage(atIndex: index)
        }
        
        // don't delete image
        let cancelAction = UIAlertAction(title: "No", style: .default) { (alert) in
        }
        
        deleteImageMenu.addAction(deleteAction)
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
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func savePictures() {
        var pictureIDs = [String?]()
        for pictureBox in pictureBoxes {
            pictureIDs.append(pictureBox.pictureID)
        }
        let editProfileBackend = EditProfileBackend()
    }

}
