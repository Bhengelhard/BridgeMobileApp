//
//  ReusableObjects.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/28/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit

class ReusableObjects {
    
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
        
        init(arrayOfVCs: [UIViewController]) {
            self.arrayOfVCs = arrayOfVCs
            super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            
            delegate = self
            dataSource = self
            
            self.view.backgroundColor = UIColor.red
            
            setViewControllers([arrayOfVCs[0]], direction: .forward, animated: true, completion: nil)
            
            // Setting PageController with the number of pages and tintColors
            pageControl.numberOfPages = arrayOfVCs.count
            pageControl.currentPage = 0
            pageControl.pageIndicatorTintColor = UIColor.lightGray
            pageControl.currentPageIndicatorTintColor = UIColor.black
            
            view.addSubview(pageControl)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            if let currIndex = arrayOfVCs.index(of: viewController) {
                if currIndex + 1 < arrayOfVCs.count {
                    return arrayOfVCs[currIndex + 1]
                }
                else {
                    return arrayOfVCs.first
                }
            }
            
            return nil
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            
            if let currIndex = arrayOfVCs.index(of: viewController) {
                if currIndex - 1 >= 0 {
                    return arrayOfVCs[currIndex - 1]
                }
                else {
                    return arrayOfVCs.last
                }
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
    
}
