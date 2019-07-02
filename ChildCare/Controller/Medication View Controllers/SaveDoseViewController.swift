//
//  SaveDoseViewController.swift
//  ChildCare
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
    let fontLittle = UIFont(name: "Avenir-Medium", size: 17)
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
    var childApp = Child()
    var registeredChildren : Results<Child>?
      
    var realm = try! Realm()
    var quantityUnit = [StringPickerPopover.ItemType]()
    let date = DateCustom()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldDate.delegate = self
        textFieldDate.textColor = grayLightColor
        textFieldDate.font = font
        textFieldDate.text = dateFormatter.string(from: Date())
        
        date.day = Date().day
        date.month = Date().month
        date.year = Date().year
        self.medication?.date = date
        self.medication?.generalDate = Date()
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
    override func viewWillAppear(_ animated: Bool) {
        configureDrugToSave()

    }

    @objc func dismissKeyboard() {
       
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
                        
                        self.date.day = selectedDate.day
                        self.date.month = selectedDate.month
                        self.date.year = selectedDate.year
                        
                        self.medication?.date = self.date
                        self.medication?.generalDate = selectedDate
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
        
        if (childApp.name.isEmpty) || textFieldDate.text!.isEmpty || textFieldQuantityUnit.text!.isEmpty || textFieldQuantity.text!.isEmpty{
            let alert = UIAlertController(style: .alert)
            
            if (childApp.name.isEmpty){
                alert.set(title: "Error", font: font!, color: grayColor!)
                alert.set(message: "In order to save a dose record at least one child has to be active in ChildCare.", font: fontLittle!, color: grayLightColor!)
            }
            else{
                alert.set(title: "Error", font: font!, color: grayColor!)
                alert.set(message: "In order to save a dose record all the fields have to be filled in.", font: fontLittle!, color: grayLightColor!)
            }
            
            
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.show(animated: true, vibrate: false, style: .light, completion: nil)
        }
        else{
            saveData()
            let image = UIImage(named: "doubletick")!
            let hudViewController = APESuperHUD(style: .icon(image: image, duration: 1), title: nil, message: "Dose has been added correctly!")
            HUDAppearance.cancelableOnTouch = true
            HUDAppearance.messageFont = self.fontLittle!
            HUDAppearance.messageTextColor = self.grayLightColor!
            
            self.present(hudViewController, animated: true)
            self.navigationController?.popViewController(animated: true)
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
        
        quantityUnit = []
        childApp = Child()
        registeredChildren = realm.objects(Child.self)
        if registeredChildren?.count != 0{
            for child in registeredChildren!{
                if child.current == true{
                    childApp = child
                }
            }

        }
     
        
        if medication?.medicationType!.name == "Drops"{
            quantityUnit.append("mg/ml")
            quantityUnit.append("drops")
        }
        else if medication?.medicationType!.name == "Syrup"{
             quantityUnit.append("mg/ml")
        }
        else if medication?.medicationType!.name == "Suppository"{
            quantityUnit.append("suppositories")
            quantityUnit.append("mg")
        }
        else if medication?.medicationType!.name == "Orodispersible Tablet"{
            quantityUnit.append("mg")
            quantityUnit.append("orodispersible tablets")
        }
        else if medication?.medicationType!.name == "Tablet"{
            quantityUnit.append("mg")
            quantityUnit.append("tablets")
        }
        else if medication?.medicationType!.name == "Sachet"{
            quantityUnit.append("mg")
            quantityUnit.append("sachets")
        }

    }
    
    func saveData(){
        
        
        do{
            try realm.write {
                
                
                childApp.medicationDoses.append(medication!)
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


    

