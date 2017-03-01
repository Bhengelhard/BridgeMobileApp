//
//  MainPageViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/28/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class MainPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource{

//    let myProfileViewController = New_MyProfileViewController()
//    let swipeViewController = SwipeViewController()
//    let messagesViewController = New_MessagesViewController()
    
    var arrayOfVCs = [New_MyProfileViewController(), SwipeViewController(), New_MessagesViewController()]
    
//    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
//        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//        
//        
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        dataSource = self
        
        //self.arrayOfVCs = [myProfileViewController, swipeViewController, messagesViewController]
        self.view.backgroundColor = UIColor.white
        
        setViewControllers([arrayOfVCs[1]], direction: .forward, animated: true, completion: nil)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
