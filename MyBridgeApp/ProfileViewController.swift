//
//  ProfileViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 7/25/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var editImageButton: UIButton!
    @IBOutlet weak var bridgeStatus: UIButton!
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
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
            profilePicture.image = pickedImage
            profilePicture.layer.cornerRadius = profilePicture.frame.size.width/2
            profilePicture.clipsToBounds = true
            if let imageData = UIImageJPEGRepresentation(pickedImage, 1.0){
                let localData = LocalData()
                localData.setMainProfilePicture(imageData)
                localData.synchronize()
                
                //update the user's profile picture in Database
                if let _ = PFUser.currentUser() {
                    PFUser.currentUser()!["profile_picture"] = imageData
                    PFUser.currentUser()?.saveInBackground()
                }
                
            }
            
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imagePicker.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        
        let username = LocalData().getUsername()
        print(username)
        
        if let username = username {
            
            print("hello world")
            
            navigationBar.topItem?.title = "\(username)'s Profile"
            
        }
        
        let mainProfilePicture = LocalData().getMainProfilePicture()
        if let mainProfilePicture = mainProfilePicture {
            let image = UIImage(data:mainProfilePicture,scale:1.0)
            profilePicture.image = image
        }
        
        editImageButton.layer.cornerRadius = editImageButton.frame.size.width/2
        editImageButton.clipsToBounds = true
        
        
        bridgeStatus.layer.cornerRadius = 7.0
        bridgeStatus.layer.borderWidth = 4.0
        bridgeStatus.layer.borderColor = UIColor(red: 255/255, green: 230/255, blue: 57/255, alpha: 1.0).CGColor
        //bridgeStatus.backgroundColor = UIColor(red: 255/255, green: 230/255, blue: 57/255, alpha: 1.0)
        bridgeStatus.clipsToBounds = true
        
        bridgeStatus.setTitleColor(UIColor(red: 255/255, green: 230/255, blue: 57/255, alpha: 1.0), forState: UIControlState.Highlighted)
        
        bridgeStatus.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        tableView.tableFooterView = UIView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
        navigationBar.frame = CGRect(x: 0, y:0, width:screenWidth, height:0.1*screenHeight)
        profilePicture.frame = CGRect(x: 0, y:0.12*screenHeight, width:0.25*screenHeight, height:0.25*screenHeight)
        profilePicture.center.x = self.view.center.x
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width/2
        profilePicture.clipsToBounds = true
        bridgeStatus.frame = CGRect(x: 0, y:0.4*screenHeight, width:0.45*screenWidth, height:0.06*screenHeight)
        bridgeStatus.center.x = self.view.center.x
        tableView.frame = CGRect(x: 0, y:0.49*screenHeight, width:screenWidth, height:0.5*screenHeight)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
            cell2.label.text = "Bridge for Business"
            //cell2.preferencesSwitch.onTintColor = UIColor(red: 139/255, green: 217/255, blue: 176/255, alpha: 1.0)
            cell2.preferencesSwitch.onTintColor = UIColor(red: 42/255, green: 66/255, blue: 165/255, alpha: 1.0)
            cell2.selectionStyle = UITableViewCellSelectionStyle.None
            
            return cell2
            
        } else if indexPath.row == 2 {
            
            let cell2 = tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath) as! ProfileTableViewCell2
            cell2.label.text = "Bridge for Love"
            //cell2.preferencesSwitch.onTintColor = UIColor.init(red: 255/255, green: 129/255, blue: 125/255, alpha: 1.0)
            cell2.preferencesSwitch.onTintColor = UIColor.init(red: 216/255, green: 63/255, blue: 52/255, alpha: 1.0)
            cell2.selectionStyle = UITableViewCellSelectionStyle.None
            
            return cell2
            
        } else if indexPath.row == 3 {
            
            let cell2 = tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath) as! ProfileTableViewCell2
            cell2.label.text = "Bridge for Friendship"
            //cell2.preferencesSwitch.onTintColor = UIColor(red: 144/255, green: 207/255, blue: 214/255, alpha: 1.0)
            cell2.preferencesSwitch.onTintColor = UIColor(red: 87/255, green: 154/255, blue: 57/255, alpha: 1.0)
            cell2.selectionStyle = UITableViewCellSelectionStyle.None
            
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
            
            let subject = "Providing%20Feedback%20for%20the%20Bridge%20Team"
            let encodedParams = "subject=\(subject)"
            let email = "blake@mybridgeapp.com"
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
