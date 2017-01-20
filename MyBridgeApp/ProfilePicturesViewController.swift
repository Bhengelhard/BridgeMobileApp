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
        profilePicturesDelegate = self
        profilePicturesDelegate?.profilePicturesViewController(self, didUpdatePageCount: vcs.count)
        setViewControllers([initialVC], direction: .forward, animated: false, completion: nil)
        
        //formatting pageControl
        pageControl.frame = CGRect(x: 0, y: 0, width: 0, height: 0.03*view.frame.height)
        pageControl.center.x = DisplayUtility.screenWidth / 2

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        
        /*
        if let firstVC = viewControllers?.first,
            let currIndex = vcs.index(of: firstVC) {
            profilePicturesDelegate?.profilePicturesViewController(self, didUpdatePageIndex: currIndex)
        }
        */
        
        pageControl.pageIndicatorTintColor = .clear
        pageControl.currentPageIndicatorTintColor = .lightGray
        view.addSubview(pageControl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        for i in 0..<pageControl.subviews.count {
            let dot = pageControl.subviews[i]
            dot.layer.borderWidth = 1
            dot.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setViewControllers(_ viewControllers: [UIViewController]?, direction: UIPageViewControllerNavigationDirection, animated: Bool, completion: ((Bool) -> Void)? = nil) {
        super.setViewControllers(viewControllers, direction: direction, animated: animated, completion: completion)
        if let vc = viewControllers?.first {
            if let index = vcs.index(of: vc) {
                profilePicturesDelegate?.profilePicturesViewController(self, didUpdatePageIndex: index)
            }
        }
    }
    
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
    
    func goToPage(index: Int) {
        print("going to page \(index)")
        if index < vcs.count {
            setViewControllers([vcs[index]], direction: .forward, animated: false, completion: nil)
        }
    }
    
    func profilePicturesViewController(_ profilePicturesViewController: ProfilePicturesViewController, didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
        for i in 0..<pageControl.subviews.count {
            let dot = pageControl.subviews[i]
            dot.layer.borderWidth = 1
            dot.layer.borderColor = UIColor.lightGray.cgColor
        }
        if count == 0 {
            pageControl.alpha = 0
        } else {
            pageControl.alpha = 1
        }
    }
    
    func profilePicturesViewController(_ profilePicturesViewController: ProfilePicturesViewController, didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
    

}

protocol ProfilePicturesViewControllerDelegate {
    func profilePicturesViewController(_ profilePicturesViewController: ProfilePicturesViewController, didUpdatePageCount count: Int)
    
    func profilePicturesViewController(_ profilePicturesViewController: ProfilePicturesViewController, didUpdatePageIndex index: Int)
}
