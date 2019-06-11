//
//  SleepViewController.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 22/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import UIKit
import RealmSwift
import Charts



class SleepViewController : UIViewController, ChartViewDelegate{
    
    let darkBlueColor = UIColor.init(hexString: "2772DB")
    let blueColor = UIColor.init(hexString: "66ACF8")
    let lightBlueColor = UIColor.init(hexString: "82BAF8")
    var realm = try! Realm()
    var registeredBabies : Results<Baby>?
    var babyApp : Baby?
    var selectedDay = Date()
    
    @IBOutlet weak var avgWeekLabel: UILabel!
    @IBOutlet weak var avgWeekField: UILabel!
    @IBOutlet weak var avgMonthLabel: UILabel!
    @IBOutlet weak var avgMonthField: UILabel!

    
    var arrayDatesGeneral = Array<Date>()
    var arrayDatesCustom = Array<DateCustom>()
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var todayButton: UIButton!
    
    
    @IBOutlet weak var med0: ActionViewSleep!
    @IBOutlet weak var med1: ActionViewSleep!
    @IBOutlet weak var med2: ActionViewSleep!
    @IBOutlet weak var med3: ActionViewSleep!
    @IBOutlet weak var med4: ActionViewSleep!
    @IBOutlet weak var med5: ActionViewSleep!
    @IBOutlet weak var med6: ActionViewSleep!
    @IBOutlet weak var first: UILabel!
    @IBOutlet weak var second: UILabel!
    @IBOutlet weak var third: UILabel!
    @IBOutlet weak var forth: UILabel!
    @IBOutlet weak var fifth: UILabel!
    @IBOutlet weak var sixth: UILabel!
    @IBOutlet weak var seventh: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appearanceView()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "64C5CF")
    }
    
    func appearanceView(){
        
        nextButton.layer.cornerRadius = 4
        backButton.layer.cornerRadius = 4
        med0.layer.cornerRadius = 4
        med0.layer.masksToBounds = true
        med1.layer.cornerRadius = 4
        med1.layer.masksToBounds = true
        med2.layer.cornerRadius = 4
        med2.layer.masksToBounds = true
        med3.layer.cornerRadius = 4
        med3.layer.masksToBounds = true
        med4.layer.cornerRadius = 4
        med4.layer.masksToBounds = true
        med5.layer.cornerRadius = 4
        med5.layer.masksToBounds = true
        med6.layer.cornerRadius = 4
        med6.layer.masksToBounds = true

        todayButton.setTitle("Go to current week", for: .normal)
        todayButton.setTitleColor(blueColor, for: .normal)
        todayButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
        todayButton.backgroundColor = UIColor.white
        let spacing : CGFloat = 8.0
        todayButton.contentEdgeInsets = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        todayButton.layer.cornerRadius = 2
        todayButton.layer.masksToBounds = false
        todayButton.layer.shadowColor = UIColor.flatGray.cgColor
        todayButton.layer.shadowOpacity = 0.7
        todayButton.layer.shadowRadius = 1
        todayButton.layer.shadowOffset = CGSize(width: 2, height: 2)
       
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
    
    func dateStringFromDate2(date: Date) -> String {
        return dateFormatter2.string(from: date)
    }
    func dateFromString2(dateString : String)->Date{
        return dateFormatter2.date(from: dateString)!
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        
        
        selectedDay = Calendar.current.date(byAdding: .day, value: 7, to: selectedDay)!
        
        
        self.loadSleepsThisWeek(date: self.selectedDay)
        reloadChart()
        
        if selectedDay.day < Date().day{
            sender.isEnabled = true
        }
            
        else if Calendar.current.isDate(selectedDay, inSameDayAs: Date()){
            
            sender.isEnabled = false
        }
        
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        selectedDay = Calendar.current.date(byAdding: .day, value: -7, to: selectedDay)!
        self.loadSleepsThisWeek(date: self.selectedDay)
        reloadChart()
        if selectedDay.day < Date().day{
            nextButton.isEnabled = true
        }
            
        else if Calendar.current.isDate(selectedDay, inSameDayAs: Date()){
            
            nextButton.isEnabled = false
        }
        
    }
    
    @IBAction func todayButtonPressed(_ sender: UIButton) {
        selectedDay = Date()
        loadSleepsThisWeek(date: selectedDay)
        reloadChart()
        nextButton.isEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.barTintColor = blueColor
        self.navigationController?.navigationBar.backgroundColor = blueColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        
        loadBabies()
        reloadChart()
        
        if Calendar.current.isDate(selectedDay, inSameDayAs: Date()){
            
            nextButton.isEnabled = false
        }
        
        
    }
    func reloadChart(){
        med0.setNeedsDisplay()
        med0.reloadInputViews()
        med1.setNeedsDisplay()
        med1.reloadInputViews()
        med2.setNeedsDisplay()
        med2.reloadInputViews()
        med3.setNeedsDisplay()
        med3.reloadInputViews()
        med4.setNeedsDisplay()
        med4.reloadInputViews()
        med5.setNeedsDisplay()
        med5.reloadInputViews()
        med6.setNeedsDisplay()
        med6.reloadInputViews()
    }
    func loadBabies(){
        
        babyApp = Baby()
        registeredBabies = realm.objects(Baby.self).filter("current == %@", true)
        if registeredBabies?.count != 0{
            for baby in registeredBabies!{
                babyApp = baby
            }
            
        }
        if !(babyApp?.name.isEmpty)! && babyApp?.sleeps.count != 0{
            loadSleepsThisWeek(date: selectedDay)

        }
        
    }
    
    func setInfoData(avg : Float, label : UILabel, labelField : UILabel, string : String){
        
        let integer = floor(avg)
        let decimal = avg.truncatingRemainder(dividingBy: 1)
        if integer != 0 && Int(decimal*60) != 0{
            label.text = "\(Int(integer))h \(Int(decimal*60))min"
            labelField.text = "/day of \(string)"
            
        }
        else if integer != 0 && Int(decimal*60) == 0{
            label.text = "\(Int(integer)) h"
            labelField.text = "/day of \(string)"
            
        }
        else if integer == 0 && Int(decimal*60) != 0{
            label.text = "\(Int(decimal*60)) min"
            labelField.text = "/day of \(string)"
            
        }
        else if integer == 0 && Int(decimal*60) == 0{
            label.text = ""
            labelField.text = ""
        }
        
        
        
    }
    func loadSleepsThisWeek(date : Date){
        
        arrayDatesGeneral = Array<Date>()
        
        for i in 0..<7{
            
            let date = Calendar.current.date(byAdding: .day, value: -i, to: date)!
            arrayDatesGeneral.append(date)
            
        }
        
        med0.loadSleepRecords(baby: babyApp!, day: arrayDatesGeneral[0])
        med1.loadSleepRecords(baby: babyApp!, day: arrayDatesGeneral[1])
        med2.loadSleepRecords(baby: babyApp!, day: arrayDatesGeneral[2])
        med3.loadSleepRecords(baby: babyApp!, day: arrayDatesGeneral[3])
        med4.loadSleepRecords(baby: babyApp!, day: arrayDatesGeneral[4])
        med5.loadSleepRecords(baby: babyApp!, day: arrayDatesGeneral[5])
        med6.loadSleepRecords(baby: babyApp!, day: arrayDatesGeneral[6])
        
        let formatterFirst = DateFormatter()
        formatterFirst.dateFormat = "\nMM/dd"
        let formatter = DateFormatter()
        formatter.dateFormat = "EE\nMM/dd"
        
        if Calendar.current.isDate(selectedDay, inSameDayAs: Date()){
            
            first.text = "Today" + formatterFirst.string(from: arrayDatesGeneral[0])
        }
        else{
            
            first.text = formatter.string(from: arrayDatesGeneral[0])
        }
        
        second.text = formatter.string(from: arrayDatesGeneral[1])
        third.text = formatter.string(from: arrayDatesGeneral[2])
        forth.text = formatter.string(from: arrayDatesGeneral[3])
        fifth.text = formatter.string(from: arrayDatesGeneral[4])
        sixth.text = formatter.string(from: arrayDatesGeneral[5])
        seventh.text = formatter.string(from: arrayDatesGeneral[6])
        
        let avg = calcAvgWeek(nightOrNap: true)
        setInfoData(avg: avg, label: avgWeekLabel, labelField: avgWeekField, string: "night sleep")
        let avg1 = calcAvgWeek( nightOrNap: false)
        setInfoData(avg: avg1, label : avgMonthLabel, labelField: avgMonthField, string: "nap sleep")
        
        let formatterlabel = DateFormatter()
        formatterlabel.dateFormat = "MMMM"
        
        weekLabel.text = "\(arrayDatesGeneral[6].day)-\(arrayDatesGeneral[0].day) " + formatterlabel.string(from: arrayDatesGeneral[0])
    }

    
    func calcAvgWeek(nightOrNap : Bool)->Float{
        
        var arrayAvgWeek = Array<Float>()
        var durationFloat1 = Float(0.0)
        var counterDur = 0
        
        
        for date in arrayDatesGeneral{
            
            counterDur = 0
            durationFloat1 = Float(0.0)
            for sleep in babyApp!.sleeps{
                
                if Calendar.current.isDate(sleep.generalDateBegin, inSameDayAs: date) && sleep.generalDateBegin.day == sleep.generalDateEnd.day && sleep.nightSleep == nightOrNap{
                    
                    durationFloat1 = durationFloat1 + sleep.timeSleepFloat
                    counterDur += 1
                    
                    
                }
                else if Calendar.current.isDate(sleep.generalDateBegin, inSameDayAs: date) && sleep.generalDateBegin.day < sleep.generalDateEnd.day && sleep.nightSleep == nightOrNap{
                    
                    let minutes = round((Float(sleep.generalDateBegin.minute)*100.0))/(60.0*100.0)
                    let duration = Float(sleep.generalDateBegin.hour) + minutes
                    
                    durationFloat1 = durationFloat1 + 24.0 - duration
                    counterDur += 1
                }
                else if Calendar.current.isDate(sleep.generalDateEnd, inSameDayAs: date) && sleep.nightSleep == nightOrNap{
                    
                    
                    let minutes = round((Float(sleep.generalDateEnd.minute)*100.0))/(60.0*100.0)
                    let duration = Float(sleep.generalDateEnd.hour) + minutes
                    durationFloat1 = durationFloat1 + duration
                    counterDur += 1
                }
                
            }
            if counterDur != 0{
                arrayAvgWeek.append(durationFloat1/(Float(counterDur)))
            }
            
            
            
        }
        
        var sum = Float(0.0)
        var avg = Float(0.0)
        for value in arrayAvgWeek{
            
            sum = sum + value
            
        }
        
        if arrayAvgWeek.count != 0{
            avg = sum/Float(arrayAvgWeek.count)
        }
        
        

        return avg
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? HistorySleepViewController{
            destinationVC.babyApp = babyApp
        }
    }

    
  
}





extension Date {
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate  {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
}
