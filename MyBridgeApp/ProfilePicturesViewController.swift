//
//  ProfilePicturesViewController.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 1/17/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class ProfilePicturesViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, ProfilePicturesViewControllerDelegate {
    var vcs: [UIViewController]
    let pageControl = UIPageControl()
    var profilePicturesDelegate: ProfilePicturesViewControllerDelegate?

    init(vcs: [UIViewController], initialVC: UIViewController) {
        self.vcs = vcs
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        setViewControllers([initialVC], direction: .forward, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        
        profilePicturesDelegate = self
        
        //formatting pageControl
        pageControl.frame = CGRect(x: 0, y: 0.02*view.frame.height, width: 0, height: 0.03*view.frame.height)
        //pageControl.center.x = DisplayUtility.screenWidth / 2
        profilePicturesDelegate?.profilePicturesViewController(self, didUpdatePageCount: vcs.count)
        if let firstVC = viewControllers?.first,
            let currIndex = vcs.index(of: firstVC) {
            profilePicturesDelegate?.profilePicturesViewController(self, didUpdatePageIndex: currIndex)
        }
        
        pageControl.pageIndicatorTintColor = .clear
        pageControl.currentPageIndicatorTintColor = .lightGray
        view.addSubview(pageControl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var minDotX: CGFloat?
        var maxDotX: CGFloat?
        for i in 0..<pageControl.subviews.count {
            let dot = pageControl.subviews[i]
            dot.layer.borderWidth = 1
            dot.layer.borderColor = UIColor.lightGray.cgColor
            
            if minDotX == nil {
                minDotX = dot.frame.minX
            } else {
                minDotX = min(minDotX!, dot.frame.minX)
            }
            
            if maxDotX == nil {
                maxDotX = dot.frame.maxX
            } else {
                maxDotX = max(maxDotX!, dot.frame.maxX)
            }
        }
        
        if let maxDotX = maxDotX,
            let minDotX = minDotX {
            let pageControlWidth = maxDotX - minDotX + 0.05*view.frame.width
            pageControl.frame = CGRect(x: 0.95*view.frame.width - pageControlWidth, y: pageControl.frame.minY, width: pageControlWidth, height: pageControl.frame.height)
            pageControl.layer.cornerRadius = 0.4*pageControl.frame.height
            pageControl.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        }
    }
    
    /*
    override init(transitionStyle: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]?) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    }*/
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    func setVCs(vcs: [UIViewController], initialVC: UIViewController) {
        self.vcs = vcs
        setViewControllers([initialVC], direction: .forward, animated: false, completion: nil)
    }
    */
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currIndex = vcs.index(of: viewController) {
            if currIndex - 1 >= 0 {
                return vcs[currIndex - 1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currIndex = vcs.index(of: viewController) {
            if currIndex + 1 < vcs.count {
                return vcs[currIndex + 1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if let firstVC = viewControllers?.first,
            let currIndex = vcs.index(of: firstVC) {
            profilePicturesDelegate?.profilePicturesViewController(self, didUpdatePageIndex: currIndex)
        }
    }
    
    func profilePicturesViewController(_ profilePicturesViewController: ProfilePicturesViewController, didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func profilePicturesViewController(_ profilePicturesViewController: ProfilePicturesViewController, didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
    

}

protocol ProfilePicturesViewControllerDelegate {
    func profilePicturesViewController(_ profilePicturesViewController: ProfilePicturesViewController, didUpdatePageCount count: Int)
    
    func profilePicturesViewController(_ profilePicturesViewController: ProfilePicturesViewController, didUpdatePageIndex index: Int)
}
