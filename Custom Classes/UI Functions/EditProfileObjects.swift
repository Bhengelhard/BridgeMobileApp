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
    
    class Table: UITableView, UITableViewDelegate, UITableViewDataSource {
        
        let editProfilePicturesCell = EditProfilePicturesTableViewCell()
        let aboutMeTableCell = WhiteTextTableCell()
        let lookingForTableCell = WhiteTextTableCell()
        let ageTableCell = WhiteFieldTableCell(field: .age)
        let cityTableCell = WhiteFieldTableCell(field: .city)
        let workTableCell = WhiteFieldTableCell(field: .work)
        let schoolTableCell = WhiteFieldTableCell(field: .school)
        let genderTableCell = WhiteFieldTableCell(field: .gender)
        let relationshipStatusTableCell = WhiteFieldTableCell(field: .relationshipStatus)
        
        override init(frame: CGRect, style: UITableViewStyle) {
            super.init(frame: CGRect(), style: .plain)
            
            delegate = self
            dataSource = self
            
            self.separatorStyle = .none
            
            self.estimatedRowHeight = 50
            //self.rowHeight = UITableViewAutomaticDimension            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - Table view data source
        
        func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 17
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            var cell = UITableViewCell()
            
            switch(indexPath.row) {
            case 0:
                cell = editProfilePicturesCell
            case 1:
                cell = GrayTableCell(text: "About Me")
            case 2:
                cell = aboutMeTableCell
            case 3:
                cell = GrayTableCell(text: "Looking For")
            case 4:
                cell = lookingForTableCell
            case 5:
                cell = GrayTableCell(field: .age)
            case 6:
                cell = ageTableCell
            case 7:
                cell = GrayTableCell(field: .city)
            case 8:
                cell = cityTableCell
            case 9:
                cell = GrayTableCell(field: .work)
            case 10:
                cell = workTableCell
            case 11:
                cell = GrayTableCell(field: .school)
            case 12:
                cell = schoolTableCell
            case 13:
                cell = GrayTableCell(field: .gender)
            case 14:
                cell = genderTableCell
            case 15:
                cell = GrayTableCell(field: .relationshipStatus)
            case 16:
                cell = relationshipStatusTableCell
            default:
                cell = WhiteTextTableCell()
            }
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            if indexPath.row != 0 {
                deselectRow(at: indexPath, animated: true)
                
                // Getting title of the selected row from the text in the previous row
                let previousCellRow = indexPath.row - 1
                let previousCellTitle = IndexPath(row: previousCellRow, section: 0)
                if let cell = tableView.cellForRow(at: previousCellTitle) {
                    if let cellTitleLabel = cell.textLabel {
                        if let cellTitleText = cellTitleLabel.text {
                            
                            if let currentCell = cellForRow(at: indexPath) {
                                if let currentCellTextLabel  = currentCell.textLabel {
                                    if let currentCellText = currentCellTextLabel.text {
                                        let object = [cellTitleText, currentCellText]
                                        // Notify EditProfileViewController to present the tappedTableCell
                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "tableViewCellTapped"), object: object)
                                    }
                                }
                            }
                            
                        }
                    }
                }
                
            }
            
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if indexPath.row == 0 {
                return DisplayUtility.screenWidth
            }
            return UITableViewAutomaticDimension
        }
        
        func setParentVCOfEditProfilePicturesCell(parentVC: UIViewController) {
            editProfilePicturesCell.setParentVC(parentVC: parentVC)
        }
    }
    
    class GrayTableCell: UITableViewCell {
        
        init(text: String) {
            super.init(style: .subtitle, reuseIdentifier: "GrayTableCell")
            
            self.textLabel?.text = text
            formatLabel()
        }
        
        init(field: UserInfoField) {
            super.init(style: .subtitle, reuseIdentifier: "GrayTableCell")
            
            self.textLabel?.text = field.rawValue
            formatLabel()
        }
        
        func formatLabel() {
            textLabel?.font = Constants.Fonts.bold16
            backgroundColor = Constants.Colors.necter.backgroundGray
            textLabel?.textColor = Constants.Colors.necter.textDarkGray
            isUserInteractionEnabled = false
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    class WhiteFieldTableCell: UITableViewCell {
        let field: UserInfoField
        
        init(field: UserInfoField) {
            self.field = field
            
            super.init(style: .subtitle, reuseIdentifier: "WhiteFieldTableCell")
            
            textLabel?.font = Constants.Fonts.light18
            textLabel?.numberOfLines = 0
            textLabel?.textColor = .black
            backgroundColor = UIColor.white
            
            accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class WhiteTableCell: UITableViewCell {
        
        init() {
            super.init(style: .subtitle, reuseIdentifier: "WhiteTableCell")
            
            self.textLabel?.font = Constants.Fonts.light18
            self.textLabel?.numberOfLines = 0
            self.textLabel?.textColor = .black
            self.backgroundColor = UIColor.white
            
            self.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class WhiteTextTableCell: UITableViewCell, UITextViewDelegate {
        
        let textView = UITextView()

        
        init() {
            super.init(style: .subtitle, reuseIdentifier: "GrayTableCell")
            
            self.backgroundColor = UIColor.white
            
            textView.delegate = self
            textView.font = Constants.Fonts.light18
            textView.textColor = Constants.Colors.necter.textDarkGray
            textView.isScrollEnabled = false
            
            self.addSubview(textView)
            textView.autoPinEdgesToSuperviewEdges(with: .init(top: 10, left: 10, bottom: 10, right: 10))
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func textViewDidChange(_ textView: UITextView) {
            print("textViewDidChange")
            
            var view = self.superview
            
            while (view != nil) && (view is UITableView) == false {
                view = view?.superview
            }
            
            if let tableView = view as? UITableView {
                print("textViewDidChange got the tableView")
                let currentOffset = tableView.contentOffset
                
                UIView.setAnimationsEnabled(false)
                tableView.beginUpdates()
                tableView.endUpdates()
                UIView.setAnimationsEnabled(true)
                tableView.setContentOffset(currentOffset, animated: false)
            }
            
            
        }
    }
    
}
