//
//  EditProfileViewController.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 1/11/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Foundation
import UIKit
import Parse

class EditProfileViewController: UIViewController {
    
    var tempSeguedFrom = ""
    var seguedTo = ""
    var seguedFrom = ""
    
    let localData = LocalData()
    
    let scrollView = UIScrollView()
    let exitButton = UIButton()
    let saveButton = UIButton()
    let greetingLabel = UILabel()
    let editingLabel = UILabel()
    let topHexView = HexagonView()
    let leftHexView = HexagonView()
    let rightHexView = HexagonView()
    let bottomHexView = HexagonView()
    
    func lblTapped() {
    }
    
    func tappedOutside() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        
        scrollView.backgroundColor = .clear
        
        if let user = PFUser.current() {
            // Creating viewed exit icon
            let xIcon = UIImageView(frame: CGRect(x: 0.044*DisplayUtility.screenWidth, y: 0.04384*DisplayUtility.screenHeight, width: 0.03514*DisplayUtility.screenWidth, height: 0.03508*DisplayUtility.screenWidth))
            xIcon.image = UIImage(named: "Black_X")
            view.addSubview(xIcon)
            
            // Creating larger clickable space around exit icon
            exitButton.frame = CGRect(x: xIcon.frame.minX - 0.02*DisplayUtility.screenWidth, y: xIcon.frame.minY - 0.02*DisplayUtility.screenWidth, width: xIcon.frame.width + 0.04*DisplayUtility.screenWidth, height: xIcon.frame.height + 0.04*DisplayUtility.screenWidth)
            exitButton.showsTouchWhenHighlighted = false
            exitButton.addTarget(self, action: #selector(exit(_:)), for: .touchUpInside)
            view.addSubview(exitButton)
            
            // Creating viewed check icon
            let checkIcon = UIImageView(frame: CGRect(x: DisplayUtility.screenWidth - xIcon.frame.minX - 0.05188*DisplayUtility.screenWidth, y: 0, width: 0.05188*DisplayUtility.screenWidth, height: 0.03698*DisplayUtility.screenWidth))
            checkIcon.center.y = xIcon.center.y
            checkIcon.image = UIImage(named: "Gradient_Check")
            view.addSubview(checkIcon)
            
            // Creating larger clickable space around check icon
            saveButton.frame = CGRect(x: checkIcon.frame.minX - 0.02*DisplayUtility.screenWidth, y: checkIcon.frame.minY - 0.02*DisplayUtility.screenWidth, width: checkIcon.frame.width + 0.04*DisplayUtility.screenWidth, height: checkIcon.frame.height + 0.04*DisplayUtility.screenWidth)
            saveButton.showsTouchWhenHighlighted = false
            saveButton.addTarget(self, action: #selector(save(_:)), for: .touchUpInside)
            view.addSubview(saveButton)
            
            // Creating greeting label
            greetingLabel.textColor = .gray
            greetingLabel.textAlignment = .center
            greetingLabel.font = UIFont(name: "BentonSans-Light", size: 21)
            if let name = localData.getUsername() {
                let firstName = DisplayUtility.firstName(name: name)
                var greeting = "Hi,"
                if let userGreeting = user["profile_greeting"] as? String {
                    greeting = userGreeting
                }
                greetingLabel.text = "\(greeting) I'm \(firstName)."
                greetingLabel.sizeToFit()
                greetingLabel.frame = CGRect(x: 0, y: 0.1*DisplayUtility.screenHeight, width: greetingLabel.frame.width, height: greetingLabel.frame.height)
                greetingLabel.center.x = DisplayUtility.screenWidth / 2
                view.addSubview(greetingLabel)
            }
            
            // Adding gesture recognizer to greeting label
            
            // Creating editing label
            editingLabel.textColor = .black
            editingLabel.textAlignment = .center
            editingLabel.font = UIFont(name: "BentonSans-Light", size: 12)
            editingLabel.text = "EDITING PROFILE"
            editingLabel.sizeToFit()
            editingLabel.frame = CGRect(x: 0, y: greetingLabel.frame.maxY + 0.0075*DisplayUtility.screenHeight, width: editingLabel.frame.width, height: editingLabel.frame.height)
            editingLabel.center.x = DisplayUtility.screenWidth / 2
            view.addSubview(editingLabel)
        }
    }
    
    func exit(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    func save(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
}
