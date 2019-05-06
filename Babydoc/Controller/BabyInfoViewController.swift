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
    let fontLight = UIFont(name: "Avenir-Medium", size: 17)
    let remainderColor = UIColor.flatYellowDark
    let deleteColor = UIColor.red
    let cancelColor = UIColor.flatSkyBlue
    let greenColor = UIColor.init(hexString: "64C5CF")
    let grayColor = UIColor.init(hexString: "555555")
    
    override func viewDidLoad() {
        super.viewDidLoad()


        tableView.register(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "babyInfoCell")
        propertyDictionaryName = [["name","Name"],["dateOfBirth","Date Of Birth"],["age","Age"], ["weight","Weight"],["height","Height"],["headDiameter","Head Diameter"],["bloodType","Blood Type"],["allergies" , "Allergies"],["illnesses","Illnesses"]]
        
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
    
  



    //MARK: CalculateAge method
    
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
    
    func saveBabyInfo(valueToSave : Any, forkey : String){
        
        do {
            
            try realm.write {
                (self.babyProperties?[0].setValue(valueToSave, forKeyPath: forkey))!
                if forkey == "name"{
                    
                    self.selectedBaby?.parentRegisteredBabies.setValue(valueToSave, forKeyPath: forkey)
                }
            }
            loadProperties()
            if let delegate = self.delegate {
                delegate.loadNewName()
            }
        } catch {
            print("Error saving done status, \(error)")
        }
        
        
        
    }


}
//MARK: SwipeTableViewCell methods
extension BabyInfoViewController : SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        
        defaultOptions.transitionStyle = .drag
        
        var textFieldStore = UITextField()
        var dateOfBirth = Date()
        let cell = tableView.dequeueReusableCell(withIdentifier: "babyInfoCell", for: indexPath) as! TextFieldTableViewCell
        if orientation == .right {
            
            let edit = SwipeAction(style: .default, title: nil){ action , indexPath in
                
                if indexPath.row == 1{
                    
                    let alert = UIAlertController(style: .alert, title: "Select Date Of Birth")
                    let hoursIn13years = 113880
                    let maxDate = Date()
                    let minDate = Calendar.current.date(byAdding: .hour, value: -hoursIn13years, to: maxDate)!
                    
                    alert.setTitle(font: self.font!, color: self.greenColor!)
                    alert.addDatePicker(mode: .date, date: maxDate, minimumDate: minDate, maximumDate: maxDate) { date in
                        dateOfBirth = date
                    }
                    let ok_action = UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                        
                        let dateString = self.dateStringFromDate(date: dateOfBirth)
                        
                        self.saveBabyInfo(valueToSave: dateString, forkey: self.propertyDictionaryName[indexPath.row][0])
                        
                        let age = self.calculateAge(dob: dateString)
                        print("age:\(age)")
                        var finalStringAge = ""
                        if age.year < 1  {
                            if age.month == 0{
                                finalStringAge = String(age.day) + " days"
                            }
                            else{
                                finalStringAge = String(age.month) + " months and " + String(age.day) + " days"
                            }
                            
                        }
                        else if age.year >= 1{
                            finalStringAge = String(age.year) + " years and " + String(age.month) + " months"
                        }
                        self.saveBabyInfo(valueToSave: finalStringAge, forkey: "age")
                        
                        alert.dismiss(animated: true, completion: nil)
                })
                    
                    //let cancel_action = UIAlertAction(title: "Cancel", style: .destructive)
                    alert.addAction(ok_action)
                    alert.addAction(title : "Cancel" , style: .destructive)
                    
                    alert.show()
                }
                else if indexPath.row == 0 || indexPath.row == 7 || indexPath.row == 8{
                    
                    let alert = UIAlertController(style: .alert, title: "Edit "+self.propertyDictionaryName[indexPath.row][0] )
                    let config: TextField.Config = { textField in
                        
                        
                        textField.becomeFirstResponder()
                        textField.textColor = .flatBlackDark
                        textField.font = self.fontLight
                        textField.leftViewPadding = 6
                        textField.borderStyle = .roundedRect
                        textField.backgroundColor = nil
                        textField.keyboardAppearance = .default
                        textField.keyboardType = .default
                        textField.returnKeyType = .done
                        textField.placeholder = "New \(self.propertyDictionaryName[indexPath.row][1])..."
                        textFieldStore = textField
                    }
                    alert.addOneTextField(configuration: config)
                    alert.setTitle(font: self.font!, color: self.greenColor!)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                        
                        self.saveBabyInfo(valueToSave: textFieldStore.text!, forkey: self.propertyDictionaryName[indexPath.row][0])
                        
                        self.navigationItem.title = self.selectedBaby?.name
                    })
                    
                    alert.addAction(okAction)
                    alert.addAction(title: "Cancel" , style : .destructive)
                    alert.show()

                }
                else if indexPath.row == 2{
                    cell.isUserInteractionEnabled = false
                }
                else if indexPath.row == 3
                {
                   
                    let alert = UIAlertController(style: .alert, title: "Select "+self.propertyDictionaryName[indexPath.row][0] , message: nil)
                    alert.setTitle(font: self.font!, color: self.greenColor!)
                    var weight  = Float()
                    var weightUnit = ""
                    var arrayWeight = [String]()
                    let weightValues = stride(from: 0.0, through: 60.0, by: 0.05)
                    for i in weightValues{
                        arrayWeight.append(String(format: "%.2f", i))
                    }
                    
                    let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: Int(3/0.05))
                    alert.addPickerView(values: [arrayWeight, ["kg","lbs"]], initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
                        
                        weight = Float(picker.selectedRow(inComponent: 0)) * Float(0.05)
                        
                        if picker.selectedRow(inComponent: 1) == 0{
                            weightUnit = " kg"
                        }
                        else if picker.selectedRow(inComponent: 1) == 1{
                            weightUnit = " lbs"
                        }

  
                    }
                    let done_action = UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                        
                        let finalStringWeight = String(format : "%.2f",weight) + weightUnit
                        print(finalStringWeight)
                        self.saveBabyInfo(valueToSave: finalStringWeight, forkey: self.propertyDictionaryName[indexPath.row][0])

                    })
                    alert.addAction(done_action)
                    alert.addAction(title: "Cancel" , style : .destructive)
                    alert.show()
                    
                  
                }
                else if indexPath.row == 4 || indexPath.row == 5 {
                    
                    switch indexPath.row{
                    case 4 :
                        let alert = UIAlertController(style: .alert, title: "Select "+self.propertyDictionaryName[indexPath.row][0] , message: nil)
                        alert.setTitle(font: self.font!, color: self.greenColor!)
                        var height  = Float()
                        let heightUnit = " m"
                        var arrayHeight = [String]()
                        let heightValues = stride(from: 0.0, through: 1.7, by: 0.01)
                        for i in heightValues{
                            arrayHeight.append(String(format: "%.2f", i))
                        }
                        let pickerViewSelectedValueHeight: PickerViewViewController.Index = (column: 0, row: Int(0.7/0.01))
                        
                        alert.addPickerView(values: [arrayHeight, [heightUnit]], initialSelection: pickerViewSelectedValueHeight) { vc, picker, index, values in
                            
                            height = Float(picker.selectedRow(inComponent: 0)) * Float(0.01)
                            
                        }
                        let done_action = UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                            
                            let finalStringHeight = String(format : "%.2f",height) + heightUnit
                            
                            self.saveBabyInfo(valueToSave: finalStringHeight, forkey: self.propertyDictionaryName[indexPath.row][0])
                            
                        })
                        alert.addAction(done_action)
                        alert.addAction(title: "Cancel" , style : .destructive)
                        alert.show()
                        
                        
                        
                    case 5 :
                        
                        let alert = UIAlertController(style: .alert, title: "Select "+self.propertyDictionaryName[indexPath.row][0] , message: nil)
                        alert.setTitle(font: self.font!, color: self.greenColor!)
                        let headValues = stride(from: 0.0, through: 25.0, by: 0.01)
                        var head = Float()
                        let headUnit = " cm"
                        var arrayHead = [String]()
                        for i in headValues{
                            arrayHead.append(String(format: "%.2f", i))
                        }
                        let pickerViewSelectedValueHeadDiameter: PickerViewViewController.Index = (column: 0, row: Int(10.0/0.01))
                        alert.addPickerView(values: [arrayHead, [headUnit]], initialSelection: pickerViewSelectedValueHeadDiameter) { vc, picker, index, values in
                            
                            head = Float(picker.selectedRow(inComponent: 0)) * Float(0.01)
                            
                        }
                        let done_action = UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                            
                            let finalStringHeight = String(format : "%.2f",head) + headUnit
                            
                            self.saveBabyInfo(valueToSave: finalStringHeight, forkey: self.propertyDictionaryName[indexPath.row][0])
                            
                        })
                        alert.addAction(done_action)
                        alert.addAction(title: "Cancel" , style : .destructive)
                        alert.show()
                    default:
                        print("saludos")
                        
                        
                    }
                    
                    
                }
                else if indexPath.row == 6{
                    
                    let alert = UIAlertController(style: .alert, title: "Select "+self.propertyDictionaryName[indexPath.row][0] , message: nil)
                    var bloodType = ""
                    var arrayBloodletter = ["0", "A" , "B", "AB"]
                    var arrayBloodSign = ["+","-"]
                    
                    let pickerViewSelectedValueBlood: PickerViewViewController.Index = (column: 0, row: 0)
                    alert.addPickerView(values: [arrayBloodletter, arrayBloodSign], initialSelection: pickerViewSelectedValueBlood) { vc, picker, index, values in
                        
                        bloodType = arrayBloodletter[picker.selectedRow(inComponent: 0)] + arrayBloodSign[picker.selectedRow(inComponent: 1)]
                        
                        
                    }
                    let done_action = UIAlertAction(title: "Done", style: .default, handler: { (alertAction) in
                        
                        self.saveBabyInfo(valueToSave: bloodType, forkey: self.propertyDictionaryName[indexPath.row][0])
                        
                    })
                    alert.setTitle(font: self.font!, color: self.greenColor!)
                    alert.addAction(done_action)
                    alert.addAction(title: "Cancel" , style : .destructive)
                    alert.show()
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
