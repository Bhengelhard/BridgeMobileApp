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
        
        // Adding Targets
        layout.editProfileButton.addTarget(self, action: #selector(editProfileButtonTapped(_:)), for: .touchUpInside)
        layout.settingsButton.addTarget(self, action: #selector(settingsButtonTapped(_:)), for: .touchUpInside)
        layout.profilePicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profilePictureTapped(_:))))

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
    
    // Present EditProfileViewController
    func editProfileButtonTapped(_ sender: UIButton) {
        present(EditProfileViewController(), animated: true, completion: nil)
    }
    
    // Present SettingsViewController
    func settingsButtonTapped(_ sender: UIButton) {
        present(SettingsViewController(), animated: true, completion: nil)
    }
    
    // Present ExternalUserViewController
    func profilePictureTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        present(ExternalProfileViewController(), animated: true, completion: nil)
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
