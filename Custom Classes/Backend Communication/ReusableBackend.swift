//
//  ReusableBackend.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 3/20/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Parse

class ReusableBackend {
    
//    func unmatch(_ sender: UIButton) {
//        let firstName = DisplayUtility.firstNameLastNameInitial(name: userName)
//        
//        let alert = UIAlertController(title: "Unmatch?", message: "Are you sure you want to unmatch \(firstName)? You will no longer be able to introduce each other.", preferredStyle: UIAlertControllerStyle.alert)
//        
//        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
//            self.animateOut(sender)
//        }))
//        
//        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
//            self.unmatch() // unmatch users
//            self.animateOut(sender)
//        }))
//        
//        parentVC.present(alert, animated: true, completion: nil)
//    }
//    
//    func reportUser(_ sender: UIButton) {
//        if let currentUser = PFUser.current() {
//            if let currentUserObjectId = currentUser.objectId {
//                let firstName = DisplayUtility.firstNameLastNameInitial(name: userName)
//                
//                let alert = UIAlertController(title: "Report User?", message: "Are you sure you want to report \(firstName)? You will also be unmathced, and will not be able to introduce each other.", preferredStyle: UIAlertControllerStyle.alert)
//                
//                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
//                    self.animateOut(sender)
//                }))
//                
//                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
//                    var reportedUsers: [String]
//                    if let userReportedUsers = currentUser["reported_users"] as? [String] {
//                        reportedUsers = userReportedUsers
//                    } else {
//                        reportedUsers = [String]()
//                    }
//                    reportedUsers.append(self.userId)
//                    currentUser["reported_users"] = reportedUsers
//                    currentUser.saveInBackground()
//                    self.unmatch() // unmatch users
//                    self.animateOut(sender)
//                }))
//                
//                parentVC.present(alert, animated: true, completion: nil)
//            }
//        }
//    }
//    
//    func unmatch() {
//        if let currentUser = PFUser.current() {
//            if let currentUserObjectId = currentUser.objectId {
//                let pfCloudFunctions = PFCloudFunctions()
//                pfCloudFunctions.removeUsersFromEachothersFriendLists(parameters: ["userObjectId1": currentUserObjectId, "userObjectId2": userId])
//                print("removeUsersFromEachothersFriendLists was called")
//            }
//        }
//    }
    
}
