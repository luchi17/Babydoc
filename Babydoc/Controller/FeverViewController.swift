//
//  FeverViewController.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 21/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import UIKit
import RealmSwift
import Charts
import ScrollableDatepicker
import SwipeCellKit

class FeverViewController : UIViewController{
    

    var realm = try! Realm()
    var listOfFever : Results<Fever>?
    var registeredBabies : Results<Baby>?
    var babyApp = Baby()
    let greenDarkColor = UIColor.init(hexString: "33BE8F")
    let greenLightColor = UIColor.init(hexString: "14E19C")
    let font = UIFont(name: "Avenir-Heavy", size: 17)
    let fontLittle = UIFont(name: "Avenir-Medium", size: 17)
    let grayColor = UIColor.init(hexString: "555555")
    let grayLightColor = UIColor.init(hexString: "7F8484")
    var defaultOptions = SwipeOptions()
    
    var feverToEdit = Fever()
    var _dateFormatter: DateFormatter?
    
    var formatter2: DateFormatter {
        if (_dateFormatter == nil) {
            _dateFormatter = DateFormatter()
            _dateFormatter!.locale = Locale(identifier: "en_US_POSIX")
            _dateFormatter!.dateFormat = "HH:mm"
        }
        return _dateFormatter!
    }
    
    var _dateFormatter2: DateFormatter?
    
    var formatter: DateFormatter {
        if (_dateFormatter2 == nil) {
            _dateFormatter2 = DateFormatter()
            _dateFormatter2!.locale = Locale(identifier: "en_US_POSIX")
            _dateFormatter2!.dateFormat = "dd MMMM yyyy"
        }
        return _dateFormatter2!
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
            
            configuration.selectedDayStyle.selectorColor = greenLightColor
            configuration.selectedDayStyle.dateTextColor = greenLightColor
            configuration.selectedDayStyle.weekDayTextColor = greenLightColor
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
    
    override func willMove(toParent parent: UIViewController?) {
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "64C5CF")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {

        self.navigationController?.navigationBar.barTintColor = greenLightColor
        self.navigationController?.navigationBar.backgroundColor = greenLightColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        loadBabiesAndFever(selectedDate: datePicker.selectedDate ?? Date())
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
            
            if self.babyApp.name.isEmpty && self.registeredBabies!.count > 0{
                
                let controller = UIAlertController(title: nil, message: "There are no active babys in Babydoc", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Ok", style: .default)
                
                controller.setTitle(font: self.font!, color: self.grayColor!)
                controller.setMessage(font: self.fontLittle!, color: self.grayLightColor!)
                controller.addAction(action)
                controller.show(animated: true, vibrate: false, style: .light, completion: nil)
                
                
            }
            else if self.babyApp.name.isEmpty && self.registeredBabies!.count == 0{
                
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
    func loadBabiesAndFever(selectedDate : Date){
        
      babyApp = Baby()
      feverToEdit = Fever()
      registeredBabies = realm.objects(Baby.self)
        
        if registeredBabies?.count != 0 {
            for baby in registeredBabies!{
                if baby.current{
                    babyApp = baby
                }
            }
            

        }
        if !babyApp.name.isEmpty{
           listOfFever = babyApp.fever.filter("date.day == %@ AND date.month == %@ AND date.year == %@", selectedDate.day, selectedDate.month, selectedDate.year).sorted(byKeyPath: "generalDate", ascending: false)
           
        }
        tableView.reloadData()
        

    }
    
    func deleteFever(fever : Fever){
        do{
            try realm.write {
                realm.delete(fever)
                
            }
           
            feverToEdit = Fever()
        }
        catch{
            print(error)
        }
        loadBabiesAndFever(selectedDate: datePicker.selectedDate ?? Date())
    }
    

}

//MARK: - ScrollableDatePicker method
extension FeverViewController: ScrollableDatepickerDelegate {
    
    func datepicker(_ datepicker: ScrollableDatepicker, didSelectDate date: Date) {
        
        self.showSelectedDate()
        
         loadBabiesAndFever(selectedDate: date)
        
    }
    func showSelectedDate() {
        guard datePicker.selectedDate != nil else {
            return
        }
        
        
    }

}

//MARK: TableView Method
extension FeverViewController: UITableViewDelegate, UITableViewDataSource{
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "feverCell", for: indexPath) as! CustomCellFever
        cell.delegate = self

        if registeredBabies!.count == 0  || listOfFever?.count == 0{
            cell.temperature.text = ""
            cell.place.text = ""
            cell.time.text = ""
        }
        
        else if babyApp.name.isEmpty && self.registeredBabies!.count > 0{
            cell.temperature.text = ""
            cell.place.text = ""
            cell.time.text = ""
            
        }
        else{
            cell.temperature.text = "Temperature: \(listOfFever?[indexPath.row].temperature ?? Float(0.0)) ºC"
            cell.time.text = "Time: \(formatter2.string(from:(listOfFever?[indexPath.row].generalDate)!))"
            cell.place.text = "Place of measurement: " + (listOfFever?[indexPath.row].placeOfMeasurement)!
        }


        return cell
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if registeredBabies?.count == 0 || babyApp.name.isEmpty{
            return 1
        }
        else if listOfFever?.count != 0 && !babyApp.name.isEmpty{
            return listOfFever?.count ?? 1
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
        return 99
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? SaveFeverViewController{
          
            
            if feverToEdit.temperature == Float(0.0){
                destinationVC.feverToSave = feverToEdit
                destinationVC.feverToEdit = feverToEdit
            }
            else{ 
                destinationVC.feverToEdit = feverToEdit

            }

        }
        
    }
    
    
}


//MARK: SwipeTableView Delegate Method
extension FeverViewController : SwipeTableViewCellDelegate{

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {

        
        defaultOptions.transitionStyle = .drag

        if orientation == .right{

            let removeSwipe = SwipeAction(style: .default, title: nil){ action , indexPath in

                let alert = UIAlertController(title: "Remove Dose", message: "Are you sure you want to remove this dose permanently?", preferredStyle: .alert)

                let removeAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (alertAction) in
                    
                   
                    self.deleteFever(fever: self.listOfFever![indexPath.row])

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

            feverToEdit = listOfFever![indexPath.row]
            return [removeSwipe]


        }
        else{


            let editSwipeAction = SwipeAction(style: .default, title: nil) { action, indexPath in

                self.feverToEdit = self.listOfFever![indexPath.row]
                self.performSegue(withIdentifier: "goToEdit", sender: self.self)
            }
            editSwipeAction.image = UIImage(named: "editt")
            editSwipeAction.hidesWhenSelected = true

            
            return [editSwipeAction]

        }
        
        
        
        

    }



}



