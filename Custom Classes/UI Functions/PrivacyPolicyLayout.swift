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
    let privacyHeaderLabel = PrivacyPolicyObjects.Label(text: "text")
    let neverPostLabel = PrivacyPolicyObjects.Label(text: "text")
    let introducedByLabel = PrivacyPolicyObjects.Label(text: "text")
    let introductionControlLabel = PrivacyPolicyObjects.Label(text: "text")
    let introducedByControlLabel = PrivacyPolicyObjects.Label(text: "text")
    let privacyPolicyButton = PrivacyPolicyObjects.PrivacyPolicyButton()
    
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
            fbLoginButton.autoPinEdge(.top, to: .bottom, of: returnToLoginButton, withOffset: 35)
            fbLoginButton.autoAlignAxis(.vertical, toSameAxisOf: view)
            
            // Layout the privacyHeaderLabel below the fb LoginButton so the user can log in to the app
            view.addSubview(privacyHeaderLabel)
            privacyHeaderLabel.autoPinEdge(.top, to: .bottom, of: fbLoginButton, withOffset: 35)
            privacyHeaderLabel.autoAlignAxis(.vertical, toSameAxisOf: view)
            
            // Layout the neverPostLabel below the privacy policy label
            view.addSubview(neverPostLabel)
            neverPostLabel.autoPinEdge(.top, to: .bottom, of: privacyHeaderLabel, withOffset: 35)
            neverPostLabel.autoAlignAxis(.vertical, toSameAxisOf: view)
            
            // Layout the introducedByLabel below the neverPostLabel
            view.addSubview(introducedByLabel)
            introducedByLabel.autoPinEdge(.top, to: .bottom, of: neverPostLabel, withOffset: 35)
            introducedByLabel.autoAlignAxis(.vertical, toSameAxisOf: view)
            
            // Layout the introductionControlLabel below the introducedByLabel
            view.addSubview(introductionControlLabel)
            introductionControlLabel.autoPinEdge(.top, to: .bottom, of: introducedByLabel, withOffset: 35)
            introductionControlLabel.autoAlignAxis(.vertical, toSameAxisOf: view)

            // Layout the introducedByControlLabel below the introductionControlLabel
            view.addSubview(introducedByControlLabel)
            introducedByControlLabel.autoPinEdge(.top, to: .bottom, of: introductionControlLabel, withOffset: 35)
            introducedByControlLabel.autoAlignAxis(.vertical, toSameAxisOf: view)
            
            // Layout the privacyPolicyButton below the introducedByControlLabel
            view.addSubview(privacyPolicyButton)
            privacyPolicyButton.autoPinEdge(.top, to: .bottom, of: introducedByControlLabel, withOffset: 35)
            privacyPolicyButton.autoAlignAxis(.vertical, toSameAxisOf: view)

            
        }
        
        return true
    }
    
}
