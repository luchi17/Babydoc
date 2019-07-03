//
//  ActionView.swift
//  ChildCare
//
//  Created by Luchi Parejo alcazar on 03/07/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//



import Foundation
import UIKit
import RealmSwift

class ActionView: UIView
    
{
    
    
    var sleepcolor :UIColor = UIColor.init(hexString: "2772db")!
    var feedcolor :UIColor = UIColor.init(hexString: "85ef47")!
    var diapercolor :UIColor = UIColor.init(hexString: "37D4C0")!
    var medicationcolor :UIColor = UIColor.init(hexString: "F54291")!
    
    var doses : Results<MedicationDoseAdministered>?
    var sleeps : Results<Sleep>?
    var arrayAllDatesDoses = Array<Date>()
    var arrayDateTodayDoses = Array<Date>()
    var arrayAllDatesSleepsBegin = Array<Date>()
    var arrayAllDatesSleepsEnd = Array<Date>()
    var arrayDateTodaySleepsBegin = Array<Date>()
    var arrayDateTodaySleepsEnd = Array<Date>()
    
    var selectedDay : Date?{
        didSet{
            
        }
    }
    
    let napColor = UIColor.init(hexString: "66ACF8")
    
    
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
        
        
        switch self.tag {
            
        case 0:
            
            for i in 0..<arrayDateTodaySleepsBegin.count{
                
                let sleep = sleeps?.filter("generalDateBegin == %@", arrayDateTodaySleepsBegin[i])
                
                var width1  = Float(0.0)
                var sleeptime  = true
                
                for s in sleep!{
                    
                    width1 = s.timeSleepFloat
                    sleeptime = s.nightSleep
                }
                
                let value = Float(arrayDateTodaySleepsBegin[i].minute * 100)/(60 * 100)
                let final = Float(arrayDateTodaySleepsBegin[i].hour) + value
                
                if sleeptime{
                    
                    self.fillColor(start : (CGFloat(final)*width)/day, with: sleepcolor, width: (CGFloat(width1)*width)/day)
                    
                }
                else{
                    
                    self.fillColor(start : (CGFloat(final)*width)/day, with: napColor!, width: (CGFloat(width1)*width)/day)
                    
                }
                
                
            }
            for date in  arrayDateTodaySleepsEnd{
                
                let value = Float(date.minute * 100)/(60 * 100)
                let final = Float(date.hour) + value
                
                self.fillColor(start : (CGFloat(0)*width)/day, with: sleepcolor, width: (CGFloat(final)*width)/day)
                
                
            }
            
            
        //MEDICATION
        case 3:
            
            for date in arrayDateTodayDoses{
                
                let value = round(Float(date.minute)/(60))
                let final = Float(date.hour) + value
                
                
                self.fillColor(start : (CGFloat(final)*width)/day, with: medicationcolor, width: 0.15*width/day)
            }
            
            
            
        default:
            break
        }
        
    }
    func loadAdministeredDoses(child : Child){
        
        doses = child.medicationDoses.filter(NSPredicate(value: true))
        
        arrayAllDatesDoses = []
        for dose in doses!{
            
            arrayAllDatesDoses.append(dose.generalDate)
            
        }
        arrayDateTodayDoses = []
        for date in arrayAllDatesDoses{
            
            if selectedDay == nil{
                selectedDay = Date()
            }
            
            if Calendar.current.isDate(date, inSameDayAs: selectedDay!){
                
                arrayDateTodayDoses.append(date)
            }
            
        }
        
        
    }
    func loadSleepRecords(child : Child){
        
        sleeps = child.sleeps.filter(NSPredicate(value: true))
        
        arrayAllDatesSleepsBegin = []
        arrayAllDatesSleepsEnd = []
        
        
        for sleep in sleeps!{
            
            
            arrayAllDatesSleepsBegin.append(sleep.generalDateBegin)
            arrayAllDatesSleepsEnd.append(sleep.generalDateEnd)
            
        }
        
        
        arrayDateTodaySleepsEnd = []
        arrayDateTodaySleepsBegin = []
        
        for date in arrayAllDatesSleepsBegin{
            
            
            if Calendar.current.isDate(date, inSameDayAs: selectedDay!){
                
                arrayDateTodaySleepsBegin.append(date)
            }
            
        }
        
        
        
        
        for i in 0..<arrayAllDatesSleepsEnd.count{
            
            if Calendar.current.isDate(arrayAllDatesSleepsEnd[i], inSameDayAs: selectedDay!) {
                
                var dateBegin = arrayAllDatesSleepsBegin[i]
                if dateBegin.day < arrayAllDatesSleepsEnd[i].day {
                    arrayDateTodaySleepsEnd.append(arrayAllDatesSleepsEnd[i])
                }
                
            }
            
        }
        
        
    }
    
    //MARK: Calc Date and String methods
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
    
    func dateFromString(dateString: String) -> Date? {
        return dateFormatter.date(from: dateString)
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
    
    
}

