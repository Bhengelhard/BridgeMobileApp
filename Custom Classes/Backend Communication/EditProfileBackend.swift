//
//  EditProfileBackend.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 3/7/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class EditProfileBackend {
    
    func setPictures(withBlock block: Picture.PicturesBlock? = nil) {
        User.getCurrent { (user) in
            Picture.getAll(withUser: user) { (pictures) in
                if let block = block {
                    block(pictures)
                }
            }

        }
    }
    
    func savePicturesToUser(pictureIDs: [String?], images: [UIImage]) {
        User.getCurrent { (user) in
            self.savePicturesToUser(user: user, pictureIDs: pictureIDs, images: images, index: 0, soFar: [])
        }
    }
    
    private func savePicturesToUser(user: User, pictureIDs: [String?], images: [UIImage], index: Int, soFar: [String]) {
        if index >= pictureIDs.count || index >= images.count {
            user.pictureIDs = soFar
            user.save()
        } else if let pictureID = pictureIDs[index] {
            var newSoFar = soFar
            newSoFar.append(pictureID)
            savePicturesToUser(user: user, pictureIDs: pictureIDs, images: images, index: index+1, soFar: newSoFar)
        } else {
            let image = images[index]
            Picture.create(image: image) { (picture) in
                picture.save { (picture) in
                    if let pictureID = picture.id {
                        var newSoFar = soFar
                        newSoFar.append(pictureID)
                        self.savePicturesToUser(user: user, pictureIDs: pictureIDs, images: images, index: index+1, soFar: newSoFar)
                    }
                }
            }
        }
    }
    
}
