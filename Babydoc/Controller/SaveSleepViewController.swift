//
//  SaveSleepViewController.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 23/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//


import UIKit
import RealmSwift
import SwiftyPickerPopover
import APESuperHUD


class SaveSleepViewController : UITableViewController{
    
    
    let font = UIFont(name: "Avenir-Heavy", size: 17)
    let fontLittle = UIFont(name: "Avenir-Medium", size: 17)
    //let fontLittle = UIFont(name: "Avenir-Heavy", size: 16)
    let grayColor = UIColor.init(hexString: "555555")
    let grayLightColor = UIColor.init(hexString: "7F8484")
    let darkBlueColor = UIColor.init(hexString: "2772DB")
    let lightBlueColor = UIColor.init(hexString: "66ACF8")
    
    var realm = try! Realm()
    var registeredBabies : Results<Baby>?
    var babyApp = Baby()
    var allsleeps : Results<Sleep>?
    
    var sleepToSave = Sleep()
    
    @IBOutlet weak var textFieldStart: UITextField!
    @IBOutlet weak var textFieldEnd: UITextField!
    @IBOutlet weak var textFieldDuration: UITextField!

    @IBOutlet weak var saveButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldEnd.delegate = self
        textFieldStart.delegate = self
        textFieldDuration.delegate = self
        
        saveButton.layer.cornerRadius = 2
        saveButton.layer.masksToBounds = false
        saveButton.layer.shadowColor = UIColor.flatGray.cgColor
        saveButton.layer.shadowOpacity = 0.7
        saveButton.layer.shadowRadius = 1
 
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.barTintColor = lightBlueColor
        self.navigationController?.navigationBar.backgroundColor = lightBlueColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        loadBabiesAndSleep()
    }
    
    @IBAction func textFieldStartTouchedDown(_ sender: UITextField) {
        sender.textColor = grayLightColor
        sender.font = font
        DatePickerPopover(title: "Date" )
            .setDateMode(.dateAndTime)
            .setArrowColor(lightBlueColor!)
            .setSelectedDate(Date())
            .setDoneButton(title: "Done", font: self.fontLittle, color: .white, action: { popover, selectedDate in
                sender.text = self.dateStringFromDate(date: selectedDate)
                
                do{
                    
                    
                    try self.realm.write {
                        let date = DateCustom()
                        date.day = selectedDate.day
                        date.month = selectedDate.month
                        date.year = selectedDate.year
                        
                        self.sleepToSave.generalDateBegin = selectedDate
                        self.sleepToSave.dateBegin = date
                        
                        
                    }
                    
                }
                catch{
                    print(error)
                }
                
            })
            .appear(originView: sender, baseViewController: self)
    }
    @IBAction func textFieldEndTouchedDown(_ sender: UITextField) {
        sender.textColor = grayLightColor
        sender.font = font
        DatePickerPopover(title: "Date" )
            .setDateMode(.dateAndTime)
            .setArrowColor(lightBlueColor!)
            .setSelectedDate(Date())
            .setDoneButton(title: "Done", font: self.fontLittle, color: .white, action: { popover, selectedDate in
                sender.text = self.dateStringFromDate(date: selectedDate)
                
                do{

                    try self.realm.write {
                        let date = DateCustom()
                        date.day = selectedDate.day
                        date.month = selectedDate.month
                        date.year = selectedDate.year
                        
                        self.sleepToSave.generalDateEnd = selectedDate
                        self.sleepToSave.dateEnd = date

                    }
                    
                }
                catch{
                    print(error)
                }
                
            })
            .appear(originView: sender, baseViewController: self)
    }
    @IBAction func textFieldDurationTouchedDown(_ sender: UITextField) {
        sender.textColor = grayLightColor
        sender.font = font
        DatePickerPopover(title: "Date" )
            .setDateMode(.countDownTimer)
            .setArrowColor(lightBlueColor!)
            .setSelectedDate(Date())
            .setDoneButton(title: "Done", font: self.fontLittle, color: .white, action: { popover, selectedDate in
                sender.text = self.dateStringFromDate(date: selectedDate)
                
                do{
                    
                    try self.realm.write {
                        self.sleepToSave.timeSleep = self.dateStringFromDate(date: selectedDate)
                        

                    }
                    
                }
                catch{
                    print(error)
                }
                
            })
            .appear(originView: sender, baseViewController: self)
    }
    
   
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(style: .alert)
        
        if babyApp.name.isEmpty || (textFieldEnd.text!.isEmpty && textFieldDuration.text!.isEmpty) || textFieldStart.text!.isEmpty {
            
            if babyApp.name.isEmpty{
                alert.set(title: "Error", font: font!, color: grayColor!)
                alert.set(message: "In order to save a sleep record at least one child has to be active in Babydoc.", font: fontLittle!, color: grayLightColor!)
            }
            else{
                alert.set(title: "Error", font: font!, color: grayColor!)
                alert.set(message: "In order to save a sleep record the start date and the end date or duration have to be filled in.", font: fontLittle!, color: grayLightColor!)
            }
            
            
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.show(animated: true, vibrate: false, style: .light, completion: nil)
        }
        else{
            
            print("save data")
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
    
   
    func loadBabiesAndSleep(){
        
        babyApp = Baby()
        registeredBabies = realm.objects(Baby.self)
    
        if registeredBabies?.count != 0 {
            for baby in registeredBabies!{
                if baby.current{
                    babyApp = baby
                }
            }
           
            
         //allsleeps = babyApp.sleeps.filter(NSPredicate(value: true))
            
        }

        
    }
    
    func saveData(){
        
        do{
            try realm.write {
                
                babyApp.sleeps.append(sleepToSave)
            }
        }
        catch{
            print(error)
        }
        
        
        
    }
    
    
    
}
extension SaveSleepViewController : UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField.tag == 1{
            return true
        }
        else{
            return false
        }
        
    }
}
