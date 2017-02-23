//
//  ExternalProfileLayout.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/20/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import PureLayout

class ExternalProfileLayout {
    
    // MARK: Global Variables
    let dismissButton = ExternalProfileObjects.DismissButton()
    let reportButton = ExternalProfileObjects.ReportButton()
    let profilePicturesView = ExternalProfileObjects.ProfilePicturesPageViewController()
    let profilePictures = [ExternalProfileObjects.Image()]
    let name = ExternalProfileObjects.Name()
    let factLabel = ExternalProfileObjects.FactLabel()
    let aboutMeLabel = ExternalProfileObjects.AboutMeLabel()
    let reputationButton = ExternalProfileObjects.ReputationButton()
    let messageButton = ExternalProfileObjects.MessageButton()
    
    // MARK: - Layout
    /// Sets the initial layout constraints
    func initialize(view: UIView, didSetupConstraints: Bool) -> Bool {
        
        if (!didSetupConstraints) {
            
            
        }
        
        return true
    }
    
}
