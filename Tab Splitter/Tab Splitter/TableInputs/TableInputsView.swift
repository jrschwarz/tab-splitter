//
//  TableInputsAdderViewController.swift
//  Tab Splitter
//
//  Created by Joseph Schwarz on 3/28/21.
//

import UIKit

class TableInputsView: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView
    let tableRowHeight: CGFloat = 43
    
    enum sections: Int {
        case name
        case people
    }
    
    var items: [String?] = [nil]
    
    var addRowIndex: Int {
        get { return items.count - 1 }
    }
    
    var addLabel: String = "Add"
    
    init(tableView: UITableView) {
        self.tableView = tableView
        
        super.init()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isEditing = true
        tableView.rowHeight = tableRowHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.row == addRowIndex {
            return .insert
        } else {
            return .delete
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == addRowIndex {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableAddInputCell")!
            cell.textLabel?.text = addLabel
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableInputCell") as! TableInputCell
            cell.input.text = items[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.items.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
        
        if editingStyle == .insert {
            let insertAt = items.count - 1
            let itemNum = items.count
            self.items.insert("Person \(itemNum)", at: insertAt)
            self.tableView.insertRows(at: [IndexPath(row: insertAt, section: 0)], with: .bottom)
            
        }
    }
}
