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
    var messageButton = UIButton()
    var type = String()
    var placeholderText = "Enter Text Here"
    var target = String()
    var maxNumCharacters = Int.max
    var currentView = UIView()
    var currentViewController = UIViewController()
    
    var updatedText = String()
    
    //setting the height of the keyboard
    var keyboardHeight = CGFloat()
    
    func display (view: UIView, placeholder: String, buttonTitle: String, buttonTarget: String){
        print("Called Display CUSTOM KEYBOARD")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        currentView = view
        
        messageView.frame = CGRect(x: 0, y: 0.925*DisplayUtility.screenHeight, width: DisplayUtility.screenWidth, height: 0.075*DisplayUtility.screenHeight)
        let displayUtility = DisplayUtility()
        displayUtility.setBlurredView(viewToBlur: messageView)
        currentView.addSubview(messageView)
        messageView.bringSubview(toFront: currentView)
        
        //setting the textView for writing messages
        messageTextView.delegate = self
        messageTextView.frame = CGRect(x: 0.05*messageView.frame.width, y: 0.1*messageView.frame.height, width: 0.65*messageView.frame.width, height: 0.8*messageView.frame.height)
        messageTextView.layer.borderWidth = 1
        messageTextView.layer.borderColor = UIColor.white.cgColor
        messageTextView.layer.cornerRadius = 7
        messageTextView.textColor = UIColor.lightGray
        messageTextView.font = UIFont(name: "BentonSans-light", size: 18)
        messageTextView.backgroundColor = DisplayUtility.necterGray
        messageTextView.text = placeholder
        placeholderText = placeholder
        messageTextView.keyboardAppearance = UIKeyboardAppearance.alert
        messageTextView.autocorrectionType = UITextAutocorrectionType.no
        messageTextView.selectedTextRange = messageTextView.textRange(from: messageTextView.beginningOfDocument, to: messageTextView.beginningOfDocument)
        //messageTextView.becomeFirstResponder()
        messageTextView.isScrollEnabled = false
        messageTextView.keyboardDismissMode = .interactive
        messageView.addSubview(messageTextView)
    
        //This changes the size of the messageTextView and message view (and below the messageButton) to the size needed to fit the placeholder text.
        updateMessageHeights()
        
        //setting the button for sending/posting messages
        let messageButtonFrame = CGRect(x: 0.75*messageView.frame.width, y: messageTextView.frame.origin.y, width: 0.2*messageView.frame.width, height: messageTextView.frame.height)
        messageButton = DisplayUtility.gradientButton(text: buttonTitle, frame: messageButtonFrame)
        target = buttonTarget
        messageButton.addTarget(self, action: #selector(messageButtonTapped(_:)), for: .touchUpInside)
        messageButton.isEnabled = false
        messageView.addSubview(messageButton)
        messageButton.bringSubview(toFront: messageView)
        
    }
    
    func resign() {
        messageTextView.resignFirstResponder()
        messageView.frame.origin.y = DisplayUtility.screenHeight - messageView.frame.height
        //messageView.removeFromSuperview()
    }
    
    func remove() {
        messageTextView.resignFirstResponder()
        messageView.frame.origin.y = DisplayUtility.screenHeight
        messageView.removeFromSuperview()
    }
    
    func updateMessageEnablement(updatedPostType: String){
        print("updatePostType")
        type = updatedPostType
        //setting the placeholder based on whether an option is selected
        if type != "All Types" {
            if messageTextView.textColor == UIColor.white && !messageTextView.text.isEmpty {
                print("setting enabled to true")
                messageButton.isEnabled = true
                messageButton.isSelected = true
                
            } else if messageTextView.textColor == UIColor.lightGray && target == "postStatus" {
                messageButton.isEnabled = false
                messageButton.isSelected = false
                setRequestForType(filterType: updatedPostType)
                updateMessageHeights()
            } else {
                messageButton.isEnabled = false
                messageButton.isSelected = false
            }
        } else {
            if messageTextView.textColor == UIColor.lightGray && target == "postStatus" {
                messageButton.isEnabled = false
                messageButton.isSelected = false
                setRequestForType(filterType: updatedPostType)
            } else {
                messageButton.isEnabled = false
                messageButton.isSelected = false
            }

        }
    }
    
    func height() -> CGFloat {
        return keyboardHeight + messageView.frame.height
    }
    func getCurrentViewController(vc: UIViewController) {
        currentViewController = vc
    }
    
    @objc func messageButtonTapped(_ sender: UIButton) {
        print("messageButtonTapped")
        let dbSavingFunctions = DBSavingFunctions()
        if let messageText = messageTextView.text {
            if target == "postStatus" {
                print("post button was clicked")
                messageTextView.text = ""
                updatePlaceholder()
                /*if let bridgeVC = currentViewController as? BridgeViewController {
                } else if let messagesVC = currentViewController as? MessagesViewController {
                }*/
                if let missionControlView = currentView as? MissionControlView {
                    missionControlView.close()
                    print("missioncontrol view is the current View")
                }
                dbSavingFunctions.postStatus(messageText: messageText, type: type)

            } else if target == "sendMessage" {
                dbSavingFunctions.sendMessage(messageText: messageText)
            } else if target == "bridgeUsers" {
                //Update CheckedOut and Bridged to true, set user1_response and user2_response to zero, and add connecter_name, connecter_objectId, connecter_profile_picture_url, reason_for_connection, predicted_bridge_type, bridge_type  to the BridgePairings table as the current user's information, selected button, and messageTextView.text
                dbSavingFunctions.bridgeUsers(messageText: messageText, type: type)
                
                //Dismiss the Reason For Connections View
                currentView.removeFromSuperview()
                if let bridgeVC = currentViewController as? BridgeViewController {
                    bridgeVC.reasonForConnectionSent()
                }
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        //Combine the textView text and the replacement text to create the updated text string
        let currentText:NSString = textView.text as NSString
        updatedText = currentText.replacingCharacters(in: range, with: text)

        //On the Reason For Connection Page -> return button closes the keyboard instead of adding lines.
        if target == "bridgeUsers" && (text == "\n") {
            textView.resignFirstResponder()
            updatedText = updatedText.trimmingCharacters(in: .newlines)
        } else if target == "postStatus" && text == "\n" {
            updatedText = updatedText.trimmingCharacters(in: .newlines)
        }
        
        //If updated text view will be empty, add the placeholder and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            //setting the placeholder
            messageTextView.text = placeholderText
            messageTextView.textColor = UIColor.lightGray
            messageTextView.selectedTextRange = messageTextView.textRange(from: messageTextView.beginningOfDocument, to: messageTextView.beginningOfDocument)
            updateMessageHeights()
            messageButton.isEnabled = false
            messageButton.isSelected = false
            print("set placeholder")
            
            //if messageTextView is empty, the circles should be deselected
            if target == "bridgeUsers" {
                let reasonForConnectionView = currentView as! ReasonForConnection
                reasonForConnectionView.deselectCircles()
            }
            
            
            return false
        }
            // else if the text view's placeholder is showing and the length of the replacement string is greater than 0, clear the text veiw and set the color to white to prepare for entry
        else if messageTextView.textColor == UIColor.lightGray && !updatedText.isEmpty && updatedText != placeholderText {
            messageTextView.text = nil
            messageTextView.textColor = UIColor.white
            messageButton.isEnabled = true
            messageButton.isSelected = true
        }
        
        return true
        
    }
    
    
    func updatePlaceholder() {
        //If updated text view will be empty, add the placeholder and set the cursor to the beginning of the text view
        if messageTextView.text.isEmpty {
            //setting the placeholder
            messageTextView.text = placeholderText
            messageTextView.textColor = UIColor.lightGray
            messageTextView.selectedTextRange = messageTextView.textRange(from: messageTextView.beginningOfDocument, to: messageTextView.beginningOfDocument)
            updateMessageHeights()
            messageButton.isEnabled = false
            messageButton.isSelected = false
            print("set placeholder")
            
            //if messageTextView is empty, the circles should be deselected
            if target == "bridgeUsers" {
                let reasonForConnectionView = currentView as! ReasonForConnection
                reasonForConnectionView.deselectCircles()
            }
        }
            // else if the text view's placeholder is showing and the length of the replacement string is greater than 0, clear the text veiw and set the color to white to prepare for entry
        else if messageTextView.textColor == UIColor.lightGray && !messageTextView.text.isEmpty && messageTextView.text != placeholderText {
            messageTextView.textColor = UIColor.white
            messageTextView.selectedTextRange = messageTextView.textRange(from: messageTextView.endOfDocument, to: messageTextView.endOfDocument)
            messageButton.isEnabled = true
            messageButton.isSelected = true
            print("set no placeholder")
        }
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
        if (((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            messageView.frame.origin.y = DisplayUtility.screenHeight - messageView.frame.height
            print("keyboard will hide")
        } else {
            
        }
    }
    
    //Changing the height of the messageTextView and messageView based on the content.
    func textViewDidChange(_ textView: UITextView) {
        updateMessageHeights()
        //need to retrieve the chracter limit from the page the user is on, if there is one and pass it through as a parameter for the characterLimit function
        characterLimit()
        print("textViewDidChange")
        print(currentView)
        print(currentView.superview)
        if let missionCV = currentView.superview as? MissionControlView {
            print("got into Mission ControlView as the current view")
            let type = missionCV.whichFilter()
            updateMessageEnablement(updatedPostType: type)
        }
    }
    
    func characterLimit() {
        //need to retrieve the chracter limit from the page the user is on, if there is on.
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
        
        //stops the growing of the messagesView and messagesTextView when the User reaches the max
        if messageViewFixedHeight < messageTextNewFrame.size.height + 8.5 {
            messageTextView.isScrollEnabled = true
        } else {
            
            messageTextView.frame = messageTextNewFrame
            
            //changing the height of the messageView based on the content
            let previousMessageViewHeight = messageView.frame.height
            let newMessageViewHeight = messageTextNewFrame.size.height + 8.5
            let changeInMessageViewHeight = newMessageViewHeight - previousMessageViewHeight
            let messageViewFixedWidth = messageView.frame.size.width
            
            let messageViewNewSize = messageView.sizeThatFits(CGSize(width: messageViewFixedWidth, height: messageViewFixedHeight))
            var messageViewNewFrame = messageView.frame
            messageViewNewFrame.size = CGSize(width: max(messageViewNewSize.width, messageViewFixedWidth), height: min(messageTextNewFrame.size.height + 8.5, messageViewFixedHeight))
            messageViewNewFrame.origin.y = messageView.frame.origin.y - changeInMessageViewHeight
            
            //if the toolbar has grown to the size where it is just below the navigation bar then enable the textView to scroll
            messageView.frame = messageViewNewFrame
            
            //MessageButton to stay in place as messageView height changes
            let previousMessagButtonY = messageButton.frame.origin.y
            messageButton.frame.origin.y = previousMessagButtonY + changeInMessageViewHeight
        }
    }
    
    /*//Gesture Recognition for messageView to Pull down with Keyboard
    func drag(gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            let tabTranslation = gestureRecognizer.translation(in: messageView)
            gestureRecognizer.view?.center = CGPoint(x: (gestureRecognizer.view?.center.x)!, y: max(0.85*DisplayUtility.screenWidth,(gestureRecognizer.view?.center.y)! + tabTranslation.y))
            gestureRecognizer.setTranslation(CGPoint.zero, in: messageView)
           
        } else if gestureRecognizer.state == .ended {
            
        }
    }*/
    
    //getting status from the currentUser's most recent status
    func setRequestForType(filterType: String) {
        var necterStatusForType = "I am looking for..."
        let type = filterType
        print("type - \(type)")
        let localData = LocalData()
        if type == "Business" {
            if let status = localData.getBusinessStatus() {
                necterStatusForType = status
                messageTextView.text = "Current Request: \(necterStatusForType)"
            } else {
                //query for current user in userId, limit to 1, and find most recently posted "Business" bridge_type
                let query: PFQuery = PFQuery(className: "BridgeStatus")
                query.whereKey("userId", equalTo: (PFUser.current()?.objectId)!)
                query.whereKey("bridge_type", equalTo: "Business")
                query.order(byDescending: "createdAt")
                query.limit = 1
                do {
                    print("getting business objects")
                    let objects = try query.findObjects()
                    for object in objects {
                        necterStatusForType = object["bridge_status"] as! String
                        messageTextView.text = "Current Request: \(necterStatusForType)"
                        localData.setBusinessStatus(necterStatusForType)
                    }
                } catch {
                    print("Error in catch getting status")
                }
            }
            updateMessageHeights()
        } else if type == "Love" {
            if let status = localData.getLoveStatus() {
                necterStatusForType = status
                messageTextView.text = "Current Request: \(necterStatusForType)"
            } else {
                //query for current user in userId, limit to 1, and find most recently posted "Business" bridge_type
                let query: PFQuery = PFQuery(className: "BridgeStatus")
                query.whereKey("userId", equalTo: (PFUser.current()?.objectId)!)
                query.whereKey("bridge_type", equalTo: "Love")
                query.order(byDescending: "createdAt")
                query.limit = 1
                do {
                    let objects = try query.findObjects()
                    for object in objects {
                        necterStatusForType = object["bridge_status"] as! String
                        messageTextView.text = "Current Request: \(necterStatusForType)"
                        localData.setLoveStatus(necterStatusForType)
                    }
                } catch {
                    print("Error in catch getting status")
                }
            }
            updateMessageHeights()
        } else if type == "Friendship" {
            if let status = localData.getFriendshipStatus() {
                necterStatusForType = status
                messageTextView.text = "Current Request: \(necterStatusForType)"
            } else {
                //query for current user in userId, limit to 1, and find most recently posted "Business" bridge_type
                let query: PFQuery = PFQuery(className: "BridgeStatus")
                query.whereKey("userId", equalTo: (PFUser.current()?.objectId)!)
                query.whereKey("bridge_type", equalTo: "Friendship")
                query.order(byDescending: "createdAt")
                query.limit = 1
                do {
                    let objects = try query.findObjects()
                    for object in objects {
                        necterStatusForType = object["bridge_status"] as! String
                        messageTextView.text = "Current Request: \(necterStatusForType)"
                        localData.setFriendshipStatus(necterStatusForType)
                    }
                } catch {
                    print("Error in catch getting status")
                }
            }
            updateMessageHeights()
        } else {
            messageTextView.text = nil
            updatePlaceholder()
        }
        /*if necterStatusForType != "I am looking for..." {
         print("isFirstPost set to \(isFirstPost)")
         isFirstPost = false
         }*/
    }
    
}
