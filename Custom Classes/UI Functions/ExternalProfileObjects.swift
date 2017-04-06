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
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
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
            
            font = Constants.Fonts.light24
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    class NameAndAgeLabel: UILabel {
        init() {
            super.init(frame: CGRect())
            
            font = Constants.Fonts.light24
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class FactsTable: UITableView, UITableViewDelegate, UITableViewDataSource {
        let fieldsOrder: [UserInfoField] = [.city, .work, .school, .gender, .relationshipStatus]
        var fieldsToCells = [UserInfoField: FactCell]()
        
        override init(frame: CGRect, style: UITableViewStyle) {
            super.init(frame: CGRect(), style: .plain)
            
            delegate = self
            dataSource = self
            
            self.separatorStyle = .none
            
            self.estimatedRowHeight = 50
            //self.rowHeight = UITableViewAutomaticDimension
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - Table view data source
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print("number of rows = \(fieldsToCells.count)")
            return fieldsToCells.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            print("cell for row at: \(indexPath.row)")
            var i = 0
            for field in fieldsOrder {
                if let cell = fieldsToCells[field] {
                    if i == indexPath.row {
                        return cell
                    }
                    i += 1
                }
            }
            return FactCell()
        }
        
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            print("height for row at: \(indexPath.row) = 50")
            return 50
        }
        
        func addFactCell(forField field: UserInfoField, withIcon icon: UIImage, withFactText factText: String) {
            fieldsToCells[field] = FactCell(icon: icon, factText: factText)
            reloadData()
        }
        
    }
    
    class FactCell: UITableViewCell {
        
        init() {
            super.init(style: .default, reuseIdentifier: "FactCell")
        }
        
        init(icon: UIImage, factText: String) {
            super.init(style: .default, reuseIdentifier: "FactCell")
            imageView?.image = icon
            textLabel?.text = factText
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class FactsView: UIView {
        var cityView: FactView?
        var workView: FactView?
        var schoolView: FactView?
        var genderView: FactView?
        var relationshipStatusView: FactView?
        
        class FactView: UIView {
            let iconImageView = UIImageView()
            let factLabel = UILabel()
            let sizeReferenceLabel = UILabel()
            
            init(icon: UIImage, factText: String) {
                super.init(frame: CGRect())
                
                factLabel.font = Constants.Fonts.light18
                factLabel.numberOfLines = 0
                
                // used only for calculating height of single line
                sizeReferenceLabel.font = factLabel.font
                sizeReferenceLabel.numberOfLines = 1
                sizeReferenceLabel.text = "A"
                sizeReferenceLabel.sizeToFit()
                
                iconImageView.image = icon
                addSubview(iconImageView)
                
                factLabel.text = factText
                //factLabel.sizeToFit()
                addSubview(factLabel)
            }
            
            required init?(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
        }
        
        func activeFactViews() -> [FactView] {
            var activeFactViews = [FactView]()
            for factView in [cityView, workView, schoolView, genderView, relationshipStatusView] {
                if let factView = factView {
                    activeFactViews.append(factView)
                }
            }
            return activeFactViews
        }

    }
    
    class FactLabel: UILabel {
        
        init() {
            super.init(frame: CGRect())
            
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
    
    /// More Button for adding, blocking, and reporting
    class MoreButton: UIButton {
        
        init() {
            super.init(frame: CGRect())
            
            let rightIcon = #imageLiteral(resourceName: "More_Button")
            self.setImage(rightIcon, for: .normal)
            self.frame.size = CGSize(width: 50, height: 14)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func tapped(_ sender: UIButton) {
            
        }
        
    }
    
}
