// 
//  CustomKeyboard.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 11/4/16.
//  Copyright © 2016 BHE Ventures LLC. All rights reserved.
//

import UIKit
import Parse

class CustomKeyboard: NSObject, UITextViewDelegate {
    
    var messageView = UIView()
    let messageTextView = UITextView()
    let messageButton = UIButton()
    var type = String()
    var placeholderText = "Enter Text Here"
    var target = String()
    var maxNumCharacters = Int.max
    
    var updatedText = String()
    
    //setting the height of the keyboard
    var keyboardHeight = CGFloat()
    
    func display (view: UIView, placeholder: String, buttonTitle: String, buttonTarget: String){
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
        messageTextView.text = placeholder
        placeholderText = placeholder
        messageTextView.keyboardAppearance = UIKeyboardAppearance.alert
        messageTextView.autocorrectionType = UITextAutocorrectionType.no
        messageTextView.selectedTextRange = messageTextView.textRange(from: messageTextView.beginningOfDocument, to: messageTextView.beginningOfDocument)
        messageTextView.becomeFirstResponder()
        messageView.addSubview(messageTextView)
        
        //This changes the size of the messageTextView and message view (and below the messageButton) to the size needed to fit the placeholder text.
        updateMessageHeights()
        
        //setting the button for sending/posting messages
        messageButton.frame = CGRect(x: 0.75*messageView.frame.width, y: 0.1*messageView.frame.height, width: 0.2*messageView.frame.width, height: 0.8*messageView.frame.height)
        messageButton.frame.size.height = messageTextView.frame.height
        messageButton.frame.origin.y = messageTextView.frame.origin.y
        messageButton.setTitle(buttonTitle, for: .normal)
        messageButton.setTitleColor(DisplayUtility.necterYellow, for: .normal)
        messageButton.setTitleColor(DisplayUtility.necterGray, for: .disabled)
        messageButton.titleLabel?.textAlignment = NSTextAlignment.right
        messageButton.titleLabel!.font = UIFont(name: "Verdana", size: 16)
        messageButton.layer.borderWidth = 2
        messageButton.layer.borderColor = UIColor.white.cgColor
        messageButton.layer.cornerRadius = 5
        target = buttonTarget
        messageButton.addTarget(self, action: #selector(messageButtonTapped(_:)), for: .touchUpInside)
        messageButton.isEnabled = false
        messageView.addSubview(messageButton)
    }
    
    func resign() {
        messageTextView.resignFirstResponder()
        messageView.frame.origin.y = DisplayUtility.screenHeight - messageView.frame.height
        //messageView.removeFromSuperview()
    }
    
    func updatePostType(updatedPostType: String){
        type = updatedPostType
            //setting the placeholder based on whether an option is selected
            if type != "All Types" {
                messageTextView.isUserInteractionEnabled = true
                //if !messageTextView.isFirstResponder {
                //    messageTextView.becomeFirstResponder()
                //}
                    //setting the placeholder
                if messageTextView.textColor == UIColor.white && !updatedText.isEmpty {
                    messageButton.isEnabled = true
                }
            } else {
                //no filter is selected
                messageTextView.isUserInteractionEnabled = false
                //if messageTextView.isFirstResponder {
                 //   messageTextView.resignFirstResponder()
                //}
                messageButton.isEnabled = false
        }
    }
    
    func height() -> CGFloat {
        return keyboardHeight + messageView.frame.height
    }
    
    @objc func messageButtonTapped(_ sender: UIButton) {
        if target == "postStatus" {
            postStatus()
        } else if target == "sendMessage" {
            print("sendMessage")
        } else if target == "bridgeUsers" {
            bridgeUsers()
        }
        print("messageButtonTapped")
    }
    
    func bridgeUsers() {
        print("BridgeUsers")
    }
    func postStatus() {
        //setting the status to local data
        let localData = LocalData()
        if type == "Business" {
            localData.setBusinessStatus(self.messageTextView.text!)
            localData.synchronize()
        } else if type == "Love" {
            localData.setLoveStatus(self.messageTextView.text!)
            localData.synchronize()
        } else if type == "Friendship" {
            localData.setFriendshipStatus(self.messageTextView.text!)
            localData.synchronize()
        }
        
        //saving the status to the database
        let bridgeStatusObject = PFObject(className: "BridgeStatus")
        bridgeStatusObject["bridge_status"] = self.messageTextView.text!
        bridgeStatusObject["bridge_type"] = self.type
        bridgeStatusObject["userId"] = PFUser.current()?.objectId
        bridgeStatusObject.saveInBackground { (success, error) in
            
            
            if error != nil {
                //sends notification to call displayMessageFromBot function
                let userInfo = ["message" : "Your post did not go through. Please wait a minute and try posting again"]
                NotificationCenter.default.post(name: Notification.Name(rawValue: "displayMessageFromBot"), object: nil, userInfo: userInfo)
            } else if success {
                //sends notification to call displayMessageFromBot function
                let userInfo = ["message" : "Your post is now being shown to friends so they can connect you!"]
                NotificationCenter.default.post(name: Notification.Name(rawValue: "displayMessageFromBot"), object: nil, userInfo: userInfo)
            }
        }
        let pfCloudFunctions = PFCloudFunctions()
        pfCloudFunctions.changeBridgePairingsOnStatusUpdate(parameters: ["status":self.messageTextView.text!, "bridgeType":self.type])
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //Combine the textView text and the replacement text to create the updated text string
        let currentText:NSString = textView.text as NSString
        updatedText = currentText.replacingCharacters(in: range, with: text)
        
        //If updated text view will be empty, add the placeholder and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            //setting the placeholder
            messageTextView.text = placeholderText
            textView.textColor = UIColor.lightGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            updateMessageHeights()
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
    
    //Changing the height of the messageTextView and messageView based on the content.
    func textViewDidChange(_ textView: UITextView) {
        updateMessageHeights()
        //need to retrieve the chracter limit from the page the user is on, if there is one and pass it through as a parameter for the characterLimit function
        characterLimit()
    }
    
    func characterLimit() {
        //need to retrieve the chracter limit from the page the user is on, if there is on.
        print(maxNumCharacters)
        //stopping user from entering bridge status with more than a certain number of characters
        if let characterCount = messageTextView.text?.characters.count {
            if characterCount > maxNumCharacters {
                let aboveMaxBy = characterCount - maxNumCharacters
                let index1 = messageTextView.text!.characters.index(messageTextView.text!.endIndex, offsetBy: -aboveMaxBy)
                messageTextView.text = messageTextView.text!.substring(to: index1)
            }
        }
    }
    
    func updateMessageHeights() {
        //changing the height of the messageText based on the content
        let messageTextFixedWidth = messageTextView.frame.size.width
        let messageTextNewSize = messageTextView.sizeThatFits(CGSize(width: messageTextFixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var messageTextNewFrame = messageTextView.frame
        messageTextNewFrame.size = CGSize(width: max(messageTextNewSize.width, messageTextFixedWidth), height: messageTextNewSize.height)
        
        let messageViewFixedHeight = 0.89*DisplayUtility.screenHeight-keyboardHeight
        
        
        if messageViewFixedHeight < messageTextNewFrame.size.height + 8.5 {
            
            print("reached the navBar")
            messageTextView.isScrollEnabled = true
            //messageText.frame.size.height = previousMessageHeight
            //toolbar.frame.size.height = previousToolbarHeight
        } else {
            
            messageTextView.frame = messageTextNewFrame
            
            //changing the height of the messageView based on the content
            let previousMessageViewHeight = messageView.frame.height
            let newMessageViewHeight = messageTextNewFrame.size.height + 8.5
            let changeInMessageViewHeight = newMessageViewHeight - previousMessageViewHeight
            let messageViewFixedWidth = messageView.frame.size.width
            
            //toolbar.sizeThatFits(CGSize(width: toolbarFixedWidth, height: toolbarFixedHeight))
            let messageViewNewSize = messageView.sizeThatFits(CGSize(width: messageViewFixedWidth, height: messageViewFixedHeight))
            var messageViewNewFrame = messageView.frame
            messageViewNewFrame.size = CGSize(width: max(messageViewNewSize.width, messageViewFixedWidth), height: min(messageTextNewFrame.size.height + 8.5, messageViewFixedHeight))
            messageViewNewFrame.origin.y = messageView.frame.origin.y - changeInMessageViewHeight
            //if the toolbar has grown to the size where it is just below the navigation bar then enable the textView to scroll
            messageView.frame = messageViewNewFrame
        }
        
        if messageTextView.text.isEmpty {
            //setting the placeholder
            messageTextView.text = placeholderText
            messageTextView.textColor = UIColor.lightGray
            messageTextView.selectedTextRange = messageTextView.textRange(from: messageTextView.beginningOfDocument, to: messageTextView.beginningOfDocument)
            messageButton.isEnabled = false
        } else if messageTextView.text != placeholderText{
            //removing the placeholder
            messageTextView.textColor = UIColor.white
            messageButton.isEnabled = true
        }
    }
    
}
