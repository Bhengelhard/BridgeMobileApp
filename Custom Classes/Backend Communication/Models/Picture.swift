//
//  Picture.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 2/15/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import Parse
import UIKit

class Picture: NSObject {
    typealias PictureBlock = (Picture) -> Void
    typealias PicturesBlock = ([Picture]) -> Void
    typealias ImageBlock = (UIImage) -> Void
    typealias ImagesBlock = ([UIImage]) -> Void
    
    private let parsePicture: PFObject
    
    /// The objectId of the Picture
    var id: String?
    
    private var imageFile: PFFile?
    
    /// The full, uncropped image
    private var image: UIImage?
    
    private var croppedImageFile: PFFile?
    
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
            imageFile = parseImageFile
            setImage(fromFile: parseImageFile)
        }
        
        if let parseCroppedImageFile = parsePicture["cropped_image_file"] as? PFFile {
            croppedImageFile = parseCroppedImageFile
            setImage(fromFile: parseCroppedImageFile)
        }
    }
    
    static func create(image: UIImage? = nil, croppedImage: UIImage? = nil, cropFrame: CGRect? = nil, withBlock block: PictureBlock? = nil) {
        
        let parsePicture = PFObject(className: "Pictures")
        
        // set Pictures ACL
        let acl = PFACL()
        acl.getPublicReadAccess = true
        acl.getPublicWriteAccess = true
        parsePicture.acl = acl
        
        if let image = image {
            parsePicture["image_file"] = imageToPFFile(image: image)
        }
        
        if let croppedImage = croppedImage {
            parsePicture["cropped_image_file"] = imageToPFFile(image: croppedImage)
        }
        
        if let cropFrame = cropFrame {
            parsePicture["crop_frame"] = cropFrame.dictionaryRepresentation
        }
        
        let picture = Picture(parsePicture: parsePicture)
        if let block = block {
            block(picture)
        }
    }
    
    private func setImage(fromFile parseImageFile: PFFile, withBlock block: ImageBlock? = nil) {
        parseImageFile.getDataInBackground { (data, error) in
            if let error = error {
                print("error getting data for image - \(error)")
            } else if let data = data {
                let image = UIImage(data: data)
                self.image = image
                if let image = image {
                    if let block = block {
                        block(image)
                    }
                }
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
    
    func getImage(withBlock block: ImageBlock? = nil) {
        if let image = image {
            if let block = block {
                block(image)
            }
        } else {
            if let imageFile = imageFile {
                setImage(fromFile: imageFile, withBlock: block)
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
            if let block = block {
                block(soFar)
            }
        } else {
            let query = PFQuery(className: "Pictures")
            query.getObjectInBackground(withId: pictureIDs[index]) { (parsePicture, error) in
                if let error = error {
                    print("error getting picture with id \(pictureIDs[index]) - \(error)")
                } else if let parsePicture = parsePicture {
                    var newSoFar = soFar
                    newSoFar.append(Picture(parsePicture: parsePicture))
                    self.getPictures(from: pictureIDs, startingAtIndex: index+1, soFar: newSoFar, withBlock: block)
                }
            }
        }
    }
    
    private static func imageToPFFile(image: UIImage) -> PFFile? {
        if let data = UIImageJPEGRepresentation(image, 1.0) {
            return PFFile(data: data)
        }
        return nil
    }
    
    func save(withBlock block: PictureBlock? = nil) {
        if let image = image {
            if let imageFile = Picture.imageToPFFile(image: image) {
                parsePicture["image_file"] = imageFile
            }
        } else if let imageFile = imageFile {
          parsePicture["image_file"] = imageFile
        } else {
            parsePicture.remove(forKey: "image_file")
        }
        
        if let croppedImage = croppedImage {
            if let croppedImageFile = Picture.imageToPFFile(image: croppedImage) {
                parsePicture["cropped_image_file"] = croppedImageFile
            }
        } else if let croppedImageFile = croppedImageFile {
            parsePicture["cropped_image_file"] = croppedImageFile
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
                self.id = self.parsePicture.objectId
                if let block = block {
                    block(self)
                }
            }
        }
    }
    
    func delete() {
        parsePicture.deleteInBackground()
    }
}
