//
//  TabItemViewController.swift
//  Tab Splitter
//
//  Created by Joseph Schwarz on 4/2/21.
//

import UIKit

class TabItemViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var tableViewForm: TableViewForm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewForm = TableViewForm(tableView: tableView)
        
        tableViewForm.addSections(sections: [
            TableViewFormSectionStatic(name: "item", title: nil, fields: [
                TableViewFormInput(name: "name", placeholder: "Name"),
                TableViewFormInput(name: "cost", placeholder: "Cost")
            ]),
            
            TableViewFormSectionSelectable(name: "people", title: nil, values: [
                "Joey",
                "Mykle",
                "Pratik"
            ])
        ])
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
