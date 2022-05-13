//
//  FormInputCurrencyCell.swift
//  Tab Splitter
//
//  Created by Joseph Schwarz on 5/11/22.
//

import UIKit

class FormInputCurrencyCell: UITableViewCell {
    
    @IBOutlet weak var inputField: UITextField!
    
    var currency = "$"
    var onChange: ((_ value: String) -> Void)?
    
    func configure(value: String, onChange: @escaping (_ value: String) -> Void) {
        self.onChange = onChange
        self.inputField.text = formatInitalValue(value)
        self.inputField.placeholder = "\(self.currency)0"
        self.inputField.addTarget(self, action: #selector(handleEditingChanged), for: .editingChanged)
        self.inputField.addTarget(self, action: #selector(handleEditingDidBegin), for: .editingDidBegin)
        self.inputField.addTarget(self, action: #selector(handleEditingDidEnd), for: .editingDidEnd)
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
    
    func stripCurrency(_ value: String) -> String {
        return value.replacingOccurrences(of: self.currency, with: "")
    }
    
    @objc func handleEditingChanged(_ inputField: UITextField) {
        inputField.text = format(inputField.text ?? "")
        self.onChange?(stripCurrency(inputField.text ?? ""))
    }
    
    @objc func handleEditingDidBegin(_ inputField: UITextField) {
        let isEmpty = inputField.text?.isEmpty ?? true
        if !isEmpty {
            let number = Float(stripCurrency(inputField.text!)) ?? 0
            if number == 0 { inputField.text = "" }
        }
    }
    
    @objc func handleEditingDidEnd(_ inputField: UITextField) {
        let isEmpty = inputField.text?.isEmpty ?? true
        if (isEmpty) { inputField.text = format("0.00") }
    }
}
