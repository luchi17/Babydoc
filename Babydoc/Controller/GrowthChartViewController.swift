//
//  GrowthChartViewController.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 14/06/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//


import Foundation
import UIKit
import Charts
import RealmSwift
import SwiftChart

class GrowthChartViewController : UIViewController, ChartViewDelegate{
    
    let darkOrangeColor = UIColor.init(hexString: "E67E22")
    let orangeColor = UIColor.init(hexString: "F58806")
    let font = UIFont(name: "Avenir-Heavy", size: 17)
    let fontLight = UIFont(name: "Avenir-Medium", size: 17)
    let grayColor = UIColor.init(hexString: "555555")
    let grayLightColor = UIColor.init(hexString: "7F8484")
    var realm = try! Realm()
    var registeredBabies : Results<Baby>?
    var babyApp = Baby()
    
    
    @IBOutlet weak var chart: LineChartView!
    
    var heightGirl  = Array<Float>()
    var heightBoy = Array<Float>()
    var weightGirl = Array<Float>()
    var weightBoy = Array<Float>()
    var headGirl = Array<Float>()
    var headBoy = Array<Float>()
    var dictHeightGirl = [Double: [Double]]()
    var dictHeightBoy = [Double: [Double]]()
    var dictWeightGirl = [Double: [Double]]()
    var dictWeightGirl2 = [Double: [Double]]()
    
    var dictWeightBoy = [Double: [Double]]()
    var dictHeadGirl = [Double: [Double]]()
    var dictHeadBoy = [Double: [Double]]()
    let arrayAgesYear1 : [Double] = [0,1,2,3,4,5,6,7, 8, 9, 10,11,12]
    let arrayAgesYear2 : [Double] = [0,1,2,3,4,5,6,7, 8, 9, 10,11,12]
    let arrayAgesYear3 : [Double] = [0,2,4,6,8,10]
    let arrayAgesYear4 : [Double] = [0,2,4,6,8,10]
    let arrayAgesYear5 : [Double] = [0,2,4,6,8,10]
    
    var lowper = Array<Double>()
    var highper = Array<Double>()
    var midper = Array<Double>()
    

    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chart.delegate = self
    }
    
    override func willMove(toParent parent: UIViewController?) {
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "64C5CF")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.barTintColor = orangeColor
        self.navigationController?.navigationBar.backgroundColor = orangeColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        loadBabies()
