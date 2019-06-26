//
//  GrowthChartViewController.swift
//  ChildCare
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
    var registeredChildren : Results<Child>?
    var childApp = Child()
    
    @IBOutlet weak var actualYear: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
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
    var dictWeightGirl3 = [Double: [Double]]()
    var dictWeightGirl4 = [Double: [Double]]()
    var dictWeightGirl5 = [Double: [Double]]()
    
    var dict = [Double : Double]()
   
    var dictWeightBoy2 = [Double: [Double]]()
    var dictWeightBoy3 = [Double: [Double]]()
    var dictWeightBoy4 = [Double: [Double]]()
    var dictWeightBoy5 = [Double: [Double]]()
    
    var dictWeightBoy = [Double: [Double]]()
    var dictHeadGirl = [Double: [Double]]()
    var dictHeadBoy = [Double: [Double]]()
    var growthRecords = List<Growth>()
    var valuesToDraw = [Double]()
    var arrayValuesxAxis = [Double]()
    
    let dictButton = [0: "0-1 years old", 1 : "1-2 years old", 2 : "2-3 years old", 3: "3-4 years old", 4: "4-5 years old"]
    
    var lowper = Array<Double>()
    var highper = Array<Double>()
    var midper = Array<Double>()
    
    var counterButton = 0
    
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
        
        counterButton = 0
        actualYear.text = dictButton[counterButton]
        
        loadChildren()
        
        DispatchQueue.main.async {

            if self.registeredChildren!.count > 0 && !self.childApp.name.isEmpty && self.childApp.sex.isEmpty && !self.childApp.dateOfBirth.isEmpty{

                let controller = UIAlertController(title: nil, message: "To see the reference growth percentiles enter the sex of \(self.childApp.name)", preferredStyle: .alert)

                let action = UIAlertAction(title: "Remind me later", style: .default) { (alertAction) in
                    alertAction.isEnabled = false
                }
                let changeDob = UIAlertAction(title: "Enter sex", style: .cancel) { (alertAction) in
                    self.performSegue(withIdentifier: "goToChangeSex", sender: self)
                }

                controller.setTitle(font: self.font!, color: self.grayColor!)
                controller.setMessage(font: self.fontLight!, color: self.grayLightColor!)
                controller.addAction(action)
                controller.addAction(changeDob)
                controller.show(animated: true, vibrate: false, style: .light, completion: nil)

            }
            else if self.registeredChildren!.count > 0 && !self.childApp.name.isEmpty && self.childApp.dateOfBirth.isEmpty && !self.childApp.sex.isEmpty{
                
                let controller = UIAlertController(title: nil, message: "To see the reference growth percentiles enter the date of birth of \(self.childApp.name)", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Remind me later", style: .default) { (alertAction) in
                    alertAction.isEnabled = false
                }
                let changeDob = UIAlertAction(title: "Enter date of birth", style: .cancel) { (alertAction) in
                    self.performSegue(withIdentifier: "goToChangeSex", sender: self)
                }
                
                controller.setTitle(font: self.font!, color: self.grayColor!)
                controller.setMessage(font: self.fontLight!, color: self.grayLightColor!)
                controller.addAction(action)
                controller.addAction(changeDob)
                controller.show(animated: true, vibrate: false, style: .light, completion: nil)
                
            }
            else if self.registeredChildren!.count > 0 && !self.childApp.name.isEmpty && self.childApp.dateOfBirth.isEmpty && self.childApp.sex.isEmpty{
                
                let controller = UIAlertController(title: nil, message: "To see the reference growth percentiles enter the sex and date of birth of \(self.childApp.name)", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Remind me later", style: .default) { (alertAction) in
                    alertAction.isEnabled = false
                }
                let changeDob = UIAlertAction(title: "Enter both", style: .cancel) { (alertAction) in
                    self.performSegue(withIdentifier: "goToChangeSex", sender: self)
                }
                
                controller.setTitle(font: self.font!, color: self.grayColor!)
                controller.setMessage(font: self.fontLight!, color: self.grayLightColor!)
                controller.addAction(action)
                controller.addAction(changeDob)
                controller.show(animated: true, vibrate: false, style: .light, completion: nil)
                
            }
            else if self.childApp.name.isEmpty && self.registeredChildren!.count > 0{

                let controller = UIAlertController(title: nil, message: "There are no active children in ChildCare", preferredStyle: .alert)

                let action = UIAlertAction(title: "Ok", style: .default)

                controller.setTitle(font: self.font!, color: self.grayColor!)
                controller.setMessage(font: self.fontLight!, color: self.grayLightColor!)
                controller.addAction(action)
                controller.show(animated: true, vibrate: false, style: .light, completion: nil)


            }
            else if self.childApp.name.isEmpty && self.registeredChildren!.count == 0{

                let controller = UIAlertController(title: nil, message: "There are no registered children in ChildCare", preferredStyle: .alert)

                let action = UIAlertAction(title: "Ok", style: .default)

                controller.setTitle(font: self.font!, color: self.grayColor!)
                controller.setMessage(font: self.fontLight!, color: self.grayLightColor!)
                controller.addAction(action)
                controller.show(animated: true, vibrate: false, style: .light, completion: nil)


            }

        }

        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationVC = segue.destination as? ChildInfoViewController {
            
            destinationVC.selectedChild  = childApp
            destinationVC.navigationItem.title = destinationVC.selectedChild?.name
            if #available(iOS 11.0, *) {
                destinationVC.navigationItem.largeTitleDisplayMode = .always
                destinationVC.navigationController?.navigationBar.prefersLargeTitles = true
                
            }
            segue.destination.navigationController?.navigationBar.tintColor = UIColor(hexString: "64C5CF")
        }

        
    }
    func loadChildren(){
        
        childApp = Child()
        registeredChildren = realm.objects(Child.self).filter("current == %@", true)
        if registeredChildren?.count != 0{
            for child in registeredChildren!{
                childApp = child
            }
            
        }
        if !childApp.name.isEmpty{
            
            if childApp.growth.count != 0 && !childApp.age.isEmpty{
                
                loadGrowthRecords()
                checkAge(counter: 0)
            }
            
            if childApp.sex == "female"{
                loadGeneralDictionariesPercentilsGirl()
                appearancechart(values: dictWeightGirl)
            }
            else if childApp.sex == "male"{
                loadGeneralDictionariesPercentilsBoy()
                appearancechart(values: dictWeightBoy)
            }
           
        
            
        }
        
        
        
    }
    func loadGeneralDictionariesPercentilsGirl(){
        
     
        dictWeightGirl = [0 : [2.4,3.2,4.15], 1 : [3.15, 4.1, 5.3],2 : [3.9,5,6.4], 3: [4.6,5.85,7.4], 4 : [5.1,6.4,8.1], 5 : [5.5,6.9,8.7], 6: [5.8,7.3,9.2], 7 : [6.1,7.6,9.65], 8 : [6.3,8,10],9 : [6.6,8.2,10.4],10 : [6.8,8.5,10.7],11 : [7,8.7,11]]
        
        dictWeightGirl2 = [0 : [7.15,8.95,11.35], 1 : [7.3,9.2,11.6],2 : [7.5,9.4,11.9],3 : [7.7,9.6,12.2],4 : [7.8,9.8,12.4],5 : [8,10,12.7] , 6 : [8.2,10.2,13],7: [8.4,10.4,13.2],8 : [8.5,10.6,13.5],9 :[8.6,10.8,13.8],10 : [8.8,11,14.1],11 : [9,11.3,14.3]]
        
        dictWeightGirl3 = [0 : [9.2, 11.5, 14.75], 1 : [9.4, 11.75, 15],2 : [9.5,12,15.2 ],3 : [9.6,12.1,15.4],4 : [9.8,12.3,15.8] , 5 : [10,12.5,16],6 : [10.1,12.7,16.2],7 : [10.2,12.9,16.5],8 :[10.4,13.1,16.8],9 : [10.6,13.3,17],10 : [10.7,13.5,17.3], 11 : [10.8, 13.6, 17.6]]
        
        dictWeightGirl4 = [0 : [11,13.8,17.8], 1 : [11.1,14,18.1],2 : [11.2,14.2,18.4],3 : [11.4,14.4,18.6],4 : [11.5,14.6,19] , 5 : [11.6,14.8,19.2],6 : [11.8,15,19.4],7 : [11.9,15.2,19.8],8 :[12,15.4,20],9 : [12.2,15.6,20.3],10 : [12.3,15.7,20.6], 11 : [12.4,15.8,20.8]]
        
        dictWeightGirl5 =  [0 : [12.5,16.1,21], 1 : [12.6,16.3,21.2],2 : [12.8,16.5,21.7],3 : [12.9,16.7,22],4 : [13,16.9,22.3] , 5 : [13.1,17.1,22.6],6 : [13.2,17.3,22.8],7 : [13.3,17.5,23.1],8 :[13.4,17.7,23.4],9 : [13.5,17.9,23.6],10 : [13.6,18.1,23.9], 11: [13.7,18.3,24.2]]
        
        
    }
    func loadGeneralDictionariesPercentilsBoy(){
        
        
        dictWeightBoy = [0 : [2.5,3.3,4.3], 1 : [3.4, 4.5, 5.7],2 : [4.4,5.6,7], 3: [5.1,6.4,7.9], 4 : [5.6,7,8.6], 5 : [6.1,7.5,9.2], 6: [6.4,7.9,9.7], 7 : [6.7,8.3,10.2], 8 : [7,8.6,10.5],9 : [7.2,8.8,10.9],10 : [7.5,9.2,11.2],11 : [7.7,9.4,11.5], 12 : [7.8,9.6,11.8]]
        
        dictWeightBoy2 = [0 : [7.8,9.6,11.8], 1 : [8,9.9,12.1],2 : [8.2,10.1,12.4],3 : [8.4,10.3,12.7],4 : [8.5,10.5,12.9],5 : [8.7,10.7,13.2] , 6 : [8.9,10.9,13.5],7: [9,11.1,13.7],8 : [9.2,11.3,14],9 :[9.3,11.5,14.3],10 : [9.5,11.8,14.5],11 : [9.7,12,14.8], 12 : [9.8, 12.2, 15.1]]
        
        dictWeightBoy3 = [0 : [9.8, 12.2, 15.1], 1 : [10, 12.4, 15.3],2 : [10.1,12.5, 15.6 ],3 : [10.2,12.7,15.9],4 : [10.4,12.9,16.1] , 5 : [10.5,13.1,16.4],6 : [10.7,13.3,16.6],7 : [10.8,13.5,16.9],8 :[10.9,13.7,17.1],9 : [11.1,13.8,17.3],10 : [11.2,14,17.6], 11 : [11.3, 14.2, 17.8], 12: [11.4,14.3,18]]
        
        dictWeightBoy4 = [0 : [11.4,14.3,18], 1 : [11.6,14.5,18.3],2 : [11.7,14.7,18.5],3 : [11.8,14.8,18.7],4 : [11.9,15,19] , 5 : [12.1,15.2,19.2],6 : [12.2,15.3,19.4],7 : [12.3,15.5,19.7],8 :[12.4,15.7,19.9],9 : [12.5,15.8,20.1],10 : [12.7,16,20.4], 11 : [12.8,16.2,20.6], 12 : [12.9,16.3,20.9]]
        
        dictWeightBoy5 =  [0 : [12.9,16.3,20.9], 1 : [13,16.5,21.1],2 : [13.1,16.7,21.3],3 : [13.3,16.8,21.6],4 : [13.4,17,21.8] , 5 : [13.5,17.2,22.1],6 : [13.6,17.3,22.3],7 : [13.7,17.5,22.5],8 :[13.8,17.7,22.8],9 : [13.9,17.8,23],10 : [14.1,18,23.3], 11: [14.2,18.2,23.5]]
        
        
    }
    func appearancechart(values : [Double: [Double]]){
        
        chart.noDataText = "You need to provide data for the chart."
        chart.chartDescription?.enabled = true
        
        lowper = []
        midper = []
        highper = []
        for key in values.keys{
            
            lowper.append(values[key]![0])
            midper.append(values[key]![1])
            highper.append(values[key]![2])
            

        }
        lowper.sort()
        midper.sort()
        highper.sort()
        
        
        chart.drawBordersEnabled = false
        chart.borderLineWidth = 0.3
        chart.dragEnabled = false
        chart.setScaleEnabled(false)
        chart.pinchZoomEnabled = false
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

        for key in values.keys.sorted(){
            arrayxaxis.append("\(Int(key+1))")
        }
        
        let formatter = IndexAxisValueFormatter(values: arrayxaxis)
        
        let formatter2 = LineChartFormatter()
        
        let legend = chart.legend
        legend.enabled = true
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .bottom
        legend.orientation = .vertical
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
        xAxis.axisMaximum = Double(values.keys.count-1)
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
        
        
        setChart(values : values, valuesChild: valuesToDraw)
        
    }
    func setChart(values : [Double: [Double]], valuesChild : [Double]) {

        var dataEntriesLow: [ChartDataEntry] = []
        var dataEntriesMid: [ChartDataEntry] = []
        var dataEntriesHigh: [ChartDataEntry] = []
        var dataEntriesChild: [ChartDataEntry] = []
        
        for i in 0..<values.keys.count {
            
            let dataEntrylow = ChartDataEntry(x: Double(i) , y: self.lowper[i])
            let dataEntrymid = ChartDataEntry(x: Double(i) , y: self.midper[i])
            let dataEntryhigh = ChartDataEntry(x: Double(i) , y: self.highper[i])
            dataEntriesLow.append(dataEntrylow)
            dataEntriesMid.append(dataEntrymid)
            dataEntriesHigh.append(dataEntryhigh)
            
        }
        for i in 0..<valuesChild.count{
            let dataEntryChild = ChartDataEntry(x: arrayValuesxAxis[i] , y: Double(valuesChild[i]))
            dataEntriesChild.append(dataEntryChild)
        }
       
        let chartDatasetlow = LineChartDataSet(entries: dataEntriesLow, label: "3rd percentile")
        let chartDatasetmid = LineChartDataSet(entries: dataEntriesMid, label: "50th percentile")
        let chartDatasethigh = LineChartDataSet(entries: dataEntriesHigh, label: "97th percentile")
        let chartDatasetChild = LineChartDataSet(entries: dataEntriesChild, label: "Child percentile")
        
        chartDatasetChild.colors = [.orange]
        chartDatasetChild.drawValuesEnabled = false
        chartDatasetChild.lineWidth = 1.75
        chartDatasetChild.drawCirclesEnabled = false
        chartDatasetChild.highlightColor = .orange
        chartDatasetChild.highlightLineDashLengths = [8.0]
        chartDatasetChild.highlightLineDashPhase = 0
        
        chartDatasetlow.colors = [.darkGray]
        chartDatasetlow.drawValuesEnabled = false
        chartDatasetlow.lineWidth = 1.75
        chartDatasetlow.drawCirclesEnabled = false
        chartDatasetlow.highlightColor = .darkGray
        chartDatasetlow.highlightLineDashLengths = [8.0]
        chartDatasetlow.highlightLineDashPhase = 0
        
        
        chartDatasetmid.drawValuesEnabled = false
        chartDatasetmid.colors = [.lightGray]
        chartDatasetmid.lineWidth = 1.75
        chartDatasetmid.drawCirclesEnabled = false
        chartDatasetmid.highlightColor = .gray
        chartDatasetmid.highlightLineDashLengths = [8.0]
        chartDatasetmid.highlightLineDashPhase = 0
        
        
        chartDatasethigh.colors = [.darkGray]
        chartDatasethigh.drawValuesEnabled = false
        chartDatasethigh.lineWidth = 1.75
        chartDatasethigh.drawCirclesEnabled = false
        chartDatasethigh.highlightColor = .darkGray
        chartDatasethigh.highlightLineDashLengths = [8.0]
        chartDatasethigh.highlightLineDashPhase = 0
       
        var chartData = LineChartData()
       
        if valuesToDraw.count >= 2{
            chartData = LineChartData(dataSets: [chartDatasethigh,chartDatasetmid,chartDatasetlow, chartDatasetChild])
        }
        else{
             chartData = LineChartData(dataSets: [chartDatasethigh,chartDatasetmid,chartDatasetlow])
        }
       
        chart.data = chartData
        
        chart.scaleYEnabled = false
        chart.scaleXEnabled = false
        chart.leftAxis.axisMaximum = chartData.yMax + 0.5
        chart.rightAxis.axisMaximum = chartData.yMax + 0.5
        chart.leftAxis.axisMinimum = chartData.yMin - 0.5
        chart.rightAxis.axisMinimum = chartData.yMin - 0.5
        chart.xAxis.axisMaximum = 12
        chart.xAxis.axisMinimum = 0
        chart.notifyDataSetChanged()
       
        
        
    }
    func checkAge(counter : Int){
        
        valuesToDraw = []
        arrayValuesxAxis = []
        dict = [Double : Double]()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: childApp.dateOfBirth)
        
        
        for growth in growthRecords{
            let birthday = Calendar.current.date(from: DateComponents(year: date?.year, month: date?.month, day: date?.day))!
            
            let days = Calendar.current.dateComponents([.day], from: birthday, to: growth.generalDate).day!
    
            let age = Float(days)/Float(365)
            
            
            
            if Float(age) >= Float(counter) && Float(age) <= Float(counter+1){
                
                dict[Double(age)] = Double(growth.weight)
                
            }
            
        }
        
        if !dict.isEmpty{
            for dictval in  dict.sorted(by: { $0.0 < $1.0 }){
                valuesToDraw.append(dictval.value)
                arrayValuesxAxis.append(dictval.key.truncatingRemainder(dividingBy: 1))
            }
        }
        
        
        

    }


    
    @IBAction func nextButtonPressed(_ sender: UIButton) {

       
        if counterButton < 4{
            counterButton += 1
            actualYear.text = dictButton[counterButton]
            chart.setNeedsDisplay()
            chart.reloadInputViews()
            chart.notifyDataSetChanged()
            if childApp.sex == "female" && childApp.growth.count != 0{
                checkAge(counter: counterButton)
                appearancechart(values: retrieveValuesForChartGirl(counter: counterButton))
            }
            else if childApp.sex == "male" && childApp.growth.count  != 0{
                checkAge(counter: counterButton)
                appearancechart(values: retrieveValuesForChartBoy(counter: counterButton))
            }
            
        }
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {

        if counterButton > 0{
            counterButton -= 1
            actualYear.text = dictButton[counterButton]
            chart.setNeedsDisplay()
            chart.reloadInputViews()
            chart.notifyDataSetChanged()
            if childApp.sex == "female" && childApp.growth.count != 0{
                checkAge(counter: counterButton)
                appearancechart(values: retrieveValuesForChartGirl(counter: counterButton))
                
            }
            else if childApp.sex == "male" && childApp.growth.count != 0{
                checkAge(counter: counterButton)
                appearancechart(values: retrieveValuesForChartBoy(counter: counterButton))
                
            }
            
            
        }

        
        
    }
    func loadGrowthRecords(){

        growthRecords = childApp.growth
            //realm.objects(Growth.self)

        
        
    }

    
    func retrieveValuesForChartGirl(counter : Int)->[Double: [Double]]{
        
        if counter == 0{
            return dictWeightGirl
        }
        else if counter == 1{
            return dictWeightGirl2
        }
        else if counter == 2{
            return dictWeightGirl3
        }
        else if counter == 3{
            return dictWeightGirl4
        }
        else if counter == 4{
            return dictWeightGirl5
        }
        
        else{
            return dictWeightGirl
        }
        
    }
    func retrieveValuesForChartBoy(counter : Int)->[Double: [Double]]{
        
        if counter == 0{
            return dictWeightBoy
        }
        else if counter == 1{
            return dictWeightBoy2
        }
        else if counter == 2{
            return dictWeightBoy3
        }
        else if counter == 3{
            return dictWeightBoy4
        }
        else if counter == 4{
            return dictWeightBoy5
        }
            
        else{
            return dictWeightBoy
        }
        
    }
}

class LineChartFormatter: NSObject, IAxisValueFormatter {
    
    
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        
        return "\(Int(value))kg"
        
    }
    
}
