//
//  AddTabViewController.swift
//  Tab Splitter
//
//  Created by Joseph Schwarz on 3/25/21.
//

import UIKit

class NewTabViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var tableViewForm: TableViewForm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewForm = TableViewForm(tableView: tableView)
        
        tableViewForm.addSections(sections: [
            TableViewFormSectionStatic(name: "name", title: nil, fields: [
                TableViewFormInput(name: "name", placeholder: "Name")
            ]),
            
            TableViewFormSectionStatic(name: "cost", title: nil, fields: [
                TableViewFormInput(name: "subtotal", placeholder: "Subtotal"),
                TableViewFormInput(name: "tax", placeholder: "Tax")
            ]),
            
            TableViewFormSectionArray(name: "fees", title: nil, label: "Add fee"),
            TableViewFormSectionArray(name: "discounts", title: nil, label: "Add discount"),
            TableViewFormSectionArray(name: "people", title: nil, label: "Add person")
        ])
    }
}
