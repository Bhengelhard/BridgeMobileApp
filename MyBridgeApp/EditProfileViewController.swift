//
//  new_EditProfileViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/20/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    // MARK: Global Variables
    let layout = EditProfileLayout()
    let transitionManager = TransitionManager()
    
    var didSetupConstraints = false
    
    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Listener for TableViewCell Tapped
        NotificationCenter.default.addObserver(self, selector: #selector(tableViewCellTapped), name: NSNotification.Name(rawValue: "tableViewCellTapped"), object: nil)
        
        layout.navBar.rightButton.addTarget(self, action: #selector(rightBarButtonTapped(_:)), for: .touchUpInside)
        
        layout.table.setParentVCOfEditProfilePicturesCell(parentVC: self)
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.white
        
        view.setNeedsUpdateConstraints()
        
        let editProfileBackend = EditProfileBackend()
        editProfileBackend.setQuickUpdate(textView: layout.table.aboutMeTextView)
    }
    
    override func updateViewConstraints() {
        didSetupConstraints = layout.initialize(view: view, didSetupConstraints: didSetupConstraints)
        
        super.updateViewConstraints()
    }
    
    // MARK: - Targets
    func rightBarButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableViewCellTapped(_ notification: Notification) {
        print("Table View Cell Tapped responding")
        print(notification.object)
        
        present(SettingsViewController(), animated: true, completion: nil)
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
