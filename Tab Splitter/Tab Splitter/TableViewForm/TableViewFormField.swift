//
//  TableViewFormField.swift
//  Tab Splitter
//
//  Created by Joseph Schwarz on 3/30/21.
//

import Foundation

protocol TableViewFormField {
    var name: String { get set }
}

struct TableViewFormInput: TableViewFormField {
    var name: String
    var placeholder: String?
    var value: String?
}
