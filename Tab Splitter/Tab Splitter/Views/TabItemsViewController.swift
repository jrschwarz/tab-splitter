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
    var tab: Tab!
    
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
    
    func updateTab() {
        tab.items = tabItems
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "TabItemSegue":
            let vc = segue.destination as! TabItemViewController
            vc.tab = self.tab
            vc.tabItem = TabItem()
        default:
            preconditionFailure("Unexpected segue")
        }
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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateTab()
        let nav = navigationController
        let vc = nav!.viewControllers[nav!.viewControllers.count - 1] as! TabFormViewController
        vc.tab = tab
    }
}
