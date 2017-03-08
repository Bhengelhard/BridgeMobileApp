//
//  SettingsViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/21/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController {

    // MARK: Global Variables
    let layout = SettingsLayout()
    let transitionManager = TransitionManager()
    
    var didSetupConstraints = false
    
    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout.navBar.rightButton.addTarget(self, action: #selector(rightBarButtonTapped(_:)), for: .touchUpInside)
        
        //Listener for Logout Tapped
        NotificationCenter.default.addObserver(self, selector: #selector(logoutTapped(_:)), name: NSNotification.Name(rawValue: "logoutTapped"), object: nil)
        //Listener for Privacy Button Tapped
        NotificationCenter.default.addObserver(self, selector: #selector(privacyButtonTapped(_:)), name: NSNotification.Name(rawValue: "privacyButtonTapped"), object: nil)
        //Listener for Terms Button Tapped
        NotificationCenter.default.addObserver(self, selector: #selector(termsOfServiceButtonTapped(_:)), name: NSNotification.Name(rawValue: "termsOfServiceButtonTapped"), object: nil)
        
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
    func rightBarButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func logoutTapped(_ notification: Notification) {
        PFUser.logOut()
        performSegue(withIdentifier: "showLogin", sender: self)
    }
    
    func privacyButtonTapped(_ notification: Notification) {
        present(WebViewController(title: "Privacy Policy", url: "http://www.necter.social/privacypolicy"), animated: true, completion: nil)
    }
    
    func termsOfServiceButtonTapped(_ notification: Notification) {
        present(WebViewController(title: "Terms of Service", url: "http://www.necter.social/termsofservice"), animated: true, completion: nil)
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
