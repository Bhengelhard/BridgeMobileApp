//
//  MyProfileViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 12/9/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController {
    
    var rightBarButton = UIButton()
    let transitionManager = TransitionManager()
    let customNavigationBar = CustomNavigationBar()
    let localData = LocalData()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        displayNavigationBar()
        displayProfilePictures()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Displaying the profile pictures view on the profile
    func displayProfilePictures() {
        let profilePicture1 = UIImageView()
        profilePicture1.frame = CGRect(x: 0, y: customNavigationBar.frame.maxY, width: DisplayUtility.screenWidth, height: 0.5622*DisplayUtility.screenHeight)
        if let data = localData.getMainProfilePicture() {
            profilePicture1.image = UIImage(data: data)
        } else {
            //set image for when the user has not yet set their profile picture
        }
        
        view.addSubview(profilePicture1)
        
    }
    func displayNavigationBar(){
        rightBarButton.addTarget(self, action: #selector(rightBarButtonTapped(_:)), for: .touchUpInside)
        customNavigationBar.createCustomNavigationBar(view: view, leftBarButtonIcon: nil, leftBarButtonSelectedIcon: nil, leftBarButton: nil, rightBarButtonIcon: "Right_Arrow", rightBarButtonSelectedIcon: "Right_Arrow", rightBarButton: rightBarButton, title: "Profile")
    }
    
    func rightBarButtonTapped(_ sender: UIButton) {
        //let bridgeVC = BridgeViewController()
        //self.present(bridgeVC, animated: true, completion: nil)
        performSegue(withIdentifier: "showBridgePageFromMyProfile", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination
        let mirror = Mirror(reflecting: vc)
        if mirror.subjectType == BridgeViewController.self {
            transitionManager.animationDirection = "Right"
        }
        vc.transitioningDelegate = transitionManager
    }
        
}
