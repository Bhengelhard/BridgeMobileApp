//
//  new_MyProfileViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/20/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class new_MyProfileViewController: UIViewController {

    // MARK: Global Variables
    let layout = MyProfileLayout()
    let transitionManager = TransitionManager()
    
    var didSetupConstraints = false
    
    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
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