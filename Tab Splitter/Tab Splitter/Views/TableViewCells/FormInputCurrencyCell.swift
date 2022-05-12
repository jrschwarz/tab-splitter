//
//  FormInputCurrencyCell.swift
//  Tab Splitter
//
//  Created by Joseph Schwarz on 5/11/22.
//

import UIKit

class FormInputCurrencyCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var inputField: UITextField!
    
    var currency = "$"
    var onChange: ((_ value: String) -> Void)?
    
    func configure(value: String, onChange: @escaping (_ value: String) -> Void) {
        self.onChange = onChange
        self.inputField.text = formatInitalValue(value)
        self.inputField.placeholder = "\(self.currency)0"
        self.inputField.textAlignment = .right
        self.inputField.addTarget(self, action: #selector(handleEditingChanged), for: .editingChanged)
    }
    
    func formatInitalValue(_ value: String) -> String {
        if (!value.isEmpty) {
            let numberValue = (Float(value) ?? 0)
            let twoPointPrecision = String(format: "%.2f", numberValue)
            return format(twoPointPrecision)
        }
        
        return format(value)
    }
    
    func format(_ value: String) -> String {
        if value.isEmpty || value == self.currency { return "" }
        if value.contains(self.currency) { return value }
        return "\(self.currency)\(value)"
    }
    
    @objc func handleEditingChanged(_ inputField: UITextField) {
        inputField.text = format(inputField.text ?? "")
        
        // strip currency symbol
        var value = (inputField.text ?? "")
        value = value.replacingOccurrences(of: self.currency, with: "")
        self.onChange?(value)
    }
}
