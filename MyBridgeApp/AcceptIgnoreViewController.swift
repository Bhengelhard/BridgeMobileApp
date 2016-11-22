//
//  AcceptIgnoreViewController.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 11/21/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class AcceptIgnoreViewController: UIViewController {
    
    var newMatch: NewMatch?
    let exitButton = UIButton()
    
    func setNewMatch(newMatch: NewMatch) {
        self.newMatch = newMatch
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        exitButton.frame = CGRect(x: 0.0204*DisplayUtility.screenWidth, y: 0.03*DisplayUtility.screenHeight, width: 0.0328*DisplayUtility.screenWidth, height: 0.0206*DisplayUtility.screenHeight)
        exitButton.setTitle("X", for: .normal)
        exitButton.titleLabel?.textColor = .white
        exitButton.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 16)
        exitButton.addTarget(self, action: #selector(dismissVC(_:)), for: .touchUpInside)
        view.addSubview(exitButton)
        let newConnectionLabel = UILabel()
        newConnectionLabel.text = "You have one new connection!"
        newConnectionLabel.textColor = .white
        newConnectionLabel.font = UIFont(name: "BentonSans-Light", size: 23.5)
        newConnectionLabel.sizeToFit()
        newConnectionLabel.frame = CGRect(x: 0.5*DisplayUtility.screenWidth - newConnectionLabel.frame.width/2, y: exitButton.frame.maxY + 0.02*DisplayUtility.screenHeight, width: newConnectionLabel.frame.width, height: newConnectionLabel.frame.height)
        view.addSubview(newConnectionLabel)
        let line = UIView()
        line.frame = CGRect(x: 0.5*DisplayUtility.screenWidth - 0.45*newConnectionLabel.frame.width, y: newConnectionLabel.frame.maxY + 0.03*DisplayUtility.screenHeight, width: 0.9*newConnectionLabel.frame.width, height: 2)
        line.backgroundColor = .white
        view.addSubview(line)
        
        let acceptButton = UIButton()
        acceptButton.frame = CGRect(x: 0.2828*DisplayUtility.screenWidth, y: line.frame.maxY + 0.035*DisplayUtility.screenHeight, width: 0.1823*DisplayUtility.screenWidth, height: 0.0456*DisplayUtility.screenHeight)
        acceptButton.setTitle("accept", for: .normal)
        acceptButton.backgroundColor = .black
        acceptButton.titleLabel?.textColor = .white
        acceptButton.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 18)
        acceptButton.layer.cornerRadius = 0.1*acceptButton.frame.height
        acceptButton.clipsToBounds = true
        
        let shape1 = CAShapeLayer()
        shape1.lineWidth = 2
        shape1.path = UIBezierPath(rect: acceptButton.bounds).cgPath
        shape1.strokeColor = UIColor.black.cgColor
        shape1.fillColor = UIColor.clear.cgColor
        let gradient1 = DisplayUtility.getGradient()
        gradient1.frame = acceptButton.bounds
        gradient1.mask = shape1
        acceptButton.layer.addSublayer(gradient1)
        view.addSubview(acceptButton)
        
        let ignoreButton = UIButton()
        ignoreButton.frame = CGRect(x: 0.527*DisplayUtility.screenWidth, y: acceptButton.frame.minY, width: acceptButton.frame.width, height: acceptButton.frame.height)
        ignoreButton.setTitle("ignore", for: .normal)
        ignoreButton.backgroundColor = .black
        ignoreButton.titleLabel?.textColor = .white
        ignoreButton.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 18)
        ignoreButton.layer.cornerRadius = 0.1*ignoreButton.frame.height
        ignoreButton.clipsToBounds = true
        
        let shape2 = CAShapeLayer()
        shape2.lineWidth = 2
        shape2.path = UIBezierPath(rect: ignoreButton.bounds).cgPath
        shape2.strokeColor = UIColor.black.cgColor
        shape2.fillColor = UIColor.clear.cgColor
        let gradient2 = DisplayUtility.getGradient()
        gradient2.frame = ignoreButton.bounds
        gradient2.mask = shape2
        ignoreButton.layer.addSublayer(gradient2)
        view.addSubview(ignoreButton)
    }
    
    func dismissVC(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
