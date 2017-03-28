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
    let fieldTableCell: EditProfileObjects.WhiteFieldTableCell
    
    var didSetupConstraints = false
    
    init(fieldTableCell: EditProfileObjects.WhiteFieldTableCell) {
        self.fieldTableCell = fieldTableCell
        field = fieldTableCell.field
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
                    self.layout.table.reloadData()
                }
            }
            
            editProfileInfoBackend.shouldDisplay(field: field) { (shouldDisplay) in
                self.layout.table.shouldDisplay = shouldDisplay
                self.layout.table.reloadData()
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
        
        if layout.table.shouldDisplay {
            fieldTableCell.textLabel?.text = layout.table.valueCell.textLabel?.text
        } else {
            fieldTableCell.textLabel?.text = "Add \(field.rawValue)"
        }
        
        editProfileInfoBackend.setAndSaveShouldDisplay(field: field, shouldDisplay: layout.table.shouldDisplay) {
            self.dismiss(animated: true, completion: nil)
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
