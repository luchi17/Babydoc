//
//  HistoryGrowthViewController.swift
//  ChilCare
//
//  Created by Luchi Parejo alcazar on 14/06/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import SwipeCellKit
import ScrollableDatepicker

class HistoryGrowthViewController: UIViewController{
    
    let font = UIFont(name: "Avenir-Heavy", size: 17)
    let fontLittle = UIFont(name: "Avenir-Medium", size: 17)
    let grayColor = UIColor.init(hexString: "555555")
    let grayLightColor = UIColor.init(hexString: "7F8484")
    let darkOrangeColor = UIColor.init(hexString: "E67E22")
    let orangeColor = UIColor.init(hexString: "F58806")
    
    var realm = try! Realm()
    var registeredChildren : Results<Child>?
    var growth : Results<Growth>?
    var childApp = Child()
    
    var defaultOptions = SwipeOptions()
    
    var growthToEdit = Growth()
    
    var _dateFormatter2: DateFormatter?
    var formatter2: DateFormatter {
        if (_dateFormatter2 == nil) {
            _dateFormatter2 = DateFormatter()
            _dateFormatter2!.locale = Locale(identifier: "en_US_POSIX")
            _dateFormatter2!.dateFormat = "MM/dd/yyyy HH:mm"
        }
        return _dateFormatter2!
    }
    
    var _dateFormatter: DateFormatter?
    var formatter: DateFormatter {
        if (_dateFormatter == nil) {
            _dateFormatter = DateFormatter()
            _dateFormatter!.locale = Locale(identifier: "en_US_POSIX")
            _dateFormatter!.dateFormat = "dd MMMM yyyy"
        }
        return _dateFormatter!
    }
    
    
    func dateStringFromDate(date: Date) -> String {
        return formatter2.string(from: date)
    }
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var datePicker: ScrollableDatepicker!{
        didSet {
            var dates = [Date]()
            for day in -60...60 {
                dates.append(Date(timeIntervalSinceNow: Double(day * 86400)))
            }
            
            datePicker.dates = dates
            datePicker.selectedDate = Date()
            
            datePicker.delegate = self
            
            var configuration = Configuration()
            
            configuration.defaultDayStyle.dateTextFont = UIFont(name: "Avenir-Medium", size: 20)
            configuration.defaultDayStyle.dateTextColor = UIColor.init(hexString: "7F8484")
            configuration.defaultDayStyle.monthTextColor = UIColor.init(hexString: "7F8484")
            configuration.defaultDayStyle.weekDayTextColor = UIColor.init(hexString: "7F8484")
            configuration.defaultDayStyle.weekDayTextFont = UIFont(name: "Avenir-Medium", size: 8)
            
            configuration.weekendDayStyle.weekDayTextFont = UIFont(name: "Avenir-Heavy", size: 8)
            
            configuration.selectedDayStyle.selectorColor = orangeColor
            configuration.selectedDayStyle.dateTextColor = orangeColor
            configuration.selectedDayStyle.weekDayTextColor = orangeColor
            configuration.selectedDayStyle.dateTextFont = UIFont(name: "Avenir-Heavy", size: 20)
            configuration.selectedDayStyle.backgroundColor = UIColor(white: 0.9, alpha: 0.25)
            
            configuration.daySizeCalculation = .numberOfVisibleItems(5)
            
            datePicker.configuration = configuration
            
        }

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.showSelectedDate()
            self.datePicker.scrollToSelectedDate(animated: false)
            
        }
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.navigationController?.navigationBar.barTintColor = orangeColor
        self.navigationController?.navigationBar.backgroundColor = orangeColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        loadChildrenAndGrowth(selectedDate: datePicker.selectedDate ?? Date())
        
    }
    override func willMove(toParent parent: UIViewController?) {
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "64C5CF")
    }
    //MARK: Data Manipulation
    func loadChildrenAndGrowth(selectedDate : Date){
        
        childApp = Child()
        growthToEdit = Growth()
        registeredChildren = realm.objects(Child.self)
        
        if registeredChildren?.count != 0 {
            for child in registeredChildren!{
                if child.current{
                    childApp = child
                }
            }
            
            
        }
        if !childApp.name.isEmpty{
            growth = childApp.growth.filter("date.day == %@ AND date.month == %@ AND date.year == %@", selectedDate.day, selectedDate.month, selectedDate.year).sorted(byKeyPath: "generalDate", ascending: false)
            
        }
        tableView.reloadData()
        
        
    }
    
    func deleteGrowth(growth : Growth){
        do{
            try realm.write {
                realm.delete(growth)
                
            }
            
            growthToEdit = Growth()
        }
        catch{
            print(error)
        }
        loadChildrenAndGrowth(selectedDate: datePicker.selectedDate ?? Date())
    }
    

    
}
//MARK: - ScrollableDatePicker method
extension HistoryGrowthViewController: ScrollableDatepickerDelegate {
    
