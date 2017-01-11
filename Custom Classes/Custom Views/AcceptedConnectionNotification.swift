//
//  AcceptedConnectionNotification.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 1/8/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class AcceptedConnectionNotification: UIView {
    
    let connectionsNected = UIButton()
    var totalConnectionsNected = 0
    
    var acceptedConnectionObjectId: String
    var user1Name: String
    var user1ObjectId: String
    var user1ProfilePictureURL: String
    var user2Name: String
    var user2ObjectId: String
    var user2ProfilePictureURL: String
    let user1ProfilePicture = UIButton(type: .custom)
    let user2ProfilePicture = UIButton(type: .custom)
    
    init(acceptedConnectionObjectId: String, user1Name: String, user1ObjectId: String, user1ProfilePictureURL: String, user2Name: String, user2ObjectId: String, user2ProfilePictureURL: String) {
        self.acceptedConnectionObjectId = acceptedConnectionObjectId
        self.user1Name = user1Name
        self.user1ObjectId = user1ObjectId
        self.user1ProfilePictureURL = user1ProfilePictureURL
        self.user2Name = user2Name
        self.user2ObjectId = user2ObjectId
        self.user2ProfilePictureURL = user2ProfilePictureURL
        
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight))
        
        intializeUIElements()
        getTotalConnectionsNected()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func connectionsNectedTapped(_ sender: UIButton) {
        if connectionsNected.isSelected {
            connectionsNected.isSelected = false
        } else {
            connectionsNected.isSelected = true
        }
    }
    
    //open user1's profile upon tapping user1ProfilePicture
    @objc func user1ProfilePictureTapped(_ sender: UIButton) {
        print("user1ProfilePictureTapped")
    }
    
    //open user2's profile upon tapping user2ProfilePicture
    @objc func user2ProfilePictureTapped(_ sender: UIButton) {
        print("user2ProfilePictureTapped")
    }
    
    //open message between current user and user1 upon tapping leftMessageButton
    @objc func leftMessageButtonTapped(_ sender: UIButton) {
        print("leftMessageButtonTapped")
    }
    
    //open message between current user and user2 upon tapping rightMessageButton
    @objc func rightMessageButtonTapped(_ sender: UIButton) {
        print("rightMessageButtonTapped")
    }
    
    //exit acceptedConnectionNotification with animation upon tapping exitButton
    @objc func exitButtonTapped(_ sender: UIButton) {
        //Save accepted_notification_viewed to true
        markNotificationViewed()
        
        //Remove acceptedConnectionNotification from View
        self.alpha = 1
        UIView.animate(withDuration: 0.4, animations: {
            self.alpha = 0
        }) { (success) in
            self.removeFromSuperview()
        }
    }
    
    //Change accepted_notification_viewed to true to denote the user has seen the new notification
    func markNotificationViewed(){
        let query = PFQuery(className: "BridgePairings")
        query.getObjectInBackground(withId: acceptedConnectionObjectId) { (object, error) in
            if error != nil {
                print(error ?? "Error: obhject not retrieved after exitButtonTapped")
            } else {
                if let object = object {
                    object["accepted_notification_viewed"] = true
                    object.saveInBackground(block: { (success, error) in
                        if error != nil {
                            print(error ?? "Error: accepted_notification_viewed not saved after exitButtonTapped")
                        } else if success == success {
                            //increment numConnectionsNected in localData
                            let localData = LocalData()
                            if let numNected = localData.getNumConnectionsNected() {
                                localData.setNumConnectionsNected(numNected + 1)
                            }
                            
                            //Check for another AcceptedConnectionNotification
                            let dbRetrievingFunctions = DBRetrievingFunctions()
                            if let view = self.superview {
                                dbRetrievingFunctions.queryForAcceptedConnectionNotifications(view: view)
                            }
                            
                            
                        }
                    })
                }
            }
        }
    }
    
    //Retrieving the currentUser's total connections nected from the Database and setting totalConnectionsNected to that Integer + 1 for the currently displayed connection
    func getTotalConnectionsNected() {
        let query = PFQuery(className: "BridgePairings")
        query.whereKey("connecter_objectId", equalTo: PFUser.current()?.objectId)
        query.whereKey("user1_response", equalTo: 1)
        query.whereKey("user2_response", equalTo: 1)
        query.whereKey("accepted_notification_viewed", equalTo: true)
        query.countObjectsInBackground { (numConnected, error) in
            if error != nil {
                print(error ?? "There was an error with query called by getTotalConnectionsNected()")
            } else {
                DispatchQueue.main.async(execute: {
                    self.totalConnectionsNected = Int(numConnected) + 1
                    self.connectionsNected.setTitle("\(self.totalConnectionsNected) CONNECTIONS NECTED", for: .selected)
                    self.connectionsNected.setTitleColor(UIColor.white, for: .selected)
                })
            }
        }
    }
    
    //Get Profile Pictures
    func getProfilePictures() {
        let downloader = Downloader()
        if let URL = URL(string: user1ProfilePictureURL) {
            downloader.imageFromURL(URL: URL, callBack: callbackToSetUser1Photo)
        }
        if let URL = URL(string: user2ProfilePictureURL) {
            downloader.imageFromURL(URL: URL, callBack: callbackToSetUser2Photo)
        }
    }
    //Set Profile Pictures
    func callbackToSetUser1Photo(_ image: UIImage) -> Void {
        DispatchQueue.main.async(execute: {
            self.user1ProfilePicture.setImage(image, for: UIControlState())
            print("callback 1")
        })
        
    }
    func callbackToSetUser2Photo(_ image: UIImage) -> Void {
        DispatchQueue.main.async(execute: {
            self.user2ProfilePicture.setImage(image, for: UIControlState())
            print("callback 2")
        })
    }

    
    //UI Setting Functions
    func intializeUIElements() {
        
        //Accepted Connection Blurred View
        let displayUtility = DisplayUtility()
        displayUtility.setBlurredView(viewToBlur: self)
        
        //Accepted Connection Notification Title
        let title = UIImageView()
        let titleOriginY = 0.12744*DisplayUtility.screenHeight
        let titleHeight = 0.1*DisplayUtility.screenHeight
        let titleWidth = 0.82198*DisplayUtility.screenWidth
        title.frame = CGRect(x: 0, y: titleOriginY, width: titleWidth, height: titleHeight)
        title.image = #imageLiteral(resourceName: "Sweet_Nect_In_Notification")
        title.center.x = self.center.x
        self.addSubview(title)
        
        //Number of Connections Nected increase is displayed and when clicked shows the current User's total number of connections nected
        let connectionsNectedOriginY = 0.24513*DisplayUtility.screenHeight
        let connectionsNectedHeight = 0.02*DisplayUtility.screenHeight
        connectionsNected.frame = CGRect(x: 0, y: connectionsNectedOriginY, width: DisplayUtility.screenWidth, height: connectionsNectedHeight)
        connectionsNected.setTitle("+1 CONNECTIONS NECTED", for: .normal)
        connectionsNected.setTitleColor(DisplayUtility.gradientColor(size: connectionsNected.frame.size), for: .normal)
        connectionsNected.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 15.5)
        connectionsNected.addTarget(self, action: #selector(connectionsNectedTapped(_:)), for: .touchUpInside)
        self.addSubview(connectionsNected)
        
        //Setting the profile pictures
        let profilePictureDiameter = 0.36311*DisplayUtility.screenWidth
        let profilePictureOriginY = 0.30343*DisplayUtility.screenHeight
        let profilePictureBorderWidth : CGFloat = 1.5
        //User1 Profile Picture
        user1ProfilePicture.frame = CGRect(x: 0.09383*DisplayUtility.screenWidth, y: profilePictureOriginY, width: profilePictureDiameter, height: profilePictureDiameter)
        user1ProfilePicture.layer.borderColor = DisplayUtility.gradientColor(size: user1ProfilePicture.frame.size).cgColor
        user1ProfilePicture.layer.borderWidth = profilePictureBorderWidth
        user1ProfilePicture.layer.cornerRadius = profilePictureDiameter/2
        user1ProfilePicture.layer.masksToBounds = true
        user1ProfilePicture.addTarget(self, action: #selector(user1ProfilePictureTapped(_:)), for: .touchUpInside)
        self.addSubview(user1ProfilePicture)
        
        //User2 Profile Picture
        let user2ProfilePictureOriginX = 0.51885*DisplayUtility.screenWidth
        user2ProfilePicture.frame = CGRect(x: user2ProfilePictureOriginX, y: profilePictureOriginY, width: profilePictureDiameter, height: profilePictureDiameter)
        user2ProfilePicture.layer.borderColor = DisplayUtility.gradientColor(size: user1ProfilePicture.frame.size).cgColor
        user2ProfilePicture.layer.borderWidth = profilePictureBorderWidth
        user2ProfilePicture.layer.cornerRadius = profilePictureDiameter/2
        user2ProfilePicture.layer.masksToBounds = true
        user2ProfilePicture.addTarget(self, action: #selector(user2ProfilePictureTapped(_:)), for: .touchUpInside)
        self.addSubview(user2ProfilePicture)
        
        //Disabling Profile Picture User Interaction until Profiles Epic is ready to be connected
        user1ProfilePicture.isUserInteractionEnabled = false
        user2ProfilePicture.isUserInteractionEnabled = false
        
        //Downloading the profile pictures and using callbacks to set the button images
        getProfilePictures()
        
        //Connecting Gradient Line
        let connectingLine = UIView()
        connectingLine.center.y = user1ProfilePicture.center.y
        connectingLine.frame.origin.x = user1ProfilePicture.frame.maxX
        connectingLine.frame.size.height = profilePictureBorderWidth
        connectingLine.frame.size.width = user2ProfilePicture.frame.minX - user1ProfilePicture.frame.maxX
        connectingLine.backgroundColor = DisplayUtility.gradientColor(size: connectingLine.frame.size)
        self.addSubview(connectingLine)
        
        //Setting Message Buttons
        let messageButtonSize = CGSize(width: 0.3466*DisplayUtility.screenWidth, height: 0.04029*DisplayUtility.screenHeight)
        let messageButtonOriginY = 0.57091*DisplayUtility.screenHeight
        //Message User 1 Button
        let leftMessageButton = UIButton()
        leftMessageButton.frame.size = messageButtonSize
        leftMessageButton.center.x = user1ProfilePicture.frame.midX
        leftMessageButton.frame.origin.y = messageButtonOriginY
        leftMessageButton.setTitle("Message", for: .normal)
        leftMessageButton.setTitleColor(UIColor.lightGray, for: .normal)
        leftMessageButton.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 15)
        leftMessageButton.layer.borderColor = UIColor.lightGray.cgColor
        leftMessageButton.layer.borderWidth = 1
        leftMessageButton.layer.cornerRadius = 8.5
        leftMessageButton.addTarget(self, action: #selector(leftMessageButtonTapped(_:)), for: .touchUpInside)
        self.addSubview(leftMessageButton)
        
        //Message User 2 Button
        let rightMessageButton = UIButton()
        rightMessageButton.frame.size = messageButtonSize
        rightMessageButton.center.x = user2ProfilePicture.center.x
        rightMessageButton.frame.origin.y = messageButtonOriginY
        rightMessageButton.setTitle("Message", for: .normal)
        rightMessageButton.setTitleColor(UIColor.lightGray, for: .normal)
        rightMessageButton.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 15)
        rightMessageButton.layer.borderColor = UIColor.lightGray.cgColor
        rightMessageButton.layer.borderWidth = 1
        rightMessageButton.layer.cornerRadius = 7
        rightMessageButton.addTarget(self, action: #selector(rightMessageButtonTapped(_:)), for: .touchUpInside)
        self.addSubview(rightMessageButton)
        
        //Disabling Message Button Interaction until singleMessage is ready to be connected
        rightMessageButton.isUserInteractionEnabled = false
        leftMessageButton.isUserInteractionEnabled = false
        
        //Setting Dashed Lines
        //Left Dashed Line
        let leftDashedLine = DashedLine()
        leftDashedLine.frame = self.bounds
        leftDashedLine.backgroundColor = UIColor.clear
        leftDashedLine.coordinates = [CGPoint(x: user1ProfilePicture.center.x, y: user1ProfilePicture.frame.maxY), CGPoint(x: leftMessageButton.center.x, y: leftMessageButton.frame.minY)]
        self.insertSubview(leftDashedLine, at: 1)
        
        //Right Dashed Line
        let rightDashedLine = DashedLine()
        rightDashedLine.frame = self.bounds
        rightDashedLine.backgroundColor = UIColor.clear
        rightDashedLine.coordinates = [CGPoint(x: user2ProfilePicture.center.x, y: user2ProfilePicture.frame.maxY), CGPoint(x: rightMessageButton.center.x, y: rightMessageButton.frame.minY)]
        self.insertSubview(rightDashedLine, at: 1)
        
        
        //Getting user's first names
        let user1FirstName = user1Name.components(separatedBy: " ").first!
        let user2FirstName = user2Name.components(separatedBy: " ").first!
        
        //User's Connected Information
        let infoLabel = UILabel()
        infoLabel.frame.size = CGSize(width: 0.64025*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenHeight)
        infoLabel.center.x = self.center.x
        infoLabel.frame.origin.y = 0.65442*DisplayUtility.screenHeight
        infoLabel.text = "\(user1FirstName) and \(user2FirstName) accepted your connection!"
        infoLabel.textAlignment = NSTextAlignment.center
        infoLabel.textColor = UIColor.white
        infoLabel.font = UIFont(name: "BentonSans-Light", size: 20)
        infoLabel.numberOfLines = 2
        self.addSubview(infoLabel)
        
        //Exit Button
        let exitButton = UIButton()
        let exitButtonDiameter = 0.05*DisplayUtility.screenHeight
        exitButton.frame.origin.y = infoLabel.frame.maxY + 0.1*DisplayUtility.screenHeight
        exitButton.frame.size = CGSize(width: exitButtonDiameter, height: exitButtonDiameter)
        exitButton.center.x = self.center.x
        exitButton.setTitleColor(UIColor.white, for: .normal)
        exitButton.setTitle("X", for: .normal)
        exitButton.layer.borderWidth = 1
        exitButton.layer.borderColor = UIColor.white.cgColor
        exitButton.layer.cornerRadius = exitButtonDiameter/2
        exitButton.addTarget(self, action: #selector(exitButtonTapped(_:)), for: .touchUpInside)
        self.addSubview(exitButton)
    }
    
}
