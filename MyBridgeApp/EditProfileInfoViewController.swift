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
    
    var didSetupConstraints = false
    
    init(infoTitle: String, value: String) {
        self.layout = EditProfileInfoLayout(infoTitle: infoTitle, value: value)
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
        
        let valueIndexPath = IndexPath(row: 1, section: 0)
        if let valueCell = layout.table.cellForRow(at: valueIndexPath) as? EditProfileInfoObjects.OptionCell {
            let editProfileInfoBackend = EditProfileInfoBackend()
            editProfileInfoBackend.setSelected(title: valueCell.infoTitle, isSelected: valueCell.isSelected)
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
