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
    
    var realm = try! Realm()
    var registeredBabies : Results<Baby>?
    var babyApp : Baby?
    var selectedDay = Date()
    
    @IBOutlet weak var avgWeekLabel: UILabel!
    @IBOutlet weak var avgWeekField: UILabel!
    @IBOutlet weak var avgMonthLabel: UILabel!
    @IBOutlet weak var avgMonthField: UILabel!
    @IBOutlet weak var barChart: BarChartView!
    
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
    
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var leftaxis = [String]()
    var nightSleep = Array<Double>()
    var napSleep = Array<Double>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barChart.delegate = self
        barChart.noDataText = "You need to provide data for the chart."
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
    
    
    func appearancebarChart(){
        
        barChart.chartDescription?.enabled = false
        
        barChart.pinchZoomEnabled = false
        
        //legend
        let legend = barChart.legend
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = true
        legend.yOffset = 10.0;
        legend.xOffset = 10.0;
        legend.yEntrySpace = 0.0;
        
        let xAxis = barChart.xAxis
        xAxis.labelFont = UIFont(name: "Avenir-Medium", size: 13)!
        xAxis.labelTextColor = UIColor(hexString: "7F8484")!
        xAxis.granularity = 1
        xAxis.centerAxisLabelsEnabled = true
        xAxis.valueFormatter = IndexAxisValueFormatter(values:self.months)
        xAxis.drawGridLinesEnabled = true
        
        let leftAxis = barChart.leftAxis
        leftAxis.labelFont = UIFont(name: "Avenir-Book", size: 13)!
        xAxis.labelTextColor = UIColor(hexString: "555555")!
        leftAxis.spaceTop = 0.35
        leftAxis.axisMinimum = 0
        leftAxis.granularity = 1
        let chartFormatter = BarChartFormatter()
        leftAxis.valueFormatter = chartFormatter
        leftAxis.drawGridLinesEnabled = false
        
        barChart.rightAxis.enabled = false

        setChart()
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
        
        appearancebarChart()
        barChart.setNeedsDisplay()
        
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
            
            
            
            
        }
        
    }
    
    func setInfoData(avg : Float, label : UILabel, labelField : UILabel, string : String){
        
        let integer = floor(avg)
        let decimal = avg.truncatingRemainder(dividingBy: 1)
        if integer != 0 && Int(decimal*60) != 0{
            label.text = "\(Int(integer)) h \(Int(decimal*60)) min"
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
        
        
        setNightAndNapForChart()
        
        
        
        return avg
        
    }
    
    
    func setNightAndNapForChart(){
        
        nightSleep = []
        napSleep = []
        var min = babyApp!.sleeps[0]
        
        for sleep in babyApp!.sleeps{
            
            if sleep.dateBegin!.day < min.dateBegin!.day{
                min = sleep
            }
        }
        
        let yearComponents = Calendar.current.dateComponents([.year], from: min.generalDateBegin)
        
        let currentYear = Int(yearComponents.year!)
        
        var comp = DateComponents()
        comp.year = currentYear
        comp.day = 1
        
        for month in 1..<13{
            comp.month = month
            let avg = calcAvgMonth(dateComp: comp, nightOrNap: true)
            nightSleep.append(Double(avg))
            let avg1 = calcAvgMonth(dateComp: comp, nightOrNap: false)
            napSleep.append(Double(avg1))
            
        }
    
        
        
    }
    
    
    func calcAvgMonth(dateComp : DateComponents, nightOrNap : Bool)->Float{
        
        var arrayAvgDay = Array<Float>()
        
        let initDate = Calendar.current.date(from: dateComp)
        
        let endDate  = Calendar.current.date(byAdding: .month, value: 1, to: initDate!)
        
        let arrayAllDates = Date.dates(from: initDate! , to: endDate!)
        
        
        var durationFloat = Float(0.0)
        var counterDur2 = 0
        
        for date in arrayAllDates{
            
            counterDur2 = 0
            durationFloat = Float(0.0)
            
            for sleep in babyApp!.sleeps{
                
                
                if sleep.dateBegin?.day == date.day && sleep.dateBegin?.month == date.month && sleep.dateBegin?.day == sleep.dateEnd?.day && sleep.nightSleep == nightOrNap{
                    durationFloat = durationFloat + sleep.timeSleepFloat
                    counterDur2 += 1
                    
                    
                }
                else if sleep.dateBegin?.day == date.day && sleep.dateBegin?.month == date.month && sleep.dateBegin!.day < sleep.dateEnd!.day && sleep.nightSleep == nightOrNap{
                    
                    let minutes = round((Float(sleep.generalDateBegin.minute)*100.0))/(60.0*100.0)
                    let duration = Float(sleep.generalDateBegin.hour) + minutes
                    
                    durationFloat = durationFloat + 24.0 - duration
                    counterDur2 += 1
                }
                else if date.day == sleep.dateEnd?.day && sleep.dateEnd?.month == date.month && sleep.nightSleep == nightOrNap{
                    
                    
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
        
        
        return avg1
        
    }
    func setChart() {
        barChart.noDataText = "You need to provide data for the chart."
        var dataEntries: [BarChartDataEntry] = []
        var dataEntries1: [BarChartDataEntry] = []
        
        for i in 0..<self.months.count {
            
            let dataEntry = BarChartDataEntry(x: Double(i) , y: self.nightSleep[i])
            dataEntries.append(dataEntry)
            
            let dataEntry1 = BarChartDataEntry(x: Double(i) , y: self.self.napSleep[i])
            dataEntries1.append(dataEntry1)
            
            
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Night Sleep")
        let chartDataSet1 = BarChartDataSet(entries: dataEntries1, label: "Nap Sleep")
        
        let dataSets: [BarChartDataSet] = [chartDataSet,chartDataSet1]
        chartDataSet.colors = [darkBlueColor!]
        chartDataSet1.colors = [blueColor!]
        chartDataSet.drawValuesEnabled = false
        chartDataSet1.drawValuesEnabled = false
        
        let chartData = BarChartData(dataSets: dataSets)
        barChart.data = chartData
        
        
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3
        
        
        
        
        
        let groupCount = self.months.count
        let startYear = 0
        
        chartData.barWidth = barWidth;
        barChart.xAxis.axisMinimum = Double(startYear)
        let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        barChart.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)
        
        chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
        
        barChart.scaleYEnabled = false
        barChart.scaleXEnabled = true
        
        barChart.xAxis.axisMinimum = max(barChart.data!.xMin, barChart.data!.xMin)
        barChart.xAxis.axisMaximum = min(barChart.data!.xMax + 1, barChart.data!.xMax + 1)
        barChart.xAxis.labelCount = Int(barChart.xAxis.axisMaximum - barChart.xAxis.axisMinimum)
        barChart.setVisibleXRange(minXRange: 3.0, maxXRange: 5.0)
        
        
       
        
        
        
        
        
        barChart.leftAxis.axisMinimum = max(barChart.data!.yMin, barChart.data!.yMin)
        barChart.leftAxis.axisMaximum = min(barChart.data!.yMax + 1, barChart.data!.yMax + 1)
         barChart.leftAxis.labelCount = 10
        //= Int(barChart.leftAxis.axisMaximum - barChart.leftAxis.axisMinimum)
        
       
        //background color
        //barChart.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        barChart.data = chartData
        barChart.moveViewToX(4)
        barChart.notifyDataSetChanged()
        
        barChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
        
        
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


class YAxisValueFormatter: NSObject, IAxisValueFormatter {
    
    let numFormatter: NumberFormatter
    
    override init() {
        numFormatter = NumberFormatter()
        numFormatter.minimumFractionDigits = 1
        numFormatter.maximumFractionDigits = 1
        
        // if number is less than 1 add 0 before decimal
        numFormatter.minimumIntegerDigits = 1 // how many digits do want before decimal
        numFormatter.paddingPosition = .beforePrefix
        numFormatter.paddingCharacter = "0"
    }
    
    /// Called when a value from an axis is formatted before being drawn.
    ///
    /// For performance reasons, avoid excessive calculations and memory allocations inside this method.
    ///
    /// - returns: The customized label that is drawn on the axis.
    /// - parameter value:           the value that is currently being drawn
    /// - parameter axis:            the axis that the value belongs to
    ///
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return numFormatter.string(from: NSNumber(floatLiteral: value))!
    }
    
}



class BarChartFormatter: NSObject, IAxisValueFormatter {
    
    
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        let label = Label(rawValue: Int(round(value)))!
        return label.labeltype
    }

}
enum Label : Int {
    case zero
    case first
    case second
    case third
    case forth
    case fifth
    case sixth
    case seventh
    case eigth
    case nineth
    
    var labeltype : String {
        switch self {
        case .nineth:
            return "9h"
            
        case .eigth:
            return "8h"
        case .seventh:
            return "7h"
        case .sixth:
            return "6h"
            
        case .fifth:
            return "5h"
        case .forth:
            return "4h"
        case .third:
            return "3h"
        case .second:
            return "2h"
        case .first:
            return "1h"
        case .zero:
            return "0h"
        default:
            break
        }
    }
}





