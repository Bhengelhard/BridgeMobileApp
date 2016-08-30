//
//  ProfileViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 7/25/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource/*, UIImagePickerControllerDelegate, UINavigationControllerDelegate*/ {
    @IBOutlet weak var tableView: UITableView!
    let profilePictureView = UIImageView()
    @IBOutlet weak var name: UILabel!
    let navigationBar = UINavigationBar()
    let necterButton = UIButton()
    let bridgeStatus = UIButton()
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    var editableName:String = ""
    let noNameText = "Click to enter your full name"
    let transitionManager = TransitionManager()
    
    let localData = LocalData()
    
    let necterYellow = UIColor(red: 255/255, green: 230/255, blue: 57/255, alpha: 1.0)
    
    /*// globally required as we do not want to re-create them everytime and for persistence
    let imagePicker = UIImagePickerController()
    
    func profilePictureTapped(sender: UIButton) {
    
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let facebookProfilePictureAction = UIAlertAction(title: "Facebook Profile Picture", style: UIAlertActionStyle.Default)
        {
            UIAlertAction in
            self.getMainProfilePictureFromFacebook()
        }
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        //self.picker.delegate = self
        alert.addAction(facebookProfilePictureAction)
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
        imagePicker.allowsEditing = false
    
    }
    
    //saves  to LocalDataStorage & Parse
    func getMainProfilePictureFromFacebook(){
        var pagingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        pagingSpinner.color = UIColor.darkGrayColor()
        pagingSpinner.hidesWhenStopped = true
        pagingSpinner.center.x = profilePictureButton.center.x
        pagingSpinner.center.y = profilePictureButton.center.y
        view.addSubview(pagingSpinner)
        pagingSpinner.startAnimating()
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name"])
        graphRequest.startWithCompletionHandler{ (connection, result, error) -> Void in
            if error != nil {
                print(error)
            }
            else if let result = result {
                let localData = LocalData()
                let userId = result["id"]! as! String
                let facebookProfilePictureUrl = "https://graph.facebook.com/" + userId + "/picture?type=large"
                if let fbpicUrl = NSURL(string: facebookProfilePictureUrl) {
                    if let data = NSData(contentsOfURL: fbpicUrl) {
                        let imageFile: PFFile = PFFile(data: data)!
                        PFUser.currentUser()?["fb_profile_picture"] = imageFile
                        PFUser.currentUser()?["profile_picture"] = imageFile
                        PFUser.currentUser()?.saveInBackground()
                        localData.setMainProfilePicture(data)
                        localData.synchronize()
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.profilePictureButton.setImage(UIImage(data: data), forState: .Normal)
                            pagingSpinner.stopAnimating()
                            pagingSpinner.removeFromSuperview()
                        })
                        
                        
                    }
                }
                
            }
        }
    }
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }else{
            let alert = UIAlertView()
            alert.title = "Warning"
            alert.message = "You don't have camera"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
    }
    func openGallary(){
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    
    //update the UIImageView once an image has been picked
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profilePictureButton.setImage(pickedImage, forState: .Normal)
            if let imageData = UIImageJPEGRepresentation(pickedImage, 1.0){
                localData.setMainProfilePicture(imageData)
                localData.synchronize()
                
                //update the user's profile picture in Database
                if let _ = PFUser.currentUser() {
                    let file = PFFile(data:imageData)
                    PFUser.currentUser()!["profile_picture"] = file
                    PFUser.currentUser()?.saveInBackground()
                }
                
            }
            
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }*/
    
    func displayNavigationBar(){
        
        let navItem = UINavigationItem()

        //setting the necterIcon to the rightBarButtonItem
        //setting messagesIcon to the icon specifying if there are or are not notifications
        necterButton.setImage(UIImage(named: "All_Types_Icon_Gray"), forState: .Normal)
        necterButton.setImage(UIImage(named: "Necter_Icon"), forState: .Selected)
        necterButton.setImage(UIImage(named: "Necter_Icon"), forState: .Highlighted)
        necterButton.addTarget(self, action: #selector(necterIconTapped(_:)), forControlEvents: .TouchUpInside)
        necterButton.frame = CGRect(x: 0, y: 0, width: 0.085*screenWidth, height: 0.085*screenWidth)
        necterButton.contentMode = UIViewContentMode.ScaleAspectFill
        necterButton.clipsToBounds = true
        let rightBarButton = UIBarButtonItem(customView: necterButton)
        navItem.rightBarButtonItem = rightBarButton
        
        //setting the navBar color and title
        navigationBar.setItems([navItem], animated: false)
        
        let navBarTitleView = UIView()
        navBarTitleView.frame = CGRect(x: 0, y: 0, width: 0.06*screenHeight, height: 0.06*screenHeight)
        //navBarTitleView.backgroundColor = UIColor.greenColor()
        let titleImageView = UIImageView(image: UIImage(named: "Profile_Icon_Yellow"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: 0.06*screenHeight, height: 0.06*screenHeight)
        titleImageView.contentMode = UIViewContentMode.ScaleAspectFill
        titleImageView.clipsToBounds = true
        navBarTitleView.addSubview(titleImageView)
        navigationBar.topItem?.titleView = navBarTitleView
        //navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Verdana", size: 30)!, NSForegroundColorAttributeName: necterYellow]
        /*UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];// Here you can set View width and height as per your requirement for displaying titleImageView position in navigationbar
        [backView setBackgroundColor:[UIColor greenColor]];
        UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SelectAnAlbumTitleLettering"]];
        titleImageView.frame = CGRectMake(45, 5,titleImageView.frame.size.width , titleImageView.frame.size.height); // Here I am passing origin as (45,5) but can pass them as your requirement.
        [backView addSubview:titleImageView];*/
        
        navigationBar.barStyle = .Black
        navigationBar.barTintColor = UIColor.whiteColor()
        
        self.view.addSubview(navigationBar)
        
    }
    func necterIconTapped (sender: UIBarButtonItem) {
        necterButton.selected = true
        performSegueWithIdentifier("showBridgeViewFromProfilePage", sender: self)
    }
    func displayMessageFromBot(notification: NSNotification) {
        let botNotificationView = UIView()
        botNotificationView.frame = CGRect(x: 0, y: -0.12*self.screenHeight, width: self.screenWidth, height: 0.12*self.screenHeight)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = botNotificationView.bounds
        //blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let messageLabel = UILabel(frame: CGRect(x: 0.05*screenWidth, y: 0.01*screenHeight, width: 0.9*screenWidth, height: 0.11*screenHeight))
        messageLabel.text = notification.userInfo!["message"] as? String ?? "No Message Came Up"
        messageLabel.textColor = UIColor.darkGrayColor()
        messageLabel.font = UIFont(name: "Verdana-Bold", size: 14)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = NSTextAlignment.Center
        //botNotificationView.backgroundColor = necterYellow
        
        //botNotificationView.addSubview(blurEffectView)
        botNotificationView.addSubview(messageLabel)
        botNotificationView.insertSubview(blurEffectView, belowSubview: messageLabel)
        view.insertSubview(botNotificationView, aboveSubview: profilePictureView)
        
        
        UIView.animateWithDuration(0.7) {
            botNotificationView.frame.origin.y = 0
        }
        
        let _ = Timer(interval: 4) {i -> Bool in
            UIView.animateWithDuration(0.7, animations: {
                botNotificationView.frame.origin.y = -0.12*self.screenHeight
            })
            return i < 1
        }

        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        //botNotificationView.removeFromSuperview()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.displayMessageFromBot), name: "displayMessageFromBot", object: nil)
        
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
        name.textColor = UIColor.blackColor()
        
        //get profile picture and set to a button
        let mainProfilePicture = localData.getMainProfilePicture()
        if let mainProfilePicture = mainProfilePicture {
            let image = UIImage(data: mainProfilePicture, scale: 1.0)
            //profilePictureButton.setImage(image, forState: .Normal)
            profilePictureView.image = image
        }  else {
            let pfData = PFUser.currentUser()?["profile_picture"] as? PFFile
            if let pfData = pfData {
                pfData.getDataInBackgroundWithBlock({ (data, error) in
                    if error != nil || data == nil {
                        print(error)
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            //self.profilePictureButton.setImage(UIImage(data: data!, scale: 1.0), forState:  .Normal)
                            self.profilePictureView.image = UIImage(data: data!, scale: 1.0)
                        })
                    }
                })
            }
            
        }
        
        //profilePictureButton.addTarget(self, action: #selector(profilePictureTapped(_:)), forControlEvents: .TouchUpInside)
        
        bridgeStatus.setTitle("Post Status", forState: .Normal)
        bridgeStatus.titleLabel!.font = UIFont(name: "Verdana", size: 20)
        bridgeStatus.setTitleColor(necterYellow, forState: UIControlState.Highlighted)
        bridgeStatus.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        bridgeStatus.layer.cornerRadius = 7.0
        bridgeStatus.layer.borderWidth = 4.0
        bridgeStatus.layer.borderColor = necterYellow.CGColor
        bridgeStatus.clipsToBounds = true
        bridgeStatus.addTarget(self, action: #selector(statusTapped(_:)), forControlEvents: .TouchUpInside)
        
        view.addSubview(bridgeStatus)
        view.addSubview(profilePictureView)
        tableView.tableFooterView = UIView()
        tableView.scrollEnabled = false
        tableView.separatorInset = UIEdgeInsetsZero
    }
    func statusTapped(sender: UIButton) {
        performSegueWithIdentifier("showNewStatusViewFromProfilePage", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        navigationBar.frame = CGRect(x: 0, y:0, width:screenWidth, height:0.11*screenHeight)
        profilePictureView.frame = CGRect(x: 0, y:0.12*screenHeight, width:0.25*screenHeight, height:0.25*screenHeight)
        profilePictureView.center.x = self.view.center.x
        profilePictureView.layer.cornerRadius = profilePictureView.frame.size.width/2
        profilePictureView.contentMode = UIViewContentMode.ScaleAspectFill
        profilePictureView.clipsToBounds = true
        name.frame = CGRect(x: 0.1*screenWidth, y:0.38*screenHeight, width:0.8*screenWidth, height:0.05*screenHeight)
        bridgeStatus.frame = CGRect(x: 0, y:0.465*screenHeight, width:0.45*screenWidth, height:0.06*screenHeight)
        bridgeStatus.center.x = self.view.center.x
        tableView.frame = CGRect(x: 0, y:0.55*screenHeight, width:screenWidth, height:0.435*screenHeight)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //let singleMessageVC:SingleMessageViewController = segue.destinationViewController as! SingleMessageViewController
        let vc = segue.destinationViewController
        let mirror = Mirror(reflecting: vc)
        if mirror.subjectType == BridgeViewController.self {
            self.transitionManager.animationDirection = "Right"
        } else if mirror.subjectType == OptionsFromBotViewController.self {
            self.transitionManager.animationDirection = "Top"
            let vc2 = vc as! OptionsFromBotViewController
            vc2.seguedFrom = "ProfileViewController"
        } else if mirror.subjectType == EditProfileViewController.self {
            self.transitionManager.animationDirection = "Left"
        } else if mirror.subjectType == TermsOfServiceViewController.self {
            self.transitionManager.animationDirection = "Left"
        } else if mirror.subjectType == PrivacyPolicyViewController.self {
            self.transitionManager.animationDirection = "Left"
        }
        vc.transitioningDelegate = self.transitionManager
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return 5
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let heightOfEachRow = tableView.frame.height/5.0
        return heightOfEachRow //Choose your custom row height
    }
    
    // Data to be shown on an individual row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ProfileTableViewCell
            cell.label.text = "Edit Profile"
            
            return cell
            
        } else if indexPath.row == 1 {
            
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
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ProfileTableViewCell
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
            
        }*/ else if indexPath.row == 2 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ProfileTableViewCell
            cell.label.text = "Terms of Service"
            //cell.label.textColor = UIColor.grayColor()
            
            return cell
            
        } else if indexPath.row == 3 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ProfileTableViewCell
            cell.label.text = "Privacy Policy"
            //cell.label.textColor = UIColor.grayColor()
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ProfileTableViewCell
            cell.label.text = "Log Out"
            //cell.label.textColor = UIColor.grayColor()
            
            return cell
            
        }
        
    }
    // A row is selected
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 {
            performSegueWithIdentifier("showEditProfileViewFromProfilePage", sender: self)
        } /*else if indexPath.row == 1 {
            
            
        } else if indexPath.row == 2 {
            
            
            
        }*/else if indexPath.row == 1 {
            
            //opens user's email application with email ready to be sent to bridge email
            
            let subject = "Providing%20Feedback%20for%20the%20necter%20Team"
            let encodedParams = "subject=\(subject)"
            let email = "blake@necter.social"
            let url = NSURL(string: "mailto:\(email)?\(encodedParams)")
            
            if UIApplication.sharedApplication().canOpenURL(url!) {
                
                UIApplication.sharedApplication().openURL(url!)
                
            }
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)

            
        } else if indexPath.row == 2 {
            
            performSegueWithIdentifier("showTermsofService", sender: self)
            
        } else if indexPath.row == 3 {
            
            performSegueWithIdentifier("showPrivacyPolicy", sender: self)
            
        } else {
            
            PFUser.logOut()
            performSegueWithIdentifier("showLoginView", sender: self)
            
        }
        
    }

}
