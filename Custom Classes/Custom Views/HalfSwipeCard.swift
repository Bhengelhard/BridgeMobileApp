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
    //var name:String?
    //var location:String?
    //var status:String?
    var photo:UIImage?
    //var locationCoordinates:[Double]?
    //var connectionType:String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    func initialize(name: String, status: String, photoURL: String!, connectionType: String) {
        self.layer.masksToBounds = true
        
        //download Photo from URL
        let photoView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        let downloader = Downloader()
        downloader.imageFromURL(URL: URL(string: photoURL)!, imageView: photoView)
        if let image = photoView.image {
            photo = image
        }
        self.addSubview(photoView)
        
        let connectionTypeIcon = UIImageView(frame: CGRect(x: 0.0257*self.frame.width, y: 0.68*self.frame.height, width: 0.056*DisplayUtility.screenHeight, height: 0.056*DisplayUtility.screenHeight))
        let typeImageName = "\(connectionType)_Card_Icon"
        connectionTypeIcon.image = UIImage(named: typeImageName)
        self.addSubview(connectionTypeIcon)
        
        let nameLabel = UILabel(frame: CGRect(x: 0.1308*self.frame.width, y: 0, width: self.frame.width, height: 0.1*self.frame.height))//x: 0.1308*DisplayUtility.screenWidth, y: 0.7556*DisplayUtility.screenHeight, width: 0.8*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenHeight))
        nameLabel.center.y = connectionTypeIcon.center.y
        nameLabel.text = firstNameLastNameInitial(name: name)
        nameLabel.textColor = UIColor.white
        nameLabel.font = UIFont(name: "BentonSans-Bold", size: 22)
        nameLabel.textAlignment = NSTextAlignment.left
        nameLabel.layer.shadowOpacity = 0.5
        nameLabel.layer.shadowRadius = 0.5
        nameLabel.layer.shadowColor = UIColor.black.cgColor
        nameLabel.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        self.addSubview(nameLabel)
        
        if status != "" {
            let statusTextView = UITextView(frame: CGRect(x: 0, y: connectionTypeIcon.frame.origin.y + connectionTypeIcon.frame.height, width: self.frame.width, height: 0.08*self.frame.height)) // this height needs to change based on text input
            let displayUtility = DisplayUtility()
            statusTextView.backgroundColor = UIColor.black
            statusTextView.layer.opacity = 0.6
            statusTextView.text = "This is the status"//status
            statusTextView.textContainer.maximumNumberOfLines = 2
            statusTextView.font = UIFont(name: "BentonSans-Light", size: 15)
            statusTextView.textColor = UIColor.white
            statusTextView.textAlignment = NSTextAlignment.center
            statusTextView.textContainerInset = UIEdgeInsetsMake(4, 12, 4, 12)
            statusTextView.isUserInteractionEnabled = false
            displayUtility.setViewHeightFromContent(view: statusTextView)
            statusTextView.text = ""
            self.addSubview(statusTextView)
            
            let statusLabel = UILabel(frame: statusTextView.frame)
            statusLabel.text = status
            statusLabel.textColor = UIColor.white
            statusLabel.font = UIFont(name: "BentonSans-Light", size: 15)
            statusLabel.textAlignment = NSTextAlignment.center
            self.addSubview(statusLabel)
        }
        
    }
    
    func firstNameLastNameInitial (name: String) -> String{
        let wordsInName = name.components(separatedBy: " ")
        if let firstName = wordsInName.first {
            if let lastName = wordsInName.last {
                if wordsInName.last != firstName {
                    let lastNameInitial = lastName.characters.first!
                    let firstNameLastNameInitial = "\(firstName) \(lastNameInitial)."
                    
                    return firstNameLastNameInitial
                }
            } else {
                return firstName
            }

        }
        
        return name
    }
    
    /*func getCard(_ deckFrame:CGRect, name:String?, location:String?, status:String?, photo:String?, cardColor:typesOfColor?, locationCoordinates:[Double]?, pairing:UserInfoPair, tag:Int, isUpperDeckCard: Bool) -> UIView {
        
        let locationFrame = CGRect(x: 0.05*cardWidth,y: 0.18*cardHeight,width: 0.8*cardWidth,height: 0.075*cardHeight)
        let statusFrame = CGRect(x: 0.05*cardWidth,y: 0.65*cardHeight,width: 0.9*cardWidth,height: 0.3*cardHeight)
        let photoFrame = CGRect(x: 0, y: 0, width: superDeckWidth, height: 0.5*superDeckHeight)
        
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.textAlignment = NSTextAlignment.left
        nameLabel.textColor = UIColor.white
        nameLabel.font = UIFont(name: "Verdana", size: 20)
        //let adjustedNameSize = nameLabel.sizeThatFits(CGSize(width: 0.8*cardWidth, height: 0.12*cardHeight))
        var nameFrame = CGRect(x: 0.05*cardWidth,y: 0.05*cardHeight,width: 0.8*cardWidth,height: 0.12*cardHeight)
        //nameFrame.size = adjustedNameSize
        //nameFrame.size.height = 0.12*cardHeight
        nameLabel.frame = nameFrame
        nameLabel.layer.cornerRadius = 2
        nameLabel.clipsToBounds = true
        
        nameLabel.layer.shadowOpacity = 0.5
        nameLabel.layer.shadowRadius = 0.5
        nameLabel.layer.shadowColor = UIColor.black.cgColor
        nameLabel.layer.shadowOffset = CGSize(width: 0.0, height: -0.5)
        let locationCoordinates = locationCoordinates ?? [-122.0,37.0]
        
        let locationLabel = UILabel(frame: locationFrame)
        locationLabel.tag = tag
        if location == "" {
            setCityName(locationLabel, locationCoordinates: locationCoordinates, pairing:pairing)
        }
        locationLabel.text = location
        locationLabel.textAlignment = NSTextAlignment.left
        locationLabel.textColor = UIColor.white
        locationLabel.font = UIFont(name: "Verdana", size: 14)
        locationLabel.layer.shadowOpacity = 0.5
        locationLabel.layer.shadowRadius = 0.5
        locationLabel.layer.shadowColor = UIColor.black.cgColor
        locationLabel.layer.shadowOffset = CGSize(width: 0.0, height: -0.5)
        
        var statusText = ""
        
        if let status = status {
            if status != "" {
                statusText = "\"\(status)\""
            }
            
        }
        let statusLabel = UILabel(frame: statusFrame)
        statusLabel.text = statusText
        statusLabel.textColor = UIColor.white
        statusLabel.font = UIFont(name: "Verdana", size: 14)
        statusLabel.textAlignment = NSTextAlignment.center
        statusLabel.numberOfLines = 0
        statusLabel.layer.shadowOpacity = 0.5
        statusLabel.layer.shadowRadius = 0.5
        statusLabel.layer.shadowColor = UIColor.black.cgColor
        statusLabel.layer.shadowOffset = CGSize(width: 0.0, height: -0.5)
        
        //card's profile pictures are retrieved if they are already saved to the phone using mapping to the associated bridgePairing objectId and the position of the card (i.e. either upperDeckCard or not)
        let photoView = UIImageView(frame: photoFrame)
        
        if isUpperDeckCard {
            if let data = pairing.user1?.savedProfilePicture {
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
            else {
                if let photo = photo{
                    if let URL = URL(string: photo) {
                        Downloader.load(URL, imageView: photoView, bridgePairingObjectId: pairing.user1?.objectId, isUpperDeckCard: isUpperDeckCard)
                    }
                }
            }
        }
        else {
            if let data = pairing.user2?.savedProfilePicture {
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
            else {
                if let photo = photo{
                    if let URL = URL(string: photo) {
                        Downloader.load(URL, imageView: photoView, bridgePairingObjectId: pairing.user2?.objectId, isUpperDeckCard: isUpperDeckCard)
                    }
                }
            }
            
        }
        
        let card = UIView(frame:deckFrame)
        
        card.addSubview(photoView)
        card.addSubview(nameLabel)
        card.addSubview(locationLabel)
        card.addSubview(statusLabel)
        
        return card
        
    }*/
    
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
