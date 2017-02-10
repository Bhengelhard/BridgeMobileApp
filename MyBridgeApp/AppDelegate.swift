import UIKit
import CoreData
import Parse
import FBSDKCoreKit
import FBSDKLoginKit
import ParseFacebookUtilsV4

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //--------------------------------------
    // MARK: - UIApplicationDelegate
    //--------------------------------------

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Enable storing and querying data from Local Datastore.
        // Remove this line if you don't want to use Local Datastore features or want to use cachePolicy.
        Parse.enableLocalDatastore()
        
        let parseConfiguration = ParseClientConfiguration(block: { (ParseMutableClientConfiguration) -> Void in
            ParseMutableClientConfiguration.applicationId = "mybridgeapp3498735421846jhlkjsdhf23d"
            ParseMutableClientConfiguration.clientKey = "euchnfbe73723ndn77sdkj3763"
            ParseMutableClientConfiguration.server = "https://mybridgeapp.herokuapp.com/parse"
        })
        
        Parse.initialize(with: parseConfiguration)


        // ****************************************************************************
        // Uncomment and fill in with your Parse credentials:
        // Parse.setApplicationId("your_application_id", clientKey: "your_client_key")
        //
        // If you are using Facebook, uncomment and add your FacebookAppID to your bundle's plist as
        // described here: https://developers.facebook.com/docs/getting-started/facebook-sdk-for-ios/
        // Uncomment the line inside ParseStartProject-Bridging-Header and the following line here:
        // PFFacebookUtils.initializeFacebook()
        // ****************************************************************************
        
        PFFacebookUtils.initializeFacebook(applicationLaunchOptions: launchOptions)

        PFUser.enableAutomaticUser()

        let defaultACL = PFACL();

        // If you would like all objects to be private by default, remove this line.
        defaultACL.getPublicReadAccess = true

        PFACL.setDefault(defaultACL, withAccessForCurrentUser: true)

        if application.applicationState != UIApplicationState.background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.

            let preBackgroundPush = !application.responds(to: #selector(getter: UIApplication.backgroundRefreshStatus))
            let oldPushHandlerOnly = !self.responds(to: #selector(UIApplicationDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:)))
            var noPushPayload = false;
            if let options = launchOptions {
                noPushPayload = options[UIApplicationLaunchOptionsKey.remoteNotification] != nil;
            }
            if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
                PFAnalytics.trackAppOpened(launchOptions: launchOptions)
            }
        }
        let types: UIUserNotificationType = [.alert, .badge, .sound]
        let settings = UIUserNotificationSettings(types: types, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()

        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    //--------------------------------------
    // MARK: Push Notifications
    //--------------------------------------

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let installation = PFInstallation.current()
        installation.setDeviceTokenFrom(deviceToken)
        installation.saveInBackground()

        PFPush.subscribeToChannel(inBackground: "") { (succeeded: Bool, error: Error?) in
            if succeeded {
                print("ParseStarterProject successfully subscribed to push notifications on the broadcast channel.\n");
            } else {
                print("ParseStarterProject failed to subscribe to push notifications on the broadcast channel with error = %@.\n", error!)
            }
        }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        if error._code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.\n")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@\n", error)
        }
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("Listener is set at didReceiveRemoteNotification")
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadTheThread"), object: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadTheMessageTable"), object: nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateBridgePage"), object: nil, userInfo: userInfo)
        
        //Segueing to Appropriate View
        let messageType = userInfo["messageType"] as? String
        let messageId = userInfo["messageId"] as? String
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if messageType == "ConnecterNotification" {
            //Segue to SingleMessageViewController
            let vc: BridgeViewController = storyboard.instantiateViewController(withIdentifier: "BridgeViewController") as! BridgeViewController
            if application.applicationState == UIApplicationState.inactive {
                print("UIApplicationState.Inactive but ")
                self.window?.rootViewController = vc
            }else if application.applicationState == UIApplicationState.background {
                print("UIApplicationState.Background")
            }else if application.applicationState == UIApplicationState.active {
                print("UIApplicationState.Active")
            }
            else{
                print("None")
            }

        }
         else if messageId != nil {
            //Segue to SingleMessageViewController
            let vc: SingleMessageViewController = storyboard.instantiateViewController(withIdentifier: "SingleMessageViewController") as! SingleMessageViewController
            vc.newMessageId = messageId!
            if application.applicationState == UIApplicationState.inactive {
                print("UIApplicationState.Inactive but ")
                self.window?.rootViewController = vc
            }else if application.applicationState == UIApplicationState.background {
                print("UIApplicationState.Background")
            }else if application.applicationState == UIApplicationState.active {
                print("UIApplicationState.Active")
            }
            else{
                print("None")
            }
        } else {
            //Segue to MessagesViewController -> this should be accept/ignore
            let vc: MessagesViewController = storyboard.instantiateViewController(withIdentifier: "MessagesViewController") as! MessagesViewController
            if application.applicationState == UIApplicationState.inactive {
                print("UIApplicationState.Inactive but ")
                self.window?.rootViewController = vc
            }else if application.applicationState == UIApplicationState.background {
                print("UIApplicationState.Background")
            }else if application.applicationState == UIApplicationState.active {
                print("UIApplicationState.Active")
            }
            else{
                print("None")
            }
        }
        //Segue to accepted connection notification
        
        //PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.inactive {
            PFAnalytics.trackAppOpened(withRemoteNotificationPayload: userInfo)
        }
    }

    //--------------------------------------
    // MARK: Facebook SDK Integration
    //--------------------------------------
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
        
        print("applicationDidBecomeActive")
        
        //Checking Reachability of internet access
        let reachability = Reachability()
        let isconnectedToNetwork = reachability.connectedToNetwork()
        
        //If the user is not connected to a network, then display an alert indicating the issue that cannot be dismissed unless the user connects to a network
        if isconnectedToNetwork == false {
            let alert = UIAlertController(title: "Not connected to internet", message: "To continue 'necting, please connect to a network.", preferredStyle: UIAlertControllerStyle.alert)
            
            if let window = self.window {
                print("is correct window")
                if let vc = window.rootViewController {
                    print("is inputViewController")
                    vc.present(alert, animated: true, completion: nil)
                }
            }
        }
        print("The current User's device \(isconnectedToNetwork)")
        
        
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.Blake.Bridge" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "Bridge", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
}
