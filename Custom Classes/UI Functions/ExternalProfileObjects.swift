//
//  ExternalProfileObjects.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/20/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit

class ExternalProfileObjects {
    
    class DismissButton: UIButton {
        
        init() {
            super.init(frame: CGRect())
            
            self.setImage(#imageLiteral(resourceName: "Down_Arrow"), for: .normal)
            self.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func tapped(_ sender: UIButton) {
            print("tapped")
        }
        
    }
    
    class ReportButton: UIButton {
        
        init() {
            super.init(frame: CGRect())
            
            self.setImage(#imageLiteral(resourceName: "Report_User"), for: .normal)
            self.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func tapped(_ sender: UIButton) {
            print("tapped")
        }
    }
    
    class ProfilePicturesPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        
        var arrayOfVCs = [UIViewController]()
        let pageControl = UIPageControl()
        
        init() {
            super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            
            delegate = self
            dataSource = self
            
            self.view.backgroundColor = UIColor.red
            
            let profPic1 = ProfilePicturesViewController(color: UIColor.blue)
            arrayOfVCs.append(profPic1)
            
            let profPic2 = ProfilePicturesViewController(color: UIColor.red)
            arrayOfVCs.append(profPic2)
            
            let profPic3 = ProfilePicturesViewController(color: UIColor.green)
            arrayOfVCs.append(profPic3)
            
            let profPic4 = ProfilePicturesViewController(color: UIColor.orange)
            arrayOfVCs.append(profPic4)
            
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
    
    class ProfilePicturesViewController: UIViewController {
        
        init(color: UIColor) {
            super.init(nibName: nil, bundle: nil)
            
            self.view.backgroundColor = color
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
    }
    
    class Image: UIImageView {
        
    }
    
    class Name: UILabel {
        
        init() {
            super.init(frame: CGRect())
            
            self.text = "Ethan Skaggs"
            self.font = Constants.Fonts.light24
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    class FactLabel: UILabel {
        
        init() {
            super.init(frame: CGRect())
            
            self.text = "23 years old\nNewOrleans, Louisiana\nUniversity of Pennsylvania"
            self.numberOfLines = 0
            self.font = Constants.Fonts.light18
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    class Line: UIView {
        
        let height:CGFloat = 0.25
        
        init() {
            super.init(frame: CGRect())
            
            self.backgroundColor = UIColor.black
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class AboutMeLabel: UILabel {
        
        init() {
            super.init(frame: CGRect())
            
            self.text = "UX Design / Wine + Spirits\nLooking for some new friends in the local startup world to join me on a new venture!"
            self.numberOfLines = 0
            self.font = Constants.Fonts.light18
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class ReputationScore: ReusableObjects.ReputationButton {
        
        
    }
    
    class MessageButton: UIButton {
        
        let size = CGSize(width: 241, height: 42)
        
        init() {
            super.init(frame: CGRect())
            
            self.setTitle("MESSAGE", for: .normal)
            self.titleLabel?.font = Constants.Fonts.bold24
            self.contentVerticalAlignment = UIControlContentVerticalAlignment.bottom
            self.layer.cornerRadius = 18
            self.backgroundColor = DisplayUtility.gradientColor(size: size)
            self.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func tapped(_ sender: UIButton) {
            print("tapped")
        }
    }
    
}
