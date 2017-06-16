//
//  SwipeObjects.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/17/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import CountdownLabel

class SwipeObjects {
    
    class NavBar: NecterNavigationBar {
        
        override init() {
            super.init()
            
            // Setting Navigation Items
            let rightIcon = #imageLiteral(resourceName: "Messages_Navbar_Inactive")
            rightButton.setImage(rightIcon, for: .normal)
            
            let leftIcon = #imageLiteral(resourceName: "Profile_Navbar_Inactive")
            leftButton.setImage(leftIcon, for: .normal)
            
            let titleImage = #imageLiteral(resourceName: "Necter_Navbar_Active")
            //titleImageView.image = titleImage
            setTitleImage(image: titleImage)
            //navItem.titleView = titleImageView
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class DecisionButton: UIButton {
        
        let size = CGSize(width: 160, height: 40)
        
        init(text: String) {
            super.init(frame: CGRect())
            self.setTitle(text, for: .normal)
            self.setTitleColor(UIColor.white, for: .normal)
            self.titleLabel?.font = Constants.Fonts.bold24
            self.contentVerticalAlignment = UIControlContentVerticalAlignment.bottom
            
            if text == "NECT" {
                self.backgroundColor = Constants.Colors.necter.orange
            } else {
                self.backgroundColor = Constants.Colors.necter.buttonGray
            }
            
            // Effect when highlighted
            self.showsTouchWhenHighlighted = true
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class InfoButton: UIButton {
        
        init() {
            super.init(frame: CGRect())
            
            self.setImage(#imageLiteral(resourceName: "Information_Icon"), for: .normal)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class BigLabel: UILabel {
        init(text: String) {
            super.init(frame: CGRect())
            
            self.text = text
            textColor = Constants.Colors.necter.textGray
            textAlignment = .center
            font = Constants.Fonts.bold48
            numberOfLines = 0
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class SmallLabel: UILabel {
        init(text: String) {
            super.init(frame: CGRect())
            
            self.text = text
            textColor = Constants.Colors.necter.textGray
            textAlignment = .center
            font = Constants.Fonts.light24
            numberOfLines = 0
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    }
    
    class SwipeCountdownLabelView: UIView, CountdownLabelDelegate {
        var countdownLabel: CountdownLabel
        
        var countdownFinishedCompletion: (() -> Void)?
        
        init() {
            countdownLabel = CountdownLabel(frame: CGRect())
            
            super.init(frame: CGRect())
            
            let currentDate = Date()
            let targetDate = getTargetDate(currentDate: currentDate)
            countdownLabel = CountdownLabel(frame: CGRect(), fromDate: currentDate as NSDate, targetDate: targetDate as NSDate)
            print(currentDate)
            print(targetDate)
            //countdownLabel = CountdownLabel(frame: CGRect(), minutes: 20)
            print(countdownLabel.text!)

            countdownLabel.countdownDelegate = self
            
            countdownLabel.textColor = Constants.Colors.necter.textGray
            countdownLabel.textAlignment = .center
            countdownLabel.font = Constants.Fonts.bold48
            
            addSubview(countdownLabel)
            countdownLabel.sizeToFit()
            countdownLabel.autoPinEdgesToSuperviewEdges()
            
        }
        
        func resetCountdownTime() {
            
            print("resetCountdownTime")
            let currentDate = Date()
            let targetDate = getTargetDate(currentDate: currentDate)
            
            countdownLabel.setCountDownDate(fromDate: currentDate as NSDate, targetDate: targetDate as NSDate)
            //countdownLabel.setCountDownTime(minutes: 20)
            countdownLabel.start()
        }
        
        func getTargetDate (currentDate: Date) -> Date {
            // initializing the user's calendar
            let calendar = Calendar(identifier: .gregorian)
            
            // Determining 5pm est in the user's current timezone set to GMT for swift Date protocol
            let secondsFromGMT: Int = TimeZone.current.secondsFromGMT()
            let minutesFromGMT = secondsFromGMT/60
            let hoursFromGMT = minutesFromGMT/60
            let hoursFromEST = hoursFromGMT + 4
            var hourValue = 17+hoursFromEST
            
            // Setting hourValue if adjusted hour value is greater than or equal to 24
            if hourValue >= 24 {
                hourValue = hourValue-24
            }
            
            // Setting date componenets for the targetDate with the determined hourValue
            var dateComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
            dateComponents.hour = hourValue
            dateComponents.minute = 0
            dateComponents.second = 0
            
            // Moving target to next day if the targetDate has already passed for the currentDay
            if calendar.component(.hour, from: currentDate) >= hourValue {
                let dayFromCurrentDate = calendar.component(.day, from: currentDate)
                dateComponents.day = dayFromCurrentDate + 1
            }
            
            // Setting and returning the target Date
            // FIXME: Force unwrap used instead of error message sent to user
            return calendar.date(from: dateComponents)!
            
        }
        
        func startCountdown() {
            countdownLabel.start()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func countingAt(timeCounted: TimeInterval, timeRemaining: TimeInterval) {
            if timeRemaining == 0 {
                if let countdownFinishedCompletion = countdownFinishedCompletion {
                    print("countdownFinishedCompletion")
                    countdownFinishedCompletion()
                }
                resetCountdownTime()
            }
        }
    }
    
    /*
    var attrs = [
        NSFontAttributeName : UIFont.systemFontOfSize(19.0),
        NSForegroundColorAttributeName : UIColor.redColor(),
        NSUnderlineStyleAttributeName : 1]
    
    var attributedString = NSMutableAttributedString(string:"")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttonTitleStr = NSMutableAttributedString(string:"My Button", attributes:attrs)
        attributedString.appendAttributedString(buttonTitleStr)
        yourButton.setAttributedTitle(attributedString, forState: .Normal)
    }
    
    class RefreshButton: UIButton {
        init() {
            super.init(frame: CGRect())
            
            let attributes: [String: Any] = [
                NSFontAttributeName: Constants.Fonts.light18 ?? UIFont(),
                NSForegroundColorAttributeName: Constants.Colors.necter.yellow,
                NSUnderlineStyleAttributeName: 1]
            let attributedString = NSAttributedString(string: "check for more pairs", attributes: attributes)
            
            setAttributedTitle(attributedString, for: .normal)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }*/
    
    class LoadingBridgePairingsView: UIView {
        let activityIndicatorView: NVActivityIndicatorView
        
        init() {
            activityIndicatorView = NVActivityIndicatorView(frame: CGRect(), type: .ballZigZag, color: Constants.Colors.necter.yellow, padding: 0)
            super.init(frame: CGRect(x: 0, y: 0, width: 37, height: 37))
            activityIndicatorView.frame = self.frame
            addSubview(activityIndicatorView)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override var intrinsicContentSize: CGSize {
            return CGSize(width: 37, height: 37)
        }
        
        func startAnimating() {
            activityIndicatorView.startAnimating()
        }
        
        func stopAnimating() {
            activityIndicatorView.stopAnimating()
        }
    }
    
}
