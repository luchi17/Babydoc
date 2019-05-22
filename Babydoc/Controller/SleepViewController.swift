//////
//////  SleepViewController.swift
//////  Babydoc
//////
//////  Created by Luchi Parejo alcazar on 22/05/2019.
//////  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//////
////
////import Foundation
////
// let months = ["Jan", "Feb", "Mar", "Apr", "May"]
//et unitsSold = [20.0, 4.0, 3.0, 2.0, 1.0]
//let unitsBought = [10.0, 4.0, 6.0, 2.0, 1.0]

//
//override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    
//    barChartView.delegate = self
//    barChartView.noDataText = "You need to provide data for the chart."
//    barChartView.chartDescription?.text = "sales vs bought "
//    
//    
//    
//    barChartView.chartDescription?.enabled =  false
//    
//    barChartView.pinchZoomEnabled = false
//    
//    //legend
//    let legend = barChartView.legend
//    legend.enabled = true
//    legend.horizontalAlignment = .right
//    legend.verticalAlignment = .top
//    legend.orientation = .vertical
//    legend.drawInside = true
//    legend.yOffset = 10.0;
//    legend.xOffset = 10.0;
//    legend.yEntrySpace = 0.0;
//    
//    
//    
//    let xAxis = barChartView.xAxis
//    xAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
//    xAxis.granularity = 1
//    xAxis.centerAxisLabelsEnabled = true
//    xAxis.valueFormatter = IntAxisValueFormatter()
//    
//    
//    
//    
//    
//    let leftAxis = barChartView.leftAxis
//    leftAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
//    leftAxis.valueFormatter = LargeValueFormatter()
//    leftAxis.spaceTop = 0.35
//    leftAxis.axisMinimum = 0
//    
//    barChartView.rightAxis.enabled = false
//    
//    
//    let leftAxisFormatter = NumberFormatter()
//    leftAxisFormatter.maximumFractionDigits = 1
//    
//    let yaxis = barChartView.leftAxis
//    yaxis.spaceTop = 0.35
//    yaxis.axisMinimum = 0
//    yaxis.drawGridLinesEnabled = false
//    
//
//    
//}
//
//override func willMove(toParent parent: UIViewController?) {
//    self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "64C5CF")
//}
//
//
//override func viewWillAppear(_ animated: Bool) {
//    
//    self.navigationController?.navigationBar.barTintColor = greenLightColor
//    self.navigationController?.navigationBar.backgroundColor = greenLightColor
//    UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//    
//    loadBabiesAndFever()
//    
//    
//}
//
//func loadBabiesAndFever(){
//    
//    registeredBabies = realm.objects(Baby.self)
//    
//    if registeredBabies?.count != 0 {
//        for baby in registeredBabies!{
//            if baby.current{
//                babyApp = baby
//            }
//        }
//        listOfFever = babyApp.fever.filter(NSPredicate(value: true))
//        
//    }
//    
//    var arrayDates  = [Date]()
//    for fever in listOfFever!{
//        var date = Date()
//        date.day = fever.date!.day
//        date.month = fever.date!.month
//        date.year = fever.date!.year
//        arrayDates.append(date)
//        
//    }
//    
//    guard let startDateYear = Calendar.current.date(byAdding: .year, value: -1, to: Date()) else { return  }
//    let datesBetweenArray = Date.dates(from: startDateYear, to: Date())
//    var array = [Date]()
//    var arrayfev = [Float]()
//    for date in datesBetweenArray{
//        array = []
//        for arraydate in arrayDates{
//            if Calendar.current.isDate(arraydate, inSameDayAs: date){
//                
//                array.append(date)
//                let fevertemp = (listOfFever?.filter("date.day == %@ AND date.month == %@ AND date.year == %@", date.day, date.month, date.year))!
//                for fever in fevertemp{
//                    arrayfev.append(fever.temperature)
//                    break
//                }
//                
//            }
//            
//        }
//        
//    }
//    
//    print(array)
//    print(arrayfev)
//    
//    
//    
//    
//    
//}
//
////func setChart() {
////    barChartView.noDataText = "You need to provide data for the chart."
////    var dataEntries: [BarChartDataEntry] = []
////    var dataEntries1: [BarChartDataEntry] = []
////    
////    for i in 0..<self.months.count {
////        
////        let dataEntry = BarChartDataEntry(x: Double(i) , y: self.unitsSold[i])
////        dataEntries.append(dataEntry)
////        
////        let dataEntry1 = BarChartDataEntry(x: Double(i) , y: self.self.unitsBought[i])
////        dataEntries1.append(dataEntry1)
////        
////        
////    }
////    
////    let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Unit sold")
////    let chartDataSet1 = BarChartDataSet(entries: dataEntries1, label: "Unit Bought")
////    
////    let dataSets: [BarChartDataSet] = [chartDataSet,chartDataSet1]
////    chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
////    chartDataSet.colors = ChartColorTemplates.colorful()
////    
////    let chartData = BarChartData(dataSets: dataSets)
////    barChartView.data = chartData
////    
////    // barChartView.set
////    let groupSpace = 0.3
////    let barSpace = 0.05
////    let barWidth = 0.3
////    // (0.3 + 0.05) * 2 + 0.3 = 1.00 -> interval per "group"
////    
////    let groupCount = self.months.count
////    let startYear = 3
////    let endYear = startYear + groupCount
////    
////    chartData.barWidth = barWidth;
////    barChartView.xAxis.axisMinimum = Double(startYear)
////    let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
////    barChartView.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)
////    
////    chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
////    
////    barChartView.scaleYEnabled = false
////    barChartView.scaleXEnabled = true
////    
////    barChartView.xAxis.axisMinimum = max(barChartView.data!.xMin - 2, barChartView.data!.xMin - 2)
////    barChartView.xAxis.axisMaximum = min(barChartView.data!.xMax + 4.0, barChartView.data!.xMax + 4.0)
////    barChartView.xAxis.labelCount = Int(barChartView.xAxis.axisMaximum - barChartView.xAxis.axisMinimum)
////    barChartView.setVisibleXRange(minXRange: 3.0, maxXRange: 4.0)
////    barChartView.moveViewToX(3)
////    
////    
////    
////    //        barChartView.leftAxis.axisMinimum = max(0.0, barChartView.data!.yMin - 1.0)
////    //        barChartView.leftAxis.axisMaximum = min(10.0, barChartView.data!.yMax + 1.0)
////    //        barChartView.leftAxis.labelCount = Int(barChartView.leftAxis.axisMaximum - barChartView.leftAxis.axisMinimum)
////    //        barChartView.leftAxis.drawZeroLineEnabled = true
////    
////    //background color
////    //barChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
////    
////    //chart animation
////    barChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
////    
////    
////}
////
////}
////
////extension Date {
////    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
////        var dates: [Date] = []
////        var date = fromDate
////        
////        while date <= toDate {
////            dates.append(date)
////            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
////            date = newDate
////        }
////        return dates
////    }
////}
////
//////
//////
//////extension FeverViewController: ChartViewDelegate, IAxisValueFormatter {
//////
//////    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
//////        let formatter = DateFormatter()
//////        formatter.dateFormat = "dd.MM"
//////        return formatter.string(from: Date(timeIntervalSince1970: value))
//////}
//////
//////}
////public class IntAxisValueFormatter: NSObject, IAxisValueFormatter {
////    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
////        return "H: \(Int(value))"
////    }
////}
////public class LargeValueFormatter: NSObject, IValueFormatter, IAxisValueFormatter {
////    
////    /// Suffix to be appended after the values.
////    ///
////    /// **default**: suffix: ["", "k", "m", "b", "t"]
////    public var suffix = ["", "k", "m", "b", "t"]
////    
////    /// An appendix text to be added at the end of the formatted value.
////    public var appendix: String?
////    
////    public init(appendix: String? = nil) {
////        self.appendix = appendix
////    }
////    
////    fileprivate func format(value: Double) -> String {
////        var sig = value
////        var length = 0
////        let maxLength = suffix.count - 1
////        
////        while sig >= 1000.0 && length < maxLength {
////            sig /= 1000.0
////            length += 1
////        }
////        
////        var r = String(format: "%2.f", sig) + suffix[length]
////        
////        if let appendix = appendix {
////            r += appendix
////        }
////        
////        return r
////    }
////    
////    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
////        return format(value: value)
////    }
////    
////    public func stringForValue(_ value: Double,entry: ChartDataEntry,dataSetIndex: Int,viewPortHandler: ViewPortHandler?) -> String {
////        return format(value: value)
////    }
////}
////
