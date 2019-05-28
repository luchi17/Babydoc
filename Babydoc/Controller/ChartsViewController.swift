//
//  ChartsViewController.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 28/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import Foundation
import UIKit
import Charts

class ChartsViewController : UIViewController, ChartViewDelegate{
    
    @IBOutlet weak var barChart: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barChart.delegate = self
        barChart.noDataText = "You need to provide data for the chart."
        appearancebarChart()
    }
    let darkBlueColor = UIColor.init(hexString: "2772DB")
    let blueColor = UIColor.init(hexString: "66ACF8")
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    var nightSleep : [Double]?
 
 
    var napSleep  : [Double]?
    
    func appearancebarChart(){
        
        barChart.noDataText = "You need to provide data for the chart."
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
        
        barChart.rightAxis.enabled = true
        barChart.xAxis.drawAxisLineEnabled = true
        
        if nightSleep?.count != 0 || napSleep?.count != 0{
            setChart()
        }
        
    }
    func setChart() {
        
        
        var dataEntries: [BarChartDataEntry] = []
        var dataEntries1: [BarChartDataEntry] = []
        
        for i in 0..<self.months.count {
            
            let dataEntry = BarChartDataEntry(x: Double(i) , y: (self.nightSleep?[i])!)
            dataEntries.append(dataEntry)
            
            let dataEntry1 = BarChartDataEntry(x: Double(i) , y: (self.self.napSleep?[i])!)
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
