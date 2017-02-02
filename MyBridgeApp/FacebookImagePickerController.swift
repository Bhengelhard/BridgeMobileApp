//
//  FacebookImagePickercController.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 2/1/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class FacebookImagePickerController: UINavigationController {
    
    weak var imageDelegate: FacebookImagePickerControllerDelegate?
    
    override weak var delegate: UINavigationControllerDelegate? {
        didSet {
            imageDelegate = delegate as? FacebookImagePickerControllerDelegate
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        let fbImagesVC = FacebookImagesViewController()
        pushViewController(fbImagesVC, animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol FacebookImagePickerControllerDelegate: UINavigationControllerDelegate {
    func fbImagePickerController(_ picker: FacebookImagePickerController, didPickImage image: UIImage)
}

class FacebookImagesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var collectionView: UICollectionView?
    var images = [UIImage]()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        // set title of nav bar
        navigationItem.title = "Profile Pictures"
        
        // add cancel button to nav bar
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:))), animated: true)
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 0.27*DisplayUtility.screenWidth, height:  0.3*DisplayUtility.screenWidth)
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        if let collectionView = collectionView {
            collectionView.backgroundColor = .white
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
            
            view.addSubview(collectionView)
        }
        
        let connection = FBSDKGraphRequestConnection()
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "albums{name, photos.order(reverse_chronological){images}}"])
        connection.add(graphRequest) { (_, result, error) in
            if let result = result as? [String:AnyObject] {
                if let albums = result["albums"] as? [String:AnyObject] {
                    if let data = albums["data"] as? [AnyObject] {
                        for album in data {
                            if let album = album as? [String:AnyObject] {
                                if let name = album["name"] as? String {
                                    if name == "Profile Pictures" {
                                        if let photos = album["photos"] as? [String:AnyObject] {
                                            if let data2 = photos["data"] as? [AnyObject] {
                                                for picture in data2 {
                                                    if let picture = picture as? [String:AnyObject] {
                                                        if let images = picture["images"] as? [AnyObject] {
                                                            if images.count > 0 {
                                                                if let image = images[0] as? [String:AnyObject] {
                                                                    if let source = image["source"] as? String {
                                                                        if let url = URL(string: source) {
                                                                            if let data = try? Data(contentsOf: url) {
                                                                                let image = UIImage(data: data)!
                                                                                self.images.append(image)
                                                                                if let collectionView = self.collectionView {
                                                                                    collectionView.reloadData()
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        connection.start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cancel(_ sender: UIButton) {
        print("cancel pressed")
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .clear
        let image = images[indexPath.row]
        let imageView = UIImageView(image: image)
        let imageWToHRatio = image.size.width / image.size.height
        imageView.frame = CGRect(x: 0, y: 0, width: min(cell.frame.width, cell.frame.height * imageWToHRatio), height: min(cell.frame.height, cell.frame.width / imageWToHRatio))
        imageView.center = CGPoint(x: cell.frame.width/2, y: cell.frame.height/2)
        cell.addSubview(imageView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = images[indexPath.row]
        if let navigationController = navigationController {
            if let fbImagePicker = navigationController as? FacebookImagePickerController {
                if let imageDelegate = fbImagePicker.imageDelegate {
                    imageDelegate.fbImagePickerController(fbImagePicker, didPickImage: image)
                }
            }
        }
    }
}
