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
    
    class backgroundView: UIView {
        
        init() {
            super.init(frame: CGRect())
            self.backgroundColor = Constants.Colors.necter.backgroundGray
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class tableView: UITableView, UITableViewDelegate, UITableViewDataSource {
        
        override init(frame: CGRect, style: UITableViewStyle) {
            super.init(frame: CGRect(), style: .plain)
            
            delegate = self
            dataSource = self
            
            //self.separatorStyle = .
            
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
            
            var cell = OptionCell(text: "test")
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // Change Option Cell selected checkmark button
            if let cell = cellForRow(at: indexPath) as? OptionCell {
                print("cell is OptionCell")
                if cell.checkmarkButton.isSelected {
                    cell.checkmarkButton.isSelected = false
                } else {
                    cell.checkmarkButton.isSelected = true
                }
            }
        }
        
    }
    
    class OptionCell: UITableViewCell {
        let checkmarkButton = UIButton()
        
        init(text: String) {
            super.init(style: .subtitle, reuseIdentifier: "OptionCell")
            
            self.textLabel?.text = text
            self.textLabel?.font = Constants.Fonts.light18
            self.backgroundColor = UIColor.white
            self.selectionStyle = .none
            
            checkmarkButton.setImage(#imageLiteral(resourceName: "Gradient_Checkmark_Circle_Unselected"), for: .normal)
            checkmarkButton.setImage(#imageLiteral(resourceName: "Gradient_Checkmark_Circle_Selected"), for: .selected)
            checkmarkButton.isSelected = true
            
            addSubview(checkmarkButton)
            checkmarkButton.autoAlignAxis(toSuperviewAxis: .horizontal)
            checkmarkButton.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
            checkmarkButton.autoSetDimensions(to: CGSize(width: 30, height: 30))
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class descriptionCell: UITableViewCell {
        
    }
}
