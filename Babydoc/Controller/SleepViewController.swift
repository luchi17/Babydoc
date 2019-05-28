//
//  SleepViewController.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 22/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import UIKit
import RealmSwift


class SleepViewController : UIViewController{
    
    let darkBlueColor = UIColor.init(hexString: "2772DB")
    let blueColor = UIColor.init(hexString: "66ACF8")
    
    var realm = try! Realm()
    var registeredBabies : Results<Baby>?
    var babyApp : Baby?
    var selectedDay = Date()
    
    @IBOutlet weak var avgWeekLabel: UILabel!
    @IBOutlet weak var avgWeekField: UILabel!
    @IBOutlet weak var avgMonthLabel: UILabel!
    @IBOutlet weak var avgMonthField: UILabel!
    
    //var dict = []
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM YYYY"
        todayButton.setTitle("Today, "+formatter.string(from: Date()), for: .normal)
        todayButton.setTitleColor(blueColor, for: .normal)
        todayButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 18)
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
    
    override func willMove(toParent parent: UIViewController?) {
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "64C5CF")
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
            self.med0.setNeedsDisplay()
            self.med0.reloadInputViews()
            self.med1.setNeedsDisplay()
            self.med1.reloadInputViews()
            self.med2.setNeedsDisplay()
            self.med2.reloadInputViews()
            self.med3.setNeedsDisplay()
            self.med3.reloadInputViews()
            self.med4.setNeedsDisplay()
            self.med4.reloadInputViews()
            self.med5.setNeedsDisplay()
            self.med5.reloadInputViews()
            self.med6.setNeedsDisplay()
            self.med6.reloadInputViews()
        
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
        self.med0.setNeedsDisplay()
        self.med0.reloadInputViews()
        self.med1.setNeedsDisplay()
        self.med1.reloadInputViews()
        self.med2.setNeedsDisplay()
        self.med2.reloadInputViews()
        self.med3.setNeedsDisplay()
        self.med3.reloadInputViews()
        self.med4.setNeedsDisplay()
        self.med4.reloadInputViews()
        self.med5.setNeedsDisplay()
        self.med5.reloadInputViews()
        self.med6.setNeedsDisplay()
        self.med6.reloadInputViews()
        
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
        nextButton.isEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.barTintColor = blueColor
        self.navigationController?.navigationBar.backgroundColor = blueColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
       
        loadBabies()
        
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
        if Calendar.current.isDate(selectedDay, inSameDayAs: Date()){
            
            nextButton.isEnabled = false
        }
        
        
        
    }
    func loadBabies(){
        
        babyApp = Baby()
        registeredBabies = realm.objects(Baby.self).filter("current == %@", true)
        if registeredBabies?.count != 0{
            for baby in registeredBabies!{
                babyApp = baby
            }
            
        }
        if !(babyApp?.name.isEmpty)!{
            loadSleepsThisWeek(date: selectedDay)
            
            
            //calcAvgMonth()
            
        }
        
    }
    
    func setInfoData(avg : Float, label : UILabel, labelField : UILabel, string : String){
        
        let integer = floor(avg)
        let decimal = avg.truncatingRemainder(dividingBy: 1)
        if integer != 0 && Int(decimal) != 0{
            label.text = "\(Int(integer)) h \(Int(decimal*60)) min"
            labelField.text = "/day of \(string)"

        }
        else if integer != 0 && Int(decimal) == 0{
            label.text = "\(Int(integer)) h"
            labelField.text = "/day of \(string)"
            
        }
        else if integer == 0 && Int(decimal) != 0{
            label.text = "\(Int(decimal*60)) min"
            labelField.text = "/day of \(string)"
            
        }
        else if integer == 0 && Int(decimal) == 0{
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
        setInfoData(avg: avg, label: avgWeekLabel, labelField: avgWeekField, string: "sleep-time")
        let avg1 = calcAvgWeek( nightOrNap: false)
        setInfoData(avg: avg1, label : avgMonthLabel, labelField: avgMonthField, string: "nap-time")
        
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

        avg = sum/Float(arrayDatesGeneral.count)
        
        
        
        

        
        return avg
       
        }
    
    
    func calcAvgMonth(){
        
        var arrayAvgDay = Array<Float>()
        var min = babyApp!.sleeps[0]
        
        for sleep in babyApp!.sleeps{
            
            if sleep.dateBegin!.day < min.dateBegin!.day{
                min = sleep
            }
        }
        let initDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        let arrayAllDates = Date.dates(from: initDate , to: Date())
        
        var durationFloat = Float(0.0)
        var counterDur2 = 0
        
        for date in arrayAllDates{
            
            counterDur2 = 0
            durationFloat = Float(0.0)
            
            for sleep in babyApp!.sleeps{
                
                
                if sleep.dateBegin?.day == date.day && sleep.dateBegin?.month == date.month && sleep.dateBegin?.day == sleep.dateEnd?.day{
                    durationFloat = durationFloat + sleep.timeSleepFloat
                    counterDur2 += 1
                    
                    
                }
                else if sleep.dateBegin?.day == date.day && sleep.dateBegin?.month == date.month && sleep.dateBegin!.day < sleep.dateEnd!.day{
                    
                    let minutes = round((Float(sleep.generalDateBegin.minute)*100.0))/(60.0*100.0)
                    let duration = Float(sleep.generalDateBegin.hour) + minutes
                    
                    durationFloat = durationFloat + 24.0 - duration
                    counterDur2 += 1
                }
                else if date.day == sleep.dateEnd?.day && sleep.dateEnd?.month == date.month{
                    
                    
                    let minutes = round((Float(sleep.generalDateEnd.minute)*100.0))/(60.0*100.0)
                    let duration = Float(sleep.generalDateEnd.hour) + minutes
                    durationFloat = durationFloat + duration
                    counterDur2 += 1
                }
                
            }
            if counterDur2 != 0{
                arrayAvgDay.append(durationFloat/Float(counterDur2))
            }
            
            
        }
        
        
        
        var sum1 = Float(0.0)
        var avg1 = Float(0.0)
        for value in arrayAvgDay{
            
            sum1 = sum1 + value
            
        }
       
       
        
        avg1 = sum1/Float(arrayAllDates.count)
       
        let integer1 = floor(avg1)
        let decimal1 = avg1.truncatingRemainder(dividingBy: 1)
        
        if integer1 != 0 && decimal1 != 0{
            avgMonthLabel.text = "\(Int(integer1)) h \(Int(decimal1*60)) min"
            avgMonthField.text = "/day this month"
        }
        else if integer1 != 0 && decimal1 == 0{
            avgMonthLabel.text = "\(Int(integer1)) h"
            avgMonthField.text = "/day this month"
        }
        else if integer1 == 0 && decimal1 != 0{
            avgMonthLabel.text = "\(Int(decimal1*60)) min"
            avgMonthField.text = "/day this month"
        }
        else if integer1 == 0 && decimal1 == 0{
            avgMonthLabel.text = ""
            avgMonthField.text = ""
        }
        
        
        
        
    }
    
    
    

        
        
    }
    
    
    

