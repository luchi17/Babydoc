//
//  File.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 09/04/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//


import UIKit
//import RealmSwift
import ChameleonFramework
import AUPickerCell


class DoctorViewController : UITableViewController, AUPickerCellDelegate{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = AUPickerCell(type: .default, reuseIdentifier: "PickerDefaultCell")
            cell.delegate = self
            cell.separatorInset = UIEdgeInsets.zero
            cell.values = ["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"]
            cell.selectedRow = 2
            cell.leftLabel.text = "Testing Strings"
            cell.leftLabel.textColor = UIColor.lightText
            cell.rightLabel.textColor = UIColor.darkText
            cell.tintColor = #colorLiteral(red: 0.9382581115, green: 0.8733785748, blue: 0.684623003, alpha: 1)
            cell.backgroundColor = #colorLiteral(red: 0.6344745755, green: 0.5274511576, blue: 0.4317585826, alpha: 1)
            return cell
        } else {
            let cell = AUPickerCell(type: .date, reuseIdentifier: "PickerDateCell")
            cell.delegate = self
            cell.separatorInset = UIEdgeInsets.zero
            cell.datePickerMode = .time
            cell.timeZone = TimeZone(abbreviation: "UTC")
            cell.dateStyle = .none
            cell.timeStyle = .short
            cell.leftLabel.text = "Testing Dates"
            cell.leftLabel.textColor = UIColor.lightText
            cell.rightLabel.textColor = UIColor.darkText
            cell.tintColor = #colorLiteral(red: 0.9382581115, green: 0.8733785748, blue: 0.684623003, alpha: 1)
            cell.backgroundColor = #colorLiteral(red: 0.6344745755, green: 0.5274511576, blue: 0.4317585826, alpha: 1)
            cell.separatorHeight = 1
            cell.unexpandedHeight = 100
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cell = tableView.cellForRow(at: indexPath) as? AUPickerCell {
            return cell.height
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? AUPickerCell {
            cell.selectedInTableView(tableView)
        }
    }
    
    func auPickerCell(_ cell: AUPickerCell, didPick row: Int, value: Any) {
        print(value)
    }

}

