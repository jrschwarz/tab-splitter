//
//  TabItemViewController.swift
//  Tab Splitter
//
//  Created by Joseph Schwarz on 4/2/21.
//

import UIKit

class TabItemViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var tab: Tab!
    var tabItem: TabItem!
    var fields: [Field] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fields = [
            SingleField(name: "Name", value: tabItem.name),
            SingleField(name: "Cost", value: String(tabItem.cost)),
            SelectField(name: "People", values: tab.people)
        ]
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

// MARK: UITableViewDataSource
extension TabItemViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fields.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.fields[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        if self.fields[section] is SingleField {
            return 1
        }
        
        if let selectField = self.fields[section] as? SelectField {
            return selectField.values.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let field = self.fields[indexPath.section]
        
        if let singleField = field as? SingleField {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FormInputCell") as! FormInputCell
            cell.configure(value: singleField.value, onChange: { singleField.setValue($0) })
            return cell
        }
        
        if let selectField = field as? SelectField {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FormSelectCell")!
            cell.textLabel?.text = selectField.values[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
    }
}

// MARK: UITableViewDelegate
extension TabItemViewController: UITableViewDelegate { }
