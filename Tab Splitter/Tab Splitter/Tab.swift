//
//  Tab.swift
//  Tab Splitter
//
//  Created by Joseph Schwarz on 3/25/21.
//

import Foundation

struct Tab {
    var name: String
    var date: Date
    var total: Float
    
    init(name: String) {
        self.name = name
        self.date = Date()
        self.total = 0.0
    }
}
