//
//  FormInputCell.swift
//  Tab Splitter
//
//  Created by Joseph Schwarz on 3/28/21.
//

import UIKit

class FormInputCell: UITableViewCell {
    
    @IBOutlet weak var inputField: UITextField!
    
    var onChange: ((_ value: String) -> Void)?
    
    func configure(value: String, onChange: @escaping (_ value: String) -> Void) {
        self.onChange = onChange
        self.inputField.text = value
        self.inputField.addTarget(self, action: #selector(handleEditingChanged), for: .editingChanged)
    }
    
    @objc func handleEditingChanged(_ inputField: UITextField) {
        self.onChange?(inputField.text ?? "")
    }
}
