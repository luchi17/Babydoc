//
//  PercentilViewController.swift
//  ChildCare
//
//  Created by Luchi Parejo alcazar on 30/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
class PercentilViewController : UIViewController{
    
    let darkBlueColor = UIColor.init(hexString: "2772DB")
    let blueColor = UIColor.init(hexString: "66ACF8")
    let font = UIFont(name: "Avenir-Heavy", size: 17)
    let fontLight = UIFont(name: "Avenir-Medium", size: 17)
    let grayColor = UIColor.init(hexString: "555555")
    let grayLightColor = UIColor.init(hexString: "7F8484")
    @IBOutlet weak var nightActionView: ActionViewPercentil!
    @IBOutlet weak var napActionView: ActionViewPercentil!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var avgNightLabel: UILabel!
    @IBOutlet weak var avgNapLabel: UILabel!
    @IBOutlet weak var lowPnight: UILabel!
    @IBOutlet weak var highPnight: UILabel!
    @IBOutlet weak var highPnap: UILabel!
    @IBOutlet weak var lowPnap: UILabel!
  
    var initDateAvg = Date()
    
    var realm = try! Realm()
    var registeredChildren : Results<Child>?
    var childApp = Child()
    var age = Float(0.0)
    var lowPercentilNight = Float(0.0)
    var highPercentilNight = Float(0.0)
    var lowPercentilNap = Float(0.0)
    var highPercentilNap = Float(0.0)
    
    var dictNight = [Float: [Float]]()
    var dictNap = [Float: [Float]]()
    let arrayAges : [Float] = [0.08, 0.25, 0.5, 0.75, 1, 1.5, 2, 3, 4]
    var avgNight = Float(0.0)
    var avgNap = Float(0.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.barTintColor = blueColor
        self.navigationController?.navigationBar.backgroundColor = blueColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        loadChildren()
        DispatchQueue.main.async {

                if self.registeredChildren!.count > 0 && !self.childApp.name.isEmpty && self.childApp.dateOfBirth.isEmpty{
                    
                    let controller = UIAlertController(title: nil, message: "To see the age-specific reference percentiles of sleep durations enter the date of birth of \(self.childApp.name)", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "Remind me later", style: .default) { (alertAction) in
                        alertAction.isEnabled = false
                    }
                    let changeDob = UIAlertAction(title: "Enter date of birth", style: .cancel) { (alertAction) in
                        self.performSegue(withIdentifier: "goToChangeDob", sender: self)
                    }
                    
                    controller.setTitle(font: self.font!, color: self.grayColor!)
                    controller.setMessage(font: self.fontLight!, color: self.grayLightColor!)
                    controller.addAction(action)
                    controller.addAction(changeDob)
                    controller.show(animated: true, vibrate: false, style: .light, completion: nil)
                    
                }
                else if self.childApp.name.isEmpty && self.registeredChildren!.count > 0{
                    
                    let controller = UIAlertController(title: nil, message: "There are no active children in ChildCare.", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "Ok", style: .default)
                    
                    controller.setTitle(font: self.font!, color: self.grayColor!)
                    controller.setMessage(font: self.fontLight!, color: self.grayLightColor!)
                    controller.addAction(action)
                    controller.show(animated: true, vibrate: false, style: .light, completion: nil)
                    
                    
                }
                else if self.childApp.name.isEmpty && self.registeredChildren!.count == 0{
                    
                    let controller = UIAlertController(title: nil, message: "There are no registered children in ChildCare.", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "Ok", style: .default)
                    
                    controller.setTitle(font: self.font!, color: self.grayColor!)
                    controller.setMessage(font: self.fontLight!, color: self.grayLightColor!)
                    controller.addAction(action)
                    controller.show(animated: true, vibrate: false, style: .light, completion: nil)
                    
                    
                }
           
        }
        
        
       
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "goToChangeDob"{ 
            if childApp.name.isEmpty{
                return false
            }
            else{
                return true
            }
        }
        else{
            return true
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationVC = segue.destination as? ChildInfoViewController {
            
            
            destinationVC.selectedChild  = childApp
            destinationVC.navigationItem.title = destinationVC.selectedChild?.name
            if #available(iOS 11.0, *) {
                destinationVC.navigationItem.largeTitleDisplayMode = .always
                destinationVC.navigationController?.navigationBar.prefersLargeTitles = true
                
            }
            segue.destination.navigationController?.navigationBar.tintColor = UIColor(hexString: "64C5CF")
        }

    }
    
    
    func loadChildren(){
        
       
        childApp = Child()
        registeredChildren = realm.objects(Child.self)
        if registeredChildren?.count != 0{
            for child in registeredChildren!{
                if child.current == true{
                    childApp = child
                }
                
            }
            
        }
        if !childApp.name.isEmpty && !childApp.dateOfBirth.isEmpty && childApp.sleeps.count == 0{
            
            loadDictionariesPercentils()
            calcAge(birthday: childApp.dateOfBirth)
            loadSpecificPercentils()
            setLabelAgeAndPercentiles()


        }
        else if !childApp.name.isEmpty && !childApp.dateOfBirth.isEmpty && childApp.sleeps.count != 0{
            
            loadDictionariesPercentils()
            calcAge(birthday: childApp.dateOfBirth)
            loadSpecificPercentils()
            setLabelAgeAndPercentiles()
            setNightAndNapAvg()
        }
        
        
        
    }
    
