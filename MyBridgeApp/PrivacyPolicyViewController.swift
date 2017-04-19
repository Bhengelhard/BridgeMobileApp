//
//  PrivacyPolicyViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/17/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit
import MBProgressHUD

/// The LoginViewController class defines the authentification and loggin process
class PrivacyPolicyViewController: UIViewController {
    
    // MARK: Global Variables
    let layout = PrivacyPolicyLayout()
    let transitionManager = TransitionManager()
    
    var userIsNew = false
    
    var didSetupConstraints = false

    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        layout.returnToLoginButton.addTarget(self, action: #selector(returnToLogin(_:)), for: .touchUpInside)
        layout.privacyPolicyButton.addTarget(self, action: #selector(privacyPolicyButtonTapped(_:)), for: .touchUpInside)
        layout.fbLoginButton.addTarget(self, action: #selector(loginWithFB(_:)), for: .touchUpInside)
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
        dismiss(animated: true, completion: nil)
        //self.performSegue(withIdentifier: "showLogin", sender: self)
    }
    /// Open URL with the Privacy Policy
    func privacyPolicyButtonTapped(_ sender: UIButton) {
        present(WebViewController(title: "Privacy Policy", url: "http://www.necter.social/privacypolicy"), animated: true, completion: nil)
    }
    /// Authenticates user through Facebook Login
    func loginWithFB(_ sender: UIButton) {
        //let hud = MBProgressHUD.showAdded(to: view, animated: true)
        //hud.label.text = "Loading..."
        
        let fbLogin = FBLogin()
        fbLogin.initialize(vc: self)
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {        
        if let vc = segue.destination as? MainPageViewController {
            vc.userIsNew = userIsNew
        }
    }

}
