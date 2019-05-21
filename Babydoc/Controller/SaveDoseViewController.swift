//
//  SaveDoseViewController.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 19/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyPickerPopover
import APESuperHUD

class SaveDoseViewController : UITableViewController{
    
    let font = UIFont(name: "Avenir-Heavy", size: 17)
    let fontLight = UIFont(name: "Avenir-Medium", size: 17)
    let fontLittle = UIFont(name: "Avenir-Heavy", size: 16)
    let pinkcolor = UIColor.init(hexString: "F97DBE")
    let darkPinkColor = UIColor.init(hexString: "FB569F")
    let lightPinkColor = UIColor.init(hexString: "FFA0D2")
    let grayColor = UIColor.init(hexString: "555555")
    let grayLightColor = UIColor.init(hexString: "7F8484")
    @IBOutlet weak var textFieldDate: UITextField!
    @IBOutlet weak var textFieldQuantity: UITextField!
    @IBOutlet weak var textFieldQuantityUnit: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var medication : MedicationDoseCalculated?{
        didSet{
            configureDrugToSave()
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
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

        view.addGestureRecognizer(tap)
    }
   

    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        textFieldQuantity.endEditing(true)
    }

    
    @IBAction func textField1TouchDown(_ sender: UITextField) {
        
        sender.textColor = grayLightColor
        sender.font = font
        DatePickerPopover(title: "Date")
            .setDateMode(.dateAndTime)
            .setArrowColor(lightPinkColor!)
            .setSelectedDate(Date())
            .setCancelButton(action: { _, _ in print("cancel")})
            .setDoneButton(title: "Done", font: self.fontLittle, color: .white, action: { popover, selectedDate in
                sender.text = self.dateStringFromDate(date: selectedDate)
                
                do{
                    
                    try self.realm.write {
                        self.medication?.date = sender.text!
                    }
                    
                }
                catch{
                 print(error)
                }
                
            })
            .appear(originView: sender, baseViewController: self)
        
        
        
    }
    
    @IBAction func textField2TouchDown(_ sender: UITextField) {
        
        sender.textColor = grayLightColor
        sender.font = font
        
        
    }
    
    @IBAction func quantityTextFieldEndEditing(_ sender: UITextField) {
       
        do{
            try realm.write {
                medication!.dose = sender.text!
            }
        }
        catch{
            print(error)
        }
        
        
    }
    
    @IBAction func textField3TouchDown(_ sender: UITextField) {
        
        sender.textColor = grayLightColor
        sender.font = font
        StringPickerPopover(title: "Units", choices: quantityUnit )
            .setArrowColor(lightPinkColor!)
            .setFontColor(grayLightColor!).setFont(font!).setSize(width: 320, height: 150).setFontSize(17).setCancelButton { (_, _, _) in }.setDoneButton(title: "Done", font: fontLittle, color: .white) {
                    popover, selectedRow, selectedString in
                    sender.text = selectedString
                do{
                    try self.realm.write {
                        self.medication!.doseUnit = sender.text!
                    }
                }
                catch{
                    print("unable to save dose")
                }
                
                
                    
            }.appear(originView: sender, baseViewController: self)
        
        
        
    }
    
    @IBAction func saveDosePressed(_ sender: UIButton) {
        
        
        if textFieldDate.text!.isEmpty || textFieldQuantityUnit.text!.isEmpty || textFieldQuantity.text!.isEmpty{
            
            let alert = UIAlertController(title: "Error", message: "In order to save the dose all the fields must be filled in.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.setMessage(font: fontLight!, color: grayLightColor!)
            alert.setTitle(font: font!, color: grayColor!)
            alert.show(animated: true, vibrate: false, style: .light, completion: nil)
        }
        else{
            saveData()
            let image = UIImage(named: "doubletick")!
            let hudViewController = APESuperHUD(style: .icon(image: image, duration: 2), title: nil, message: "Dose has been added correctly!")
            HUDAppearance.cancelableOnTouch = true
            HUDAppearance.messageFont = self.fontLight!
            HUDAppearance.messageTextColor = self.grayLightColor!
            
            self.present(hudViewController, animated: true)
            
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
    
    func configureDrugToSave(){
        
        if medication?.nameType == "Drops"{
            quantityUnit.append("mg/ml")
            quantityUnit.append("drops")
        }
        else if medication?.nameType == "Syrup"{
             quantityUnit.append("mg/ml")
        }
        else if medication?.nameType == "Suppository"{
            quantityUnit.append("suppositories")
            quantityUnit.append("mg")
        }
        else if medication?.nameType == "Orodispersible Tablet"{
            quantityUnit.append("mg")
            quantityUnit.append("orodispersible tablets")
        }
        else if medication?.nameType == "Tablet"{
            quantityUnit.append("mg")
            quantityUnit.append("tablets")
        }
        else if medication?.nameType == "Sachet"{
            quantityUnit.append("mg")
            quantityUnit.append("sachets")
        }

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


    

