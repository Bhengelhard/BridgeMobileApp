//
//  CustomKeyboard.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 11/4/16.
//  Copyright © 2016 BHE Ventures LLC. All rights reserved.
//

import UIKit

class CustomKeyboard: NSObject, UITextViewDelegate {
    
    var postView = UIView()
    let messageView = UITextView()
    let messageButton = UIButton()
    
    //setting the height of the keyboard
    var keyboardHeight = CGFloat()
    
    func display (view: UIView){
        postView.frame = CGRect(x: 0, y: DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: 0.4*DisplayUtility.screenHeight)
        postView.backgroundColor = UIColor.black
        
        let maskPath = UIBezierPath(roundedRect: postView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 5.0, height: 5.0))
        let postViewShape = CAShapeLayer()
        postViewShape.path = maskPath.cgPath
        postView.layer.mask = postViewShape
        
        view.addSubview(postView)
        
        //adding the post status text field and the post button

        
        //setting the send button
        messageButton.frame = CGRect(x: 0.75*postView.frame.width, y: 0.05*postView.frame.height, width: 0.2*DisplayUtility.screenWidth, height: 0.0605*DisplayUtility.screenHeight)
        messageButton.setTitle("Post", for: .normal)
        messageButton.setTitleColor(DisplayUtility.necterYellow, for: .normal)
        messageButton.setTitleColor(DisplayUtility.necterGray, for: .disabled)
        messageButton.titleLabel?.textAlignment = NSTextAlignment.right
        messageButton.titleLabel!.font = UIFont(name: "Verdana", size: 16)
        messageButton.layer.borderWidth = 2
        messageButton.layer.borderColor = UIColor.white.cgColor
        messageButton.layer.cornerRadius = 5
        messageButton.addTarget(self, action: #selector(messageButtonTapped(_:)), for: .touchUpInside)
        messageButton.isEnabled = false
        
        postView.addSubview(messageButton)
        
        messageView.delegate = self
        messageView.frame = CGRect(x: 0.05*postView.frame.width, y: 0.05*postView.frame.height, width: 0.65*DisplayUtility.screenWidth, height: 0.0605*DisplayUtility.screenHeight)
        messageView.layer.borderWidth = 2
        messageView.layer.borderColor = UIColor.white.cgColor
        messageView.layer.cornerRadius = 5
        messageView.textColor = UIColor.lightGray
        messageView.text = "I am looking for..."
        messageView.backgroundColor = DisplayUtility.necterGray
        //messageView.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.editingChanged)
    
        messageView.keyboardAppearance = UIKeyboardAppearance.alert
        messageView.autocorrectionType = UITextAutocorrectionType.no
        messageView.becomeFirstResponder()
        
        postView.addSubview(messageView)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            self.postView.frame.origin.y = 0.6*DisplayUtility.screenHeight
        })
        
    }
    
    func resign() {
        messageView.resignFirstResponder()
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            self.postView.frame.origin.y = DisplayUtility.screenHeight
        })
        postView.removeFromSuperview()
        
    }
    
    @objc func messageButtonTapped(_ sender: UIButton) {
        print("postTapped")
    }
    
    
    
    
    func textViewDidChange(_ textView: UITextView) {
        print("TextViewDidChange")
        /*if messageView.text != "" {
            messageButton.isEnabled = true
            
            //changing the height of the messageText based on the content
            let messageTextFixedWidth = messageView.frame.size.width
            let messageTextNewSize = messageView.sizeThatFits(CGSize(width: messageTextFixedWidth, height: CGFloat.greatestFiniteMagnitude))
            var messageTextNewFrame = messageView.frame
            messageTextNewFrame.size = CGSize(width: max(messageTextNewSize.width, messageTextFixedWidth), height: messageTextNewSize.height)
            
            let toolbarFixedHeight = 0.89*DisplayUtility.screenHeight-keyboardHeight
            
            
            if toolbarFixedHeight < messageTextNewFrame.size.height + 8.5 {
                
                print("reached the navBar")
                messageView.isScrollEnabled = true
                //messageText.frame.size.height = previousMessageHeight
                //toolbar.frame.size.height = previousToolbarHeight
            } else {
                
                messageView.frame = messageTextNewFrame
                
                /*//changing the height of the toolbar based on the content
                let previousToolbarHeight = toolbar.frame.height
                let newToolbarHeight = messageTextNewFrame.size.height + 8.5
                let changeInToolbarHeight = newToolbarHeight - previousToolbarHeight
                let toolbarFixedWidth = toolbar.frame.size.width
                
                //toolbar.sizeThatFits(CGSize(width: toolbarFixedWidth, height: toolbarFixedHeight))
                let toolbarNewSize = toolbar.sizeThatFits(CGSize(width: toolbarFixedWidth, height: toolbarFixedHeight))
                var toolbarNewFrame = toolbar.frame
                toolbarNewFrame.size = CGSize(width: max(toolbarNewSize.width, toolbarFixedWidth), height: min(messageTextNewFrame.size.height + 8.5, toolbarFixedHeight))
                toolbarNewFrame.origin.y = toolbar.frame.origin.y - changeInToolbarHeight
                //if the toolbar has grown to the size where it is just below the navigation bar then enable the textView to scroll
                toolbar.frame = toolbarNewFrame*/
            }
            
            
        } else {
            messageButton.isEnabled = false
        }*/
        
        
    }
    
    //taking away the placeholder to begin editing the textView
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("textViewDidBeginEditing")
        /*if messageView.textColor == UIColor.lightGray {
            messageView.text = nil
            messageView.textColor = UIColor.white
        }*/
    }
    //adding a placeholder when the user is not editing the textView
    func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewDidEndEditing")
        /*if messageView.text.isEmpty {
            messageView.text = "Type a message..."
            messageView.textColor = UIColor.lightGray
        }*/
    }
    

    
    func keyboardWillShow(notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            print("keyboardWillShow")
        }
        
    }
    func keyboardWillHide(notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print("keyboardWillHide")
        }
    }
    
    
}