    func setLabelAgeAndPercentiles(){
        
        ageLabel.text = "\(childApp.name) is \(childApp.age)old"
        
        let nightHours : CGFloat = 14
        let napHours : CGFloat = 10
        
        var xhighnight = (nightActionView.bounds.width * CGFloat(highPercentilNight))/nightHours
        xhighnight = 35 + xhighnight
        var xlownap = (nightActionView.bounds.width * CGFloat(lowPercentilNap))/napHours
        xlownap = 35 + xlownap
        var xhighnap = (nightActionView.bounds.width * CGFloat(highPercentilNap))/napHours
        xhighnap = 35 + xhighnap
        
        let integer1 = floor(lowPercentilNight)
        let decimal1 = lowPercentilNight.truncatingRemainder(dividingBy: 1)
        let integer2 = floor(highPercentilNight)
        let decimal2 = highPercentilNight.truncatingRemainder(dividingBy: 1)
        let integer3 = floor(lowPercentilNap)
        let decimal3 = lowPercentilNap.truncatingRemainder(dividingBy: 1)
        let integer4 = floor(highPercentilNap)
        let decimal4 = highPercentilNap.truncatingRemainder(dividingBy: 1)
        if Int(integer1) != 0 && Int(decimal1*60) != 0{
            lowPnight.text = "2nd percentile: \(Int(integer1))h \(Int(decimal1*60))min"
        }
        else if Int(integer1) == 0 && Int(decimal1*60) != 0 {
            lowPnight.text = "2nd percentile: \(Int(decimal1*60))min"
        }
        else if Int(integer1) != 0 && Int(decimal1*60) == 0{
            lowPnight.text = "2nd percentile: \(Int(integer1))h"
        }
        
        if Int(integer2) != 0 && Int(decimal2*60) != 0{
            highPnight.text = "98th percentile: \(Int(integer2))h \(Int(decimal2*60))min "
        }
        else if Int(integer2) == 0 && Int(decimal2*60) != 0 {
            highPnight.text = "98th percentile: \(Int(decimal2*60))min "
        }
        else if Int(integer2) != 0 && Int(decimal2*60) == 0{
            highPnight.text = "98th percentile: \(Int(integer2))h"
        }
        
        if Int(integer3) != 0 && Int(decimal3*60) != 0{
            lowPnap.text = "2nd percentile: \(Int(integer3))h \(Int(decimal3*60))min"
        }
        else if Int(integer3) == 0 && Int(decimal3*60) != 0 {
            lowPnap.text = "2nd percentile: \(Int(decimal3*60))min"
        }
        else if Int(integer3) != 0 && Int(decimal3*60) == 0{
            lowPnap.text = "2nd percentile: \(Int(integer3))h"
        }
        
        if Int(integer4) != 0 && Int(decimal4*60) != 0{
            highPnap.text = "98th percentile: \(Int(integer4))h \(Int(decimal4*60))min"
        }
        else if Int(integer4) == 0 && Int(decimal4*60) != 0 {
            highPnap.text = "98th percentile: \(Int(decimal4*60))min"
        }
        else if Int(integer4) != 0 && Int(decimal4*60) == 0{
            highPnap.text = "98th percentile: \(Int(integer4))h"
        }
    
        nightActionView.lowPercentilNight = lowPercentilNight
        nightActionView.highPercentilNight = highPercentilNight
        napActionView.lowPercentilNap = lowPercentilNap
        napActionView.highPercentilNap = highPercentilNap
    
    }
    
