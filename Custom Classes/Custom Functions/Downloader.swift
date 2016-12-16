//
//  Downloader.swift
//  MyBridgeApp
//
//  Created by Sagar Sinha on 8/24/16.
//  Copyright © 2016 BHE Ventures LLC. All rights reserved.
//

import Foundation
import UIKit
import Parse

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
                imageView.alpha = 0
                
                DispatchQueue.main.async(execute: {
                    //imageView.image = UIImage(data: data!)
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
    
    /*class func loadBothUrls(_ URL1: URL, URL2: URL, imageView1:UIImageView, imageView2:UIImageView, superDeckView:UIView) {
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
    }*/
    
    func imageFromURL (URL: URL, callBack: @escaping ((_ image: UIImage)->Void)) {
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
                
                callBack(newImage)
                
            }
            else {
                // Failure to retrieve Image from URL
                print("Failure: %@", error!.localizedDescription)
            }
        }
        task.resume()
    }

    //converts an image from a URL
    func imageFromURL (URL: URL, imageView: UIImageView, callBack: ((_ image: UIImage)->Void)?){
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
                    
                    if let callBack = callBack {
                         callBack(newImage)
                    }
                })
               
                
            }
            else {
                // Failure to retrieve Image from URL
                print("Failure: %@", error!.localizedDescription)
            }
        }
        task.resume()
    }
    
    
    //getting status from the currentUser's most recent status
    func setRequestForType(filterType: String, file: NSObject) {
        var necterStatusForType = "I am looking for..."
        let type = filterType
        let localData = LocalData()
        if type == "Business" {
            if let status = localData.getBusinessStatus() {
                necterStatusForType = status
                if let customKeyboard = file as? CustomKeyboard {
                    customKeyboard.messageTextView.text = "Current Request: \(necterStatusForType)"
                }
                
            } else {
                //query for current user in userId, limit to 1, and find most recently posted "Business" bridge_type
                let query: PFQuery = PFQuery(className: "BridgeStatus")
                query.whereKey("userId", equalTo: (PFUser.current()?.objectId)!)
                query.whereKey("bridge_type", equalTo: "Business")
                query.order(byDescending: "createdAt")
                query.limit = 1
                do {
                    print("getting business objects")
                    let objects = try query.findObjects()
                    for object in objects {
                        necterStatusForType = object["bridge_status"] as! String
                        if let customKeyboard = file as? CustomKeyboard {
                            customKeyboard.messageTextView.text = "Current Request: \(necterStatusForType)"
                        }
                        localData.setBusinessStatus(necterStatusForType)
                    }
                } catch {
                    print("Error in catch getting status")
                }
            }
        } else if type == "Love" {
            if let status = localData.getLoveStatus() {
                necterStatusForType = status
                if let customKeyboard = file as? CustomKeyboard {
                    customKeyboard.messageTextView.text = "Current Request: \(necterStatusForType)"
                }
                
            } else {
                //query for current user in userId, limit to 1, and find most recently posted "Business" bridge_type
                let query: PFQuery = PFQuery(className: "BridgeStatus")
                query.whereKey("userId", equalTo: (PFUser.current()?.objectId)!)
                query.whereKey("bridge_type", equalTo: "Love")
                query.order(byDescending: "createdAt")
                query.limit = 1
                do {
                    let objects = try query.findObjects()
                    for object in objects {
                        necterStatusForType = object["bridge_status"] as! String
                        if let customKeyboard = file as? CustomKeyboard {
                            customKeyboard.messageTextView.text = "Current Request: \(necterStatusForType)"
                        }
                        localData.setLoveStatus(necterStatusForType)
                    }
                } catch {
                    print("Error in catch getting status")
                }
            }
        } else if type == "Friendship" {
            if let status = localData.getFriendshipStatus() {
                necterStatusForType = status
                if let customKeyboard = file as? CustomKeyboard {
                    customKeyboard.messageTextView.text = "Current Request: \(necterStatusForType)"
                }
                
            } else {
                //query for current user in userId, limit to 1, and find most recently posted "Business" bridge_type
                let query: PFQuery = PFQuery(className: "BridgeStatus")
                query.whereKey("userId", equalTo: (PFUser.current()?.objectId)!)
                query.whereKey("bridge_type", equalTo: "Friendship")
                query.order(byDescending: "createdAt")
                query.limit = 1
                do {
                    let objects = try query.findObjects()
                    for object in objects {
                        necterStatusForType = object["bridge_status"] as! String
                        if let customKeyboard = file as? CustomKeyboard {
                            customKeyboard.messageTextView.text = "Current Request: \(necterStatusForType)"
                        }
                        localData.setLoveStatus(necterStatusForType)
                    }
                } catch {
                    print("Error in catch getting status")
                }
            }
            
        } else {
            if let customKeyboard = file as? CustomKeyboard {
                customKeyboard.messageTextView.text = nil
                customKeyboard.updatePlaceholder()
            }
        }
        if let customKeyboard = file as? CustomKeyboard {
            customKeyboard.updateMessageHeights()
        }
        /*if necterStatusForType != "I am looking for..." {
         print("isFirstPost set to \(isFirstPost)")
         isFirstPost = false
         }*/
    }

    
}