class ActionViewSleep: UIView
    
{
    
    let napColor = UIColor.init(hexString: "66ACF8")
    var sleepcolor :UIColor = UIColor.init(hexString: "2772db")!
    
    var arrayAllDates = Array<Date>()
    var arrayDateToday = Array<Date>()
    var arrayAllDatesSleepsBegin = Array<Date>()
    var arrayAllDatesSleepsEnd = Array<Date>()
    var arrayDateTodaySleepsBegin = Array<Date>()
    var arrayDateTodaySleepsEnd = Array<Date>()
    var arrayDateTodaySleepsDurationBegin = Array<Float>()
    var arrayColors = Array<Bool>()
    var selectedDay : Date?{
        didSet{
            
        }
    }
    var sleeps : Results<Sleep>?
    var dict = [Date : Float]()
    var dictColors = [Date : Bool]()
    
    
    func fillColor(start : CGFloat,with color:UIColor,width:CGFloat)
    {
        let topRect = CGRect(x : start, y:0, width : width, height: self.bounds.height)
        color.setFill()
        UIRectFill(topRect)
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    
    
    func setDay(day : Date){
        selectedDay = day
    }
    
    override func draw(_ rect: CGRect)
    {
        let width = self.bounds.width
        let day : CGFloat = 24
        
        switch tag {
        case 0:
            
            for i in 0..<arrayDateTodaySleepsBegin.count{
                
                let value = Float(arrayDateTodaySleepsBegin[i].minute * 100)/(60 * 100)
                let final = Float(arrayDateTodaySleepsBegin[i].hour) + value
                
                let width1 = CGFloat(arrayDateTodaySleepsDurationBegin[i])
                
                if arrayColors[i]{
                    
             
                    self.fillColor(start : (CGFloat(final)*width)/day, with: sleepcolor, width: (width1*width)/day)
                   
                }
                else{
                 
                    self.fillColor(start : (CGFloat(final)*width)/day, with: napColor!, width: (width1*width)/day)
                    
                }
                
                
                
                
            }
            for date in  arrayDateTodaySleepsEnd{
                
                let value = Float(date.minute * 100)/(60 * 100)
                let final = Float(date.hour) + value
                
                self.fillColor(start : (CGFloat(0)*width)/day, with: sleepcolor, width: (CGFloat(final)*width)/day)
                
                
            }
            
            
        case 1:
            
            for i in 0..<arrayDateTodaySleepsBegin.count{
                
                let value = Float(arrayDateTodaySleepsBegin[i].minute * 100)/(60 * 100)
                let final = Float(arrayDateTodaySleepsBegin[i].hour) + value
                
                let width1 = CGFloat(arrayDateTodaySleepsDurationBegin[i])
                
                
                if arrayColors[i]{
                    
                    
                    self.fillColor(start : (CGFloat(final)*width)/day, with: sleepcolor, width: (width1*width)/day)
                }
                else{
                  
                    self.fillColor(start : (CGFloat(final)*width)/day, with: napColor!, width: (width1*width)/day)
                }
                
                
            }
            for date in  arrayDateTodaySleepsEnd{
                
                let value = Float(date.minute * 100)/(60 * 100)
                let final = Float(date.hour) + value
                
                self.fillColor(start : (CGFloat(0)*width)/day, with: sleepcolor, width: (CGFloat(final)*width)/day)
                
                
            }
            
        case 2:
            
            for i in 0..<arrayDateTodaySleepsBegin.count{
                
                let value = Float(arrayDateTodaySleepsBegin[i].minute * 100)/(60 * 100)
                let final = Float(arrayDateTodaySleepsBegin[i].hour) + value
                
                let width1 = CGFloat(arrayDateTodaySleepsDurationBegin[i])
                
                if arrayColors[i]{
                    
                   
                    self.fillColor(start : (CGFloat(final)*width)/day, with: sleepcolor, width: (width1*width)/day)
                }
                else{
                    
                    self.fillColor(start : (CGFloat(final)*width)/day, with: napColor!, width: (width1*width)/day)
                }

                
                
            }
            for date in  arrayDateTodaySleepsEnd{
                
                let value = Float(date.minute * 100)/(60 * 100)
                let final = Float(date.hour) + value
                
                self.fillColor(start : (CGFloat(0)*width)/day, with: sleepcolor, width: (CGFloat(final)*width)/day)
                
                
            }
            
        case 3:
            
            for i in 0..<arrayDateTodaySleepsBegin.count{
                
                let value = Float(arrayDateTodaySleepsBegin[i].minute * 100)/(60 * 100)
                let final = Float(arrayDateTodaySleepsBegin[i].hour) + value
                
                let width1 = CGFloat(arrayDateTodaySleepsDurationBegin[i])
                
                if arrayColors[i]{
                    
                 
                    self.fillColor(start : (CGFloat(final)*width)/day, with: sleepcolor, width: (width1*width)/day)
                }
                else{
                   
                    self.fillColor(start : (CGFloat(final)*width)/day, with: napColor!, width: (width1*width)/day)
                }
             
                
                
            }
            for date in  arrayDateTodaySleepsEnd{
                
                let value = Float(date.minute * 100)/(60 * 100)
                let final = Float(date.hour) + value
                
                self.fillColor(start : (CGFloat(0)*width)/day, with: sleepcolor, width: (CGFloat(final)*width)/day)
                
                
            }
            
        case 4:
            
            for i in 0..<arrayDateTodaySleepsBegin.count{
                
                let value = Float(arrayDateTodaySleepsBegin[i].minute * 100)/(60 * 100)
                let final = Float(arrayDateTodaySleepsBegin[i].hour) + value
                
                let width1 = CGFloat(arrayDateTodaySleepsDurationBegin[i])
                
                if arrayColors[i]{
                    
                    self.fillColor(start : (CGFloat(final)*width)/day, with: sleepcolor, width: (width1*width)/day)
                }
                else{
                   
                    self.fillColor(start : (CGFloat(final)*width)/day, with: napColor!, width: (width1*width)/day)
                }
                
               
                
                
            }
            for date in  arrayDateTodaySleepsEnd{
                
                let value = Float(date.minute * 100)/(60 * 100)
                let final = Float(date.hour) + value
                
                self.fillColor(start : (CGFloat(0)*width)/day, with: sleepcolor, width: (CGFloat(final)*width)/day)
                
                
            }
            
        case 5:
            
            
            for i in 0..<arrayDateTodaySleepsBegin.count{
                
                let value = Float(arrayDateTodaySleepsBegin[i].minute * 100)/(60 * 100)
                let final = Float(arrayDateTodaySleepsBegin[i].hour) + value
                
                let width1 = CGFloat(arrayDateTodaySleepsDurationBegin[i])
                
                if arrayColors[i]{
                    
                
                    self.fillColor(start : (CGFloat(final)*width)/day, with: sleepcolor, width: (width1*width)/day)
                }
                else{
                    
                    self.fillColor(start : (CGFloat(final)*width)/day, with: napColor!, width: (width1*width)/day)
                }
                
                
                
            }
            for date in  arrayDateTodaySleepsEnd{
                
                let value = Float(date.minute * 100)/(60 * 100)
                let final = Float(date.hour) + value
                
                self.fillColor(start : (CGFloat(0)*width)/day, with: sleepcolor, width: (CGFloat(final)*width)/day)
                
                
            }
            
        case 6:
            
            for i in 0..<arrayDateTodaySleepsBegin.count{
                
                let value = Float(arrayDateTodaySleepsBegin[i].minute * 100)/(60 * 100)
                let final = Float(arrayDateTodaySleepsBegin[i].hour) + value
                
                let width1 = CGFloat(arrayDateTodaySleepsDurationBegin[i])
                
                if arrayColors[i]{
                    
           
                    self.fillColor(start : (CGFloat(final)*width)/day, with: sleepcolor, width: (width1*width)/day)
                }
                else{
                    
                    self.fillColor(start : (CGFloat(final)*width)/day, with: napColor!, width: (width1*width)/day)
                }
                
              
                
                
            }
            for date in  arrayDateTodaySleepsEnd{
                
                let value = Float(date.minute * 100)/(60 * 100)
                let final = Float(date.hour) + value
                
                self.fillColor(start : (CGFloat(0)*width)/day, with: sleepcolor, width: (CGFloat(final)*width)/day)
                
                
            }
        default:
            break
        }
        
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
    
    
    
    func loadSleepRecords(baby : Baby, day : Date){
        
        sleeps = baby.sleeps.filter(NSPredicate(value: true))
        
        arrayAllDatesSleepsBegin = []
        arrayAllDatesSleepsEnd = []
        arrayDateTodaySleepsDurationBegin = []
        dict = [:]
        dictColors = [:]
        arrayColors = []
        
        for sleep in sleeps!{
            
            
            arrayAllDatesSleepsBegin.append(sleep.generalDateBegin)
            arrayAllDatesSleepsEnd.append(sleep.generalDateEnd)
            dict[sleep.generalDateBegin] = sleep.timeSleepFloat
            dictColors[sleep.generalDateBegin] = sleep.nightSleep
        }
        
        arrayDateTodaySleepsEnd = []
        arrayDateTodaySleepsBegin = []
        
        
       
        
        for date in arrayAllDatesSleepsBegin{
            
            if Calendar.current.isDate(date, inSameDayAs: day){
                
                arrayDateTodaySleepsBegin.append(date)
            }
            
        }
        for date in dict.keys{
            
            
            if Calendar.current.isDate(date, inSameDayAs: day){
                
                arrayDateTodaySleepsDurationBegin.append(dict[date]!)
                
            }
            
        }
        for date in dictColors.keys{
            if Calendar.current.isDate(date, inSameDayAs: day){
                
                arrayColors.append(dictColors[date]!)
                
            }
        }

        
        for i in 0..<arrayAllDatesSleepsEnd.count{
            
            if Calendar.current.isDate(arrayAllDatesSleepsEnd[i], inSameDayAs: day) {
                
                var dateBegin = arrayAllDatesSleepsBegin[i]
                if dateBegin.day < arrayAllDatesSleepsEnd[i].day {
                    arrayDateTodaySleepsEnd.append(arrayAllDatesSleepsEnd[i])
                }
                
            }
            
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
