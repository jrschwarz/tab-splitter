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
    var tab: Tab!
    var tabItem: TabItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewForm = TableViewForm(tableView: tableView)
        
        tableViewForm.addSections(sections: [
            TableViewFormSectionStatic(name: "item", title: nil, fields: [
                TableViewFormInput(name: "name", placeholder: "Name", value: tabItem.name),
                TableViewFormInput(name: "cost", placeholder: "Cost", value: tabItem.cost != 0 ? String(tabItem.cost) : nil)
            ]),
            
            TableViewFormSectionSelectable(name: "people", title: nil, values: tabItem.people)
        ])
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
