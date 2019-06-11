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
    
    
    @IBOutlet weak var switchy: UISwitch!
    
    let font = UIFont(name: "Avenir-Heavy", size: 17)
    let fontLittle = UIFont(name: "Avenir-Medium", size: 17)
    let grayColor = UIColor.init(hexString: "555555")
    let grayLightColor = UIColor.init(hexString: "7F8484")
    let darkBlueColor = UIColor.init(hexString: "2772DB")
    let lightBlueColor = UIColor.init(hexString: "82BAF8")
    let blueColor = UIColor.init(hexString: "66ACF8")
    
    var realm = try! Realm()
    var registeredBabies : Results<Baby>?
    var babyApp = Baby()
    var allsleeps : Results<Sleep>?
    
    var sleepToSave = Sleep()
    var sleepToEdit : Sleep?{
        didSet{
            loadSleepToEdit()
        }
    }
    var indicatorEdit = 0
    
    @IBOutlet weak var textFieldStart: UITextField!
    @IBOutlet weak var textFieldEnd: UITextField!
    @IBOutlet weak var textFieldDuration: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var endEdit = Date()
    var startEdit = Date()
    var durEdit = ""
    var startdayEdit = 0
    var startmonthEdit = 0
    var startyearEdit = 0
    var enddayEdit = 0
    var endmonthEdit = 0
    var endyearEdit = 0
    var duration = Float(0.0)
    var switchValue = true
    @IBOutlet weak var nightSleepLabel: UILabel!
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        
        switchValue = !switchValue
        if switchValue{
            nightSleepLabel.text = "Night-time sleep"
        }
        else{
            nightSleepLabel.text = "Nap-time sleep"
        }
        
        
    }
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
        if indicatorEdit != 0 {
            textFieldEnd.text = dateStringFromDate(date: sleepToEdit?.generalDateEnd ?? Date())
            textFieldStart.text = dateStringFromDate(date: sleepToEdit?.generalDateBegin ?? Date())
            textFieldDuration.text = sleepToEdit?.timeSleep
            if sleepToEdit!.nightSleep{
                switchy.setOn(true, animated: true)
            }
            else{
                switchy.setOn(false, animated: true)
                
            }
            
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.barTintColor = blueColor
        self.navigationController?.navigationBar.backgroundColor = blueColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        loadBabiesAndSleep()
        nightSleepLabel.text = "Night sleep"
    }
    
    func loadSleepToEdit(){
        
        
        indicatorEdit = 0
        
        
        if sleepToEdit?.timeSleepFloat != Float(0.0){
            
            indicatorEdit += 1
            startEdit = sleepToEdit!.generalDateBegin
            endEdit = sleepToEdit!.generalDateEnd
            duration = sleepToEdit!.timeSleepFloat
            startdayEdit = startEdit.day
            startmonthEdit = startEdit.month
            startyearEdit = startEdit.year

            enddayEdit = endEdit.day
            endmonthEdit = endEdit.month
            endyearEdit = endEdit.year
            switchValue = sleepToEdit!.nightSleep
        }
        
        
    }
    
    @IBAction func textFieldStartTouchedDown(_ sender: UITextField) {
        sender.textColor = grayLightColor
        sender.font = font
        DatePickerPopover(title: "Date" )
            .setDateMode(.dateAndTime)
            .setArrowColor(blueColor!)
            .setSelectedDate(Date())
            .setDoneButton(title: "Done", font: self.fontLittle, color: .white, action: { popover, selectedDate in
                sender.text = self.dateStringFromDate(date: selectedDate)
                
                do{
                    if self.indicatorEdit != 0 {
                        try self.realm.write {
                            self.startEdit = selectedDate
                            self.startdayEdit = selectedDate.day
                            self.startmonthEdit = selectedDate.month
                            self.startyearEdit = selectedDate.year
                            self.textFieldDuration.text = ""
                            self.textFieldEnd.text = ""
                            
                        }
                        
                    }
                    else{
                        try self.realm.write {
                            let date = DateCustom()
                            date.day = selectedDate.day
                            date.month = selectedDate.month
                            date.year = selectedDate.year
                            
                            self.startEdit = selectedDate
                            self.startdayEdit = selectedDate.day
                            self.startmonthEdit = selectedDate.month
                            self.startyearEdit = selectedDate.year

                            self.sleepToSave.dateBegin = date
                            self.sleepToSave.generalDateBegin = selectedDate
                            
                        }
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
            .setArrowColor(blueColor!)
            .setSelectedDate(Date())
            .setDoneButton(title: "Done", font: self.fontLittle, color: .white, action: { popover, selectedDate in
                sender.text = self.dateStringFromDate(date: selectedDate)
                do{
                    if self.indicatorEdit != 0 {
                        try self.realm.write {
                            self.endEdit = selectedDate
                            self.enddayEdit = selectedDate.day
                            self.endmonthEdit = selectedDate.month
                            self.endyearEdit = selectedDate.year
                            self.textFieldDuration.text = ""
                        }
                        
                    }
                    else{
                        try self.realm.write {
                            let date = DateCustom()
                            date.day = selectedDate.day
                            date.month = selectedDate.month
                            date.year = selectedDate.year
                            
                            self.endEdit = selectedDate
                            self.enddayEdit = selectedDate.day
                            self.endmonthEdit = selectedDate.month
                            self.endyearEdit = selectedDate.year
                            
                            self.sleepToSave.dateEnd = date
                            self.sleepToSave.generalDateEnd = selectedDate
                            
                        }
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
            .setArrowColor(blueColor!)
            .setSelectedDate(Date())
            .setDoneButton(title: "Done", font: self.fontLittle, color: .white, action: { popover, selectedDate in
                sender.text = self.dateStringFromDate2(date: selectedDate)
                do{
                    if self.indicatorEdit != 0 {
                        try self.realm.write {
                            self.durEdit = self.dateStringFromDate2(date: selectedDate)
                            let minutes = round((Float(selectedDate.minute)*100.0))/(60.0*100.0)
                            self.duration = Float(selectedDate.hour) + minutes
                            self.textFieldEnd.text = ""
                            
                        }
                        
                    }
                    else{
                        try self.realm.write {
                            
                            self.durEdit = self.dateStringFromDate2(date: selectedDate)
                            let minutes = round((Float(selectedDate.minute)*100.0))/(60.0*100.0)
                            self.sleepToSave.timeSleep = self.dateStringFromDate2(date: selectedDate)
                            self.sleepToSave.timeSleepFloat = Float(selectedDate.hour) + minutes
                            
                        }
                    }
                    
                }
                    
                catch{
                    print(error)
                }
                
                        
                        
               
                
            })
            .appear(originView: sender, baseViewController: self)
    }

    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        
        
        if babyApp.name.isEmpty || (textFieldEnd.text!.isEmpty && textFieldDuration.text!.isEmpty) || textFieldStart.text!.isEmpty {
            
            let alert = UIAlertController(style: .alert)
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
        
            
        else if !textFieldDuration.text!.isEmpty && !textFieldEnd.text!.isEmpty{
            
            
            let alert = UIAlertController(style: .actionSheet)
            alert.set(message: "Both the end time and the duration were introduced, select one of them", font: fontLittle!, color: grayLightColor!)
            
            let actionend = UIAlertAction(title: "Just end time", style: .default) { (alertAction) in
                
                if self.indicatorEdit != 0{
                    self.saveData(valueToSave: "End", sleepToEdit: self.sleepToEdit!)
                }
                else{
                    self.saveData(valueToSave: "End", sleepToSave: self.sleepToSave)
                }
                
                
                
                }
                
            
            let actiondur = UIAlertAction(title: "Just duration", style: .default, handler: { (alertAction) in
                
                if self.indicatorEdit != 0{
                    self.saveData(valueToSave: "Duration", sleepToEdit: self.sleepToEdit!)
                }
                else{
                    self.saveData(valueToSave: "Duration", sleepToSave: self.sleepToSave)
                }
                
               
                
            })
            
            alert.addAction(actionend)
            alert.addAction(actiondur)
            alert.show(animated: true, vibrate: false, style: .light, completion: nil)
            
        }
        else{
            if textFieldEnd.text!.isEmpty{
               
                if self.indicatorEdit != 0{
                    self.saveData(valueToSave: "Duration", sleepToEdit: self.sleepToEdit!)
                }
                else{
                    self.saveData(valueToSave: "Duration", sleepToSave: self.sleepToSave)
                }
                
            }
            else if textFieldDuration.text!.isEmpty{
                print(startEdit)
                print(endEdit)
                if startEdit.compare(endEdit) == .orderedDescending{
                    
                    let alert = UIAlertController(style: .alert)
                    
                    alert.set(title: "Error", font: self.font!, color: self.grayColor!)
                    alert.set(message: "Sleep end time is earlier than start time, please change any of them.", font: self.fontLittle!, color: self.grayLightColor!)
                    let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    
                    alert.addAction(action)
                    alert.show(animated: true, vibrate: false, style: .light, completion: nil)
                    
                }
                else{
                    if self.indicatorEdit != 0{
                        self.saveData(valueToSave: "End", sleepToEdit: self.sleepToEdit!)
                    }
                    else{
                        self.saveData(valueToSave: "End", sleepToSave: self.sleepToSave)
                    }
                    
                   
                }
               
            }

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
    var _dateFormatter2: DateFormatter?
    var dateFormatter2: DateFormatter {
        if (_dateFormatter2 == nil) {
            _dateFormatter2 = DateFormatter()
            _dateFormatter2!.locale = Locale(identifier: "en_US_POSIX")
            _dateFormatter2!.dateFormat = "HH:mm"
        }
        return _dateFormatter2!
    }
    
    func dateStringFromDate(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    func dateStringFromDate2(date: Date) -> String {
        return dateFormatter2.string(from: date)
    }
    func dateFromString2(dateString : String)->Date{
        return dateFormatter2.date(from: dateString)!
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
         
            
        }
        
        
    }
    
    func saveData(valueToSave : String, sleepToSave : Sleep){
        
        do{
            try realm.write {
                
                switch valueToSave{
                    
                case "Duration":
                    
                    var dateFromStringDuration = dateFormatter2.date(from: durEdit)
                    
                    var dateComponent = DateComponents()
                    dateComponent.hour = dateFromStringDuration?.hour
                    dateComponent.minute = dateFromStringDuration?.minute
                    
                    let checkDate = Calendar.current.date(byAdding: dateComponent, to: self.startEdit)
                    
                    var intercept = false
                    for sleep in babyApp.sleeps{
                       
                        if startEdit.isBetween(sleep.generalDateBegin, and: sleep.generalDateEnd) || (checkDate?.isBetween(sleep.generalDateBegin, and: sleep.generalDateEnd))! {

                            let alert = UIAlertController(style: .alert)
                            
                            alert.set(title: "Error", font: self.font!, color: self.grayColor!)
                            alert.set(message: "Trying to save a sleep record that is already saved.", font: self.fontLittle!, color: self.grayLightColor!)
                            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                            
                            alert.addAction(action)
                            alert.show(animated: true, vibrate: false, style: .light, completion: nil)
                            
                            intercept = true
                            break
                            
                        }
                        
                        
                    }
                  
                    if intercept == false{

                        sleepToSave.generalDateEnd = checkDate!
                        
                        let dateend  = DateCustom()
                        dateend.day = checkDate!.day
                        dateend.month = checkDate!.month
                        dateend.year = checkDate!.year
                        
                        sleepToSave.dateEnd = dateend

                        sleepToSave.nightSleep = switchValue
                        babyApp.sleeps.append(sleepToSave)
                        
                        let image = UIImage(named: "doubletick")!
                        let hudViewController = APESuperHUD(style: .icon(image: image, duration: 1.5), title: nil, message: "Sleep record saved correctly!")
                        HUDAppearance.cancelableOnTouch = true
                        HUDAppearance.messageFont = self.fontLittle!
                        HUDAppearance.messageTextColor = self.grayColor!
                        
                        self.present(hudViewController, animated: true)
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    
                    
                case "End": 
                
                var dateComponentend = DateComponents()
                dateComponentend.hour = self.endEdit.hour
                dateComponentend.minute = self.endEdit.minute

                var dateComponentstart = DateComponents()
                dateComponentstart.hour = self.startEdit.hour
                dateComponentstart.minute = self.startEdit.minute
               

                
                var difference = Calendar.current.dateComponents([ .minute], from: dateComponentstart, to: dateComponentend).minute
                
                
                if endEdit.day > startEdit.day{
                    difference = 24*60 + difference!
                }
              
                var (hours, mins) = (difference?.quotientAndRemainder(dividingBy: 60))!
              
                if hours < 0 {
                    hours = hours*(-1)
                }
                if mins < 0{
                    mins = mins*(-1)
                }
                let formattedDuration = String(format: "%02d:%02d", hours, mins)
                var intercept = false
                for sleep in babyApp.sleeps{
                    
                    
                    if startEdit.isBetween(sleep.generalDateBegin, and: sleep.generalDateEnd) || endEdit.isBetween(sleep.generalDateBegin, and: sleep.generalDateEnd) {
                        
                        let alert = UIAlertController(style: .alert)
                        
                        alert.set(title: "Error", font: self.font!, color: self.grayColor!)
                        alert.set(message: "Trying to save a sleep record that is already saved.", font: self.fontLittle!, color: self.grayLightColor!)
                        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        
                        alert.addAction(action)
                        alert.show(animated: true, vibrate: false, style: .light, completion: nil)
                        
                        intercept = true
                        break
                        
                    }
                    
                    
                }
                
                if hours >= 24 {
                    let alert = UIAlertController(style: .alert)
                    
                    alert.set(title: "Error", font: self.font!, color: self.grayColor!)
                    alert.set(message: "The time of sleep is greater than 24 hours, please change the end time.", font: self.fontLittle!, color: self.grayLightColor!)
                    let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    
                    alert.addAction(action)
                    alert.show(animated: true, vibrate: false, style: .light, completion: nil)
                }
                
                else if hours < 24 && intercept == false{
             
                    sleepToSave.timeSleep = formattedDuration
                    let minutes = round((Float(mins)*10.0))/(60.0*10.0)
                    sleepToSave.timeSleepFloat = Float(hours) + minutes
                    sleepToSave.nightSleep = switchValue
                    babyApp.sleeps.append(sleepToSave)
                    
                    let image = UIImage(named: "doubletick")!
                    let hudViewController = APESuperHUD(style: .icon(image: image, duration: 1.5), title: nil, message: "Sleep record saved correctly!")
                    HUDAppearance.cancelableOnTouch = true
                    HUDAppearance.messageFont = self.fontLittle!
                    HUDAppearance.messageTextColor = self.grayColor!
                    
                    self.present(hudViewController, animated: true)
                    self.navigationController?.popViewController(animated: true)
                }

                    
                default:
                    babyApp.sleeps.append(sleepToSave)
                    self.navigationController?.popViewController(animated: true)
                    
                    
                    
                }
                
                
               
                
            }
        }
        catch{
            print(error)
        }
        
        
        
    }
    func saveData(valueToSave : String, sleepToEdit : Sleep){
        
        do{
            try realm.write {
                
                switch valueToSave{
                    
                case "Duration":
                    
                    var dateFromStringDuration = dateFormatter2.date(from: durEdit)
                    
                    var dateComponent = DateComponents()
                    dateComponent.hour = dateFromStringDuration?.hour
                    dateComponent.minute = dateFromStringDuration?.minute
                    
                    let checkDate = Calendar.current.date(byAdding: dateComponent, to: self.startEdit)
                    
                    var intercept = false
                    for sleep in babyApp.sleeps{
                        
                        if sleep.generalDateBegin != startEdit{
                        
                            
                            if startEdit.isBetween(sleep.generalDateBegin, and: sleep.generalDateEnd) || (checkDate?.isBetween(sleep.generalDateBegin, and: sleep.generalDateEnd))! {
                                
                                let alert = UIAlertController(style: .alert)
                                
                                alert.set(title: "Error", font: self.font!, color: self.grayColor!)
                                alert.set(message: "Trying to save a sleep record that is already saved.", font: self.fontLittle!, color: self.grayLightColor!)
                                let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                                
                                alert.addAction(action)
                                alert.show(animated: true, vibrate: false, style: .light, completion: nil)
                                
                                intercept = true
                                break
                                
                            }
                        }
                        
                        
                        
                    }
                    
                    if intercept == false{
                 
                        sleepToEdit.dateEnd?.day = checkDate!.day
                        sleepToEdit.dateEnd?.month = checkDate!.month
                        sleepToEdit.dateEnd?.year = checkDate!.year
                        
                        sleepToEdit.timeSleep = durEdit
                        sleepToEdit.generalDateEnd = checkDate!
                        sleepToEdit.timeSleepFloat = duration
                 
                        sleepToEdit.dateBegin?.day = startdayEdit
                        sleepToEdit.dateBegin?.month = startmonthEdit
                        sleepToEdit.dateBegin?.year = startyearEdit
                        sleepToEdit.generalDateBegin = startEdit
                        sleepToEdit.nightSleep = switchValue
                        
                        
                        let image = UIImage(named: "doubletick")!
                        let hudViewController = APESuperHUD(style: .icon(image: image, duration: 1.5), title: nil, message: "Sleep record editted correctly!")
                        HUDAppearance.cancelableOnTouch = true
                        HUDAppearance.messageFont = self.fontLittle!
                        HUDAppearance.messageTextColor = self.grayColor!
                        
                        self.present(hudViewController, animated: true)
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    
                    
                case "End":
                    
                    var dateComponentend = DateComponents()
                    dateComponentend.hour = self.endEdit.hour
                    dateComponentend.minute = self.endEdit.minute
                    
                    var dateComponentstart = DateComponents()
                    dateComponentstart.hour = self.startEdit.hour
                    dateComponentstart.minute = self.startEdit.minute
                    
                    
                    
                    var difference = Calendar.current.dateComponents([ .minute], from: dateComponentstart, to: dateComponentend).minute
                    
                    
                    if endEdit.day > startEdit.day{
                        difference = 24*60 + difference!
                    }
                    
                    var (hours, mins) = (difference?.quotientAndRemainder(dividingBy: 60))!
                    
                    if hours < 0 {
                        hours = hours*(-1)
                    }
                    if mins < 0{
                        mins = mins*(-1)
                    }
                    let formattedDuration = String(format: "%02d:%02d", hours, mins)
                    var intercept = false
                    for sleep in babyApp.sleeps{
                        
                        if sleep.generalDateBegin != startEdit{
                        if startEdit.isBetween(sleep.generalDateBegin, and: sleep.generalDateEnd) || endEdit.isBetween(sleep.generalDateBegin, and: sleep.generalDateEnd) {
                            
                            let alert = UIAlertController(style: .alert)
                            
                            alert.set(title: "Error", font: self.font!, color: self.grayColor!)
                            alert.set(message: "Trying to save a sleep record that is already saved.", font: self.fontLittle!, color: self.grayLightColor!)
                            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                            
                            alert.addAction(action)
                            alert.show(animated: true, vibrate: false, style: .light, completion: nil)
                            
                            intercept = true
                            break
                            
                        }
                        }
                        
                        
                    }
                    
                    if hours >= 24 {
                        let alert = UIAlertController(style: .alert)
                        
                        alert.set(title: "Error", font: self.font!, color: self.grayColor!)
                        alert.set(message: "The time of sleep is greater than 24 hours, please change the end time.", font: self.fontLittle!, color: self.grayLightColor!)
                        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        
                        alert.addAction(action)
                        alert.show(animated: true, vibrate: false, style: .light, completion: nil)
                    }
                        
                    else if hours < 24 && intercept == false{

                        sleepToEdit.dateEnd?.day = enddayEdit
                        sleepToEdit.dateEnd?.month = endmonthEdit
                        sleepToEdit.dateEnd?.year = endyearEdit
                    
                        
                        sleepToEdit.timeSleep = formattedDuration
                        let minutes = round((Float(mins)*10.0))/(60.0*10.0)
                        sleepToEdit.timeSleepFloat = Float(hours) + minutes
                        sleepToEdit.generalDateEnd = endEdit
  
                        
                        sleepToEdit.dateBegin?.day = startdayEdit
                        sleepToEdit.dateBegin?.month = startmonthEdit
                        sleepToEdit.dateBegin?.year = startyearEdit
                        sleepToEdit.generalDateBegin = startEdit
                        sleepToEdit.nightSleep = switchValue
                        
                        let image = UIImage(named: "doubletick")!
                        let hudViewController = APESuperHUD(style: .icon(image: image, duration: 1.5), title: nil, message: "Sleep record editted correctly!")
                        HUDAppearance.cancelableOnTouch = true
                        HUDAppearance.messageFont = self.fontLittle!
                        HUDAppearance.messageTextColor = self.grayColor!
                        
                        self.present(hudViewController, animated: true)
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    
                default:
                    
                    sleepToEdit.dateBegin?.day = startdayEdit
                    sleepToEdit.dateBegin?.month = startmonthEdit
                    sleepToEdit.dateBegin?.year = startyearEdit
                    sleepToEdit.generalDateBegin = startEdit
                    sleepToEdit.nightSleep = switchValue
                    self.navigationController?.popViewController(animated: true)
                    
                    
                    
                }
                
                
                
                
            }
        }
        catch{
            print(error)
        }
        
        
        
    }
    
    
    
}
extension SaveSleepViewController : UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return false
        
    }
}
//extension Date {
//    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
//        var dates: [Date] = []
//        var date = fromDate
//
//        while date <= toDate  {
//            dates.append(date)
//            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
//            date = newDate
//        }
//        return dates
//}
extension Date {
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
}

