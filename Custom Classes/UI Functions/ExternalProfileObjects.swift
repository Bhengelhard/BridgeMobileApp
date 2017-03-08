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
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.4
            self.layer.shadowOffset = .init(width: 1, height: 1)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
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
    
    class ProfilePicturesPageViewController: ReusableObjects.NecterPageViewController {
        
        init() {
            super.init(arrayOfVCs: [], startingIndex: 0, withPageControl: true, circular: true)
        }
        
        func addImage(image: UIImage) {
            let profilePictureVC = ProfilePictureViewController(image: image)
            arrayOfVCs.append(profilePictureVC)
            pageControl.numberOfPages = arrayOfVCs.count
            super.setViewControllers([arrayOfVCs[0]], direction: .forward, animated: true, completion: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
    }
    
    class ProfilePictureViewController: UIViewController {
        let imageView = UIImageView()
        
        init(color: UIColor) {
            super.init(nibName: nil, bundle: nil)
            
            self.view.backgroundColor = color
        }
        
        init(image: UIImage) {
            super.init(nibName: nil, bundle: nil)
            
            view.addSubview(imageView)
            imageView.autoPinEdgesToSuperviewEdges()
            imageView.image = image
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
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.4
            self.layer.shadowOffset = .init(width: 1, height: 1)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func tapped(_ sender: UIButton) {
            print("tapped")
        }
    }
    
}
