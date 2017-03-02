//
//  MessagesLogic.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 2/24/17.
//  Copyright © 2017 Parse. All rights reserved.
//

class MessagesLogic {
    
    static func filterContentForSearchText(_ searchText:String, messagePositionToIDMapping: [Int: String], messageNames: [String: String], messageSnapshots: [String: String]) -> [Int] {
        var filteredPositions = [Int]()
        for i in 0 ..< messagePositionToIDMapping.count  {
            if let messageID = messagePositionToIDMapping[i] {
                var flag = true
                if let messageName = messageNames[messageID] {
                    if messageName.lowercased().contains(searchText.lowercased()){
                        filteredPositions.append(i)
                        flag = false
                        break
                    }
                }
                
                if flag {
                    if let messageSnapshot = messageSnapshots[messageID] {
                        if messageSnapshot.lowercased().contains(searchText.lowercased()) {
                            filteredPositions.append(i)
                        }
                    }
                }
            }
        }
        return filteredPositions
    }
}
