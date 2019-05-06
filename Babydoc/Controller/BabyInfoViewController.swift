//
//  BabyInfoViewController.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 29/04/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import PMAlertController
import RLBAlertsPickers


class BabyInfoViewController : UITableViewController{

    var babyProperties : Results<Baby>?
    var realm = try! Realm()
    var propertyDictionaryName = [[String]]()
    var selectedBaby : Baby? {
        didSet{
            loadProperties()
            
        }
    }
    var defaultOptions = SwipeOptions()
    weak var delegate : notifyChangeInName?

    
    let normalColor = UIColor.flatGrayDark
    let font = UIFont(name: "Avenir-Heavy", size: 17)
    let remainderColor = UIColor.flatYellowDark
    let deleteColor = UIColor.red
    let cancelColor = UIColor.flatSkyBlue
    
    override func viewDidLoad() {
        super.viewDidLoad()


        tableView.register(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "babyInfoCell")
        propertyDictionaryName = [["name","Name"],["dateOfBirth","Date of Birth"],["age","Age"], ["height","Height"],["weight","Weight"],["bloodType","Blood Type"],["allergies" , "Allergies"],["illnesses","Illnesses"]]
        
    }
//
//
//    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
//
//       //tableView.isUserInteractionEnabled = true
////        if editingMode == true {
////            // save the data
////            saveBabyInfo(baby : selectedBaby!)
////            editingEnd()
////        } else {
////            editingBegin()
////        }
//
//
//    }
    @objc func saveButtonPressed(){
        if self.selectedBaby != nil{
            saveBabyInfo(baby : selectedBaby!)
            //tableView.isUserInteractionEnabled = false
        }
        else{
            print("unable to save baby")
        }


    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 85.0
        
    }
    


    
    //MARK - Table View Datasource method


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return propertyDictionaryName.count
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cellBabyInfo = tableView.dequeueReusableCell(withIdentifier: "babyInfoCell", for: indexPath) as! TextFieldTableViewCell
        cellBabyInfo.delegate = self as SwipeTableViewCellDelegate
        cellBabyInfo.fieldNameLabel.text! = propertyDictionaryName[indexPath.row][1]
        cellBabyInfo.fieldValue.text = babyProperties?[0].value(forKeyPath: propertyDictionaryName[indexPath.row][0]) as? String
        
        
        return cellBabyInfo
    }
    
  



    //MARK: CalcAge method
    
    
    
    func calcAge(birthday: String) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM/dd/yyyy"
        let birthdayDate = dateFormater.date(from: birthday)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let age = calcAge.year
       
        let finalage = String(describing: age)
        return finalage
    }
    
   var _dateFormatter: DateFormatter?
   var dateFormatter: DateFormatter {
        if (_dateFormatter == nil) {
            _dateFormatter = DateFormatter()
            _dateFormatter!.locale = Locale(identifier: "en_US_POSIX")
            _dateFormatter!.dateFormat = "MM/dd/yyyy"
        }
        return _dateFormatter!
    }
     func dateFromString(dateString: String) -> Date? {
        return dateFormatter.date(from: dateString)
    }
     func dateStringFromDate(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    func calculateAge(dob : String) -> (year :Int, month : Int, day : Int){
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy"
        let date = df.date(from: dob)
        guard let val = date else{
            return (0, 0, 0)
        }
        var years = 0
        var months = 0
        var days = 0
        
        let cal = NSCalendar.current
        years = cal.component(.year, from: NSDate() as Date) -  cal.component(.year, from: val)
        
        let currMonth = cal.component(.month, from: NSDate() as Date)
        let birthMonth = cal.component(.month, from: val)
        
        //get difference between current month and birthMonth
        months = currMonth - birthMonth
        //if month difference is in negative then reduce years by one and calculate the number of months.
        if months < 0
        {
            years = years - 1
            months = 12 - birthMonth + currMonth
            if cal.component(.day, from: NSDate() as Date) < cal.component(.day, from: val){
                months = months - 1
            }
        } else if months == 0 && cal.component(.day, from: NSDate() as Date) < cal.component(.day, from: val)
        {
            years = years - 1
            months = 11
        }
        
        //Calculate the days
        if cal.component(.day, from: NSDate() as Date) > cal.component(.day, from: val){
            days = cal.component(.day, from: NSDate() as Date) - cal.component(.day, from: val)
        }
        else if cal.component(.day, from: NSDate() as Date) < cal.component(.day, from: val)
        {
            let today = cal.component(.day, from: NSDate() as Date)
            let date = cal.date(byAdding: .month, value: -1, to: NSDate() as Date)
            
            days = date!.daysInMonth - cal.component(.day, from: val) + today
        } else
        {
            days = 0
            if months == 12
            {
                years = years + 1
                months = 0
            }
        }
        
        return (years, months, days)
    }

    

  
    
    //MARK: Data Manipulation methods
    
    func loadProperties(){
        babyProperties =  realm.objects(Baby.self).filter( "name == %@",selectedBaby?.name as Any)
        
        tableView.reloadData()
    }
    
    func saveBabyInfo(baby : Baby){
        
        do {
            
            try realm.write {
                //realm.add(baby.self, update: true)
                
            }
        } catch {
            print("Error saving done status, \(error)")
        }
        // tableView.reloadData()
        
        
    }


}
//MARK: SwipeTableViewCell methods
extension BabyInfoViewController : SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        
        defaultOptions.transitionStyle = .drag
        
        var textField = UITextField()
        let cell = tableView.dequeueReusableCell(withIdentifier: "babyInfoCell", for: indexPath) as! TextFieldTableViewCell
        if orientation == .right {
            
            let edit = SwipeAction(style: .default, title: nil){ action , indexPath in
                
                if indexPath.row == 1{
                    let alert = UIAlertController(style: .alert, title: "Select date")
                    let hoursIn13years = 113880
                    let maxDate = Date()
                    let minDate = Calendar.current.date(byAdding: .hour, value: -hoursIn13years, to: maxDate)!

                    alert.addDatePicker(mode: .date, date: maxDate, minimumDate: minDate, maximumDate: maxDate) { date in
                        do{
                            try self.realm.write {
                                let dateString = self.dateStringFromDate(date: date)
                                self.babyProperties?[0].setValue(dateString, forKeyPath: self.propertyDictionaryName[indexPath.row][0])
                                
                               //age
                                let age = self.calculateAge(dob: dateString)
                                print("age:\(age)")
                                var finalStringAge = ""
                                if age.year < 1  {
                                    finalStringAge = String(age.month) + " months and " + String(age.day) + " days"
                                }
                                else if age.year >= 1{
                                    finalStringAge = String(age.year) + " years and " + String(age.month) + " months"
                                }
                                self.babyProperties?[0].setValue(finalStringAge, forKeyPath: "age")
                                
                            }
                            self.loadProperties()
                        }
                        catch{
                            print("UNABLE TO SAVE DATE: \(error)")
                        }
                    }
                    alert.addAction(title: "OK", style: .cancel)
                    alert.addAction(title : "Cancel" , style: .destructive)
                    alert.show()
                }
                else{
                    
                    let alert = PMAlertController(title: nil, description: nil, image: nil, style : .alert)
                    
                    
                    alert.addTextField( { (alertTextField) in
                        
                        alertTextField!.placeholder = "New \(self.propertyDictionaryName[indexPath.row][1])..."
                        textField = alertTextField!
                    })
                    let done_action = PMAlertAction(title: "Done", style: .default, action: { () in
                        
                        cell.fieldValue.text = textField.text!
                        
                        do{
                            try self.realm.write {
                                self.babyProperties?[0].setValue(textField.text!, forKeyPath: self.propertyDictionaryName[indexPath.row][0])
                                self.selectedBaby?.parentRegisteredBabies.setValue(textField.text!, forKeyPath: self.propertyDictionaryName[indexPath.row][0])
                                
                            }
                            self.loadProperties()
                            if let delegate = self.delegate {
                                delegate.loadNewName()
                            }
                            self.navigationItem.title = self.selectedBaby?.name
                            
                            
                        }
                        catch{
                            print("Error saving data: \(error)")
                        }
                    })
                    
                    let cancel_action = PMAlertAction(title: "Cancel", style: .cancel, action: {
                        alert.dismiss(animated: true, completion: nil)
                    })
                    
                    done_action.setTitleColor(self.cancelColor, for: .normal)
                    cancel_action.setTitleColor(self.deleteColor, for: .normal)
                    alert.addAction(done_action)
                    alert.addAction(cancel_action)
                    alert.alertTitle.textColor = self.normalColor
                    alert.alertTitle.font = self.font
                    alert.gravityDismissAnimation = true
                    alert.dismissWithBackgroudTouch = true
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
                
                
                
            }
            //edit.backgroundColor = UIColor.init(hexString: "F8F9F9")?.withAlphaComponent(CGFloat(0.99))
            edit.image = UIImage(named: "editt")
            //edit.image?.
            edit.hidesWhenSelected = true
            
            return [edit]
        }
        else{
            return nil
        }
    }
    
}
protocol notifyChangeInName : class  {
    func loadNewName()
}
extension Date {
    
  
    var daysInMonth:Int{
        let calendar = Calendar.current
        
        let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        return numDays
    }
    
}
