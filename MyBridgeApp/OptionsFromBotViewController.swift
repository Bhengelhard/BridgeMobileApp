//
//  OptionsFromBotViewController.swift
//  MyBridgeApp
//
//  Created by Blake H. Engelhard on 8/22/16.
//  Copyright © 2016 BHE Ventures LLC. All rights reserved.
//

import UIKit
import Parse

class OptionsFromBotViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var myTimer = Timer()
    var counter = 0
    
    
    let selectTypeLabel = UILabel()
    let optionsTableView = UITableView()
    let cancelButton = UIButton()
    let editProfileButton = UIButton()
    let username = UILabel()
    var firstName = String()
    
    let localData = LocalData()
    let transitionManager = TransitionManager()
    
    var seguedFrom = ""
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let necterYellow = UIColor(red: 255/255, green: 230/255, blue: 57/255, alpha: 1.0)
    let businessBlue = UIColor(red: 36.0/255, green: 123.0/255, blue: 160.0/255, alpha: 1.0)
    let loveRed = UIColor(red: 242.0/255, green: 95.0/255, blue: 92.0/255, alpha: 1.0)
    let friendshipGreen = UIColor(red: 112.0/255, green: 193.0/255, blue: 179.0/255, alpha: 1.0)
    let necterGray = UIColor(red: 80.0/255.0, green: 81.0/255.0, blue: 79.0/255.0, alpha: 1.0)
    var necterType = ""
    
    
    func cancelTapped(_ sender: UIButton ){
        cancelButton.isSelected = true
        performSegueToPriorView()
    }
    func editProfileTapped(_ sender: UIButton ){
        editProfileButton.isSelected = true
        performSegue(withIdentifier: "showEditProfileViewFromOptionsView", sender: self)
    }
    
    func performSegueToPriorView() {
        if seguedFrom == "ProfileViewController" {
            performSegue(withIdentifier: "showProfilePageFromOptionsView", sender: self)
        } else if seguedFrom == "BridgeViewController" {
            performSegue(withIdentifier: "showBridgePageFromOptionsView", sender: self)
        } else if seguedFrom == "MessagesViewController" {
            performSegue(withIdentifier: "showMessagesViewfromOptionsView", sender: self)
        } else {
            //default case
            performSegue(withIdentifier: "showBridgePageFromOptionsView", sender: self)
        }
    }
    
    func fireTimer(){
        print("Timer fired - \(counter)")
        counter += 1
        if counter == 4 {
            // This might need to be myScheduledTimer
            print("Time is being invalidated")
            myTimer.invalidate()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        if let name = localData.getUsername() {
            username.text = name
        }
        else {
            username.text = "Enter Name on your Profile"
        }
        username.textColor = UIColor.white
        username.font = UIFont(name: "BentonSans", size: 20)
        
        if username.text != "Enter name on your Profile" {
            if let username = username.text {
                firstName = username.components(separatedBy: " ").first!
            }
        }
        
        //setting up instructions and buttons
        selectTypeLabel.frame = CGRect(x: 0.05*screenWidth, y: 0.045*screenHeight, width: 0.9*screenWidth, height: 0.25*screenHeight)
        //setting multi-font label
        let greeting = "Hello \(firstName), \n\nWhat type of connection are you looking for?" as NSString
        var attributedGreeting = NSMutableAttributedString(string: greeting as String, attributes: [NSFontAttributeName: UIFont.init(name: "Verdana-Bold", size: 22)!])
        // Part of string to be bolded
        selectTypeLabel.textAlignment = NSTextAlignment.left
        selectTypeLabel.numberOfLines = 0
        selectTypeLabel.textColor = necterGray
        selectTypeLabel.alpha = 0
        
        view.addSubview(selectTypeLabel)

        //adding the optionsTableView
        optionsTableView.register(StatusTableViewCell.self, forCellReuseIdentifier: "cell")
        optionsTableView.frame = CGRect(x: 0, y: 0.3*screenHeight, width: screenWidth, height: 0.6*screenHeight)
        optionsTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        optionsTableView.tableFooterView = UIView()
        optionsTableView.rowHeight = optionsTableView.frame.size.height/CGFloat(optionsTableView.numberOfRows(inSection: 0))
        optionsTableView.alpha = 0.001
        optionsTableView.isScrollEnabled = false
        view.addSubview(optionsTableView)
        
        //Bot that fades in and down to speak with you
//        let _ = Timer.init(interval: 1) { (i) -> Bool in
//            print("Timer worked")
//            return i < 2
//        }
        //var t = Timer.init(interval: TimeInterval, handler: Timer.TimerFunction)
//        var timer = Timer.init(timeInterval: 0.4, target: self,userInfo: nil, repeats: true)
// 
//        
//        let t = Timer(fireAt: Date().addTimeInterval(TimeInterval(1.0)), interval: 1.0, target: self, selector: #selector(timerFired(_:)), userInfo: nil, repeat: true)
        //let t = Timer.scheduleTimer(TimeInterval: 1.0, target: self, selector: #selector(timerFired(_:)), userInfor)
        
        
        
        
        let _ = CustomTimer(interval: 0.25) {i -> Bool in
        
            print("started Up the Timer")
        
//        let myScheduledTimer = Timer(timeInterval: 1, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
//        
//        myScheduledTimer.fire()
//        
            UIView.animate(withDuration: 0.7, delay: 0.2, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
//                if i == 0 {
                    self.selectTypeLabel.frame = CGRect(x: 0.05*self.screenWidth, y: 0.05*self.screenHeight, width: 0.9*self.screenWidth, height: 0.25*self.screenHeight)
                    let attributedGreeting2 = NSMutableAttributedString(string: greeting as String, attributes: [NSFontAttributeName: UIFont.init(name: "Verdana", size: 22)!])
                //Adding attributes to particular portions of the strings
                let boldedFontAttribute = [NSFontAttributeName: UIFont.init(name: "Verdana-Bold", size: 22) as Any]
                let boldedFontRange = greeting.range(of: "Hello \(self.firstName)")
                attributedGreeting2.addAttributes([:], range: boldedFontRange)
                let lineBreakAttribute = [NSFontAttributeName: UIFont.init(name: "Verdana-Bold", size: 10) as Any]
                let lineBreakRange = greeting.range(of: "\n\n")
                attributedGreeting2.addAttributes([:], range: lineBreakRange)
                
                self.selectTypeLabel.attributedText = attributedGreeting2
                    self.selectTypeLabel.alpha = 1.0
//                } else if i == 2 {
                    self.optionsTableView.alpha = 1.0
//                }
                
                })
            return i < 4
      }
        
        //Bot that pops in to speak with you
        /*let _ = Timer(interval: 0.5) {i -> Bool in
         if i == 1 {
         self.selectTypeLabel.attributedText = attributedGreeting
         self.selectTypeLabel.alpha = 1.0
         } else if i == 2 {
         greeting = "Hello \(self.firstName), \n\nWhat type of connection are you looking for?"
         let attributedGreeting2 = NSMutableAttributedString(string: greeting as String, attributes: [NSFontAttributeName: UIFont.init(name: "Verdana", size: 22)!])
         let boldedFontAttribute = [NSFontAttributeName: UIFont.init(name: "Verdana-Bold", size: 22) as! AnyObject]
         let lineBreakAttribute = [NSFontAttributeName: UIFont.init(name: "Verdana-Bold", size: 10) as! AnyObject]
         attributedGreeting2.addAttributes(boldedFontAttribute, range: greeting.rangeOfString("Hello \(self.firstName),"))
         print(attributedGreeting)
         attributedGreeting2.addAttributes(lineBreakAttribute, range: greeting.rangeOfString("\n\n"))
         print(attributedGreeting)
         self.selectTypeLabel.attributedText = attributedGreeting2
         } else if i == 3 {
         self.optionsTableView.alpha = 1.0
         }
         print(i)
         return i < 4
         }*/
        
        
        
        //Bot that types in to speak with you
        /*let _ = Timer(interval: 0.5) {i -> Bool in
         //self.selectTypeLabel.attributedText = attributedGreeting.attributedSubstringFromRange(NSRange(location: 0, length: i+1))
         //return i + 1 < attributedGreeting.string.characters.count
         if i == 1 {
         self.selectTypeLabel.attributedText = attributedGreeting
         self.selectTypeLabel.alpha = 1.0
         } else if i == 2 {
         greeting = "Hello \(self.firstName), \n\nWhat type of connection are you looking for?"
         let attributedGreeting2 = NSMutableAttributedString(string: greeting as String, attributes: [NSFontAttributeName: UIFont.init(name: "Verdana", size: 22)!])
         let boldedFontAttribute = [NSFontAttributeName: UIFont.init(name: "Verdana-Bold", size: 22) as! AnyObject]
         let lineBreakAttribute = [NSFontAttributeName: UIFont.init(name: "Verdana-Bold", size: 10) as! AnyObject]
         attributedGreeting2.addAttributes(boldedFontAttribute, range: greeting.rangeOfString("Hello \(self.firstName),"))
         print(attributedGreeting)
         attributedGreeting2.addAttributes(lineBreakAttribute, range: greeting.rangeOfString("\n\n"))
         print(attributedGreeting)
         self.selectTypeLabel.attributedText = attributedGreeting2
         } else if i == 3 {
         self.optionsTableView.alpha = 1.0
         }
         print(i)
         return i < 4
         }*/
        
        /*let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC)))
         dispatch_after(delayTime, dispatch_get_main_queue()) {
         self.optionsTableView.alpha = 1.0
         /*UIView.animateWithDuration(0.3) {
         self.optionsTableView.alpha = 1.0
         }*/
         }*/
        
        
        
 
        
        
        //adding the cancel button
        //cancelButton.frame = CGRect(x: 0, y:0.9*screenHeight, width:0.3*screenWidth, height:0.06*screenHeight)
        cancelButton.frame = CGRect(x: 0.62*screenWidth, y:0.9*screenHeight, width:0.33*screenWidth, height:0.06*screenHeight)
        //cancelButton.center.x = view.center.x
        cancelButton.layer.borderWidth = 4.0
        cancelButton.layer.borderColor = necterGray.cgColor
        cancelButton.layer.cornerRadius = 7.0
        cancelButton.setTitle("cancel", for: UIControlState())
        cancelButton.setTitleColor(necterGray, for: UIControlState())
        cancelButton.setTitleColor(necterYellow, for: .highlighted)
        cancelButton.setTitleColor(necterYellow, for: .selected)
        cancelButton.titleLabel!.font = UIFont(name: "BentonSans", size: 20)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        //adding the cancel button
        editProfileButton.frame = CGRect(x: 0.05*screenWidth, y:0.9*screenHeight, width:0.33*screenWidth, height:0.06*screenHeight)
        //editProfileButton.center.x = view.center.x
        editProfileButton.layer.borderWidth = 4.0
        editProfileButton.layer.borderColor = necterGray.cgColor
        editProfileButton.layer.cornerRadius = 7.0
        editProfileButton.setTitle("edit profile", for: UIControlState())
        editProfileButton.setTitleColor(necterGray, for: UIControlState())
        editProfileButton.setTitleColor(necterYellow, for: .highlighted)
        editProfileButton.setTitleColor(necterYellow, for: .selected)
        editProfileButton.titleLabel!.font = UIFont(name: "BentonSans", size: 20)
        editProfileButton.addTarget(self, action: #selector(editProfileTapped), for: .touchUpInside)
        view.addSubview(editProfileButton)

        
        //adding the view elements to the NewBridgeStatusViewController
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Setting Up the optionsTable
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //returns the number of rows
        
        return 3
        
    }
    
    // Data to be shown on an individual row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = StatusTableViewCell()//optionsTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! StatusTableViewCell
        cell.cellHeight = optionsTableView.frame.size.height/CGFloat(optionsTableView.numberOfRows(inSection: 0))
        //CGRect(x: 0.1*self.frame.width, y: 0, width: 0.2*self.frame.width, height: 0.2*self.frame.width)
        //optionImage.center.y = self.center.y
        //setting the information in the rows of the optionTableView
        if (indexPath as NSIndexPath).row == 0 {
            //cell.optionImage.image = cell.optionImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            //Setting whether the user is interested in business
            if let businessInterest = PFUser.current()?["interested_in_business"] as? Bool {
                if businessInterest {
                    cell.optionImage.image = UIImage(named: "Business_Icon_Blue")
                    cell.optionLabel.text = "Business"
                    cell.optionLabel.textColor = businessBlue
                } else {
                    cell.optionImage.image = UIImage(named: "Business_Icon_Gray")
                    cell.optionLabel.text = "Business"
                    cell.optionLabel.textColor = necterGray
                    cell.isUserInteractionEnabled = false
                }
            }
            else {
                cell.optionImage.image = UIImage(named: "Business_Icon_Blue")
                cell.optionLabel.text = "Business"
                cell.optionLabel.textColor = businessBlue
            }
            
            //cell.backgroundColor = UIColor(red: 144.0/255, green: 207.0/255, blue: 214.0/255, alpha: 1.0)
        } else if (indexPath as NSIndexPath).row == 1 {
            //Setting whether the user is interested in love
            if let loveInterest = PFUser.current()?["interested_in_love"] as? Bool {
                if loveInterest {
                    cell.optionImage.image = UIImage(named: "Love_Icon_Red")
                    cell.optionLabel.text = "Love"
                    cell.optionLabel.textColor = loveRed

                } else {
                    cell.optionImage.image = UIImage(named: "Love_Icon_Gray")
                    cell.optionLabel.text = "Love"
                    cell.optionLabel.textColor = necterGray
                    cell.isUserInteractionEnabled = false
                }
            }
            else {
                cell.optionImage.image = UIImage(named: "Love_Icon_Red")
                cell.optionLabel.text = "Love"
                cell.optionLabel.textColor = loveRed
            }
        } else {
            //Setting whether the user is interested in friendship
            if let friendshipInterest = PFUser.current()?["interested_in_friendship"] as? Bool {
                if friendshipInterest {
                    cell.optionImage.image = UIImage(named: "Friendship_Icon_Green")
                    cell.optionLabel.text = "Friendship"
                    cell.optionLabel.textColor = friendshipGreen
                } else {
                    cell.optionImage.image = UIImage(named: "Friendship_Icon_Gray")
                    cell.optionLabel.text = "Friendship"
                    cell.optionLabel.textColor = necterGray
                    cell.isUserInteractionEnabled = false
                }
            }
            else {
                cell.optionImage.image = UIImage(named: "Friendship_Icon_Green")
                cell.optionLabel.text = "Friendship"
                cell.optionLabel.textColor = friendshipGreen
            }
            
        }
        
        return cell
        
    }
    // A row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).row == 0 {
            necterType = "Business"
            performSegue(withIdentifier: "showNewStatusFromOptionsView", sender: self)
        } else if (indexPath as NSIndexPath).row == 1 {
            necterType = "Love"
            performSegue(withIdentifier: "showNewStatusFromOptionsView", sender: self)
        } else {
            necterType = "Friendship"
            performSegue(withIdentifier: "showNewStatusFromOptionsView", sender: self)
            
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination
        let mirror = Mirror(reflecting: vc)
        if mirror.subjectType == BridgeViewController.self {
            self.transitionManager.animationDirection = "Bottom"
        } else if mirror.subjectType == ProfileViewController.self {
            self.transitionManager.animationDirection = "Bottom"
        } else if mirror.subjectType == MessagesViewController.self {
            self.transitionManager.animationDirection = "Bottom"
        } else if mirror.subjectType == NewBridgeStatusViewController.self {
            self.transitionManager.animationDirection = "Right"
            let vc2 = vc as! NewBridgeStatusViewController
            vc2.seguedFrom = seguedFrom
            vc2.necterType = necterType
        } else if mirror.subjectType == EditProfileViewController.self {
            self.transitionManager.animationDirection = "Left"
            let vc2 = vc as! EditProfileViewController
            vc2.tempSeguedFrom = "OptionsFromBotViewController"
            vc2.seguedFrom = seguedFrom
        }
        vc.transitioningDelegate = self.transitionManager
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
