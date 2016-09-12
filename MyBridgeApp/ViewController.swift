import UIKit
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4
import FBSDKLoginKit
import CoreData
import CoreLocation
//var user1 = PFUser()
//var currentUser = PFUser.currentUser()

class ViewController: UIViewController {
   
    
    @IBOutlet weak var fbLoginButton: UIButton!
    @IBOutlet weak var appName: UILabel!

    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var geoPoint:PFGeoPoint?
    
    //Login with Facebook button tapped
    @IBAction func fbLogin(sender: AnyObject) { 
        
        print("pressed")
        // Spinner sparts animating before the segue can be accesses
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0.475*screenWidth,0.16*screenHeight,0.05*screenWidth,0.05*screenWidth))
        //activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        fbLoginButton.backgroundColor = UIColor.clearColor()
        
        var global_name:String = ""
        
        let localData = LocalData()
        
        //setting first Time Swiping Right to false so the user will be notified of what swiping does for their first swipe
        localData.setFirstTimeSwipingRight(true)
        localData.synchronize()
        
        //setting first Time SwipingRight to false so the user will be notified of what swiping does for their first swipe
        localData.setFirstTimeSwipingLeft(true)
        localData.synchronize()
        
        //Log user in with permissions public_profile, email and user_friends
        let permissions = ["public_profile", "email", "user_friends"]
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) { (user, error) in
            print("got past permissions")
            if let error = error {
                print(error)
                print("got to error")
            } else {
                if let user = user {
                    print("got user")
                    /* Check if the global variable geoPoint has been set to the user's location. If so, store it in Parse. Extremely important since the location would be used to get the user's current city in LocalUtility().getBridgePairings() which is indeed called in SignupViewController - cIgAr 08/18/16 */
                    if let geoPoint = self.geoPoint {
                    PFUser.currentUser()?["location"] = geoPoint
                    PFUser.currentUser()?.saveInBackground()
                    }
                    // identify user id with the device
                    let installation = PFInstallation.currentInstallation()
                    //installation.setDeviceTokenFromData(deviceToken)
                    installation["user"] = PFUser.currentUser()
                    installation["userObjectId"] = PFUser.currentUser()?.objectId
                    installation.saveInBackground()
                    
                    LocalStorageUtility().getUserFriends()
                    
                    if user.isNew {
                        //sync profile picture with facebook profile picture
                        LocalStorageUtility().getMainProfilePicture()
                        
                        print("got to new user")
                        let localData = LocalData()
                        
                        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, interested_in, name, gender, email, friends, birthday, location"])
                        graphRequest.startWithCompletionHandler { (connection, result, error) -> Void in
                            print("got into graph request")
                            
                            if error != nil {
                                
                                print(error)
                                print("got error")
                                
                            } else if let result = result {
                                // saves these to parse at every login
                                print("got result")
                                if let interested_in = result["interested_in"]! {
                                    
                                    localData.setInterestedIN(interested_in as! String)
                                    PFUser.currentUser()?["interested_in"] = interested_in
                                }
                                
                                if let gender: String = result["gender"]! as? String {
                                    
                                    PFUser.currentUser()?["gender"] = gender
                                    PFUser.currentUser()?["fb_gender"] = gender
                                    //saves a guess at the gender the current user is interested in if it doesn't already exist
                                if result["interested_in"]! == nil {
                                    
                                    if gender == "male" {
                                        
                                        PFUser.currentUser()?["interested_in"] = "female"
                                        
                                    } else if gender == "female" {
                                            
                                        PFUser.currentUser()?["interested_in"] = "male"
                                    }
                                        
                                }
                                    
                                    
                                }
                                
                                //setting main name and names for Bridge Types to Facebook name
                                if let name = result["name"]! {
                                    // Store the name in core data 06/09
                                    
                                    global_name = name as! String
                                    localData.setUsername(global_name)
                                    PFUser.currentUser()?["fb_name"] = name
                                    PFUser.currentUser()?["name"] = name
                                    PFUser.currentUser()?["business_name"] = name
                                    PFUser.currentUser()?["love_name"] = name
                                    PFUser.currentUser()?["friendship_name"] = name
                                                                       
                                }
                                
                                if let email = result["email"]! {
                                    
                                    PFUser.currentUser()?["email"] = email
                                }
                                
                                if let id = result["id"]! {
                                    
                                    PFUser.currentUser()?["fb_id"] =  id
                                    
                                }
                                
                                if let birthday = result["birthday"]! {
                                    
                                    print(result["birthday"]!)
                                    print("birthday")
                                    //getting birthday from Facebook and calculating age
                                    PFUser.currentUser()?["fb_birthday"] = birthday
                                    //newUser.setValue(birthday, forKey: "fb_birthday")
                                    let NSbirthday: NSDate = birthday as! NSDate
                                    let calendar: NSCalendar = NSCalendar.currentCalendar()
                                    let now = NSDate()
                                    let age = calendar.components(.Year, fromDate: NSbirthday, toDate: now, options: [])
                                    
                                    print(age)
                                    
                                    PFUser.currentUser()?["age"] = age
                                    //newUser.setValue(age, forKey: "age")
                                    
                                }
                                // Commenting this out since we are using Apple's Location Manager Services to get the user's location. In the graph request above we are still requesting for the user's location which is kind of useless now. cIgaR - 08/18/16
                                //if let location = result["location"]! {
                                //    print("location")
                                //    PFUser.currentUser()?["fb_location"] = location
                                    
                                //}
                                

                                
                                PFUser.currentUser()?["distance_interest"] = 100
                                PFUser.currentUser()?["new_message_push_notifications"] = true
                                localData.setNewMessagesPushNotifications(true)
                                PFUser.currentUser()?["new_bridge_push_notifications"] = true
                                localData.setNewBridgesPushNotifications(true)
                                PFUser.currentUser()?["built_bridges"] = []
                                PFUser.currentUser()?["rejected_bridges"] = []
                                PFUser.currentUser()?["interested_in_business"] = true
                                PFUser.currentUser()?["interested_in_love"] = true
                                PFUser.currentUser()?["interested_in_friendship"] = true

                                PFUser.currentUser()?.saveInBackground()
                               
                                //LocalStorageUtility().getBridgePairings()
                                localData.synchronize()
                                
                                
                                PFUser.currentUser()?.saveInBackgroundWithBlock({ (success, error) in
                                    
                                    if success == true {
                                        self.activityIndicator.stopAnimating()
                                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                                        self.performSegueWithIdentifier("showSignUp", sender: self)
                                        
                                    } else {
                                        
                                        print(error)
                                        
                                    }
                                    
                                })

                                
                                
                            }
                            
                            
                        }
                        
                    } else {
                        //spinner
                        //update user and friends
                        //use while access token is nil instead of delay
                         print("not new")
                        if let _ = (PFUser.currentUser()?["name"]) as? String {
                            let localData = LocalData()
                            localData.setUsername((PFUser.currentUser()?["name"])! as! String)
                            localData.synchronize()
                        }
                        let localData = LocalData()
                        if localData.getMainProfilePicture() == nil {
                            print("user is not new but we are getting his picture")
                            LocalStorageUtility().getMainProfilePictureFromParse()
                        }
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                            //stop the spinner animation and reactivate the interaction with user
                            self.activityIndicator.stopAnimating()
                            UIApplication.sharedApplication().endIgnoringInteractionEvents()
                            
                            self.performSegueWithIdentifier("showBridgeViewController", sender: self)
                         })
                    }
                    
                    
                    
                } else {
                    print("there is no user")
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()

                }
            }
        }
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    /* This was me experimenting with coreData. Leaving it here if someone wants to have a look - cIgAr - 08/18/16*/
    func seedUsers(){
        print("seedUsers method called")
        let moc = DataController().managedObjectContext
        let entity = NSEntityDescription.insertNewObjectForEntityForName("Users", inManagedObjectContext: moc) as! Users
        entity.setValue("Udta Punjab", forKey: "name")
        entity.setValue("/home/picture", forKey: "profilePicture")
        do{
            try moc.save()
        }
        catch {
            fatalError("failure to save context:\(error)")
            
        }
    }
    /* This was me experimenting with coreData. Leaving it here if someone wants to have a look - cIgAr - 08/18/16*/
    func fetchUsers(){
        print("fetchUsers method called")
        let moc = DataController().managedObjectContext
        let userFetch = NSFetchRequest(entityName: "Users")
        do {
            let fetchUser = try moc.executeFetchRequest(userFetch) as! [Users]
            print(fetchUser.first!.name)
            
        }
        catch{
            fatalError("failure to fetch user: \(error)")
        }
    }
    
    //right now just updates users Friends
    /* Why is this in viewDidAppear? I'm leaving it here for historical reasons - cIgAr - 08/18/16*/
    func updateUser() {
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "friends"])
        graphRequest.startWithCompletionHandler { (connection, result, error) -> Void in
            if error != nil {
                
                print(error)
                
            } else if let result = result {
                
                if let friends = result["friends"]! as? NSDictionary {
                    
                    let friendsData : NSArray = friends.objectForKey("data") as! NSArray
                    
                    var fbFriendIds = [String]()
                    
                    for friend in friendsData {
                        
                        let valueDict : NSDictionary = friend as! NSDictionary
                        fbFriendIds.append(valueDict.objectForKey("id") as! String)
                        
                    }
                    
                    
                    PFUser.currentUser()?["fb_friends"] = fbFriendIds
                    
                    PFUser.currentUser()?.saveInBackgroundWithBlock({ (success, error) in
                        
                        if error != nil {
                            
                            print(error)
                            
                        } else {
                            
                            self.updateFriendList()
                            
                        }
                        
                    })
                    
                }
                
            }
        
        }
        
    }
    /* Why is this in viewDidAppear? I'm leaving it here for historical reasons - cIgAr - 08/18/16*/
    func updateFriendList() {
        //add graph request to update users fb_friends
        //query to find and save fb_friends
        
        let currentUserFbFriends = PFUser.currentUser()!["fb_friends"] as! NSArray
        let query: PFQuery = PFQuery(className: "_User")
        
        query.whereKey("fb_id", containedIn: currentUserFbFriends as [AnyObject])
        
        query.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) in
            
            if error != nil {
                
                print(error)
                
            } else if let objects = objects {
                
                PFUser.currentUser()?.fetchInBackgroundWithBlock({ (success, error) in
                
                    for object in objects {
                    
                        var containedInFriendList = false
                        
                        if let friendList: NSArray = PFUser.currentUser()!["friend_list"] as? NSArray {
                            
                            containedInFriendList = friendList.contains {$0 as! String == object.objectId!}
                            
                        }
                        
                        if containedInFriendList == false {
                            
                            if PFUser.currentUser()!["friend_list"] != nil {
                                
                                let currentFriendList = PFUser.currentUser()!["friend_list"]
                                PFUser.currentUser()!["friend_list"] = currentFriendList as! Array + [object.objectId!]
                                
                            } else {
                                
                                PFUser.currentUser()!["friend_list"] = [object.objectId!]
                                
                            }
                            
                        }
                        
                        PFUser.currentUser()?.saveInBackground()
                        
                    }
                    
                })
                
            }
            
        })
        
    }
    func storeUserLocationOnParse(notification: NSNotification) {
        print("storeUserLocationOnParse - \(notification.userInfo)")
        let geoPoint = notification.userInfo!["geoPoint"] as? PFGeoPoint
        if let geoPoint = geoPoint {
            self.geoPoint = geoPoint
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Listen for a notification from LoadPageViewController when it has got the user's location. cIgaR 08/18/16
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.storeUserLocationOnParse), name: "storeUserLocationOnParse", object: nil)
        fbLoginButton.setTitleColor(UIColor(red: 255/255, green: 230/255, blue: 57/255, alpha: 1.0), forState: UIControlState.Highlighted)
        
        fbLoginButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        fbLoginButton.layer.cornerRadius = 7.0
        fbLoginButton.layer.borderWidth = 4.0
        fbLoginButton.layer.borderColor = UIColor(red: 255/255, green: 230/255, blue: 57/255, alpha: 1.0).CGColor
        fbLoginButton.clipsToBounds = true
        let appDescriptions = UILabel(frame: CGRectMake(0.05*screenWidth, 0.49*screenHeight, 0.90*screenWidth, 0.15*screenHeight))
        appDescriptions.textAlignment = NSTextAlignment.Center
        appDescriptions.text = "Connect your friends with the people they are looking for"
        appDescriptions.font = UIFont(name: "BentonSans", size: 24)
        appDescriptions.textColor = UIColor.whiteColor()
        appDescriptions.numberOfLines = 0
        self.view.addSubview(appDescriptions)
        
        
        let label = UILabel(frame: CGRectMake(0.05*screenWidth, 0.775*screenHeight, 0.9*screenWidth, 0.075*screenHeight))
        //label.center = CGPointMake(160, 284)
        label.textAlignment = NSTextAlignment.Center
        label.text = "No need to get sour! We never post to Facebook."
        label.font = UIFont(name: "BentonSans", size: 14)
        label.textColor = UIColor.whiteColor()
        label.numberOfLines = 0
        self.view.addSubview(label)
        
        let appDescriptionsArray = ["Connect your friends with the people they are looking for", "Discover the sweetness of your community", "Be the (con)necter you wish to see in the world"]
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            var i = 1
            while i < 10 {
                sleep(4)
                dispatch_async(dispatch_get_main_queue(), {
                appDescriptions.text = appDescriptionsArray[i % appDescriptionsArray.count]
                i += 1
                })
            }
            
        }
        
        /*let delay2 = (2 * seconds + 1) * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime2 = dispatch_time(DISPATCH_TIME_NOW, Int64(delay2))
        
        dispatch_after(dispatchTime2, dispatch_get_main_queue(), {
            
            appDescriptions.text = "Be the (con)necter you wish to see in the world"
            
        })*/
        
    }
    
    override func viewDidLayoutSubviews() {
        
        appName.frame = CGRect(x: 0.1*screenWidth, y:0.36*screenHeight, width:0.80*screenWidth, height:0.15*screenHeight)
        fbLoginButton.frame = CGRect(x:0.16*screenWidth, y:0.7*screenHeight, width:0.68*screenWidth, height:0.075*screenHeight)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

