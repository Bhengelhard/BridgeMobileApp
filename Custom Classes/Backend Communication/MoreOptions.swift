//
//  MoreOptions.Swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 3/20/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Parse

class MoreOptions {
    
    var vc: UIViewController?
    
    func displayMoreAlertController(vc: UIViewController) {
        self.vc = vc
        
        let addMoreMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        
        // Check if user follows the other user
        //        if areFriends {
        //
        //        } else {
        //
        //
        //        }
        
        let followAction = UIAlertAction(title: "Follow", style: .default) { (alert) in
            self.follow()
        }
        
        // Check if user has blocked the other user
        let blockAction = UIAlertAction(title: "Block", style: .destructive) { (alert) in
            self.block()
        }
        
        // Check if user has reported the other user
        let reportAction = UIAlertAction(title: "Report", style: .destructive) { (alert) in
            self.report()
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            addMoreMenu.dismiss(animated: true, completion: nil)
        }
        
        addMoreMenu.addAction(followAction)
        addMoreMenu.addAction(blockAction)
        addMoreMenu.addAction(reportAction)
        addMoreMenu.addAction(cancelAction)
        
        vc.present(addMoreMenu, animated: true, completion: nil)
        
    }
    
    func follow() {
        // Code that adds otherUser to currentUser's friendlist after making sure they have not been blocked
        
        let firstName = "test"//DisplayUtility.firstNameLastNameInitial(name: userName)
        
        let alert = UIAlertController(title: "You followed \(firstName)", message: "You can now 'nect \(firstName) with your friends.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in

        }))
        
        vc?.present(alert, animated: true, completion: nil)
    }
    
    func unfollow() {
        // Code that removes otherUser from currentUser's friendlist
        
        let firstName = "test"//DisplayUtility.firstNameLastNameInitial(name: userName)
        
        let alert = UIAlertController(title: "You Unfollowed \(firstName)", message: "You can no longer 'nect \(firstName) with your friends.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
            
        }))
        
        vc?.present(alert, animated: true, completion: nil)
    }
    
    func block() {
        // Code that removes current user from otherUser's friendlist
        let firstName = "test"//DisplayUtility.firstNameLastNameInitial(name: userName)
        
        let alert = UIAlertController(title: "You blocked \(firstName)", message: "\(firstName) is no longer be able to introduce you.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
            
        }))
        
        vc?.present(alert, animated: true, completion: nil)
    }
    
    func unblock() {
        // Code that adds current user to otherUser's friendlist
        let firstName = "test"//DisplayUtility.firstNameLastNameInitial(name: userName)
        
        let alert = UIAlertController(title: "You Unblocked \(firstName)", message: "\(firstName) is now able to introduce you.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
            
        }))
        
        vc?.present(alert, animated: true, completion: nil)
    }
    
    func report() {
        let firstName = "Test"//DisplayUtility.firstNameLastNameInitial(name: userName)
        
        let alert = UIAlertController(title: "Report \(firstName)?", message: "Are you sure you want to report \(firstName) for misconduct? You will both no longer be able to introduce each other.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
//            var reportedUsers: [String]
//            if let userReportedUsers = currentUser["reported_users"] as? [String] {
//                reportedUsers = userReportedUsers
//            } else {
//                reportedUsers = [String]()
//            }
//            //reportedUsers.append(self.userId)
//            currentUser["reported_users"] = reportedUsers
//            currentUser.saveInBackground()
            //self.removeUsersFromEachothersFriendlists
            print("Yes tapped")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            
        }))
        
        vc?.present(alert, animated: true, completion: nil)
    }

    func removeUsersFromEachothersFriendlists() {
        if let currentUser = PFUser.current() {
            if let currentUserObjectId = currentUser.objectId {
                let pfCloudFunctions = PFCloudFunctions()
                //pfCloudFunctions.removeUsersFromEachothersFriendLists(parameters: ["userObjectId1": currentUserObjectId, "userObjectId2": userId])
                print("removeUsersFromEachothersFriendLists was called")
            }
        }
    }
    
}
