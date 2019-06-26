//
//  ChartsViewController.swift
//  ChildCare
//
//  Created by Luchi Parejo alcazar on 28/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import Foundation
import UIKit
import Charts
import RealmSwift

class ChartsViewController : UIViewController, ChartViewDelegate{
    
    @IBOutlet weak var barChart: BarChartView!
    let darkBlueColor = UIColor.init(hexString: "2772DB")
    let blueColor = UIColor.init(hexString: "66ACF8")
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    @IBOutlet weak var yearLabel: UILabel!
    
    var nightSleep = [Double]()
    var napSleep = [Double]()
    var realm = try! Realm()
    var registeredChildren : Results<Child>?
    var childApp : Child?
    var selectedYear = Date().year
   
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barChart.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.barTintColor = blueColor
        self.navigationController?.navigationBar.backgroundColor = blueColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        loadChildren()
        appearanceView()
        appearancebarChart()
        
        if selectedYear == Date().year{
            
            nextButton.isEnabled = false
        }
    }
    func appearanceView(){
        
        nextButton.layer.cornerRadius = 4
        backButton.layer.cornerRadius = 4
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        todayButton.setTitle("Go to current year", for: .normal)
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
        
        yearLabel.text = "\(selectedYear) Sleep Progress"
        
    }
    
    func appearancebarChart(){
        
        
        yearLabel.text = "\(selectedYear) Sleep Progress"
        barChart.noDataText = "You need to provide data for the chart."
        barChart.chartDescription?.enabled = true
        
        
        barChart.pinchZoomEnabled = false
        barChart.drawBordersEnabled = false
        
        let legend = barChart.legend
        legend.enabled = true
        legend.drawInside = false
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .bottom
        legend.orientation = .horizontal
        legend.yOffset = 0.0
        legend.xOffset = 0.0
        legend.yEntrySpace = 0.0
        legend.font = UIFont(name: "Avenir-Medium", size: 13)!
        legend.textColor = UIColor(hexString: "7F8484")!
       
        
        let xAxis = barChart.xAxis
        xAxis.labelFont = UIFont(name: "Avenir-Medium", size: 14)!
        xAxis.labelTextColor = UIColor(hexString: "7F8484")!
        xAxis.granularity = 1
        xAxis.centerAxisLabelsEnabled = true
        xAxis.valueFormatter = IndexAxisValueFormatter(values:self.months)
        xAxis.drawGridLinesEnabled = true
        xAxis.gridLineDashPhase = 0
        xAxis.gridLineDashLengths = [8.0]
        xAxis.labelPosition = .bottom
        xAxis.drawAxisLineEnabled = true
        xAxis.axisLineColor = (UIColor(hexString: "7F8484")?.lighten(byPercentage: 0.2))!
        
        
        let leftAxis = barChart.leftAxis
        leftAxis.labelFont = UIFont(name: "Avenir-Medium", size: 14)!
        leftAxis.labelTextColor = UIColor(hexString: "7F8484")!
        leftAxis.spaceTop = 0.35
        leftAxis.axisMinimum = 0
        leftAxis.granularity = 1
        let chartFormatter = BarChartFormatter()
        leftAxis.valueFormatter = chartFormatter
        leftAxis.drawGridLinesEnabled = false
        leftAxis.drawAxisLineEnabled = true
        leftAxis.axisLineColor = (UIColor(hexString: "7F8484")?.lighten(byPercentage: 0.2))!
        
        barChart.rightAxis.enabled = false
        
        
        if nightSleep.count != 0 || napSleep.count != 0{
            setChart()
        }
        
    }
    func setChart() {
        
        
        var dataEntries: [BarChartDataEntry] = []
        var dataEntries1: [BarChartDataEntry] = []

        for i in 0..<self.months.count {
            
            let dataEntry = BarChartDataEntry(x: Double(i) , y: self.nightSleep[i])
            dataEntries.append(dataEntry)
            
            let dataEntry1 = BarChartDataEntry(x: Double(i) , y: self.self.napSleep[i])
            dataEntries1.append(dataEntry1)
            
            
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Avg night-time Sleep")
        let chartDataSet1 = BarChartDataSet(entries: dataEntries1, label: "Avg nap-time Sleep")
        
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
        barChart.leftAxis.labelCount = 5
        
        barChart.data = chartData
        barChart.moveViewToX(Double(Date().month - 1))
        barChart.notifyDataSetChanged()
        
        barChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
        
        
    }
    func setNightAndNapForChart(year : Int){
        
        nightSleep = []
        napSleep = []
        var comp = DateComponents()
        comp.year = year
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
            
            for sleep in childApp!.sleeps{
                
                
                if sleep.dateBegin?.day == date.day && sleep.dateBegin?.month == date.month && sleep.dateBegin?.year == date.year && sleep.dateBegin?.day == sleep.dateEnd?.day && sleep.nightSleep == nightOrNap{
                    durationFloat = durationFloat + sleep.timeSleepFloat
                    counterDur2 += 1
                    
                    
                }
                else if sleep.dateBegin?.day == date.day && sleep.dateBegin?.month == date.month && sleep.dateBegin?.year == date.year && sleep.dateBegin!.day < sleep.dateEnd!.day && sleep.nightSleep == nightOrNap{
                    
                    let minutes = round((Float(sleep.generalDateBegin.minute)*100.0))/(60.0*100.0)
                    let duration = Float(sleep.generalDateBegin.hour) + minutes
                    
                    durationFloat = durationFloat + 24.0 - duration
                    counterDur2 += 1
                }
                else if date.day == sleep.dateEnd?.day && sleep.dateEnd?.month == date.month && sleep.dateBegin?.year == date.year &&  sleep.nightSleep == nightOrNap{
                    
                    
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
        
        
        if arrayAvgDay.count != 0{
             avg1 = sum1/Float(arrayAvgDay.count)
        }

        return avg1
        
    }
    func loadChildren(){
        
        childApp = Child()
        registeredChildren = realm.objects(Child.self).filter("current == %@", true)
        if registeredChildren?.count != 0{
            for child in registeredChildren!{
                childApp = child
            }
            
        }
        if !(childApp?.name.isEmpty)! && childApp?.sleeps.count != 0{
            
            setNightAndNapForChart(year: selectedYear)
            appearancebarChart()
            barChart.setNeedsDisplay()
            
            
            
        }
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        selectedYear = selectedYear - 1
        
        setNightAndNapForChart(year: selectedYear)
 
        
        if selectedYear < Date().year{
            nextButton.isEnabled = true
        }
            
        else if selectedYear == Date().year{
            
            nextButton.isEnabled = false
        }
        self.appearancebarChart()
        
    }
    
    @IBAction func todayButtonPressed(_ sender: UIButton) {
        
        selectedYear = Date().year
        setNightAndNapForChart(year: selectedYear)
        nextButton.isEnabled = false
        self.appearancebarChart()
    }
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        selectedYear = selectedYear + 1
        
        setNightAndNapForChart(year: selectedYear)
        
        if selectedYear < Date().year{
            sender.isEnabled = true
        }
            
        else if selectedYear == Date().year{
            
            sender.isEnabled = false
        }
        self.appearancebarChart()
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
    case tenth
    case eleventh
    case twelveth
    
    var labeltype : String {
        switch self {
        case .twelveth:
            return "12h"
        case .eleventh:
            return "11h"
        case .tenth:
            return "10h"
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
        }
    }
}






