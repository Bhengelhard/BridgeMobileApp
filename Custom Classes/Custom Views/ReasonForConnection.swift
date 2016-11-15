//
//  ReasonForConnection.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 11/14/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class ReasonForConnection: UIView {

    
    var swipeCard = SwipeCard()
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: DisplayUtility.screenHeight)
        self.alpha = 0
        let displayUtility = DisplayUtility()
        displayUtility.setBlurredView(viewToBlur: self)
        
        UIView.animate(withDuration: 0.4, animations: {
           self.alpha = 1
        })
        
        displayNavBar()
    }
    
    convenience init () {
        self.init(frame: CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This is a fatal error message from CustomClasses/CustomViews/SwipeCard.swift")
    }
    
    func sendSwipeCard(swipeCardView: SwipeCard) {
        swipeCard = swipeCardView
        print("initializing reason for connection view")
        
        displayUserPhotos()
    }
    
    func displayNavBar() {
        let cancelButton = UIButton()
        cancelButton.frame = CGRect(x: 0, y: 0, width: 0.1*DisplayUtility.screenWidth, height: 0.1*DisplayUtility.screenHeight)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        self.addSubview(cancelButton)
        
        let cancelIcon = UIImageView()
        cancelIcon.frame = CGRect(x: 0.05*DisplayUtility.screenWidth, y: 0.05*DisplayUtility.screenHeight, width: 0.0328*DisplayUtility.screenWidth, height: 0.0206*DisplayUtility.screenHeight)
        cancelIcon.image = #imageLiteral(resourceName: "X_Icon")
        self.addSubview(cancelIcon)
        
        let title = UILabel()
        title.frame = CGRect(x: 0, y: 0.08*DisplayUtility.screenHeight, width: 0.8606*DisplayUtility.screenWidth, height: 0.0382*DisplayUtility.screenHeight)
        title.center.x = self.center.x
        title.text = "Sweet! You're almost there."
        title.textColor = UIColor.white
        title.font = UIFont(name: "BentonSans-Light", size: 20)
        title.textAlignment = NSTextAlignment.center
        self.addSubview(title)
        
    }
    
    @objc func cancelButtonTapped(_ sender: UIButton) {
        print("cancelButtonTapped")
        /*UIView.animate(withDuration: 0.4, animations: {
            self.alpha = 0
        })*/
        self.removeFromSuperview()
        
        //bring back last card into place
        let bridgeVC = BridgeViewController()
        bridgeVC.connectionCanceled(swipeCardView: swipeCard)
    }
    
    func displayUserPhotos() {
        let user1Photo = UIImageView()
        user1Photo.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        //user1Photo.layer.borderWidth = 1
        //user1Photo.layer.borderColor = UIColor.white.cgColor
        user1Photo.image = swipeCard.user1Photo
        self.addSubview(user1Photo)
        
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */


}
