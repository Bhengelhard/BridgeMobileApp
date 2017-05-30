//
//  MainPageViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/28/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class MainPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    
    var arrayOfVCs = [UIViewController]()
    
    var userIsNew = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        dataSource = self
        
        setUpArrayofVCs()
        
        // Listener for updating thread when new messages come in
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadMessageTable), name: NSNotification.Name(rawValue: "reloadTheMessageTable"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpArrayofVCs() {
        let sb = storyboard!
        let myProfileViewController = sb.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
        myProfileViewController.layout.navBar.rightButton.addTarget(self, action: #selector(myProfileRightButtonTapped(_:)), for: .touchUpInside)
        arrayOfVCs.append(myProfileViewController)
        
        let swipeViewController = sb.instantiateViewController(withIdentifier: "SwipeViewController") as! SwipeViewController
        swipeViewController.layout.navBar.leftButton.addTarget(self, action: #selector(swipeLeftButtonTapped(_:)), for: .touchUpInside)
        swipeViewController.layout.navBar.rightButton.addTarget(self, action: #selector(swipeRightButtonTapped(_:)), for: .touchUpInside)
        arrayOfVCs.append(swipeViewController)
        
        let messagesViewController = sb.instantiateViewController(withIdentifier: "MessagesViewController") as! MessagesViewController
        messagesViewController.layout.navBar.leftButton.addTarget(self, action: #selector(messagesLeftButtonTapped(_:)), for: .touchUpInside)
        arrayOfVCs.append(messagesViewController)
        
        self.view.backgroundColor = UIColor.white
        
        setViewControllers([arrayOfVCs[1]], direction: .forward, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if userIsNew {
            let alert = UIAlertController(title: "How to NECT:", message: "Our algorithm pairs two of your friends.\nSwipe right to introduce them.\nSwipe left to see the next pair.", preferredStyle: UIAlertControllerStyle.alert)
            //Create the actions
            alert.addAction(UIAlertAction(title: "Got it", style: .default, handler: { (action) in
            }))
            self.present(alert, animated: true, completion: nil)
            
            userIsNew = false
        }
    }
    
    // MARK: - PageViewController Functions
    
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

    // MARK: - Targets
    
    // Segue from MyProfileViewController to SwipeViewController via the PageViewController
    func myProfileRightButtonTapped(_ sender: UIButton) {
        setViewControllers([arrayOfVCs[1]], direction: .forward, animated: true, completion: nil)
    }
    
    // Segue from SwipeViewController to MessagesViewController via the PageViewController
    func swipeRightButtonTapped(_ sender: UIButton) {
        if let swipeVC = arrayOfVCs[1] as? SwipeViewController {
            swipeVC.layout.navBar.rightButton.setImage(#imageLiteral(resourceName: "Messages_Navbar_Inactive"), for: .normal)
        }
        setViewControllers([arrayOfVCs[2]], direction: .forward, animated: true, completion: nil)
    }
    // Segue from SwipeViewController to MyProfileViewController via the PageViewController
    func swipeLeftButtonTapped(_ sender: UIButton) {
        setViewControllers([arrayOfVCs[0]], direction: .reverse, animated: true, completion: nil)
    }
    
    // Segue from MessagesViewController to SwipeViewController via the PageViewController
    func messagesLeftButtonTapped(_ sender: UIButton) {
        if let swipeVC = arrayOfVCs[1] as? SwipeViewController {
            swipeVC.layout.navBar.rightButton.setImage(#imageLiteral(resourceName: "Messages_Navbar_Inactive"), for: .normal)
        }
        setViewControllers([arrayOfVCs[1]], direction: .reverse, animated: true, completion: nil)
    }
    
    // Reload the messages table upon push notification
    func reloadMessageTable(_ notification: Notification) {
        if let messagesVC = arrayOfVCs[2] as? MessagesViewController {
            messagesVC.messagesBackend.reloadMessagesTable(tableView: messagesVC.layout.messagesTable)
            messagesVC.messagesBackend.loadNewMatches(newMatchesTableViewCell: messagesVC.newMatchesTableViewCell)
        }
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


//class MainPageViewController: ReusableObjects.NecterPageViewController {
//    
//    init() {
//        super.init(arrayOfVCs: [MyProfileViewController(), SwipeViewController()], startingIndex: 0)
//        
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    
//    
//}
