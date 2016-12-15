//
//  MyProfileViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 12/9/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class MyProfileViewController: UIViewController {
    
    var rightBarButton = UIButton()
    let transitionManager = TransitionManager()
    let customNavigationBar = CustomNavigationBar()
    let scrollView = UIScrollView()
    let necterInfo = UIView()
    let profilePicture1 = UIImageView()
    let personalInfo = UILabel()
    let currentRequests = UIView()
    let bottomOfProfileButtons = UIView()
    let localData = LocalData()
    var user = PFUser.current()!

    override func viewDidLoad() {
        print ("my profile did load")
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        displayNavigationBar()
        
        scrollView.frame = CGRect(x: 0, y: customNavigationBar.frame.maxY, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight - customNavigationBar.frame.maxY)
        scrollView.backgroundColor = .black
        scrollView.bounces = false
        view.addSubview(scrollView)
        
        displayProfilePictures()
        
        let editButton = createEditButton()
        displayNecterInformation(button: editButton)
        displayLine(y: necterInfo.frame.maxY)
        
        displayPersonalInformation()
        displayLine(y: personalInfo.frame.maxY)
        
        displayCurrentRequests()
        displayLine(y: currentRequests.frame.maxY)
        
        displayBottomOfProfileButtons()
        
        scrollView.contentSize = CGSize(width: DisplayUtility.screenWidth, height: bottomOfProfileButtons.frame.maxY)
        print ("scrollView frame height: \(scrollView.frame.height) and content height: \(scrollView.contentSize.height)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Displaying the profile pictures view on the profile
    func displayProfilePictures() {
        profilePicture1.frame = CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: 0.5622*DisplayUtility.screenHeight)
        if let data = localData.getMainProfilePicture() {
            let beginImage = CIImage(data: data)
            let edgeDetectFilter = CIFilter(name: "CIVignetteEffect")!
            edgeDetectFilter.setValue(beginImage, forKey: kCIInputImageKey)
            edgeDetectFilter.setValue(0.2, forKey: "inputIntensity")
            edgeDetectFilter.setValue(0.2, forKey: "inputRadius")
            
            //edgeDetectFilter.setValue(CIImage(image: edgeDetectFilter.outputImage!), forKey: kCIInputImageKey)
            let newCGImage = CIContext(options: nil).createCGImage(edgeDetectFilter.outputImage!, from: (edgeDetectFilter.outputImage?.extent)!)
            
            profilePicture1.image = UIImage(cgImage: newCGImage!)

            //profilePicture1.image = UIImage(data: data)
        } else {
            //set image for when the user has not yet set their profile picture
        }
        
        scrollView.addSubview(profilePicture1)
        
    }
    func displayNavigationBar() {
        rightBarButton.addTarget(self, action: #selector(rightBarButtonTapped(_:)), for: .touchUpInside)
        customNavigationBar.createCustomNavigationBar(view: view, leftBarButtonIcon: nil, leftBarButtonSelectedIcon: nil, leftBarButton: nil, rightBarButtonIcon: "Right_Arrow", rightBarButtonSelectedIcon: "Right_Arrow", rightBarButton: rightBarButton, title: "Profile")
    }
    func displayNecterInformation(button: UIButton) {
        necterInfo.frame = CGRect(x: 0, y: profilePicture1.frame.maxY, width: DisplayUtility.screenWidth, height: 0.12*DisplayUtility.screenHeight)
        let nameLabel = UILabel()
        if let name = user["name"] as? String {
            nameLabel.text = DisplayUtility.firstNameLastNameInitial(name: name)
        }
        nameLabel.textColor = .white
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont(name: "BentonSans-Bold", size: 28)
        nameLabel.frame = CGRect(x: 0.01927*necterInfo.frame.width, y: 0.17*necterInfo.frame.height, width: 0.8*necterInfo.frame.width, height: 0.60*necterInfo.frame.height)
        nameLabel.sizeToFit()
        necterInfo.addSubview(nameLabel)
        
        button.frame = CGRect(x: 0.98073*necterInfo.frame.width - button.frame.width, y: nameLabel.frame.minY, width: button.frame.width, height: button.frame.height)
        necterInfo.addSubview(button)
        
        let numNectedLabel = UILabel()
        if let objectId = user.objectId {
            let query = PFQuery(className: "BridgePairings")
            query.whereKey("connecter_objectId", equalTo: objectId)
            query.whereKey("user1_response", equalTo: 1)
            query.whereKey("user2_response", equalTo: 1)
            query.limit = 1000
            query.findObjectsInBackground(block: { (results, error) in
                print("numNected query executing...")
                if let error = error {
                    print("numNected findObjectsInBackgroundWithBlock error - \(error)")
                }
                else if let results = results {
                    numNectedLabel.text = "\(results.count) CONNECTIONS 'NECTED"
                    numNectedLabel.sizeToFit()
                }
            })
        }
        
        numNectedLabel.textColor = .white
        numNectedLabel.textAlignment = .left
        numNectedLabel.font = UIFont(name: "BentonSans-Light", size: 15.5)
        numNectedLabel.frame = CGRect(x: nameLabel.frame.minX, y: nameLabel.frame.maxY + 0.05*necterInfo.frame.height, width: necterInfo.frame.width, height: 0.95*necterInfo.frame.height - nameLabel.frame.maxY)
        necterInfo.addSubview(numNectedLabel)
        
        scrollView.addSubview(necterInfo)
    }
    func displayPersonalInformation() {
        personalInfo.textAlignment = .left
        personalInfo.textColor = .white
        personalInfo.numberOfLines = 3
        personalInfo.font = UIFont(name: "BentonSans-Light", size: 18)
        var allLines = ""
        var numLines = 0
        var line1 = ""
        if let age = user["age"] as? Int {
            line1 = "\(age)"
            if let city = user["city"] as? String {
                line1 = "\(line1), \(city)"
            }
            allLines.append(line1)
            numLines += 1
        } else if let city = user["city"] as? String {
            line1 = city
            allLines.append(line1)
            numLines += 1
        }
        var line2 = ""
        if let school = user["school"] as? String {
            line2 = school
            if allLines != "" {
                allLines.append("\n")
            }
            allLines.append(line2)
            numLines += 1
        }
        var line3 = ""
        if let employer = user["employer"] as? String {
            line3 = "Works for \(employer)"
            if allLines != "" {
                allLines.append("\n")
            }
            allLines.append(line3)
            numLines += 1
        }
        
        personalInfo.text = allLines//"\(line1)\n\(line2)\n\(line3)"
        print(numLines)
        var personalInfoHeight:CGFloat = 0.00
        if numLines == 1 {
            personalInfoHeight = 0.06*DisplayUtility.screenHeight
        } else if numLines == 2 {
            personalInfoHeight = 0.1*DisplayUtility.screenHeight
        } else if numLines == 3 {
            personalInfoHeight = 0.12616*DisplayUtility.screenHeight
        }

        personalInfo.frame = CGRect(x: 0.03754*DisplayUtility.screenWidth, y: necterInfo.frame.maxY, width: 0.76861*DisplayUtility.screenWidth, height: personalInfoHeight)//0.12616*DisplayUtility.screenHeight)
        scrollView.addSubview(personalInfo)
    }
    func createEditButton() -> UIButton {
        let frame = CGRect(x: 0, y: 0, width: 0.18233*DisplayUtility.screenWidth, height: 0.04558*DisplayUtility.screenHeight)
        let editButton = DisplayUtility.gradientButton(text: "edit", frame: frame, fontSize: 17)
        editButton.addTarget(self, action: #selector(editButtonTapped(_:)), for: .touchUpInside)
        return editButton
    }
    func getCurrentRequest(type: String, frame: CGRect) -> UIView {
        let reqView = UIView(frame: frame)
        
        let icon = UIImageView()
        icon.image = UIImage(named: "\(type)_Card_Icon")
        icon.frame = CGRect(x: 0.02501*DisplayUtility.screenWidth, y: 0, width: 0.11596*DisplayUtility.screenWidth, height: 0.11596*DisplayUtility.screenWidth)
        reqView.addSubview(icon)
        
        let status = UILabel()
        status.frame = CGRect(x: icon.frame.maxX + 0.0379*DisplayUtility.screenWidth, y: icon.frame.minY, width: 0.9121*DisplayUtility.screenWidth - icon.frame.maxX, height: 0.8*icon.frame.height)
        status.textAlignment = .left
        status.textColor = .white
        status.numberOfLines = 0
        status.font = UIFont(name: "BentonSans-Light", size: 17)
        status.adjustsFontSizeToFitWidth = true
        status.minimumScaleFactor = 0.75
        
        if let objectId = user.objectId {
            let query = PFQuery(className: "BridgeStatus")
            query.whereKey("userId", equalTo: objectId)
            query.whereKey("bridge_type", equalTo: type)
            query.order(byDescending: "updatedAt")
            query.limit = 1
            query.findObjectsInBackground(block: { (results, error) in
                if let error = error {
                    print("status findObjectsInBackgroundWithBlock error - \(error)")
                }
                else if let results = results {
                    if results.count > 0 {
                        let result = results[0]
                        if let bridgeStatus = result["bridge_status"] as? String {
                            status.text = bridgeStatus
                        }
                    }
                }
            })
        }
        
        reqView.addSubview(status)
        
        return reqView
    }
    func displayCurrentRequests() {
        var y: CGFloat = 0.02*DisplayUtility.screenHeight
        for type in ["Business", "Love", "Friendship"] {
            let frame = CGRect(x: 0, y: y, width: DisplayUtility.screenWidth, height: 0.11596*DisplayUtility.screenWidth + 0.0075*DisplayUtility.screenHeight)
            let currentRequest = getCurrentRequest(type: type, frame: frame)
            y = currentRequest.frame.maxY
            currentRequests.addSubview(currentRequest)
        }
        currentRequests.frame = CGRect(x: 0, y: personalInfo.frame.maxY, width: DisplayUtility.screenWidth, height: y)
        scrollView.addSubview(currentRequests)
    }
    func displayBottomOfProfileButtons() {
        
        let feedbackFrame = CGRect(x: 0.08*DisplayUtility.screenWidth, y: 0.03*DisplayUtility.screenHeight, width: 0.4*DisplayUtility.screenWidth, height: 0.04558*DisplayUtility.screenHeight)
        let feedbackButton = DisplayUtility.gradientButton(text: "give feedback", frame: feedbackFrame, fontSize: 18.5)
        bottomOfProfileButtons.addSubview(feedbackButton)
        
        let termsFrame = CGRect(x: DisplayUtility.screenWidth - feedbackFrame.maxX, y: feedbackFrame.minY, width: feedbackFrame.width, height: feedbackFrame.height)
        let termsButton = DisplayUtility.gradientButton(text: "terms of service", frame: termsFrame, fontSize: 18.5)
        bottomOfProfileButtons.addSubview(termsButton)
        
        let shareFrame = CGRect(x: feedbackFrame.minX, y: feedbackFrame.maxY + 0.021*DisplayUtility.screenHeight, width: feedbackFrame.width, height: feedbackFrame.height)
        let shareButton = DisplayUtility.gradientButton(text: "share necter", frame: shareFrame, fontSize: 18.5)
        bottomOfProfileButtons.addSubview(shareButton)
        
        let privacyFrame = CGRect(x: termsFrame.minX, y: shareFrame.minY, width: feedbackFrame.width, height: feedbackFrame.height)
        let privacyButton = DisplayUtility.gradientButton(text: "privacy policy", frame: privacyFrame, fontSize: 18.5)
        bottomOfProfileButtons.addSubview(privacyButton)
        
        let logoutFrame = CGRect(x: feedbackFrame.minX, y: shareFrame.maxY + 0.021*DisplayUtility.screenHeight, width: feedbackFrame.width, height: feedbackFrame.height)
        let logoutButton = DisplayUtility.gradientButton(text: "logout", frame: logoutFrame, fontSize: 18.5)
        bottomOfProfileButtons.addSubview(logoutButton)
        
        let deleteFrame = CGRect(x: termsFrame.minX, y: logoutFrame.minY, width: feedbackFrame.width, height: feedbackFrame.height)
        let deleteButton = greyButton(text: "delete account", frame: deleteFrame, fontSize: 18.5)
        bottomOfProfileButtons.addSubview(deleteButton)
        
        bottomOfProfileButtons.frame = CGRect(x: 0, y: currentRequests.frame.maxY, width: DisplayUtility.screenWidth, height: logoutFrame.maxY + 0.021*DisplayUtility.screenHeight)
        scrollView.addSubview(bottomOfProfileButtons)
    }
    func greyButton(text: String, frame: CGRect, fontSize: CGFloat) -> UIButton {
        let button = UIButton(frame: frame)
        button.setTitle(text, for: .normal)
        button.backgroundColor = .clear
        let color = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        button.setTitleColor(color, for: .normal)
        button.setTitleColor(color, for: .highlighted)
        button.setTitleColor(color, for: .selected)
        button.titleLabel?.font = UIFont(name: "BentonSans-Light", size: fontSize)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.layer.cornerRadius = 0.2*button.frame.height
        button.layer.borderColor = color.cgColor
        button.layer.borderWidth = 1.5
        button.clipsToBounds = true
        
        return button
    }
    func displayLine(y: CGFloat) {
        let line = UIView()
        line.backgroundColor = .white
        line.frame = CGRect(x: 0, y: y, width: 0.74704*DisplayUtility.screenWidth, height: 1)
        line.center.x = DisplayUtility.screenWidth / 2
        scrollView.addSubview(line)
    }
    
    func rightBarButtonTapped(_ sender: UIButton) {
        //let bridgeVC = BridgeViewController()
        //self.present(bridgeVC, animated: true, completion: nil)
        performSegue(withIdentifier: "showBridgePageFromMyProfile", sender: self)

    }
    
    func editButtonTapped(_ sender: UIButton) {
        print("edit button tapped")
        //present(EditProfileViewController(), animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination
        let mirror = Mirror(reflecting: vc)
        if mirror.subjectType == BridgeViewController.self {
            transitionManager.animationDirection = "Right"
        }
        vc.transitioningDelegate = transitionManager
    }
        
}
