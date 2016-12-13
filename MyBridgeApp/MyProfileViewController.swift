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
    let localData = LocalData()
    let user = PFUser.current()!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        displayNavigationBar()
        
        scrollView.frame = CGRect(x: 0, y: customNavigationBar.frame.maxY, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight - customNavigationBar.frame.maxY)
        scrollView.backgroundColor = .black
        view.addSubview(scrollView)
        displayProfilePictures()
        
        let editButton = createEditButton()
        displayNecterInformation(button: editButton)
        displayLine(y: necterInfo.frame.maxY)
        
        displayPersonalInformation()
        displayCurrentRequests()
        displayLine(y: currentRequests.frame.maxY)
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
        if let nected = user["built_bridges"] as? [String] {
            numNectedLabel.text = "\(nected.count) CONNECTIONS 'NECTED"
        } else {
            numNectedLabel.text = "0 CONNECTIONS 'NECTED"
        }
        numNectedLabel.textColor = .white
        numNectedLabel.textAlignment = .left
        numNectedLabel.font = UIFont(name: "BentonSans-Light", size: 15.5)
        numNectedLabel.frame = CGRect(x: nameLabel.frame.minX, y: nameLabel.frame.maxY + 0.05*necterInfo.frame.height, width: necterInfo.frame.width, height: 0.95*necterInfo.frame.height - nameLabel.frame.maxY)
        numNectedLabel.sizeToFit()
        necterInfo.addSubview(numNectedLabel)
        
        scrollView.addSubview(necterInfo)
    }
    func displayPersonalInformation() {
        personalInfo.textAlignment = .left
        personalInfo.textColor = .white
        personalInfo.numberOfLines = 3
        personalInfo.font = UIFont(name: "BentonSans-Light", size: 18)
        var allLines = ""
        var line1 = ""
        var numLines = 0
        if let age = user["age"] as? Int {
            line1 = "\(age)"
            if let city = user["city"] as? String {
                line1 = "\(line1), \(city)"
                allLines.append(line1)
                numLines += 1
            }
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
                allLines.append(line2)
                numLines += 1
            } else {
                allLines.append(line2)
                numLines += 1
            }
        }
        var line3 = ""
        if let employer = user["employer"] as? String {
            line3 = "Works for \(employer)"
            if allLines != "" {
                allLines.append("\n")
                allLines.append(line3)
                numLines += 1
            } else {
                allLines.append(line3)
                numLines += 1
            }
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
        let editButton = DisplayUtility.gradientButton(text: "edit", frame: frame)
        editButton.addTarget(self, action: #selector(editButtonTapped(_:)), for: .touchUpInside)
        return editButton
    }
    func getCurrentRequest(type: String, frame: CGRect) -> UIView {
        var reqView = UIView()
        var color = String()
        switch type {
        case "Business":
            reqView = businessReqView
            color = "Blue"
        case "Love":
            reqView = loveReqView
            color = "Red"
        case "Friendship":
            reqView = friendshipReqView
            color = "Green"
        default:
            return
        }
        let icon = UIImageView()
        icon.image = UIImage(named: "\(type)_Icon_\(color)")
    }
    func displayCurrentRequests() {
        var y = personalInfo.frame.maxY
        for type in ["Business", "Love", "Freindship"] {
            let frame = CGRect(x: 0, y: y, width: DisplayUtility.screenWidth, height: 0.08*DisplayUtility.screenHeight)
            let currentRequest = getCurrentRequest(type, frame)
            currentRequests.addSubview(currentRequest)
        }
        currentRequests.sizeToFit()
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
