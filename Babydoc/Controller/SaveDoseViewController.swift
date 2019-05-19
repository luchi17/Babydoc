//
//  SaveDoseViewController.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 19/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import SwiftyPickerPopover

class SaveDoseViewController : UITableViewController{
    
    let font = UIFont(name: "Avenir-Heavy", size: 17)
    let fontLight = UIFont(name: "Avenir-Medium", size: 17)
    let fontLittle = UIFont(name: "Avenir-Heavy", size: 16)
    let pinkcolor = UIColor.init(hexString: "F97DBE")
    let darkPinkColor = UIColor.init(hexString: "FB569F")
    let lightPinkColor = UIColor.init(hexString: "FFA0D2")
    let grayColor = UIColor.init(hexString: "7F8484")
    let grayLightColor = UIColor.init(hexString: "7F8484")
    @IBOutlet weak var textFieldDate: UITextField!
    @IBOutlet weak var textFieldQuantity: UITextField!
    @IBOutlet weak var textFieldQuantityUnit: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var medication : MedicationDoseCalculated?{
        didSet{
            loadDrugToSave()
        }
    }
    var baby : Baby?{
        didSet{
            
        }
    }
    var realm = try! Realm()
    var quantityUnit = [StringPickerPopover.ItemType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldDate.delegate = self
        textFieldQuantity.delegate = self
        textFieldQuantityUnit.delegate = self
        saveButton.layer.cornerRadius = 2
        saveButton.layer.masksToBounds = false
        saveButton.layer.shadowColor = UIColor.flatGray.cgColor
        saveButton.layer.shadowOpacity = 0.7
        saveButton.layer.shadowRadius = 1
        saveButton.layer.shadowOffset = CGSize(width: 2, height: 2)
    }
    
    @IBAction func textField1TouchDown(_ sender: UITextField) {
        
        sender.textColor = grayColor
        sender.font = font
        DatePickerPopover(title: "Date")
            .setDateMode(.dateAndTime)
            .setArrowColor(lightPinkColor!)
            .setSelectedDate(Date())
            .setCancelButton(action: { _, _ in print("cancel")})
            .setDoneButton(title: "Done", font: self.fontLittle, color: .white, action: { popover, selectedDate in
                sender.text = self.dateStringFromDate(date: selectedDate)
                self.medication?.date = sender.text!
            })
            .appear(originView: sender, baseViewController: self)
        
        
        
    }
    
    @IBAction func textField2TouchDown(_ sender: UITextField) {
        
        sender.textColor = grayColor
        sender.font = font
        medication?.dose = sender.text!
        
    }
    
    @IBAction func textField3TouchDown(_ sender: UITextField) {
        
        sender.textColor = grayColor
        sender.font = font
        StringPickerPopover(title: "Units", choices: quantityUnit )
            .setArrowColor(lightPinkColor!)
            .setFontColor(grayColor!).setFont(font!).setSize(width: 320, height: 150).setFontSize(17).setCancelButton { (_, _, _) in }.setDoneButton(title: "Done", font: fontLittle, color: .white) {
                    popover, selectedRow, selectedString in
                    sender.text = selectedString
                    self.medication!.doseUnit = sender.text!
                    
            }.appear(originView: sender, baseViewController: self)
        
        
        
    }
    
    @IBAction func saveDosePressed(_ sender: UIButton) {
        
        
        if textFieldDate.text!.isEmpty || textFieldQuantityUnit.text!.isEmpty || textFieldQuantity.text!.isEmpty{
            
            let alert = UIAlertController(title: "Error", message: "In order to save the dose all the fields must be filled in.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.setMessage(font: fontLight!, color: grayLightColor!)
            alert.setTitle(font: font!, color: grayColor!)
            alert.show(animated: true, vibrate: true, style: .light, completion: nil)
        }
        else{
            saveData()
        }
    }
    
    
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
    
    func loadDrugToSave(){
        
        var unit = StringPickerPopover.ItemType()
        unit.append("mg/ml")
        var unit1 = StringPickerPopover.ItemType()
        unit1.append("mg")
        var unit2 = StringPickerPopover.ItemType()
        unit2.append("drops")
        var unit3 = StringPickerPopover.ItemType()
        unit3.append("suppositories")
        var unit4 = StringPickerPopover.ItemType()
        unit4.append("orodispersible tablets")
        var unit5 = StringPickerPopover.ItemType()
        unit5.append("tablets")
        quantityUnit.append(unit)
        quantityUnit.append(unit1)
        quantityUnit.append(unit2)
        quantityUnit.append(unit3)
        quantityUnit.append(unit4)
        quantityUnit.append(unit5)
        
        
    }
    
    func saveData(){
        
        
        do{
            try realm.write {

                baby?.medicationDoses.append(medication!)
            }
        }
        catch{
            print(error)
        }
        
        
    }
    
   

    
}
extension SaveDoseViewController : UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField.tag == 1{
            return true
        }
        else{
            return false
        }
        
    }
}

    

