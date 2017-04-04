//
//  new_MyProfileViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/20/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit
import MBProgressHUD

class MyProfileViewController: UIViewController {

    // MARK: Global Variables
    let layout = MyProfileLayout()
    let transitionManager = TransitionManager()
    let messageComposer = MessageComposer()
    
    var didSetupConstraints = false
    
    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Adding Targets and GestureRecognizers
        layout.editProfileButton.addTarget(self, action: #selector(editProfileButtonTapped(_:)), for: .touchUpInside)
        layout.settingsButton.addTarget(self, action: #selector(settingsButtonTapped(_:)), for: .touchUpInside)
        layout.profilePicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profilePictureTapped(_:))))
        
        layout.inviteButton.setVC(vc: self)
        
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
    
    // MARK: - Targets and GestureRecognizers
    
    // Present EditProfileViewController
    func editProfileButtonTapped(_ sender: UIButton) {
        let editProfileVC = EditProfileViewController()
        editProfileVC.myProfileVC = self
        present(editProfileVC, animated: true, completion: nil)
    }
    
    // Present SettingsViewController
    func settingsButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showSettings", sender: self)
        //present(SettingsViewController(), animated: true, completion: nil)
    }
    
    // Present ExternalUserViewController
    func profilePictureTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        User.getCurrent { (user) in
            let externalProfileVC = ExternalProfileViewController()
            externalProfileVC.setUserID(userID: user.id)
            externalProfileVC.hideMessageButton()
            self.present(externalProfileVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination
        let mirror = Mirror(reflecting: vc)
        if mirror.subjectType == SettingsViewController.self {
            self.transitionManager.animationDirection = "top"
        }
        //vc.transitioningDelegate = self.transitionManager
    }

}