    func datepicker(_ datepicker: ScrollableDatepicker, didSelectDate date: Date) {
        
        self.showSelectedDate()
        
        loadChildrenAndGrowth(selectedDate: date)
        
    }
    func showSelectedDate() {
        guard datePicker.selectedDate != nil else {
            return
        }
        
        
    }
    
}
//MARK: TableView Method

extension HistoryGrowthViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "growthCell", for: indexPath) as! GrowthCell
        cell.delegate = self
        
        if registeredChildren!.count == 0  || growth?.count == 0{
            cell.date.text = ""
            cell.weight.text = ""
            cell.height.text = ""
            cell.head.text = ""
        }
            
        else if childApp.name.isEmpty && self.registeredChildren!.count > 0{
            cell.date.text = ""
            cell.weight.text = ""
            cell.height.text = ""
            cell.head.text = ""
            
        }
        else{
            cell.date.text = "Date: \(formatter2.string(from:(growth?[indexPath.row].generalDate)!))"
            cell.weight.text = "Weight: \(growth?[indexPath.row].weight ?? Float(0.0)) kg"
            cell.height.text = "Height: \(growth?[indexPath.row].height ?? Float(0.0)) m"
            cell.head.text = "Head Diameter: \(Int((growth?[indexPath.row].headDiameter)!)) cm"
        }
        
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if registeredChildren?.count == 0 || childApp.name.isEmpty{
            return 1
        }
        else if growth?.count != 0 && !childApp.name.isEmpty{
            return growth?.count ?? 1
        }
        else {
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 133
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return formatter.string(from: datePicker.selectedDate!)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 133
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? SaveGrowthViewController{
            
            
            if growthToEdit.weight == Float(0.0){
                destinationVC.growthToSave = growthToEdit
                destinationVC.growthToEdit = growthToEdit
            }
            else{
                destinationVC.growthToEdit = growthToEdit
                
            }
            
        }
        
    }
    
    
}


//MARK: SwipeTableView Delegate Method
extension HistoryGrowthViewController : SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        
        defaultOptions.transitionStyle = .drag
        
        guard growth?.count == 0 else{
            if orientation == .right{
                
                let removeSwipe = SwipeAction(style: .default, title: nil){ action , indexPath in
                    
                    let alert = UIAlertController(title: "Remove growth record", message: "Are you sure you want to remove this growth permanently?", preferredStyle: .alert)
                    
                    let removeAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (alertAction) in
                        
                        
                        self.deleteGrowth(growth: self.growth![indexPath.row])
                        
                    })
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) in
                        
                    })
                    
                    alert.setTitle(font: self.font!, color: self.grayColor!)
                    alert.setMessage(font: self.fontLittle!, color: self.grayLightColor!)
                    alert.addAction(removeAction)
                    alert.addAction(cancelAction)
                    alert.show(animated: true, vibrate: false, style: .prominent, completion: nil)
                    
                }
                removeSwipe.image = UIImage(named: "delete-icon")
                removeSwipe.backgroundColor = .red
                removeSwipe.hidesWhenSelected = true
                
                growthToEdit = growth![indexPath.row]
                return [removeSwipe]
                
                
            }
            else{
                
                
                let editSwipeAction = SwipeAction(style: .default, title: nil) { action, indexPath in
                    
                    self.growthToEdit = self.growth![indexPath.row]
                    self.performSegue(withIdentifier: "goToEdit", sender: self.self)
                }
                editSwipeAction.image = UIImage(named: "editt")
                editSwipeAction.hidesWhenSelected = true
                
                
                return [editSwipeAction]
                
            }
        }
       
        
        return nil
    }
    
    
    
}






