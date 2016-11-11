//
//  CustomSearchBar.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 11/2/16.
//  Copyright © 2016 BHE Ventures LLC. All rights reserved.
//
//  This class is for creating and updating the search bar
//

import UIKit

class CustomSearchBar: UISearchBar {
    
    class func customizeSearchController(searchController: UISearchController) {
        
        //Modify Search Controller
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        
        //Modify Search Bar
        let searchBar = searchController.searchBar
        searchBar.frame = CGRect(x: 0, y: 0.11*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: 0.07*DisplayUtility.screenHeight)
        searchBar.showsCancelButton = false
        searchBar.barTintColor = UIColor.black
        let maskPath = UIBezierPath(roundedRect: searchController.searchBar.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 10.0, height: 10.0))
        let searchBarShape = CAShapeLayer()
        searchBarShape.path = maskPath.cgPath
        searchBar.layer.mask = searchBarShape
        searchBar.sizeToFit()
        
        //Modify Text Field
        let textFieldIdx = indexOfSearchFieldInSubviews(searchBarView: searchBar.subviews[0])
        let textField = searchBar.subviews[0].subviews[textFieldIdx] as! UITextField
        textField.backgroundColor = UIColor.clear
        textField.font = UIFont(name: "HelveticaNeue-Thin", size: 20)
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(string: "search", attributes: [NSForegroundColorAttributeName: UIColor.white])
        textField.autocapitalizationType = .none
        textField.leftViewMode = .never // remove magnifying glass
    }
    
    class func indexOfSearchFieldInSubviews(searchBarView: UIView) -> Int {
        for i in 0 ..< searchBarView.subviews.count {
            if (searchBarView.subviews[i] as? UITextField) != nil {
                return i
            }
        }
        
        return -1
    }
}
