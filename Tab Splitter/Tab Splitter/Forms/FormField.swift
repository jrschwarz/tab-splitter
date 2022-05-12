//
//  FormField.swift
//  Tab Splitter
//
//  Created by Joseph Schwarz on 5/11/22.
//

import Foundation

protocol Field {
    var name: String { get set }
}

// MARK: SingleField
final class SingleField: Field {
    var name: String = ""
    var value: String = ""
    
    init(name: String) {
        self.name = name
    }
    
    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
    
    func setValue(_ value: String) {
        self.value = value
    }
    
}

// MARK: MultiField
final class MultiField: Field {
    var name: String
    var values: [String] = []
    
    init(name: String) {
        self.name = name
    }
    
    init(name: String, values: [String]) {
        self.name = name
        self.values = values
    }
    
    func setValue(at index: Int, _ value: String) {
        if index >= 0 && index < self.values.count {
            self.values[index] = value
        }
    }
}

// MARK: SelectField
final class SelectField: Field {
    var name: String
    var values: [String] = []
    var selected: [Int:Bool] = [:]
    
    init(name: String) {
        self.name = name
    }
    
    init(name: String, values: [String]) {
        self.name = name
        self.values = values
    }
    
    func isSelected(_ index: Int) -> Bool {
        return self.selected[index] ?? false
    }
    
    func toggleSelected(_ index: Int) {
        self.selected[index] = !isSelected(index)
    }
}
