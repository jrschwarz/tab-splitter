//
//  TabItemsViewController.swift
//  Tab Splitter
//
//  Created by Joseph Schwarz on 4/1/21.
//

import UIKit

protocol TabItemReceivable {
    func receive(tabItem: TabItem)
}

class TabItemsViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    var tab: Tab!
    var delegate: TabReceivable!
    
    var currencyFormatter: NumberFormatter = {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        return currencyFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.delegate.receive(tab: self.tab)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "TabItemSegue":
            let vc = segue.destination as! TabItemFormViewController
            vc.tab = self.tab
            vc.tabItem = TabItem(name: "Salmon", cost: 12.0)
            vc.delegate = self
        default:
            preconditionFailure("Unexpected segue")
        }
    }
}

// MARK: TabItemReceivable
extension TabItemsViewController: TabItemReceivable {
    func receive(tabItem: TabItem) {
        self.tab.items.append(tabItem)
        self.tableView.reloadData()
    }
}

// MARK: UITableViewDataSource
extension TabItemsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tab.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tabItem = self.tab.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TabItemCell") as! TabItemCell
        cell.name.text = tabItem.name
        cell.people.text = tabItem.people.joined(separator: ", ")
        cell.cost.text = currencyFormatter.string(from: tabItem.cost as NSNumber)
        return cell
    }
}

// MARK: UITableViewDelegate
extension TabItemsViewController: UITableViewDelegate {}
