//
//  WebPrivacyPolicyViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 3/7/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    // Mark: - Global Variables
    var didSetupConstraints = false
    let webView = UIWebView()
    let navBar = NecterNavigationBar()
    let urlString: String
    let titleString: String
    
    init(title: String, url: String) {
        self.titleString = title
        self.urlString = url
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url: URL = NSURL(string: urlString) as! URL
        let request: URLRequest = NSURLRequest(url: url) as URLRequest
        webView.loadRequest(request)

        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Override Functions
  
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.white
        
        // Setting Necter Navbar
        navBar.rightButton.setTitle("Done", for: .normal)
        navBar.rightButton.sizeToFit()
        let gradientColor = DisplayUtility.gradientColor(size: navBar.rightButton.frame.size)
        navBar.rightButton.setTitleColor(gradientColor, for: .normal)
        navBar.navItem.title = titleString
        navBar.rightButton.addTarget(self, action: #selector(doneTapped(_:)), for: .touchUpInside)
        
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            
            
            // Layout the navigation bar at the top of the view with a done button for dismissing the EditProfileViewController
            view.addSubview(navBar)
            navBar.autoPinEdge(toSuperviewEdge: .top)
            navBar.autoPinEdge(toSuperviewEdge: .left)
            navBar.autoMatch(.width, to: .width, of: view)
            navBar.autoSetDimension(.height, toSize: 64)
            
            // Layout the Table below the navigation bar
            view.addSubview(webView)
            webView.autoPinEdge(.top, to: .bottom, of: navBar)
            webView.autoPinEdge(toSuperviewEdge: .left)
            webView.autoPinEdge(toSuperviewEdge: .right)
            webView.autoPinEdge(toSuperviewEdge: .bottom)
        
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    // MARK: - Targets
    /// Segues to Login
    func doneTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
