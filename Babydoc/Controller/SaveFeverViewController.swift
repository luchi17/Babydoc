//
//  SaveFeverViewController.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 21/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyPickerPopover
import APESuperHUD

class SaveFeverViewController : UITableViewController{
    
    let greenDarkColor = UIColor.init(hexString: "33BE8F")
    let greenLightColor = UIColor.init(hexString: "14E19C")
    let font = UIFont(name: "Avenir-Heavy", size: 17)
    let fontLight = UIFont(name: "Avenir-Medium", size: 17)
    let fontLittle = UIFont(name: "Avenir-Heavy", size: 16)
    let grayColor = UIColor.init(hexString: "555555")
    let grayLightColor = UIColor.init(hexString: "7F8484")
    
    var realm = try! Realm()
    var registeredBabies : Results<Baby>?
    var babyApp = Baby()
    var newFever = Fever()
    var feverValues = [StringPickerPopover.ItemType]()

    
    @IBOutlet weak var textFieldDate: UITextField!
    @IBOutlet weak var textFieldTemperature: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldDate.delegate = self
        textFieldTemperature.delegate = self
        saveButton.layer.cornerRadius = 2
        saveButton.layer.masksToBounds = false
        saveButton.layer.shadowColor = UIColor.flatGray.cgColor
        saveButton.layer.shadowOpacity = 0.7
        saveButton.layer.shadowRadius = 1
        saveButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        configurePopOvers()
        loadBabiesAndFever()
    }
    
    
    
    func saveFever(newFever : Fever){
        
        do{
            try realm.write {
                babyApp.fever.append(newFever)
            }
        }
        catch{
            print(error)
        }
    }
    func configurePopOvers(){
        
        
        for value in 30...42{
            feverValues.append("\(value)")
        }
        
        
    }
    func loadBabiesAndFever(){
        
        registeredBabies = realm.objects(Baby.self)
        
        if registeredBabies?.count != 0 {
            for baby in registeredBabies!{
                if baby.current{
                    babyApp = baby
                }
            }
            //listOfFever = babyApp.fever.filter(NSPredicate(value: true))
            
        }

    }
    
    
    
    
    
    
    
    
    @IBAction func textFieldDateTouchedDown(_ sender: UITextField) {
        sender.textColor = grayLightColor
        sender.font = font
        DatePickerPopover(title: "Date")
            .setDateMode(.dateAndTime)
            .setArrowColor(greenLightColor!)
            .setSelectedDate(Date())
            .setCancelButton(action: { _, _ in print("cancel")})
            .setDoneButton(title: "Done", font: self.fontLittle, color: .white, action: { popover, selectedDate in
                sender.text = self.dateStringFromDate(date: selectedDate)
                
                do{
                    
                    try self.realm.write {
                        self.newFever.date = selectedDate
                    }
                    
                }
                catch{
                    print(error)
                }
                
            })
            .appear(originView: sender, baseViewController: self)
    }
    
    @IBAction func textFieldTemperatureTouchedDown(_ sender: UITextField) {
        
        StringPickerPopover(title: "ºC", choices: feverValues )
            .setArrowColor(greenLightColor!)
            .setFontColor(grayLightColor!).setFont(font!).setSize(width: 320, height: 150).setFontSize(17).setCancelButton { (_, _, _) in }.setDoneButton(title: "Done", font: fontLittle, color: .white) {
                popover, selectedRow, selectedString in
                sender.text = selectedString
                do{
                    try self.realm.write {
                        self.newFever.temperature = Float(selectedString) as! Float
                    }
                }
                catch{
                    print(error)
                }
                
                
                
            }.appear(originView: sender, baseViewController: self)
        
        
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
      
        if babyApp.name.isEmpty || textFieldDate.text!.isEmpty || textFieldTemperature.text!.isEmpty{
            
            let alert = UIAlertController(title: "Error", message: "In order to save the new fever all the fields must be filled in and at least one baby has to be active in Babydoc.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.setMessage(font: fontLight!, color: grayLightColor!)
            alert.setTitle(font: font!, color: grayColor!)
            alert.show(animated: true, vibrate: false, style: .light, completion: nil)
        }
        else{
            saveFever(newFever: newFever)
            let image = UIImage(named: "doubletick")!
            let hudViewController = APESuperHUD(style: .icon(image: image, duration: 2), title: nil, message: "Fever has been added correctly!")
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
    
    
    
}
extension SaveFeverViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
     
            return false
        }
        
}





