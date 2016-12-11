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
    let necterInfo = UIView()
    let profilePicture1 = UIImageView()
    let personalInfo = UILabel()
    let localData = LocalData()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        displayNavigationBar()
        displayProfilePictures()
        displayNecterInformation()
        displayLine(y: necterInfo.frame.maxY)
        displayPersonalInformation()
        displayLine(y: personalInfo.frame.maxY)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Displaying the profile pictures view on the profile
    func displayProfilePictures() {
        profilePicture1.frame = CGRect(x: 0, y: customNavigationBar.frame.maxY, width: DisplayUtility.screenWidth, height: 0.5622*DisplayUtility.screenHeight)
        if let data = localData.getMainProfilePicture() {
            profilePicture1.image = UIImage(data: data)
        } else {
            //set image for when the user has not yet set their profile picture
        }
        
        view.addSubview(profilePicture1)
        
    }
    func displayNavigationBar() {
        rightBarButton.addTarget(self, action: #selector(rightBarButtonTapped(_:)), for: .touchUpInside)
        customNavigationBar.createCustomNavigationBar(view: view, leftBarButtonIcon: nil, leftBarButtonSelectedIcon: nil, leftBarButton: nil, rightBarButtonIcon: "Right_Arrow", rightBarButtonSelectedIcon: "Right_Arrow", rightBarButton: rightBarButton, title: "Profile")
    }
    func displayNecterInformation() {
        necterInfo.frame = CGRect(x: 0, y: profilePicture1.frame.maxY, width: DisplayUtility.screenWidth, height: 0.12*DisplayUtility.screenHeight)
        let user = PFUser.current()!
        let nameLabel = UILabel()
        if let name = user["name"] as? String {
            nameLabel.text = DisplayUtility.firstNameLastNameInitial(name: name)
        }
        nameLabel.textColor = .white
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont(name: "BentonSans-Bold", size: 28)
        nameLabel.frame = CGRect(x: 0.01927*necterInfo.frame.width, y: 0.1*necterInfo.frame.height, width: 0.8*necterInfo.frame.width, height: 0.60*necterInfo.frame.height)
        nameLabel.sizeToFit()
        necterInfo.addSubview(nameLabel)
        let numNectedLabel = UILabel()
        if let nected = user["built_bridges"] as? [String] {
            numNectedLabel.text = "\(nected.count) CONNECTIONS 'NECTED"
        }
        numNectedLabel.textColor = .white
        numNectedLabel.textAlignment = .left
        numNectedLabel.font = UIFont(name: "BentonSans-Light", size: 15.5)
        numNectedLabel.frame = CGRect(x: nameLabel.frame.minX, y: nameLabel.frame.maxY + 0.05*necterInfo.frame.height, width: necterInfo.frame.width, height: 0.25*necterInfo.frame.height)
        numNectedLabel.sizeToFit()
        necterInfo.addSubview(numNectedLabel)
        
        view.addSubview(necterInfo)
    }
    func displayPersonalInformation() {
        personalInfo.textAlignment = .left
        personalInfo.textColor = .white
        personalInfo.numberOfLines = 3
        personalInfo.font = UIFont(name: "BentonSans-Light", size: 18)
        let user = PFUser.current()!
        var line1 = ""
        if let age = user["age"] as? Int {
            line1 = "\(age)"
            if let city = user["city"] as? String {
                line1 = "\(line1), \(city)"
            }
        } else if let city = user["city"] as? String {
            line1 = city
        }
        var line2 = ""
        if let school = user["school"] as? String {
            line2 = school
        }
        var line3 = ""
        if let employer = user["employer"] as? String {
            line3 = "Works for \(employer)"
        }
        personalInfo.text = "\(line1)\n\(line2)\n\(line3)"
        personalInfo.frame = CGRect(x: 0.03754*DisplayUtility.screenWidth, y: necterInfo.frame.maxY, width: 0.76861*DisplayUtility.screenWidth, height: 0.12616*DisplayUtility.screenHeight)
        view.addSubview(personalInfo)
    }
    
    func displayLine(y: CGFloat) {
        let line = UIView()
        line.backgroundColor = .white
        line.frame = CGRect(x: 0, y: y, width: 0.74704*DisplayUtility.screenWidth, height: 1)
        line.center.x = DisplayUtility.screenWidth / 2
        view.addSubview(line)
    }
    
    func rightBarButtonTapped(_ sender: UIButton) {
        //let bridgeVC = BridgeViewController()
        //self.present(bridgeVC, animated: true, completion: nil)
        performSegue(withIdentifier: "showBridgePageFromMyProfile", sender: self)

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
