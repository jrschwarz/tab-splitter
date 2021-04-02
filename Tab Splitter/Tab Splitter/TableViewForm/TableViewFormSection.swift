//
//  TableViewFormSection.swift
//  Tab Splitter
//
//  Created by Joseph Schwarz on 3/30/21.
//

import Foundation

protocol TableViewFormSection {
    var name: String { get set }
    var title: String? { get set }
}

struct TableViewFormSectionStatic: TableViewFormSection {
    var name: String
    var title: String?
    var fields: [TableViewFormField]
    
    init(name: String, title: String?, fields: [TableViewFormField]?) {
        self.name = name
        self.title = title
        self.fields = fields ?? []
    }
}

struct TableViewFormSectionArray: TableViewFormSection {
    var name: String
    var title: String?
    var label: String
    var values: [String] = []
    
    init(name: String, title: String?, label: String) {
        self.name = name
        self.title = title
        self.label = label
    }
}
