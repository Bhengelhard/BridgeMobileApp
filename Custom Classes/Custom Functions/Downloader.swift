//
//  Downloader.swift
//  MyBridgeApp
//
//  Created by Sagar Sinha on 8/24/16.
//  Copyright © 2016 BHE Ventures LLC. All rights reserved.
//

import Foundation
import UIKit

class Downloader {
    class func load(_ URL: Foundation.URL, imageView:UIImageView, bridgePairingObjectId: String?, isUpperDeckCard: Bool) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            if (error == nil && data != nil) {
                //applying filter to make the white text more legible
                let beginImage = CIImage(data: data!)
                let edgeDetectFilter = CIFilter(name: "CIVignetteEffect")!
                edgeDetectFilter.setValue(beginImage, forKey: kCIInputImageKey)
                edgeDetectFilter.setValue(0.2, forKey: "inputIntensity")
                edgeDetectFilter.setValue(0.2, forKey: "inputRadius")
                
                //edgeDetectFilter.setValue(CIImage(image: edgeDetectFilter.outputImage!), forKey: kCIInputImageKey)
                let newCGImage = CIContext(options: nil).createCGImage(edgeDetectFilter.outputImage!, from: (edgeDetectFilter.outputImage?.extent)!)
                
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
                
                
                let newImage = UIImage(cgImage: newCGImage!)
                
                DispatchQueue.main.async(execute: {
                    //imageView.image = UIImage(data: data!)
                    imageView.alpha = 0
                    imageView.image = newImage
                    UIView.animate(withDuration: 0.2, animations: {
                        imageView.alpha = 1
                    })
                    imageView.contentMode = UIViewContentMode.scaleAspectFill
                    imageView.clipsToBounds = true
                    
                })
                
            }
            else {
                // Failure
                print("Failure: %@", error!.localizedDescription);
            }
        }
        
        task.resume()
    }
    
    class func loadBothUrls(_ URL1: URL, URL2: URL, imageView1:UIImageView, imageView2:UIImageView, superDeckView:UIView) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        var request1 = URLRequest(url: URL1)
        var request2 = URLRequest(url: URL1)
        var image1:UIImage? = nil
        var image2:UIImage? = nil
        request1.httpMethod = "GET"
        request2.httpMethod = "GET"
        let task = session.dataTask(with: request1) { (data:Data?, response:URLResponse?, error:Error?) in
            if (error == nil && data != nil) {
                
                //applying filter to make the white text more legible
                let beginImage = CIImage(data: data!)
                let edgeDetectFilter = CIFilter(name: "CIVignetteEffect")!
                edgeDetectFilter.setValue(beginImage, forKey: kCIInputImageKey)
                edgeDetectFilter.setValue(0.1, forKey: "inputIntensity")
                edgeDetectFilter.setValue(0.2, forKey: "inputRadius")
                
                image1 = UIImage(ciImage: edgeDetectFilter.outputImage!)
                
                //img2.image = newImage
                
                
            }
            else {
                // Failure
                print("Failure: %@", error!.localizedDescription);
            }
            
            let task1 = session.dataTask(with: request2, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                if (error == nil && data != nil) {
                    
                    //applying filter to make the white text more legible
                    let beginImage = CIImage(data: data!)
                    let edgeDetectFilter = CIFilter(name: "CIVignetteEffect")!
                    edgeDetectFilter.setValue(beginImage, forKey: kCIInputImageKey)
                    edgeDetectFilter.setValue(0.1, forKey: "inputIntensity")
                    edgeDetectFilter.setValue(0.2, forKey: "inputRadius")
                    
                    image2 = UIImage(ciImage: edgeDetectFilter.outputImage!)
                    
                    //img2.image = newImage
                    
                    
                }
                else {
                    // Failure
                    print("Failure: %@", error!.localizedDescription);
                }
                DispatchQueue.main.async(execute: {
                    //imageView.image = UIImage(data: data!)
                    imageView1.alpha = 0
                    imageView1.image = image2
                    
                })
                
            })
            task1.resume()
        }
        
        task.resume()
    }

    
    func imageFromURL (URL: URL, imageView: UIImageView){
        var newImage = UIImage()
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            if (error == nil && data != nil) {
                //applying filter to make the white text more legible
                let beginImage = CIImage(data: data!)
                let edgeDetectFilter = CIFilter(name: "CIVignetteEffect")!
                edgeDetectFilter.setValue(beginImage, forKey: kCIInputImageKey)
                edgeDetectFilter.setValue(0.2, forKey: "inputIntensity")
                edgeDetectFilter.setValue(0.2, forKey: "inputRadius")
                
                //edgeDetectFilter.setValue(CIImage(image: edgeDetectFilter.outputImage!), forKey: kCIInputImageKey)
                let newCGImage = CIContext(options: nil).createCGImage(edgeDetectFilter.outputImage!, from: (edgeDetectFilter.outputImage?.extent)!)
                
                newImage = UIImage(cgImage: newCGImage!)
                DispatchQueue.main.async(execute: {
                    imageView.alpha = 0
                    imageView.image = newImage
                    UIView.animate(withDuration: 0.2, animations: {
                        imageView.alpha = 1
                    })
                    imageView.contentMode = UIViewContentMode.scaleAspectFill
                    imageView.clipsToBounds = true
                })
                
            }
            else {
                // Failure to retrieve Image from URL
                print("Failure: %@", error!.localizedDescription)
            }
        }
        task.resume()
        
    }
    
}
