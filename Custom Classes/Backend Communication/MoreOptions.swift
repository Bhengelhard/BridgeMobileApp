//
//  MoreOptions.Swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 3/20/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Parse
import MBProgressHUD

class MoreOptions {
    
    let vc: UIViewController
    var messageID: String?
    
    init(vc: UIViewController) {
        self.vc = vc
    }
    
    func displayMoreAlertController(messageID: String?) {
        let hud = MBProgressHUD.showAdded(to: vc.view, animated: true)
        hud.label.text = "Loading..."
        
        self.messageID = messageID
        
        let addMoreMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Check if user follows the other user
        //        if areFriends {
        //
        //        } else {
        //
        //
        //        }
        // If blocked then add does not appear
        // If blocked then message disappears
        // If the currentUser is blocked then they get popup with title "Message Not Sent" and messgae "This person isn't receiveing messages right now." and button "OK"
        // If the currentUser is the blocker then they get popup with title: "Message Not Sent" and message "Unblock to send messages"
        

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
                    self.block(message: message)
                }
                
                let unblockAction = UIAlertAction(title: "Unblock", style: .default) { (_) in
                    self.unblock(message: message)
                }
                
                // Check if user has reported the other user
                let reportAction = UIAlertAction(title: "Report", style: .destructive) { (_) in
                    self.report(message: message)
                }
                
