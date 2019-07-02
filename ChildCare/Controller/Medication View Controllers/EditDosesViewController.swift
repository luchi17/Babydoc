//
//  EditDosesViewController.swift
//  ChildCare
//
//  Created by Luchi Parejo alcazar on 20/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyPickerPopover
import APESuperHUD


class EditDosesViewController : UITableViewController{
    
    @IBOutlet weak var textFieldDate: UITextField!
    
    @IBOutlet weak var textFieldConcentration: UITextField!
    
    @IBOutlet weak var textFieldWeight: UITextField!
    
    @IBOutlet weak var textFieldQuantity: UITextField!
    
    @IBOutlet weak var textFieldQuantityUnits: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    let pinkcolor = UIColor.init(hexString: "F97DBE")
    let darkPinkColor = UIColor.init(hexString: "FB569F")
    let lightPinkColor = UIColor.init(hexString: "FFA0D2")
    let font = UIFont(name: "Avenir-Heavy", size: 17)
    let fontLittle = UIFont(name: "Avenir-Medium", size: 17)
    //let fontLittle = UIFont(name: "Avenir-Heavy", size: 16)
    let grayColor = UIColor.init(hexString: "555555")
    let grayLightColor = UIColor.init(hexString: "7F8484")
    var doseToEdit: MedicationDoseCalculated?{
        didSet{
            configurePopOvers()
            loadDoseToEditAndChild()
        }
    }
    var realm = try! Realm()
    var concentrations = Array<Int>()
    var concentrationsPopOver = Array<StringPickerPopover.ItemType>()
    var weightsPopOver = Array<StringPickerPopover.ItemType>()
    var quantityUnit = [StringPickerPopover.ItemType]()
    var drugTypes : Results<MedicationType>?
    var drugs : Results<Medication>?
    var concentrationUnit : String = ""
    var minimumWeight = 0
    var maximumWeight = 60
    var concentrationSelected = 0
    var weightUnit = ""
    var weightSelected = Float(0.0)
    
