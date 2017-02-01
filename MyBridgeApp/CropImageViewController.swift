//
//  CropImageViewController.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 1/26/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class CropImageViewController: UIViewController {
    
    let imageView = UIImageView()
    var imageViewCenter = CGPoint()
    let box = UIView()
    var maxScale: CGFloat = 0.0
    var minScale: CGFloat = 0.0
    var currentScale: CGFloat = 1.0
    var standardBoxSize = CGSize.zero
    var boxCenter = CGPoint.zero
    let dashedBorder = CAShapeLayer()
    let leftGrayBox = UIView()
    let topGrayBox = UIView()
    let rightGrayBox = UIView()
    let bottomGrayBox = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
        let exitGR = UITapGestureRecognizer(target: self, action: #selector(exit(_:)))
        view.addGestureRecognizer(exitGR)
        
        view.addSubview(imageView)
        
        box.frame = CGRect(x: 0, y: 0, width: 0.6*DisplayUtility.screenWidth, height: 0.6*DisplayUtility.screenWidth)
        box.center.x = view.frame.width / 2
        box.center.y = view.frame.height / 2
        standardBoxSize = box.frame.size
        boxCenter = box.center
        box.backgroundColor = .clear
        box.isUserInteractionEnabled = true
        view.addSubview(box)
        
        // Create Dashed Border
        dashedBorder.fillColor = UIColor.clear.cgColor
        dashedBorder.lineWidth = 1
        dashedBorder.lineJoin = kCALineJoinRound
        dashedBorder.lineDashPattern = [4,4]
        box.layer.addSublayer(dashedBorder)
        
        adjustDashedBorder()
        
        let zoomGR = UIPinchGestureRecognizer(target: self, action: #selector(zoom(_:)))
        box.addGestureRecognizer(zoomGR)
        
        let moveGR = UIPanGestureRecognizer(target: self, action: #selector(move(_:)))
        box.addGestureRecognizer(moveGR)
        
        for grayBox in [leftGrayBox, topGrayBox, rightGrayBox, bottomGrayBox] {
            grayBox.backgroundColor = .darkGray
            grayBox.alpha = 0.6
            view.addSubview(grayBox)
        }
        
        let showBigImageGR = UITapGestureRecognizer(target: self, action: #selector(showImage(_:)))
        box.addGestureRecognizer(showBigImageGR)
    }
    
    func setImage(image: UIImage) {
        imageView.image = image
        
        let imageWToHRatio = image.size.width / image.size.height
        imageView.frame = CGRect(x: 0, y: 0, width: min(view.frame.width, view.frame.height * imageWToHRatio), height: min(view.frame.height, view.frame.width / imageWToHRatio))
        imageView.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        
        maxScale = min(imageView.frame.width / box.frame.width, imageView.frame.height / box.frame.height)
        minScale = 0.4
        
        adjustGrayBoxes()
        
    }
    func zoom(_ gesture: UIPinchGestureRecognizer) {
        
        maxScale = min(
            min(
                (2*(box.frame.minX - imageView.frame.minX) + box.frame.width)/standardBoxSize.width,
                (2*(imageView.frame.maxX - box.frame.maxX) + box.frame.width)/standardBoxSize.width),
            min(
                (2*(box.frame.minY - imageView.frame.minY) + box.frame.height)/standardBoxSize.height,
                (2*(imageView.frame.maxY - box.frame.maxY) + box.frame.height)/standardBoxSize.height)
        )
        
        let scale = gesture.scale
        let newScale = scale * currentScale
        if newScale > maxScale {
            currentScale = maxScale
        } else if newScale < minScale {
            currentScale = minScale
        } else {
            currentScale = newScale
        }
        
        box.frame.size = CGSize(width: standardBoxSize.width * currentScale, height: standardBoxSize.height * currentScale)
        box.center = boxCenter
        
        adjustGrayBoxes()
        adjustDashedBorder()
    }
    
    func move(_ gesture: UIPanGestureRecognizer) {
        var translation = gesture.translation(in: view)
        translation.x = min(translation.x, imageView.frame.maxX - box.frame.maxX)
        translation.x = max(translation.x, imageView.frame.minX - box.frame.minX)
        translation.y = min(translation.y, imageView.frame.maxY - box.frame.maxY)
        translation.y = max(translation.y, imageView.frame.minY - box.frame.minY)
        box.center = CGPoint(x: box.center.x + translation.x, y: box.center.y + translation.y)
        gesture.setTranslation(CGPoint.zero, in: view)
        boxCenter = box.center
        
        adjustGrayBoxes()
    }
    
    func adjustDashedBorder() {
        let color = DisplayUtility.gradientColor(size: box.frame.size)
        dashedBorder.strokeColor = color.cgColor
        dashedBorder.bounds = CGRect(x: 0, y: 0, width: box.frame.width, height: box.frame.height)
        dashedBorder.position = CGPoint(x: box.frame.width/2, y: box.frame.height/2)
        dashedBorder.path = UIBezierPath(rect: box.bounds).cgPath
    }
    
    func adjustGrayBoxes() {
        leftGrayBox.frame = CGRect(x: imageView.frame.minX, y: imageView.frame.minY, width: box.frame.minX-imageView.frame.minX, height: imageView.frame.height)
        topGrayBox.frame = CGRect(x: box.frame.minX, y: imageView.frame.minY, width: box.frame.width, height: box.frame.minY - imageView.frame.minY)
        rightGrayBox.frame = CGRect(x: box.frame.maxX, y: imageView.frame.minY, width: imageView.frame.width - box.frame.maxX, height: imageView.frame.height)
        bottomGrayBox.frame = CGRect(x: box.frame.minX, y: box.frame.maxY, width: box.frame.width, height: imageView.frame.maxY - box.frame.maxY)
        
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
