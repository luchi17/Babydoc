//
//  SaveFeverViewController.swift
//  ChildCare
//
//  Created by Luchi Parejo alcazar on 21/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyPickerPopover
import APESuperHUD
import ChameleonFramework
import RLBAlertsPickers

class SaveFeverViewController : UITableViewController{
    
    
    let greenDarkColor = UIColor.init(hexString: "33BE8F")
    let greenLightColor = UIColor.init(hexString: "14E19C")
    let font = UIFont(name: "Avenir-Heavy", size: 17)
    let fontLittle = UIFont(name: "Avenir-Medium", size: 17)
    let grayColor = UIColor.init(hexString: "555555")
    let grayLightColor = UIColor.init(hexString: "7F8484")
    
    var realm = try! Realm()
    var registeredChildren : Results<Child>?
    var childApp = Child()
    var indicatorEdit = 0
    var feverValues = [StringPickerPopover.ItemType]()
    var placeValues = [StringPickerPopover.ItemType]()
    var temperatureEdit = Float(0.0)
    var placeEdit = ""
    var generaldateEdit = Date()
    var dayEdit = 0
    var monthEdit = 0
    var yearEdit = 0
    var feverToSave = Fever()
    var feverToEdit : Fever?{
        didSet{
            loadFeverToEdit()
        }
    }
     let date = DateCustom()
    var _dateFormatter: DateFormatter?
    var dateFormatter: DateFormatter {
        if (_dateFormatter == nil) {
            _dateFormatter = DateFormatter()
            _dateFormatter!.locale = Locale(identifier: "en_US_POSIX")
            _dateFormatter!.dateFormat = "MM/dd/yyyy HH:mm"
        }
        return _dateFormatter!
    }
    
    func dateStringFromDate(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    
    @IBOutlet weak var textFieldDate: UITextField!
    @IBOutlet weak var textFieldTemperature: UITextField!
    @IBOutlet weak var textFieldPlace: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var checkFeverButton: UIButton!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldDate.delegate = self
        
        textFieldTemperature.delegate = self
        textFieldPlace.delegate = self
        if indicatorEdit != 0 {
            textFieldDate.text = dateStringFromDate(date: feverToEdit?.generalDate ?? Date())
            textFieldTemperature.text = "\(feverToEdit?.temperature ?? Float(0.0)) ºC"
            textFieldPlace.text = feverToEdit?.placeOfMeasurement
        }
        else{
            textFieldDate.textColor = grayLightColor
            textFieldDate.font = font
            textFieldDate.text = dateFormatter.string(from: Date())
            
            date.day = Date().day
            date.month = Date().month
            date.year = Date().year
            feverToSave.date = date
        }
        
        
        saveButton.layer.cornerRadius = 2
        saveButton.layer.masksToBounds = false
        saveButton.layer.shadowColor = UIColor.flatGray.cgColor
        saveButton.layer.shadowOpacity = 0.7
        saveButton.layer.shadowRadius = 1
        checkFeverButton.layer.cornerRadius = 2
        checkFeverButton.layer.masksToBounds = false
        checkFeverButton.layer.shadowColor = UIColor.flatGray.cgColor
        checkFeverButton.layer.shadowOpacity = 0.7
        checkFeverButton.layer.shadowRadius = 1
        checkFeverButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        configurePopOvers()
        loadChildrenAndFever()

        
    }
    func configurePopOvers(){
        
        feverValues = []
        for value in stride(from: 35, to: 42, by: 0.1){
            feverValues.append("\(value)")
        }
        placeValues.append("mouth")
        placeValues.append("ear")
        placeValues.append("armpit")
        placeValues.append("rectum")
        
        
    }
    
    
    //MARK: - Data manipulation methods
    
    func saveFever(feverToEdit : Fever){
        
        do{
     
            try realm.write {
                feverToEdit.temperature = temperatureEdit
                feverToEdit.placeOfMeasurement = placeEdit
                feverToEdit.generalDate = generaldateEdit
                feverToEdit.date?.day = dayEdit
                feverToEdit.date?.month = monthEdit
                feverToEdit.date?.year = yearEdit
                
            }
        }
        catch{
            print(error)
        }
        
        
    }
    
    
    func saveFever(feverToSave : Fever){
        
        do{
            try realm.write {
                childApp.fever.append(feverToSave)
            }
        }
        catch{
            print(error)
        }
    }
    
