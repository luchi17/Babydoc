//
//  FeverChartViewController.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 11/06/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import Foundation
import UIKit
import Charts
import RealmSwift

class FeverChartViewController : UIViewController, ChartViewDelegate{
    
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var lineChart: LineChartView!
    let greenDarkColor = UIColor.init(hexString: "33BE8F")
    let greenLightColor = UIColor.init(hexString: "14E19C")
    
    var days = Array<String>()
    
    var feverValues = [Double]()
    var realm = try! Realm()
    var registeredBabies : Results<Baby>?
    var babyApp : Baby?
    var selectedMonth = Date().month
    var selectedYear = Date().year

    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lineChart.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.barTintColor = greenLightColor
        self.navigationController?.navigationBar.backgroundColor = greenLightColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        loadBabies()
        appearanceView()
        appearancelineChart()
        
        if selectedMonth == Date().month{
            
            nextButton.isEnabled = false
        }
    }
    func appearanceView(){
        
        nextButton.layer.cornerRadius = 4
        backButton.layer.cornerRadius = 4
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        todayButton.setTitle("Go to current year", for: .normal)
        todayButton.setTitleColor(greenDarkColor, for: .normal)
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
        
        yearLabel.text = "\(selectedMonth) Temperature Progress"
        
        for i in 1..<32{
            days.append("\(i)")
        }
        
    }
    
    func appearancelineChart(){


        yearLabel.text = "\(selectedMonth) Temperature Progress"
        lineChart.noDataText = "You need to provide data for the chart."
        lineChart.chartDescription?.enabled = true

        lineChart.drawBordersEnabled = false
        lineChart.dragEnabled = true
        lineChart.setScaleEnabled(false)
        lineChart.pinchZoomEnabled = false
        lineChart.highlightPerDragEnabled = false
        lineChart.legend.enabled = false
        
        let xAxis = lineChart.xAxis
        xAxis.labelFont = UIFont(name: "Avenir-Medium", size: 14)!
        xAxis.labelTextColor = UIColor(hexString: "7F8484")!
        xAxis.granularity = 1
        xAxis.centerAxisLabelsEnabled = true
        xAxis.valueFormatter = IndexAxisValueFormatter(values: self.days)
        xAxis.drawGridLinesEnabled = false
        xAxis.labelPosition = .bottom
        xAxis.drawAxisLineEnabled = true
        xAxis.axisMaximum = 31
        xAxis.axisMinimum = 1
        xAxis.axisLineColor = (UIColor(hexString: "7F8484")?.lighten(byPercentage: 0.2))!


        let leftAxis = lineChart.leftAxis
        leftAxis.labelFont = UIFont(name: "Avenir-Medium", size: 14)!
        leftAxis.labelTextColor = UIColor(hexString: "7F8484")!
        leftAxis.spaceTop = 0.35
        leftAxis.granularityEnabled = true
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = 42
        leftAxis.granularityEnabled = true
        leftAxis.drawGridLinesEnabled = false
        leftAxis.drawAxisLineEnabled = true
        leftAxis.axisLineColor = (UIColor(hexString: "7F8484")?.lighten(byPercentage: 0.2))!

        lineChart.rightAxis.enabled = false


        if feverValues.count != 0 {
            setChart()
        }

    }
    func setChart() {


        var dataEntries: [ChartDataEntry] = []
      

        for i in 0..<self.days.count {

            let dataEntry = ChartDataEntry(x: Double(i) , y: self.feverValues[i])
            dataEntries.append(dataEntry)

        }

        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "")
        chartDataSet.colors = [greenLightColor!]
        chartDataSet.drawValuesEnabled = false

        let chartData = LineChartData(dataSet: chartDataSet)
        lineChart.data = chartData

        lineChart.scaleYEnabled = false
        lineChart.scaleXEnabled = true
        lineChart.maxVisibleCount = 10
    

        lineChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .linear)


    }
    func setFeverForChart(month : Int){
        
        feverValues = []
        var comp = DateComponents()
        comp.year = selectedYear
        comp.day = 1
        comp.month = Date().month

        calcAvgMonth(dateComp: comp)
        
        
        
    }
    func calcAvgMonth(dateComp : DateComponents){
        
        
        let initDate = Calendar.current.date(from: dateComp)
        
        let endDate  = Calendar.current.date(byAdding: .month, value: 1, to: initDate!)
        
        let arrayAllDates = Date.dates(from: initDate! , to: endDate!)
        
        
        var tempFloat = Float(0.0)
        var counter = 0
        
        for date in arrayAllDates{
            
            counter = 0
            tempFloat = Float(0.0)
            
            for fever in babyApp!.fever{
                
                if fever.date?.day == date.day && fever.date?.month == date.month && fever.date?.year == date.year {
                    
                    tempFloat = tempFloat + fever.temperature
                    counter += 1
                }
            }
            
            if counter != 0{
                feverValues.append(Double(tempFloat/Float(counter)))
            }
            else{
                feverValues.append(Double(0.0))
            }
            
            
            
            
            
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
        if !(babyApp?.name.isEmpty)! && babyApp?.sleeps.count != 0{
            
            setFeverForChart(month: selectedMonth)
            appearancelineChart()
            lineChart.setNeedsDisplay()
            
            
            
        }
        
    }
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        selectedMonth = selectedMonth - 1
        
        setFeverForChart(month: selectedMonth)
        
        
        if selectedMonth < Date().month{
            nextButton.isEnabled = true
        }
            
        else if selectedMonth == Date().month{
            
            nextButton.isEnabled = false
        }
        self.appearancelineChart()
        
    }
    
    @IBAction func todayButtonPressed(_ sender: UIButton) {
        
        selectedMonth = Date().month
        setFeverForChart(month: selectedMonth)
        nextButton.isEnabled = false
        self.appearancelineChart()
        
    }
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        selectedMonth = selectedMonth + 1
        
        setFeverForChart(month: selectedMonth)
        
        if selectedMonth < Date().month{
            sender.isEnabled = true
        }
            
        else if selectedMonth == Date().month{
            
            sender.isEnabled = false
        }
        self.appearancelineChart()
    }
    
}

class LineChartFormatter: NSObject, IAxisValueFormatter {
    
    
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        let label = Label(rawValue: Int(round(value)))!
        return label.labeltype
    }
    
}
enum LabelLine : Int {
    case _34
    case _35
    case _36
    case _37
    case _38
    case _39
    case _40
    case _41
    case _42
    case _0
    
    
    
    var labeltype : String {
        switch self {
        case ._42:
            return "42ºC"
        case ._41:
            return "41ºC"
        case ._40:
            return "40ºC"
        case ._39:
            return "39ºC"
        case ._38:
            return "38ºC"
        case ._37:
            return "37ºC"
        case ._36:
            return "36ºC"
        case ._35:
            return "35ºC"
        case ._34:
            return "34ºC"
        case ._0:
            return "0ºC"
        }
    }
}









