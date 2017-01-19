//
//  OtherProfileViewController.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 1/19/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class OtherProfileViewController: UIViewController {
    let userId: String
    var user: PFUser?
    
    let scrollView = UIScrollView()
    let exitButton = UIButton()
    let privacyButton = UIButton()
    let greetingLabel = UILabel()
    let numNectedLabel = UILabel()
    let topHexView = HexagonView()
    let leftHexView = HexagonView()
    let rightHexView = HexagonView()
    let bottomHexView = HexagonView()
    let messageButton = UIButton()
    let quickUpdateView = UIView()
    let factsView = UIView()
    let factsTextLabel = UILabel()
    
    init(userId: String) {
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUser(user: PFUser) {
        self.user = user
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //Setting Background Color
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        
        scrollView.backgroundColor = .clear
        
        // run query to get user
        if user == nil {
            if let query = PFUser.query() {
                query.whereKey("objectId", equalTo: userId)
                query.getFirstObjectInBackground(block: { (user, error) in
                    if error != nil {
                        print("error - get first object - \(error)")
                    } else if let user = user as? PFUser {
                        self.user = user
                        self.layoutViews()
                    }
                })
            }
        } else {
            layoutViews()
        }
        
    }
    
    func layoutViews() {
        if let user = user {
            // Creating viewed exit icon
            let xIcon = UIImageView(frame: CGRect(x: 0.044*DisplayUtility.screenWidth, y: 0.04384*DisplayUtility.screenHeight, width: 0.03514*DisplayUtility.screenWidth, height: 0.03508*DisplayUtility.screenWidth))
            xIcon.image = UIImage(named: "Black_X")
            view.addSubview(xIcon)
            
            // Creating larger clickable space around exit icon
            exitButton.frame = CGRect(x: xIcon.frame.minX - 0.02*DisplayUtility.screenWidth, y: xIcon.frame.minY - 0.02*DisplayUtility.screenWidth, width: xIcon.frame.width + 0.04*DisplayUtility.screenWidth, height: xIcon.frame.height + 0.04*DisplayUtility.screenWidth)
            exitButton.showsTouchWhenHighlighted = false
            exitButton.addTarget(self, action: #selector(exit(_:)), for: .touchUpInside)
            view.addSubview(exitButton)
            
            // Creating viewed check icon
            let checkIcon = UIImageView(frame: CGRect(x: DisplayUtility.screenWidth - xIcon.frame.minX - 0.05188*DisplayUtility.screenWidth, y: 0, width: 0.05188*DisplayUtility.screenWidth, height: 0.03698*DisplayUtility.screenWidth))
            checkIcon.center.y = xIcon.center.y
            checkIcon.image = UIImage(named: "Gradient_Check")
            view.addSubview(checkIcon)
            
            // Creating larger clickable space around privacy icon
            privacyButton.frame = CGRect(x: checkIcon.frame.minX - 0.02*DisplayUtility.screenWidth, y: checkIcon.frame.minY - 0.02*DisplayUtility.screenWidth, width: checkIcon.frame.width + 0.04*DisplayUtility.screenWidth, height: checkIcon.frame.height + 0.04*DisplayUtility.screenWidth)
            privacyButton.showsTouchWhenHighlighted = false
            //privacyButton.addTarget(self, action: nil, for: .touchUpInside)
            view.addSubview(privacyButton)
            
            // Creating greeting label
            greetingLabel.textColor = .black
            greetingLabel.textAlignment = .center
            greetingLabel.font = UIFont(name: "BentonSans-Light", size: 21)
            var greeting = "Hi,"
            if let userGreeting = user["profile_greeting"] as? String {
                greeting = userGreeting
            }
            if let name = user["name"] as? String {
                let firstName = DisplayUtility.firstName(name: name)
                greetingLabel.text = "\(greeting) I'm \(firstName)."
                greetingLabel.sizeToFit()
                greetingLabel.frame = CGRect(x: 0, y: 0.07969*DisplayUtility.screenHeight, width: greetingLabel.frame.width, height: greetingLabel.frame.height)
                greetingLabel.center.x = DisplayUtility.screenWidth / 2
                view.addSubview(greetingLabel)
            }
            
            numNectedLabel.textColor = .gray
            numNectedLabel.textAlignment = .center
            numNectedLabel.font = UIFont(name: "BentonSans-Light", size: 12)
            numNectedLabel.frame = CGRect(x: 0, y: greetingLabel.frame.maxY + 0.0075*DisplayUtility.screenHeight, width: 0, height: 0)

            if let objectId = user.objectId {
                let query = PFQuery(className: "BridgePairings")
                query.whereKey("connecter_objectId", equalTo: objectId)
                query.whereKey("user1_response", equalTo: 1)
                query.whereKey("user2_response", equalTo: 1)
                query.whereKey("accepted_notification_viewed", equalTo: true)
                query.limit = 1000
                query.countObjectsInBackground(block: { (count, error) in
                    print("numNected query executing...")
                    if let error = error {
                        print("numNected findObjectsInBackgroundWithBlock error - \(error)")
                    }
                    else {
                        let numNected = Int(count)
                        self.numNectedLabel.text = "\(numNected) CONNECTIONS 'NECTED"
                        self.numNectedLabel.sizeToFit()
                        self.numNectedLabel.frame = CGRect(x: 0, y: self.numNectedLabel.frame.minY, width: self.numNectedLabel.frame.width, height: self.numNectedLabel.frame.height)
                        self.numNectedLabel.center.x = DisplayUtility.screenWidth / 2
                        self.view.addSubview(self.numNectedLabel)
                    }
                    
                })
            }
            
            scrollView.frame = CGRect(x: 0, y: greetingLabel.frame.maxY + 0.045*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: 0.955*DisplayUtility.screenHeight - greetingLabel.frame.maxY)
            view.addSubview(scrollView)
            
            scrollView.backgroundColor = .clear
            
            let hexWidth = 0.38154*DisplayUtility.screenWidth
            let hexHeight = hexWidth * sqrt(3) / 2
            
            let downloader = Downloader()
            
            //setting frame for topHexView
            topHexView.frame = CGRect(x: 0, y: 0, width: hexWidth, height: hexHeight)
            topHexView.center.x = DisplayUtility.screenWidth / 2
            scrollView.addSubview(topHexView)
            
            //setting frame for leftHexView
            leftHexView.frame = CGRect(x: topHexView.frame.minX - 0.75*hexWidth - 3, y: topHexView.frame.midY + 2, width: hexWidth, height: hexHeight)
            /*
             if let data = localData.getMainProfilePicture() {
             if let image = UIImage(data: data) {
             self.leftHexView.setBackgroundImage(image: image)
             }
             } else if let urlString = user["profile_picture_url"] as? String, let url = URL(string: urlString) {
             downloader.imageFromURL(URL: url, callBack: { (image) in
             self.leftHexView.setBackgroundImage(image: image)
             //Saviong mainProfilePicture to device if it has not already been saved
             if let data = UIImageJPEGRepresentation(image, 1.0){
             self.localData.setMainProfilePicture(data)
             }
             })
             }
             */
            scrollView.addSubview(leftHexView)
            
            //setting frame for rightHexView
            rightHexView.frame = CGRect(x: topHexView.frame.minX + 0.75*hexWidth + 3, y: topHexView.frame.midY + 2, width: hexWidth, height: hexHeight)
            scrollView.addSubview(rightHexView)
            
            //setting frame for bottomHexView
            bottomHexView.frame = CGRect(x: topHexView.frame.minX, y: topHexView.frame.maxY + 4, width: hexWidth, height: hexHeight)
            scrollView.addSubview(bottomHexView)
            
            if let profilePics = user["profile_pictures"] as? [PFFile] {
                let hexViews = [leftHexView, topHexView, rightHexView, bottomHexView]
                for i in 0..<hexViews.count {
                    if profilePics.count > i {
                        profilePics[i].getDataInBackground(block: { (data, error) in
                            if error != nil {
                                print(error)
                            } else {
                                if let data = data {
                                    if let image = UIImage(data: data) {
                                        hexViews[i].setBackgroundImage(image: image)
                                        //let hexViewGR = UITapGestureRecognizer(target: self, action: #selector(self.profilePicSelected(_:)))
                                        //hexViews[i].addGestureRecognizer(hexViewGR)
                                    }
                                }
                                
                            }
                        })
                    }
                }
            }
            
            // layout message button
            let messageButtonWidth = 0.34666*DisplayUtility.screenWidth
            let messageButtonHeight = 53.75 / 260.0 * messageButtonWidth
            messageButton.frame = CGRect(x: 0, y: bottomHexView.frame.maxY + 0.03*DisplayUtility.screenHeight, width: messageButtonWidth, height: messageButtonHeight)
            messageButton.center.x = DisplayUtility.screenWidth / 2
            messageButton.setImage(UIImage(named: "Message_Button"), for: .normal)
            scrollView.addSubview(messageButton)
            
            let line = UIView()
            let gradientLayer = DisplayUtility.getGradient()
            line.backgroundColor = .clear
            line.layer.insertSublayer(gradientLayer, at: 0)
            line.frame = CGRect(x: 0, y: messageButton.frame.maxY + 0.02*DisplayUtility.screenHeight, width: 0.8*DisplayUtility.screenWidth, height: 1)
            line.center.x = DisplayUtility.screenWidth / 2
            gradientLayer.frame = line.bounds
            scrollView.addSubview(line)
            
            var yOffsetFromLine: CGFloat = 0
            
            // Creating "Quick-Update" section
            if let quickUpdate = user["quick_update"] as? String {
                let quickUpdateLabel = UILabel()
                quickUpdateLabel.text = "QUICK-UPDATE"
                quickUpdateLabel.textColor = .black
                quickUpdateLabel.textAlignment = .center
                quickUpdateLabel.font = UIFont(name: "BentonSans-Light", size: 12)
                quickUpdateLabel.sizeToFit()
                quickUpdateLabel.frame = CGRect(x: 0, y: 0, width: quickUpdateLabel.frame.width, height: quickUpdateLabel.frame.height)
                quickUpdateLabel.center.x = DisplayUtility.screenWidth / 2
                quickUpdateView.addSubview(quickUpdateLabel)
                
                let quickUpdateTextLabel = UILabel()
                quickUpdateTextLabel.text = quickUpdate
                quickUpdateTextLabel.numberOfLines = 0
                quickUpdateTextLabel.font = UIFont(name: "BentonSans-Light", size: 17)
                quickUpdateTextLabel.adjustsFontSizeToFitWidth = true
                quickUpdateTextLabel.minimumScaleFactor = 0.5
                quickUpdateTextLabel.textColor = .black
                quickUpdateTextLabel.textAlignment = .center
                quickUpdateTextLabel.frame = CGRect(x: 0, y: quickUpdateLabel.frame.maxY + 0.03*DisplayUtility.screenHeight, width: 0.9*DisplayUtility.screenWidth, height: 0)
                quickUpdateTextLabel.sizeToFit()
                quickUpdateTextLabel.center.x = DisplayUtility.screenWidth / 2
                quickUpdateView.addSubview(quickUpdateTextLabel)
                
                quickUpdateView.frame = CGRect(x: 0, y: line.frame.maxY + yOffsetFromLine + 0.03*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: quickUpdateTextLabel.frame.maxY)
                scrollView.addSubview(quickUpdateView)
                
                yOffsetFromLine = quickUpdateView.frame.maxY - line.frame.maxY
            }
            
            let factsLabel = UILabel()
            factsLabel.text = "THE FACTS"
            factsLabel.textColor = .black
            factsLabel.textAlignment = .center
            factsLabel.font = UIFont(name: "BentonSans-Light", size: 12)
            factsLabel.sizeToFit()
            factsLabel.frame = CGRect(x: 0, y: 0, width: factsLabel.frame.width, height: factsLabel.frame.height)
            factsLabel.center.x = DisplayUtility.screenWidth / 2
            factsView.addSubview(factsLabel)
            
            factsTextLabel.font = UIFont(name: "BentonSans-Light", size: 17)
            factsTextLabel.adjustsFontSizeToFitWidth = true
            factsTextLabel.minimumScaleFactor = 0.5
            factsTextLabel.textColor = .black
            factsTextLabel.textAlignment = .center
            factsTextLabel.frame = CGRect(x: 0, y: factsLabel.frame.maxY + 0.03*DisplayUtility.screenHeight, width: 0.9*DisplayUtility.screenWidth, height: 0)
            
            if writeFacts() { // facts to write
                factsTextLabel.sizeToFit()
                factsTextLabel.center.x = DisplayUtility.screenWidth / 2
                factsView.addSubview(factsTextLabel)
                
                factsView.frame = CGRect(x: 0, y: line.frame.maxY + yOffsetFromLine + 0.05*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: factsTextLabel.frame.maxY)
                scrollView.addSubview(factsView)
                
                yOffsetFromLine = factsView.frame.maxY - line.frame.maxY
            }
            
            if yOffsetFromLine != 0 {
                let line2 = UIView()
                let gradientLayer = DisplayUtility.getGradient()
                line2.backgroundColor = .clear
                line2.layer.insertSublayer(gradientLayer, at: 0)
                line2.frame = CGRect(x: 0, y: line.frame.maxY + yOffsetFromLine + 0.03*DisplayUtility.screenHeight, width: 0.8*DisplayUtility.screenWidth, height: 1)
                line2.center.x = DisplayUtility.screenWidth / 2
                gradientLayer.frame = line2.bounds
                scrollView.addSubview(line2)
                
                yOffsetFromLine = line2.frame.maxY - line.frame.maxY
            }

        }
    }
    
    func exit(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    func writeFacts() -> Bool {
        if let user = user {
            if let selectedFacts = user["selected_facts"] as? [String] {
                var factsText = ""
                var facts = [String]()
                
                if selectedFacts.contains("Age") {
                    if let age = user["age"] as? Int {
                        facts.append("I'm \(age)")
                    }
                }
                if selectedFacts.contains("City") {
                    if let city = user["city"] as? String {
                        if let currentCity = user["current_city"] as? Bool {
                            if currentCity {
                                facts.append("I live in \(city)")
                            } else {
                                facts.append("I lived in \(city)")
                            }
                        } else {
                            facts.append("I lived in \(city)")
                        }
                    }
                }
                if selectedFacts.contains("School") {
                    if let school = user["school"] as? String {
                        if let currentStudent = user["current_student"] as? Bool {
                            if currentStudent {
                                facts.append("I go to \(school)")
                            } else {
                                facts.append("I went to \(school)")
                            }
                        } else {
                            facts.append("I went to \(school)")
                        }
                    }
                }
                if selectedFacts.contains("Work") {
                    if let work = user["work"] as? String {
                        if let currentWork = user["current_work"] as? Bool {
                            if currentWork {
                                facts.append("I work at \(work)")
                            } else {
                                facts.append("I worked at \(work)")
                            }
                        } else {
                            facts.append("I worked at \(work)")
                        }
                    }
                }
                if selectedFacts.contains("Religion") {
                    if let religion = user["religion"] as? String {
                        facts.append("I am \(religion)")
                    }
                }
                if facts.count > 0 {
                    for i in 0..<facts.count {
                        if i == facts.count - 1 {
                            factsText = "\(factsText) \(facts[i])."
                        } else {
                            factsText = "\(factsText) \(facts[i]),"
                        }
                    }
                    factsTextLabel.text = factsText
                    
                    return true
                }
            }
        }
        return false
    }

}
