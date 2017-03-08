//
//  PrivacyPolicyLayout.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/17/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import PureLayout

class PrivacyPolicyLayout {
    
    // MARK: Global Variables
    let returnToLoginButton = PrivacyPolicyObjects.ReturnToLoginButton()
    let fbLoginButton = PrivacyPolicyObjects.FBLoginButton()
    let privacyHeaderLabel = PrivacyPolicyObjects.Header()
    let neverPostLabel: PrivacyPolicyObjects.Label
    let introducedByLabel: PrivacyPolicyObjects.Label
    let introductionControlLabel: PrivacyPolicyObjects.Label
    let introducedByControlLabel: PrivacyPolicyObjects.Label
    let privacyPolicyButton = PrivacyPolicyObjects.PrivacyPolicyButton()
    
    init() {
        let neverPostText = "We never post to Facebook."
        neverPostLabel = PrivacyPolicyObjects.Label(text: neverPostText)
        
        let introducedText = "You will only be introduced to other users by people you are already friends with."
        introducedByLabel = PrivacyPolicyObjects.Label(text: introducedText)
        
        let introductionControlText = "You have control over the users you can introduce."
        introductionControlLabel = PrivacyPolicyObjects.Label(text: introductionControlText)
        
        let introducedByControlText = "You have control over the users who can introduce you."
        introducedByControlLabel = PrivacyPolicyObjects.Label(text: introducedByControlText)
        
    }
    
    // MARK: - Layout
    /// Sets the initial layout constraints
    func initialize(view: UIView, didSetupConstraints: Bool) -> Bool {
        
        if (!didSetupConstraints) {
            
            // Layout the returnToLoginButton at the top of the view so the user can segue back to Login
            view.addSubview(returnToLoginButton)
            returnToLoginButton.autoPinEdge(toSuperviewEdge: .top, withInset: 35)
            returnToLoginButton.autoAlignAxis(.vertical, toSameAxisOf: view)
            
            // Layout the fbLoginButton below the returnToLoginButton so the user can log in to the app
            view.addSubview(fbLoginButton)
            fbLoginButton.autoSetDimensions(to: CGSize(width: 250, height: 42.5))
            fbLoginButton.autoPinEdge(.top, to: .bottom, of: returnToLoginButton, withOffset: 35)
            fbLoginButton.autoAlignAxis(.vertical, toSameAxisOf: view)
            
            // Layout the privacyHeaderLabel below the fb LoginButton so the user can log in to the app
            view.addSubview(privacyHeaderLabel)
            privacyHeaderLabel.autoPinEdge(.top, to: .bottom, of: fbLoginButton, withOffset: 35)
            privacyHeaderLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            privacyHeaderLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
            
            // Layout the neverPostLabel below the privacy policy label
            view.addSubview(neverPostLabel)
            neverPostLabel.autoPinEdge(.top, to: .bottom, of: privacyHeaderLabel, withOffset: 35)
            neverPostLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            neverPostLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
            
            // Layout the introducedByLabel below the neverPostLabel
            view.addSubview(introducedByLabel)
            introducedByLabel.autoPinEdge(.top, to: .bottom, of: neverPostLabel, withOffset: 35)
            introducedByLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            introducedByLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
            
            // Layout the introductionControlLabel below the introducedByLabel
            view.addSubview(introductionControlLabel)
            introductionControlLabel.autoPinEdge(.top, to: .bottom, of: introducedByLabel, withOffset: 35)
            introductionControlLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            introductionControlLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 20)

            // Layout the introducedByControlLabel below the introductionControlLabel
            view.addSubview(introducedByControlLabel)
            introducedByControlLabel.autoPinEdge(.top, to: .bottom, of: introductionControlLabel, withOffset: 35)
            introducedByControlLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            introducedByControlLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
            
            // Layout the privacyPolicyButton below the introducedByControlLabel
            view.addSubview(privacyPolicyButton)
            privacyPolicyButton.autoPinEdge(.top, to: .bottom, of: introducedByControlLabel, withOffset: 35)
            privacyPolicyButton.autoAlignAxis(.vertical, toSameAxisOf: view)
            
        }
        
        return true
    }
    
}
