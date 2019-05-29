//
//  HistorySleepViewController.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 29/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import SwipeCellKit
import ScrollableDatepicker

class HistorySleepViewController: UIViewController{
    
    
    let darkBlueColor = UIColor.init(hexString: "2772DB")
    let blueColor = UIColor.init(hexString: "66ACF8")
    let lightBlueColor = UIColor.init(hexString: "82BAF8")
    let font = UIFont(name: "Avenir-Heavy", size: 17)
    let fontLittle = UIFont(name: "Avenir-Medium", size: 17)
    let grayColor = UIColor.init(hexString: "555555")
    let grayLightColor = UIColor.init(hexString: "7F8484")
    var realm = try! Realm()
    var registeredBabies : Results<Baby>?
    var babyApp : Baby?
    var selectedDay = Date()
    var defaultOptions = SwipeOptions()
    var sleepToEdit = Sleep()
    
    var _dateFormatter2: DateFormatter?
    var formatter: DateFormatter {
        if (_dateFormatter2 == nil) {
            _dateFormatter2 = DateFormatter()
            _dateFormatter2!.locale = Locale(identifier: "en_US_POSIX")
            _dateFormatter2!.dateFormat = "dd MMMM yyyy"
        }
        return _dateFormatter2!
    }
    
    var _dateFormatter : DateFormatter?
    var formatter2: DateFormatter {
        if (_dateFormatter == nil) {
            _dateFormatter = DateFormatter()
            _dateFormatter!.locale = Locale(identifier: "en_US_POSIX")
            _dateFormatter!.dateFormat = "HH:mm"
        }
        return _dateFormatter!
    }
    