    func loadChildrenAndFever(){

        childApp = Child()
        registeredChildren = realm.objects(Child.self)
        
        if registeredChildren?.count != 0 {
            for child in registeredChildren!{
                if child.current{
                    childApp = child
                }
            }

            
        }

        
    }
    func loadFeverToEdit(){
        
       
        indicatorEdit = 0
       
        
        if feverToEdit?.temperature != Float(0.0){
            
            indicatorEdit += 1
            temperatureEdit = feverToEdit!.temperature
            placeEdit = feverToEdit!.placeOfMeasurement
            generaldateEdit = feverToEdit!.generalDate
            dayEdit = feverToEdit!.date!.day
            monthEdit = (feverToEdit?.date!.month)!
            yearEdit = (feverToEdit?.date!.year)!
        }

        
    }
    
    
    
    @IBAction func textFieldDateTouchedDown(_ sender: UITextField) {
        
        if indicatorEdit != 0{
            sender.text = dateFormatter.string(from: feverToEdit?.generalDate ?? Date())
        }
        
        sender.textColor = grayLightColor
        sender.font = font
        DatePickerPopover(title: "Date" )
            .setDateMode(.dateAndTime)
            .setArrowColor(greenLightColor!)
            .setSelectedDate(Date())
            .setDoneButton(title: "Done", font: self.fontLittle, color: .white, action: { popover, selectedDate in
                sender.text = self.dateStringFromDate(date: selectedDate)
                
                do{
                    if self.indicatorEdit != 0 {
                        try self.realm.write {

                            self.generaldateEdit = selectedDate
                            self.dayEdit = selectedDate.day
                            self.monthEdit = selectedDate.month
                            self.yearEdit = selectedDate.year
                            
                        }
                        
                    }
                    else{
                        try self.realm.write {
                            
                            self.date.day = selectedDate.day
                            self.date.month = selectedDate.month
                            self.date.year = selectedDate.year
                            
                            self.feverToSave.date = self.date
                            self.feverToSave.generalDate = selectedDate
                            
                        }
                    }
                    
                }
                catch{
                    print(error)
                }
                
            })
            .appear(originView: sender, baseViewController: self)
    }
    
    @IBAction func textFieldTemperatureTouchedDown(_ sender: UITextField) {
        
        
        if indicatorEdit != 0{
            sender.text = "\(feverToEdit?.temperature ?? Float(0.0)) ºC"
        }
        
        StringPickerPopover(title: "ºC", choices: feverValues )
            .setArrowColor(greenLightColor!)
            .setFontColor(grayLightColor!).setFont(font!).setSize(width: 320, height: 220).setFontSize(17).setCancelButton { (_, _, _) in }.setDoneButton(title: "Done", font: fontLittle, color: .white) {
                popover, selectedRow, selectedString in
                sender.text = selectedString + " ºC"
                do{
                    try self.realm.write {
                        if self.indicatorEdit != 0{
                            self.temperatureEdit = Float(selectedString) as! Float
                        }
                        else{
                            self.feverToSave.temperature = Float(selectedString) as! Float
                        }
                        
                    }
                }
                catch{
                    print(error)
                }
                
                
                
            }.appear(originView: sender, baseViewController: self)
        
        
    }
    
    @IBAction func textFieldPlaceTouchedDown(_ sender: UITextField) {
        
        if indicatorEdit != 0{
            sender.text = "\(feverToEdit?.placeOfMeasurement ?? "")"
        }
        
        StringPickerPopover(title: "Place", choices: placeValues )
            .setArrowColor(greenLightColor!)
            .setFontColor(grayLightColor!).setFont(font!).setSize(width: 320, height: 150).setFontSize(17).setCancelButton { (_, _, _) in }.setDoneButton(title: "Done", font: fontLittle, color: .white) {
                popover, selectedRow, selectedString in
                sender.text = selectedString
                do{
                    try self.realm.write {
                        if self.indicatorEdit != 0{
                           self.placeEdit = selectedString
                        }
                        else{
                            self.feverToSave.placeOfMeasurement = selectedString
                        }
                        
                    }
                }
                catch{
                    print(error)
                }
                
                
                
            }.appear(originView: sender, baseViewController: self)
        
        
    }
    @IBAction func saveButtonPressed(_ sender: UIButton) {

        
        let alert = UIAlertController(title: "Error", message: "In order to save the fever all the fields must be filled in and at least one child has to be active in ChildCare.", preferredStyle: .alert)
        
        if childApp.name.isEmpty || textFieldDate.text!.isEmpty || textFieldTemperature.text!.isEmpty || textFieldPlace.text!.isEmpty{
            
            
            if childApp.name.isEmpty{
                alert.set(title: "Error", font: font!, color: grayColor!)
                alert.set(message: "In order to save a fever record at least one child has to be active in ChildCare.", font: fontLittle!, color: grayLightColor!)
            }
            else{
                alert.set(title: "Error", font: font!, color: grayColor!)
                alert.set(message: "In order to save a fever record all the fields have to be filled in.", font: fontLittle!, color: grayLightColor!)
            }
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.show(animated: true, vibrate: false, style: .light, completion: nil)
        }
        else{
            if indicatorEdit == 0 {
                saveFever(feverToSave: feverToSave)
            }
            else{
                saveFever(feverToEdit: feverToEdit!)
            }
            
            let image = UIImage(named: "doubletick")!
            let hudViewController = APESuperHUD(style: .icon(image: image, duration: 1), title: nil, message: "Fever has been saved correctly!")
            HUDAppearance.cancelableOnTouch = true
            HUDAppearance.messageFont = self.fontLittle!
            HUDAppearance.messageTextColor = self.grayLightColor!
            self.present(hudViewController, animated: true)
           
            

        }
       
    }
    
