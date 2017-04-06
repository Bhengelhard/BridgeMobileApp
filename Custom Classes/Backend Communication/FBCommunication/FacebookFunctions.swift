//
//  FacebookFunctions.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 12/16/16.
//  Copyright © 2016 BHE Ventures LLC. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import ParseFacebookUtilsV4
import FBSDKLoginKit


/// This class handles functions related to the Facebook api
class FacebookFunctions {
    
    var geoPoint:PFGeoPoint?
    
    // MARK: -
    
    func getProfilePictures(completion: (() -> Void)? = nil) {
        var sources = [String]()
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "albums{name, photos.order(reverse_chronological).limit(4){images}}"])
        _ = graphRequest?.start(completionHandler: { (_, result, error) in
            if let result = result as? [String:AnyObject] {
                if let albums = result["albums"] as? [String:AnyObject] {
                    if let data = albums["data"] as? [AnyObject] {
                        for album in data {
                            if let album = album as? [String:AnyObject] {
                                if let name = album["name"] as? String {
                                    if name == "Profile Pictures" {
                                        if let photos = album["photos"] as? [String:AnyObject] {
                                            if let data2 = photos["data"] as? [AnyObject] {
                                                for picture in data2 {
                                                    if let picture = picture as? [String:AnyObject] {
                                                        if let images = picture["images"] as? [AnyObject] {
                                                            if images.count > 0 {
                                                                if let image = images[0] as? [String:AnyObject] {
                                                                    if let source = image["source"] as? String {
                                                                        sources.append(source)
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            var imageFiles = [PFFile]()
            for source in sources {
                if let url = URL(string: source) {
                    if let data = try? Data(contentsOf: url) {
                        if let imageFile = PFFile(data: data) {
                            imageFiles.append(imageFile)
                        }
                    }
                }
            }
            
            PFUser.current()?["pictures"] = []
            PFUser.current()?.saveInBackground()
            
            self.addPicturesToCurrentUser(from: imageFiles, soFar: [], startingWithIndex: 0, completion: completion)
        })
        
    }
    
    private func addPicturesToCurrentUser(from imageFiles: [PFFile], soFar: [String], startingWithIndex index: Int, completion: (() -> Void)? = nil) {
        if index >= imageFiles.count {
            PFUser.current()?["pictures"] = soFar
            PFUser.current()?.saveInBackground()
            if let completion = completion {
                completion()
            }
        } else {
            let imageFile = imageFiles[index]
            imageFile.getDataInBackground { (data, error) in
                if let error = error {
                    print("error getting data for image - \(error)")
                } else if let data = data {
                    let image = UIImage(data: data)
                    Picture.create(image: image, croppedImage: nil, cropFrame: nil) { (picture) in
                        picture.save { (picture) in
                            if let pictureID = picture.id {
                                var newSoFar = soFar
                                newSoFar.append(pictureID)
                                self.addPicturesToCurrentUser(from: imageFiles, soFar: newSoFar, startingWithIndex: index+1, completion: completion)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    // MARK: - Updating User's Friends

    func updateFacebookFriends(withBlock block: (() -> Void)? = nil) {
        print("updating facebook friends")
        facebookFriends(withCursor: nil, fbFriendIDs: [], withBlock: block)
    }

    func facebookFriends(withCursor after: String?, fbFriendIDs: [String], withBlock block: (() -> Void)?) {
        var parameters = ["fields": ""]

        if after != nil {
            parameters["after"] = after!
        }
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: parameters)

        _ = graphRequest?.start { (connection, result, error) -> Void in
            if error != nil {
                print(error!)
            }
            else if let dictionary = result as? Dictionary<String, AnyObject> {
                var updatedFBFriendIDs = fbFriendIDs // new friend list
                
                //if let friends = dictionary["friends"] as? Dictionary<String, AnyObject> {
                if let data = dictionary["data"] as? [Dictionary<String, AnyObject>] {
                    for friend in data {
                        if let id = friend["id"] as? String {
                            updatedFBFriendIDs.append(id)
                        }
                        
                    }
                }

                if let paging = dictionary["paging"] as? Dictionary<String, AnyObject> {
                    if let _ = paging["next"] {
                        if let cursors = paging["cursors"] as? Dictionary<String, AnyObject> {
                            if let cursor = cursors["after"] as? String {
                                return self.facebookFriends(withCursor: cursor, fbFriendIDs: updatedFBFriendIDs, withBlock: block)
                            }
                        }
                    }
                }
                
                // After paging through the whole list, save the fbids to the fbFriends
                PFUser.current()?["fb_friends"] = updatedFBFriendIDs
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    if error != nil {
                        print(error!)
                    } else {
                        // Convert fbIds to parse objectIds
                        self.updateFriendList(withBlock: block)
                    }
                })
            }
        }
        
    }
    
    // Update the user's friendList in the User Table with objectIds corresponding to the User's FaceBook Friends
    func updateFriendList(withBlock block: (() -> Void)? = nil) {
        //add graph request to update users fb_friends
        //query to find and save fb_friends
        let currentUserFbFriends = PFUser.current()!["fb_friends"] as? [String] ?? [String]()
        let currentUserUnmatchedList = PFUser.current()!["unmatched_list"] as? [String] ?? [String]()
        let query: PFQuery = PFQuery(className: "_User")
        
        query.whereKey("fb_id", containedIn: currentUserFbFriends as [AnyObject])
        
        query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
            if error != nil {
                print(error!)
            } else if let objects = objects {
                
                // If the user does not yet have any friends, set the friend_list to an empty array
                if PFUser.current()?["friend_list"] == nil {
                    PFUser.current()?["friend_list"] = []
                }
                
                PFUser.current()?.fetchInBackground(block: { (success, error) in
                    for object in objects {
                        if let friendsObjectId = object.objectId {
                            // Do not include users the current user has unmatched
                            if !currentUserUnmatchedList.contains(friendsObjectId) {
                                PFUser.current()?.addUniqueObject(friendsObjectId, forKey: "friend_list")
                            }
                        }
                    }
                    
                    PFUser.current()?.saveInBackground(block: { (success, error) in
                        if error != nil {
                            print(error!)
                        } else {
                            if let block = block {
                                block()
                            }
                        }
                    })
                })
            }
        })
    }
    
}
