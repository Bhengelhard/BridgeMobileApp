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
    let scrollView = UIScrollView.newAutoLayout()
    let contentView = UIView.newAutoLayout()
    let dismissButton = ExternalProfileObjects.DismissButton()
    let reportButton = ExternalProfileObjects.ReportButton()
    let profilePicturesVC = ExternalProfileObjects.ProfilePicturesPageViewController()
    let profilePictures = [ExternalProfileObjects.Image()]
    let name = ExternalProfileObjects.Name()
    let factLabel = ExternalProfileObjects.FactLabel()
    let dividerLine = ExternalProfileObjects.Line()
    let aboutMeLabel = ExternalProfileObjects.AboutMeLabel()
    let messageButton = ExternalProfileObjects.MessageButton()
    
    // MARK: - Layout
    /// Sets the initial layout constraints
    func initialize(view: UIView, didSetupConstraints: Bool) -> Bool {
        if (!didSetupConstraints) {
            
            // Setting the space between objects
            let buffer: CGFloat = 20
            
            // Set scrollView to contain the contents of the view in case they go over the the bottom of the view
            view.addSubview(scrollView)
            scrollView.autoPinEdgesToSuperviewEdges()
            scrollView.autoMatch(.width, to: .width, of: view)
            scrollView.backgroundColor = UIColor.clear
            
            // Set contentView to relate the scrollView to the displayed constraints
            scrollView.addSubview(contentView)
            contentView.autoPinEdgesToSuperviewEdges()
            contentView.autoMatch(.width, to: .width, of: scrollView)
            contentView.backgroundColor = UIColor.clear
            
            // Set the profilePicturesView with the first picture displayed
            scrollView.addSubview(profilePicturesVC.view)
            profilePicturesVC.view.autoPinEdge(toSuperviewEdge: .left)
            profilePicturesVC.view.autoPinEdge(toSuperviewEdge: .top)
            profilePicturesVC.view.autoMatch(.width, to: .width, of: view)
            profilePicturesVC.view.autoMatch(.height, to: .width, of: view)
            
            /// Diameter of the dismissButton and reportButton
            let diameter:CGFloat = 35
            
            // Set the dismissButton to the top left above the profilePicturesView
            scrollView.insertSubview(dismissButton, aboveSubview: profilePicturesVC.view)
            dismissButton.autoPinEdge(toSuperviewEdge: .top, withInset: 2*buffer)
            dismissButton.autoPinEdge(toSuperviewEdge: .right, withInset: buffer)
            dismissButton.autoSetDimensions(to: CGSize(width: diameter, height: diameter))
            dismissButton.layer.cornerRadius = diameter / 2.0
            
//            // Set the reportButton to display in the top right above the profilePicturesView
//            scrollView.insertSubview(reportButton, aboveSubview: profilePicturesVC.view)
//            reportButton.autoAlignAxis(.horizontal, toSameAxisOf: dismissButton)
//            reportButton.autoPinEdge(toSuperviewEdge: .right, withInset: buffer)
//            reportButton.autoSetDimensions(to: CGSize(width: diameter, height: diameter))
//            reportButton.layer.cornerRadius = diameter / 2.0
            
            // Set the pageControl of the profilePicturesPageViewController
            profilePicturesVC.pageControl.autoAlignAxis(.vertical, toSameAxisOf: view)
            profilePicturesVC.pageControl.autoAlignAxis(.horizontal, toSameAxisOf: dismissButton)
            
            // Set the name below the profilePicturesView
            scrollView.addSubview(name)
            name.autoPinEdge(toSuperviewEdge: .left, withInset: buffer)
            name.autoPinEdge(.top, to: .bottom, of: profilePicturesVC.view, withOffset: buffer)
            
            // Set the multi-line factsLabel below the name
            scrollView.addSubview(factLabel)
            factLabel.autoPinEdge(toSuperviewEdge: .left, withInset: buffer)
            factLabel.autoPinEdge(.top, to: .bottom, of: name, withOffset: buffer)
            factLabel.autoMatch(.width, to: .width, of: view, withOffset: 2*buffer)
            
            // Set the divider line below the factsLabel
            scrollView.addSubview(dividerLine)
            dividerLine.autoPinEdge(toSuperviewEdge: .left)
            dividerLine.autoPinEdge(.top, to: .bottom, of: factLabel, withOffset: buffer)
            dividerLine.autoMatch(.width, to: .width, of: view)
            dividerLine.autoSetDimension(.height, toSize: dividerLine.height)
            
            // Set the multi-line aboutMeLabel below the divider line
            scrollView.addSubview(aboutMeLabel)
            aboutMeLabel.autoPinEdge(toSuperviewEdge: .left, withInset: buffer)
            aboutMeLabel.autoPinEdge(.top, to: .bottom, of: dividerLine, withOffset: buffer)
//            aboutMeLabel.autoMatch(.width, to: .width, of: view, withOffset: 2*buffer)
            aboutMeLabel.autoSetDimension(.width, toSize: view.frame.width - 2*buffer)
            
            // Decide whether to display the report button or the edit button (If currentUser profile display edit button and no message button, otherwise display reportButton and message button)
            
            
            // Set the messageButton below the aboutMeLabel
            scrollView.addSubview(messageButton)
            messageButton.autoAlignAxis(.vertical, toSameAxisOf: view)
            messageButton.autoPinEdge(.top, to: .bottom, of: aboutMeLabel, withOffset: buffer)
            messageButton.autoSetDimensions(to: messageButton.size)
            
//            
//            let scrollView2 = UIScrollView.newAutoLayout()
//            view.addSubview(scrollView2)
//            scrollView2.autoPinEdgesToSuperviewEdges()
//            
//            let contentView = UIView.newAutoLayout()
//            
//            scrollView2.addSubview(contentView)
//            contentView.autoPinEdgesToSuperviewEdges()
//            contentView.autoMatch(.width, to: .width, of: view)
//            
//            let subview = UILabel()
//            subview.text = "Text"
//            contentView.addSubview(subview)
//            
//            subview.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
//            subview.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
            
            
        }
        
        return true
    }
    
}
