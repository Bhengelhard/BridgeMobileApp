//
//  ExternalProfileViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/20/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit
import MBProgressHUD

class ExternalProfileViewController: UIViewController {

    // MARK: Global Variables
    let layout = ExternalProfileLayout()
    let transitionManager = TransitionManager()
    var userID: String?
    
    var didSetupConstraints = false
    
    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout.dismissButton.addTarget(self, action: #selector(dismissButtonTapped(_:)), for: .touchUpInside)
        layout.messageButton.addTarget(self, action: #selector(messageButtonTapped(_:)), for: .touchUpInside)
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // Hide the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.white
        
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        didSetupConstraints = layout.initialize(view: view, didSetupConstraints: didSetupConstraints)
        
        super.updateViewConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        
        // Setting the size of the content within the Scroll View so it will scroll to the specified height
        let contentSize = CGSize(width: layout.scrollView.frame.width, height: layout.messageButton.frame.maxY + 20)
        layout.scrollView.contentSize = contentSize
    }
    
    // MARK: - Targets
    func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Setters
    
    /// set user ID and get user's information
    func setUserID(userID: String?) {
        self.userID = userID
        
        if let userID = userID {
            let externalProfileBackend = ExternalProfileBackend()
            
            let hud = MBProgressHUD.showAdded(to: layout.profilePicturesVC.view, animated: true)
            hud.label.text = "Loading..."
            
            // pictures
            externalProfileBackend.getImages(userID: userID) { (images) in
                for image in images {
                    self.layout.profilePicturesVC.addImage(image: image)
                }
                
                if images.count <= 1 {
                    self.layout.profilePicturesVC.pageControl.alpha = 0
                } else {
                    self.layout.profilePicturesVC.pageControl.alpha = 1
                }
                
                MBProgressHUD.hide(for: self.layout.profilePicturesVC.view, animated: true)
            }
            
            // name
            externalProfileBackend.setName(userID: userID, label: layout.name)
            
            /*
            externalProfileBackend.getFieldShouldDisplayAndValue(userID: userID, field: .city) { (shouldDisplay, value) in
                if shouldDisplay {
                    if let city = value {
                        self.layout.factsTable.addFactCell(forField: .city, withIcon: #imageLiteral(resourceName: "Profile_Unselected_Work_Icon"), withFactText: "Lives in \(city)")
                    }
                }
                //self.layout.layoutFactViews()
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }*/
            
            // facts label
            externalProfileBackend.setFacts(userID: userID, label: layout.factLabel)
            
            // about me
            externalProfileBackend.setAboutMe(userID: userID, label: layout.aboutMeLabel)
            
            // looking for
            externalProfileBackend.setLookingFor(userID: userID, label: layout.lookingForLabel)
        }
    }
    
    /// Hide the message button when the current user is looking at their own profile
    func hideMessageButton() {
        layout.messageButton.alpha = 0
    }
    
    /// Create Direct Message with the other User
    func messageButtonTapped(_ sender: UIButton) {
        print("messageButtonTapped")
        
        var user1ID = String()
        var user2ID = userID
        var connecterID = String()
        var user1Name = String()
        var user2Name = String()
        var user1PictureID = String()
        var user2PictureID = String()
        
        // Get 1st user
        User.getCurrent { (user1) in
            print("user1.id: \(user1.id)")
            if let id1 = user1.id { 
                user1ID = id1
                connecterID = id1
            }
            if let name1 = user1.name {
                user1Name = name1
            }
            if let picIDs1 = user1.pictureIDs {
                if let picID1 = picIDs1[0] as? String {
                    user1PictureID = picID1
                }
            }
            
            // Get 2nd user
            if let id = user2ID {
                User.get(withID: id, withBlock: { (user2) in
                    print("user2.id: \(user2.id)")
                    if let id2 = user2.id {
                        user2ID = id2
                    }
                    if let name2 = user2.name {
                        user2Name = name2
                    }
                    if let picIDs2 = user2.pictureIDs {
                        if let picID2 = picIDs2[0] as? String {
                            user2PictureID = picID2
                        }
                    }
                    
                    // Create message with both of the retrieved users
                    Message.create(user1ID: user1ID, user2ID: user2ID, connecterID: connecterID, user1Name: user1Name, user2Name: user2Name, user1PictureID: user1PictureID, user2PictureID: user2PictureID, lastSingleMessage: nil, user1HasSeenLastSingleMessage: nil, user2HasSeenLastSingleMessage: nil, user1HasPosted: nil, user2HasPosted: nil) { (message, isNew) in
                        if isNew {
                            message.save(withBlock: { (message) in
                                if let messageId = message.id {
                                    print("messageId: \(messageId)")
                                    let threadVC = ThreadViewController()
                                    threadVC.setMessageID(messageID: messageId)
                                    self.present(threadVC, animated: true, completion: nil)
                                }
                            })
                        } else {
                            if let messageId = message.id {
                                print("messageId: \(messageId)")
                                let threadVC = ThreadViewController()
                                threadVC.setMessageID(messageID: messageId)
                                self.present(threadVC, animated: true, completion: nil)
                            }
                        }
                        
                    }
                })
            }
        }
        

        
        
        
        // Create new object in Messages table with users information
        // In the block after that is saved Open Thread with setMessageID. That should be all
        
        
    }
    
    // MARK: - Navigation
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        let vc = segue.destination
    //        let mirror = Mirror(reflecting: vc)
    //        if mirror.subjectType == LoginViewController.self {
    //            self.transitionManager.animationDirection = "Bottom"
    //        }
    //        //vc.transitioningDelegate = self.transitionManager
    //    }
    
}
