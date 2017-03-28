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
    var messageID: String?
    
    func displayMoreAlertController(vc: UIViewController, messageID: String?) {
        self.vc = vc
        self.messageID = messageID
        
        let addMoreMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        
        // Check if user follows the other user
        //        if areFriends {
        //
        //        } else {
        //
        //
        //        }
        
        if let messageID = messageID {
            Message.get(withID: messageID) { (message) in
        
                let followAction = UIAlertAction(title: "Follow", style: .default) { (_) in
                    self.follow(message: message)
                }
                
                let unfollowAction = UIAlertAction(title: "Unfollow", style: .destructive) { (_) in
                    self.unfollow(message: message)
                }
                
                // Check if user has blocked the other user
                let blockAction = UIAlertAction(title: "Block", style: .destructive) { (_) in
                    self.block()
                }
                
                let unblockAction = UIAlertAction(title: "Unblock", style: .default) { (_) in
                    self.unblock()
                }
                
                // Check if user has reported the other user
                let reportAction = UIAlertAction(title: "Report", style: .destructive) { (_) in
                    self.report(message: message)
                }
                
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
                    addMoreMenu.dismiss(animated: true, completion: nil)
                }
                
                User.getCurrent { (currentUser) in
                    message.getNonCurrentUser { (otherUser) in
                        if let otherUserID = otherUser.id, let currentUserFriendList = currentUser.friendList {
                            if currentUserFriendList.contains(otherUserID) {
                                addMoreMenu.addAction(unfollowAction)
                            } else {
                                addMoreMenu.addAction(followAction)
                            }
                            addMoreMenu.addAction(blockAction)
                            addMoreMenu.addAction(reportAction)
                            addMoreMenu.addAction(cancelAction)
                            
                            vc.present(addMoreMenu, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        
    }
    
    func follow(message: Message) {
        // add otherUser to currentUser's friend list
        message.getNonCurrentUser { (otherUser) in
            if let firstName = otherUser.firstName {
                let alert = UIAlertController(title: "You followed \(firstName)", message: "You can now 'nect \(firstName) with your friends.", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Okay", style: .default))
                
                User.getCurrent { (currentUser) in
                    if let otherUserID = otherUser.id, var currentUserFriendList = currentUser.friendList {
                        if !currentUserFriendList.contains(otherUserID) {
                            currentUserFriendList.append(otherUserID)
                            currentUser.friendList = currentUserFriendList
                        }
                    }
                    currentUser.save { (_) in
                        if let vc = self.vc {
                            vc.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    func unfollow(message: Message) {
        // remove otherUser from currentUser's friend list
        message.getNonCurrentUser { (otherUser) in
            if let firstName = otherUser.firstName {
                let alert = UIAlertController(title: "You Unfollowed \(firstName)", message: "You can no longer 'nect \(firstName) with your friends.", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Okay", style: .default))
                
                User.getCurrent { (currentUser) in
                    if let otherUserID = otherUser.id {
                        if var currentUserFriendList = currentUser.friendList {
                            if let index = currentUserFriendList.index(of: otherUserID) {
                                currentUserFriendList.remove(at: index)
                                currentUser.friendList = currentUserFriendList
                            }
                        } else {
                            currentUser.friendList = [otherUserID]
                        }
                    }
                    currentUser.save { (_) in
                        if let vc = self.vc {
                            vc.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
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
        // add current user to other user's friendlist
        let firstName = "test"//DisplayUtility.firstNameLastNameInitial(name: userName)
        
        let alert = UIAlertController(title: "You Unblocked \(firstName)", message: "\(firstName) is now able to introduce you.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
            
        }))
        
        vc?.present(alert, animated: true, completion: nil)
    }
    
    func report(message: Message) {
        // report otherUser for misconduct
        message.getNonCurrentUser { (otherUser) in
            if let firstName = otherUser.firstName {
                let alert = UIAlertController(title: "Report \(firstName)?", message: "Are you sure you want to report \(firstName) for misconduct?", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { (_) in
                    User.getCurrent { (currentUser) in
                        if let otherUserID = otherUser.id {
                            if var currentUserReportedList = currentUser.reportedList {
                                if !currentUserReportedList.contains(otherUserID) {
                                    currentUserReportedList.append(otherUserID)
                                    currentUser.reportedList = currentUserReportedList
                                }
                            } else {
                                currentUser.reportedList = [otherUserID]
                            }
                        }
                        currentUser.save()
                    }
                })
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                
                if let vc = self.vc {
                    vc.present(alert, animated: true, completion: nil)
                }
            }
        }
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
