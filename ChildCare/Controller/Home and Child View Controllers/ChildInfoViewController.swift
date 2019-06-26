//
//  ChildInfoViewController.swift
//  Childcare
//
//  Created by Luchi Parejo alcazar on 29/04/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import PMAlertController
import RLBAlertsPickers


class ChildInfoViewController : UITableViewController{
    
    
    var childProperties : Results<Child>?
    var realm = try! Realm()
    var propertyDictionaryName = [[String]]()
    var selectedChild : Child? {
        didSet{
            loadProperties()
            
        }
    }
    var currentChild = Child()
    var registeredChildren : Results<Child>?
    
    
    var defaultOptions = SwipeOptions()
    weak var delegate : NotifyChangeInNameDelegate?
    weak var delegateCurrentChild : CurrentChildOftheAppDelegate?
    
    
    
    let normalColor = UIColor.flatGrayDark
    let font = UIFont(name: "Avenir-Heavy", size: 17)
    let fontLight = UIFont(name: "Avenir-Medium", size: 17)
    let remainderColor = UIColor.flatYellowDark
    let deleteColor = UIColor.red
    let cancelColor = UIColor.flatSkyBlue
    let greenColor = UIColor.init(hexString: "64C5CF")
    let grayColor = UIColor.init(hexString: "555555")
    let grayLightColor = UIColor.init(hexString: "7F8484")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "childInfoCell")
        propertyDictionaryName = [["name","Name"],["sex", "Sex"],["dateOfBirth","Date Of Birth"],["age","Age"], ["weight","Weight (kg)"],["height","Height (m)"],["headDiameter","Head Diameter (cm)"],["bloodType","Blood Type"],["allergies" , "Allergies"],["illnesses","Illnesses"]]
        

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 85.0
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .always
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
         self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "64C5CF")
        self.navigationController?.navigationBar.backgroundColor = UIColor(hexString: "64C5CF")
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        
    }
    
    
    
    
    //MARK - Table View Datasource method
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return propertyDictionaryName.count
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cellChildInfo = tableView.dequeueReusableCell(withIdentifier: "childInfoCell", for: indexPath) as! TextFieldTableViewCell
        cellChildInfo.delegate = self as SwipeTableViewCellDelegate
        tableView.backgroundColor = UIColor.init(hexString: "F8F9F9")?.withAlphaComponent(CGFloat(0.995))
        cellChildInfo.backgroundColor = UIColor.init(hexString: "F8F9F9")
        cellChildInfo.fieldNameLabel.textColor = UIColor.init(hexString: "64C5CF")
        cellChildInfo.fieldNameLabel.text! = propertyDictionaryName[indexPath.row][1]
        
        if childProperties?[0].value(forKeyPath: propertyDictionaryName[indexPath.row][0]) as? Float == Float(0.0){
            cellChildInfo.fieldValue.text = ""
        }
        else{
            cellChildInfo.fieldValue.text = "\(childProperties?[0].value(forKeyPath: propertyDictionaryName[indexPath.row][0]) ?? "")"
        }
       
        
        
        return cellChildInfo
    }
    
    
    
    //MARK: Data Manipulation methods
    
    func loadProperties(){
        childProperties =  realm.objects(Child.self).filter( "name == %@",selectedChild?.name as Any)
        
        tableView.reloadData()
    }
    
    func saveChildInfo(valueToSave : Any, forkey : String){
        
        do {
            
            try realm.write {
                self.childProperties?[0].setValue(valueToSave, forKeyPath: forkey)
                
                if forkey == "name"{
                    
                    self.selectedChild?.setValue(valueToSave, forKeyPath: forkey)
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
    
    func dateStringFromDate(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    func dateFromString(dateString: String) -> Date? {
        return dateFormatter.date(from: dateString)
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
    func calcDateOfVaccination(doses : List<VaccineDose>){
        
      
        var dateOfDose = Date()
        var dateOfDoseString = ""
        let birthDateString = dateFromString(dateString: selectedChild!.dateOfBirth)
        
        for vaccineDose in doses{
            
            let age = vaccineDose.ageOfVaccination
            let stringArray = age.components(separatedBy: CharacterSet.decimalDigits.inverted)
            for item in stringArray {
                if let number = Int(item){
                    
                    if age.contains("months"){
                        dateOfDose = Calendar.current.date(byAdding: .month, value: number, to: birthDateString!)!
                        dateOfDoseString = dateStringFromDate(date: dateOfDose)
                    }
                    else if age.contains("years"){

                        dateOfDose = Calendar.current.date(byAdding: .year, value: number, to: birthDateString!)!
                        dateOfDoseString = dateStringFromDate(date: dateOfDose)
                    }
                }
                
                
            }
            do{
                try realm.write {
                    
                    vaccineDose.dateOfVaccination = dateOfDoseString
                    
                }
            }
            catch{
                print(error)
            }
            
            
        }
        
        
    }

    
    
    
    
    
}
//MARK: SwipeTableViewCell methods
extension ChildInfoViewController : SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        
        defaultOptions.transitionStyle = .drag
        
        var textFieldStore = UITextField()
        var dateOfBirth = Date()
        let cell = tableView.dequeueReusableCell(withIdentifier: "childInfoCell", for: indexPath) as! TextFieldTableViewCell
        if orientation == .right {
            
            let edit = SwipeAction(style: .default, title: nil){ action , indexPath in
                
                if indexPath.row == 2{
                    
                    let alert = UIAlertController(style: .alert, title: "Select \(self.propertyDictionaryName[indexPath.row][1])")
                    let maxDate = Date()
                    let minDate = Calendar.current.date(byAdding: .year, value: -14, to: maxDate)!
                    
                    alert.setTitle(font: self.font!, color: self.greenColor!)
                    alert.addDatePicker(mode: .date, date: maxDate, minimumDate: minDate, maximumDate: maxDate) { date in
                        dateOfBirth = date
                    }
                    let ok_action = UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                        
                        let dateString = self.dateStringFromDate(date: dateOfBirth)
                        
                        self.saveChildInfo(valueToSave: dateString, forkey: self.propertyDictionaryName[indexPath.row][0])
                        
                        let age = self.calculateAge(dob: dateString)
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
                            
                            if age.month == 0{
                                finalStringAge = String(age.year) + " years"
                            }
                            else{
                                finalStringAge = String(age.year) + " years and " + String(age.month) + " months"
                            }
                            
                        }
                        self.saveChildInfo(valueToSave: finalStringAge, forkey: "age")
                        
                        for vaccine in self.selectedChild!.vaccines{
                            
                            self.calcDateOfVaccination(doses: vaccine.doses)
                        }
                        
                        alert.dismiss(animated: true, completion: nil)
                    })
                    
                    alert.addAction(title : "Cancel" , style: .cancel)
                    alert.addAction(ok_action)
                    alert.show(animated: true, vibrate: false, style: .prominent, completion: nil)
                }
                    
                else if indexPath.row == 0 || indexPath.row == 8 || indexPath.row == 9{
                    
                    let alert = UIAlertController(style: .alert, title: "Edit "+self.propertyDictionaryName[indexPath.row][1] )
                    let config: TextField.Config = { textField in
                        
                        
                        textField.becomeFirstResponder()
                        textField.textColor = self.grayLightColor
                        textField.font = self.fontLight
                        textField.leftViewPadding = 6
                        textField.borderStyle = .roundedRect
                        textField.backgroundColor = nil
                        textField.keyboardAppearance = .default
                        textField.keyboardType = .default
                        textField.returnKeyType = .done
                        textField.placeholder = "new \(self.propertyDictionaryName[indexPath.row][0])..."
                        textFieldStore = textField
                    }
                    alert.addOneTextField(configuration: config)
                    alert.setTitle(font: self.font!, color: self.greenColor!)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                        
                        self.saveChildInfo(valueToSave: textFieldStore.text!, forkey: self.propertyDictionaryName[indexPath.row][0])
                        
                        self.navigationItem.title = self.selectedChild?.name
                    })
                    
                    
                    alert.addAction(title: "Cancel" , style : .cancel)
                    alert.addAction(okAction)
                    alert.show(animated: true, vibrate:false, style: .prominent, completion: nil)
                    
                }
                else if indexPath.row == 1{
                    let alert = UIAlertController(style: .alert, title: "Select "+self.propertyDictionaryName[indexPath.row][0] , message: nil)
                    
                    var sex = ["female", "male"]
                    var selected  = "female"
                    let pickerViewSelectedValueSex: PickerViewViewController.Index = (column: 0, row: 0)
                    
                    selected = "female"
                    alert.addPickerView(values: [sex], initialSelection: pickerViewSelectedValueSex) { vc, picker, index, values in
                        
                        selected = sex[picker.selectedRow(inComponent: 0)]
                        
                        
                    }
                    let done_action = UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                        
                        
                        self.saveChildInfo(valueToSave: selected, forkey: self.propertyDictionaryName[indexPath.row][0])
                        
                    })
                    alert.setTitle(font: self.font!, color: self.greenColor!)
                    alert.addAction(title: "Cancel" , style : .cancel)
                    alert.addAction(done_action)
                    alert.show(animated: true, vibrate: false, style: .prominent, completion: nil)
                }
                else if indexPath.row == 3{
                    cell.isUserInteractionEnabled = false
                    cell.hideSwipe(animated: true)
                    
                }
                else if indexPath.row == 4
                {
                    
                    let alert = UIAlertController(style: .alert, title: "Select "+self.propertyDictionaryName[indexPath.row][0] , message: nil)
                    alert.setTitle(font: self.font!, color: self.greenColor!)
                    var weight  = Float()
                    var arrayWeight = [String]()
                    let weightValues = stride(from: 2.0, through: 60.0, by: 0.05)
                    for i in weightValues{
                        arrayWeight.append(String(format: "%.2f", i))
                    }
                    let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: Int(3/0.05))
           
    
                    weight = Float(3.00)
                   
                    alert.addPickerView(values: [arrayWeight, ["kg"]], initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
                        DispatchQueue.main.async {
                            UIView.animate(withDuration: 1) {
                                
                                weight = Float(picker.selectedRow(inComponent: 0))*Float(0.05)
                                
                                

                            }
                        }

                    }
                    let done_action = UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                        

                        self.saveChildInfo(valueToSave: round((weight*100))/100, forkey: self.propertyDictionaryName[indexPath.row][0])
                        
                    })
                    
                    alert.addAction(title: "Cancel" , style : .cancel)
                    alert.addAction(done_action)
                    alert.show(animated: true, vibrate: false, style: .prominent, completion: nil)
                    
                    
                }
                else if indexPath.row == 5 || indexPath.row == 6 {
                    
                    switch indexPath.row{
                    case 5 :
                        let alert = UIAlertController(style: .alert, title: "Select "+self.propertyDictionaryName[indexPath.row][0] , message: nil)
                        alert.setTitle(font: self.font!, color: self.greenColor!)
                        var height  = Float()
                        var arrayHeight = [String]()
                        let heightValues = stride(from: 0.0, through: 1.7, by: 0.01)
                        for i in heightValues{
                            arrayHeight.append(String(format: "%.2f", i))
                        }
                        let pickerViewSelectedValueHeight: PickerViewViewController.Index = (column: 0, row: Int(0.7/0.01))
                        
                        height = Float(0.7)
                        
                        alert.addPickerView(values: [arrayHeight, ["m"]], initialSelection: pickerViewSelectedValueHeight) { vc, picker, index, values in
                            
                            height = Float(picker.selectedRow(inComponent: 0)) * Float(0.01)
                            
                        }
                        let done_action = UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                            
                            
                            
                            self.saveChildInfo(valueToSave: round((height*100))/100, forkey: self.propertyDictionaryName[indexPath.row][0])
                            
                        })
                        
                        alert.addAction(title: "Cancel" , style : .cancel)
                        alert.addAction(done_action)
                        alert.show(animated: true, vibrate: false, style: .prominent, completion: nil)
                        
                        
                        
                    case 6 :
                        
                        let alert = UIAlertController(style: .alert, title: "Select "+self.propertyDictionaryName[indexPath.row][0] , message: nil)
                        alert.setTitle(font: self.font!, color: self.greenColor!)
                        let headValues = stride(from: 25.0, through: 55.0, by: 0.1)
                        
                        var head = Float()
                        var arrayHead = [String]()
                        for i in headValues{
                            arrayHead.append(String(format: "%.2f", i))
                        }
                        head = Float(35.0)
                        let pickerViewSelectedValueHeadDiameter: PickerViewViewController.Index = (column: 0, row: Int(35.0/0.01))
                        alert.addPickerView(values: [arrayHead, ["cm"]], initialSelection: pickerViewSelectedValueHeadDiameter) { vc, picker, index, values in
                            
                            head = Float(picker.selectedRow(inComponent: 0)) * Float(0.01)
                            
                        }
                        let done_action = UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                            
                            
                            self.saveChildInfo(valueToSave:  round((head*100))/100, forkey: self.propertyDictionaryName[indexPath.row][0])
                            
                        })
                        
                        alert.addAction(title: "Cancel" , style : .cancel)
                        alert.addAction(done_action)
                        alert.show(animated: true, vibrate: false, style: .prominent, completion: nil)
                    default:
                        break
                        
                        
                    }
                    
                    
                }
                else if indexPath.row == 7{
                    
                    let alert = UIAlertController(style: .alert, title: "Select "+self.propertyDictionaryName[indexPath.row][0] , message: nil)
                    var bloodType = ""
                    var arrayBloodletter = ["0", "A" , "B", "AB"]
                    var arrayBloodSign = ["+","-"]
                    
                    let pickerViewSelectedValueBlood: PickerViewViewController.Index = (column: 0, row: 0)
                    
                    bloodType = "0+"
                    alert.addPickerView(values: [arrayBloodletter, arrayBloodSign], initialSelection: pickerViewSelectedValueBlood) { vc, picker, index, values in
                        
                        bloodType = arrayBloodletter[picker.selectedRow(inComponent: 0)] + arrayBloodSign[picker.selectedRow(inComponent: 1)]
                        
                        
                    }
                    let done_action = UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                        
                        self.saveChildInfo(valueToSave: bloodType, forkey: self.propertyDictionaryName[indexPath.row][0])
                        
                    })
                    alert.setTitle(font: self.font!, color: self.greenColor!)
                    alert.addAction(title: "Cancel" , style : .cancel)
                    alert.addAction(done_action)
                    alert.show(animated: true, vibrate: false, style: .prominent, completion: nil)
                }
                
            }
            edit.image = UIImage(named: "editt")
            edit.hidesWhenSelected = true
            
            
            return [edit]
        }
        else{
            return nil
        }
        
    }
    
    
    
}
protocol NotifyChangeInNameDelegate : class  {
    func loadNewName()
}
protocol CurrentChildOftheAppDelegate : class {
    func getCurrentChild()->Child
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
