//
//  OptionsFromBotViewController.swift
//  MyBridgeApp
//
//  Created by Daniel Fine on 8/22/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class OptionsFromBotViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let selectTypeLabel = UILabel()
    let optionsTableView = UITableView()
    let cancelButton = UIButton()
    let username = UILabel()
    var firstName = String()
    
    let localData = LocalData()
    let transitionManager = TransitionManager()
    
    var seguedFrom = ""
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    let necterYellow = UIColor(red: 255/255, green: 230/255, blue: 57/255, alpha: 1.0)
    let businessBlue = UIColor(red: 36.0/255, green: 123.0/255, blue: 160.0/255, alpha: 1.0)
    let loveRed = UIColor(red: 242.0/255, green: 95.0/255, blue: 92.0/255, alpha: 1.0)
    let friendshipGreen = UIColor(red: 112.0/255, green: 193.0/255, blue: 179.0/255, alpha: 1.0)
    let necterGray = UIColor(red: 80.0/255.0, green: 81.0/255.0, blue: 79.0/255.0, alpha: 1.0)
    var necterType = ""
    
    
    func cancelTapped(sender: UIButton ){
        performSegueToPriorView()
    }
    
    func performSegueToPriorView() {
        if seguedFrom == "ProfileViewController" {
            performSegueWithIdentifier("showProfilePageFromOptionsView", sender: self)
        } else if seguedFrom == "BridgeViewController" {
            performSegueWithIdentifier("showBridgePageFromOptionsView", sender: self)
        } else if seguedFrom == "MessagesViewController" {
            performSegueWithIdentifier("showMessagesViewfromOptionsView", sender: self)
        } else {
            //default case
            performSegueWithIdentifier("showBridgePageFromOptionsView", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        if let name = localData.getUsername() {
            username.text = name
            
            print("got username")
        }
        else {
            username.text = "Enter Name on your Profile"
        }
        username.textColor = UIColor.whiteColor()
        username.font = UIFont(name: "BentonSans", size: 20)
        
        if username.text != "Enter name on your Profile" {
            if let username = username.text {
                firstName = username.componentsSeparatedByString(" ").first!
            }
        }
        
        //setting up instructions and buttons
        selectTypeLabel.frame = CGRect(x: 0.05*screenWidth, y: 0.045*screenHeight, width: 0.9*screenWidth, height: 0.25*screenHeight)
        //setting multi-font label
        var greeting = "Hello \(firstName), \n\nWhat type of connection are you looking for?" as NSString
        var attributedGreeting = NSMutableAttributedString(string: greeting as String, attributes: [NSFontAttributeName: UIFont.init(name: "Verdana-Bold", size: 22)!])
        // Part of string to be bolded
        selectTypeLabel.textAlignment = NSTextAlignment.Left
        selectTypeLabel.numberOfLines = 0
        selectTypeLabel.textColor = necterGray
        selectTypeLabel.alpha = 0
        
        view.addSubview(selectTypeLabel)
        
        
        //Bot that fades in and down to speak with you
        let _ = Timer(interval: 0.25) {i -> Bool in
            
            UIView.animateWithDuration(0.7, delay: 0.2, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
                if i == 0 {
                    self.selectTypeLabel.frame = CGRect(x: 0.05*self.screenWidth, y: 0.05*self.screenHeight, width: 0.9*self.screenWidth, height: 0.25*self.screenHeight)
                    let attributedGreeting2 = NSMutableAttributedString(string: greeting as String, attributes: [NSFontAttributeName: UIFont.init(name: "Verdana", size: 22)!])
                    let boldedFontAttribute = [NSFontAttributeName: UIFont.init(name: "Verdana-Bold", size: 22) as! AnyObject]
                    let lineBreakAttribute = [NSFontAttributeName: UIFont.init(name: "Verdana-Bold", size: 10) as! AnyObject]
                    attributedGreeting2.addAttributes(boldedFontAttribute, range: greeting.rangeOfString("Hello \(self.firstName),"))
                    attributedGreeting2.addAttributes(lineBreakAttribute, range: greeting.rangeOfString("\n\n"))
                    self.selectTypeLabel.attributedText = attributedGreeting2
                    self.selectTypeLabel.alpha = 1
                } else if i == 2 {
                    self.optionsTableView.alpha = 1.0
                }
                
                }, completion: nil)
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
        
        
        
        //adding the optionsTableView
        optionsTableView.registerClass(StatusTableViewCell.self, forCellReuseIdentifier: "cell")
        optionsTableView.frame = CGRect(x: 0, y: 0.3*screenHeight, width: screenWidth, height: 0.6*screenHeight)
        optionsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        optionsTableView.tableFooterView = UIView()
        optionsTableView.rowHeight = optionsTableView.frame.size.height/CGFloat(optionsTableView.numberOfRowsInSection(0))
        optionsTableView.alpha = 0
        view.addSubview(optionsTableView)
        
        
        //adding the cancel button
        cancelButton.frame = CGRect(x: 0, y:0.9*screenHeight, width:0.3*screenWidth, height:0.06*screenHeight)
        cancelButton.center.x = view.center.x
        cancelButton.layer.borderWidth = 4.0
        cancelButton.layer.borderColor = necterGray.CGColor
        cancelButton.layer.cornerRadius = 7.0
        cancelButton.setTitle("cancel", forState: .Normal)
        cancelButton.setTitleColor(necterGray, forState: .Normal)
        cancelButton.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
        cancelButton.titleLabel!.font = UIFont(name: "BentonSans", size: 20)
        cancelButton.addTarget(self, action: #selector(cancelTapped), forControlEvents: .TouchUpInside)
        view.addSubview(cancelButton)
        
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
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //returns the number of rows
        
        return 3
        
    }
    
    // Data to be shown on an individual row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = StatusTableViewCell()//optionsTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! StatusTableViewCell
        cell.cellHeight = optionsTableView.frame.size.height/CGFloat(optionsTableView.numberOfRowsInSection(0))
        //CGRect(x: 0.1*self.frame.width, y: 0, width: 0.2*self.frame.width, height: 0.2*self.frame.width)
        //optionImage.center.y = self.center.y
        //setting the information in the rows of the optionTableView
        if indexPath.row == 0 {
            //cell.optionImage.image = cell.optionImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            cell.optionImage.image = UIImage(named: "Business_Icon_Blue")
            cell.optionLabel.text = "Business"
            cell.optionLabel.textColor = businessBlue
            //cell.backgroundColor = UIColor(red: 144.0/255, green: 207.0/255, blue: 214.0/255, alpha: 1.0)
        } else if indexPath.row == 1 {
            cell.optionImage.image = UIImage(named: "Love_Icon_Red.svg")
            cell.optionLabel.text = "Love"
            cell.optionLabel.textColor = loveRed
            //cell.backgroundColor = UIColor(red: 255.0/255, green: 129.0/255, blue: 125.0/255, alpha: 1.0)
        } else {
            cell.optionImage.image = UIImage(named: "Friendship_Icon_Green.svg")
            cell.optionLabel.text = "Friendship"
            cell.optionLabel.textColor = friendshipGreen
            //cell.backgroundColor = UIColor(red: 139.0/255, green: 217.0/255, blue: 176.0/255, alpha: 1.0)
            
        }
        
        return cell
        
    }
    // A row is selected
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 {
            necterType = "Business"
            performSegueWithIdentifier("showNewStatusFromOptionsView", sender: self)
        } else if indexPath.row == 1 {
            necterType = "Love"
            performSegueWithIdentifier("showNewStatusFromOptionsView", sender: self)
        } else {
            necterType = "Friendship"
            performSegueWithIdentifier("showNewStatusFromOptionsView", sender: self)
            
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController
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
