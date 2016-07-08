//
//  NewMessageViewController.swift
//  MyBridgeApp
//
//  Created by Sagar Sinha on 6/23/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
class NewMessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchResultsUpdating, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UISearchBarDelegate {

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var bridgeMessage: UITextField!
    @IBOutlet weak var imageMessage: UIImageView!
    @IBOutlet weak var sendButon: UIButton!
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    var friendNames = [String]()
    var friendObjectIds = [String]()
    var friendProfilePictures = [UIImage]()
    var friendProfilePicturesPfFile = [PFFile]()
    var filteredPositions = [Int]()
    var nameAdded = false
    var picker = UIImagePickerController()
    var imageViewRef = UIButton()
    var sendToObjectIds = [String]()
    var imageSet = false
    var messageId = String()
    var segueToSingleMessage = false
    let transitionManager = TransitionManager()
    var noOfnamesSelected = 0
    var scrollViewXPosition = -58
    var scrollViewYPosition = 0
    var nameSelectedArray = [String]()
    var nameIdSelectedArray = [String]()
    func getFriendNames(){
        let friendList = LocalData().getFriendList()
        if let _ = friendList{
            let query: PFQuery = PFQuery(className: "_User")
            query.whereKey("objectId", containedIn: friendList!)
            query.cachePolicy = .NetworkElseCache
            query.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                if let error = error {
                    print(error)
                }
                else if let results = results {
                    for result in results{
                        self.friendObjectIds.append(result.objectId!)
                        if let name = result["name"] as? String{
                            self.friendNames.append(name)
                        }
                        else {
                            self.friendNames.append("Anonymous")
                        }
                        if let profilePhoto = result["profile_picture"] as? PFFile{
                            self.friendProfilePicturesPfFile.append(profilePhoto)
                            /*do {
                                let imageData = try profilePhoto.getData()
                                print("fb_profile_picture")
                                self.friendProfilePictures.append(UIImage(data:imageData)!)
                                
                            }
                            catch{
                                print(error)
                            }*/
                            
                        }
                        else if let profilePhoto = result["fb_profile_picture"] as? PFFile{
                            self.friendProfilePicturesPfFile.append(profilePhoto)
                            
                        }
                        
                    }
                }
                
            })
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segueToSingleMessage {
        segueToSingleMessage = false
        let singleMessageVC:SingleMessageViewController = segue.destinationViewController as! SingleMessageViewController
        singleMessageVC.transitioningDelegate = self.transitionManager
        singleMessageVC.isSeguedFromNewMessage = true
        singleMessageVC.newMessageId = self.messageId
        }
    }
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        if bridgeMessage.text != "" || self.imageSet{
            //self.imageSet = false
            imageMessage.hidden = true
            
            self.sendButon.userInteractionEnabled = false
            //self.sendButon.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            self.searchController.searchBar.text = ""
            let query: PFQuery = PFQuery(className: "Messages")
            sendToObjectIds = nameIdSelectedArray
            var objectIdsInMessage = sendToObjectIds
            objectIdsInMessage.append((PFUser.currentUser()?.objectId)!)
            print("objectIdsInMessage - \(objectIdsInMessage)")
            query.whereKey("ids_in_message", containsAllObjectsInArray: objectIdsInMessage)
            var messageIdNotFound = true
            do{
            let results = try query.findObjects()
            self.messageId = String()
            for result in results{
                let objectIdsRetrieved = result["ids_in_message"] as! [String]
                if objectIdsInMessage.count == objectIdsRetrieved.count{
                    print("object found")
                    self.messageId = result.objectId!
                    messageIdNotFound = false
                    result["ids_in_message"] = result["ids_in_message"]
                    result["message_viewed_by"] = [String]()
                    result.saveInBackground() // to update the time
                    break
                    }
              }
            }
            catch {
                
            }
                    if (messageIdNotFound) {
                        print("object not found")
                        let message = PFObject(className: "Messages")
                        message["ids_in_message"]  = objectIdsInMessage
                        message["bridge_builder"] = PFUser.currentUser()?.objectId
                        do{
                            try message.save()
                            self.messageId = message.objectId!
                        }
                        catch{
                            print(error)
                        }

                    }
                    let singleMessage = PFObject(className: "SingleMessages")
                    if self.bridgeMessage.text != "" {
                        print("self.bridgeMessage.text \(self.bridgeMessage.text)")
                        singleMessage["message_text"] = self.bridgeMessage.text!
                    }
                    if self.imageSet {
                        print("imageSet is Set to true")
                        let file = PFFile(data: UIImageJPEGRepresentation(self.imageMessage.image!, 1.0)!)
                        singleMessage["message_image"] = file
                        self.imageSet = false
                    }
                    singleMessage["sender"] = PFUser.currentUser()?.objectId
                    singleMessage["message_id"] = self.messageId
                    do{
                        try singleMessage.save()
                    }
                    catch{
                        print(error)
                    }

                }
            segueToSingleMessage = true
            print("Segue now")
            searchController.active = false
            performSegueWithIdentifier("showSingleMessageFromNewMessage", sender: self)
    }
    @IBAction func photoButton(sender: AnyObject) {
        let savedSendTo = searchController.searchBar.text!
        searchController.active = false
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
        self.picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
        searchController.searchBar.text = savedSendTo
    }
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(picker, animated: true, completion: nil)
        }else{
            let alert = UIAlertView()
            alert.title = "Warning"
            alert.message = "You don't have camera"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
    }
    func openGallary(){
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(picker, animated: true, completion: nil)
    }
   
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        picker .dismissViewControllerAnimated(true, completion: nil)
        imageMessage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        //imageMessage.hidden = false
        
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        //view.addSubview(imageView)
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        bridgeMessage.leftView = imageView
        self.imageSet = true
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        print("picker cancel.")
        self.imageSet = false
    }

    
      override func viewDidLoad() {
        super.viewDidLoad()
        self.getFriendNames()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "To:                                                        "
        self.sendButon.userInteractionEnabled = false
        self.sendButon.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        imageMessage.hidden = true
        
        bridgeMessage.leftViewMode = UITextFieldViewMode.Always
        
        
        navigationBar.hidden = false
        scrollView.hidden = true

        // Do any additional setup after loading the view.
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   

    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        navigationBar.hidden = true
        
        /*let xPosition = tableView.frame.origin.x - 10
        //View will slide 20px up
        let yPosition = tableView.frame.origin.y - 40
        let height = tableView.frame.size.height
        let width = tableView.frame.size.width
        
        UIView.animateWithDuration(1.0, animations: {
            
            self.tableView.frame = CGRectMake(xPosition, yPosition, height, width)
        })*/
        scrollView.hidden = true
        print("tapped")
        
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        navigationBar.hidden = false
        scrollView.hidden = true
        let subViews = self.scrollView.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        nameIdSelectedArray.removeAll()
        nameSelectedArray.removeAll()
        scrollViewXPosition = -58
        scrollViewYPosition = 0
        
    
        /*var xPosition = scrollView.frame.origin.x
        
        //View will slide 20px up
        var yPosition = scrollView.frame.origin.y - 40
        
        var height = scrollView.frame.size.height
        var width = scrollView.frame.size.width
        
        UIView.animateWithDuration(1.0, animations: {
            
            self.scrollView.frame = CGRectMake(xPosition, yPosition, height, width)
        })

        
        xPosition = tableView.frame.origin.x
        //View will slide 20px up
        yPosition = tableView.frame.origin.y - 40
        height = tableView.frame.size.height
        width = tableView.frame.size.width
        
        UIView.animateWithDuration(1.0, animations: {
            
            self.tableView.frame = CGRectMake(xPosition, yPosition, height, width)
        })
        scrollView.hidden = true
         */
        self.sendButon.userInteractionEnabled = false
        self.sendButon.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        self.sendToObjectIds = [String]()
        print("cancel button tapped")
    }
    func filterContentForSearchText(searchText:String, scope: String = "All"){
        print("searchText is \(searchText) and friend ids are \(self.friendObjectIds)")
        self.filteredPositions = [Int]()
        var searchTerms = searchText.characters.split{$0 == ","}.map(String.init)
        var searchFor = searchText
        if searchTerms.count > 1 {
         print("searchTerms.count - \(searchTerms.count)")
            if searchTerms.count == searchText.componentsSeparatedByString(",").count - 1{
                searchFor = " "
            }
            else {
                searchFor = searchTerms[searchTerms.count - 1]
            }
        }
        for i in 0 ..< self.friendNames.count  {
            if self.friendNames[i].lowercaseString.containsString(searchFor.lowercaseString){
                self.filteredPositions.append(i)
            }

        }
        tableView.reloadData()
    }
    func updateSearchResultsForSearchController(searchController: UISearchController) {
       /* if self.nameAdded {
            if let _ = searchController.searchBar.text{
            searchController.searchBar.text = searchController.searchBar.text! + ", "
            print("comma added")
            }
            
        }*/
        self.nameAdded = false
        filterContentForSearchText(searchController.searchBar.text!)
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPositions.count
    }
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! NewMessageTableCell
        cell.name.text = self.friendNames[filteredPositions[indexPath.row]]
       
        self.friendProfilePicturesPfFile[filteredPositions[indexPath.row]].getDataInBackgroundWithBlock {
            (imageData:NSData?, error:NSError?) -> Void in
            if error == nil {
                cell.profilePhoto.image = UIImage(data:imageData!)!
                cell.profilePhoto.layer.cornerRadius = cell.profilePhoto.frame.size.width/2
                cell.profilePhoto.clipsToBounds = true
            }
        }
        return cell
       
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var preSearchedTerms = ""
        if searchController.searchBar.text!.containsString(","){
            var searchTerms = searchController.searchBar.text!.characters.split{$0 == ","}.map(String.init)
            
            for i in 0 ..< searchTerms.count-1 {
                preSearchedTerms += searchTerms[i]+","
            }
            self.sendToObjectIds.append(self.friendObjectIds[filteredPositions[indexPath.row]])
            
        }
        else {
            print("filteredPositions \(filteredPositions) ")
            self.sendToObjectIds.append(self.friendObjectIds[filteredPositions[indexPath.row]])
            //searchController.searchBar.text = friendNames[filteredPositions[indexPath.row]] + ","
            
        }
       var shiftDown = false
        scrollViewXPosition += 58
        if scrollViewXPosition > 261 {
            scrollViewXPosition = 0
            scrollViewYPosition += 25
            shiftDown = true
        }
        navigationBar.hidden = true
        scrollView.hidden = false
        if (shiftDown || noOfnamesSelected == 0) {
            print("shiftDown || noOfnamesSelected")
            //searchController.searchBar.userInteractionEnabled = false
            navigationBar.hidden = true
            scrollView.hidden = false
        }
        

        let frame1 = CGRect(x: scrollViewXPosition, y: scrollViewYPosition, width: 50, height: 20 )
        let button = UIButton(frame: frame1)
        button.setTitle(friendNames[filteredPositions[indexPath.row]], forState: .Normal)
        
        button.backgroundColor = UIColor.clearColor()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blackColor().CGColor
        button.backgroundColor = UIColor.blackColor()
        button.titleLabel?.font = UIFont(name:"HelveticaNeue", size:8)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NewMessageViewController.nameDoubleTapped(_:)))
        tapGesture.numberOfTapsRequired = 2
        button.addGestureRecognizer(tapGesture)
        button.tag = noOfnamesSelected
        
        
        let frame2 = CGRect(x: scrollViewXPosition+50, y: scrollViewYPosition, width: 6, height: 6 )
        let cancelButton = UIButton(frame: frame2)
        cancelButton.layer.cornerRadius = 0.5 * button.bounds.size.width
        cancelButton.setImage(UIImage(named:"iconCancel.png"), forState: .Normal)
        cancelButton.addTarget(self, action: #selector(NewMessageViewController.removeNameTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cancelButton.tag = noOfnamesSelected
        
        nameSelectedArray.append(friendNames[filteredPositions[indexPath.row]])
        nameIdSelectedArray.append(friendObjectIds[filteredPositions[indexPath.row]])
        
        self.scrollView.addSubview(cancelButton)
        self.scrollView.addSubview(button)
         searchController.searchBar.text = ""//preSearchedTerms+friendNames[filteredPositions[indexPath.row]]+","
        
        
        self.sendButon.userInteractionEnabled = true
        self.sendButon.setTitleColor(UIColor.init(red: 0.196, green: 0.3098, blue: 0.52, alpha: 1.0), forState: UIControlState.Normal)
        self.nameAdded = true
        noOfnamesSelected += 1
        //tableView.reloadData()
    }
    func removeNameTapped(button: UIButton) {
        print("button.tag \(button.tag)")
        nameSelectedArray.removeAtIndex(button.tag)
        nameIdSelectedArray.removeAtIndex(button.tag)
        removeAndAddNameButtons()
    }
    func nameDoubleTapped(sender : UIGestureRecognizer){
        nameSelectedArray.removeAtIndex(sender.view!.tag)
        nameIdSelectedArray.removeAtIndex(sender.view!.tag)
        removeAndAddNameButtons()
        
    }
    func removeAndAddNameButtons(){
        let subViews = self.scrollView.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        scrollViewXPosition = -58
        scrollViewYPosition = 0
        print("nameSelectedArray \(nameSelectedArray)")
        for i in 0 ..< nameSelectedArray.count {
            scrollViewXPosition += 58
            if scrollViewXPosition > 261 {
                scrollViewXPosition = 0
                scrollViewYPosition += 25
            }
            
            let frame1 = CGRect(x: scrollViewXPosition, y: scrollViewYPosition, width: 50, height: 20 )
            let button = UIButton(frame: frame1)
            button.setTitle(nameSelectedArray[i], forState: .Normal)
            
            button.backgroundColor = UIColor.clearColor()
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.blackColor().CGColor
            button.backgroundColor = UIColor.blackColor()
            button.titleLabel?.font = UIFont(name:"HelveticaNeue", size:8)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NewMessageViewController.nameDoubleTapped(_:)))
            tapGesture.numberOfTapsRequired = 2
            button.addGestureRecognizer(tapGesture)
            button.tag = i
            
            
            let frame2 = CGRect(x: scrollViewXPosition+50, y: scrollViewYPosition, width: 6, height: 6 )
            let cancelButton = UIButton(frame: frame2)
            cancelButton.layer.cornerRadius = 0.5 * button.bounds.size.width
            cancelButton.setImage(UIImage(named:"iconCancel.png"), forState: .Normal)
            cancelButton.addTarget(self, action: #selector(NewMessageViewController.removeNameTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            cancelButton.tag = i
            self.scrollView.addSubview(cancelButton)
            self.scrollView.addSubview(button)
        }
        noOfnamesSelected = nameSelectedArray.count
        if nameIdSelectedArray.count == 0{
            self.sendButon.userInteractionEnabled = false
            self.sendButon.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        }
    }

    



}
