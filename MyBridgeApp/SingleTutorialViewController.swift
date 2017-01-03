//
//  PostTutorialViewController.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 12/14/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit

class SingleTutorialViewController: UIViewController {
    
    let boundary = UIImageView()
    let titleLabel: UILabel
    let explanationLabel: UILabel
    //let videoURL: String
    let videoFilename: String
    let videoExtension: String
    //let video = UIWebView()
    var moviePlayer = MPMoviePlayerController()
    
    init(titleLabel: UILabel, explanationLabel: UILabel, videoFilename: String, videoExtension: String) {
        self.titleLabel = titleLabel
        self.explanationLabel = explanationLabel
        self.videoFilename = videoFilename
        self.videoExtension = videoExtension
        
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        let (titleLabel, explanationLabel) = SingleTutorialViewController.nectLabels()
        self.init(titleLabel: titleLabel, explanationLabel: explanationLabel, videoFilename: "", videoExtension: "")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let phone = UIImageView()
        phone.image = UIImage(named: "Tutorial_Phone")
        phone.frame = CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: 1.09*DisplayUtility.screenHeight)
        view.addSubview(phone)
        
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        whiteView.frame = CGRect(x: 0, y: 0, width: phone.frame.width, height: 0.1444*phone.frame.height)
        phone.addSubview(whiteView)
        
        //let boundary = UIImageView()
        boundary.image = UIImage(named: "Tutorial_VideoBoundary")
        boundary.frame = CGRect(x: 0, y: 0.18823*DisplayUtility.screenHeight, width: 0.7139*DisplayUtility.screenWidth, height: 0.77616*DisplayUtility.screenHeight)
        boundary.center.x = DisplayUtility.screenWidth / 2
        view.addSubview(boundary)
        
        view.addSubview(titleLabel)
        view.addSubview(explanationLabel)
        
        /*
        video.frame = CGRect(x: boundary.frame.minX+1, y: boundary.frame.minY+1, width: boundary.frame.width-2, height: boundary.frame.height-2)
        //video.scalesPageToFit = true
        video.scrollView.isScrollEnabled = false
        */

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /*
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {
            print("error with audi session")
        }
         */
        
        if let path = Bundle.main.path(forResource: videoFilename, ofType: videoExtension) {
            let url = NSURL.fileURL(withPath: path)
            moviePlayer = MPMoviePlayerController(contentURL: url)
            moviePlayer.view.frame = CGRect(x: boundary.frame.minX+1, y: boundary.frame.minY+1, width: boundary.frame.width-2, height: boundary.frame.height-2)
            moviePlayer.scalingMode = MPMovieScalingMode.fill
            moviePlayer.isFullscreen = false
            moviePlayer.controlStyle = MPMovieControlStyle.default
            moviePlayer.movieSourceType = MPMovieSourceType.file
            moviePlayer.play()
            DispatchQueue.main.async {
                self.view.addSubview(self.moviePlayer.view)
            }
        }
    }
    
    static func postLabels() -> (UILabel, UILabel) {
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 0.10512*DisplayUtility.screenWidth, y: 0.09382*DisplayUtility.screenHeight, width: 0.0, height: 0.0)
        titleLabel.text = "post."
        titleLabel.font = UIFont(name: "BentonSans-Light", size: 26)
        titleLabel.textColor = .black
        titleLabel.sizeToFit()
        
        let explanationLabel = UILabel()
        explanationLabel.frame = CGRect(x: 0.33255*DisplayUtility.screenWidth, y: 0.08219*DisplayUtility.screenHeight, width: 0.57*DisplayUtility.screenWidth, height: 0.05606*DisplayUtility.screenHeight)
        explanationLabel.center.y = titleLabel.center.y
        explanationLabel.numberOfLines = 2
        explanationLabel.text = "Post a request for your\nfriends to better 'nect you."
        explanationLabel.font = UIFont(name: "BentonSans-Light", size: 18)
        explanationLabel.textAlignment = .center
        explanationLabel.textColor = .black
        explanationLabel.adjustsFontSizeToFitWidth = true
        
        return (titleLabel, explanationLabel)
    }
    
    static func nectLabels() -> (UILabel, UILabel) {
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 0.08281*DisplayUtility.screenWidth, y: 0.09382*DisplayUtility.screenHeight, width: 0.0, height: 0.0)
        titleLabel.text = "'nect."
        titleLabel.font = UIFont(name: "BentonSans-Light", size: 26)
        titleLabel.textColor = .black
        titleLabel.sizeToFit()
        
        let explanationLabel = UILabel()
        explanationLabel.frame = CGRect(x: 0.35397*DisplayUtility.screenWidth, y: 0.08219*DisplayUtility.screenHeight, width: 0.53*DisplayUtility.screenWidth, height: 0.05606*DisplayUtility.screenHeight)
        explanationLabel.center.y = titleLabel.center.y
        explanationLabel.numberOfLines = 2
        explanationLabel.text = "Swipe right to introduce.\nSwipe left to see more."
        explanationLabel.font = UIFont(name: "BentonSans-Light", size: 18)
        explanationLabel.textAlignment = .center
        explanationLabel.textColor = .black
        explanationLabel.adjustsFontSizeToFitWidth = true
        
        return (titleLabel, explanationLabel)
    }
    
    static func chatLabels() -> (UILabel, UILabel) {
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 0.10512*DisplayUtility.screenWidth, y: 0.09382*DisplayUtility.screenHeight, width: 0.0, height: 0.0)
        titleLabel.text = "chat."
        titleLabel.font = UIFont(name: "BentonSans-Light", size: 26)
        titleLabel.textColor = .black
        titleLabel.sizeToFit()
        
        let explanationLabel = UILabel()
        explanationLabel.frame = CGRect(x: 0.32928*DisplayUtility.screenWidth, y: 0.08219*DisplayUtility.screenHeight, width: 0.58*DisplayUtility.screenWidth, height: 0.05606*DisplayUtility.screenHeight)
        explanationLabel.center.y = titleLabel.center.y
        explanationLabel.numberOfLines = 2
        explanationLabel.text = "Get to know the poeple\nyou've been introduced to."
        explanationLabel.font = UIFont(name: "BentonSans-Light", size: 18)
        explanationLabel.textAlignment = .center
        explanationLabel.textColor = .black
        explanationLabel.adjustsFontSizeToFitWidth = true
        
        return (titleLabel, explanationLabel)
    }

}
