//
//  HexagonView.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 12/21/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class HexagonView: UIView {
    
    var hexBackgroundColor = UIColor.black
    var hexBackgroundImage: UIImage?
    var border = false
    var borderColor = UIColor.black
    var borderWidth: CGFloat = 1.0
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        backgroundColor = .clear
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        
        ctx?.move(to: CGPoint(x: rect.minX, y: rect.midY))
        ctx?.addLine(to: CGPoint(x: rect.minX + 0.25*rect.width, y: rect.minY))
        ctx?.addLine(to: CGPoint(x: rect.maxX - 0.25*rect.width, y: rect.minY))
        ctx?.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        ctx?.addLine(to: CGPoint(x: rect.maxX - 0.25*rect.width, y: rect.maxY))
        ctx?.addLine(to: CGPoint(x: rect.minX + 0.25*rect.width, y: rect.maxY))
        ctx?.closePath()
        
        ctx?.setFillColor(hexBackgroundColor.cgColor)
        ctx?.fillPath()
        
        if border {
            ctx?.move(to: CGPoint(x: rect.minX + borderWidth/2, y: rect.midY))
            ctx?.addLine(to: CGPoint(x: rect.minX + 0.25*rect.width + borderWidth/4, y: rect.minY + borderWidth/2))
            ctx?.addLine(to: CGPoint(x: rect.maxX - 0.25*rect.width - borderWidth/4, y: rect.minY + borderWidth/2))
            ctx?.addLine(to: CGPoint(x: rect.maxX - borderWidth/2, y: rect.midY))
            ctx?.addLine(to: CGPoint(x: rect.maxX - 0.25*rect.width - borderWidth/4, y: rect.maxY - borderWidth/2))
            ctx?.addLine(to: CGPoint(x: rect.minX + 0.25*rect.width + borderWidth/4, y: rect.maxY - borderWidth/2))
            ctx?.closePath()
            
            ctx?.setLineWidth(borderWidth)
            ctx?.setStrokeColor(borderColor.cgColor)
            ctx?.strokePath()
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let path = CGMutablePath()
        
        path.move(to: CGPoint(x: bounds.minX, y: bounds.midY))
        path.addLine(to: CGPoint(x: bounds.minX + 0.25*bounds.width, y: bounds.minY))
        path.addLine(to: CGPoint(x: bounds.maxX - 0.25*bounds.width, y: bounds.minY))
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.midY))
        path.addLine(to: CGPoint(x: bounds.maxX - 0.25*bounds.width, y: bounds.maxY))
        path.addLine(to: CGPoint(x: bounds.minX + 0.25*bounds.width, y: bounds.maxY))
        path.closeSubpath()
        
        if path.contains(point) {
            return self
        }
        
        return nil
    }
    
    func setBackgroundColor(color: UIColor) {
        hexBackgroundColor = color
        DispatchQueue.main.async {
            self.setNeedsDisplay()
        }
    }
    
    func setBackgroundImage(image: UIImage) {
        hexBackgroundImage = image
        if let newImage = fitImageToView(image: image) {
            hexBackgroundColor = UIColor(patternImage: newImage)
        } else {
            hexBackgroundColor = UIColor(patternImage: image)
        }
        DispatchQueue.main.async {
            self.setNeedsDisplay()
        }
    }
    
    func resetBackgroundImage() {
        if let image = hexBackgroundImage {
            setBackgroundImage(image: image)
        }
    }
    
    func addBorder(width: CGFloat, color: UIColor) {
        border = true
        borderWidth = width
        borderColor = color
        DispatchQueue.main.async {
            self.setNeedsDisplay()
        }
    }
    
    func fitImageToView(image: UIImage) -> UIImage? {
        let viewSize = CGSize(width: frame.width, height: frame.width)
        var resultImage: UIImage?
        UIGraphicsBeginImageContext(viewSize)
        image.draw(in: CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height))
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return resultImage;
    }
    
}
