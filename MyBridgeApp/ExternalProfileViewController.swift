//
//  ExternalProfileViewController.swift
//  MyBridgeApp
//
//  Created by Blake H. Engelhard on 9/7/16.
//  Copyright © 2016 BHE Ventures LLC. All rights reserved.
//

import UIKit
import Parse

class ExternalProfileViewController: UIViewController {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let localData = LocalData()
    
    var singleMessageTitle = "Conversation"
    var necterTypeColor = UIColor()
    var seguedFrom = ""
    
    let transitionManager = TransitionManager()
    

    func displayProfilePicture() {
        let profilePictureView = UIImageView()
        profilePictureView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
        //get profile picture and set to a button
        let mainProfilePicture = localData.getMainProfilePicture()
        if let mainProfilePicture = mainProfilePicture {
            let image = UIImage(data: mainProfilePicture as Data, scale: 1.0)
            //profilePictureButton.setImage(image, forState: .Normal)
            profilePictureView.image = image
        }  else {
            let pfData = PFUser.current()?["profile_picture"] as? PFFile
            if let pfData = pfData {
                pfData.getDataInBackground(block: { (data, error) in
                    if error != nil || data == nil {
                        print(error!)
                    } else {
                        DispatchQueue.main.async(execute: {
                            //self.profilePictureButton.setImage(UIImage(data: data!, scale: 1.0), forState:  .Normal)
                            profilePictureView.image = UIImage(data: data!, scale: 1.0)
                        })
                    }
                })
            }
            
        }
        
        profilePictureView.contentMode = UIViewContentMode.scaleAspectFit
        profilePictureView.clipsToBounds = true
        
        view.addSubview(profilePictureView)
    }
    
    func displayUserInfo() {
        let username = localData.getUsername()
        let usernameLabel = UILabel()
        usernameLabel.frame = CGRect(x: 0, y: 0, width: 0.5*screenWidth, height: 0.1*screenHeight)
        
        if let username = username {
            usernameLabel.text = username
        }
        
        view.addSubview(usernameLabel)
        
    }
    
    // Tapped anywhere else on the main view. Textfield should be replaced by label
    func tappedOutside(){
        if let _ = view.gestureRecognizers {
            for gesture in view.gestureRecognizers! {
                view.removeGestureRecognizer(gesture)
            }
        }
        performSegue(withIdentifier: "showSingleMessageFromExternalProfile", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //adding a black background
        let backgroundView = UIImageView()
        backgroundView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        backgroundView.backgroundColor = UIColor.black
        view.addSubview(backgroundView)

        displayProfilePicture()
        displayUserInfo()
        
        let outSelector : Selector = #selector(ExternalProfileViewController.tappedOutside)
        let outsideTapGesture = UITapGestureRecognizer(target: self, action: outSelector)
        outsideTapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(outsideTapGesture)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Update the fact that you have viewed the message Thread when you segue
        // Segue is not the best place to put this. If you are about to close the view this should get called
        NotificationCenter.default.removeObserver(self)
        let vc = segue.destination
        let mirror = Mirror(reflecting: vc)
        if mirror.subjectType == SingleMessageViewController.self {
            let vc2 = vc as! SingleMessageViewController
            vc2.singleMessageTitle = singleMessageTitle
            vc2.necterTypeColor = necterTypeColor
            vc2.seguedFrom = seguedFrom
            self.transitionManager.animationDirection = "Top"
        }
        vc.transitioningDelegate = self.transitionManager
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
