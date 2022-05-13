//
//  TabItemFormViewController.swift
//  Tab Splitter
//
//  Created by Joseph Schwarz on 4/2/21.
//

import UIKit

class TabItemFormViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var tab: Tab!
    var tabItem: TabItem!
    var delegate: TabItemReceivable!
    
    // Form fields
    var fields: [Field] = []
    var nameField = SingleField(name: "Name")
    var costField = SingleField(name: "Cost")
    var peopleField = SelectField(name: "People")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fields = [
            nameField,
            costField,
            peopleField
        ]
        
        // Init fields
        nameField.value = tabItem.name
        costField.value = String(tabItem.cost)
        peopleField.values = tab.people
        peopleField.selected = Dictionary(
            uniqueKeysWithValues:
                tab.people
                .enumerated()
                .map({ (index, element) in
                    return (index, tabItem.people.contains(element))
                })
        )
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        self.tabItem.name = nameField.value
        self.tabItem.cost = Float(costField.value) ?? 0
        self.tabItem.people = peopleField.values
            .enumerated()
            .filter({ peopleField.isSelected($0.offset) })
            .map({ $0.element })
        
        self.delegate.receive(tabItem: self.tabItem)
        dismiss(animated: true)
    }
    
    func isCurrencyField(field: Field) -> Bool {
        return field.name == costField.name
    }
}

// MARK: UITableViewDataSource
extension TabItemFormViewController: UITableViewDataSource {
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
            if isCurrencyField(field: singleField) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FormInputCurrencyCell") as! FormInputCurrencyCell
                cell.configure(value: singleField.value, onChange: { singleField.setValue($0) })
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "FormInputCell") as! FormInputCell
            cell.configure(value: singleField.value, onChange: { singleField.setValue($0) })
            return cell
        }
        
        if let selectField = field as? SelectField {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FormSelectCell")!
            cell.textLabel?.text = selectField.values[indexPath.row]
            cell.accessoryType = selectField.isSelected(indexPath.row) ? .checkmark : .none
            return cell
        }
        
        return UITableViewCell()
    }
}

// MARK: UITableViewDelegate
extension TabItemFormViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectField = self.fields[indexPath.section] as? SelectField {
            selectField.toggleSelected(indexPath.row)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}
