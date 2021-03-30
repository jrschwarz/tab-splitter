//
//  AddTabViewController.swift
//  Tab Splitter
//
//  Created by Joseph Schwarz on 3/25/21.
//

import UIKit

class AddTabViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    enum Section: Int, CaseIterable {
        case name
        case people
    }
    
    var sections: [Section:[String?]] = [
        .name: [""],
        .people: [nil]
    ]
    
    var activeIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isEditing = true
        tableView.allowsMultipleSelection = true
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension AddTabViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[Section(rawValue: section)!]!.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Section(rawValue: indexPath.section)!
        
        switch section {
        case .name:
            let value = sections[section]![indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableInputCell") as! TableInputCell
            cell.input.placeholder = "Name"
            cell.input.text = value
            return cell
        case .people:
            let values = sections[section]!
            if (indexPath.row == values.count - 1) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TableAddInputCell")!
                cell.textLabel?.text = "Add person"
                return cell
            } else {
                let value = values[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: "TableInputCell") as! TableInputCell
                cell.input.text = value
                cell.input.placeholder = "Person"
                if activeIndexPath == indexPath {
                    cell.input.becomeFirstResponder()
                    cell.input.selectAll(nil)
                }
                return cell
            }
        }
    }
}

extension AddTabViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let section = Section(rawValue: indexPath.section)!
        
        switch section {
        case .name:
            return .none
        case .people:
            let values = sections[section]!
            if (indexPath.row == values.count - 1) {
                return .insert
            } else {
                return .delete
            }
        }
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        let section = Section(rawValue: indexPath.section)!
        
        switch section {
        case .name:
            return false
        case .people:
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let section = Section(rawValue: indexPath.section)!
        
        if (section == .people) {
            if (editingStyle == .insert) {
                let newIndex = sections[section]!.count - 1
                sections[section]!.insert("Person", at: newIndex)
                activeIndexPath = IndexPath(row: newIndex, section: indexPath.section)
                tableView.insertRows(at: [IndexPath(row: newIndex, section: indexPath.section)], with: .bottom)
            }
            
            if (editingStyle == .delete) {
                sections[section]!.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let section = Section(rawValue: indexPath.section)!
        
        if (section == .people) {
            let newIndex = sections[section]!.count - 1
            sections[section]!.insert("Person", at: newIndex)
            activeIndexPath = IndexPath(row: newIndex, section: indexPath.section)
            tableView.insertRows(at: [IndexPath(row: newIndex, section: indexPath.section)], with: .bottom)
        }
        

    }
}
