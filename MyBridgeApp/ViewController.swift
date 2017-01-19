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
   var geoPoint:PFGeoPoint?
    
    @IBOutlet weak var fbLoginButton: UIButton!
    @IBOutlet weak var appName: UILabel!

    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    //Login with Facebook button tapped
    @IBAction func fbLogin(_ sender: AnyObject) { 
        
        print("pressed")
        // Spinner sparts animating before the segue can be accesses
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0.475*screenWidth,y: 0.16*screenHeight,width: 0.05*screenWidth,height: 0.05*screenWidth))
        //activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        fbLoginButton.backgroundColor = UIColor.clear
        
        var global_name:String = ""
        
        let localData = LocalData()
        
        //setting first Time Swiping Right to true so the user will be notified of what swiping does for their first swipe
        localData.setFirstTimeSwipingRight(true)
        
        //setting first Time SwipingRight to true so the user will be notified of what swiping does for their first swipe
        localData.setFirstTimeSwipingLeft(true)
        
        //setting hasSignedUp to false so the user will be sent back to the signUp page if they have not completed signing up
        let hasSignedUp:Bool = localData.getHasSignedUp() ?? false
        localData.setHasSignedUp(hasSignedUp)
        localData.synchronize()
        
        //Log user in with permissions public_profile, email and user_friends
        let permissions = ["public_profile", "email", "user_friends"]
        PFFacebookUtils.logInInBackground(withReadPermissions: permissions) { (user, error) in
            print("got past permissions")
            if let error = error {
                print(error)
                print("got to error")
            } else {
                if let user = user {
                    print("got user")
                    /* Check if the global variable geoPoint has been set to the user's location. If so, store it in Parse. Extremely important since the location would be used to get the user's current city in LocalUtility().getBridgePairings() which is indeed called in SignupViewController - cIgAr 08/18/16 */
                    if let geoPoint = self.geoPoint {
                        PFUser.current()?["location"] = geoPoint
                        PFUser.current()?.saveInBackground()
                    }
                    // identify user id with the device
                    let installation = PFInstallation.current()
                    //installation.setDeviceTokenFromData(deviceToken)
                    installation["user"] = PFUser.current()
                    installation["userObjectId"] = PFUser.current()?.objectId
                    installation.saveInBackground()
                    
                    LocalStorageUtility().getUserFriends()
                    
                    if user.isNew {
                        
                        //sync profile picture with facebook profile picture
                        LocalStorageUtility().getMainProfilePicture()
                        
                        print("got to new user")
                        let localData = LocalData()
                        
                        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, interested_in, name, gender, email, friends, birthday, location"])
                        graphRequest!.start { (connection, result, error) -> Void in
                            print("got into graph request")
                            
                            if error != nil {
                                
                                print(error!)
                                print("got error")
                                
                            } else if let result = result as? [String: AnyObject]{
                                // saves these to parse at every login
                                print("got result")
                                var hasInterestedIn = false
                                if let interested_in = result["interested_in"] {
                                    localData.setInterestedIn(interested_in as! String)
                                    PFUser.current()?["interested_in"] = interested_in
                                    hasInterestedIn = true
                                }
                                
                                
                                if let gender: String = result["gender"]! as? String {
                                    PFUser.current()?["gender"] = gender
                                    PFUser.current()?["fb_gender"] = gender
                                    //saves a guess at the gender the current user is interested in if it doesn't already exist
                                    if hasInterestedIn == false {
                                        if gender == "male" {
                                            PFUser.current()?["interested_in"] = "female"
                                        } else if gender == "female" {
                                            PFUser.current()?["interested_in"] = "male"
                                        }
                                    }
                                }
                                
                                //setting main name and names for Bridge Types to Facebook name
                                if let name = result["name"] {
                                    global_name = name as! String
                                    // Store the name in core data 06/09
                                    localData.setUsername(global_name)
                                    PFUser.current()?["fb_name"] = name
                                    PFUser.current()?["name"] = name
                                    //PFUser.current()?["business_name"] = name
                                    //PFUser.current()?["love_name"] = name
                                    //PFUser.current()?["friendship_name"] = name
                                }
                                if let email = result["email"] {
                                    PFUser.current()?["email"] = email
                                }
                                if let id = result["id"] {
                                    PFUser.current()?["fb_id"] =  id
                                }
                                
                                if let birthday = result["birthday"] {
                                    print(result["birthday"]!)
                                    print("birthday")
                                    //getting birthday from Facebook and calculating age
                                    PFUser.current()?["fb_birthday"] = birthday
                                    
                                    //getting age from Birthday
                                    let NSbirthday: Date = birthday as! Date
                                    let calendar: Calendar = Calendar.current
                                    let now = Date()
                                    let age = (calendar as NSCalendar).components(.year, from: NSbirthday, to: now, options: [])
                                    print(age)
                                    PFUser.current()?["age"] = age
                                }
                                
                                //Getting user friends from facebook and then updating the friend_list
                                if let friends = result["friends"]! as? NSDictionary {
                                    let friendsData : NSArray = friends.object(forKey: "data") as! NSArray
                                    var fbFriendIds = [String]()
                                    for friend in friendsData {
                                        let valueDict : NSDictionary = friend as! NSDictionary
                                        fbFriendIds.append(valueDict.object(forKey: "id") as! String)
                                    }
                                    PFUser.current()?["fb_friends"] = fbFriendIds
                                    PFUser.current()?.saveInBackground(block: { (success, error) in
                                        if error != nil {
                                            print(error!)
                                        } else {
                                            self.updateFriendList()
                                        }
                                    })
                                }

                                
                                PFUser.current()?["distance_interest"] = 100
                                PFUser.current()?["new_message_push_notifications"] = true
                                localData.setNewMessagesPushNotifications(true)
                                PFUser.current()?["new_bridge_push_notifications"] = true
                                localData.setNewBridgesPushNotifications(true)
                                PFUser.current()?["built_bridges"] = []
                                PFUser.current()?["rejected_bridges"] = []
                                PFUser.current()?["interested_in_business"] = true
                                PFUser.current()?["interested_in_love"] = true
                                PFUser.current()?["interested_in_friendship"] = true
                                PFUser.current()?["ran_out_of_pairs"] = 0
                                
                                PFUser.current()?.saveInBackground()
                               
                                //setting hasSignedUp to false so the user will be sent back to the signUp page if they have not completed signing up
                                localData.setHasSignedUp(false)
                                localData.synchronize()
                                
                                PFUser.current()?.saveInBackground(block: { (success, error) in
                                    if success == true {
                                        self.activityIndicator.stopAnimating()
                                        UIApplication.shared.endIgnoringInteractionEvents()
                                        self.performSegue(withIdentifier: "showSignUp", sender: self)
                                    } else {
                                        print(error ?? "error")
                                    }
                                })
                            }
                        }
                        
                    } else {
                        //spinner
                        //update user and friends
                        //use while access token is nil instead of delay
                         print("not new")
                        if let _ = (PFUser.current()?["name"]) as? String {
                            let localData = LocalData()
                            localData.setUsername((PFUser.current()?["name"])! as! String)
                            localData.synchronize()
                        }
                        let localData = LocalData()
                        if localData.getMainProfilePicture() == nil {
                            print("user is not new but we are getting his picture")
                            LocalStorageUtility().getMainProfilePictureFromParse()
                        }
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { () -> Void in
                            //stop the spinner animation and reactivate the interaction with user
                            self.activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                            
                            if hasSignedUp == true {
                                self.performSegue(withIdentifier: "showBridgeViewController", sender: self)
                            } else {
                                self.performSegue(withIdentifier: "showSignUp", sender: self)
                            }
                            
                         })
                    }
                    
                    
                    
                } else {
                    print("there is no user")
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            }
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    /* This was me experimenting with coreData. Leaving it here if someone wants to have a look - cIgAr - 08/18/16
    func seedUsers(){
        print("seedUsers method called")
        let moc = DataController().managedObjectContext
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Users", into: moc) as! Users
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
        let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        do {
            let fetchUser = try moc.fetch(userFetch) as! [Users]
            print(fetchUser.first!.name)
            
        }
        catch{
            fatalError("failure to fetch user: \(error)")
        }
    }*/
    
    //right now just updates users Friends
    /* Why is this in viewDidAppear? I'm leaving it here for historical reasons - cIgAr - 08/18/16*/
    func updateUser() {
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "friends"])
        _ = graphRequest?.start { (connection, result, error) -> Void in
            if error != nil {
                
                print(error!)
                
            } else if let result = result as? [String:AnyObject]{
                
                if let friends = result["friends"]! as? NSDictionary {
                    let friendsData : NSArray = friends.object(forKey: "data") as! NSArray
                    var fbFriendIds = [String]()
                    for friend in friendsData {
                        let valueDict : NSDictionary = friend as! NSDictionary
                        fbFriendIds.append(valueDict.object(forKey: "id") as! String)
                    }
                    PFUser.current()?["fb_friends"] = fbFriendIds
                    PFUser.current()?.saveInBackground(block: { (success, error) in
                        if error != nil {
                            print(error!)
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
        
        let currentUserFbFriends = PFUser.current()!["fb_friends"] as! NSArray
        let query: PFQuery = PFQuery(className: "_User")
        
        query.whereKey("fb_id", containedIn: currentUserFbFriends as [AnyObject])
        
        query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
            if error != nil {
                print(error!)
            } else if let objects = objects {
                PFUser.current()?.fetchInBackground(block: { (success, error) in
                    for object in objects {
                        var containedInFriendList = false
                        if let friendList: NSArray = PFUser.current()!["friend_list"] as? NSArray {
                            //This was exchanged for the following in Swift3 migration -> containedInFriendList = friendList.contains {$0 as! String == object.objectId!}
                            containedInFriendList = friendList.contains(object.objectId!)
                        }
                        if containedInFriendList == false {
                            if PFUser.current()!["friend_list"] != nil {
                                let currentFriendList = PFUser.current()!["friend_list"]
                                PFUser.current()!["friend_list"] = currentFriendList as! Array + [object.objectId!]
                            } else {
                                PFUser.current()!["friend_list"] = [object.objectId!]
                            }
                        }
                        PFUser.current()?.saveInBackground()
                    }
                })
            }
        })
    }
    
    func storeUserLocationOnParse(_ notification: Notification) {
        print("storeUserLocationOnParse - \((notification as NSNotification).userInfo)")
        let geoPoint = (notification as NSNotification).userInfo!["geoPoint"] as? PFGeoPoint
        if let geoPoint = geoPoint {
            self.geoPoint = geoPoint
            print(geoPoint)
        } else {
            //self.geoPoint = PFGeoPoint.init(latitude: 0.0, longitude: 0.0)
            print("initialize PFGeoPoint at 0,0")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Listen for a notification from LoadPageViewController when it has got the user's location. cIgaR 08/18/16
        NotificationCenter.default.addObserver(self, selector: #selector(self.storeUserLocationOnParse), name: NSNotification.Name(rawValue: "storeUserLocationOnParse"), object: nil)
        fbLoginButton.setTitleColor(UIColor(red: 255/255, green: 230/255, blue: 57/255, alpha: 1.0), for: UIControlState.highlighted)
        fbLoginButton.setTitleColor(UIColor.white, for: UIControlState())
        fbLoginButton.layer.cornerRadius = 7.0
        fbLoginButton.layer.borderWidth = 4.0
        fbLoginButton.layer.borderColor = UIColor(red: 255/255, green: 230/255, blue: 57/255, alpha: 1.0).cgColor
        fbLoginButton.clipsToBounds = true
        let appDescriptions = UILabel(frame: CGRect(x: 0.05*screenWidth, y: 0.49*screenHeight, width: 0.90*screenWidth, height: 0.15*screenHeight))
        appDescriptions.textAlignment = NSTextAlignment.center
        appDescriptions.text = "Connect your friends with the people they are looking for"
        appDescriptions.font = UIFont(name: "BentonSans", size: 24)
        appDescriptions.textColor = UIColor.white
        appDescriptions.numberOfLines = 0
        self.view.addSubview(appDescriptions)
        
        let label = UILabel(frame: CGRect(x: 0.05*screenWidth, y: 0.775*screenHeight, width: 0.9*screenWidth, height: 0.075*screenHeight))
        //label.center = CGPointMake(160, 284)
        label.textAlignment = NSTextAlignment.center
        label.text = "No need to get sour! We never post to Facebook."
        label.font = UIFont(name: "BentonSans", size: 14)
        label.textColor = UIColor.white
        label.numberOfLines = 0
        self.view.addSubview(label)
        
        let appDescriptionsArray = ["'nect your friends with the people they are looking for", "Discover the sweetness of your community", "Be the 'necter you wish to see in the world"]
        
        DispatchQueue.global().async
		{
            var i = 1
            while i < 10 {
                sleep(4)
                DispatchQueue.main.async(execute: {
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
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

