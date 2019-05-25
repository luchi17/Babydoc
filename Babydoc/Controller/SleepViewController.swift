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
    var allsleeps : Results<Sleep>?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func willMove(toParent parent: UIViewController?) {
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "64C5CF")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.barTintColor = blueColor
        self.navigationController?.navigationBar.backgroundColor = blueColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        loadAllSleeps()
       
        
        
    }
    func loadAllSleeps(){
        
        babyApp = Baby()
        registeredBabies = realm.objects(Baby.self).filter("current == %@", true)
        if registeredBabies?.count != 0{
            for baby in registeredBabies!{
                babyApp = baby
            }
       
            //allsleeps = realm.objects(Sleep.self).filter("%@ IN parentBaby", babyApp!)
        }

       loadSleepsThisWeek()
        
    }
    func loadSleepsThisWeek(){
        
        var arrayDatesGeneral = Array<Date>()
        var arrayDatesCustom = Array<DateCustom>()
        
        for i in 0..<7{
            
            var date = Calendar.current.date(byAdding: .day, value: i, to: Date())!
            arrayDatesGeneral.append(date)
            var dateCustom = DateCustom()
            dateCustom.day = date.day
            dateCustom.month = date.month
            dateCustom.year = date.year
            arrayDatesCustom.append(dateCustom)
            
        }
        
        
        
        
        
    }
}
class ActionViewSleep: UIView
    
{
    
    
    var sleepcolor :UIColor = UIColor.init(hexString: "2772db")!

    var arrayAllDates = Array<Date>()
    var arrayDateToday = Array<Date>()
    var selectedDay : Date?{
        didSet{
            
        }
    }
    
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
        
        switch self.tag {
            
        case 0:
            
            fillColor(start : (0*width)/day ,with: sleepcolor, width: (2*width)/day)
            fillColor(start : ((12+0.5)*width)/day ,with: sleepcolor , width: (1*width)/day)
            fillColor(start : (15*width)/day ,with: sleepcolor , width: (2*width)/day)
        
        
        default:
            print("TAG NOT FOUND")
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
    
    
}
