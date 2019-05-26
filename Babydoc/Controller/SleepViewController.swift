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
    }
    
    override func willMove(toParent parent: UIViewController?) {
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "64C5CF")
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
       
        
        selectedDay = Calendar.current.date(byAdding: .day, value: 7, to: selectedDay)!
        
        DispatchQueue.main.async{
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
        }
        if selectedDay.day < Date().day{
            sender.isEnabled = true
        }
            
        else if Calendar.current.isDate(selectedDay, inSameDayAs: Date()){
            
            sender.isEnabled = false
        }
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        selectedDay = Calendar.current.date(byAdding: .day, value: -7, to: selectedDay)!
        DispatchQueue.main.async{
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
        }
        
        if selectedDay.day < Date().day{
            nextButton.isEnabled = true
        }
            
        else if Calendar.current.isDate(selectedDay, inSameDayAs: Date()){
            
            nextButton.isEnabled = false
        }
       
    }
    
    @IBAction func todayButtonPressed(_ sender: UIButton) {
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.barTintColor = blueColor
        self.navigationController?.navigationBar.backgroundColor = blueColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        loadAllSleeps()
        loadBabies()
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
    }
    func loadSleepsThisWeek(date : Date){
        
        arrayDatesGeneral = Array<Date>()
        arrayDatesCustom = Array<DateCustom>()
        
        for i in 0..<7{
            
            var date = Calendar.current.date(byAdding: .day, value: -i, to: date)!
            arrayDatesGeneral.append(date)
            var dateCustom = DateCustom()
            dateCustom.day = date.day
            dateCustom.month = date.month
            dateCustom.year = date.year
            arrayDatesCustom.append(dateCustom)
            
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
        
        
        
    }

    
    
    func loadAllSleeps(){
        
        babyApp = Baby()
        registeredBabies = realm.objects(Baby.self).filter("current == %@", true)
        if registeredBabies?.count != 0{
            for baby in registeredBabies!{
                babyApp = baby
            }

        }
        
    }

    
}
class ActionViewSleep: UIView
    
{
    
    
    var sleepcolor :UIColor = UIColor.init(hexString: "2772db")!

    var arrayAllDates = Array<Date>()
    var arrayDateToday = Array<Date>()
    var arrayAllDatesSleepsBegin = Array<Date>()
    var arrayAllDatesSleepsEnd = Array<Date>()
    var arrayDateTodaySleepsBegin = Array<Date>()
    var arrayDateTodaySleepsEnd = Array<Date>()
    var arrayDateTodaySleepsDurationBegin = Array<Float>()
    var selectedDay : Date?{
        didSet{
            
        }
    }
    var realm = try! Realm()
    var sleeps : Results<Sleep>?
    var dict = [Date : Float]()

    
    
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
        //SLEEP
        
        switch tag {
        case 0:

            for i in 0..<arrayDateTodaySleepsBegin.count{
                
                let value = Float(arrayDateTodaySleepsBegin[i].minute * 100)/(60 * 100)
                let final = Float(arrayDateTodaySleepsBegin[i].hour) + value
                
                let width1 = CGFloat(arrayDateTodaySleepsDurationBegin[i])
                
                
                self.fillColor(start : (CGFloat(final)*width)/day, with: sleepcolor, width: (width1*width)/day)
                
                
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
                
                
                self.fillColor(start : (CGFloat(final)*width)/day, with: sleepcolor, width: (width1*width)/day)
                
                
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
                
                
                self.fillColor(start : (CGFloat(final)*width)/day, with: sleepcolor, width: (width1*width)/day)
                
                
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
                
                
                self.fillColor(start : (CGFloat(final)*width)/day, with: sleepcolor, width: (width1*width)/day)
                
                
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
                
                
                self.fillColor(start : (CGFloat(final)*width)/day, with: sleepcolor, width: (width1*width)/day)
                
                
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
                
                
                self.fillColor(start : (CGFloat(final)*width)/day, with: sleepcolor, width: (width1*width)/day)
                
                
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
                
                
                self.fillColor(start : (CGFloat(final)*width)/day, with: sleepcolor, width: (width1*width)/day)
                
                
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
        
        for sleep in sleeps!{
            
            
            arrayAllDatesSleepsBegin.append(sleep.generalDateBegin)
            arrayAllDatesSleepsEnd.append(sleep.generalDateEnd)
            var dateFromStringSleep = dateFormatter2.date(from: sleep.timeSleep)
            let width = round((Float(dateFromStringSleep!.minute)*10.0))/(60.0*10.0)
            dict[sleep.generalDateBegin] = Float(dateFromStringSleep!.hour) + width
        }
        
        arrayDateTodaySleepsEnd = []
        arrayDateTodaySleepsBegin = []
        
        
        for date in arrayAllDatesSleepsBegin{

            if Calendar.current.isDate(date, inSameDayAs: day){
                
                arrayDateTodaySleepsBegin.append(date)
            }
            
        }
        for date in dict.keys{
            
            
            if Calendar.current.isDate(date, inSameDayAs: selectedDay ?? Date()){
                
                arrayDateTodaySleepsDurationBegin.append(dict[date]!)
                
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
