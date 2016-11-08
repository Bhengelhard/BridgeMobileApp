//
//  CustomKeyboard.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 11/4/16.
//  Copyright © 2016 BHE Ventures LLC. All rights reserved.
//

import UIKit

class CustomKeyboard: NSObject, UITextViewDelegate {
    
    var messageView = UIView()
    let messageTextView = UITextView()
    let messageButton = UIButton()
    var type = String()
    
    var updatedText = String()
    
    //setting the height of the keyboard
    var keyboardHeight = CGFloat()
    
    func display (view: UIView){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        messageView.frame = CGRect(x: 0, y: 0.925*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: 0.075*DisplayUtility.screenHeight)
        let displayUtility = DisplayUtility()
        displayUtility.setBlurredView(viewToBlur: messageView)
        view.addSubview(messageView)
        
        //setting the textView for writing messages
        messageTextView.delegate = self
        messageTextView.frame = CGRect(x: 0.05*messageView.frame.width, y: 0.1*messageView.frame.height, width: 0.65*messageView.frame.width, height: 0.8*messageView.frame.height)
        messageTextView.layer.borderWidth = 2
        messageTextView.layer.borderColor = UIColor.white.cgColor
        messageTextView.layer.cornerRadius = 5
        messageTextView.textColor = UIColor.lightGray
        messageTextView.font = UIFont(name: "BentonSans-light", size: 18)
        messageTextView.backgroundColor = DisplayUtility.necterGray
        messageTextView.text = "I am looking for..."
        messageTextView.keyboardAppearance = UIKeyboardAppearance.alert
        messageTextView.autocorrectionType = UITextAutocorrectionType.no
        messageTextView.selectedTextRange = messageTextView.textRange(from: messageTextView.beginningOfDocument, to: messageTextView.beginningOfDocument)
        messageTextView.becomeFirstResponder()
        messageView.addSubview(messageTextView)
        
        //setting the button for sending/posting messages
        messageButton.frame = CGRect(x: 0.75*messageView.frame.width, y: 0.1*messageView.frame.height, width: 0.2*DisplayUtility.screenWidth, height: 0.8*messageView.frame.height)
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
        messageView.addSubview(messageButton)
    }
    
    func resign() {
        messageTextView.resignFirstResponder()
        messageView.frame.origin.y = 0.9*DisplayUtility.screenHeight
        messageView.removeFromSuperview()
    }
    
    func updatePostType(updatedPostType: String){
        type = updatedPostType
            //setting the placeholder based on whether an option is selected
            if type != "All Types" {
                messageTextView.isUserInteractionEnabled = true
                if !messageTextView.isFirstResponder {
                    messageTextView.becomeFirstResponder()
                }
                    //setting the placeholder
                if messageTextView.textColor == UIColor.white && !updatedText.isEmpty {
                    messageButton.isEnabled = true
                }
            } else {
                //no filter is selected
                messageTextView.isUserInteractionEnabled = false
                if messageTextView.isFirstResponder {
                    messageTextView.resignFirstResponder()
                }
                messageButton.isEnabled = false
        }
    }
    
    func height() -> CGFloat {
        return keyboardHeight + messageView.frame.height
    }
    
    @objc func messageButtonTapped(_ sender: UIButton) {
        print("postTapped")
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //Combine the textView text and the replacement text to create the updated text string
        let currentText:NSString = textView.text as NSString
        updatedText = currentText.replacingCharacters(in: range, with: text)
        
        //If updated text view will be empty, add the placeholder and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            //setting the placeholder
            messageTextView.text = "I am looking for..."
            textView.textColor = UIColor.lightGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            messageButton.isEnabled = false
            return false
        }
            // else if the text view's placeholder is showing and the length of the replacement string is greater than 0, clear the text veiw and set the color to white to prepare for entry
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.white
            messageButton.isEnabled = true
        }
        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if messageView.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
        
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            messageView.frame.origin.y = DisplayUtility.screenHeight - keyboardHeight - messageView.frame.height
            print("keyboard will show")
        }
        
    }
    func keyboardWillHide(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            messageView.frame.origin.y = DisplayUtility.screenHeight - messageView.frame.height
            print("keyboard will hide")
        }
    }
    
}
