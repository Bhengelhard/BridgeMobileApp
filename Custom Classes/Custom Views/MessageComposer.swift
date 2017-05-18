//
//  MessageComposeViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 1/13/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit
import MessageUI

class MessageComposer: NSObject, MFMessageComposeViewControllerDelegate {
    
    // A wrapper function to indicate whether or not a text message can be sent from the user's device
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    
    // Configures and returns a MFMessageComposeViewController instance
    func configuredMessageComposeViewController() -> MFMessageComposeViewController {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self  //  Make sure to set this property to self, so that the controller can be dismissed!
        //messageComposeVC.recipients = textMessageRecipients
        messageComposeVC.body = "Hey, are you on necter? It's an app to meet new people. Thought I might intro you to someone.\n\nhttp://download.necter.social?utm_source=app&utm_medium=profile_referral"
        return messageComposeVC
    }
    
    // MFMessageComposeViewControllerDelegate callback - dismisses the view controller when the user is finished with it
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
        if result == .sent {
            let dbSavingFunctions = DBSavingFunctions()
            if let recipients = controller.recipients {
                print(recipients)
                print("--------------")
                dbSavingFunctions.sharedNecter(recipients: recipients)
            } else {
                dbSavingFunctions.sharedNecter(recipients: nil)
                print("didn't get recipients")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
