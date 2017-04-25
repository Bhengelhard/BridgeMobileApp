//
//  HalfSwipeCard.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 11/11/16.
//  Copyright © 2016 Parse. All rights reserved.
//
//// Create View for Half of Swipe Card that includes the inputted user info

import UIKit

class HalfSwipeCard: UIView {
    var photo: UIImage?
    let nameLabel = UILabel()
    let photoView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    func initialize(name: String) {
        layer.masksToBounds = true
        backgroundColor = UIColor(red: 234/255, green: 237/255, blue: 239/255, alpha: 1.0)
        
        nameLabel.textColor = UIColor.white
        nameLabel.font = UIFont(name: "BentonSans-Bold", size: 22)
        nameLabel.textAlignment = NSTextAlignment.left
        nameLabel.layer.shadowOpacity = 0.5
        nameLabel.layer.shadowRadius = 0.5
        nameLabel.layer.shadowColor = UIColor.black.cgColor
        nameLabel.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)

        
        photoView.contentMode = .scaleAspectFill
        photoView.clipsToBounds = true
        
        photoView.image = nil

    }
    
    func setName(name: String) {
        nameLabel.text = DisplayUtility.firstNameLastNameInitial(name: name)
        layoutHalfCard()
    }
    
    func setImage(image: UIImage) {
        photoView.image = image
    }
    
    func layoutHalfCard() {
        addSubview(photoView)
        photoView.autoPinEdgesToSuperviewEdges()
        
        //let nameLabel = UILabel(frame: CGRect(x: 0.1308*self.frame.width, y: 0, width: self.frame.width, height: 0.1*self.frame.height))//x: 0.1308*DisplayUtility.screenWidth, y: 0.7556*DisplayUtility.screenHeight, width: 0.8*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenHeight))
        //nameLabel.text = DisplayUtility.firstNameLastNameInitial(name: name)
        addSubview(nameLabel)
        
        // Setting origin y value of nameLabel based on placement of connectionTypeIcon which is based on whether there is a status
        //nameLabel.center.y = 0.83*self.frame.height
        nameLabel.sizeToFit()
        nameLabel.autoSetDimensions(to: nameLabel.frame.size)
        nameLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
        nameLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)

    }
    
    func callbackToSetPhoto(_ image: UIImage) -> Void {
        photo = image
    }
    
    
    
    /*
     //card's profile pictures are retrieved if they are already saved to the phone using mapping to the associated bridgePairing objectId and the position of the card (i.e. either upperDeckCard or not)
     let localData = LocalData()
     if let pairings = localData.getPairings() {
     for pair in pairings {
     if self.frame.origin.y == 0 {
     //Sets the image on the HalfSwipeCard to user1's saved profile picture in the pair
     if let data = pair.user1?.savedProfilePicture {
     //applying filter to make the white text more legible
     let beginImage = CIImage(data: data as Data)
     let edgeDetectFilter = CIFilter(name: "CIVignetteEffect")!
     edgeDetectFilter.setValue(beginImage, forKey: kCIInputImageKey)
     edgeDetectFilter.setValue(0.2, forKey: "inputIntensity")
     edgeDetectFilter.setValue(0.2, forKey: "inputRadius")
     
     let newCGImage = CIContext(options: nil).createCGImage(edgeDetectFilter.outputImage!, from: (edgeDetectFilter.outputImage?.extent)!)
     
     let newImage = UIImage(cgImage: newCGImage!)
     photoView.image = newImage
     photoView.contentMode = UIViewContentMode.scaleAspectFill
     photoView.clipsToBounds = true
     }
     //Downloads the photo from the URL and then saves to the pairing
     else {
     /*if let bridgePairingObjectId = pair.user1?.objectId {
     if let URL = URL(string: photoURL) {
     Downloader.load(URL, imageView: photoView, bridgePairingObjectId: bridgePairingObjectId , isUpperDeckCard: true)
     }
     }*/
     if let URL = URL(string: photoURL) {
     downloader.imageFromURL(URL: URL, imageView: photoView, callBack: callbackToSetPhoto)
     break
     }
     }
     }
     else {
     //Sets the image on the HalfSwipeCard to user2's saved profile picture in the pair
     if let data = pair.user2?.savedProfilePicture {
     //applying filter to make the white text more legible
     let beginImage = CIImage(data: data as Data)
     let edgeDetectFilter = CIFilter(name: "CIVignetteEffect")!
     edgeDetectFilter.setValue(beginImage, forKey: kCIInputImageKey)
     edgeDetectFilter.setValue(0.2, forKey: "inputIntensity")
     edgeDetectFilter.setValue(0.2, forKey: "inputRadius")
     
     let newCGImage = CIContext(options: nil).createCGImage(edgeDetectFilter.outputImage!, from: (edgeDetectFilter.outputImage?.extent)!)
     
     let newImage = UIImage(cgImage: newCGImage!)
     photoView.image = newImage
     photoView.contentMode = UIViewContentMode.scaleAspectFill
     photoView.clipsToBounds = true
     }
     //Downloads the photo from the URL and then saves to the pairing
     else {
     /*if let bridgePairingObjectId = pair.user2?.objectId {
     if let URL = URL(string: photoURL) {
     Downloader.load(URL, imageView: photoView, bridgePairingObjectId: bridgePairingObjectId , isUpperDeckCard: false)
     }
     }*/
     if let URL = URL(string: photoURL) {
     downloader.imageFromURL(URL: URL, imageView: photoView, callBack: callbackToSetPhoto)
     break
     }
     }
     }
     
     }
     }*/
}
