//
//  CropImageViewController.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 1/26/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class CropImageViewController: UIViewController {
    
    var delegate: CropImageViewControllerDelegate?
    let image: UIImage
    let imageView:  UIImageView
    let cropBox: UIView
    var initialCroppedImageOrigin: CGPoint?
    var initialCroppedImageSize: CGSize?
    var minScale: CGFloat = 0.0 // TODO: use iphone 7+ width & height
    var maxScale: CGFloat = 0.0
    var currentScale: CGFloat = 1.0
    var maxCropBoxSize = CGSize()
    var cropBoxCenter = CGPoint()
    let dashedBorder = CAShapeLayer()
    let leftGrayBox = UIView()
    let topGrayBox = UIView()
    let rightGrayBox = UIView()
    let bottomGrayBox = UIView()
    
    init(image: UIImage, croppedImageFrame: CGRect? = nil) {
        self.image = image
        imageView = UIImageView()
        cropBox = UIView()
        if let croppedImageFrame = croppedImageFrame {
            initialCroppedImageOrigin = croppedImageFrame.origin
            initialCroppedImageSize = croppedImageFrame.size
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        imageView.image = image
        imageView.isUserInteractionEnabled = true
        
        // imageView should fit entire width or height of view
        let imageWToHRatio = image.size.width / image.size.height
        let imageViewHeight = min(min(view.frame.height, view.frame.width / imageWToHRatio), 0.75*DisplayUtility.screenHeight)
        let imageViewWidth = min(view.frame.width, imageViewHeight * imageWToHRatio)
        imageView.frame = CGRect(x: 0, y: 0.05*DisplayUtility.screenHeight, width: imageViewWidth, height: imageViewHeight)
        imageView.center.x = view.frame.width / 2
        view.addSubview(imageView)
        
        
        cropBox.backgroundColor = .clear
        cropBox.isUserInteractionEnabled = true
        
        let croppedImageWToHRatio = ProfileHexagons.hexWToHRatio
        maxCropBoxSize = CGSize(width: min(imageView.frame.width, imageView.frame.height * croppedImageWToHRatio), height: min(imageView.frame.height, imageView.frame.width / croppedImageWToHRatio))
        
        // set size of crop box
        if let croppedImageSize = initialCroppedImageSize {
            cropBox.frame.size = CGSize(width: croppedImageSize.width * imageView.frame.width / image.size.width, height: croppedImageSize.height * imageView.frame.height / image.size.height)
        } else { // default to max possible size
            cropBox.frame.size = maxCropBoxSize
        }
        
        // set position of crop box
        if let croppedImageOrigin = initialCroppedImageOrigin {
            cropBox.frame.origin = CGPoint(x: croppedImageOrigin.x * imageView.frame.width / image.size.width, y: croppedImageOrigin.y * imageView.frame.height / image.size.height)
        } else { // default to center of image view
            cropBox.center = CGPoint(x: imageView.frame.width / 2, y: imageView.frame.height / 2)
        }
        cropBoxCenter = cropBox.center
        
        imageView.addSubview(cropBox)

        currentScale = max(cropBox.frame.width / maxCropBoxSize.width, cropBox.frame.height / maxCropBoxSize.height)
        maxScale = 1.0
        minScale = 0.4
        
        // create dashed border around crop box
        dashedBorder.fillColor = UIColor.clear.cgColor
        dashedBorder.lineWidth = 1
        dashedBorder.lineJoin = kCALineJoinRound
        dashedBorder.lineDashPattern = [4,4]
        cropBox.layer.addSublayer(dashedBorder)
        adjustDashedBorder()
        
        // set up gray boxes that make part of image outside crop box look darker
        for grayBox in [leftGrayBox, topGrayBox, rightGrayBox, bottomGrayBox] {
            grayBox.backgroundColor = .darkGray
            grayBox.alpha = 0.6
            imageView.addSubview(grayBox)
        }
        adjustGrayBoxes()
        
        // pinch gesture recognizer for changing size of crop box
        let zoomGR = UIPinchGestureRecognizer(target: self, action: #selector(zoom(_:)))
        cropBox.addGestureRecognizer(zoomGR)
        
        // pan gesture recognizer for changing position of crop box
        let moveGR = UIPanGestureRecognizer(target: self, action: #selector(move(_:)))
        cropBox.addGestureRecognizer(moveGR)
        
        let showBigImageGR = UITapGestureRecognizer(target: self, action: #selector(showImage(_:)))
        cropBox.addGestureRecognizer(showBigImageGR)
        
        // create buttons menu
        let menu = UIView()
        
        let buttonWidth = 0.33*DisplayUtility.screenWidth
        let buttonHeight = 0.212*buttonWidth
        
        
        // create save button
        let saveButtonFrame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        let saveButton = DisplayUtility.plainButton(frame: saveButtonFrame, text: "SAVE", fontSize: 13)
        saveButton.center.x = DisplayUtility.screenWidth / 2
        menu.addSubview(saveButton)
        
        // add target for save button
        saveButton.addTarget(self, action: #selector(save(_:)), for: .touchUpInside)
        
        
        // create cancel button
        let cancelButtonFrame = CGRect(x: 0, y: saveButton.frame.maxY + 0.015*DisplayUtility.screenHeight, width: buttonWidth, height: buttonHeight)
        let cancelButton = DisplayUtility.plainButton(frame: cancelButtonFrame, text: "CANCEL", fontSize: 13)
        cancelButton.center.x = DisplayUtility.screenWidth / 2
        menu.addSubview(cancelButton)
        
        // add target for cancel button
        cancelButton.addTarget(self, action: #selector(cancel(_:)), for: .touchUpInside)
        
        menu.frame = CGRect(x: 0, y: imageView.frame.maxY + 0.05*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: cancelButton.frame.maxY)
        view.addSubview(menu)
    }
    
    func save(_ sender: UIButton) {
        if let delegate = delegate {
            let croppedImage = self.croppedImage()
            delegate.cropImageViewController(cropImageViewController: self, didCropImageTo: croppedImage, withCroppedImageFrame: croppedImageFrame())
            let bigImageView = UIImageView()
            bigImageView.image = croppedImage
            bigImageView.frame = CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: DisplayUtility.screenWidth / ProfileHexagons.hexWToHRatio)
            view.addSubview(bigImageView)
            UIView.animate(withDuration: 3.0, animations: { 
                bigImageView.alpha = 0
            }, completion: { (finished) in
                if finished {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
        //dismiss(animated: true, completion: nil)
    }
    
    func croppedImage() -> UIImage {
        let imageRef = image.cgImage!
        let bitmapInfo = imageRef.bitmapInfo
        let colorspaceInfo = imageRef.colorSpace!
        var bitmap: CGContext?
        
        let targetWidth = image.size.width
        let targetHeight = image.size.height
        
        if image.imageOrientation == .up || image.imageOrientation == .down {
            bitmap = CGContext(data: nil, width: Int(targetWidth), height: Int(targetHeight), bitsPerComponent: imageRef.bitsPerComponent, bytesPerRow: imageRef.bytesPerRow, space: colorspaceInfo, bitmapInfo: bitmapInfo.rawValue)
        } else {
            bitmap = CGContext(data: nil, width: Int(targetHeight), height: Int(targetWidth), bitsPerComponent: imageRef.bitsPerComponent, bytesPerRow: imageRef.bytesPerRow, space: colorspaceInfo, bitmapInfo: bitmapInfo.rawValue)
        }

        if let bitmap = bitmap {
            // rotate and translate image if orientation is not up
            if image.imageOrientation == .left {
                print("LEFT")
                bitmap.rotate(by: 90 * CGFloat.pi / 180)
                bitmap.translateBy(x: 0, y: -targetHeight)
            } else if image.imageOrientation == .right {
                print("RIGHT")
                bitmap.rotate(by: -90 * CGFloat.pi / 180)
                bitmap.translateBy(x: -targetWidth, y: 0)
            } else if image.imageOrientation == .down {
                print("DOWN")
                bitmap.translateBy(x: targetWidth, y: targetHeight)
                bitmap.rotate(by: -180 * CGFloat.pi / 180)
            } else {
                print("UP")
            }
            
            bitmap.draw(imageRef, in: CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight))
            if let newImageRef = bitmap.makeImage() {
                let newImage = UIImage(cgImage: newImageRef)
                
                // crop image
                let cropFrame = CGRect(x: cropBox.frame.minX * newImage.size.width / imageView.frame.width, y: cropBox.frame.minY * newImage.size.height / imageView.frame.height, width: cropBox.frame.width * newImage.size.width / imageView.frame.width, height: cropBox.frame.height * newImage.size.height / imageView.frame.height)
                if let croppedImageRef = newImageRef.cropping(to: cropFrame) {
                    //let croppedImage = UIImage(cgImage: croppedImageRef)
                    let croppedImage = UIImage(cgImage: croppedImageRef, scale: 1.0, orientation: .up)
                    return croppedImage
                }
            }
        }
        return image
    }
    
    func croppedImageFrame() -> CGRect {
        let croppedImageFrame = CGRect(x: cropBox.frame.minX / imageView.frame.width * image.size.width, y: cropBox.frame.minY / imageView.frame.height * image.size.height, width: cropBox.frame.width / imageView.frame.width * image.size.width, height: cropBox.frame.height / imageView.frame.height * image.size.height)
        return croppedImageFrame
    }
    
    func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func zoom(_ gesture: UIPinchGestureRecognizer) {
        let scale = gesture.scale
        let newScale = scale * currentScale
        
        if newScale > maxScale {
            currentScale = maxScale
        } else if newScale < minScale {
            currentScale = minScale
        } else {
            currentScale = newScale
        }
        
        cropBox.frame.size = CGSize(width: maxCropBoxSize.width * currentScale, height: maxCropBoxSize.height * currentScale)
        cropBox.center = cropBoxCenter
        
        if cropBox.frame.minX < 0 { // hitting left edge
            cropBox.frame.origin = CGPoint(x: 0, y: cropBox.frame.minY)
        }
        if cropBox.frame.maxX > imageView.frame.width { // hitting right edge
            cropBox.frame.origin = CGPoint(x: imageView.frame.width - cropBox.frame.width, y: cropBox.frame.minY)
        }
        if cropBox.frame.minY < 0 { // hitting top edge
            cropBox.frame.origin = CGPoint(x: cropBox.frame.minX, y: 0)
        }
        if cropBox.frame.maxY > imageView.frame.height { // hitting bottom edge
            cropBox.frame.origin = CGPoint(x: cropBox.frame.minX, y: imageView.frame.height - cropBox.frame.height)
        }
        
        adjustGrayBoxes()
        adjustDashedBorder()
        
        if gesture.state == .ended {
            cropBoxCenter = cropBox.center
        }
    }
    
    func move(_ gesture: UIPanGestureRecognizer) {
        var translation = gesture.translation(in: view)
        translation.x = min(translation.x, imageView.frame.width - cropBox.frame.maxX)
        translation.x = max(translation.x, -cropBox.frame.minX)
        translation.y = min(translation.y, imageView.frame.height - cropBox.frame.maxY)
        translation.y = max(translation.y, -cropBox.frame.minY)
        cropBox.center = CGPoint(x: cropBox.center.x + translation.x, y: cropBox.center.y + translation.y)
        gesture.setTranslation(CGPoint.zero, in: view)
        cropBoxCenter = cropBox.center
        
        adjustGrayBoxes()
    }
    
    func adjustDashedBorder() {
        let color = DisplayUtility.gradientColor(size: cropBox.frame.size)
        dashedBorder.strokeColor = color.cgColor
        dashedBorder.bounds = cropBox.bounds
        dashedBorder.position = CGPoint(x: cropBox.frame.width/2, y: cropBox.frame.height/2)
        dashedBorder.path = UIBezierPath(rect: cropBox.bounds).cgPath
    }
    
    func adjustGrayBoxes() {
        leftGrayBox.frame = CGRect(x: 0, y: 0, width: cropBox.frame.minX, height: imageView.frame.height)
        topGrayBox.frame = CGRect(x: cropBox.frame.minX, y: 0, width: cropBox.frame.width, height: cropBox.frame.minY)
        rightGrayBox.frame = CGRect(x: cropBox.frame.maxX, y: 0, width: imageView.frame.width - cropBox.frame.maxX, height: imageView.frame.height)
        bottomGrayBox.frame = CGRect(x: cropBox.frame.minX, y: cropBox.frame.maxY, width: cropBox.frame.width, height: imageView.frame.height - cropBox.frame.maxY)
    }
    
    func showImage(_ gesture: UIGestureRecognizer) {
        print("showing image")
        
        let imageRef = image.cgImage!
        let bitmapInfo = imageRef.bitmapInfo
        let colorspaceInfo = imageRef.colorSpace!
        var bitmap: CGContext?
        
        let targetWidth = DisplayUtility.screenWidth
        let targetHeight = DisplayUtility.screenWidth
        
        if image.imageOrientation == .up || image.imageOrientation == .down {
            bitmap = CGContext(data: nil, width: Int(targetWidth), height: Int(targetHeight), bitsPerComponent: imageRef.bitsPerComponent, bytesPerRow: imageRef.bytesPerRow, space: colorspaceInfo, bitmapInfo: bitmapInfo.rawValue)
        } else {
            bitmap = CGContext(data: nil, width: Int(targetHeight), height: Int(targetWidth), bitsPerComponent: imageRef.bitsPerComponent, bytesPerRow: imageRef.bytesPerRow, space: colorspaceInfo, bitmapInfo: bitmapInfo.rawValue)
        }
        
        if let bitmap = bitmap {
            if image.imageOrientation == .left {
                print("LEFT")
                bitmap.rotate(by: 90 * CGFloat.pi / 180)
                bitmap.translateBy(x: 0, y: -targetHeight)
            } else if image.imageOrientation == .right {
                print("RIGHT")
                bitmap.rotate(by: -90 * CGFloat.pi / 180)
                bitmap.translateBy(x: -targetWidth, y: 0)
            } else if image.imageOrientation == .down {
                print("DOWN")
                bitmap.translateBy(x: targetWidth, y: targetHeight)
                bitmap.rotate(by: -180 * CGFloat.pi / 180)
            } else {
                print("UP")
            }
            
            bitmap.draw(imageRef, in: CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight))
            let newImageRef = bitmap.makeImage()
            if let newImageRef = newImageRef {
                let newImage = UIImage(cgImage: newImageRef)
                let cropFrame = CGRect(x: cropBox.frame.minX * newImage.size.width / imageView.frame.width, y: cropBox.frame.minY * newImage.size.height / imageView.frame.height, width: cropBox.frame.width * newImage.size.width / imageView.frame.width, height: cropBox.frame.height * newImage.size.height / imageView.frame.height)
                let croppedImageRef = newImageRef.cropping(to: cropFrame)
                if let croppedImageRef = croppedImageRef {
                    let croppedImage = UIImage(cgImage: croppedImageRef)
                    let bigImageView = UIImageView()
                    bigImageView.image = newImage
                    bigImageView.frame = CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: DisplayUtility.screenWidth * newImage.size.height / newImage.size.width)
                    view.addSubview(bigImageView)
                    UIView.animate(withDuration: 3.0) {
                        bigImageView.alpha = 0
                    }
                }
            }
            
        }
        
    }
}

protocol CropImageViewControllerDelegate {
    func cropImageViewController(cropImageViewController: CropImageViewController, didCropImageTo croppedImage: UIImage, withCroppedImageFrame croppedImageFrame: CGRect)
}
