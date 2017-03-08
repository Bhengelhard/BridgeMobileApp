//
//  LoginBackend.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 3/8/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Parse

class LoginBackend {
    
    // Update Facebook Friends and Return whether user is SignedIn
    func authenticateUser(vc: UIViewController) {
        print("authenticating User")
        //Updating the user's friends
        let fbFunctions = FacebookFunctions()
        fbFunctions.updateFacebookFriends()
        
        //Checking if user is already logged in
        do {
            try PFUser.current()?.fetch()
            print("fetched PFUser")
            if (PFUser.current()!.objectId) != nil {
                print("returning true")
                vc.performSegue(withIdentifier: "showSwipe", sender: self)
            }
            else {
                print("returning false")
            }
            
        } catch {
            print("caught and returned false")
        }
    }
}
