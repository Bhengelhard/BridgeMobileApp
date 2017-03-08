//
//  ExternalProfileViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/20/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit

class ExternalProfileViewController: UIViewController {

    // MARK: Global Variables
    let layout = ExternalProfileLayout()
    let transitionManager = TransitionManager()
    var userID: String?
    
    var didSetupConstraints = false
    
    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout.dismissButton.addTarget(self, action: #selector(dismissButtonTapped(_:)), for: .touchUpInside)
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
    
    override func viewDidLayoutSubviews() {
        
        // Setting the size of the content within the Scroll View so it will scroll to the specified height
        let contentSize = CGSize(width: layout.scrollView.frame.width, height: layout.messageButton.frame.maxY + 20)
        layout.scrollView.contentSize = contentSize
    }
    
    // MARK: - Targets
    func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Setters
    
    /// set user ID and get user's pictures
    func setUserID(userID: String?) {
        self.userID = userID
        
        if let userID = userID {
            let externalBackend = ExternalBackend()
            externalBackend.setPictures(userID: userID) { (pictures) in
                for i in 0..<pictures.count {
                    let picture = pictures[i]
                    picture.getImage { (image) in
                        self.layout.profilePicturesVC.addImage(image: image)
                    }
                }
            }
        }
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
