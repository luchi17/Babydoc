//
//  ActionViewSleep.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 28/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//


import UIKit
import RealmSwift


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
