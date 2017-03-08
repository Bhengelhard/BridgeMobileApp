//
//  AccessBackgroundView.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/14/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import PureLayout

///  The LoginLayout class handles AutoLayout and object initialization for the LoginViewController
class LoginLayout {
    
    // MARK: Global Variables
    let fbLoginButton = LoginObjects.FBLoginButton()
    let loginInformationLabel = LoginObjects.LoginInformationLabel()
    let seeMoreButton = LoginObjects.SeeMoreButton()
    let tutorialsPageViewController = LoginObjects.TutorialsPageViewController()
    let transgradientView = LoginObjects.TransgradientView()
    
    // MARK: Layout Objects
    /// Sets the initial layout constraints
    func initialize(view: UIView, didSetupConstraints: Bool) -> Bool {
        
        if (!didSetupConstraints) {
            
            var tutorialsView = UIView()
            
            if let tView = tutorialsPageViewController.view {
                tutorialsView = tView
            }
            
            //Layout the tutorialsViewPageController at the top of the view so the user can swipe through the tutorial pages
            view.addSubview(tutorialsView)
            tutorialsView.autoPinEdge(toSuperviewEdge: .top)
            tutorialsView.autoPinEdge(toSuperviewEdge: .left)
            tutorialsView.autoMatch(.width, to: .width, of: view)
            
            // Set the pageControl of the tutorialsViewPageController
            tutorialsPageViewController.pageControl.autoAlignAxis(.vertical, toSameAxisOf: view)
            tutorialsPageViewController.pageControl.autoPinEdge(.bottom, to: .bottom, of: tutorialsView)

            // Layout the fbLoginButton below the tutorialsViewController to the bottom with 80pt inset and dimensions of 300x40
            view.addSubview(fbLoginButton)
            fbLoginButton.autoSetDimensions(to: CGSize(width: 250, height: 42.5))
            fbLoginButton.autoAlignAxis(toSuperviewAxis: .vertical)
            fbLoginButton.autoPinEdge(.top, to: .bottom, of: tutorialsView, withOffset: 35)
            
            // Layout Objects Pinned to the Bottom
            // Layout the loginInformation Label just above the seeMoreButton to tell the user about necter's facebook posting policy and terms of service
            view.addSubview(loginInformationLabel)
            loginInformationLabel.autoAlignAxis(.vertical, toSameAxisOf: view)
            loginInformationLabel.autoMatch(.width, to: .width, of: view)
            loginInformationLabel.autoSetDimension(.height, toSize: 63.7/2)
            loginInformationLabel.autoPinEdge(.top, to: .bottom, of: fbLoginButton, withOffset: 35)
            
            // Layout the seemMoreButton pinned just above the bottom of the ViewController
            view.addSubview(seeMoreButton)
            //seeMoreButton.autoSetDimensions(to: CGSize(width: 28, height: 9))
            seeMoreButton.autoAlignAxis(.vertical, toSameAxisOf: view)
            seeMoreButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 20)
            seeMoreButton.autoPinEdge(.top, to: .bottom, of: loginInformationLabel, withOffset: 10)
            
            // Layout the transgradientView be pinned just above the bottom of the ViewController
            view.insertSubview(transgradientView, belowSubview: fbLoginButton)
            transgradientView.autoPinEdge(toSuperviewEdge: .left)
            transgradientView.autoPinEdge(toSuperviewEdge: .right)
            transgradientView.autoPinEdge(toSuperviewEdge: .bottom)
            
            // MARK: Add Targets
            fbLoginButton.addTarget(self, action: #selector(fbLoginButtonTapped(_:)), for: .touchUpInside)
           
            
        }
        
        return true
    }
    
    @objc func fbLoginButtonTapped(_ sender: UIButton) {
        
    }
    
}





