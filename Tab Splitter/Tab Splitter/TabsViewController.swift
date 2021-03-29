//
//  ViewController.swift
//  Tab Splitter
//
//  Created by Joseph Schwarz on 3/25/21.
//

import UIKit

class TabsViewController: UITableViewController {
    var tabs = [Tab]()
    
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm/dd/yyy"
        return dateFormatter
    }()
    
    var currencyFormatter: NumberFormatter = {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        return currencyFormatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        tabs.append(contentsOf: [
            Tab(name: "P.F. Changs"),
            Tab(name: "Grand Lux Cafe"),
            Tab(name: "Quarter Deck"),
            Tab(name: "Cheesecake Factory"),
            Tab(name: "Red Lobster"),
            Tab(name: "Olive Garden"),
            Tab(name: "TGI Friday's")
        ])
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TabItemCell") as! TabItemCell
        let tab = tabs[indexPath.row]
        cell.title.text = tab.name
        cell.date.text = dateFormatter.string(from: tab.date)
        cell.total.text = currencyFormatter.string(from: tab.total as NSNumber)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tabs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

