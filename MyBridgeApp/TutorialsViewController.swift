//
//  TutorialsViewController.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 12/14/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class TutorialsViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, TutorialsViewControllerDelegate {

    let pageControl = UIPageControl()
    var vcs = [UIViewController]()
    var tutorialsDelegate: TutorialsViewControllerDelegate?
    
//    init() {
//        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        tutorialsDelegate = self
                
        let (postTitleLabel, postExplLabel) = SingleTutorialViewController.postLabels()
        let postVC = SingleTutorialViewController(titleLabel: postTitleLabel, explanationLabel: postExplLabel, videoFilename: "PostGray", videoExtension: "mp4")
        vcs.append(postVC)
        let (nectTitleLabel, nectExplLabel) = SingleTutorialViewController.nectLabels()
        let nectVC = SingleTutorialViewController(titleLabel: nectTitleLabel, explanationLabel: nectExplLabel, videoFilename: "ConnectGray", videoExtension: "mp4")
        vcs.append(nectVC)
        let (chatTitleLabel, chatExplLabel) = SingleTutorialViewController.chatLabels()
        let chatVC = SingleTutorialViewController(titleLabel: chatTitleLabel, explanationLabel: chatExplLabel, videoFilename: "AcceptChat", videoExtension: "mp4")
        vcs.append(chatVC)
        setViewControllers([vcs[0]], direction: .forward, animated: true, completion: nil)
        
        pageControl.frame = CGRect(x: 0, y: 0.04138*DisplayUtility.screenHeight, width: 0, height: 0.00976*DisplayUtility.screenHeight)
        pageControl.center.x = DisplayUtility.screenWidth / 2
        pageControl.numberOfPages = vcs.count
        tutorialsDelegate?.tutorialsViewController(self, didUpdatePageCount: vcs.count)
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
            dot.center.x =  2 * dot.center.x / 3
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tutorialsViewController = segue.destination as? TutorialsViewController {
            tutorialsViewController.tutorialsDelegate = self
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
            tutorialsDelegate?.tutorialsViewController(self, didUpdatePageIndex: currIndex)
        }
    }
    
    func tutorialsViewController(_ tutorialsViewController: TutorialsViewController, didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func tutorialsViewController(_ tutorialsViewController: TutorialsViewController, didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
    
    /*
    // These two functions will cause the built-in UIPageControl to show up
     
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return vcs.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let firstVC = viewControllers?.first,
            let currIndex = vcs.index(of: firstVC) {
            return currIndex
        }
        return 0
    }
    */

}

protocol TutorialsViewControllerDelegate {
    func tutorialsViewController(_ tutorialsViewController: TutorialsViewController, didUpdatePageCount count: Int)
    
    func tutorialsViewController(_ tutorialsViewController: TutorialsViewController, didUpdatePageIndex index: Int)
}
