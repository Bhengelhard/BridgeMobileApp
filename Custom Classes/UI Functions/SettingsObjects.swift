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
            
            self.backgroundColor = UIColor.white

            label.text = "WWW.NECTER.SOCIAL"
            label.sizeToFit()
            label.font = Constants.Fonts.bold16
            label.textColor = Constants.Colors.necter.textGray
            
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
            
            self.isScrollEnabled = false
            
            self.estimatedRowHeight = 100
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
            return 4
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
                cell = MyNecterTableCell()
            }
            
            return cell
            
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            if indexPath.row == 3 {
                return 150
            } else {
                return 50
            }
            
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // Change Option Cell selected checkmark button
            if let cell = cellForRow(at: indexPath) as? WhiteTableCell {
                print("cell is OptionCell")
                if cell.checkmarkButton.isSelected {
                    cell.checkmarkButton.isSelected = false
                } else {
                    cell.checkmarkButton.isSelected = true
                }
            }
        }
        
    }
    
    class GrayTableCell: UITableViewCell {
        
        init(text: String) {
            super.init(style: .subtitle, reuseIdentifier: "GrayTableCell")
            
            self.textLabel?.text = text
            self.textLabel?.font = Constants.Fonts.bold16
            self.backgroundColor = Constants.Colors.necter.backgroundGray
            self.isUserInteractionEnabled = false
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    class WhiteTableCell: UITableViewCell {
        
        let checkmarkButton = UIButton()
        
        init(text: String) {
            super.init(style: .subtitle, reuseIdentifier: "WhiteTableCell")
            
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
    
    class MyNecterTableCell: UITableViewCell {
        
        var feedbackButton = UIButton()
        var privacyButton = UIButton()
        var logoutButton = UIButton()
        var termsOfServiceButton = UIButton()
        let dividerLine = UIView()
        let buttonSize = CGSize(width: 130, height: 35)
        
        init() {
            super.init(style: .subtitle, reuseIdentifier: "MyNecterTableCell")
            
            self.backgroundColor = UIColor.white
            self.selectionStyle = .none

            // Initialize buttons
            setUpButton(button: feedbackButton, text: "FEEDBACK")
            setUpButton(button: privacyButton, text: "PRIVACY")
            setUpButton(button: logoutButton, text: "LOGOUT")
            setUpButton(button: termsOfServiceButton, text: "TERMS")
            
            // Initialize divider
            dividerLine.backgroundColor = Constants.Colors.necter.backgroundGray
            
            // Layout buttons
            let buffer: CGFloat = 20
            
            self.addSubview(feedbackButton)
            feedbackButton.autoPinEdge(toSuperviewEdge: .left, withInset: buffer)
            feedbackButton.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            feedbackButton.autoSetDimensions(to: buttonSize)
            
            self.addSubview(privacyButton)
            privacyButton.autoPinEdge(toSuperviewEdge: .right, withInset: buffer)
            privacyButton.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
            privacyButton.autoSetDimensions(to: buttonSize)
            
            self.addSubview(dividerLine)
            dividerLine.autoPinEdge(.top, to: .bottom, of: feedbackButton, withOffset: buffer)
            dividerLine.autoPinEdge(toSuperviewEdge: .left, withInset: buffer)
            dividerLine.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
            dividerLine.autoSetDimension(.height, toSize: 1)
            
            self.addSubview(logoutButton)
            logoutButton.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            logoutButton.autoPinEdge(.top, to: .bottom, of: dividerLine, withOffset: buffer)
            logoutButton.autoSetDimensions(to: buttonSize)
            
            self.addSubview(termsOfServiceButton)
            termsOfServiceButton.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
            termsOfServiceButton.autoPinEdge(.top, to: .bottom, of: dividerLine, withOffset: buffer)
            termsOfServiceButton.autoSetDimensions(to: buttonSize)
            
            
            // Add Targets
            feedbackButton.addTarget(self, action: #selector(feedbackButtonTapped(_:)), for: .touchUpInside)
            privacyButton.addTarget(self, action: #selector(privacyButtonTapped(_:)), for: .touchUpInside)
            logoutButton.addTarget(self, action: #selector(logoutButtonTapped(_:)), for: .touchUpInside)
            termsOfServiceButton.addTarget(self, action: #selector(termsOfServiceButtonTapped(_:)), for: .touchUpInside)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // Helper Functions
        func setUpButton(button: UIButton, text: String) {
            let gradientColor = DisplayUtility.gradientColor(size: buttonSize)
            button.backgroundColor = gradientColor
            button.setTitle(text, for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.titleLabel?.font = Constants.Fonts.bold16
            button.layer.cornerRadius = 12
        }
        
        // Targets
        func feedbackButtonTapped(_ sender: UIButton) {
            let subject = "Providing%20Feedback%20for%20the%20necter%20Team"
            let encodedParams = "subject=\(subject)"
            let email = "blake@necter.social"
            let url = NSURL(string: "mailto:\(email)?\(encodedParams)")
            
            if UIApplication.shared.canOpenURL(url! as URL) {
                UIApplication.shared.openURL(url! as URL)
            } else {
                // Let the user know if his/her device isn't able to send Emails
                let errorAlert = UIAlertView(title: "Cannot Send Email", message: "Your device is not able to send emails.", delegate: self, cancelButtonTitle: "OK")
                errorAlert.show()
            }
            
        }
        
        // Notify SettingsViewController to display WebPrivacyViewController
        func privacyButtonTapped(_ sender: UIButton) {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "privacyButtonTapped"), object: nil)
        }
        
        // Notify SettingsViewController to logout
        func logoutButtonTapped(_ sender: UIButton) {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "logoutTapped"), object: nil)
        }
        
        // Notify SettingsViewController to logout
        func termsOfServiceButtonTapped(_ sender: UIButton) {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "termsOfServiceButtonTapped"), object: nil)
        }
        
    }
    
    
}