    func checkFever(){
        if textFieldTemperature.text!.isEmpty || textFieldPlace.text!.isEmpty{
            
            if textFieldTemperature.text!.isEmpty && textFieldPlace.text!.isEmpty{
                
                let alert = UIAlertController(style: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.set(title: "Error", font: font!, color: grayColor!)
                alert.set(message: "Temperature and place fields must be filled in.", font: fontLittle!, color: grayLightColor!)
                
                alert.addAction(action)
                alert.show(animated: true, vibrate: false, style: .light, completion: nil)
            }
            else{
                let alert = UIAlertController(style: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                if textFieldTemperature.text!.isEmpty{
                    
                    alert.set(title: "Error", font: font!, color: grayColor!)
                    alert.set(message: "The temperature field must be filled in.", font: fontLittle!, color: grayLightColor!)
                    
                }
                else if textFieldPlace.text!.isEmpty{
                    alert.set(title: "Error", font: font!, color: grayColor!)
                    alert.set(message: "The site of measurement field must be filled in.", font: fontLittle!, color: grayLightColor!)
                    
                }
                
                alert.addAction(action)
                alert.show(animated: true, vibrate: false, style: .light, completion: nil)
            }
            
        }
            
            
        else{
            
            let alert = UIAlertController(style: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
            guard let temperatureArray = textFieldTemperature.text?.components(separatedBy: CharacterSet.decimalDigits.inverted) else { return  }
            var temperature = Float(0.0)
            for temp in temperatureArray {
                if let number = Float(temp){
                    temperature = number
                    break
                }
                
            }
            let ageArray = childApp.age.components(separatedBy: CharacterSet.decimalDigits.inverted)
            var ageChild : Int = 0
            for age in ageArray {
                if let number = Int(age){
                    ageChild = number
                    break
                }
                
            }
            
            
            if textFieldPlace.text! == "mouth"{
                if temperature >= Float(37.8) {
                    
                    if temperature >= Float(38.9){
                        alert.set(title: "Seek medical attention for your child!", font: self.font!, color: .red)
                    }
                    else{
                        
                        alert.set(title: "Your child has fever!", font: self.font!, color: .flatOrange)
                    }
                    
                }
                    
                else{
                    
                    alert.set(title: "Your child does not have fever!", font: self.font!, color: self.greenDarkColor!)
                    
                }
                
                
            }
            else if textFieldPlace.text! == "rectum" || textFieldPlace.text! == "ear" {
                if temperature >= Float(38.0){
                    
                    if childApp.age.contains("months") && !childApp.age.contains("years") && ageChild <= 3{
                        alert.set(title: "Seek medical attention for your child!", font: self.font!, color: .red)
                        
                    }
                    else if childApp.age.contains("days") && !childApp.age.contains("months") && !childApp.age.contains("years"){
                        alert.set(title: "Seek medical attention for your child!", font: self.font!, color: .red)
                    }
                    else if temperature >= Float(38.9){
                        alert.set(title: "Seek medical attention for your child!", font: self.font!, color: .red)
                    }
                        
                    else{
                        alert.set(title: "Your child has fever!", font: self.font!, color: .flatOrange)
                    }
                }
                    
                else{
                    
                    alert.set(title: "Your child does not have fever!", font: self.font!, color: self.greenDarkColor!)
                    
                }
                
            }
            else if textFieldPlace.text! == "armpit"{
                if temperature >= Float(37.2) {
                    
                    alert.set(title: "Your child has fever!", font: self.font!, color: .flatOrange)
                   
                }
                else if temperature >= Float(38.9){
                    alert.set(title: "Seek medical attention for your child!", font: self.font!, color: .red)
                    
                   
                }
                    
                else{
                    
                    alert.set(title: "Your child does not have fever!", font: self.font!, color: self.greenDarkColor!)
                   
                }
                
            }
            
            alert.addAction(action)
            alert.show(animated: true, vibrate: false, style: .light, completion: nil)
        }
        
        
        
        
    }

    
    @IBAction func checkFeverPressed(_ sender: UIButton) {
        
        checkFever()
    }
    
    
    
}
extension SaveFeverViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return false
    }
    
}





