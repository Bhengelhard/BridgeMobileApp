//
//  EditProfileObjects.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/20/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit

class EditProfileObjects {
    
    class NavBar: NecterNavigationBar {
        
        override init() {
            super.init()
            
            rightButton.setTitle("Done", for: .normal)
            rightButton.sizeToFit()
            let gradientColor = DisplayUtility.gradientColor(size: rightButton.frame.size)
            rightButton.setTitleColor(gradientColor, for: .normal)
            
            navItem.title = "Edit Profile"
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class EditImagesView: UICollectionView {
        
    }
    
    class LargeImage: UIImageView {
        
    }
    
    class SmallImage: UIImageView {
        
    }
    
    class DeleteButton: UIButton {
        
    }
    
    class AddButton: UIButton {
        
    }
    
    class Number: UILabel {
        
    }
    
    class Table: UITableView {
        
    }
    
    class Header: UITableViewHeaderFooterView {
        
    }
    
    class TextViewCell: UITableViewCell {
        
    }
    
    class ClickableCell: UITableViewCell {
        
    }
    
}
