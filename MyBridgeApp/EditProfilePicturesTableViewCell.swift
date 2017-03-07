//
//  EditProfilePicturesTableViewCell.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 3/7/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class EditProfilePicturesTableViewCell: UITableViewCell {
    
    var pictureBoxes = [PictureBox]()
    
    class PictureBox: UIImageView {
        
        let pictureButton: PictureButton
        
        init(sideLength: CGFloat, cornerRadius: CGFloat, pictureButtonDiameter: CGFloat) {
            pictureButton = PictureButton(diameter: pictureButtonDiameter, plus: false)
            
            super.init(frame: CGRect())
            
            let size = CGSize(width: sideLength, height: sideLength)
            autoSetDimensions(to: size)
            
            backgroundColor = UIColor(red: 223 / 255, green: 223 / 255, blue: 228 / 255, alpha: 1.0)
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
            
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
        init(diameter: CGFloat, plus: Bool) {
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
        
        let pictureButtonDiameter = 69.0/449.0 * largeSideLength
        
        let pictureBox = PictureBox(sideLength: largeSideLength, cornerRadius: cornerRadius,  pictureButtonDiameter: pictureButtonDiameter)
        addSubview(pictureBox)
        pictureBox.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
        pictureBox.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        pictureBoxes.append(pictureBox)
        
        for i in 1...5 {
            let pictureBox = PictureBox(sideLength: smallSideLength, cornerRadius: cornerRadius,  pictureButtonDiameter: pictureButtonDiameter)
            addSubview(pictureBox)
            pictureBoxes.append(pictureBox)
            
            if i == 1 {
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
    
    func setImage(image: UIImage, atIndex index: Int) {
        if index < pictureBoxes.count {
            pictureBoxes[index].setImage(image: image)
        }
    }
    
    func deleteImage(atIndex index: Int) {
        for i in index..<pictureBoxes.count-1 {
            if let newImage = pictureBoxes[i+1].image {
                pictureBoxes[i].setImage(image: newImage)
            } else {
                pictureBoxes[i].removeImage()
            }
        }
        pictureBoxes[pictureBoxes.count-1].removeImage()
    }

}
