//
//  ViewController.swift
//  play
//
//  Created by Sagar Sinha on 7/5/16.
//  Copyright © 2016 SagarSinha. All rights reserved.
//

import UIKit
import MapKit
class BridgeNewViewController: UIViewController {
    var lowerDeckCards = [UIView?](count: 5, repeatedValue: nil)
    var upperDeckCards = [UIView?](count: 5, repeatedValue: nil)
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    let cardWidth = UIScreen.mainScreen().bounds.width*0.8
    let cardHeight = UIScreen.mainScreen().bounds.height*0.30
    var nameSet = ["Peter", "Jackson", "Johnny", "Bravo", "Dezz"]
    var locationSet = ["Moscow", "Brlin", "Paris", "Mumbai", "Tel Aviv"]
    var statusSet = ["Business","Love","Friendship","Business", "Love"]
    var colorSet = [ UIColor.init(red: 144.0/255, green: 207.0/255, blue: 214.0/255, alpha: 1.0), UIColor.init(red: 255.0/255, green: 129.0/255, blue: 125.0/255, alpha: 1.0), UIColor(red: 139.0/255, green: 217.0/255, blue: 176.0/255, alpha: 1.0), UIColor.init(red: 144.0/255, green: 207.0/255, blue: 214.0/255, alpha: 1.0)]
    var nextPairButton:UIButton? = nil
    var bridgeButton:UIButton? = nil
    var minimumCards = 4
    
    
    func bridgeButtonTapped(sender: UIButton!) {
        bridgeButton?.userInteractionEnabled = false
        nextPairButton?.userInteractionEnabled = false
        let nameFrame = CGRectMake(0.05*cardWidth,0.10*cardHeight,0.55*cardWidth,0.20*cardHeight)
        let locationFrame = CGRectMake(0.60*cardWidth,0.10*cardHeight,0.40*cardWidth,0.20*cardHeight)
        let statusFrame = CGRectMake(0.05*cardWidth,0.31*cardHeight,0.95*cardWidth,0.34*cardHeight)
        let photoFrame = CGRectMake(0.275*cardWidth,0.55*cardHeight,0.45*cardWidth,1.0*cardHeight)
        let upperDeckFrame : CGRect = CGRectMake(screenWidth*(0.06),screenHeight*(0.16), screenWidth*0.8,screenHeight*0.30)
        let lowerDeckFrame : CGRect = CGRectMake(screenWidth*(0.06),screenHeight*(0.61), screenWidth*0.8,screenHeight*0.30)
        let upperDeckNameLabel = UILabel(frame: nameFrame)
        upperDeckNameLabel.text = nameSet[0]
        let upperDeckLocationLabel = UILabel(frame: locationFrame)
        upperDeckLocationLabel.text = locationSet[0]
        let upperDeckStatusLabel = UILabel(frame: statusFrame)
        upperDeckStatusLabel.text = statusSet[0]
        let upperDeckPhotoView = UIImageView(frame: photoFrame)
        
        let lowerDeckNameLabel = UILabel(frame: nameFrame)
        lowerDeckNameLabel.text = nameSet[0]
        let lowerDeckLocationLabel = UILabel(frame: locationFrame)
        lowerDeckLocationLabel.text = locationSet[0]
        let lowerDeckStatusLabel = UILabel(frame: statusFrame)
        lowerDeckStatusLabel.text = statusSet[0]
        let lowerDeckPhotoView = UIImageView(frame: photoFrame)
        
        let upperDeckCard = UIView(frame:upperDeckFrame)
        upperDeckCard.addSubview(upperDeckNameLabel)
        upperDeckCard.addSubview(upperDeckLocationLabel)
        upperDeckCard.addSubview(upperDeckStatusLabel)
        upperDeckCard.addSubview(upperDeckPhotoView)
        upperDeckCard.backgroundColor = colorSet[0]
        upperDeckCards[minimumCards] = upperDeckCard
        
        
        let lowerDeckCard = UIView(frame:lowerDeckFrame)
        lowerDeckCard.addSubview(lowerDeckNameLabel)
        lowerDeckCard.addSubview(lowerDeckLocationLabel)
        lowerDeckCard.addSubview(lowerDeckStatusLabel)
        lowerDeckCard.addSubview(lowerDeckPhotoView)
        lowerDeckCard.backgroundColor = colorSet[0]
        
        upperDeckCard.layer.cornerRadius = 8.0
        upperDeckCard.clipsToBounds = true
        lowerDeckCard.layer.cornerRadius = 8.0
        lowerDeckCard.clipsToBounds = true
        
        upperDeckCards[minimumCards] = upperDeckCard
        lowerDeckCards[minimumCards] = lowerDeckCard
        
        let upperDeckFrame0 = self.upperDeckCards[0]!.frame
        let lowerDeckFrame0 = self.lowerDeckCards[0]!.frame
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
            
            self.upperDeckCards[0]!.frame.origin.x = UIScreen.mainScreen().bounds.width
            self.lowerDeckCards[0]!.frame.origin.x = UIScreen.mainScreen().bounds.width
            }, completion: {  finished in
        })

        
        UIView.animateWithDuration(1.0, delay: 0.3, options: .CurveEaseOut, animations: {
            self.view.insertSubview(upperDeckCard, belowSubview: self.upperDeckCards[self.minimumCards-1]!)
            self.view.insertSubview(lowerDeckCard, belowSubview: self.lowerDeckCards[self.minimumCards-1]!)
            for i in (2..<5).reverse() {
                self.upperDeckCards[i]?.frame = self.upperDeckCards[i-1]!.frame
                self.lowerDeckCards[i]?.frame = self.lowerDeckCards[i-1]!.frame
            }
            self.upperDeckCards[1]?.frame = upperDeckFrame0
            self.lowerDeckCards[1]?.frame = lowerDeckFrame0
            }, completion: {  finished in
                self.upperDeckCards[0]!.removeFromSuperview()
                self.lowerDeckCards[0]!.removeFromSuperview()
                for i in 0..<self.minimumCards {
                    self.upperDeckCards[i] = self.upperDeckCards[i+1]
                    self.lowerDeckCards[i] = self.lowerDeckCards[i+1]
                }
                self.bridgeButton?.userInteractionEnabled = true
                self.nextPairButton?.userInteractionEnabled = true
                
        })
        
    }
    func nextPairButtonTapped(sender: UIButton!) {
        bridgeButton?.userInteractionEnabled = false
        nextPairButton?.userInteractionEnabled = false
        let nameFrame = CGRectMake(0.05*cardWidth,0.10*cardHeight,0.55*cardWidth,0.20*cardHeight)
        let locationFrame = CGRectMake(0.60*cardWidth,0.10*cardHeight,0.40*cardWidth,0.20*cardHeight)
        let statusFrame = CGRectMake(0.05*cardWidth,0.31*cardHeight,0.95*cardWidth,0.34*cardHeight)
        let photoFrame = CGRectMake(0.275*cardWidth,0.55*cardHeight,0.45*cardWidth,1.0*cardHeight)
        let upperDeckFrame : CGRect = CGRectMake(screenWidth*(0.06),screenHeight*(0.16), screenWidth*0.8,screenHeight*0.30)
        let lowerDeckFrame : CGRect = CGRectMake(screenWidth*(0.06),screenHeight*(0.61), screenWidth*0.8,screenHeight*0.30)
        let upperDeckNameLabel = UILabel(frame: nameFrame)
        upperDeckNameLabel.text = nameSet[0]
        let upperDeckLocationLabel = UILabel(frame: locationFrame)
        upperDeckLocationLabel.text = locationSet[0]
        let upperDeckStatusLabel = UILabel(frame: statusFrame)
        upperDeckStatusLabel.text = statusSet[0]
        let upperDeckPhotoView = UIImageView(frame: photoFrame)
        
        let lowerDeckNameLabel = UILabel(frame: nameFrame)
        lowerDeckNameLabel.text = nameSet[0]
        let lowerDeckLocationLabel = UILabel(frame: locationFrame)
        lowerDeckLocationLabel.text = locationSet[0]
        let lowerDeckStatusLabel = UILabel(frame: statusFrame)
        lowerDeckStatusLabel.text = statusSet[0]
        let lowerDeckPhotoView = UIImageView(frame: photoFrame)
        
        let upperDeckCard = UIView(frame:upperDeckFrame)
        upperDeckCard.addSubview(upperDeckNameLabel)
        upperDeckCard.addSubview(upperDeckLocationLabel)
        upperDeckCard.addSubview(upperDeckStatusLabel)
        upperDeckCard.addSubview(upperDeckPhotoView)
        upperDeckCard.backgroundColor = colorSet[0]
        
        
        
        let lowerDeckCard = UIView(frame:lowerDeckFrame)
        lowerDeckCard.addSubview(lowerDeckNameLabel)
        lowerDeckCard.addSubview(lowerDeckLocationLabel)
        lowerDeckCard.addSubview(lowerDeckStatusLabel)
        lowerDeckCard.addSubview(lowerDeckPhotoView)
        lowerDeckCard.backgroundColor = colorSet[0]
        
        upperDeckCard.layer.cornerRadius = 8.0
        upperDeckCard.clipsToBounds = true
        lowerDeckCard.layer.cornerRadius = 8.0
        lowerDeckCard.clipsToBounds = true
        
        upperDeckCards[4] = upperDeckCard
        lowerDeckCards[4] = lowerDeckCard
        
        let upperDeckFrame0 = self.upperDeckCards[0]!.frame
        let lowerDeckFrame0 = self.lowerDeckCards[0]!.frame
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
            
            self.upperDeckCards[0]!.frame.origin.x = -UIScreen.mainScreen().bounds.width
            self.lowerDeckCards[0]!.frame.origin.x = -UIScreen.mainScreen().bounds.width
            }, completion: {  finished in
                UIView.animateWithDuration(1.0, delay: 0.0, options: .CurveEaseOut, animations: {
                    self.view.insertSubview(upperDeckCard, belowSubview: self.upperDeckCards[self.minimumCards-1]!)
                    self.view.insertSubview(lowerDeckCard, belowSubview: self.lowerDeckCards[self.minimumCards-1]!)
                    for i in (2..<5).reverse() {
                        self.upperDeckCards[i]?.frame = self.upperDeckCards[i-1]!.frame
                        self.lowerDeckCards[i]?.frame = self.lowerDeckCards[i-1]!.frame
                    }
                    self.upperDeckCards[1]?.frame = upperDeckFrame0
                    self.lowerDeckCards[1]?.frame = lowerDeckFrame0
                    }, completion: {  finished in
                        self.upperDeckCards[0]!.removeFromSuperview()
                        self.lowerDeckCards[0]!.removeFromSuperview()
                        for i in 0..<4 {
                            self.upperDeckCards[i] = self.upperDeckCards[i+1]
                            self.lowerDeckCards[i] = self.lowerDeckCards[i+1]
                        }
                        self.bridgeButton?.userInteractionEnabled = true
                        self.nextPairButton?.userInteractionEnabled = true
                        
                })
        })
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let bridgePairings = LocalData().getPairings()
        if let bridgePairings = bridgePairings {
            nameSet = [String]()
            locationSet = [String]()
            statusSet = [String]()
            colorSet = [ UIColor]()
            for pairing in bridgePairings {
                if let name = pairing.user1?.name {
                nameSet.append(name)
                }
                else {
                    nameSet.append("Man has no name")
                }
                if let location_values = pairing.user1?.location {
                    let geoCoder = CLGeocoder()
                    let location = CLLocation(latitude: location_values[0], longitude: location_values[1])
                    geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                        
                        var placeMark: CLPlacemark!
                        placeMark = placemarks?[0]
                        if let city = placeMark.addressDictionary!["City"] as? NSString {
                            self.locationSet.append(city as String)
                        }

                        })

                    
                }
                else {
                    locationSet.append("Location has no name")
                }
                if let bridgeStatus = pairing.user1?.bridgeStatus {
                    statusSet.append(bridgeStatus)
                }
                else {
                    statusSet.append("Nah")
                }
                 colorSet.append(UIColor.init(red: 144.0/255, green: 207.0/255, blue: 214.0/255, alpha: 1.0))
                
            }
        }
        
        
        
        let nameFrame = CGRectMake(0.05*cardWidth,0.10*cardHeight,0.55*cardWidth,0.20*cardHeight)
        let locationFrame = CGRectMake(0.60*cardWidth,0.10*cardHeight,0.40*cardWidth,0.20*cardHeight)
        let statusFrame = CGRectMake(0.05*cardWidth,0.31*cardHeight,0.95*cardWidth,0.34*cardHeight)
        let photoFrame = CGRectMake(0.275*cardWidth,0.55*cardHeight,0.45*cardWidth,1.0*cardHeight)
        
        for i in 0..<colorSet.count {
            let upperDeckFrame : CGRect = CGRectMake(screenWidth*(0.08 + ( CGFloat(i) * 0.02)),screenHeight*(0.15 - ( CGFloat(i) * 0.01)), screenWidth*0.8,screenHeight*0.30)
            
            let lowerDeckFrame : CGRect = CGRectMake(screenWidth*(0.08 + ( CGFloat(i) * 0.02)),screenHeight*(0.60 - ( CGFloat(i) * 0.01)), screenWidth*0.8,screenHeight*0.30)
            
            let upperDeckNameLabel = UILabel(frame: nameFrame)
            upperDeckNameLabel.text = nameSet[i]
            let upperDeckLocationLabel = UILabel(frame: locationFrame)
            upperDeckLocationLabel.text = locationSet[i]
            let upperDeckStatusLabel = UILabel(frame: statusFrame)
            upperDeckStatusLabel.text = statusSet[i]
            let upperDeckPhotoView = UIImageView(frame: photoFrame)
            
            let lowerDeckNameLabel = UILabel(frame: nameFrame)
            lowerDeckNameLabel.text = nameSet[i]
            let lowerDeckLocationLabel = UILabel(frame: locationFrame)
            lowerDeckLocationLabel.text = locationSet[i]
            let lowerDeckStatusLabel = UILabel(frame: statusFrame)
            lowerDeckStatusLabel.text = statusSet[i]
            let lowerDeckPhotoView = UIImageView(frame: photoFrame)
            
            
            let upperDeckCard = UIView(frame:upperDeckFrame)
            upperDeckCard.addSubview(upperDeckNameLabel)
            upperDeckCard.addSubview(upperDeckLocationLabel)
            upperDeckCard.addSubview(upperDeckStatusLabel)
            upperDeckCard.addSubview(upperDeckPhotoView)
            upperDeckCard.backgroundColor = colorSet[i]
            upperDeckCards[colorSet.count-1-i] = upperDeckCard
            
            
            let lowerDeckCard = UIView(frame:lowerDeckFrame)
            lowerDeckCard.addSubview(lowerDeckNameLabel)
            lowerDeckCard.addSubview(lowerDeckLocationLabel)
            lowerDeckCard.addSubview(lowerDeckStatusLabel)
            lowerDeckCard.addSubview(lowerDeckPhotoView)
            lowerDeckCard.backgroundColor = colorSet[i]
            lowerDeckCards[colorSet.count-1-i] = lowerDeckCard
            
            upperDeckCard.layer.cornerRadius = 8.0
            upperDeckCard.clipsToBounds = true
            lowerDeckCard.layer.cornerRadius = 8.0
            lowerDeckCard.clipsToBounds = true
            
            view.addSubview(upperDeckCard)
            view.addSubview(lowerDeckCard)
            
        }
        nextPairButton = UIButton(frame: CGRectMake(screenWidth*0.08 ,screenHeight*0.47, screenWidth*0.4,screenHeight*0.07))
        nextPairButton!.backgroundColor = .grayColor()
        
        nextPairButton!.setTitle("Next Pair", forState: .Normal)
        nextPairButton!.addTarget(self, action: #selector(BridgeNewViewController.nextPairButtonTapped), forControlEvents: .TouchUpInside)
        self.view.addSubview(nextPairButton!)
        
        bridgeButton = UIButton(frame: CGRectMake(screenWidth*0.52 ,screenHeight*0.47, screenWidth*0.4,screenHeight*0.07))
        bridgeButton!.backgroundColor = .blueColor()
        bridgeButton!.setTitle("Bridge", forState: .Normal)
        bridgeButton!.addTarget(self, action: #selector(BridgeNewViewController.bridgeButtonTapped), forControlEvents: .TouchUpInside)
        self.view.addSubview(bridgeButton!)
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

