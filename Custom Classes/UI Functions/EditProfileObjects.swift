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
        let workTableCell = WhiteTableCell()
        let schoolTableCell = WhiteTableCell()
        let genderTableCell = WhiteTableCell()
        let relationshipStatusTableCell = WhiteTableCell()
        
        override init(frame: CGRect, style: UITableViewStyle) {
            super.init(frame: CGRect(), style: .plain)
            
            delegate = self
            dataSource = self
            
            self.separatorStyle = .none
            
            self.estimatedRowHeight = 50
            self.rowHeight = UITableViewAutomaticDimension
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - Table view data source
        
        func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 13
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
                //cell = WhiteTextTableCell(text: "Mobile Design / Wine + Spirits. Looking for some new friends in the local startup world to join me on a new venture!")
            case 3:
                cell = GrayTableCell(text: "Looking For")
            case 4:
                //cell = WhiteTextTableCell(text: "Add Something you are Looking For")
                cell = lookingForTableCell
            case 5:
                cell = GrayTableCell(text: "Current Work")
            case 6:
                //cell = WhiteTableCell(text: "Add Work")
                cell = workTableCell
            case 7:
                cell = GrayTableCell(text: "School")
            case 8:
                //cell = WhiteTableCell(text: "Add Work")
                cell = schoolTableCell
            case 9:
                cell = GrayTableCell(text: "Gender")
            case 10:
                //cell = WhiteTableCell(text: "Add Gender")
                cell = genderTableCell
            case 11:
                cell = GrayTableCell(text: "Relationship Status")
            case 12:
                //cell = WhiteTableCell(text: "Add Relationship Status")
                cell = relationshipStatusTableCell
            default:
                //cell = WhiteTableCell(text: "")
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
        
        func setParentVCOfEditProfilePicturesCell(parentVC: UIViewController) {
            editProfilePicturesCell.setParentVC(parentVC: parentVC)
        }
    }
    
    class GrayTableCell: UITableViewCell {
        
        init(text: String) {
            super.init(style: .subtitle, reuseIdentifier: "GrayTableCell")
            
            self.textLabel?.text = text
            self.textLabel?.font = Constants.Fonts.bold16
            self.backgroundColor = Constants.Colors.necter.backgroundGray
            self.textLabel?.textColor = Constants.Colors.necter.textDarkGray
            self.isUserInteractionEnabled = false
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
