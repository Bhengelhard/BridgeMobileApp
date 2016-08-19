//
//  ProfileViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 7/25/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var editImageButton: UIButton!
    //@IBOutlet weak var bridgeStatus: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    let navigationBar = UINavigationBar()
    let necterButton = UIButton()
    let bridgeStatus = UIButton()
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    var editableName:String = ""
    let noNameText = "Click to enter your full name"
    let transitionManager = TransitionManager()
    
    let necterYellow = UIColor(red: 255/255, green: 230/255, blue: 57/255, alpha: 1.0)
    
    // globally required as we do not want to re-create them everytime and for persistence
    let imagePicker = UIImagePickerController()
    
    @IBAction func editImageTapped(sender: AnyObject) {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
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
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)

        imagePicker.allowsEditing = false
        
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
            editImageButton.setImage(pickedImage, forState: .Normal)
            if let imageData = UIImageJPEGRepresentation(pickedImage, 1.0){
                let localData = LocalData()
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
    }

    //stopping user from entering name with length greater than 25
    @IBAction func nameTextFieldChanged(sender: AnyObject) {
        if let characterCount = nameTextField.text?.characters.count {
            if characterCount > 25 {
                let aboveMaxBy = characterCount - 25
                let index1 = nameTextField.text!.endIndex.advancedBy(-aboveMaxBy)
                nameTextField.text = nameTextField.text!.substringToIndex(index1)
            }
        }
    }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        nameTextField.delegate = self
        imagePicker.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        displayNavigationBar()
        
        /*
        let modelName = UIDevice.currentDevice().modelName
        
        if ["iPhone 4", "iPhone 4s", "iPhone 5", "iPhone 5", "iPhone 5c", "iPhone 5s"].contains(modelName) {
            navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Verdana", size: 16)!]
        } else {
            navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Verdana", size: 18)!]
        }*/
        
        
        let username = LocalData().getUsername()
        
        if let username = username {
            if username != "" {
                editableName = username
                nameTextField.text = username
            } else{
                /*PFUser.currentUser()?.fetchInBackgroundWithBlock({ (<#PFObject?#>, <#NSError?#>) in
                    <#code#>
                })
                let query = PFQuery(className:"_User")
                query.getObjectInBackgroundWithId(PFUser.currentUser()?.objectId, block: { (objects, error) in
                    if error == nil {
                        
                    } else {
                        
                    }
                    
                })*/
                
                
                editableName = noNameText
                name.text = noNameText
            }
        }
        else{
            editableName = noNameText
            name.text = noNameText
        }
        
        nameTextField.hidden = true
        name.userInteractionEnabled = true
        
        if let username = username {
            name.text = username
        }
        name.textColor = UIColor.lightGrayColor()
        
        let aSelector : Selector = #selector(ProfileViewController.lblTapped)
        let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
        tapGesture.numberOfTapsRequired = 1
        name.addGestureRecognizer(tapGesture)
        
        
        let mainProfilePicture = LocalData().getMainProfilePicture()
        if let mainProfilePicture = mainProfilePicture {
            let image = UIImage(data:mainProfilePicture,scale:1.0)
            editImageButton.setImage(image, forState: .Normal)
        }
        
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
        tableView.tableFooterView = UIView()
        
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
        editImageButton.frame = CGRect(x: 0, y:0.12*screenHeight, width:0.25*screenHeight, height:0.25*screenHeight)
        editImageButton.center.x = self.view.center.x
        editImageButton.layer.cornerRadius = editImageButton.frame.size.width/2
        editImageButton.contentMode = UIViewContentMode.ScaleAspectFill
        editImageButton.clipsToBounds = true
        name.frame = CGRect(x: 0.1*screenWidth, y:0.38*screenHeight, width:0.8*screenWidth, height:0.05*screenHeight)
        nameTextField.frame = CGRect(x: 0.1*screenWidth, y:0.38*screenHeight, width:0.8*screenWidth, height:0.05*screenHeight)
        bridgeStatus.frame = CGRect(x: 0, y:0.465*screenHeight, width:0.45*screenWidth, height:0.06*screenHeight)
        bridgeStatus.center.x = self.view.center.x
        tableView.frame = CGRect(x: 0, y:0.55*screenHeight, width:screenWidth, height:0.435*screenHeight)
    }
    
    // Username label is tapped. Textfield should appear and replace the label
    func lblTapped(){
        nameTextField.becomeFirstResponder()
        name.hidden = true
        nameTextField.hidden = false
        if editableName != noNameText {
            nameTextField.text = editableName
        }
        let outSelector : Selector = #selector(ProfileViewController.tappedOutside)
        let outsideTapGesture = UITapGestureRecognizer(target: self, action: outSelector)
        outsideTapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(outsideTapGesture)
    }
    // Tapped anywhere else on the main view. Textfield should be replaced by label
    func tappedOutside(){
        if nameTextField.isFirstResponder() {
            nameTextField.endEditing(true)
            name.hidden = false
            nameTextField.hidden = true
            if let editableNameTemp = nameTextField.text{
                if editableNameTemp != "" {
                    name.text = editableNameTemp
                    editableName = editableNameTemp
                }
            }
            let updatedText = nameTextField.text
            if let updatedText = updatedText {
                let localData = LocalData()
                localData.setUsername(updatedText)
                localData.synchronize()
                
                //saving updated username to parse
                if let _ = PFUser.currentUser() {
                    PFUser.currentUser()!["name"] = updatedText
                    PFUser.currentUser()?.saveInBackground()
                }
            }
            if let _ = view.gestureRecognizers {
                for gesture in view.gestureRecognizers! {
                    view.removeGestureRecognizer(gesture)
                }
            }
            
        }
    }
    // User returns after editing
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        nameTextField.hidden = true
        name.hidden = false
        if let editableNameTemp = nameTextField.text{
            name.text = editableNameTemp
            editableName = editableNameTemp
        }
        let updatedText = nameTextField.text
        if let updatedText = updatedText {
            let localData = LocalData()
            localData.setUsername(updatedText)
            localData.synchronize()
        }
        return true
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //let singleMessageVC:SingleMessageViewController = segue.destinationViewController as! SingleMessageViewController

        let vc = segue.destinationViewController
        let mirror = Mirror(reflecting: vc)
        if mirror.subjectType == BridgeViewController.self {
            self.transitionManager.animationDirection = "Right"
        } else if mirror.subjectType == NewBridgeStatusViewController.self {
            self.transitionManager.animationDirection = "Top"
            let vc2 = vc as! NewBridgeStatusViewController
            vc2.seguedFrom = "ProfileViewController"
        }
        vc.transitioningDelegate = self.transitionManager
    }
    
    
 
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return 7
        
    }
    
    // Data to be shown on an individual row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ProfileTableViewCell
            cell.label.text = "Give Feedback"
            
            return cell
            
        } else if indexPath.row == 1 {
            
            let cell2 = tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath) as! ProfileTableViewCell2
            //cell2.label.text = "'nect for Business"
            if let interestedInBusiness = PFUser.currentUser()?["interested_in_business"] as? Bool {
                cell2.preferencesSwitch.on = interestedInBusiness
            }
            else {
                cell2.preferencesSwitch.on = true
            }
            cell2.preferencesSwitch.onTintColor = UIColor(red: 39/255, green: 103/255, blue: 143/255, alpha: 1.0)
            cell2.selectionStyle = UITableViewCellSelectionStyle.None
            
            //setting multi-font label
            //let string = "connect for business" as NSString
            //let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSFontAttributeName: UIFont.init(name: "BentonSans", size: 18)!])
            //let necterFontAttribute = [NSFontAttributeName: UIFont.init(name: "Verdana", size: 18) as! AnyObject]
            // Part of string to be necter font
            //attributedString.addAttributes(necterFontAttribute, range: string.rangeOfString("nect"))
            cell2.label.text = "connect for business"
            cell2.label.font = UIFont(name: "BentonSans", size: 18)
            
            return cell2
            
        } else if indexPath.row == 2 {
            
            let cell2 = tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath) as! ProfileTableViewCell2
            if let interestedInLove = PFUser.currentUser()?["interested_in_love"] as? Bool {
                cell2.preferencesSwitch.on = interestedInLove
            }
            else {
                cell2.preferencesSwitch.on = true
            }
            cell2.preferencesSwitch.onTintColor = UIColor.init(red: 227/255, green: 70/255, blue: 73/255, alpha: 1.0)
            cell2.selectionStyle = UITableViewCellSelectionStyle.None
            
            //setting multi-font label
            //let string = "connect for love" as NSString
            //let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSFontAttributeName: UIFont.init(name: "BentonSans", size: 18)!])
            //let necterFontAttribute = [NSFontAttributeName: UIFont.init(name: "Verdana", size: 18) as! AnyObject]
            // Part of string to be necter font
            //attributedString.addAttributes(necterFontAttribute, range: string.rangeOfString("nect"))
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
            
        } else if indexPath.row == 4 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ProfileTableViewCell
            cell.label.text = "Terms of Service"
            //cell.label.textColor = UIColor.grayColor()
            
            return cell
            
        } else if indexPath.row == 5 {
            
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
            
            //opens user's email application with email ready to be sent to bridge email
            
            let subject = "Providing%20Feedback%20for%20the%20necter%20Team"
            let encodedParams = "subject=\(subject)"
            let email = "blake@necter.social"
            let url = NSURL(string: "mailto:\(email)?\(encodedParams)")
            
            if UIApplication.sharedApplication().canOpenURL(url!) {
                
                UIApplication.sharedApplication().openURL(url!)
                
            }
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
        } else if indexPath.row == 1 {
            
            
        } else if indexPath.row == 2 {
            
            
            
        } else if indexPath.row == 3 {
            
            
            
        } else if indexPath.row == 4 {
            
            performSegueWithIdentifier("showTermsofService", sender: self)
            
        } else if indexPath.row == 5 {
            
            performSegueWithIdentifier("showPrivacyPolicy", sender: self)
            
        } else {
            
            PFUser.logOut()
            performSegueWithIdentifier("showLoginView", sender: self)
            
        }
        
    }

}
