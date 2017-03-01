//
//  MainPageViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/28/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class MainPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    
    var arrayOfVCs = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        dataSource = self
        
        if let sb = storyboard {
            let myProfileViewController = sb.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
            myProfileViewController.layout.navBar.rightButton.addTarget(self, action: #selector(myProfileRightButtonTapped(_:)), for: .touchUpInside)
            
            let swipeViewController = sb.instantiateViewController(withIdentifier: "SwipeViewController") as! SwipeViewController
            swipeViewController.layout.navBar.leftButton.addTarget(self, action: #selector(swipeLeftButtonTapped(_:)), for: .touchUpInside)
            swipeViewController.layout.navBar.rightButton.addTarget(self, action: #selector(swipeRightButtonTapped(_:)), for: .touchUpInside)
            
            let messagesViewController = sb.instantiateViewController(withIdentifier: "MessagesViewController") as! MessagesViewController
            messagesViewController.layout.navBar.leftButton.addTarget(self, action: #selector(messagesLeftButtonTapped(_:)), for: .touchUpInside)
            
            arrayOfVCs = [myProfileViewController, swipeViewController, messagesViewController]
        } else {
            arrayOfVCs = [MyProfileViewController(), SwipeViewController(), MessagesViewController()]
        }
        
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

    // Mark: - Targets
    
    // Segue from MyProfileViewController to SwipeViewController via the PageViewController
    func myProfileRightButtonTapped(_ sender: UIButton) {
        setViewControllers([arrayOfVCs[1]], direction: .forward, animated: true, completion: nil)
    }
    
    // Segue from SwipeViewController to MessagesViewController via the PageViewController
    func swipeRightButtonTapped(_ sender: UIButton) {
        setViewControllers([arrayOfVCs[2]], direction: .forward, animated: true, completion: nil)
    }
    // Segue from SwipeViewController to MyProfileViewController via the PageViewController
    func swipeLeftButtonTapped(_ sender: UIButton) {
        setViewControllers([arrayOfVCs[0]], direction: .reverse, animated: true, completion: nil)
    }
    
    // Segue from MyProfileViewController to SwipeViewController via the PageViewController
    func messagesLeftButtonTapped(_ sender: UIButton) {
        setViewControllers([arrayOfVCs[1]], direction: .reverse, animated: true, completion: nil)
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
