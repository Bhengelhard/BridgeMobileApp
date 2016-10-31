//
//  PrivacyPolicyViewController.swift
//  MyBridgeApp
//
//  Created by Blake H. Engelhard on 8/29/16.
//  Copyright © 2016 BHE Ventures LLC. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {

    let transitionManager = TransitionManager()
    
    let navigationBar = UINavigationBar()
    let backButton = UIButton()
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    //necter Colors
    let necterYellow = UIColor(red: 255/255, green: 230/255, blue: 57/255, alpha: 1.0)
    let businessBlue = UIColor(red: 36.0/255, green: 123.0/255, blue: 160.0/255, alpha: 1.0)
    let loveRed = UIColor(red: 242.0/255, green: 95.0/255, blue: 92.0/255, alpha: 1.0)
    let friendshipGreen = UIColor(red: 112.0/255, green: 193.0/255, blue: 179.0/255, alpha: 1.0)
    let necterGray = UIColor(red: 80.0/255.0, green: 81.0/255.0, blue: 79.0/255.0, alpha: 1.0)

    
    func displayNavigationBar(){
        
        let navItem = UINavigationItem()
        
        //cancel edit bar buton item
        backButton.setTitle(">", for: UIControlState())
        backButton.setTitleColor(necterGray, for: UIControlState())
        backButton.setTitleColor(necterYellow, for: .selected)
        backButton.setTitleColor(necterYellow, for: .highlighted)
        backButton.titleLabel!.font = UIFont(name: "Verdana-Bold", size: 24)!
        //leaveConversation.setImage(UIImage(named: "Profile_Icon_Yellow"), forState: .Selected)
        //leaveConversation.setImage(UIImage(named: "Profile_Icon_Yellow"), forState: .Highlighted)
        backButton.addTarget(self, action: #selector(backTapped(_:)), for: .touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 0.2*screenWidth, height: 0.06*screenHeight)
        let rightBarButtonItem = UIBarButtonItem(customView: backButton)
        navItem.rightBarButtonItem = rightBarButtonItem
        
        
        //setting the navBar color and title
        navigationBar.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 0.11*screenHeight)
        navigationBar.setItems([navItem], animated: false)
        navigationBar.topItem?.title = "Privacy Policy"
        navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Verdana", size: 24)!, NSForegroundColorAttributeName: necterYellow]
        navigationBar.barStyle = .black
        navigationBar.barTintColor = UIColor.white
        self.view.addSubview(navigationBar)
        
    }
    
    
    
    
    func backTapped (_ sender: UIButton) {
        backButton.isSelected = true
        performSegue(withIdentifier: "showProfilePageFromPrivacyPolicy", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayNavigationBar()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let singleMessageVC:SingleMessageViewController = segue.destinationViewController as! SingleMessageViewController
        let vc = segue.destination
        let mirror = Mirror(reflecting: vc)
        if mirror.subjectType == ProfileViewController.self {
            self.transitionManager.animationDirection = "Right"
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