    func setNightAndNapAvg(){
    
        let avgNight = calcAvgMonth(nightOrNap: true)
        let avgNap = calcAvgMonth(nightOrNap: false)
        nightActionView.avgNight = avgNight
        napActionView.avgNap = avgNap
        let intnight = floor(Double(avgNight))
        let decimalnight = avgNight.truncatingRemainder(dividingBy: 1)
        let intnap = floor(Double(avgNap))
        let decimalnap = avgNap.truncatingRemainder(dividingBy: 1)
        
        
        if (Int(intnight) == 0 && Int(decimalnight*60) == 0){
            avgNightLabel.text = ""
            
        }
        else if (Int(intnight) == 0 && Int(decimalnight*60) != 0){
            
            avgNightLabel.text = "\(Int(decimalnight*60))min"
            
        }
        else if (Int(intnight) != 0 && Int(decimalnight*60) == 0){
            
            avgNightLabel.text = "\(Int(intnight))h"
        }
        else if (Int(intnight) != 0 && Int(decimalnight*60) != 0){
            
            avgNightLabel.text = "\(Int(intnight))h \(Int(decimalnight*60))min"
        }
        if Int(intnap) == 0 && Int(decimalnap*60) == 0{
            avgNapLabel.text = ""
        }
        else if (Int(intnap) != 0 && Int(decimalnap*60) == 0){
            avgNapLabel.text = "\(Int(intnap))h"
        }
        else if (Int(intnap) != 0 && Int(decimalnap*60) != 0){
            avgNapLabel.text = "\(Int(intnap))h \(Int(decimalnap*60))min"
        }
        else if (Int(intnap) == 0 && Int(decimalnap*60) != 0){
            avgNapLabel.text = "\(Int(decimalnap*60))min"
        }

    }

    func calcAvgMonth(nightOrNap : Bool)->Float{
        
        var arrayAvgDay = Array<Float>()

        let arrayAllDates = Date.dates(from: initDateAvg , to: Date())
        
        var durationFloat = Float(0.0)
        var counterDur = 0
        
        for date in arrayAllDates{
            
            counterDur = 0
            durationFloat = Float(0.0)
            
            for sleep in childApp.sleeps{
                
                
                if sleep.dateBegin?.day == date.day && sleep.dateBegin?.month == date.month && sleep.dateBegin?.year == date.year && sleep.dateBegin?.day == sleep.dateEnd?.day && sleep.nightSleep == nightOrNap{
                    durationFloat = durationFloat + sleep.timeSleepFloat
                    counterDur += 1
                    
                    
                }
                else if sleep.dateBegin?.day == date.day && sleep.dateBegin?.month == date.month && sleep.dateBegin?.year == date.year && sleep.dateBegin!.day < sleep.dateEnd!.day && sleep.nightSleep == nightOrNap{
                    
                    let minutes = round((Float(sleep.generalDateBegin.minute)*100.0))/(60.0*100.0)
                    let duration = Float(sleep.generalDateBegin.hour) + minutes
                    
                    durationFloat = durationFloat + 24.0 - duration
                    counterDur += 1
                }
                else if date.day == sleep.dateEnd?.day && sleep.dateEnd?.month == date.month && sleep.dateBegin?.year == date.year &&  sleep.nightSleep == nightOrNap{
                    
                    
                    let minutes = round((Float(sleep.generalDateEnd.minute)*100.0))/(60.0*100.0)
                    let duration = Float(sleep.generalDateEnd.hour) + minutes
                    durationFloat = durationFloat + duration
                    counterDur += 1
                }
                
            }
            if counterDur != 0{
                arrayAvgDay.append(durationFloat/Float(counterDur))
                
            }
            
            
        }
        
        
        
        var sum1 = Float(0.0)
        var avg1 = Float(0.0)
        for value in arrayAvgDay{
            
            sum1 = sum1 + value
            
        }
        
        if arrayAvgDay.count != 0{
             avg1 = sum1/Float(arrayAvgDay.count)
        }
        
        return avg1
        
    }
    
