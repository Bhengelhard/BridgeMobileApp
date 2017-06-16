//
//  LoginViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/14/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit
import Parse
import Foundation
import MBProgressHUD

/// The LoginViewController class defines the authentification and loggin process
class LoginViewController: UIViewController {
    
    // MARK: Global Variables
    let accessCode = ""
    
    let layout = LoginLayout()
    let transitionManager = TransitionManager()

    var didSetupConstraints = false
    
    var userIsNew = false
    
    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout.seeMoreButton.addTarget(self, action: #selector(seeMoreButtonTapped(_:)), for: .touchUpInside)
        layout.fbLoginButton.addTarget(self, action: #selector(loginWithFB(_:)), for: .touchUpInside)
        
        authenticateUser()
        
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
    func seeMoreButtonTapped(_ sender: UIButton) {
//        present(PrivacyPolicyViewController(), animated: true, completion: nil)
        performSegue(withIdentifier: "showPrivacyPolicy", sender: self)
    }
    
    /// Authenticates user through Facebook Login
    func loginWithFB(_ sender: UIButton) {
        //let hud = MBProgressHUD.showAdded(to: view, animated: true)
        //hud.label.text = "Loading..."

        let fbLogin = FBLogin()
        fbLogin.initialize(vc: self)
    }
    
    // MARK: - Backend Functions
    // Update Facebook Friends and Return whether user is SignedIn
    func authenticateUser() {
        //let hud = MBProgressHUD.showAdded(to: view, animated: true)
        //hud.label.text = "Loading..."
        //print("Authentication should display")
        
        //Checking if user is already logged in
        User.fetchCurrent { (user) in
            if let user = user {
                if user.id != nil {
                    // Record Login with Firebase
                    if let id = user.id {
                        AnalyticsLogs.loggedIn(userObjectID: id)
                    }
                    
                    //Updating the user's friends
                    let fbFunctions = FacebookFunctions()
                    fbFunctions.updateFacebookFriends()
                    
                    // Hide Authentication Popup and Segue to SwipeViewController
                    //hud.hide(animated: false)
                    print("Authentication should hide 1")
                    self.performSegue(withIdentifier: "showSwipe", sender: self)
                    
                }
            }
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {        
        if let vc = segue.destination as? MainPageViewController {
            vc.userIsNew = userIsNew
        }
    }

}
