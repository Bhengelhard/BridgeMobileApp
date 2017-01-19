//
//  ProfileViewController.swift
//  MyBridgeApp
//
//  Created by Blake H. Engelhard on 7/25/16.
//  Copyright © 2016 BHE Ventures LLC. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource/*, UIImagePickerControllerDelegate, UINavigationControllerDelegate*/ {
    @IBOutlet weak var tableView: UITableView!
    let profilePictureView = UIImageView()
    @IBOutlet weak var name: UILabel!
    let rightBarButton = UIButton()
    var bridgeStatus = UIButton()
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    var editableName:String = ""
    let noNameText = "Click to enter your full name"
    let transitionManager = TransitionManager()
    
    let localData = LocalData()
    
    //This variable allows MissionControlView to display opened after a segue
    var postTapped = false
    
    func rightBarButtonTapped (_ sender: UIBarButtonItem){
        performSegue(withIdentifier: "showBridgeViewFromProfilePage", sender: self)
        rightBarButton.isSelected = true
    }
    func displayNavigationBar(){
        let customNavigationBar = CustomNavigationBar()
        rightBarButton.addTarget(self, action: #selector(rightBarButtonTapped(_:)), for: .touchUpInside)
        customNavigationBar.createCustomNavigationBar(view: view, leftBarButtonIcon: nil, leftBarButtonSelectedIcon: nil, leftBarButton: nil, rightBarButtonIcon: "Right_Arrow", rightBarButtonSelectedIcon: "Right_Arrow", rightBarButton: rightBarButton, title: "Profile")
    }
    
    func displayMessageFromBot(_ notification: Notification) {
        let botNotificationView = UIView()
        botNotificationView.frame = CGRect(x: 0, y: -0.12*self.screenHeight, width: self.screenWidth, height: 0.12*self.screenHeight)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = botNotificationView.bounds
        //blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let messageLabel = UILabel(frame: CGRect(x: 0.05*screenWidth, y: 0.01*screenHeight, width: 0.9*screenWidth, height: 0.11*screenHeight))
        messageLabel.text = (notification as NSNotification).userInfo!["message"] as? String ?? "No Message Came Up"
        messageLabel.textColor = UIColor.darkGray
        messageLabel.font = UIFont(name: "Verdana-Bold", size: 14)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = NSTextAlignment.center
        //botNotificationView.backgroundColor = necterYellow
        
        //botNotificationView.addSubview(blurEffectView)
        botNotificationView.addSubview(messageLabel)
        botNotificationView.insertSubview(blurEffectView, belowSubview: messageLabel)
        view.insertSubview(botNotificationView, aboveSubview: profilePictureView)
        
        
        UIView.animate(withDuration: 0.7, animations: {
            botNotificationView.frame.origin.y = 0
        }) 
        
        let _ = CustomTimer(interval: 4) {i -> Bool in
            UIView.animate(withDuration: 0.7, animations: {
                botNotificationView.frame.origin.y = -0.12*self.screenHeight
            })
            return i < 1
        }

        
        NotificationCenter.default.removeObserver(self)
        //botNotificationView.removeFromSuperview()
        
    }
    //setting background color to off-white blue
    func displayBackgroundView(){
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight))
        backgroundView.backgroundColor = UIColor(red: 234/255, green: 237/255, blue: 239/255, alpha: 1.0)
        view.addSubview(backgroundView)
        view.sendSubview(toBack: backgroundView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*//running getMainAppMetrics
        print("running getMainAppMetrics")
        let pfCloudFunctions = PFCloudFunctions()
        pfCloudFunctions.getMainAppMetrics(parameters: [:])*/
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.displayMessageFromBot), name: NSNotification.Name(rawValue: "displayMessageFromBot"), object: nil)
        
        // Do any additional setup after loading the view.
        //imagePicker.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        displayNavigationBar()
        
        /*
        //setting UI based on iPhone model
        let modelName = UIDevice.currentDevice().modelName
        
        if ["iPhone 4", "iPhone 4s", "iPhone 5", "iPhone 5", "iPhone 5c", "iPhone 5s"].contains(modelName) {
            navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Verdana", size: 16)!]
        } else {
            navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Verdana", size: 18)!]
        }*/
        
        
        let username = localData.getUsername()
        
        if let username = username {
            if username != "" {
                editableName = username
            } else{
                editableName = noNameText
                name.text = noNameText
            }
        }
        else{
            editableName = noNameText
            name.text = noNameText
        }
        
        if let username = username {
            name.text = username
        }
        name.textColor = UIColor.black
        
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
                            self.profilePictureView.image = UIImage(data: data!, scale: 1.0)
                        })
                    }
                })
            }
            
        }
        
        //profilePictureButton.addTarget(self, action: #selector(profilePictureTapped(_:)), forControlEvents: .TouchUpInside)
        
        /*bridgeStatus.setTitle("Post Request", for: UIControlState())
        bridgeStatus.titleLabel!.font = UIFont(name: "Verdana", size: 20)
        bridgeStatus.setTitleColor(DisplayUtility.necterYellow, for: UIControlState.highlighted)
        bridgeStatus.setTitleColor(UIColor.black, for: UIControlState())
        bridgeStatus.layer.cornerRadius = 7.0
        bridgeStatus.layer.borderWidth = 4.0
        bridgeStatus.layer.borderColor = DisplayUtility.necterYellow.cgColor
        bridgeStatus.clipsToBounds = true*/
        
        let bridgeStatusFrame = CGRect(x: 0.275*DisplayUtility.screenWidth, y:0.465*DisplayUtility.screenHeight, width:0.45*DisplayUtility.screenWidth, height:0.06*DisplayUtility.screenHeight)
        bridgeStatus = DisplayUtility.gradientButton(frame: bridgeStatusFrame, text: "Post Request", textColor: UIColor.black, fontSize: 20)
        bridgeStatus.addTarget(self, action: #selector(statusTapped(_:)), for: .touchUpInside)
        bridgeStatus.setTitleColor(UIColor.black, for: .normal)
        
        view.addSubview(bridgeStatus)
        view.addSubview(profilePictureView)
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        tableView.separatorInset = UIEdgeInsets.zero
        //tableView.backgroundColor = UIColor(red: 234/255, green: 237/255, blue: 239/255, alpha: 1.0)
        
        //displayBackgroundView()
        
    }
    func statusTapped(_ sender: UIButton) {
        postTapped = true
        performSegue(withIdentifier: "showBridgeViewFromProfilePage", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        profilePictureView.frame = CGRect(x: 0, y:0.12*screenHeight, width:0.25*screenHeight, height:0.25*screenHeight)
        profilePictureView.center.x = self.view.center.x
        profilePictureView.layer.cornerRadius = profilePictureView.frame.size.width/2
        profilePictureView.contentMode = UIViewContentMode.scaleAspectFill
        profilePictureView.clipsToBounds = true
        name.frame = CGRect(x: 0.1*screenWidth, y:0.38*screenHeight, width:0.8*screenWidth, height:0.05*screenHeight)
        tableView.frame = CGRect(x: 0, y:0.55*screenHeight, width:screenWidth, height:0.435*screenHeight)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let singleMessageVC:SingleMessageViewController = segue.destinationViewController as! SingleMessageViewController
        let vc = segue.destination
        let mirror = Mirror(reflecting: vc)
        if mirror.subjectType == BridgeViewController.self {
            self.transitionManager.animationDirection = "Right"
            let vc2 = vc as! BridgeViewController
            //vc2.postTapped = postTapped
        } else if mirror.subjectType == EditProfileViewController.self {
            self.transitionManager.animationDirection = "Left"
        } else if mirror.subjectType == TermsOfServiceViewController.self {
            self.transitionManager.animationDirection = "Left"
        } else if mirror.subjectType == PrivacyPolicyViewController.self {
            self.transitionManager.animationDirection = "Left"
        }
        vc.transitioningDelegate = self.transitionManager
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return 5
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heightOfEachRow = tableView.frame.height/5.0
        return heightOfEachRow //Choose your custom row height
    }
    
    // Data to be shown on an individual row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if (indexPath as NSIndexPath).row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProfileTableViewCell
            cell.label.text = "Edit Profile"
            
            return cell
            
        } else if (indexPath as NSIndexPath).row == 1 {
            
            /*let cell2 = tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath) as! ProfileTableViewCell2
            //cell2.label.text = "'nect for Business"
            if let interestedInBusiness = PFUser.currentUser()?["interested_in_business"] as? Bool {
                cell2.preferencesSwitch.on = interestedInBusiness
            }
            else {
                cell2.preferencesSwitch.on = true
            }
            cell2.preferencesSwitch.onTintColor = UIColor(red: 39/255, green: 103/255, blue: 143/255, alpha: 1.0)
            cell2.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell2.label.text = "connect for business"
            cell2.label.font = UIFont(name: "BentonSans", size: 18)
            
            return cell2
             */
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProfileTableViewCell
            cell.label.text = "Give Feedback"
            
            return cell
            
        } /*else if indexPath.row == 2 {
            
            let cell2 = tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath) as! ProfileTableViewCell2
            if let interestedInLove = PFUser.currentUser()?["interested_in_love"] as? Bool {
                cell2.preferencesSwitch.on = interestedInLove
            }
            else {
                cell2.preferencesSwitch.on = true
            }
            cell2.preferencesSwitch.onTintColor = UIColor.init(red: 227/255, green: 70/255, blue: 73/255, alpha: 1.0)
            cell2.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell2.label.text = "connect for love"
            cell2.label.font = UIFont(name: "BentonSans", size: 18)
            
            return cell2
            
        } else if indexPath.row == 3 {
            
            let cell2 = tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath) as! ProfileTableViewCell2
            if let interestedInFriendship = PFUser.currentUser()?["interested_in_friendship"] as? Bool {
                cell2.preferencesSwitch.on = interestedInFriendship
            }
            else {
                cell2.preferencesSwitch.on = true
            }

            cell2.preferencesSwitch.onTintColor = UIColor(red: 96/255, green: 182/255, blue: 163/255, alpha: 1.0)
            cell2.selectionStyle = UITableViewCellSelectionStyle.None
            
            //setting multi-font label
            //let string = "connect for friendship" as NSString
            //let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSFontAttributeName: UIFont.init(name: "BentonSans", size: 18)!])
            //let necterFontAttribute = [NSFontAttributeName: UIFont.init(name: "Verdana", size: 18) as! AnyObject]
            // Part of string to be necter font
            //attributedString.addAttributes(necterFontAttribute, range: string.rangeOfString("nect"))
            cell2.label.text = "connect for friendship"
            cell2.label.font = UIFont(name: "BentonSans", size: 18)
            
            return cell2
            
        }*/ else if (indexPath as NSIndexPath).row == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProfileTableViewCell
            cell.label.text = "Terms of Service"
            //cell.label.textColor = UIColor.grayColor()
            
            return cell
            
        } else if (indexPath as NSIndexPath).row == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProfileTableViewCell
            cell.label.text = "Privacy Policy"
            //cell.label.textColor = UIColor.grayColor()
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProfileTableViewCell
            cell.label.text = "Log Out"
            //cell.label.textColor = UIColor.grayColor()
            
            return cell
            
        }
        
    }
    // A row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).row == 0 {
            performSegue(withIdentifier: "showEditProfileViewFromProfilePage", sender: self)
        } else if (indexPath as NSIndexPath).row == 1 {
            
            //opens user's email application with email ready to be sent to necter email -> commented out and replaced with link to survey
            let subject = "Providing%20Feedback%20for%20the%20necter%20Team"
            let encodedParams = "subject=\(subject)"
            let email = "blake@necter.social"
            let url = NSURL(string: "mailto:\(email)?\(encodedParams)")
            //let surveyURL = "https://upenn.co1.qualtrics.com/SE/?SID=SV_9Lj1NBkAbagCcwR"
            //let url = URL(string: "https://upenn.co1.qualtrics.com/SE/?SID=SV_9Lj1NBkAbagCcwR")
            
            if UIApplication.shared.canOpenURL(url! as URL) {
                
                UIApplication.shared.openURL(url! as URL)
                
            }
            
            tableView.deselectRow(at: indexPath, animated: true)

        } else if (indexPath as NSIndexPath).row == 2 {
            
            let url = URL(string: "https://necter.social/termsofservice")
            
            if UIApplication.shared.canOpenURL(url!) {
                
                UIApplication.shared.openURL(url!)
                
            }
            
            //performSegueWithIdentifier("showTermsofService", sender: self)
            
        } else if (indexPath as NSIndexPath).row == 3 {
            
            let url = URL(string: "https://necter.social/privacypolicy")
            
            if UIApplication.shared.canOpenURL(url!) {
                
                UIApplication.shared.openURL(url!)
                
            }
            
            //performSegueWithIdentifier("showPrivacyPolicy", sender: self)
            
        } else {
            
            PFUser.logOut()
            performSegue(withIdentifier: "showAccessViewController", sender: self)
            
        }
        
    }

}
