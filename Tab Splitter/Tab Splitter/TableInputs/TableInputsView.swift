//
//  TableInputsAdderViewController.swift
//  Tab Splitter
//
//  Created by Joseph Schwarz on 3/28/21.
//

import UIKit

class TableInputsView: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var superView: UIView?
    var tableView: UITableView
    var heightConstraint: NSLayoutConstraint
    let tableRowHeight: CGFloat = 43
    
    var items: [String?] = [nil]
    
    var addRowIndex: Int {
        get { return items.count - 1 }
    }
    
    var addLabel: String = "Add"
    
    init(superView: UIView?, tableView: UITableView) {
        self.superView = superView
        self.tableView = tableView

        let initialHeight = CGFloat(items.count) * tableRowHeight
        heightConstraint = tableView.heightAnchor.constraint(equalToConstant: initialHeight)
        
        super.init()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isEditing = true
        tableView.rowHeight = tableRowHeight
        tableView.isScrollEnabled = false
        heightConstraint.isActive = true
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
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableInputCell") as! TableInputCell
            cell.input.text = items[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            updateHeightAnimation(duration: 0)
        }
        
        if editingStyle == .insert {
            let insertAt = items.count - 1
            let itemNum = items.count
            items.insert("Person \(itemNum)", at: insertAt)
            updateHeightAnimation(duration: 0.3)
            tableView.insertRows(at: [IndexPath(row: insertAt, section: 0)], with: .bottom)
        }
    }
    
    func updateHeightAnimation(duration: TimeInterval = 0.3) {
        let newHeight = CGFloat(items.count) * tableView.rowHeight
        UIView.animate(withDuration: duration, animations: {
            self.heightConstraint.constant = newHeight
            self.superView?.layoutIfNeeded()
        })
    }
}