                let reportedAction = UIAlertAction(title: "Reported", style: .destructive)
                reportedAction.isEnabled = false
                
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
                    addMoreMenu.dismiss(animated: true, completion: nil)
                }
                
                User.getCurrent { (currentUser) in
                    message.getNonCurrentUser { (otherUser) in
                        if let otherUserID = otherUser.id {
                            if let currentUserFriendList = currentUser.friendList {
                                if currentUserFriendList.contains(otherUserID) {
                                    addMoreMenu.addAction(unfollowAction)
                                } else {
                                    addMoreMenu.addAction(followAction)
                                }
                            } else {
                                addMoreMenu.addAction(followAction)
                            }
                            
                            if let currentUserBlockingList = currentUser.blockingList {
                                if currentUserBlockingList.contains(otherUserID) {
                                    addMoreMenu.addAction(unblockAction)
                                } else {
                                    addMoreMenu.addAction(blockAction)
                                }
                            } else {
                                addMoreMenu.addAction(blockAction)
                            }
                            
                            if let currentUserReportedList = currentUser.reportedList {
                                if currentUserReportedList.contains(otherUserID) {
                                    addMoreMenu.addAction(reportedAction)
                                } else {
                                    addMoreMenu.addAction(reportAction)
                                }
                            } else {
                                addMoreMenu.addAction(reportAction)
                            }
                        }
                        addMoreMenu.addAction(cancelAction)
                        self.vc.present(addMoreMenu, animated: true, completion: nil)
                        
                        MBProgressHUD.hide(for: self.vc.view, animated: true)
                    }
                }
            }
        }
        
    }
    

    func follow(message: Message) {
        // add otherUser to currentUser's friend list
        message.getNonCurrentUser { (otherUser) in
            if let firstName = otherUser.firstName {
                let alert = UIAlertController(title: "Followed \(firstName)?", message: "You will be able to 'nect \(firstName) with your friends.", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Follow", style: .default) { (_) in
                    let hud = MBProgressHUD.showAdded(to: self.vc.view, animated: true)
                    hud.label.text = "Loading..."

                    User.getCurrent { (currentUser) in
                        if let otherUserID = otherUser.id, var currentUserFriendList = currentUser.friendList {
                            if !currentUserFriendList.contains(otherUserID) {
                                currentUserFriendList.append(otherUserID)
                                currentUser.friendList = currentUserFriendList
                            }
                        }
                        currentUser.save { (_) in
                            MBProgressHUD.hide(for: self.vc.view, animated: true)
                        }
                    }
                })
                    
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                
                self.vc.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func unfollow(message: Message) {
        // remove otherUser from currentUser's friend list
        message.getNonCurrentUser { (otherUser) in
            if let firstName = otherUser.firstName {
                let alert = UIAlertController(title: "Unfollowed \(firstName)?", message: "You will no longer be able to 'nect \(firstName) with your friends.", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Unfollow", style: .destructive) { (_) in
                    let hud = MBProgressHUD.showAdded(to: self.vc.view, animated: true)
                    hud.label.text = "Loading..."

                    User.getCurrent { (currentUser) in
                        if let otherUserID = otherUser.id {
                            if var currentUserFriendList = currentUser.friendList {
                                if let index = currentUserFriendList.index(of: otherUserID) {
                                    currentUserFriendList.remove(at: index)
                                    currentUser.friendList = currentUserFriendList
                                }
                            }
                        }
                        currentUser.save { (_) in
                            MBProgressHUD.hide(for: self.vc.view, animated: true)
                        }
                    }
                })
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                
                self.vc.present(alert, animated: true, completion: nil)
            }
        }
    }
    

    func block(message: Message) {
        // block both users from introducing and messaging
        message.getNonCurrentUser { (otherUser) in
            if let firstName = otherUser.firstName {
                let alert = UIAlertController(title: "Block \(firstName)?", message: "You and \(firstName) will no longer be able to introduce or message each other.", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Block", style: .destructive) { (_) in
                    let hud = MBProgressHUD.showAdded(to: self.vc.view, animated: true)
                    hud.label.text = "Loading..."

                    User.getCurrent { (currentUser) in
                        if let otherUserID = otherUser.id {
                            if var currentUserBlockingList = currentUser.blockingList {
                                if !currentUserBlockingList.contains(otherUserID) {
                                    currentUserBlockingList.append(otherUserID)
                                    currentUser.blockingList = currentUserBlockingList
                                }
                            } else {
                                currentUser.blockingList = [otherUserID]
                            }
                            currentUser.save { (_) in
                                MBProgressHUD.hide(for: self.vc.view, animated: true)
                            }
                            
                            BridgePairing.getAll(withUser: currentUser) { (bridgePairings) in
                                for bridgePairing in bridgePairings {
                                    if var blockedList = bridgePairing.blockedList {
                                        if !blockedList.contains(otherUserID) {
                                            blockedList.append(otherUserID)
                                            bridgePairing.blockedList = blockedList
                                        }
                                    } else {
                                        bridgePairing.blockedList = [otherUserID]
                                    }
                                    bridgePairing.save()
                                }
                            }
                        }
                    }
                })
                    
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                
                self.vc.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func unblock(message: Message) {
        // unblock both users from introducing and messaging
        message.getNonCurrentUser { (otherUser) in
            if let firstName = otherUser.firstName {
                let alert = UIAlertController(title: "Unblock \(firstName)?", message: "You and \(firstName) will be able to introduce and message each other.", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Unblock", style: .default) { (_) in
                    let hud = MBProgressHUD.showAdded(to: self.vc.view, animated: true)
                    hud.label.text = "Loading..."

                    User.getCurrent { (currentUser) in
                        if let otherUserID = otherUser.id {
                            if var currentUserBlockingList = currentUser.blockingList {
                                if  let index = currentUserBlockingList.index(of: otherUserID) {
                                    currentUserBlockingList.remove(at: index)
                                    currentUser.blockingList = currentUserBlockingList
                                }
                            }
                            currentUser.save { (_) in
                                MBProgressHUD.hide(for: self.vc.view, animated: true)
                            }
                            
                            BridgePairing.getAll(withUser: currentUser) { (bridgePairings) in
                                for bridgePairing in bridgePairings {
                                    if var blockedList = bridgePairing.blockedList {
                                        if  let index = blockedList.index(of: otherUserID) {
                                            blockedList.remove(at: index)
                                            bridgePairing.blockedList = blockedList
                                        }
                                    }
                                    bridgePairing.save()
                                }
                            }
                        }
                    }
                })
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                
                self.vc.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func report(message: Message) {
        // report otherUser for misconduct
        message.getNonCurrentUser { (otherUser) in
            if let firstName = otherUser.firstName {
                let alert = UIAlertController(title: "Report \(firstName)?", message: "Are you sure you want to report \(firstName) for misconduct?", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Report", style: .destructive) { (_) in
                    let hud = MBProgressHUD.showAdded(to: self.vc.view, animated: true)
                    hud.label.text = "Loading..."

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
                        currentUser.save { (_) in
                            MBProgressHUD.hide(for: self.vc.view, animated: true)
                        }
                    }
                })
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                
                self.vc.present(alert, animated: true, completion: nil)
            }
        }
    }

    /*
    func removeUsersFromEachothersFriendlists() {
        if let currentUser = PFUser.current() {
            if let currentUserObjectId = currentUser.objectId {
                let pfCloudFunctions = PFCloudFunctions()
                //pfCloudFunctions.removeUsersFromEachothersFriendLists(parameters: ["userObjectId1": currentUserObjectId, "userObjectId2": userId])
                print("removeUsersFromEachothersFriendLists was called")
            }
        }
    }*/
    
}
