//
//  FirebaseLogs.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 5/10/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Firebase

class FirebaseLogs {
    
    static func swiped (title: String, userObjectID: String) {
        print("Firebase recorded swipe")
        FIRAnalytics.logEvent(withName: kFIREventSelectContent, parameters: [
            kFIRParameterItemID: "id-\(userObjectID)" as NSObject,
            kFIRParameterItemName: "swipe" as NSObject,
            kFIRParameterContentType: title as NSObject
            ])
    }
    
    static func loggedIn (userObjectID: String) {
        print("Firebase recorded login")
        FIRAnalytics.logEvent(withName: kFIREventLogin, parameters: [
            kFIRParameterItemID: "id-\(userObjectID)" as NSObject,
            kFIRParameterItemName: "login" as NSObject,
            kFIRParameterContentType: "login"as NSObject
            ])
    }
    
    static func signedUp (userObjectID: String) {
        print("Firebase recorded signup")
        FIRAnalytics.logEvent(withName: kFIREventSignUp, parameters: [
            kFIRParameterItemID: "id-\(userObjectID)" as NSObject,
            kFIRParameterItemName: "signup" as NSObject,
            kFIRParameterContentType: "signup"as NSObject
            ])
    }
}
