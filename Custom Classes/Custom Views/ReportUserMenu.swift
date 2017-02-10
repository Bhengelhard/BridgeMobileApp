//
//  ReportUserMenu.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 2/9/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class ReportUserMenu: UIView {
    
    let parentVC: UIViewController
    let superView: UIView
    let userId: String
    let userName: String
    
    let showingFrame = CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight)
    let hiddenFrame = CGRect(x: 0, y: DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight)
    
    init(parentVC: UIViewController, superView: UIView, userId: String, userName: String) {
        self.parentVC = parentVC
        self.superView = superView
        self.userId = userId
        self.userName = userName
        
        let frame = hiddenFrame
        super.init(frame: frame)
        backgroundColor = .white
        
        // add gesture recognizer to hide upload menu
        let animateOutGR = UITapGestureRecognizer(target: self, action: #selector(animateOut(_:)))
        addGestureRecognizer(animateOutGR)
        
        let reportButtonWidth = 0.66*DisplayUtility.screenWidth
        let reportButtonHeight = 0.14*DisplayUtility.screenWidth
        

        // create unmatch button
        let unmatchButtonFrame = CGRect(x: 0, y: 0, width: reportButtonWidth, height: reportButtonHeight)
        let unmatchButton = DisplayUtility.plainButton(frame: unmatchButtonFrame, text: "UNMATCH", fontSize: 13)
        unmatchButton.center = CGPoint(x: 0.5*frame.width, y: 0.4*frame.height)
        addSubview(unmatchButton)
        
        // add target to unmatch button
        unmatchButton.addTarget(self, action: #selector(unmatch(_:)), for: .touchUpInside)
        
        
        // create report user button
        let reportUserFrame = CGRect(x: 0, y: 0, width: reportButtonWidth, height: reportButtonHeight)
        let reportUserButton = DisplayUtility.plainButton(frame: reportUserFrame, text: "REPORT USER", fontSize: 13)
        reportUserButton.center = CGPoint(x: 0.5*frame.width, y: 0.6*frame.height)
        addSubview(reportUserButton)
        
        // add target to report user button
        reportUserButton.addTarget(self, action: #selector(reportUser(_:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // display menu
    func animateIn(_ sender: UIButton) {
        frame = hiddenFrame
        superView.addSubview(self)
        UIView.animate(withDuration: 0.5) {
            self.frame = self.showingFrame
        }
    }
    
    func animateOut(_ sender: UIButton) {
        frame = showingFrame
        UIView.animate(withDuration: 0.5, animations: {
            self.frame = self.hiddenFrame
        }) { (finished) in
            if finished {
                self.removeFromSuperview()
            }
        }
    }
    
    func unmatch(_ sender: UIButton) {
        let firstName = DisplayUtility.firstNameLastNameInitial(name: userName)
        
        let alert = UIAlertController(title: "Unmatch?", message: "Are you sure you want to unmatch \(firstName)? You will no longer be able to introduce each other.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            self.animateOut(sender)
        }))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.unmatch() // unmatch users
            self.animateOut(sender)
        }))
        
        parentVC.present(alert, animated: true, completion: nil)
    }
    
    func reportUser(_ sender: UIButton) {
        if let currentUser = PFUser.current() {
            if let currentUserObjectId = currentUser.objectId {
                let firstName = DisplayUtility.firstNameLastNameInitial(name: userName)
                
                let alert = UIAlertController(title: "Report User?", message: "Are you sure you want to report \(firstName)? You will also be unmathced, and will not be able to introduce each other.", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                    self.animateOut(sender)
                }))
                
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                    var reportedUsers: [String]
                    if let userReportedUsers = currentUser["reported_users"] as? [String] {
                        reportedUsers = userReportedUsers
                    } else {
                        reportedUsers = [String]()
                    }
                    reportedUsers.append(self.userId)
                    currentUser["reported_users"] = reportedUsers
                    currentUser.saveInBackground()
                    self.unmatch() // unmatch users
                    self.animateOut(sender)
                }))
                
                parentVC.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func unmatch() {
        if let currentUser = PFUser.current() {
            if let currentUserObjectId = currentUser.objectId {
                let pfCloudFunctions = PFCloudFunctions()
                pfCloudFunctions.removeUsersFromEachothersFriendLists(parameters: ["userObjectId1": currentUserObjectId, "userObjectId2": userId])
                print("removeUsersFromEachothersFriendLists was called")
            }
        }
    }
    
}
