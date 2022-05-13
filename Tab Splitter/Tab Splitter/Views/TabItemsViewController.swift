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
    var selectedIndex: Int?
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
        let vc = segue.destination as! TabItemFormViewController
        vc.tab = self.tab
        vc.delegate = self
    
        switch segue.identifier {
        case "TabItemSegueNew":
            vc.tabItem = TabItem()
            if self.selectedIndex != nil {
                self.selectedIndex = nil
            }
            
        case "TabItemSegueEdit":
            if let index = self.selectedIndex {
                vc.tabItem = self.tab.items[index]
            } else {
                vc.tabItem = TabItem()
            }
            
        default:
            preconditionFailure("Unexpected segue")
        }
    }
}

// MARK: TabItemReceivable
extension TabItemsViewController: TabItemReceivable {
    func receive(tabItem: TabItem) {
        if let index = self.selectedIndex {
            self.tab.items[index] = tabItem
        } else if !tabItem.name.isEmpty {
            self.tab.items.append(tabItem)
        }
        
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
extension TabItemsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        self.selectedIndex = indexPath.row
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
