//
//  MessagesTableDataSource.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 2/24/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class MessagesTableDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    let messagesBackend: MessagesBackend
    
    init(messagesBackend: MessagesBackend) {
        self.messagesBackend = messagesBackend
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MessagesTableCell()
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
}
