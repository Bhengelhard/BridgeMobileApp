//
//  FilterInfo.swift
//  MyBridgeApp
//
//  Created by Douglas Dolitsky on 12/8/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import Foundation

class FilterInfo {
    let type: String
    var noOfElementsFetched = 0
    var noOfElementsProcessed = 0
    var messagePositionToMessageIdMapping = [Int:String]()
    var totalElements = 0
    
    init(type: String) {
        self.type = type
    }
    
    func reset() {
        noOfElementsFetched = 0
        noOfElementsProcessed = 0
    }
    
    func setTotalElements(_ totalElements: Int) {
        self.totalElements = totalElements
    }
    
    func process() {
        self.noOfElementsProcessed += 1
    }
    
    func fetch(_ noOfElements: Int) {
        self.noOfElementsFetched += noOfElements
    }
}
