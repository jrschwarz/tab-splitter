//
//  AddTabViewController.swift
//  Tab Splitter
//
//  Created by Joseph Schwarz on 3/25/21.
//

import UIKit

class AddTabViewController: UIViewController {
    
    @IBOutlet var peopleInputsTableView: UITableView!
    
    var name: String = ""
    var peopleInputsTable: TableInputsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        peopleInputsTable = TableInputsView(superView: view, tableView: peopleInputsTableView)
        peopleInputsTable.addLabel = "Add person"
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onNameChanged(_ sender: UITextField) {
        name = sender.text ?? ""
        print("name: \(name)")
    }
}
