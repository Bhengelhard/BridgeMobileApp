//
//  EditProfileInfoViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 3/10/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class EditProfileInfoViewController: UIViewController {

    // MARK: Global Variables
    let layout: EditProfileInfoLayout
    let transitionManager = TransitionManager()
    let editProfileInfoBackend = EditProfileInfoBackend()
    let field: UserInfoField
    
    var didSetupConstraints = false
    
    init(field: UserInfoField) {
        self.field = field
        layout = EditProfileInfoLayout(field: field)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add targets
        layout.navBar.rightButton.addTarget(self, action: #selector(rightBarButtonTapped(_:)), for: .touchUpInside)
        
        if let textLabel = layout.table.valueCell.textLabel {
            editProfileInfoBackend.setFieldValueLabel(field: field, label: textLabel) { (fieldValueExists) in
                if fieldValueExists {
                    self.layout.table.value = textLabel.text
                    print(textLabel.text)
                    self.layout.table.reloadData()
                }
            }
        }
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
        
        if let value = layout.table.value {
            editProfileInfoBackend.setSelected(title: value, isSelected: layout.table.valueCell.isSelected)
        }
        
        dismiss(animated: true, completion: nil)
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
