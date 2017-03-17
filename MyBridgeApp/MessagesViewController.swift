//
//  new_MessagesViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/20/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // "You have no new matches"/"You have no messages"

    // MARK: Global Variables
    let layout = MessagesLayout()
    let transitionManager = TransitionManager()
    let messagesBackend = MessagesBackend()
    let newMatchesTableViewCell = NewMatchesTableViewCell()
    var messageSelectedID = ""
    
    var didSetupConstraints = false
    
    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout.messagesTable.delegate = self
        layout.messagesTable.dataSource = self
        layout.messagesTable.separatorStyle = .none
        
        messagesBackend.reloadMessagesTable(tableView: layout.messagesTable)
        messagesBackend.loadNewMatches(newMatchesTableViewCell: newMatchesTableViewCell)
        //messagesBackend.loadNewMatches(newMatchesView: layout.newMatchesScrollView)
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.white
        
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        didSetupConstraints = layout.initialize(view: view, didSetupConstraints: didSetupConstraints)
        
        super.updateViewConstraints()
    }
    
    // MARK: - tableView Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesBackend.messagePositionToIDMapping.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 100
            //return UITableViewAutomaticDimension
        }
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return newMatchesTableViewCell
        }
        
        let messageIndex = indexPath.row - 1
        
        let cell = MessagesTableCell()
        cell.cellHeight = self.tableView(tableView, heightForRowAt: indexPath)
        messagesBackend.setParticipantsLabel(index: messageIndex, label: cell.participants)
        messagesBackend.setSanpshotLabel(index: messageIndex, textView: cell.messageSnapshot)
        messagesBackend.setProfilePicture(index: messageIndex, imageView: cell.profilePic)
        cell.notificationDot.alpha = 0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let threadVC = ThreadViewController()
        if let messageID = messagesBackend.messagePositionToIDMapping[indexPath.row - 1] {
            //threadVC.setMessageID(messageID: messageID)
            
            self.messageSelectedID = messageID
            
            tableView.deselectRow(at: indexPath, animated: false) // deselect the row
            performSegue(withIdentifier: "showThread", sender: self)
            
//            present(threadVC, animated: true) {
//                
//            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == messagesBackend.messagePositionToIDMapping.count-1 && Int32(messagesBackend.noOfElementsFetched) < messagesBackend.totalElements {
            messagesBackend.refreshMessagesTable(tableView: tableView)
        }
    }
    
    // MARK: - Targets
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination
        let mirror = Mirror(reflecting: vc)
        if mirror.subjectType == ThreadViewController.self {
            if let threadVC = vc as? ThreadViewController {
                threadVC.setMessageID(messageID: messageSelectedID)
            }
            
            self.transitionManager.animationDirection = "Right"
        }
        //vc.transitioningDelegate = self.transitionManager
    }

}
