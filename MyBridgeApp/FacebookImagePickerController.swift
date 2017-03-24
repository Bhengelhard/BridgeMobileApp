//
//  FacebookImagePickercController.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 2/1/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
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
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 0.25*(DisplayUtility.screenWidth-6), height: 0.25*(DisplayUtility.screenWidth-6))
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        if let collectionView = collectionView {
            collectionView.backgroundColor = .white
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(FacebookImageCell.self, forCellWithReuseIdentifier: "Cell")
            
            view.addSubview(collectionView)
        }
        
        getPhotos()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getPhotos() {
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
                                        if let id = album["id"] as? String {
                                            print("album id = \(id)")
                                            self.getPhotosFromAlbum(id: id, nextCursor: nil)
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
    
    func getPhotosFromAlbum(id: String, nextCursor: String?) {
        var params = ["fields": "source"]
        if let nextCursor = nextCursor {
            params["after"] = nextCursor
        }
        let connection = FBSDKGraphRequestConnection()
        let graphRequest = FBSDKGraphRequest(graphPath: "/\(id)/photos", parameters: params)
        connection.add(graphRequest) { (_, result, error) in
            print(result ?? "no result")
            if let result = result as? [String:AnyObject] {
                print(result)
                if let data = result["data"] as? [AnyObject] {
                    for picture in data {
                        if let picture = picture as? [String:AnyObject] {
                            if let source = picture["source"] as? String {
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
                // check for more pages
                if let paging = result["paging"] as? [String:AnyObject] {
                    if paging["next"] != nil { // there are more pages
                        if let cursors = paging["cursors"] as? [String:AnyObject] {
                            if let after = cursors["after"] as? String {
                                self.getPhotosFromAlbum(id: id, nextCursor: after) // recursive call with "after" cursor
                            }
                        }
                    }
                }
            }
        }
        connection.start()
    }
    
    func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FacebookImageCell
        let image = images[indexPath.row]
        cell.setImage(image: image)
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

class FacebookImageCell: UICollectionViewCell {
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(image: UIImage) {
        imageView.image = image
        let imageWToHRatio = image.size.width / image.size.height
        imageView.frame = CGRect(x: 0, y: 0, width: min(frame.width, frame.height * imageWToHRatio), height: min(frame.height, frame.width / imageWToHRatio))
        imageView.center = CGPoint(x: frame.width/2, y: frame.height/2)
    }
    
}
