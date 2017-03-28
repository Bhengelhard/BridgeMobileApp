//
//  EditProfileInfoObjects.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 3/10/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class EditProfileInfoObjects {
    
    class NavBar: NecterNavigationBar {
        
        init(infoTitle: String) {
            super.init()
            
            rightButton.setTitle("Done", for: .normal)
            //rightButton.titleLabel?.font = Constants.Fonts.light18
            rightButton.sizeToFit()
            let gradientColor = DisplayUtility.gradientColor(size: rightButton.frame.size)
            rightButton.setTitleColor(gradientColor, for: .normal)
            
            self.shadowImage = nil
            
            navItem.title = infoTitle
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    class TableView: UITableView, UITableViewDelegate, UITableViewDataSource {
        let field: UserInfoField
        var value: String?
        var shouldDisplay = false
        var valueCell = OptionCell()
        
        init(infoTitle: String, value: String) {
            field = .age
            super.init(frame: CGRect(), style: .plain)
            
            delegate = self
            dataSource = self
            
            self.separatorStyle = .none
            self.isScrollEnabled = false
            
            self.backgroundColor = Constants.Colors.necter.backgroundGray
            
            self.estimatedRowHeight = 50
            self.rowHeight = UITableViewAutomaticDimension
        }
        
        init(field: UserInfoField) {
            self.field = field
            super.init(frame: CGRect(), style: .plain)
            
            delegate = self
            dataSource = self
            
            separatorStyle = .singleLine
            isScrollEnabled = false
            
            backgroundColor = Constants.Colors.necter.backgroundGray
            
            estimatedRowHeight = 50
            rowHeight = UITableViewAutomaticDimension
            
            tableFooterView = UIView()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - Table view data source
        func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if value != nil {
                return 3
            }
            return 2
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var cell: UITableViewCell
            
            let editProfileInfoBackend = EditProfileInfoBackend()
            //let isSelected = editProfileInfoBackend.returnSelected(title: infoTitle)
            
            switch(indexPath.row) {
                /*
            case 0:
                cell = DescriptionCell(text: "")
            case 1:
                cell = OptionCell(text: value, infoTitle: infoTitle)
                if let cell = cell as? OptionCell {
                    if isSelected {
                        cell.checkmarkButton.isSelected = true
                    } else {
                        cell.checkmarkButton.isSelected = false
                    }
                }
                
            case 2:
                cell = DescriptionCell(text: "If your \(infoTitle) isn't shown, update it on Facebook.")
            case 3:
                cell = OptionCell(text: "None", infoTitle: infoTitle)
                if let cell = cell as? OptionCell {
                    if !isSelected {
                        cell.checkmarkButton.isSelected = true
                    } else {
                        cell.checkmarkButton.isSelected = false
                    }                
                 }
            */
            case 0:
                cell = DescriptionCell(text: "If your \(field.rawValue.lowercased()) isn't shown, update it on Facebook.")
            case 1:
                cell = OptionCell()
                if let cell = cell as? OptionCell {
                    cell.textLabel?.text = "None"
                    /*
                    if !isSelected {
                        cell.checkmarkButton.isSelected = true
                    } else {
                        cell.checkmarkButton.isSelected = false
                    }*/
                }
            case 2:
                cell = valueCell
            
            default:
                cell = DescriptionCell(text: "")
            }
            
            
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            //if indexPath.row == 0 {
            //    return 20
            //}
            return 50
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // Change Option Cell selected checkmark button
            if let cell = cellForRow(at: indexPath) as? OptionCell {
                print("cell is OptionCell")
                
                let noneIndexPath = IndexPath(row: 1, section: 0)
                let valueIndexPath = IndexPath(row: 2, section: 0)
                
                let cell2: OptionCell
                if indexPath == valueIndexPath {
                    cell2 = cellForRow(at: noneIndexPath) as! EditProfileInfoObjects.OptionCell
                } else {
                    cell2 = cellForRow(at: valueIndexPath) as! EditProfileInfoObjects.OptionCell
                }
                
                if cell.checkmarkButton.isSelected {
                    cell.checkmarkButton.isSelected = false
                    cell2.checkmarkButton.isSelected = true
                } else {
                    cell.checkmarkButton.isSelected = true
                    cell2.checkmarkButton.isSelected = false
                }
            }
        }
        
    }
    
    class OptionCell: UITableViewCell {
        let checkmarkButton = UIButton()
        
        init() {
            super.init(style: .subtitle, reuseIdentifier: "OptionCell")
            
            self.textLabel?.font = Constants.Fonts.light18
            self.backgroundColor = UIColor.white
            self.selectionStyle = .none
            
            checkmarkButton.setImage(nil, for: .normal)
            checkmarkButton.setImage(#imageLiteral(resourceName: "Gradient_Checkmark_Circle_Selected"), for: .selected)

            addSubview(checkmarkButton)
            checkmarkButton.autoAlignAxis(toSuperviewAxis: .horizontal)
            checkmarkButton.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
            checkmarkButton.autoSetDimensions(to: CGSize(width: 30, height: 30))
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class DescriptionCell: UITableViewCell {
        
        init(text: String) {
            super.init(style: .subtitle, reuseIdentifier: "OptionCell")
            
            self.textLabel?.text = text
            self.textLabel?.font = Constants.Fonts.light14
            self.textLabel?.numberOfLines = 0
            self.backgroundColor = Constants.Colors.necter.backgroundGray
            self.selectionStyle = .none
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}
