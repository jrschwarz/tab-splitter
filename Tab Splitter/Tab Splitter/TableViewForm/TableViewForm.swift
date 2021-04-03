//
//  TableViewForm.swift
//  Tab Splitter
//
//  Created by Joseph Schwarz on 3/30/21.
//

import UIKit

class TableViewForm: NSObject {
    
    var tableView: UITableView
    
    private var sections: [TableViewFormSection] = []
    
    private var nextResponderIndexPath: IndexPath?
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isEditing = true
        tableView.allowsSelectionDuringEditing = true
    }
    
    func addSection(section: TableViewFormSection) {
        sections.append(section)
    }
    
    func addSections(sections: [TableViewFormSection]) {
        sections.forEach { addSection(section: $0) }
    }
    
    func removeSection(section: TableViewFormSection) {
        sections.removeAll { $0.name == section.name }
    }
    
    func getSection(name: String) -> TableViewFormSection? {
        return sections.first { $0.name == name } ?? nil
    }
}

extension TableViewForm: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let row = indexPath.row
        
        if let staticSection = section as? TableViewFormSectionStatic {
            let field = staticSection.fields[row]
            
            if let inputField = field as? TableViewFormInput {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TableInputCell") as! TableInputCell
                cell.input.placeholder = inputField.placeholder
                cell.input.text = inputField.value
                if nextResponderIndexPath == indexPath { cell.input.becomeFirstResponder() }
                return cell
            }
        }
        
        if let arraySection = section as? TableViewFormSectionArray {
            if row == arraySection.values.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TableAddInputCell")!
                cell.textLabel?.text = arraySection.label
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TableInputCell") as! TableInputCell
                cell.input.text = arraySection.values[row]
                if nextResponderIndexPath == indexPath { cell.input.becomeFirstResponder() }
                return cell
            }
        }
        
        if let selectableSection = section as? TableViewFormSectionSelectable {
            let isSelected = selectableSection.selected.contains(indexPath.row)
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableSelectableCell")!
            cell.textLabel?.text = selectableSection.values[indexPath.row]
            cell.accessoryType = isSelected ? .checkmark : .none
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let staticSection = sections[section] as? TableViewFormSectionStatic {
            return staticSection.fields.count
        }
        
        if let arraySection = sections[section] as? TableViewFormSectionArray {
            return arraySection.values.count + 1
        }
        
        if let selectableSection = sections[section] as? TableViewFormSectionSelectable {
            return selectableSection.values.count
        }
        
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
}

extension TableViewForm: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        let section = sections[indexPath.section]
        return section is TableViewFormSectionArray
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let section = sections[indexPath.section]
        return section is TableViewFormSectionArray
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if let arraySection = sections[indexPath.section] as? TableViewFormSectionArray {
            if indexPath.row == arraySection.values.count { return .insert }
            else { return .delete }
        }
        
        return .none
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete { handleCommitDelete(tableView, indexPath: indexPath) }
        if editingStyle == .insert { handleCommitInsert(tableView, indexPath: indexPath) }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let section = sections[indexPath.section]
        
        if let arraySection = section as? TableViewFormSectionArray {
            if indexPath.row == arraySection.values.count {
                handleCommitInsert(tableView, indexPath: indexPath)
            }
        }
        
        if section is TableViewFormSectionSelectable {
            handleToggleSelection(tableView, indexPath: indexPath)
        }
    }
    
    func handleCommitInsert(_ tableView: UITableView, indexPath: IndexPath) {
        if var arraySection = sections[indexPath.section] as? TableViewFormSectionArray {
            arraySection.values.append("")
            sections[indexPath.section] = arraySection
            let newIndexPath = IndexPath(row: arraySection.values.count - 1, section: indexPath.section)
            nextResponderIndexPath = newIndexPath
            tableView.insertRows(at: [newIndexPath], with: .bottom)
        }
    }
    
    func handleCommitDelete(_ tableView: UITableView, indexPath: IndexPath) {
        if var arraySection = sections[indexPath.section] as? TableViewFormSectionArray {
            arraySection.values.remove(at: indexPath.row)
            sections[indexPath.section] = arraySection
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func handleToggleSelection(_ tableView: UITableView, indexPath: IndexPath) {
        if var selectableSection = sections[indexPath.section] as? TableViewFormSectionSelectable {
            if selectableSection.selected.contains(indexPath.row) {
                selectableSection.selected.removeAll { $0 == indexPath.row }
            } else {
                selectableSection.selected.append(indexPath.row)
            }
            sections[indexPath.section] = selectableSection
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}