    func loadDictionariesPercentils(){
        
        dictNight[arrayAges[0]] = [6.0, 13.2]
        dictNight[arrayAges[1]] = [6.8, 13.2]
        dictNight[arrayAges[2]] = [8.8, 13.2]
        dictNight[arrayAges[3]] = [9.2, 13.3]
        dictNight[arrayAges[4]] = [9.7, 13.6]
        dictNight[arrayAges[5]] = [9.7, 13.5]
        dictNight[arrayAges[6]] = [9.7, 13.4]
        dictNight[arrayAges[7]] = [9.7, 13.1]
        dictNight[arrayAges[8]] = [9.6, 12.8]
        
        dictNap[arrayAges[0]] = [2.0, 9.0]
        dictNap[arrayAges[1]] = [1.5, 8.0]
        dictNap[arrayAges[2]] = [0.4, 6.4]
        dictNap[arrayAges[3]] = [0.2, 5.3]
        dictNap[arrayAges[4]] = [0.2, 4.6]
        dictNap[arrayAges[5]] = [0.5, 3.6]
        dictNap[arrayAges[6]] = [0.7, 2.9]
        dictNap[arrayAges[7]] = [0.8, 2.6]
        dictNap[arrayAges[8]] = [0.7, 2.4]
        
        
    }
    
    func loadSpecificPercentils(){
        
        var mindistance = arrayAges[0] - age
        var proximateAge = Float(0.0)
        for value in arrayAges{
            
            if (value - age) <= mindistance && value < age {
                mindistance = abs(value - age)
                proximateAge = value
            }
            
        }

        var percentil = Float(0.0)
        
        for counter in 0..<dictNight.keys.count{
            
            percentil = Array(dictNight.keys)[counter]
            
            if abs(percentil-proximateAge) == 0{
                lowPercentilNight = (dictNight[percentil]?[0])!
                highPercentilNight = (dictNight[percentil]?[1])!
                
            }
            
            
        }
        
        
        for counter in 0..<dictNap.keys.count{
            
            percentil = Array(dictNap.keys)[counter]
            
            if abs(percentil-proximateAge) == 0{
                
                lowPercentilNap = (dictNap[percentil]?[0])!
                highPercentilNap = (dictNap[percentil]?[1])!
                
            }
            
        }
        
        let integer = floor(proximateAge)
        let decimal = proximateAge.truncatingRemainder(dividingBy: 1)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let dateOfBirth = dateFormatter.date(from: childApp.dateOfBirth)!
        
        
        if integer >= 1 { //year
            initDateAvg =  Calendar.current.date(byAdding: .year, value: Int(integer), to: dateOfBirth)!
            
            if Int(decimal*12) != 0{
                initDateAvg =  Calendar.current.date(byAdding: .month, value: Int(decimal*12), to: initDateAvg)!
            }
            let monthAndDay = decimal*12
            
            if monthAndDay.truncatingRemainder(dividingBy: 1) != 0{
                initDateAvg = Calendar.current.date(byAdding: .day, value: Int(monthAndDay.truncatingRemainder(dividingBy: 1)*30), to: initDateAvg)!
            }
        }
        else{//month
           initDateAvg =  Calendar.current.date(byAdding: .month, value: Int(decimal*12), to: dateOfBirth)!
            let monthAndDay = decimal*12
            
            if monthAndDay.truncatingRemainder(dividingBy: 1) != 0{
                initDateAvg = Calendar.current.date(byAdding: .day, value: Int(monthAndDay.truncatingRemainder(dividingBy: 1)*30), to: initDateAvg)!
            }
            
            
        }
       
        

        
    }
    
    
    func calcAge(birthday: String) {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: birthday)
        
        let myDOB = Calendar.current.date(from: DateComponents(year: date?.year, month: date?.month, day: date?.day))!
        let myAge = Calendar.current.dateComponents([.month], from: myDOB, to: Date()).month!
        let years = myAge / 12
        let months = myAge % 12
        
        if months != 0 && years != 0{
            self.age = Float(years) + Float(months)/12
        }
        else if months == 0 && years != 0{
            
            self.age = Float(years)
        }
        else if months != 0 && years == 0 {
            self.age = Float(years) + Float(months)/12
        }
        else if months == 0 && years == 0{
            self.age = Float(0.0)
        }
        
        let birthday = Calendar.current.date(from: DateComponents(year: date?.year, month: date?.month, day: date?.day))!
        
        let days = Calendar.current.dateComponents([.day], from: birthday, to: Date()).day!
        
        let year = Float(days)/Float(365)

       
        
        
    }
    
    

    
    
}