    var quantityEdit = Float(0.0)
    var quantityUnitEdit = ""
    var generaldateEdit = Date()
    var dayEdit = 0
    var monthEdit = 0
    var yearEdit = 0
    var registeredChildren : Results<Child>?
    var childApp = Child()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldDate.delegate = self
        textFieldQuantity.delegate = self
        textFieldQuantityUnits.delegate = self
        textFieldWeight.delegate = self
        textFieldConcentration.delegate = self
        textFieldDate.text = dateStringFromDate(date: doseToEdit!.generalDate)
        textFieldQuantity.text = doseToEdit?.dose
        textFieldQuantityUnits.text = doseToEdit?.doseUnit
        textFieldWeight.text = "\(doseToEdit?.weight ?? Float(0.0))" + " kg"
        textFieldConcentration.text = "\(doseToEdit?.medicationType?.concentration ?? 0)" + " " + doseToEdit!.medicationType!.concentrationUnit
        saveButton.layer.cornerRadius = 2
        saveButton.layer.masksToBounds = false
        saveButton.layer.shadowColor = UIColor.flatGray.cgColor
        saveButton.layer.shadowOpacity = 0.7
        saveButton.layer.shadowRadius = 1
        saveButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        
        textFieldQuantity.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.barTintColor = lightPinkColor
        self.navigationController?.navigationBar.backgroundColor = lightPinkColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        configurePopOvers()
        
        
    }
    override func willMove(toParent parent: UIViewController?) {
        self.navigationController?.navigationBar.barTintColor = pinkcolor
    }
    
    //MARK: TextFields methods
    
    @IBAction func textFieldDateTouchDown(_ sender: UITextField) {
        
        
        DatePickerPopover(title: "Date")
            .setDateMode(.dateAndTime)
            .setArrowColor(lightPinkColor!)
            .setSelectedDate(Date())
            .setCancelButton(action: { _, _ in print("cancel")})
            .setDoneButton(title: "Done", font: self.fontLittle, color: .white, action: { popover, selectedDate in
                sender.text = self.dateStringFromDate(date: selectedDate)
                
                self.generaldateEdit = selectedDate
                self.dayEdit = selectedDate.day
                self.monthEdit = selectedDate.month
                self.yearEdit = selectedDate.year
               
                
                
            })
            .appear(originView: sender, baseViewController: self)
        
        
        
        
    }
    
    @IBAction func textFieldConcentrationTouchDown(_ sender: UITextField) {
        
        self.concentrationSelected = doseToEdit!.medicationType!.concentration
        
        StringPickerPopover(title: doseToEdit?.medicationType?.concentrationUnit, choices: concentrationsPopOver).setArrowColor(lightPinkColor!).setFontColor(grayColor!).setFont(font!).setSize(width: 220, height: 150).setFontSize(17).setDoneButton(title: "Done", font: fontLittle, color: .white) {
            popover, selectedRow, selectedString in
            sender.text = selectedString + " " + self.doseToEdit!.medicationType!.concentrationUnit
            
            self.concentrationSelected = Int(selectedString)!
            
            
            self.configureProperties(selectedProperty:selectedString)
            
            }.appear(originView: sender, baseViewController: self)
    }
    
    
    
    
    @IBAction func textFieldWeightTouchDown(_ sender: UITextField) {
        
        
        self.configureProperties(selectedProperty: "\(concentrationSelected)")
        
        StringPickerPopover(title: "kg", choices: weightsPopOver).setArrowColor(lightPinkColor!).setFontColor(grayLightColor!).setFont(font!).setSize(width: 180, height: 220).setFontSize(17).setDoneButton(title: "Done", font: fontLittle, color: .white) {
            popover, selectedRow, selectedString in
            sender.text = selectedString + " kg"
            
            self.weightSelected = Float(selectedString)!
            
            }.appear(originView: sender, baseViewController: self)
        
        
    }
    
    
    @IBAction func textFieldQuantityDidEndEditing(_ sender: UITextField) {
        
        quantityEdit = Float(sender.text!) as! Float
        
        
    }
    
    @IBAction func textFieldQUnitsTouchDown(_ sender: UITextField) {
        
        sender.text = doseToEdit?.doseUnit
        sender.textColor = grayLightColor
        sender.font = font
        StringPickerPopover(title: "Units", choices: quantityUnit )
            .setArrowColor(lightPinkColor!)
            .setFontColor(grayColor!).setFont(font!).setSize(width: 320, height: 150).setFontSize(17).setCancelButton { (_, _, _) in }.setDoneButton(title: "Done", font: fontLittle, color: .white) {
                popover, selectedRow, selectedString in
                sender.text = selectedString
                
                self.quantityUnitEdit = selectedString
                
                
            }.appear(originView: sender, baseViewController: self)
        
        
    }
    
    
    @IBAction func okButtonPressed(_ sender: UIButton) {
        
        
        let alert = UIAlertController(style: .alert)
        
        if childApp.name.isEmpty {
            
            alert.set(title: "Error", font: font!, color: grayColor!)
            alert.set(message: "In order to save a fever record at least one child has to be active in ChildCare.", font: fontLittle!, color: grayLightColor!)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.show(animated: true, vibrate: false, style: .light, completion: nil)
        }
            
            
        else{
            
            do{
                try realm.write {
                    //doseToEdit?.concentration = self.concentrationSelected
                    doseToEdit?.weight = self.weightSelected
                    doseToEdit?.dose = "\(quantityEdit)"
                    doseToEdit?.generalDate = generaldateEdit
                    doseToEdit?.date?.day = dayEdit
                    doseToEdit?.date?.month = monthEdit
                    doseToEdit?.date?.year = yearEdit
                }
            }
            catch{
                print(error)
            }
            
            
            let image = UIImage(named: "doubletick")!
            let hudViewController = APESuperHUD(style: .icon(image: image, duration: 1), title: nil, message: "Dose has been added correctly!")
            HUDAppearance.cancelableOnTouch = true
            HUDAppearance.messageFont = self.fontLittle!
            HUDAppearance.messageTextColor = self.grayColor!
            
            self.present(hudViewController, animated: true)
            
            self.navigationController?.popViewController(animated: true)
        }
        
        
        
        
    }
    
    
    func configurePopOvers(){
        
        if !(doseToEdit?.medicationType?.name.isEmpty)!{
            
            quantityEdit = Float(doseToEdit!.dose) as! Float
            quantityUnitEdit = doseToEdit!.doseUnit
            generaldateEdit = doseToEdit!.generalDate
            dayEdit = doseToEdit!.date!.day
            monthEdit = (doseToEdit?.date!.month)!
            yearEdit = (doseToEdit?.date!.year)!
        }
        
        
        
        
        if doseToEdit?.medicationType?.name == "Drops"{
            quantityUnit.append("ml")
            quantityUnit.append("drops")
        }
        else if doseToEdit?.medicationType?.name == "Syrup"{
            quantityUnit.append("ml")
        }
        else if doseToEdit?.medicationType?.name == "Suppository"{
            quantityUnit.append("suppositories")
            quantityUnit.append("mg")
        }
        else if doseToEdit?.medicationType?.name == "Orodispersible Tablet"{
            quantityUnit.append("mg")
            quantityUnit.append("orodispersible tablets")
        }
        else if doseToEdit?.medicationType?.name == "Tablet"{
            quantityUnit.append("mg")
            quantityUnit.append("tablets")
        }
        else if doseToEdit?.medicationType?.name == "Sachet"{
            quantityUnit.append("mg")
            quantityUnit.append("sachets")
        }
      
        drugTypes = realm.objects(MedicationType.self).filter( "name == %@ AND medication.name", doseToEdit?.medicationType?.name as Any, doseToEdit?.medicationType?.medication?.name as Any)
        
        
        for type in drugTypes!{
            concentrations.append(Int(type.concentration))
            
        }
        
        for concentration in concentrations{
            
            var valuePopOver = StringPickerPopover.ItemType()
            valuePopOver.append("\(concentration)")
            concentrationsPopOver.append(valuePopOver)
            
        }
        self.configureProperties(selectedProperty: "\(concentrationSelected)")
        self.concentrationSelected = doseToEdit!.medicationType!.concentration
        self.weightSelected = doseToEdit!.weight
        
        
        
        
    }
    func loadDoseToEditAndChild(){
        
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
    
    func configureProperties(selectedProperty : String){
        
        let specificType = drugTypes?.filter("concentration == %@", Int(selectedProperty) as Any)
        
        for type in specificType!{
            
            minimumWeight = type.minWeight
            maximumWeight = type.maxWeight
            break
        }
        
        
        weightsPopOver = []
        for weight in minimumWeight...maximumWeight{
            
            var weightPopOver = StringPickerPopover.ItemType()
            weightPopOver.append("\(weight)")
            weightsPopOver.append(weightPopOver)
            
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
    
    
    
}



extension EditDosesViewController : UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField.tag == 3{
            return true
        }
        else{
            return false
        }
        
    }
    
}
