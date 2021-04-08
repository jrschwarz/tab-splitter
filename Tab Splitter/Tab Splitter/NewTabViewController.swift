//
//  AddTabViewController.swift
//  Tab Splitter
//
//  Created by Joseph Schwarz on 3/25/21.
//

import UIKit

class NewTabViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var tableViewForm: TableViewForm!
    var tab: Tab = Tab()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewForm = TableViewForm(tableView: tableView)
        
        tableViewForm.addSections(sections: [
            TableViewFormSectionStatic(name: "name", title: nil, fields: [
                TableViewFormInput(name: "name", placeholder: "Name")
            ]),
            TableViewFormSectionStatic(name: "cost", title: nil, fields: [
                TableViewFormInput(name: "subtotal", placeholder: "Subtotal"),
                TableViewFormInput(name: "tax", placeholder: "Tax")
            ]),
            TableViewFormSectionArray(name: "fees", title: nil, label: "Add fee"),
            TableViewFormSectionArray(name: "discounts", title: nil, label: "Add discount"),
            TableViewFormSectionArray(name: "people", title: nil, label: "Add person")
        ])
        
        updateForm()
    }
    
    func updateForm() {
        var nameSection = tableViewForm.getSection(name: "name") as! TableViewFormSectionStatic
        var costSection = tableViewForm.getSection(name: "cost") as! TableViewFormSectionStatic
        var feesSection = tableViewForm.getSection(name: "fees") as! TableViewFormSectionArray
        var discountsSection = tableViewForm.getSection(name: "discounts") as! TableViewFormSectionArray
        var peopleSection = tableViewForm.getSection(name: "people") as! TableViewFormSectionArray
        
        var nameField = (nameSection.getField(name: "name") as! TableViewFormInput)
        var subTotalField = (costSection.getField(name: "subtotal") as! TableViewFormInput)
        var taxField = (costSection.getField(name: "tax") as! TableViewFormInput)
        
        nameField.value = tab.name
        subTotalField.value = tab.subtotal != 0 ? String(tab.subtotal) : nil
        taxField.value = tab.tax != 0 ? String(tab.tax) : nil
        
        nameSection.updateField(name: "name", field: nameField)
        costSection.updateField(name: "subtotal", field: subTotalField)
        costSection.updateField(name: "tax", field: taxField)
        feesSection.values = tab.fees.map { String($0) }
        discountsSection.values = tab.discounts.map { String($0) }
        peopleSection.values = tab.people
        
        tableViewForm.updateSection(name: "name", section: nameSection)
        tableViewForm.updateSection(name: "cost", section: costSection)
        tableViewForm.updateSection(name: "fees", section: feesSection)
        tableViewForm.updateSection(name: "discounts", section: discountsSection)
        tableViewForm.updateSection(name: "people", section: peopleSection)
    }
    
    func updateTab() {
        let nameSection = tableViewForm.getSection(name: "name") as! TableViewFormSectionStatic
        let costSection = tableViewForm.getSection(name: "cost") as! TableViewFormSectionStatic
        let feesSection = tableViewForm.getSection(name: "fees") as! TableViewFormSectionArray
        let discountsSection = tableViewForm.getSection(name: "discounts") as! TableViewFormSectionArray
        let peopleSection = tableViewForm.getSection(name: "people") as! TableViewFormSectionArray
        
        let nameField = (nameSection.getField(name: "name") as! TableViewFormInput)
        let subTotalField = (costSection.getField(name: "subtotal") as! TableViewFormInput)
        let taxField = (costSection.getField(name: "tax") as! TableViewFormInput)
        
        tab.name = nameField.value ?? ""
        tab.subtotal = parseOptionalStringToFloat(value: subTotalField.value)
        tab.tax = parseOptionalStringToFloat(value: taxField.value)
        tab.fees = feesSection.values.map { parseOptionalStringToFloat(value: $0) }
        tab.discounts = discountsSection.values.map { parseOptionalStringToFloat(value: $0) }
        tab.people = peopleSection.values
    }
    
    func parseOptionalStringToFloat(value: String?) -> Float {
        return Float(value ?? "") ?? 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "TabItemsSegue":
            updateTab()
            let vc = segue.destination as! TabItemsViewController
            vc.tab = tab
        default:
            preconditionFailure("Unexpected segue")
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}


