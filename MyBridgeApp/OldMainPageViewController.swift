//
//  MainPageViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/28/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import PureLayout

class MainViewController: UIViewController {
    
    // MARK: Global Variables
    let mainPageViewController = MainPageViewController()
    let transitionManager = TransitionManager()
    
    var didSetupConstraints = false
    
    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.white
        
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        //didSetupConstraints = layout.initialize(view: view, didSetupConstraints: didSetupConstraints)
        
        if !didSetupConstraints {
            view.addSubview(mainPageViewController.view)
            mainPageViewController.view.autoPinEdgesToSuperviewEdges()
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    
    // MARK: - Targets
    
    
    // MARK: - Navigation
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        let vc = segue.destination
    //        let mirror = Mirror(reflecting: vc)
    //        if mirror.subjectType == LoginViewController.self {
    //            self.transitionManager.animationDirection = "Bottom"
    //        }
    //        //vc.transitioningDelegate = self.transitionManager
    //    }
    
    
}

//class MainPageViewController: ReusableObjects.NecterPageViewController {
//
//    let myProfileViewController = New_MyProfileViewController()
//    let swipeViewController = SwipeViewController()
//    let messagesViewController = New_MessagesViewController()
//    
//    init() {
//        super.init(arrayOfVCs: [myProfileViewController, swipeViewController, messagesViewController], startingIndex: 1)
//        
//        setViewControllers([arrayOfVCs[1]], direction: .forward, animated: true, completion: nil)
//
//        
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}


// PageViewController is a class which initializes with the viewControllers involved in a PageViewController and handles the page transitions between them
class OldMainPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    let myProfileViewController = New_MyProfileViewController()
    let swipeViewController = SwipeViewController()
    let messagesViewController = New_MessagesViewController()
    
    var arrayOfVCs: [UIViewController]
    
    init() {
        self.arrayOfVCs = [myProfileViewController, swipeViewController, messagesViewController]
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        delegate = self
        dataSource = self
        
        setViewControllers([arrayOfVCs[1]], direction: .forward, animated: true, completion: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currIndex = arrayOfVCs.index(of: viewController) {
            if currIndex + 1 < arrayOfVCs.count {
                return arrayOfVCs[currIndex + 1]
            }
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let currIndex = arrayOfVCs.index(of: viewController) {
            if currIndex - 1 >= 0 {
                return arrayOfVCs[currIndex - 1]
            }
        }
        return nil
    }
    
}
