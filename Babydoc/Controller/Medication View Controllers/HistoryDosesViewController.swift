//
//  HistoryDosesViewController.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 18/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ScrollableDatepicker

class HistoryDosesViewController : UIViewController{
    
    
     let pinkcolor = UIColor.init(hexString: "F97DBE")
     let darkPinkColor = UIColor.init(hexString: "FB569F")
    let font = UIFont(name: "Avenir-Heavy", size: 17)
    let fontLittle = UIFont(name: "Avenir-Medium", size: 17)
    //let fontLittle = UIFont(name: "Avenir-Heavy", size: 16)
    let grayColor = UIColor.init(hexString: "555555")
    let grayLightColor = UIColor.init(hexString: "7F8484")
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
    var _dateFormatter1: DateFormatter?
    var dateFormatter: DateFormatter {
        if (_dateFormatter1 == nil) {
            _dateFormatter1 = DateFormatter()
            _dateFormatter1!.locale = Locale(identifier: "en_US_POSIX")
            _dateFormatter1!.dateFormat = "MM/dd/yyyy HH:mm"
        }
        return _dateFormatter1!
    }
    

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
            
            configuration.selectedDayStyle.selectorColor = pinkcolor
            configuration.selectedDayStyle.dateTextColor = pinkcolor
            configuration.selectedDayStyle.weekDayTextColor = darkPinkColor
            configuration.selectedDayStyle.dateTextFont = UIFont(name: "Avenir-Heavy", size: 20)
            configuration.selectedDayStyle.backgroundColor = UIColor(white: 0.9, alpha: 0.25)
            
            configuration.daySizeCalculation = .numberOfVisibleItems(5)
            
            datePicker.configuration = configuration
            
        }

    }
    
    let realm = try! Realm()
    var doses : Results<MedicationDoseCalculated>?
    var registeredBabies : Results<Baby>?
    var babyApp = Baby()
    var defaultOptions = SwipeOptions()
    var doseToEdit = MedicationDoseCalculated()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
     super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.barTintColor = pinkcolor
        self.navigationController?.navigationBar.backgroundColor = pinkcolor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        loadBabyAndDoses(selectedDate: datePicker.selectedDate ?? Date())
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
            
            if self.babyApp.name.isEmpty && self.registeredBabies!.count > 0{
                
                let controller = UIAlertController(title: "Warning", message: "There are no active babys in Babydoc", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Ok", style: .default)
                
                controller.setTitle(font: self.font!, color: self.grayColor!)
                controller.setMessage(font: self.fontLittle!, color: self.grayLightColor!)
                controller.addAction(action)
                controller.show(animated: true, vibrate: false, style: .light, completion: nil)
                
                
            }
        }
        
    }

    func loadBabyAndDoses(selectedDate : Date){
        
        babyApp = Baby()
        registeredBabies = realm.objects(Baby.self)
       
        if registeredBabies?.count != 0{
            
            for baby in registeredBabies!{
                if baby.current == true{
                    babyApp = baby
                }
            }

           
        }
        if !babyApp.name.isEmpty{
            doses = babyApp.medicationDoses.filter("date.day == %@ AND date.month == %@ AND date.year == %@", selectedDate.day, selectedDate.month, selectedDate.year).sorted(byKeyPath: "generalDate", ascending: false)
            
            tableView.reloadData()

        }
        
            
    }

    
    func deleteDose(dose : MedicationDoseCalculated){
        
        do{
            
            try realm.write {
                realm.delete(dose)
                
            }
        }
        catch{
            print(error)
        }
        loadBabyAndDoses(selectedDate: datePicker.selectedDate ?? Date())
    }


    func dateStringFromDate(date: Date) -> String {
        return dateFormatter.string(from: date)
    }

    func dateFromString(dateString: String) -> Date? {
        return dateFormatter.date(from: dateString)
    }
    
    
  
}

//MARK : SwipeTableView Methods
extension HistoryDosesViewController : SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        doseToEdit = doses![indexPath.row]
        defaultOptions.transitionStyle = .drag
        
        if orientation == .right{
            
            let removeSwipe = SwipeAction(style: .default, title: nil){ action , indexPath in
                
                let alert = UIAlertController(title: "Remove Dose", message: "Are you sure you want to remove this dose permanently?", preferredStyle: .alert)
                
                let removeAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (alertAction) in
                    
                    self.deleteDose(dose: self.doses![indexPath.row])
                    
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
           
            
            return [removeSwipe]
            
            
        }
        else{

            
            let editSwipeAction = SwipeAction(style: .default, title: nil) { action, indexPath in
                
                
                self.performSegue(withIdentifier: "goToEdit", sender: self.self)
            }
            editSwipeAction.image = UIImage(named: "editt")
            editSwipeAction.hidesWhenSelected = true

            
            return [editSwipeAction]
            
        }
        
    }
    
    
    
}
//MARK: - ScrollableDatePicker method
extension HistoryDosesViewController: ScrollableDatepickerDelegate {
    
    func datepicker(_ datepicker: ScrollableDatepicker, didSelectDate date: Date) {
        
        self.showSelectedDate()
        //mostrar info de ese dia
        loadBabyAndDoses(selectedDate: date)
        
    }
    func showSelectedDate() {
        guard datePicker.selectedDate != nil else {
            return
        }
        
        
    }
    
}
 //MARK: Table View methods
extension HistoryDosesViewController : UITableViewDelegate, UITableViewDataSource{
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return formatter.string(from: datePicker.selectedDate!)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 129
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "doseCell", for: indexPath) as! CustomCellHistoryDose
        

        if registeredBabies!.count == 0  || doses?.count == 0{
            cell.nameDose.text = ""
            cell.descriptionDose.text = ""
            cell.descriptionDose2.text = ""
            cell.descriptionDose3.text = ""
        }
            
        else if babyApp.name.isEmpty && self.registeredBabies!.count > 0{
            cell.nameDose.text = ""
            cell.descriptionDose.text = ""
            cell.descriptionDose2.text = ""
            cell.descriptionDose3.text = ""
            
        }
          
        else{
            cell.nameDose.text = (doses?[indexPath.row].parentMedicationName)! + " " + (doses?[indexPath.row].nameType)!
            cell.descriptionDose.text = "Time of administration: \(formatter2.string(from:(doses?[indexPath.row].generalDate)!))" + "\nConcentration: " + "\(doses?[indexPath.row].concentration ?? 0) \(doses?[indexPath.row].concentrationUnit ?? "")"
            cell.descriptionDose2.text = "Weight: " + "\(doses?[indexPath.row].weight ?? Float(0.0)) kg"
            cell.descriptionDose3.text = "Applied dose: " + (doses?[indexPath.row].dose)! + " " + (doses?[indexPath.row].doseUnit)!
        }
        cell.delegate = self
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if registeredBabies?.count == 0 || babyApp.name.isEmpty{
            return 1
        }
        else if doses?.count != 0 && !babyApp.name.isEmpty{
            return doses?.count ?? 1
        }
        else {
            return 1
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? EditDosesViewController{
            destinationVC.doseToEdit = self.doseToEdit
        }
    }
    
}

