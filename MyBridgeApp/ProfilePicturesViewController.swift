//
//  ProfilePicturesViewController.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 1/17/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class ProfilePicturesViewController: UIPageViewController, UIPageViewControllerDataSource {
    var vcs = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
    }
    
    override init(transitionStyle: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]?) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setVCs(vcs: [UIViewController], initialVC: UIViewController) {
        self.vcs = vcs
        setViewControllers([initialVC], direction: .forward, animated: false, completion: nil)
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


}
