//
//  Tab.swift
//  Tab Splitter
//
//  Created by Joseph Schwarz on 3/25/21.
//

import Foundation

struct Tab {
    var name: String = ""
    var date: Date = Date()
    var subtotal: Float = 0
    var tax: Float = 0
    var fees: [Float] = []
    var discounts: [Float] = []
    var people: [String] = []
    var items: [TabItem] = []
    
    var total: Float {
        get { return tax + subtotal }
    }
}

extension Tab {
    init(name: String) {
        self.name = name
    }
}
