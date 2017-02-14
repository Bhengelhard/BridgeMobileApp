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
    var fbFriendIds = [String]()
    
    // MARK: -
    
    func getProfilePictures() {
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
                        let imageFile = PFFile(data: data)!
                        imageFiles.append(imageFile)
                    }
                }
            }
            PFUser.current()?["profile_pictures"] = imageFiles
            PFUser.current()?.saveInBackground(block: { (success, error) in
                if error != nil {
                    print("error - saving profile pictures - \(error)")
                }
                if success {
                    //Saving profilePicture url
                    if let profilePictureFiles = PFUser.current()?["profile_pictures"] as? [PFFile] {
                        var profilePicturesURLs = [String]()
                        for profilePictureFile in profilePictureFiles {
                            if let url = profilePictureFile.url {
                                profilePicturesURLs.append(url)
                            }
                        }
                        PFUser.current()?["profile_pictures_urls"] = profilePicturesURLs
                        PFUser.current()?.signUpInBackground()
                    }
                }
            })
        })
        
    }
    
    // MARK: - Updating User's Friends

    func updateFacebookFriends () {
        facebookFriends(withCursor: nil)
    }

    func facebookFriends (withCursor after: String?){
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
                //if let friends = dictionary["friends"] as? Dictionary<String, AnyObject> {
                if let data = dictionary["data"] as? [Dictionary<String, AnyObject>] {
                    for friend in data {
                        if let id = friend["id"] as? String {
                            self.fbFriendIds.append(id)
                        }
                        
                    }
                }

                if let paging = dictionary["paging"] as? Dictionary<String, AnyObject> {
                    if let _ = paging["next"] {
                        if let cursors = paging["cursors"] as? Dictionary<String, AnyObject> {
                            if let cursor = cursors["after"] as? String
                            {
                                return self.facebookFriends(withCursor: cursor)
                            }
                        }
                    } else {
                        // After paging through the whole list, save the fbids to the fbFriends
                        PFUser.current()?["fb_friends"] = self.fbFriendIds
                        PFUser.current()?.saveInBackground(block: { (success, error) in
                            if error != nil {
                                print(error!)
                            } else {
                                // Convert fbIds to parse objectIds
                                self.updateFriendList()
                            }
                        })
                        
                    }
                }
            }
        }
        
    }
    
    // Update the user's friendList in the User Table with objectIds corresponding to the User's FaceBook Friends
    func updateFriendList() {
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
                PFUser.current()?.fetchInBackground(block: { (success, error) in
                    for object in objects {
                        if let friendsObjectId = object.objectId {
                            
                            // Do not include users the current user has unmatched
                            if !currentUserUnmatchedList.contains(friendsObjectId) {
                                PFUser.current()?.addUniqueObject(friendsObjectId, forKey: "friend_list")
                            }
                        }
                    }
                    PFUser.current()?.saveInBackground()
                })
            }
        })
    }
    
}
