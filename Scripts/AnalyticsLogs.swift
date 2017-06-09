//
//  AnalyticsLogs.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 5/10/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import Firebase
import FBSDKCoreKit

class AnalyticsLogs {
    
    static func swiped (title: String, userObjectID: String) {
        print("Firebase recorded swipe")
        FIRAnalytics.logEvent(withName: kFIREventSelectContent, parameters: [
            kFIRParameterItemID: "id-\(userObjectID)" as NSObject,
            kFIRParameterItemName: "swipe" as NSObject,
            kFIRParameterContentType: title as NSObject
            ])
        
        // logging swipeRight and swipeLeft event with FBSDK
        FBSDKAppEvents.logEvent(title)
    }
    
    static func loggedIn (userObjectID: String) {
        print("Firebase recorded login")
        FIRAnalytics.logEvent(withName: kFIREventLogin, parameters: [
            kFIRParameterItemID: "id-\(userObjectID)" as NSObject,
            kFIRParameterItemName: "login" as NSObject,
            kFIRParameterContentType: "login"as NSObject
            ])
        
        // logging login event with FBSDK
        FBSDKAppEvents.logEvent("login")
    }
    
    static func signedUp (userObjectID: String) {
        print("Firebase recorded signup")
        FIRAnalytics.logEvent(withName: kFIREventSignUp, parameters: [
            kFIRParameterItemID: "id-\(userObjectID)" as NSObject,
            kFIRParameterItemName: "signup" as NSObject,
            kFIRParameterContentType: "signup"as NSObject
            ])
        
        // logging signup event with FBSDK
        FBSDKAppEvents.logEvent("signup")
    }
}
