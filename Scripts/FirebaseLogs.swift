//
//  FirebaseLogs.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 5/10/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Firebase

class FirebaseLogs {
    
    static func swiped (title: String) {
        FIRAnalytics.logEvent(withName: kFIREventSelectContent, parameters: [
            kFIRParameterItemID: "id-\(title)" as NSObject,
            kFIRParameterItemName: title as NSObject,
            kFIRParameterContentType: "swipe" as NSObject
            ])
    }
    
}
