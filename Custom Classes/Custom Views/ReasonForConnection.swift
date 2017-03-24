//
//  ReasonForConnection.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 11/14/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class ReasonForConnection: UIView, UITextViewDelegate {
    
    let placeholderText = "Enter Message"
    let placeholderTextColor = Constants.Colors.necter.textGray
    var updatedText = ""
    let sendButton = UIButton()
    
    init(user1Name: String?, user2Name: String?) {
        super.init(frame: CGRect())
        
        self.backgroundColor = Constants.Colors.necter.backgroundGray
        self.layer.cornerRadius = 8
        self.layer.borderColor = Constants.Colors.necter.textDarkGray.cgColor //DisplayUtility.gradientColor(size: self.frame.size).cgColor
        self.layer.borderWidth = 3
        self.clipsToBounds = true
        
        let reasonForConnectionLabel = UILabel()
        
        if let name1 = user1Name, let name2 = user2Name {
            if let firstName1 = name1.components(separatedBy: " ").first, let firstName2 = name2.components(separatedBy: " ").first {
                reasonForConnectionLabel.text = "This message sends to \(firstName1) and \(firstName2)'s conversation."
            }
        } else {
            reasonForConnectionLabel.text = "This message sends to your friends' conversation."
        }
        
        reasonForConnectionLabel.font = Constants.Fonts.bold16
        reasonForConnectionLabel.numberOfLines = 0
        reasonForConnectionLabel.textColor = Constants.Colors.necter.textDarkGray
        reasonForConnectionLabel.textAlignment = NSTextAlignment.center
        addSubview(reasonForConnectionLabel)
        reasonForConnectionLabel.autoPinEdgesToSuperviewEdges(with: .init(top: 10, left: 10, bottom: 10, right: 10), excludingEdge: .bottom)
        reasonForConnectionLabel.autoSetDimension(.height, toSize: 60)
        
        let dividerLine = UIView()
        dividerLine.backgroundColor = Constants.Colors.necter.textDarkGray
        dividerLine.autoSetDimension(.height, toSize: 3)
        addSubview(dividerLine)
        dividerLine.autoPinEdge(toSuperviewEdge: .left)
        dividerLine.autoPinEdge(toSuperviewEdge: .right)
        dividerLine.autoPinEdge(.top, to: .bottom, of: reasonForConnectionLabel)
        
        let midDivider = UIView()
        midDivider.backgroundColor = Constants.Colors.necter.textDarkGray
        addSubview(midDivider)
        midDivider.autoPinEdge(toSuperviewEdge: .bottom)
        midDivider.autoAlignAxis(toSuperviewAxis: .vertical)
        midDivider.autoSetDimension(.width, toSize: 3)
        
        let cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(Constants.Colors.necter.textDarkGray, for: .normal)
        cancelButton.titleLabel?.font = Constants.Fonts.bold16
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        addSubview(cancelButton)
        cancelButton.autoPinEdge(toSuperviewEdge: .left)
        cancelButton.autoPinEdge(toSuperviewEdge: .bottom)
        cancelButton.autoSetDimension(.height, toSize: 40)
        cancelButton.autoPinEdge(.right, to: .left, of: midDivider)
        
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(Constants.Colors.necter.textGray, for: .normal)
        sendButton.setTitleColor(Constants.Colors.necter.yellow, for: .selected)
        sendButton.titleLabel?.font = Constants.Fonts.bold16
        sendButton.addTarget(self, action: #selector(sendButtonTapped(_:)), for: .touchUpInside)
        sendButton.isEnabled = false
        sendButton.isSelected = false
        
        addSubview(sendButton)
        sendButton.autoPinEdge(toSuperviewEdge: .right)
        sendButton.autoPinEdge(toSuperviewEdge: .bottom)
        sendButton.autoSetDimension(.height, toSize: 40)
        sendButton.autoPinEdge(.left, to: .right, of: midDivider)
        
        midDivider.autoPinEdge(.top, to: .top, of: sendButton)
        
        let dividerLine2 = UIView()
        dividerLine2.backgroundColor = Constants.Colors.necter.textDarkGray
        addSubview(dividerLine2)
        dividerLine2.autoSetDimension(.height, toSize: 3)
        dividerLine2.autoPinEdge(toSuperviewEdge: .left)
        dividerLine2.autoPinEdge(toSuperviewEdge: .right)
        dividerLine2.autoPinEdge(.bottom, to: .top, of: midDivider)
        
        let reasonForConnectionTextView = UITextView()
        reasonForConnectionTextView.delegate = self
        reasonForConnectionTextView.text = placeholderText
        reasonForConnectionTextView.textColor = placeholderTextColor
        reasonForConnectionTextView.selectedTextRange = reasonForConnectionTextView.textRange(from: reasonForConnectionTextView.beginningOfDocument, to: reasonForConnectionTextView.beginningOfDocument)
        reasonForConnectionTextView.font = Constants.Fonts.light14
        reasonForConnectionTextView.textContainerInset.left = 10
        reasonForConnectionTextView.textContainerInset.right = 10
        addSubview(reasonForConnectionTextView)
        reasonForConnectionTextView.autoPinEdge(.top, to: .bottom, of: dividerLine)
        reasonForConnectionTextView.autoPinEdge(.bottom, to: .top, of: dividerLine2)
        reasonForConnectionTextView.autoPinEdge(toSuperviewEdge: .left)
        reasonForConnectionTextView.autoPinEdge(toSuperviewEdge: .right)
        reasonForConnectionTextView.becomeFirstResponder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cancelButtonTapped(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    func sendButtonTapped(_ sender: UIButton) {
        print("Add sending of the message as a notificatio")
        self.removeFromSuperview()
    }
    
    // Update placeholder and sendButton enablement upon typing
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        
        //Combine the textView text and the replacement text to create the updated text string
        let currentText:NSString = textView.text as NSString
        updatedText = currentText.replacingCharacters(in: range, with: text)
        
        //If updated text view will be empty, add the placeholder and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            //setting the placeholder
            textView.text = placeholderText
            textView.textColor = placeholderTextColor
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            sendButton.isEnabled = false
            sendButton.isSelected = false
            //sendButton.backgroundColor = UIColor.white
            
            return false
        }
            // else if the text view's placeholder is showing and the length of the replacement string is greater than 0, clear the text veiw and set the color to white to prepare for entry
        else if textView.textColor == placeholderTextColor && !updatedText.isEmpty && updatedText != placeholderText {
            textView.text = nil
            textView.textColor = UIColor.black //Constants.Colors.necter.textDarkGray
            sendButton.isEnabled = true
            sendButton.isSelected = true
            //sendButton.backgroundColor = DisplayUtility.gradientColor(size: sendButton.frame.size)
        }
        
        return true
    }
    
    // When placeholder is set, don't allow user to move cursor from beginning of textView
    func textViewDidChangeSelection(_ textView: UITextView) {
        if sendButton.isSelected == false {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
    }
    
}
