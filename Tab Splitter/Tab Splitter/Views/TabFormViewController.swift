//
//  TabFormViewController.swift
//  Tab Splitter
//
//  Created by Joseph Schwarz on 3/25/21.
//

import UIKit

class TabFormViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    // Tab model
    var tab: Tab = Tab()
    
    // Form fields
    var fields: [Field] = []
    var nameField = SingleField(name: "Name")
    var subtotalField = SingleField(name: "Subtotal")
    var taxField = SingleField(name: "Tax")
    var feesField = MultiField(name: "Fees")
    var discountsField = MultiField(name: "Discounts")
    var peopleField = MultiField(name: "People")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fields = [
            nameField,
            subtotalField,
            taxField,
            feesField,
            discountsField,
            peopleField
        ]
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isEditing = true
        tableView.allowsSelectionDuringEditing = true
        tableView.keyboardDismissMode = .onDrag
        tableView.automaticallyAdjustsScrollIndicatorInsets = true
        
        // Observe keyboardWillShow notification to offset tableview
        // to prevent from being hidden from keyboard
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        // Observe keyboardWillHide notification to reset tablview insets
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "TabItemsSegue":
            self.tab.name = self.nameField.value
            self.tab.subtotal = Float(self.subtotalField.value) ?? 0
            self.tab.tax = Float(self.taxField.value) ?? 0
            self.tab.fees = self.feesField.values.map({ Float($0) ?? 0 })
            self.tab.discounts = self.discountsField.values.map({ Float($0) ?? 0 })
            self.tab.people = self.peopleField.values
            
            let vc = segue.destination as! TabItemsViewController
            vc.tab = self.tab
        default:
            preconditionFailure("Unexpected segue")
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

// MARK: UITableViewDataSource
extension TabFormViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fields.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.fields[section] is SingleField {
            return 1
        }
        
        if let field = self.fields[section] as? MultiField {
            // Plus one to account for adder button row
            return field.values.count + 1
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
        
        if let multiField = field as? MultiField {
            // Adder button row
            if indexPath.row == multiField.values.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FormAdderCell")!
                cell.textLabel?.text = "Add"
                return cell
            }
            
            let value = multiField.values[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "FormInputCell") as! FormInputCell
            cell.configure(value: value, onChange: { multiField.setValue(at: indexPath.row, $0) })
            return cell
        }
        
        return UITableViewCell()
    }
}

// MARK: UITableViewDelegate
extension TabFormViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return self.fields[indexPath.section] is MultiField
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.fields[indexPath.section] is MultiField
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if let multiField = self.fields[indexPath.section] as? MultiField {
            // Adder button row
            if indexPath.row == multiField.values.count { return .insert }
            return .delete
        }
        
        return .none
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete { handleCommitDelete(tableView, indexPath: indexPath) }
        if editingStyle == .insert { handleCommitInsert(tableView, indexPath: indexPath) }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.fields[section].name
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let field = self.fields[indexPath.section]
        
        if let multiField = field as? MultiField {
            if indexPath.row == multiField.values.count {
                handleCommitInsert(tableView, indexPath: indexPath)
            }
        }
    }
    
    func handleCommitInsert(_ tableView: UITableView, indexPath: IndexPath) {
        if let multiField = self.fields[indexPath.section] as? MultiField {
            multiField.values.append("")
            let newIndexPath = IndexPath(row: multiField.values.count - 1, section: indexPath.section)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            
            // Focus input of newly inserted cell
            let cell = tableView.cellForRow(at: newIndexPath) as! FormInputCell
            cell.inputField.becomeFirstResponder()
        }
    }
    
    func handleCommitDelete(_ tableView: UITableView, indexPath: IndexPath) {
        if let multiField = self.fields[indexPath.section] as? MultiField {
            multiField.values.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: Keyboard
extension TabFormViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
        if let keyboardSize = (keyboardFrame as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 40, right: 0)
            self.tableView.contentInset = contentInsets
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.contentInset = contentInsets
    }
}

