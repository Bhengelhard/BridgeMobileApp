//
//  ReusableObjects.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/28/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit
import MBProgressHUD

class ReusableObjects {
    
    /// FBLoginButton is UIButton allowing user to log into the necter app using Facebook authentication
    class FBLoginButton: UIButton  {
        
        let size = CGSize(width: 250, height: 42.5)
        
        init() {
            super.init(frame: CGRect())
            
            self.setImage(#imageLiteral(resourceName: "FB_Login_Button"), for: .normal)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class ReputationButton: UIButton {
        
        init() {
            super.init(frame: CGRect())
            
            self.layer.cornerRadius = 10
            self.layer.borderColor = UIColor.black.cgColor
            self.layer.borderWidth = 3
            self.setTitle("15", for: .normal)
            self.titleLabel?.font = Constants.Fonts.bold24
            self.setTitleColor(UIColor.black, for: .normal)
            self.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func tapped(_ sender: UIButton) {
            print("ReputationScore tapped")
        }
    }
    
    
    // PageViewController is a class which initializes with the viewControllers involved in a PageViewController and handles the page transitions between them
    class NecterPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        
        var arrayOfVCs: [UIViewController]
        let pageControl = UIPageControl()
        let startingIndex: Int
        let withPageControl: Bool
        let circular: Bool
        
        
        init(arrayOfVCs: [UIViewController], startingIndex: Int, withPageControl: Bool, circular: Bool) {
            self.arrayOfVCs = arrayOfVCs
            self.startingIndex = startingIndex
            self.withPageControl = withPageControl
            self.circular = circular
            super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            
            delegate = self
            dataSource = self
            
            if arrayOfVCs.count > 0 {
                setViewControllers([arrayOfVCs[startingIndex]], direction: .forward, animated: true, completion: nil)
                
            }
            
            // Add pageControl for pageViewControllers that start at 0, i.e. not the MainPageViewController
            if withPageControl {
                // Setting PageController with the number of pages and tintColors
                pageControl.numberOfPages = arrayOfVCs.count
                pageControl.currentPage = startingIndex
                pageControl.pageIndicatorTintColor = UIColor.lightGray
                pageControl.currentPageIndicatorTintColor = DisplayUtility.gradientColor(size: pageControl.frame.size)
                
                view.addSubview(pageControl)
            }

            
        }
        
        func addVC(vc: UIViewController) {
            arrayOfVCs.append(vc)
            setViewControllers([arrayOfVCs[startingIndex]], direction: .forward, animated: false, completion: nil)
            
            if withPageControl {
                pageControl.numberOfPages = arrayOfVCs.count
                pageControl.currentPage = startingIndex
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            if let currIndex = arrayOfVCs.index(of: viewController) {
                if currIndex + 1 < arrayOfVCs.count {
                    return arrayOfVCs[currIndex + 1]
                }
                // Move to beginning of arrayOfVCs
//                else if circular {
//                    return arrayOfVCs.first
//                }
            }
            
            return nil
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            
            if let currIndex = arrayOfVCs.index(of: viewController) {
                if currIndex - 1 >= 0 {
                    return arrayOfVCs[currIndex - 1]
                }
                // Move to end of arrayOfVCs
//                else if circular {
//                    return arrayOfVCs.last
//                }
            }
            return nil
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if let currentVC = viewControllers?.first {
                if let currentIndex = arrayOfVCs.index(of: currentVC) {
                    pageControl.currentPage = currentIndex
                }
            }
        }
        
    }
    
    class InviteButton: UIButton {
        var vc: UIViewController?
        let messageComposer = MessageComposer()
        
        init() {
            super.init(frame: CGRect())
            
            setImage(#imageLiteral(resourceName: "Profile_Invite_Button"), for: .normal)
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.4
            layer.shadowOffset = .init(width: 1, height: 1)
            
            addTarget(self, action: #selector(inviteButtonTapped(_:)), for: .touchUpInside)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setVC(vc: UIViewController) {
            self.vc = vc
        }
        
        // Presents Message with text prepopulated
        func inviteButtonTapped(_ sender: UIButton) {
            if let vc = vc {
                // Make sure the device can send text messages
                if messageComposer.canSendText() {
                    let hud = MBProgressHUD.showAdded(to: vc.view, animated: true)
                    hud.label.text = "Loading..."
                    
                    // Obtain a configured MFMessageComposeViewController
                    let messageComposeVC = messageComposer.configuredMessageComposeViewController()
                    // Present the configured MFMessageComposeViewController instance
                    // Note that the dismissal of the VC will be handled by the messageComposer instance,
                    // since it implements the appropriate delegate call-back
                    vc.present(messageComposeVC, animated: true, completion: nil)
                    
                    MBProgressHUD.hide(for: vc.view, animated: true)
                } else {
                    // Let the user know if his/her device isn't able to send text messages
                    let errorAlert = UIAlertView(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", delegate: self, cancelButtonTitle: "OK")
                    errorAlert.show()
                }
            }
        }
    }
    
}
