
//
//  SaveGrowthViewController.swift
//  ChilCare
//
//  Created by Luchi Parejo alcazar on 14/06/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import SwiftyPickerPopover
import APESuperHUD


class SaveGrowthViewController : UITableViewController, UITextFieldDelegate{
    
    let font = UIFont(name: "Avenir-Heavy", size: 17)
    let fontLittle = UIFont(name: "Avenir-Medium", size: 17)
    let grayColor = UIColor.init(hexString: "555555")
    let grayLightColor = UIColor.init(hexString: "7F8484")
    let darkOrangeColor = UIColor.init(hexString: "E67E22")
    let orangeColor = UIColor.init(hexString: "F58806")
    
    @IBOutlet weak var textFieldDate: UITextField!
    @IBOutlet weak var textFieldHeight: UITextField!
    @IBOutlet weak var textFieldHead: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    var realm = try! Realm()
    var registeredChildren : Results<Child>?
    var childApp = Child()
    
    var growthToSave = Growth()
    var growthToEdit : Growth?{
        didSet{
            loadGrowthToEdit()
        }
    }
    var indicatorEdit = 0
    var weightValues = [StringPickerPopover.ItemType]()
    var heightValues = [StringPickerPopover.ItemType]()
    var headValues = [StringPickerPopover.ItemType]()
    var weightEdit = Float(0.0)
    var heightEdit = Float(0.0)
    var headEdit = Float(0.0)
    var generaldateEdit = Date()
    var dayEdit = 0
    var monthEdit = 0
    var yearEdit = 0
    
    
    func loadChildrenAndGrowth(){
        
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
    func loadGrowthToEdit(){
        
        
        indicatorEdit = 0
        
        if growthToEdit?.weight != Float(0.0){
            
            indicatorEdit += 1
            heightEdit = growthToEdit!.height
            weightEdit = growthToEdit!.weight
            headEdit = growthToEdit!.weight
            generaldateEdit = growthToEdit!.generalDate
            dayEdit = growthToEdit!.date!.day
            monthEdit = (growthToEdit?.date!.month)!
            yearEdit = (growthToEdit?.date!.year)!
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldDate.delegate = self
        
        textFieldHeight.delegate = self
        textFieldHead.delegate = self
        if indicatorEdit != 0 {
            textFieldDate.text = dateStringFromDate(date: growthToEdit?.generalDate ?? Date())
            textFieldWeight.text = "\(growthToEdit?.weight ?? Float(0.0))"
            textFieldHeight.text = "\(growthToEdit?.height ?? Float(0.0))"
            textFieldHead.text = "\(growthToEdit?.headDiameter ?? Float(0.0))"
        }
        
        
        saveButton.layer.cornerRadius = 2
        saveButton.layer.masksToBounds = false
        saveButton.layer.shadowColor = UIColor.flatGray.cgColor
        saveButton.layer.shadowOpacity = 0.7
        saveButton.layer.shadowRadius = 1
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        configurePopOvers()
        loadChildrenAndGrowth()
        
        self.navigationController?.navigationBar.barTintColor = orangeColor
        self.navigationController?.navigationBar.backgroundColor = orangeColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
    }
    func configurePopOvers(){
        
        weightValues = []
        heightValues = []
        headValues = []
        for value in stride(from: 3.0, to: 50.0, by: 0.05){
            weightValues.append(String(format: "%.2f", value))
        }
        for value in stride(from: 0.4, to: 1.5, by: 0.01){
            heightValues.append(String(format: "%.2f", value))
        }//m
        for value in stride(from: 25, to: 60, by: 1){
            headValues.append("\(value)")
        }//cm
        
        
        
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return false
    }
    
    @IBAction func dateTouchedDown(_ sender: UITextField) {
        if indicatorEdit != 0{
            sender.text = dateFormatter.string(from: growthToEdit?.generalDate ?? Date())
        }
        
        sender.textColor = grayLightColor
        sender.font = font
        DatePickerPopover(title: "Date" )
            .setDateMode(.dateAndTime)
            .setArrowColor(orangeColor!)
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
                            let date = DateCustom()
                            date.day = selectedDate.day
                            date.month = selectedDate.month
                            date.year = selectedDate.year
                            
                            self.growthToSave.date = date
                            self.growthToSave.generalDate = selectedDate
                            
                        }
                    }
                    
                }
                catch{
                    print(error)
                }
                
            }).appear(originView: sender, baseViewController: self)
    }
    
    
    
    @IBAction func heightTocuhedDown(_ sender: UITextField) {
        if indicatorEdit != 0{
            sender.text = "\(growthToEdit?.height ?? Float(0.0))"
        }
        
        StringPickerPopover(title: "m", choices: heightValues )
            .setArrowColor(orangeColor!)
            .setFontColor(grayLightColor!).setFont(font!).setSize(width: 320, height: 220).setFontSize(17).setCancelButton { (_, _, _) in }.setDoneButton(title: "Done", font: fontLittle, color: .white) {
                popover, selectedRow, selectedString in
                sender.text = selectedString
                do{
                    try self.realm.write {
                        if self.indicatorEdit != 0{
                            self.heightEdit = Float(selectedString) as! Float
                            self.heightEdit = round((self.heightEdit*100))/100
                        }
                        else{
                            self.growthToSave.height = Float(selectedString) as! Float
                            self.growthToSave.height = round((self.growthToSave.height*100))/100
                        }
                        
                    }
                }
                catch{
                    print(error)
                }
                
                
                
            }.appear(originView: sender, baseViewController: self)
        
        
    }
    @IBOutlet weak var textFieldWeight: UITextField!
    
    
    @IBAction func weightTouchedDown(_ sender: UITextField) {
        if indicatorEdit != 0{
            sender.text = "\(growthToEdit?.weight ?? Float(0.0))"
        }
        
        StringPickerPopover(title: "kg", choices: weightValues )
            .setArrowColor(orangeColor!)
            .setFontColor(grayLightColor!).setFont(font!).setSize(width: 320, height: 220).setFontSize(17).setCancelButton { (_, _, _) in }.setDoneButton(title: "Done", font: fontLittle, color: .white) {
                popover, selectedRow, selectedString in
                sender.text = selectedString
                do{
                    try self.realm.write {
                        if self.indicatorEdit != 0{
                            
                            self.weightEdit = Float(selectedString) as! Float
                            self.weightEdit = round((self.weightEdit*100))/100
                        }
                        else{
                            self.growthToSave.weight = Float(selectedString) as! Float
                            self.growthToSave.weight = round((self.growthToSave.weight*100))/100
                        }
                        
                    }
                }
                catch{
                    print(error)
                }
                
                
                
            }.appear(originView: sender, baseViewController: self)
    }
    
    @IBAction func headTouchedDown(_ sender: UITextField) {
        if indicatorEdit != 0{
            sender.text = "\(growthToEdit?.headDiameter ?? Float(0.0))"
        }
        
        StringPickerPopover(title: "cm", choices: headValues )
            .setArrowColor(orangeColor!)
            .setFontColor(grayLightColor!).setFont(font!).setSize(width: 320, height: 220).setFontSize(17).setCancelButton { (_, _, _) in }.setDoneButton(title: "Done", font: fontLittle, color: .white) {
                popover, selectedRow, selectedString in
                sender.text = selectedString
                do{
                    try self.realm.write {
                        if self.indicatorEdit != 0{
                            self.headEdit = Float(selectedString) as! Float
                            
                        }
                        else{
                            self.growthToSave.headDiameter = Float(selectedString) as! Float
                        }
                        
                    }
                }
                catch{
                    print(error)
                }
                
                
                
            }.appear(originView: sender, baseViewController: self)
        
        
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        
        let alert = UIAlertController(title: "Error", message: "In order to save the growth record all the fields must be filled in and at least one child has to be active in ChildCare.", preferredStyle: .alert)
        
        if childApp.name.isEmpty || textFieldDate.text!.isEmpty || textFieldWeight.text!.isEmpty || textFieldHeight.text!.isEmpty || textFieldHead.text!.isEmpty{
            
            
            if childApp.name.isEmpty{
                alert.set(title: "Error", font: font!, color: grayColor!)
                alert.set(message: "In order to save a growth record at least one child has to be active in ChildCare.", font: fontLittle!, color: grayLightColor!)
            }
            else{
                alert.set(title: "Error", font: font!, color: grayColor!)
                alert.set(message: "In order to save a growth record all the fields have to be filled in.", font: fontLittle!, color: grayLightColor!)
            }
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.show(animated: true, vibrate: false, style: .light, completion: nil)
        }
        else{
            if indicatorEdit == 0 {
                saveGrowth(growthToSave: growthToSave)
            }
            else{
                saveGrowth(growthToEdit: growthToEdit!)
            }
            
            let image = UIImage(named: "doubletick")!
            let hudViewController = APESuperHUD(style: .icon(image: image, duration: 1), title: nil, message: "Fever has been saved correctly!")
            HUDAppearance.cancelableOnTouch = true
            HUDAppearance.messageFont = self.fontLittle!
            HUDAppearance.messageTextColor = self.grayLightColor!
            self.present(hudViewController, animated: true)
            
            self.navigationController?.popViewController(animated: true)
            
            
        }
        
    }
    func saveGrowth(growthToEdit : Growth){
        
        do{
            
            try realm.write {
                growthToEdit.height = heightEdit
                growthToEdit.weight = weightEdit
                growthToEdit.generalDate = generaldateEdit
                growthToEdit.date?.day = dayEdit
                growthToEdit.date?.month = monthEdit
                growthToEdit.date?.year = yearEdit
                
            }
        }
        catch{
            print(error)
        }
        
        
    }
    
    
    
    func saveGrowth(growthToSave : Growth){
        
        do{
            try realm.write {
                childApp.growth.append(growthToSave)
            }
        }
        catch{
            print(error)
        }
    }
    
    
}
