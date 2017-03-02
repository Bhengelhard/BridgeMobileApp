//
//  SettingsObjects.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/21/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import PureLayout

class SettingsObjects {
    
    class NavBar: NecterNavigationBar {
        
        override init() {
            super.init()
            
            rightButton.setTitle("Done", for: .normal)
            rightButton.sizeToFit()
            let gradientColor = DisplayUtility.gradientColor(size: rightButton.frame.size)
            rightButton.setTitleColor(gradientColor, for: .normal)

            navItem.title = "Settings"
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class WebsiteView: UIView {
        
        let label = UILabel()
        
        init() {
            super.init(frame: CGRect())
            
            self.backgroundColor = UIColor.lightGray

            label.text = "WWW.NECTER.SOCIAL"
            //label.textColor = UIColor.orange
            label.sizeToFit()
            label.font = Constants.Fonts.bold16
            
            addSubview(label)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class Table: UITableView, UITableViewDelegate, UITableViewDataSource {
        
        override init(frame: CGRect, style: UITableViewStyle) {
            super.init(frame: CGRect(), style: .plain)
            
            delegate = self
            dataSource = self
            
            self.separatorStyle = .none
            self.isScrollEnabled = false
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - Table view data source
        
        func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
        }
         
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 5
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            var cell = UITableViewCell()
            
            if indexPath.row == 0 {
                cell = GrayTableCell(text: "Notification")
                
            } else if indexPath.row == 1 {
                cell = WhiteTableCell(text: "Necter Newsletter")
                
            } else if indexPath.row == 2 {
                cell = GrayTableCell(text: "My Necter")
                
            } else if indexPath.row == 3 {
                cell = WhiteTableCell(text: "Feedback")
                
            } else if indexPath.row == 4 {
                
                cell = WhiteTableCell(text: "Logout")
            }
            
            return cell
            
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 50
        }
        
    }
    
    class GrayTableCell: UITableViewCell {
        
        init(text: String) {
            super.init(style: .subtitle, reuseIdentifier: "GrayTableCell")
            
            self.textLabel?.text = text
            self.textLabel?.font = Constants.Fonts.bold16
            self.backgroundColor = UIColor.lightGray
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    class WhiteTableCell: UITableViewCell {
        
        let checkmarkButton = UIButton()
        
        init(text: String) {
            super.init(style: .subtitle, reuseIdentifier: "GrayTableCell")
            
            self.textLabel?.text = text
            self.textLabel?.font = Constants.Fonts.light18
            self.backgroundColor = UIColor.white
            
            checkmarkButton.setImage(#imageLiteral(resourceName: "Gradient_Checkmark_Circle_Unselected"), for: .normal)
            checkmarkButton.setImage(#imageLiteral(resourceName: "Gradient_Checkmark_Circle_Selected"), for: .selected)
            checkmarkButton.isSelected = true
            checkmarkButton.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
            
            addSubview(checkmarkButton)
            checkmarkButton.autoAlignAxis(toSuperviewAxis: .horizontal)
            checkmarkButton.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
            checkmarkButton.autoSetDimensions(to: CGSize(width: 40, height: 40))
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func tapped(_ sender: UIButton) {
            if checkmarkButton.isSelected {
                checkmarkButton.isSelected = false
            } else {
                checkmarkButton.isSelected = true
            }
        }
        
    }
    
    
}
