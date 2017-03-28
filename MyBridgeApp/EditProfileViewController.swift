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
    var myProfileVC: MyProfileViewController?
    let editProfileBackend = EditProfileBackend()
    
    var didSetupConstraints = false
    
    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout.table.backgroundColor = Constants.Colors.necter.backgroundGray
        
        //Listener for TableViewCell Tapped
        //NotificationCenter.default.addObserver(self, selector: #selector(tableViewCellTapped), name: NSNotification.Name(rawValue: "tableViewCellTapped"), object: nil)
        
        layout.navBar.rightButton.addTarget(self, action: #selector(rightBarButtonTapped(_:)), for: .touchUpInside)
        layout.table.setParentVCOfEditProfilePicturesCell(parentVC: self)
        
        for fieldTableCell in [layout.table.ageTableCell, layout.table.cityTableCell, layout.table.workTableCell, layout.table.schoolTableCell, layout.table.genderTableCell, layout.table.relationshipStatusTableCell] {
            if let textLabel = fieldTableCell.textLabel {
                editProfileBackend.setFieldLabel(field: fieldTableCell.field, label: textLabel)
            }
            let editInfoGR = UITapGestureRecognizer(target: self, action: #selector(editInfo(_:)))
            fieldTableCell.addGestureRecognizer(editInfoGR)
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
        if let myProfileVC = myProfileVC {
            if let image = layout.table.editProfilePicturesCell.pictureBoxes[0].image {
                myProfileVC.layout.profilePicture.setBackgroundImage(image: image)
            }
        }
        layout.table.editProfilePicturesCell.savePictures()
        dismiss(animated: true, completion: nil)
    }
    
    func editInfo(_ gesture: UITapGestureRecognizer) {
        if let view = gesture.view {
            if let fieldTableCell = view as? EditProfileObjects.WhiteFieldTableCell {
                let editProfileInfoVC = EditProfileInfoViewController(field: fieldTableCell.field)
                present(editProfileInfoVC, animated: true, completion: nil)
            }
        }
    }
    
    /*
    func tableViewCellTapped(_ notification: Notification) {
        print("Table View Cell Tapped responding")
        
        if let cellObject = notification.object as? [String] {
            let infoTitle = cellObject[0]
            let value = cellObject[1]
            let editProfileInfoVC = EditProfileInfoViewController(infoTitle: infoTitle, value: value)
    
            present(editProfileInfoVC, animated: true, completion: nil)
        }
        
    }*/
    
    
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
