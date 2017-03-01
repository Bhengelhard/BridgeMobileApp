//
//  new_MyProfileViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/20/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController {

    // MARK: Global Variables
    let layout = MyProfileLayout()
    let transitionManager = TransitionManager()
    
    var didSetupConstraints = false
    
    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout.editProfileButton.addTarget(self, action: #selector(editProfileButtonTapped(_:)), for: .touchUpInside)
        layout.settingsButton.addTarget(self, action: #selector(settingsButtonTapped(_:)), for: .touchUpInside)
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
    
    // MARK: - Targets
    
    // Segue from MyProfileViewController to EditProfileViewController
    func editProfileButtonTapped(_ sender: UIButton) {
        print("editProfileButtonTapped in MyProfileViewController")
        performSegue(withIdentifier: "showEditProfile", sender: self)
    }
    
    func settingsButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showSettings", sender: self)
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
