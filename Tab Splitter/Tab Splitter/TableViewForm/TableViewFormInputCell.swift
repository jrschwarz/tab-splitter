//
//  TableInputCell.swift
//  Tab Splitter
//
//  Created by Joseph Schwarz on 3/28/21.
//

import UIKit

class TableViewFormInputCell: UITableViewCell {
    @IBOutlet var input: UITextField!
    
    func configure(inputField: TableViewFormInput) {
        input.text = inputField.value
        input.placeholder = inputField.placeholder
    }
}
