//
//  Picture.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 2/15/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Parse
import UIKit

class Picture: NSObject {
    typealias PictureBlock = (Picture) -> Void
    typealias PicturesBlock = ([Picture]) -> Void
    
    private let parsePicture: PFObject
    
    /// The objectId of the Picture
    let id: String?
    
    /// The full, uncropped image
    var image: UIImage?
    
    /// The cropped image
    var croppedImage: UIImage?
    
    /// The frame of the cropped portion of the image
    var cropFrame: CGRect?
    
    private init(parsePicture: PFObject) {
        self.parsePicture = parsePicture
        
        id = parsePicture.objectId
        
        if let parseCropFrame = parsePicture["crop_frame"] as? [String: CGFloat] {
            if let x = parseCropFrame["X"], let y = parseCropFrame["Y"],
                let width = parseCropFrame["Width"], let height = parseCropFrame["Height"] {
                cropFrame = CGRect(x: x, y: y, width: width, height: height)
            }
        }
        
        super.init()
        
        if let parseImageFile = parsePicture["image_file"] as? PFFile {
            setImage(fromFile: parseImageFile)
        }
        
        if let parseCroppedImageFile = parsePicture["cropped_image_file"] as? PFFile {
            setImage(fromFile: parseCroppedImageFile)
        }
    }
    
    private func setImage(fromFile parseImageFile: PFFile) {
        parseImageFile.getDataInBackground { (data, error) in
            if let error = error {
                print("error getting data for image - \(error)")
            } else if let data = data {
                self.image = UIImage(data: data)
            }
        }
    }
    
    private func setCroppedImage(fromFile parseCroppedImageFile: PFFile) {
        parseCroppedImageFile.getDataInBackground { (data, error) in
            if let error = error {
                print("error getting data for cropped image - \(error)")
            } else if let data = data {
                self.croppedImage = UIImage(data: data)
            }
        }
    }
    
    static func get(withID id: String, withBlock block: PictureBlock? = nil) {
        let query = PFQuery(className: "Pictures")
        query.getObjectInBackground(withId: id) { (parseObject, error) in
            if let error = error {
                print("error getting picture with id \(id) - \(error)")
            } else if let parsePicture = parseObject {
                let picture = Picture(parsePicture: parsePicture)
                if let block = block {
                    block(picture)
                }
            }
        }
    }
    
    static func getAll(withUser user: User, withBlock block: PicturesBlock? = nil) {
        if let userPictureIDs = user.pictureIDs {
            getPictures(from: userPictureIDs, startingAtIndex: 0, soFar: [], withBlock: block)
        }
    }
    
    private static func getPictures(from pictureIDs: [String], startingAtIndex index: Int, soFar: [Picture], withBlock block: Picture.PicturesBlock? = nil) {
        if index >= pictureIDs.count {
            print("got \(soFar.count) pictures")
            if let block = block {
                block(soFar)
            }
        } else {
            let query = PFQuery(className: "Pictures")
            query.getObjectInBackground(withId: pictureIDs[index]) { (parsePicture, error) in
                if let error = error {
                    print("error getting picture - \(error)")
                } else if let parsePicture = parsePicture {
                    var newSoFar = soFar
                    newSoFar.append(Picture(parsePicture: parsePicture))
                    self.getPictures(from: pictureIDs, startingAtIndex: index+1, soFar: newSoFar, withBlock: block)
                }
            }
        }
    }
    
    private func imageToPFFile(image: UIImage) -> PFFile? {
        if let data = UIImageJPEGRepresentation(image, 1.0) {
            return PFFile(data: data)
        }
        return nil
    }
    
    func save(withBlock block: PictureBlock? = nil) {
        if let image = image {
            if let imageFile = imageToPFFile(image: image) {
                parsePicture["image_file"] = imageFile
            }
        } else {
            parsePicture.remove(forKey: "image_file")
        }
        
        if let croppedImage = croppedImage {
            if let croppedImageFile = imageToPFFile(image: croppedImage) {
                parsePicture["cropped_image_file"] = croppedImageFile
            }
        } else {
            parsePicture.remove(forKey: "cropped_image_file")
        }
        
        if let cropFrame = cropFrame {
            if let cropFrameDict = cropFrame.dictionaryRepresentation as? [String: CGFloat] {
                parsePicture["crop_frame"] = cropFrameDict
            }
        } else {
            parsePicture.remove(forKey: "cropFrame")
        }
        
        parsePicture.saveInBackground { (succeeded, error) in
            if let error = error {
                print("error saving picture - \(error)")
            } else if succeeded {
                if let block = block {
                    block(self)
                }
            }
        }
    }
}
