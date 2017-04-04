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
            
            shadowImage = nil
                        
            navItem.title = infoTitle
            if let titleLabel = navItem.titleView as? UILabel {
                titleLabel.adjustsFontSizeToFitWidth = true
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    class TableView: UITableView, UITableViewDelegate, UITableViewDataSource {
        let field: UserInfoField
        var value: String?
        var shouldDisplay = false
        let noneCell = OptionCell()
        let valueCell = OptionCell()
        var noneSelected = true
        
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
            
            noneCell.textLabel?.text = "Do Not Display"
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
            
            switch(indexPath.row) {
            case 0:
                cell = DescriptionCell(text: "If your \(field.rawValue.lowercased()) isn't shown, update it on Facebook.")
            case 1:
                cell = noneCell
                noneCell.setChecked(checked: !shouldDisplay)
            case 2:
                cell = valueCell
                valueCell.setChecked(checked: shouldDisplay)
            
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
            if let cell = cellForRow(at: indexPath) {
                if cell == noneCell {
                    if !noneCell.checked {
                        shouldDisplay = false
                        noneCell.setChecked(checked: true)
                        valueCell.setChecked(checked: false)
                    }
                } else if cell == valueCell {
                    if !valueCell.checked {
                        shouldDisplay = true
                        noneCell.setChecked(checked: false)
                        valueCell.setChecked(checked: true)
                    }
                }
            }
        }
        
    }
    
    class OptionCell: UITableViewCell {
        let checkmarkButton = UIButton()
        var checked = false
        
        init() {
            super.init(style: .subtitle, reuseIdentifier: "OptionCell")
            
            self.textLabel?.font = Constants.Fonts.light18
            self.backgroundColor = UIColor.white
            self.selectionStyle = .none
            
            checkmarkButton.setImage(nil, for: .normal)
            checkmarkButton.setImage(#imageLiteral(resourceName: "Gradient_Checkmark_Circle_Selected"), for: .selected)
            
            checkmarkButton.isUserInteractionEnabled = false

            addSubview(checkmarkButton)
            checkmarkButton.autoAlignAxis(toSuperviewAxis: .horizontal)
            checkmarkButton.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
            checkmarkButton.autoSetDimensions(to: CGSize(width: 30, height: 30))
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setChecked(checked: Bool) {
            self.checked = checked
            checkmarkButton.isSelected = checked
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
