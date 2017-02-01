//
//  CropImageViewController.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 1/26/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class CropImageViewController: UIViewController {
    
    let image: UIImage
    let imageView:  UIImageView
    let cropBox: UIView
    let initialCropBoxOrigin: CGPoint?
    let initialCropBoxSize: CGSize?
    var minScale: CGFloat = 0.0
    var maxScale: CGFloat = 0.0
    var currentScale: CGFloat = 1.0
    var maxCropBoxSize = CGSize()
    var cropBoxCenter = CGPoint()
    let dashedBorder = CAShapeLayer()
    let leftGrayBox = UIView()
    let topGrayBox = UIView()
    let rightGrayBox = UIView()
    let bottomGrayBox = UIView()
    
    init(image: UIImage, initialCropBoxOrigin: CGPoint? = nil, initialCropBoxSize: CGSize? = nil) {
        self.image = image
        self.imageView = UIImageView()
        self.cropBox = UIView()
        self.initialCropBoxOrigin = initialCropBoxOrigin
        self.initialCropBoxSize = initialCropBoxSize
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
        imageView.frame = CGRect(x: 0, y: 0.05*DisplayUtility.screenHeight, width: min(view.frame.width, view.frame.height * imageWToHRatio), height: min(view.frame.height, view.frame.width / imageWToHRatio))
        // center image view in view
        imageView.center.x = view.frame.width / 2
        view.addSubview(imageView)
        
        // tap gesture recognizer for exiting
        let exitGR = UITapGestureRecognizer(target: self, action: #selector(exit(_:)))
        imageView.addGestureRecognizer(exitGR)
        
        cropBox.backgroundColor = .clear
        cropBox.isUserInteractionEnabled = true
        
        maxCropBoxSize = CGSize(width: min(imageView.frame.width, imageView.frame.height), height: min(imageView.frame.height, imageView.frame.width))
        
        // set size of crop box
        if let cropBoxSize = initialCropBoxSize {
            cropBox.frame.size = cropBoxSize
        } else { // default to max possible size
            cropBox.frame.size = maxCropBoxSize
        }
        
        // set position of crop box
        if let cropBoxOrigin = initialCropBoxOrigin {
            cropBox.frame.origin = cropBoxOrigin
        } else { // default to center of image view
            cropBox.center = CGPoint(x: imageView.frame.width / 2, y: imageView.frame.height / 2)
        }
        cropBoxCenter = cropBox.center
        
        imageView.addSubview(cropBox)

        currentScale = max(cropBox.frame.width / imageView.frame.width, cropBox.frame.height / imageView.frame.height)
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
        
        /*
        let showBigImageGR = UITapGestureRecognizer(target: self, action: #selector(showImage(_:)))
        box.addGestureRecognizer(showBigImageGR)*/
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
        
        /*
        leftGrayBox.backgroundColor = .red
        topGrayBox.backgroundColor = .orange
        rightGrayBox.backgroundColor = .yellow
        bottomGrayBox.backgroundColor = .green
        */
    }
    
    func showImage(_ gesture: UIGestureRecognizer) {
        let image = imageView.image
        let imageRef = image?.cgImage
        let bitmapInfo = imageRef?.bitmapInfo
        let colorspaceInfo = imageRef?.colorSpace
        var bitmap: CGContext
        
        let targetWidth = DisplayUtility.screenWidth
        let targetHeight = DisplayUtility.screenHeight
        
        if image?.imageOrientation == .up || image?.imageOrientation == .down {
            bitmap = CGContext(data: nil, width: Int(targetWidth), height: Int(targetHeight), bitsPerComponent: imageRef!.bitsPerComponent, bytesPerRow: imageRef!.bytesPerRow, space: colorspaceInfo!, bitmapInfo: bitmapInfo!.rawValue)!
        } else {
            bitmap = CGContext(data: nil, width: Int(targetHeight), height: Int(targetWidth), bitsPerComponent: imageRef!.bitsPerComponent, bytesPerRow: imageRef!.bytesPerRow, space: colorspaceInfo!, bitmapInfo: bitmapInfo!.rawValue)!
        }
        
        if image?.imageOrientation == .left {
            bitmap.rotate(by: 90 * CGFloat.pi / 180)
            bitmap.translateBy(x: 0, y: -targetHeight)
        } else if image?.imageOrientation == .right {
            bitmap.rotate(by: -90 * CGFloat.pi / 180)
            bitmap.translateBy(x: -targetWidth, y: 0)
        } else if image?.imageOrientation == .down {
            bitmap.translateBy(x: targetWidth, y: targetHeight)
            bitmap.rotate(by: -180 * CGFloat.pi / 180)
        }
        
        
        //CGContextDrawImage(bitmap, CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight), imageRef)
        
        /*
        let cropImageViewFrame = view.convert(box.frame, to: imageView)
        let imageToImageViewWRatio = imageView.image!.size.width / imageView.frame.width
        let imageToImageViewHRatio = imageView.image!.size.height / imageView.frame.height
        let cropFrame = CGRect(x: cropImageViewFrame.minX * imageToImageViewWRatio, y: cropImageViewFrame.minY * imageToImageViewHRatio, width: cropImageViewFrame.width * imageToImageViewWRatio, height: cropImageViewFrame.height * imageToImageViewHRatio)
        var croppedImage: CGImage
        if imageView.image?.imageOrientation == .up || imageView.image?.imageOrientation == .down {
        }
        let imageRef = imageView.image!.cgImage!.cropping(to: cropFrame)!
        let bigImageView = UIImageView()
        bigImageView.image = UIImage(cgImage: imageRef)
        bigImageView.frame = CGRect(x: 0, y: 0, width: DisplayUtility.screenWidth, height: DisplayUtility.screenWidth)
        view.addSubview(bigImageView)
        UIView.animate(withDuration: 3.0) { 
            bigImageView.alpha = 0
        }
        */
    }
    
    func exit(_ gesture: UIGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
