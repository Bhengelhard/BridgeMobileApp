//
//  LoginViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/14/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

/// The LoginViewController class defines the authentification and loggin process
class LoginViewController: UIViewController {
    
    // MARK: Global Variables
    let accessCode = ""
    
    let layout = LoginLayout()
    let transitionManager = TransitionManager()

    var didSetupConstraints = false
    
    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout.seeMoreButton.addTarget(self, action: #selector(seeMoreButtonTapped(_:)), for: .touchUpInside)
        
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
    /// Segues to PrivacyInformationViewController to show more information about privacy while using the application
    func seeMoreButtonTapped (_ sender: UIButton) {
        self.performSegue(withIdentifier: "showPrivacyPolicy", sender: self)
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination
        let mirror = Mirror(reflecting: vc)
        if mirror.subjectType == PrivacyPolicyViewController.self {
            self.transitionManager.animationDirection = "Top"
        }
        //vc.transitioningDelegate = self.transitionManager

    }

}
