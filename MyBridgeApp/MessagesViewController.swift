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
    
    var newMatchSelector: Selector?
    
    var didSetupConstraints = false
    
    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout.messagesTable.delegate = self
        layout.messagesTable.dataSource = self
        layout.messagesTable.separatorStyle = .none
        
        messagesBackend.reloadMessagesTable(tableView: layout.messagesTable)
        
        newMatchesTableViewCell.parentVC = self
        newMatchesTableViewCell.tableView = layout.messagesTable
        
        messagesBackend.loadNewMatches(newMatchesTableViewCell: newMatchesTableViewCell)
        
        // Listener for updating inbox when new messages come in
        //        NotificationCenter.default.addObserver(self, selector: #selector(presentThreadVC(_:)), name: NSNotification.Name(rawValue: "pushNotification"), object: nil)
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return messagesBackend.messagePositionToIDMapping.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return newMatchesTableViewCell
        }
        
        let cell = MessagesTableCell()
        cell.cellHeight = self.tableView(tableView, heightForRowAt: indexPath)
        messagesBackend.setParticipantsLabel(index: indexPath.row, label: cell.participants)
        messagesBackend.setSanpshotLabel(index: indexPath.row, textView: cell.messageSnapshot)
        messagesBackend.setProfilePicture(index: indexPath.row, imageView: cell.profilePic)
        messagesBackend.setDotAlpha(index: indexPath.row, dot: cell.notificationDot)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//<<<<<<< HEAD
//        let threadVC = ThreadViewController()
//        if let messageID = messagesBackend.messagePositionToIDMapping[indexPath.row - 1] {
//            //threadVC.setMessageID(messageID: messageID)
//            
//            self.messageSelectedID = messageID
//            
//            tableView.deselectRow(at: indexPath, animated: false) // deselect the row
//            performSegue(withIdentifier: "showThread", sender: self)
//            
////            present(threadVC, animated: true) {
////                
////            }
//=======
        if indexPath.section == 1 {
            if let messageID = messagesBackend.messagePositionToIDMapping[indexPath.row] {
                goToThread(messageID: messageID)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == messagesBackend.messagePositionToIDMapping.count-1 && Int32(messagesBackend.noOfElementsFetched) < messagesBackend.totalElements {
                messagesBackend.refreshMessagesTable(tableView: tableView)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "New Matches"
        }
        
        return "Messages"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            if let backgroundView = view.backgroundView {
                backgroundView.backgroundColor = .white
            }
        }
    }
    
    func goToThread(messageID: String?) {
        let threadVC = ThreadViewController()
        threadVC.setMessageID(messageID: messageID)
        threadVC.messagesBackend = messagesBackend
        threadVC.messagesTableView = layout.messagesTable
        threadVC.newMatchesTableViewCell = newMatchesTableViewCell
        present(threadVC, animated: true, completion: nil)
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
