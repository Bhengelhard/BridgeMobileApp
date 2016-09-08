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
    class func load(URL: NSURL, imageView:UIImageView, bridgePairingObjectId: String?, isUpperDeckCard: Bool) {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "GET"
        let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if (error == nil && data != nil) {
                
                
                //applying filter to make the white text more legible
                let beginImage = CIImage(data: data!)
                let edgeDetectFilter = CIFilter(name: "CIVignetteEffect")!
                edgeDetectFilter.setValue(beginImage, forKey: kCIInputImageKey)
                edgeDetectFilter.setValue(0.2, forKey: "inputIntensity")
                edgeDetectFilter.setValue(0.2, forKey: "inputRadius")
                
                //edgeDetectFilter.setValue(CIImage(image: edgeDetectFilter.outputImage!), forKey: kCIInputImageKey)
                let newCGImage = CIContext(options: nil).createCGImage(edgeDetectFilter.outputImage!, fromRect: (edgeDetectFilter.outputImage?.extent)!)
                
                if let pairings = LocalData().getPairings() {
                    for pair in pairings {
                        if pair.user1?.objectId == bridgePairingObjectId {
                            if isUpperDeckCard {
                                pair.user1?.savedProfilePicture = data
                            }
                            else {
                                pair.user2?.savedProfilePicture = data
                            }
                            let localData = LocalData()
                            localData.setPairings(pairings)
                            localData.synchronize()
                        }
                    }
                }
                
                
                let newImage = UIImage(CGImage: newCGImage)
                
                dispatch_async(dispatch_get_main_queue(), {
                    //imageView.image = UIImage(data: data!)
                    imageView.alpha = 0
                    imageView.image = newImage
                    UIView.animateWithDuration(0.2, animations: {
                        imageView.alpha = 1
                    })
                    imageView.contentMode = UIViewContentMode.ScaleAspectFill
                    imageView.clipsToBounds = true

                })

            }
            else {
                // Failure
                print("Failure: %@", error!.localizedDescription);
            }
        })
        task.resume()
    }
    
    class func loadBothUrls(URL1: NSURL, URL2: NSURL, imageView1:UIImageView, imageView2:UIImageView, superDeckView:UIView) {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request1 = NSMutableURLRequest(URL: URL1)
        let request2 = NSMutableURLRequest(URL: URL1)
        var image1:UIImage? = nil
        var image2:UIImage? = nil
        request1.HTTPMethod = "GET"
        request2.HTTPMethod = "GET"
        let task = session.dataTaskWithRequest(request1, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if (error == nil && data != nil) {
                
                //applying filter to make the white text more legible
                let beginImage = CIImage(data: data!)
                let edgeDetectFilter = CIFilter(name: "CIVignetteEffect")!
                edgeDetectFilter.setValue(beginImage, forKey: kCIInputImageKey)
                edgeDetectFilter.setValue(0.1, forKey: "inputIntensity")
                edgeDetectFilter.setValue(0.2, forKey: "inputRadius")
                
                image1 = UIImage(CIImage: edgeDetectFilter.outputImage!)
                
                //img2.image = newImage
                
                
            }
            else {
                // Failure
                print("Failure: %@", error!.localizedDescription);
            }
            
            let task1 = session.dataTaskWithRequest(request2, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                if (error == nil && data != nil) {
                    
                    //applying filter to make the white text more legible
                    let beginImage = CIImage(data: data!)
                    let edgeDetectFilter = CIFilter(name: "CIVignetteEffect")!
                    edgeDetectFilter.setValue(beginImage, forKey: kCIInputImageKey)
                    edgeDetectFilter.setValue(0.1, forKey: "inputIntensity")
                    edgeDetectFilter.setValue(0.2, forKey: "inputRadius")
                    
                    image2 = UIImage(CIImage: edgeDetectFilter.outputImage!)
                    
                    //img2.image = newImage
                    
                    
                }
                else {
                    // Failure
                    print("Failure: %@", error!.localizedDescription);
                }
                dispatch_async(dispatch_get_main_queue(), {
                    //imageView.image = UIImage(data: data!)
                    imageView1.alpha = 0
                    imageView1.image = image2
                    
                })
                
            })
            task1.resume()
        })
        task.resume()
    }

}