    var listOfSleep : Results<Sleep>?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var datePicker: ScrollableDatepicker!{
        didSet {
            var dates = [Date]()
            for day in -15...15 {
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
            
            configuration.selectedDayStyle.selectorColor = blueColor
            configuration.selectedDayStyle.dateTextColor = blueColor
            configuration.selectedDayStyle.weekDayTextColor = blueColor
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
        
        self.navigationController?.navigationBar.barTintColor = blueColor
        self.navigationController?.navigationBar.backgroundColor = blueColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        loadBabiesAndSleep(selectedDate: datePicker.selectedDate ?? Date())
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
            
            if (self.babyApp?.name.isEmpty)! && self.registeredBabies!.count > 0{
                
                let controller = UIAlertController(title: nil, message: "There are no active babys in Babydoc", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Ok", style: .default)
                
                controller.setTitle(font: self.font!, color: self.grayColor!)
                controller.setMessage(font: self.fontLittle!, color: self.grayLightColor!)
                controller.addAction(action)
                controller.show(animated: true, vibrate: false, style: .light, completion: nil)
                
                
            }
            else if (self.babyApp?.name.isEmpty)! && self.registeredBabies!.count == 0{
                
                let controller = UIAlertController(title: nil, message: "There are no registered babys in Babydoc", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Ok", style: .default)
                
                controller.setTitle(font: self.font!, color: self.grayColor!)
                controller.setMessage(font: self.fontLittle!, color: self.grayLightColor!)
                controller.addAction(action)
                controller.show(animated: true, vibrate: false, style: .light, completion: nil)
                
                
            }
        }
        
        
    }
    //MARK: Data Manipulation
    func loadBabiesAndSleep(selectedDate : Date){
        
        babyApp = Baby()
        sleepToEdit = Sleep()
        registeredBabies = realm.objects(Baby.self)
        
        if registeredBabies?.count != 0 {
            for baby in registeredBabies!{
                if baby.current{
                    babyApp = baby
                }
            }
            
            
        }
        if !(babyApp?.name.isEmpty)!{
            listOfSleep = babyApp?.sleeps.filter("dateBegin.day == %@ AND dateBegin.month == %@ AND dateBegin.year == %@", selectedDate.day, selectedDate.month, selectedDate.year).sorted(byKeyPath: "generalDateBegin", ascending: false)
            
        }
        tableView.reloadData()
        
        
    }
    
    func deleteSleep(sleep : Sleep){
        do{
            try realm.write {
                realm.delete(sleep)
                
            }
            
            sleepToEdit = Sleep() 
        }
        catch{
            print(error)
        }
        loadBabiesAndSleep(selectedDate: datePicker.selectedDate ?? Date())
    }
    
    
    
    
    
    
}

//MARK: - ScrollableDatePicker method
extension HistorySleepViewController: ScrollableDatepickerDelegate {
    
    func datepicker(_ datepicker: ScrollableDatepicker, didSelectDate date: Date) {
        
        self.showSelectedDate()
       
        loadBabiesAndSleep(selectedDate: date)
        
    }
    func showSelectedDate() {
        guard datePicker.selectedDate != nil else {
            return
        }
        
        
    }
    
}
//MARK: TableView Method
extension HistorySleepViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "sleepCellHistory", for: indexPath) as! CustomCellHistorySleep
        cell.delegate = self
        
        if registeredBabies!.count == 0  || listOfSleep?.count == 0{
            cell.typeSleep.text = ""
            cell.duration.text = ""
            cell.starttime.text = ""
            cell.endtime.text = ""
        }

        else if (babyApp?.name.isEmpty)! && self.registeredBabies!.count > 0{

            cell.typeSleep.text = ""
            cell.duration.text = ""
            cell.starttime.text = ""
            cell.endtime.text = ""

        }
        else{
            if (listOfSleep?[indexPath.row].nightSleep)!{
                cell.typeSleep.text = "Night-time sleep"
                cell.typeSleep.textColor = darkBlueColor
            }
            else{
                cell.typeSleep.text = "Nap-time sleep"
                cell.typeSleep.textColor = blueColor
            }
            
            let sleepTime = listOfSleep?[indexPath.row].timeSleepFloat
            let integer = floor(Double(sleepTime!))
            let decimal = sleepTime!.truncatingRemainder(dividingBy: 1)
            
            if Int(integer) != 0 && Int(decimal*60) != 0{
                cell.duration.text = "Duration: \(Int(integer))h \(Int(decimal*60))min"
            }
            else if Int(integer) == 0 && Int(decimal*60) != 0{
                cell.duration.text = "Duration: \(Int(decimal*60))min"
            }
            else if Int(integer) != 0 && Int(decimal*60) == 0{
                cell.duration.text = "Duration: \(Int(integer))h"
            }
            
            cell.starttime.text = "Start time: \(formatter2.string(from: (listOfSleep?[indexPath.row].generalDateBegin)!))"
            let formatterFirst = DateFormatter()
            formatterFirst.dateFormat = "dd MMM"
            if (listOfSleep?[indexPath.row].generalDateBegin.day)! < listOfSleep![indexPath.row].generalDateEnd.day {
                
                cell.endtime.text = "End time: \(formatter2.string(from: (listOfSleep?[indexPath.row].generalDateEnd)!))" + ", " + formatterFirst.string(from: (listOfSleep?[indexPath.row].generalDateEnd)!)
            }
            else{
                cell.endtime.text = "End time: \(formatter2.string(from: (listOfSleep?[indexPath.row].generalDateEnd)!))"
            }
            
            
        }
        
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if registeredBabies?.count == 0 || (babyApp?.name.isEmpty)!{
            return 1
        }
        else if listOfSleep?.count != 0 && !(babyApp?.name.isEmpty)!{
            return listOfSleep?.count ?? 1
        }
        else {
            return 1
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        return formatter.string(from: datePicker.selectedDate!)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 127
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? SaveSleepViewController{
            
            
            
            if sleepToEdit.timeSleepFloat == Float(0.0){ 
                destinationVC.sleepToSave = sleepToEdit
                destinationVC.sleepToEdit = sleepToEdit
            }
            else{  //Edit
                destinationVC.sleepToEdit = sleepToEdit
                
            }
            
            
        }
        
    }
    
    
}
//MARK: SwipeTableView Delegate Method
extension HistorySleepViewController : SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        
        defaultOptions.transitionStyle = .drag
        
        if orientation == .right{
            
            let removeSwipe = SwipeAction(style: .default, title: nil){ action , indexPath in
                
                let alert = UIAlertController(title: "Remove Dose", message: "Are you sure you want to remove this sleep record permanently?", preferredStyle: .alert)
                
                let removeAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (alertAction) in
                    
                    
                    self.deleteSleep(sleep: self.listOfSleep![indexPath.row])
                    
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
            
            sleepToEdit = listOfSleep![indexPath.row]
            return [removeSwipe]
            
            
        }
        else{
            
            
            let editSwipeAction = SwipeAction(style: .default, title: nil) { action, indexPath in
                
                self.sleepToEdit = self.listOfSleep![indexPath.row]
                self.performSegue(withIdentifier: "goToEditSleep", sender: self.self)
            }
            editSwipeAction.image = UIImage(named: "editt")
            editSwipeAction.hidesWhenSelected = true
            
            
            return [editSwipeAction]
            
        }
        
        
        
        
        
    }
    
    
    
}