//        DispatchQueue.main.async {
//
//            if self.registeredBabies!.count > 0 && !self.babyApp.name.isEmpty && self.babyApp.dateOfBirth.isEmpty{
//
//                let controller = UIAlertController(title: nil, message: "To see the age-specific reference percentiles of sleep durations enter the date of birth of \(self.babyApp.name)", preferredStyle: .alert)
//
//                let action = UIAlertAction(title: "Remind me later", style: .default) { (alertAction) in
//                    alertAction.isEnabled = false
//                }
//                let changeDob = UIAlertAction(title: "Edit date of birth", style: .cancel) { (alertAction) in
//                    self.performSegue(withIdentifier: "goToChangeDob", sender: self)
//                }
//
//                controller.setTitle(font: self.font!, color: self.grayColor!)
//                controller.setMessage(font: self.fontLight!, color: self.grayLightColor!)
//                controller.addAction(action)
//                controller.addAction(changeDob)
//                controller.show(animated: true, vibrate: false, style: .light, completion: nil)
//
//            }
//            else if self.babyApp.name.isEmpty && self.registeredBabies!.count > 0{
//
//                let controller = UIAlertController(title: nil, message: "There are no active babys in Babydoc", preferredStyle: .alert)
//
//                let action = UIAlertAction(title: "Ok", style: .default)
//
//                controller.setTitle(font: self.font!, color: self.grayColor!)
//                controller.setMessage(font: self.fontLight!, color: self.grayLightColor!)
//                controller.addAction(action)
//                controller.show(animated: true, vibrate: false, style: .light, completion: nil)
//
//
//            }
//            else if self.babyApp.name.isEmpty && self.registeredBabies!.count == 0{
//
//                let controller = UIAlertController(title: nil, message: "There are no registered babys in Babydoc", preferredStyle: .alert)
//
//                let action = UIAlertAction(title: "Ok", style: .default)
//
//                controller.setTitle(font: self.font!, color: self.grayColor!)
//                controller.setMessage(font: self.fontLight!, color: self.grayLightColor!)
//                controller.addAction(action)
//                controller.show(animated: true, vibrate: false, style: .light, completion: nil)
//
//
//            }
//
//        }

        
    }
    func loadBabies(){
        
        
        babyApp = Baby()
        registeredBabies = realm.objects(Baby.self).filter("current == %@", true)
        if registeredBabies?.count != 0{
            for baby in registeredBabies!{
                babyApp = baby
            }
            
        }
        if !babyApp.name.isEmpty{
            loadGeneralDictionariesPercentils()
            appearancechart()
        
            
        }
        
        
        
    }
    func loadGeneralDictionariesPercentils(){
        
        dictWeightGirl = [0 : [2.4,3.2,4.15], 1 : [3.15, 4.1, 5.3],2 : [3.9,5,6.4], 3: [4.6,5.85,7.4], 4 : [5.1,6.4,8.1], 5 : [5.5,6.9,8.7], 6: [5.8,7.3,9.2], 7 : [6.1,7.6,9.65], 8 : [6.3,8,10],9 : [6.6,8.2,10.4],10 : [6.8,8.5,10.7],11 : [7,8.7,11],12 : [7.2,8.95,11.35], 13 : [7.3,9.2,11.6], 14 : [7.5,9.4,11.9],15 : [7.7,9.6,12.2],16 : [7.8,9.8,12.4],17 : [8,10,12.7] , 18 : [8.2,10.2,13],19 : [8.4,10.4,13.2],20 : [8.5,10.6,13.5],21 :[8.6,10.8,13.8],22 : [8.8,11,14.1],23 : [9,11.3,14.3], 24 : [9.1,11.5,14.6],25 : [7.3,9.2,11.6], 26 : [7.5,9.4,11.9],27 : [7.7,9.6,12.2], 28: [7.8,9.8,12.5], 29 : [8,10,12.7], 30 : [8.2,10.2,13], 31: [8.4,10.4,13.3], 32 : [8.5,10.5,13.3], 33 : [8.7,10.9,13.8],34 : [8.9,11.1,14.1],35 : [9,11.3,14.3],36 : [9.2,11.5,14.6]]
//            ,12 : [], 13 : [], 14 : [],15 : [],16 : [7.8,9.8,12.4],17 : [8,10,12.7] , 18 : [8.2,10.2,13],19 : [8.4,10.4,13.2],20 : [8.5,10.6,13.5],21 :[8.6,10.8,13.8],22 : [8.8,11,14.1],23 : [9,11.3,14.3], 24 : [9.1,11.5,14.6] ]
       
        
        
        for key in dictWeightGirl.keys{
            
            lowper.append(dictWeightGirl[key]![0])
            midper.append(dictWeightGirl[key]![1])
            highper.append(dictWeightGirl[key]![2])
            
            
            
        }
        lowper.sort()
        midper.sort()
        highper.sort()
        
    }
    func appearancechart(){
        
        chart.noDataText = "You need to provide data for the chart."
        chart.chartDescription?.enabled = true
        
        chart.drawBordersEnabled = false
        chart.borderLineWidth = 0.3
        chart.dragEnabled = true
        chart.setScaleEnabled(true)
        chart.pinchZoomEnabled = true
        chart.highlightPerDragEnabled = true
        
        let marker = MarkerChart(color: UIColor(white: 180/255, alpha: 1),
                                   font: .systemFont(ofSize: 12),
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = chart
        marker.minimumSize = CGSize(width: 80, height: 40)
        chart.marker = marker
        chart.legend.form = .square

        
        marker.minimumSize = CGSize(width: 80, height: 40)
        chart.marker = marker
        
        var arrayxaxis = Array<String>()
        
        for key in dictWeightGirl.keys.sorted(){
            arrayxaxis.append("\(Int(key))" + "m")
        }
        
        let formatter = IndexAxisValueFormatter(values: arrayxaxis)
        
        let formatter2 = LineChartFormatter()
        
        let legend = chart.legend
        legend.enabled = true
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .bottom
        legend.orientation = .horizontal
        legend.drawInside = false
        legend.yOffset = 0.0
        legend.xOffset = 0.0
        legend.yEntrySpace = 0.0
        legend.font = UIFont(name: "Avenir-Medium", size: 13)!
        legend.textColor = UIColor(hexString: "7F8484")!
        
        let xAxis = chart.xAxis
        xAxis.labelFont = UIFont(name: "Avenir-Medium", size: 14)!
        xAxis.labelTextColor = UIColor(hexString: "7F8484")!
        xAxis.granularity = 1
        xAxis.centerAxisLabelsEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.labelPosition = .bottom
        xAxis.drawAxisLineEnabled = true
        xAxis.axisMaximum = 36
        xAxis.axisMinimum = 0
        xAxis.axisLineColor = (UIColor(hexString: "7F8484")?.lighten(byPercentage: 0.2))!
        xAxis.valueFormatter = formatter
        
        
        let leftAxis = chart.leftAxis
        leftAxis.valueFormatter = formatter2
        leftAxis.labelFont = UIFont(name: "Avenir-Medium", size: 14)!
        leftAxis.labelTextColor = UIColor(hexString: "7F8484")!
        leftAxis.spaceTop = 0.35
        leftAxis.granularityEnabled = true
        leftAxis.drawGridLinesEnabled = false
        leftAxis.drawAxisLineEnabled = true
        leftAxis.axisLineColor = (UIColor(hexString: "7F8484")?.lighten(byPercentage: 0.2))!
        
        

        let rightAxis = chart.rightAxis
        rightAxis.valueFormatter = formatter2
        rightAxis.enabled = true
        rightAxis.labelFont = UIFont(name: "Avenir-Medium", size: 14)!
        rightAxis.labelTextColor = UIColor(hexString: "7F8484")!
        rightAxis.spaceTop = 0.35
        rightAxis.granularityEnabled = true
        rightAxis.drawGridLinesEnabled = false
        rightAxis.drawAxisLineEnabled = true
        rightAxis.axisLineColor = (UIColor(hexString: "7F8484")?.lighten(byPercentage: 0.2))!
        
        
        setChart()
        
    }
    func setChart() {

        var dataEntriesLow: [ChartDataEntry] = []
        var dataEntriesMid: [ChartDataEntry] = []
        var dataEntriesHigh: [ChartDataEntry] = []
        
        
        for i in 0..<self.dictWeightGirl.keys.count {
            
            let dataEntrylow = ChartDataEntry(x: Double(i) , y: self.lowper[i])
            let dataEntrymid = ChartDataEntry(x: Double(i) , y: self.midper[i])
            let dataEntryhigh = ChartDataEntry(x: Double(i) , y: self.highper[i])
            dataEntriesLow.append(dataEntrylow)
            dataEntriesMid.append(dataEntrymid)
            dataEntriesHigh.append(dataEntryhigh)
            
        }
       
        let chartDatasetlow = LineChartDataSet(entries: dataEntriesLow, label: "3rd percentile")
        let chartDatasetmid = LineChartDataSet(entries: dataEntriesMid, label: "50th percentile")
        let chartDatasethigh = LineChartDataSet(entries: dataEntriesHigh, label: "97th percentile")
        
        chartDatasetlow.colors = [.red]
        chartDatasetlow.drawValuesEnabled = false
        chartDatasetlow.lineWidth = 1.75
        chartDatasetlow.drawCirclesEnabled = false
        chartDatasetlow.highlightColor = .red
        chartDatasetlow.highlightLineDashLengths = [8.0]
        chartDatasetlow.highlightLineDashPhase = 0
        
        
        chartDatasetmid.drawValuesEnabled = false
        chartDatasetmid.colors = [.green]
        chartDatasetmid.lineWidth = 1.75
        chartDatasetmid.drawCirclesEnabled = false
        chartDatasetmid.highlightColor = .green
        chartDatasetmid.highlightLineDashLengths = [8.0]
        chartDatasetmid.highlightLineDashPhase = 0
        
        
        chartDatasethigh.colors = [.red]
        chartDatasethigh.drawValuesEnabled = false
        chartDatasethigh.lineWidth = 1.75
        chartDatasethigh.drawCirclesEnabled = false
        chartDatasethigh.highlightColor = .red
        chartDatasethigh.highlightLineDashLengths = [8.0]
        chartDatasethigh.highlightLineDashPhase = 0
       
        
        let chartData = LineChartData(dataSets: [chartDatasetlow,chartDatasetmid,chartDatasethigh])
        chart.data = chartData
        
        chart.scaleYEnabled = false
        chart.scaleXEnabled = true
        chart.setVisibleXRange(minXRange: 30.0, maxXRange: 34.0)
        chart.leftAxis.axisMaximum = chartData.yMax + 0.5
        chart.rightAxis.axisMaximum = chartData.yMax + 0.5
        chart.leftAxis.axisMinimum = chartData.yMin - 0.5
        chart.rightAxis.axisMinimum = chartData.yMin - 0.5
        
        
        chart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .linear)
        
        
    }

    
}

class LineChartFormatter: NSObject, IAxisValueFormatter {
    
    
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        
        return "\(Int(value))kg"
        
    }
    
}
