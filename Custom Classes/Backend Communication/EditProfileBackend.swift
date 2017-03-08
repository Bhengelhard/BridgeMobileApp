//
//  EditProfileBackend.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 3/7/17.
//  Copyright © 2017 Parse. All rights reserved.
//

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
    
}
