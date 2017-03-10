//
//  new_MessagesViewController.swift
//  MyBridgeApp
//
//  Created by Blake Engelhard on 2/20/17.
//  Copyright © 2017 BHE Ventures LLC. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    // MARK: Global Variables
    let layout = MessagesLayout()
    let transitionManager = TransitionManager()
    let messagesBackend = MessagesBackend()
    
    var didSetupConstraints = false
    
    // MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesBackend.reloadMessagesTable(tableView: layout.messagesTable)
        messagesBackend.loadNewMatches(newMatchesView: layout.newMatchesScrollView)
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.white
        
        layout.messagesTable.delegate = self
        layout.messagesTable.dataSource = self
        
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
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MessagesTableCell()
        cell.cellHeight = self.tableView(tableView, heightForRowAt: indexPath)
        messagesBackend.setParticipantsLabel(index: indexPath.row, label: cell.participants)
        messagesBackend.setSanpshotLabel(index: indexPath.row, textView: cell.messageSnapshot)
        messagesBackend.setProfilePicture(index: indexPath.row, imageView: cell.profilePic)
        cell.notificationDot.alpha = 0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let threadVC = ThreadViewController()
        if let messageID = messagesBackend.messagePositionToIDMapping[indexPath.row] {
            threadVC.setMessageID(messageID: messageID)
        }
        present(threadVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == messagesBackend.messagePositionToIDMapping.count-1 && Int32(messagesBackend.noOfElementsFetched) < messagesBackend.totalElements {
            messagesBackend.refreshMessagesTable(tableView: tableView)
        }
    }
    
    // MARK: - Targets
    
    
    // MARK: - Navigation
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        let vc = segue.destination
    //        let mirror = Mirror(reflecting: vc)
    //        if mirror.subjectType == LoginViewController.self {
    //            self.transitionManager.animationDirection = "Bottom"
    //        }
    //        //vc.transitioningDelegate = self.transitionManager
    //    }

}
