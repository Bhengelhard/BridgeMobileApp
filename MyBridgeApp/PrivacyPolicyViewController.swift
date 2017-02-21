//
//  PrivacyPolicyViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/17/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit

/// The LoginViewController class defines the authentification and loggin process
class PrivacyPolicyViewController: UIViewController {
    
    // MARK: Global Variables
    let layout = PrivacyPolicyLayout()
    let transitionManager = TransitionManager()
    
    var didSetupConstraints = false

    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        layout.returnToLoginButton.addTarget(self, action: #selector(returnToLogin(_:)), for: .touchUpInside)
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
    /// Segues to Login
    func returnToLogin(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showLogin", sender: self)
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination
        let mirror = Mirror(reflecting: vc)
        if mirror.subjectType == LoginViewController.self {
            self.transitionManager.animationDirection = "Bottom"
        }
        //vc.transitioningDelegate = self.transitionManager
    }

}
