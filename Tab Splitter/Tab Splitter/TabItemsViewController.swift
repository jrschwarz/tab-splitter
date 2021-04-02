//
//  TabItemsViewController.swift
//  Tab Splitter
//
//  Created by Joseph Schwarz on 4/1/21.
//

import UIKit

class TabItemsViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    var tabItems: [TabItem] = []
    
    var currencyFormatter: NumberFormatter = {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        return currencyFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tabItems.append(contentsOf: [
            TabItem(name: "Mac & Cheese", cost: 8.50, people: ["Joey"]),
            TabItem(name: "Ribeye", cost: 21.99, people: ["Mykle"]),
            TabItem(name: "Lobster Tail", cost: 22, people: ["Pratik"]),
            TabItem(name: "Tiramasu", cost: 9.50, people: ["Joey", "Pratik"]),
            TabItem(name: "Moscow Mule", cost: 11.50, people: ["Mykle"]),
            TabItem(name: "Tuna Tartare", cost: 16, people: ["Mykle", "Joey", "Pratik"])
        ])
    }
}

extension TabItemsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tabItem = tabItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TabItemCell") as! TabItemCell
        cell.name.text = tabItem.name
        cell.people.text = tabItem.people.joined(separator: ", ")
        cell.cost.text = currencyFormatter.string(from: tabItem.cost as NSNumber)
        return cell
    }
}

extension TabItemsViewController: UITableViewDelegate {
    
}
