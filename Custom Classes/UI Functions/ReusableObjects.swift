//
//  ReusableObjects.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/28/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit

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
        
        // MARK: - Global Variables
        var arrayOfVCs: [UIViewController]
        let pageControl = UIPageControl()
        let startingIndex: Int
        let withPageControl: Bool
        let circular: Bool
        
        // MARK: -
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
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - Functions
        // Adding view controllers to the PageViewController
        func addVC(vc: UIViewController) {
            arrayOfVCs.append(vc)
            setViewControllers([arrayOfVCs[startingIndex]], direction: .forward, animated: false, completion: nil)
            
            if withPageControl {
                pageControl.numberOfPages = arrayOfVCs.count
                pageControl.currentPage = startingIndex
            }
        }
        
        // Swiping the PageViewController to the right
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
        
        // Swiping the PageViewController to the left
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
        
        // Setting the pageControl to the correct index once the animation to the new index has completed
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if let currentVC = viewControllers?.first {
                if let currentIndex = arrayOfVCs.index(of: currentVC) {
                    pageControl.currentPage = currentIndex
                }
            }
        }
        
    }
    
    class InviteButton: UIButton {
        
        init() {
            super.init(frame: CGRect())
            
            self.setImage(#imageLiteral(resourceName: "Profile_Invite_Button"), for: .normal)
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.4
            self.layer.shadowOffset = .init(width: 1, height: 1)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}
