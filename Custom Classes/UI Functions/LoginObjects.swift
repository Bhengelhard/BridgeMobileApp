//
//  LoginVCLayout.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/15/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

///  The LoginObjects class defines a class nested with object classes of the objects displayed in LoginViewController
class LoginObjects {
    
    // MARK: - Object Classes
    /// TutorialsView is a UIView that displays a swipable set of tutorial pages
    class TutorialsView: UIView {
        
        init() {
            super.init(frame: CGRect())
            
            self.backgroundColor = UIColor.red
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    /// FBLoginButton is UIButton allowing user to log into the necter app using Facebook authentication
    class FBLoginButton: UIButton  {
        
        init() {
            super.init(frame: CGRect())
            
            self.setTitle("LOGIN WITH FACEBOOK", for: .normal)
            self.setTitleColor(UIColor.white, for: .normal)
            self.setTitleColor(DisplayUtility.gradientColor(size: (self.titleLabel?.frame.size)!), for: .highlighted)
            self.titleLabel?.font = UIFont(name: "BentonSans-Light", size: 16)
            self.backgroundColor = UIColor(red: 66.0/255.0, green: 103.0/255.0, blue: 178.0/255.0, alpha: 1)
            self.layer.cornerRadius = 8            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    /// Displays label letting user know about privacy information and the necter terms of service
    class LoginInformationLabel : UILabel {
        
        init() {
            super.init(frame: CGRect())
            self.text = "No need to get sour! We don't post to Facebook.\nBy signing in, you agree to our Terms of Service"
            self.numberOfLines = 2
            self.textAlignment = NSTextAlignment.center
            self.font = Constants.Fonts.light14
            //UIFont(name: Constants.Fonts.bentonSansLight, size: 12)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    /// SeeMoreButton is a UIButton that segues to more detailed privacy information in the PrivacyPolicyViewController
    class SeeMoreButton: UIButton  {
        
        init() {
            super.init(frame: CGRect())
            self.setImage(#imageLiteral(resourceName: "Black_X"), for: .normal)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }

}





///// Displays four tutorial pages as a page view controller
//class TutorialsViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, TutorialsViewControllerDelegate {
//
//    let pageControl = UIPageControl()
//    var vcs = [UIViewController]()
//    var tutorialsDelegate: TutorialsViewControllerDelegate?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        delegate = self
//        dataSource = self
//        tutorialsDelegate = self
//
//        //let (postTitleLabel, postExplLabel) = SingleTutorialViewController.postLabels()
//        let postVC = SingleTutorialViewController()
//        vcs.append(postVC)
//        //            let (nectTitleLabel, nectExplLabel) = SingleTutorialViewController.nectLabels()
//        let nectVC = SingleTutorialViewController()
//        vcs.append(nectVC)
//        //            let (chatTitleLabel, chatExplLabel, chatButton) = SingleTutorialViewController.chatLabels()
//        let chatVC = SingleTutorialViewController()
//        vcs.append(chatVC)
//        //            chatButton.addTarget(self, action: #selector(endTutorialButtonTapped(_:)), for: .touchUpInside)
//        setViewControllers([vcs[0]], direction: .forward, animated: true, completion: nil)
//
//        pageControl.frame = CGRect(x: 0, y: 0.04138*DisplayUtility.screenHeight, width: 0, height: 0.00976*DisplayUtility.screenHeight)
//        pageControl.center.x = DisplayUtility.screenWidth / 2
//        pageControl.numberOfPages = vcs.count
//        tutorialsDelegate?.tutorialsViewController(self, didUpdatePageCount: vcs.count)
//        pageControl.pageIndicatorTintColor = .clear
//        pageControl.currentPageIndicatorTintColor = .lightGray
//
//        view.addSubview(pageControl)
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        for i in 0..<pageControl.subviews.count {
//            let dot = pageControl.subviews[i]
//            dot.layer.borderWidth = 1
//            dot.layer.borderColor = UIColor.lightGray.cgColor
//            dot.center.x =  2 * dot.center.x / 3
//            print(dot.frame)
//        }
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let tutorialsViewController = segue.destination as? TutorialsViewController {
//            tutorialsViewController.tutorialsDelegate = self
//        }
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        if let currIndex = vcs.index(of: viewController) {
//            if currIndex - 1 >= 0 {
//                return vcs[currIndex - 1]
//            }
//        }
//        return nil
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        if let currIndex = vcs.index(of: viewController) {
//            if currIndex + 1 < vcs.count {
//                return vcs[currIndex + 1]
//            }
//        }
//        return nil
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController,
//                            didFinishAnimating finished: Bool,
//                            previousViewControllers: [UIViewController],
//                            transitionCompleted completed: Bool) {
//        if let firstVC = viewControllers?.first,
//            let currIndex = vcs.index(of: firstVC) {
//            tutorialsDelegate?.tutorialsViewController(self, didUpdatePageIndex: currIndex)
//        }
//    }
//
//    func tutorialsViewController(_ tutorialsViewController: TutorialsViewController, didUpdatePageCount count: Int) {
//        pageControl.numberOfPages = count
//    }
//
//    func tutorialsViewController(_ tutorialsViewController: TutorialsViewController, didUpdatePageIndex index: Int) {
//        pageControl.currentPage = index
//    }
//
//
//    // MARK: Tutorial Objects
//
//    class SingleTutorialViewController: UIViewController {
//
//        let boundary = UIImageView()
//
//        init() {
//            super.init(nibName: nil, bundle: nil)
//        }
//
//        required init?(coder aDecoder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//
//        override func viewDidLoad() {
//            super.viewDidLoad()
//
//            //let boundary = UIImageView()
//            boundary.backgroundColor = UIColor.red
//            boundary.frame = CGRect(x: 0, y: 0.18823*DisplayUtility.screenHeight, width: 0.7139*DisplayUtility.screenWidth, height: 0.77616*DisplayUtility.screenHeight)
//            boundary.center.x = DisplayUtility.screenWidth / 2
//            view.addSubview(boundary)
//
//        }
//
//        override func viewDidAppear(_ animated: Bool) {
//            super.viewDidAppear(animated)
//
//        }
//
//        static func postLabels() -> (UILabel, UILabel) {
//            let titleLabel = UILabel()
//            titleLabel.frame = CGRect(x: 0.10512*DisplayUtility.screenWidth, y: 0.09382*DisplayUtility.screenHeight, width: 0.0, height: 0.0)
//            titleLabel.text = "post."
//            titleLabel.font = UIFont(name: "BentonSans-Light", size: 26)
//            titleLabel.textColor = .black
//            titleLabel.sizeToFit()
//
//            let explanationLabel = UILabel()
//            explanationLabel.frame = CGRect(x: 0.33255*DisplayUtility.screenWidth, y: 0.08219*DisplayUtility.screenHeight, width: 0.57*DisplayUtility.screenWidth, height: 0.05606*DisplayUtility.screenHeight)
//            explanationLabel.center.y = titleLabel.center.y
//            explanationLabel.numberOfLines = 2
//            explanationLabel.text = "Post a request for your\nfriends to better 'nect you."
//            explanationLabel.font = UIFont(name: "BentonSans-Light", size: 18)
//            explanationLabel.textAlignment = .center
//            explanationLabel.textColor = .black
//            explanationLabel.adjustsFontSizeToFitWidth = true
//
//            return (titleLabel, explanationLabel)
//        }
//
//        static func nectLabels() -> (UILabel, UILabel) {
//            let titleLabel = UILabel()
//            titleLabel.frame = CGRect(x: 0.08281*DisplayUtility.screenWidth, y: 0.09382*DisplayUtility.screenHeight, width: 0.0, height: 0.0)
//            titleLabel.text = "'nect."
//            titleLabel.font = UIFont(name: "BentonSans-Light", size: 26)
//            titleLabel.textColor = .black
//            titleLabel.sizeToFit()
//
//            let explanationLabel = UILabel()
//            explanationLabel.frame = CGRect(x: 0.35397*DisplayUtility.screenWidth, y: 0.08219*DisplayUtility.screenHeight, width: 0.53*DisplayUtility.screenWidth, height: 0.05606*DisplayUtility.screenHeight)
//            explanationLabel.center.y = titleLabel.center.y
//            explanationLabel.numberOfLines = 2
//            explanationLabel.text = "Swipe right to introduce.\nSwipe left to see more."
//            explanationLabel.font = UIFont(name: "BentonSans-Light", size: 18)
//            explanationLabel.textAlignment = .center
//            explanationLabel.textColor = .black
//            explanationLabel.adjustsFontSizeToFitWidth = true
//
//            return (titleLabel, explanationLabel)
//        }
//
//        static func chatLabels() -> (UILabel, UILabel, UIButton) {
//            let titleLabel = UILabel()
//            titleLabel.frame = CGRect(x: 0.10512*DisplayUtility.screenWidth, y: 0.09382*DisplayUtility.screenHeight, width: 0.0, height: 0.0)
//            titleLabel.text = "chat."
//            titleLabel.font = UIFont(name: "BentonSans-Light", size: 26)
//            titleLabel.textColor = .black
//            titleLabel.sizeToFit()
//
//            let explanationLabel = UILabel()
//            explanationLabel.frame = CGRect(x: 0.32928*DisplayUtility.screenWidth, y: 0.08219*DisplayUtility.screenHeight, width: 0.58*DisplayUtility.screenWidth, height: 0.05606*DisplayUtility.screenHeight)
//            explanationLabel.center.y = titleLabel.center.y
//            explanationLabel.numberOfLines = 2
//            explanationLabel.text = "Get to know the poeple\nyou've been introduced to."
//            explanationLabel.font = UIFont(name: "BentonSans-Light", size: 18)
//            explanationLabel.textAlignment = .center
//            explanationLabel.textColor = .black
//            explanationLabel.adjustsFontSizeToFitWidth = true
//
//            let endTutorialButtonFrame = CGRect(x: 0.65*DisplayUtility.screenWidth, y: 0.0325*DisplayUtility.screenHeight, width: 0.3*DisplayUtility.screenWidth, height: 0.04093*DisplayUtility.screenHeight)
//            let endTutorialButton = DisplayUtility.gradientButton(frame: endTutorialButtonFrame, text: "BEGIN 'NECTING", textColor: UIColor.black, fontSize: 11)
//            endTutorialButton.layer.cornerRadius = 8
//            endTutorialButton.layer.borderColor = DisplayUtility.gradientColor(size: endTutorialButton.frame.size).cgColor
//            return (titleLabel, explanationLabel, endTutorialButton)
//        }
//
//
//        //This button is for the user to click on the completion of the tutorial
//        static func tutorialComplete() -> (UIButton) {
//            var tutorialCompletedButton = UIButton()
//            let tutorialCompletedButtonFrame = CGRect(x: 0.4*DisplayUtility.screenWidth, y: 0.05, width: 0.54125*DisplayUtility.screenWidth, height: 0.04093*DisplayUtility.screenHeight)
//            tutorialCompletedButton = DisplayUtility.gradientButton(frame: tutorialCompletedButtonFrame, text: "I'M READY", textColor: UIColor.black, fontSize: 12)
//            tutorialCompletedButton.layer.cornerRadius = 8
//
//            return tutorialCompletedButton
//        }
//
//    }
//
//    /// Displays the title of the tutorial view
//    class TitleLabel : UILabel {
//
//    }
//
//    /// Displays the image in the tutorial view
//    class AppImageView : UIImageView {
//
//    }
//
//    /// Displays the page control circles
//    class PageControl : UIPageControl {
//
//    }
//}
//protocol TutorialsViewControllerDelegate {
//    func tutorialsViewController(_ tutorialsViewController: LoginUI.TutorialsViewController, didUpdatePageCount count: Int)
//
//    func tutorialsViewController(_ tutorialsViewController: LoginUI.TutorialsViewController, didUpdatePageIndex index: Int)
//}
