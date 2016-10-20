//
//  PFCloudFunctions.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 10/14/16.
//  Copyright © 2016 BHE Ventures. All rights reserved.
//
//This class is a helper class to store the PFCloud functions stored in the server-side file main.js

import UIKit
import Parse

class PFCloudFunctions {
    
    func revitalizeMyPairs(parameters: [AnyHashable: Any]?) {
        PFCloud.callFunction(inBackground: "revitalizeMyPairs", withParameters: parameters, block: {
            (response: Any?, error: Error?) in
            if error == nil {
                if let response = response as? String {
                    print(response)
                    //sends notification to call displayMessageFromBot function
                    let userInfo = ["message" : "Your pairs were revitalized"]
                    //self.didSendPost = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "revitalizeMyPairsHelper"), object: nil, userInfo: userInfo)
                } else {
                    //sends notification to call displayMessageFromBot function
                    let userInfo = ["message" : "Your pairs did not revitalize"]
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "revitalizeMyPairsHelper"), object: nil, userInfo: userInfo)
                }
            }
        })
    }
}
