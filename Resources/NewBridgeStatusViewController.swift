//
//  NewBridgeStatusViewController.swift
//  MyBridgeApp
//
//  Created by Sagar Sinha on 6/27/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
class NewBridgeStatusViewController: UIViewController, UITextFieldDelegate, UINavigationBarDelegate {
    var pickerSelected = false
    let pickerData = ["Friendship", "Love","Business"]
    var pickerRowSelected = 0
    //@IBOutlet weak var navigationBar: UINavigationBar!
    let navigationBar = UINavigationBar()
    let username = UILabel()
    //@IBOutlet weak var username: UILabel!
    //@IBOutlet weak var bridgeTypePicker: UIPickerView!
    let profilePicture = UIImageView()
    let selectTypeLabel = UILabel()
    let screenOverImage = UIImageView()
    let businessButton = UIButton()
    let businessLabel = UILabel()
    let loveButton = UIButton()
    let loveLabel = UILabel()
    let friendshipButton = UIButton()
    let friendshipLabel = UILabel()
    let bridgeStatus = UITextField()
    let navItem = UINavigationItem()
    let nextUp = UILabel()

    var vc : ProfileViewController? = nil
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    let necterYellow = UIColor(red: 255/255, green: 230/255, blue: 57/255, alpha: 1.0)
    var necterTypeSet = false
    
