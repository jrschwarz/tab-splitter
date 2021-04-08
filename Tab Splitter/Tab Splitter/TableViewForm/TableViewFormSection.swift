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
    
    func getField(name: String) -> TableViewFormField? {
        return fields.first { $0.name == name }
    }
    
    mutating func updateField(name: String, field: TableViewFormField) {
        if let index = fields.firstIndex(where: { $0.name == name }) {
            fields[index] = field
        }
    }
}

struct TableViewFormSectionArray: TableViewFormSection {
    var name: String
    var title: String?
    var label: String
    var values: [String] = []
}

struct TableViewFormSectionSelectable: TableViewFormSection {
    var name: String
    var title: String?
    var values: [String] = []
    var selected: [Int] = []
}
