//
//  Downloader.swift
//  MyBridgeApp
//
//  Created by Sagar Sinha on 8/24/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation
import UIKit
class Downloader {
    class func load(URL: NSURL, imageView:UIImageView) {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "GET"
        let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if (error == nil && data != nil) {
                
                dispatch_async(dispatch_get_main_queue(), {
                    imageView.image = UIImage(data: data!)
                })

            }
            else {
                // Failure
                print("Failure: %@", error!.localizedDescription);
            }
        })
        task.resume()
    }
}