    /*func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }*/
    /*func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerSelected = true
        pickerRowSelected = row
        if bridgeStatus.text! != "" {
            postButton.enabled = true
            navigationBar.topItem?.rightBarButtonItem?.tintColor = necterYellow
        }
    }*/
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 140 
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        if bridgeStatus.text! != "" && pickerSelected{
            navItem.rightBarButtonItem?.enabled = true
            navItem.rightBarButtonItem?.tintColor = necterYellow
        }
        return true
    }
    /*func textFieldDidEndEditing(textField: UITextField) {
        if bridgeStatus.text! != "" && pickerSelected{
            postButton.enabled = true
        }
    }*/
    /*func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        let titleData = pickerData[row]
        var myTitle = NSAttributedString()
        if row == 0{
            
         myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 14.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
            pickerLabel.backgroundColor = UIColor.init(red: 139.0/255, green: 217.0/255, blue: 176.0/255, alpha: 1.0)
        }
        else if row == 1{
            
             myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 14.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
            pickerLabel.backgroundColor = UIColor.init(red: 255.0/255, green: 129.0/255, blue: 125.0/255, alpha: 1.0)
        }
        else if row == 2{
            
            myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 14.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
            pickerLabel.backgroundColor = UIColor.init(red: 144.0/255, green: 207.0/255, blue: 214.0/255, alpha: 1.0)
        }
        else {
            myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 14.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
        }



        pickerLabel.attributedText = myTitle
        return pickerLabel
    }*/

    /*func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerData[row]
    }*/
    //creating actions for when necter Type buttons are clicked
    //the border should be outside of the image instead of inside
    func businessButtonClicked(sender: UIButton!) {
        profilePicture.layer.borderColor = UIColor(red: 144.0/255, green: 207.0/255, blue: 214.0/255, alpha: 1.0).CGColor
        profilePicture.layer.borderWidth = 4
        setPositionsForEnteringStatus()
    }
    func loveButtonClicked(sender: UIButton!) {
        print("Love tapped")
        profilePicture.layer.borderWidth = 4
        profilePicture.layer.borderColor = UIColor(red: 255.0/255, green: 129.0/255, blue: 125.0/255, alpha: 1.0).CGColor
        setPositionsForEnteringStatus()
    }
    func friendshipButtonClicked(sender: UIButton!) {
        print("Friendship tapped")
        profilePicture.layer.borderWidth = 4
        profilePicture.layer.borderColor = UIColor(red: 139.0/255, green: 217.0/255, blue: 176.0/255, alpha: 1.0).CGColor
        setPositionsForEnteringStatus()
    }
    //resetting view for what it should look like after one of the necter Type Buttons are clicked
    func setPositionsForEnteringStatus() {
        self.necterTypeSet = true
        UIView.animateWithDuration(0.7) {
            self.bridgeStatus.becomeFirstResponder()
            self.bridgeStatus.alpha = 1
            self.businessButton.alpha = 0
            self.businessLabel.alpha = 0
            self.loveButton.alpha = 0
            self.loveLabel.alpha = 0
            self.friendshipButton.alpha = 0
            self.friendshipLabel.alpha = 0
            self.screenOverImage.alpha = 0
            self.selectTypeLabel.alpha = 0
            self.profilePicture.frame = CGRect(x: 0.05*self.screenWidth, y: 0.15*self.screenHeight, width: 0.9*self.screenWidth, height: 0.4*self.screenHeight)
            self.screenOverImage.frame = CGRect(x: 0.05*self.screenWidth, y: 0.15*self.screenHeight, width: 0.9*self.screenWidth, height: 0.4*self.screenHeight)
            self.bridgeStatus.frame = CGRect(x: 0.1*self.screenWidth, y: 0.4*self.screenHeight, width: 0.8*self.screenWidth, height: 0.1*self.screenHeight)
            //self.businessLabel.frame = CGRect(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
        }
        
    }
    
    func displayNavigationBar(){
        
        var items = [UINavigationItem]()
        
        navItem.leftBarButtonItem = UIBarButtonItem(title: "cancel", style: .Plain, target: self, action: #selector(cancelTapped(_:)))
        navItem.leftBarButtonItem?.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Verdana", size: 16)!, NSForegroundColorAttributeName: UIColor.grayColor()], forState: .Normal)
        navItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .Plain, target: self, action: #selector(postTapped(_:)))
        navItem.rightBarButtonItem?.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Verdana", size: 16)!, NSForegroundColorAttributeName: UIColor.lightGrayColor()], forState: .Normal)
        //navItem.title = "necter Status"
        items.append(navItem)

        navigationBar.setItems(items, animated: false)
        navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Verdana", size: 20)!, NSForegroundColorAttributeName: UIColor.blackColor()]

        view.addSubview(navigationBar)

        
    }
    func cancelTapped(sender: UIBarButtonItem ){
        print("cancel selected")
        presentViewController(vc!, animated: true, completion: nil)
    }
    func postTapped(sender: UIBarButtonItem) {
        print("post selected")
        presentViewController(vc!, animated: true, completion: nil)
        let bridgeStatusObject = PFObject(className: "BridgeStatus")
        bridgeStatusObject["bridge_status"] = self.bridgeStatus.text!
        bridgeStatusObject["bridge_type"] = self.pickerData[self.pickerRowSelected]
        bridgeStatusObject["userId"] = PFUser.currentUser()?.objectId
        bridgeStatusObject.saveInBackground()
        PFCloud.callFunctionInBackground("changeBridgePairingsOnStatusUpdate", withParameters: ["status":self.bridgeStatus.text!, "bridgeType":self.pickerData[self.pickerRowSelected]]) {
            (response:AnyObject?, error: NSError?) -> Void in
            if error == nil {
                if let response = response as? String {
                    print(response)
                }
            }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bridgeStatus.delegate = self
        
        vc = storyboard!.instantiateViewControllerWithIdentifier("ProfileViewController") as? ProfileViewController
        displayNavigationBar()
        
        let localData = LocalData()
        let mainProfilePicture = localData.getMainProfilePicture()
        if let mainProfilePicture = mainProfilePicture {
            let image = UIImage(data:mainProfilePicture,scale:1.0)
            profilePicture.image = image
            print("got image")
        }
        if let name = localData.getUsername() {
            username.text = name
            
            print("got username")
        }
        else {
            username.text = "Enter Name on your Profile"
        }
        
        
        var firstName = String()
        if username.text != "Enter name on your Profile" {
            if let username = username.text {
                firstName = username.componentsSeparatedByString(" ").first!
            }
        }
        
        profilePicture.layer.cornerRadius = 7
        profilePicture.contentMode = UIViewContentMode.ScaleAspectFill
        profilePicture.clipsToBounds = true
        screenOverImage.layer.cornerRadius = 7
        screenOverImage.clipsToBounds = true
        screenOverImage.image = UIImage(named: "Screen over image.png")
        
        username.textColor = UIColor.whiteColor()
        username.font = UIFont(name: "BentonSans", size: 20)
        
        bridgeStatus.alpha = 0
        bridgeStatus.textColor = UIColor.whiteColor()
        var statusAttributedString = NSMutableAttributedString()
        let placeholderText  = "What are you looking to connect for?" // PlaceHolderText
        statusAttributedString = NSMutableAttributedString(string:placeholderText, attributes: [NSFontAttributeName:UIFont(name: "BentonSans", size: 14.0)!]) // Font
        statusAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range:NSRange(location:0,length:placeholderText.characters.count))    // Color
        bridgeStatus.attributedPlaceholder = statusAttributedString
        
        //setting up instructions and buttons
        selectTypeLabel.frame = CGRect(x: 0.05*screenWidth, y: 0.12*screenHeight, width: 0.9*screenWidth, height: 0.15*screenHeight)
        selectTypeLabel.text = "Hey \(firstName), \nWhat are you looking to connect for?"
        selectTypeLabel.font = UIFont(name: "Verdana", size: 22)
        selectTypeLabel.textAlignment = NSTextAlignment.Left
        selectTypeLabel.numberOfLines = 0
        selectTypeLabel.textColor = UIColor.blackColor()
        
        //setting business button and label
        businessButton.frame = CGRect(x: 0.1*screenWidth, y: 0.3*screenHeight, width: 0.2*screenWidth, height: 0.2*screenWidth)
        businessButton.setBackgroundImage(UIImage(named: "Business-33x33.png"), forState: .Normal)
        businessButton.addTarget(self, action: #selector(businessButtonClicked), forControlEvents: .TouchUpInside)
        businessButton.contentMode = UIViewContentMode.ScaleToFill
        businessButton.clipsToBounds = true
        businessLabel.text = "Business"
        businessLabel.font = UIFont(name: "BentonSans", size: 20)
        businessLabel.textAlignment = NSTextAlignment.Left
        businessLabel.frame = CGRect(x: 0, y: 0, width: 0.3*screenWidth, height: 0.1*screenHeight)
        businessLabel.center.x = businessButton.center.x + 0.3*screenWidth
        businessLabel.center.y = businessButton.center.y
        
        //setting love button and label
        loveButton.frame = CGRect(x: 0.1*screenWidth, y: 0.35*screenHeight + 0.2*screenWidth, width: 0.2*screenWidth, height: 0.2*screenWidth)
        loveButton.setBackgroundImage(UIImage(named: "Love-33x33.png"), forState: .Normal)
        loveButton.addTarget(self, action: #selector(loveButtonClicked), forControlEvents: .TouchUpInside)
        loveButton.contentMode = UIViewContentMode.ScaleToFill
        loveButton.clipsToBounds = true
        loveLabel.text = "Love"
        loveLabel.font = UIFont(name: "BentonSans", size: 16)
        loveLabel.textAlignment = NSTextAlignment.Left
        loveLabel.frame = CGRect(x: 0, y: 0, width: 0.3*screenWidth, height: 0.1*screenHeight)
        loveLabel.center.x = loveButton.center.x + 0.3*screenWidth
        loveLabel.center.y = loveButton.center.y
        
        //setting friendship button and label
        friendshipButton.frame = CGRect(x: 0.1*screenWidth, y: 0.4*screenHeight + 0.4*screenWidth, width: 0.2*screenWidth, height: 0.2*screenWidth)
        friendshipButton.setBackgroundImage(UIImage(named: "Friendship-44x44.png"), forState: .Normal)
        friendshipButton.addTarget(self, action: #selector(friendshipButtonClicked), forControlEvents: .TouchUpInside)
        friendshipButton.contentMode = UIViewContentMode.ScaleToFill
        friendshipButton.clipsToBounds = true
        friendshipLabel.text = "Friendship"
        friendshipLabel.font = UIFont(name: "BentonSans", size: 20)
        friendshipLabel.textAlignment = NSTextAlignment.Left
        friendshipLabel.frame = CGRect(x: 0, y: 0, width: 0.3*screenWidth, height: 0.1*screenHeight)
        friendshipLabel.center.x = friendshipButton.center.x + 0.3*screenWidth
        friendshipLabel.center.y = friendshipButton.center.y
        
        nextUp.frame = CGRect(x: 0.05*screenWidth, y: 0.3*screenHeight + 0.3*screenWidth, width: 0.9*screenWidth, height: 0.1)
        nextUp.font = UIFont(name: "Verdana", size: 18)
        nextUp.text = "Next: Post a Status"
        nextUp.textColor = UIColor.lightGrayColor()
        
        //adding the view elements to the NewBridgeStatusViewController
        view.addSubview(profilePicture)
        view.addSubview(selectTypeLabel)
        view.addSubview(businessButton)
        view.addSubview(businessLabel)
        view.addSubview(loveButton)
        view.addSubview(loveLabel)
        view.addSubview(friendshipButton)
        view.addSubview(friendshipLabel)
        view.addSubview(bridgeStatus)
        view.addSubview(username)
        view.addSubview(screenOverImage)
        view.addSubview(nextUp)
        //bridgeTypePicker.hidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        
        if necterTypeSet == false {
            navigationBar.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 0.11*screenHeight)
            //username.frame = CGRect(x: 0.12*screenWidth, y: 0.7*screenHeight, width: 0.5*screenWidth, height: 0.1*screenHeight)
            screenOverImage.frame = profilePicture.frame
            //profilePicture.frame = CGRect(x: 0.1*screenWidth, y: 0.5*screenHeight, width: 0.8*screenWidth, height: 0.4*screenHeight)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    /*@IBAction func postButtonTapped(sender: AnyObject) {
        //        let query: PFQuery = PFQuery(className: "BridgeStatus")
        //        query.whereKey("userId", containsString: PFUser.currentUser()?.objectId)
        //        query.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
        //            if let error = error {
        //
        //                print(error)
        //
        //            } else if let results = results {
        //                var noResultReturned = true
        //                for result in results{
        //                    noResultReturned = false
        //                    result["bridge_status"] = self.bridgeStatus.text!
        //                    result["bridge_type"] = self.pickerData[self.pickerRowSelected]
        //                    result.saveInBackground()
        //                }
        //                if noResultReturned {
        //                    let bridgeStatusObject = PFObject(className: "BridgeStatus")
        //                    bridgeStatusObject["bridge_status"] = self.bridgeStatus.text!
        //                    bridgeStatusObject["bridge_type"] = self.pickerData[self.pickerRowSelected]
        //                    bridgeStatusObject["userId"] = PFUser.currentUser()?.objectId
        //                    bridgeStatusObject.saveInBackground()
        //
        //                }
        //            }
        //
        //        })
        let bridgeStatusObject = PFObject(className: "BridgeStatus")
        bridgeStatusObject["bridge_status"] = self.bridgeStatus.text!
        bridgeStatusObject["bridge_type"] = self.pickerData[self.pickerRowSelected]
        bridgeStatusObject["userId"] = PFUser.currentUser()?.objectId
        bridgeStatusObject.saveInBackground()
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        //navigationController?.popViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
*/

}
