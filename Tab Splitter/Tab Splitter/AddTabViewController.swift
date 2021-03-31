//
//  AddTabViewController.swift
//  Tab Splitter
//
//  Created by Joseph Schwarz on 3/25/21.
//

import UIKit

class AddTabViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var tableViewForm: TableViewForm!
    
    var activeIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewForm = TableViewForm(tableView: tableView)
        
        tableViewForm.addSections(sections: [
            TableViewFormSectionStatic(name: "name", title: nil, fields: [
                TableViewFormInput(name: "name", placeholder: "Name")
            ]),
            
            TableViewFormSectionArray(name: "people", title: nil, label: "Add person")
        ])
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
