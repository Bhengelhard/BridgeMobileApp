//
//  EditProfileViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/20/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit
import MBProgressHUD

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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        layout.navBar.rightButton.addTarget(self, action: #selector(rightBarButtonTapped(_:)), for: .touchUpInside)
        layout.table.backgroundColor = Constants.Colors.necter.backgroundGray
        layout.table.setParentVCOfEditProfilePicturesCell(parentVC: self)
        
        for fieldTableCell in [layout.table.ageTableCell, layout.table.cityTableCell, layout.table.workTableCell, layout.table.schoolTableCell, layout.table.genderTableCell, layout.table.relationshipStatusTableCell] {
            if let textLabel = fieldTableCell.textLabel {
                editProfileBackend.setFieldLabel(field: fieldTableCell.field, label: textLabel)
            }
            let editInfoGR = UITapGestureRecognizer(target: self, action: #selector(editInfo(_:)))
            fieldTableCell.addGestureRecognizer(editInfoGR)
        }
        
        // gesture recognizer to remove keyboard upon tap
        let removeKeyboardGR = UITapGestureRecognizer(target: self, action: #selector(removeKeyboard(_:)))
        removeKeyboardGR.cancelsTouchesInView = false
        view.addGestureRecognizer(removeKeyboardGR)
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
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.label.text = "Saving..."
        if let myProfileVC = myProfileVC {
            if let image = layout.table.editProfilePicturesCell.pictureBoxes[0].image {
                myProfileVC.layout.profilePicture.setBackgroundImage(image: image)
            }
        }
        User.getCurrent { (user) in
            self.layout.table.editProfilePicturesCell.setPicturesToUser(user: user) {
                user.aboutMe = self.layout.table.aboutMeTableCell.textView.text
                user.lookingFor = self.layout.table.lookingForTableCell.textView.text
                user.save { (_) in
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func editInfo(_ gesture: UIGestureRecognizer) {
        if let view = gesture.view {
            if let fieldTableCell = view as? EditProfileObjects.WhiteFieldTableCell {
                let editProfileInfoVC = EditProfileInfoViewController(fieldTableCell: fieldTableCell)
                present(editProfileInfoVC, animated: true, completion: nil)
            }
        }
    }
    
    func removeKeyboard(_ gesture: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    // scroll scroll view when keyboard shows
    func keyboardWillShow(_ notification:NSNotification) {
        if let userInfo = notification.userInfo {
            // get keyboard frame
            var keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            keyboardFrame = view.convert(keyboardFrame, from: nil)
            
            // update content inset of scroll view
            layout.table.contentInset.bottom = keyboardFrame.height
            
            // update content offset of scroll view
            layout.table.contentOffset.y += keyboardFrame.height
        }
    }
    
    // scroll scroll view when keyboard hides
    func keyboardWillHide(_ notification:NSNotification){
        if let userInfo = notification.userInfo {
            // get keyboard frame
            var keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            keyboardFrame = view.convert(keyboardFrame, from: nil)
            
            // reset content offset of scroll view
            layout.table.contentOffset.y -= keyboardFrame.height
            
            // reset content inset of scroll view
            layout.table.contentInset = UIEdgeInsets.zero
        }
    }
}
