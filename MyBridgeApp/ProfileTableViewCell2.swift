//
//  ProfileTableViewCell2.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 7/25/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class ProfileTableViewCell2: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var preferencesSwitch: UISwitch!
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    //Switches Tapped
    @IBAction func preferencesSwitchTapped(sender: AnyObject) {
        if label.text == "Bridge for Business" {
            if preferencesSwitch.on{
                label.textColor = UIColor.blackColor()
                if let _ = PFUser.currentUser() {
                    PFUser.currentUser()?["interested_in_business"] = true
                }
            }
            else{
                label.textColor = UIColor.grayColor()
                if let _ = PFUser.currentUser() {
                    PFUser.currentUser()?["interested_in_business"] = false
                }
            }
        } else if label.text == "Bridge for Love" {
            if preferencesSwitch.on{
                label.textColor = UIColor.blackColor()
                if let _ = PFUser.currentUser() {
                    PFUser.currentUser()?["interested_in_love"] = true
                }
            }
            else{
                label.textColor = UIColor.grayColor()
                if let _ = PFUser.currentUser() {
                    PFUser.currentUser()?["interested_in_love"] = false
                }
            }
        } else {
            if preferencesSwitch.on{
                label.textColor = UIColor.blackColor()
                if let _ = PFUser.currentUser() {
                    PFUser.currentUser()?["interested_in_friendship"] = true
                }
            }
            else{
                label.textColor = UIColor.grayColor()
                if let _ = PFUser.currentUser() {
                    PFUser.currentUser()?["interested_in_friendship"] = false
                }
            }
        }
        PFUser.currentUser()?.saveInBackgroundWithBlock{
            (success: Bool, error: NSError?) -> Void in
            if success && error == nil {
                PFCloud.callFunctionInBackground("changeBridgePairingsOnInterestedInUpdate", withParameters: [:]) {
                    (response:AnyObject?, error: NSError?) -> Void in
                    if error == nil {
                        if let response = response as? String {
                            print(response)
                        }
                    }
                }
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
