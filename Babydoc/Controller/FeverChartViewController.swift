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
import SwiftChart


class FeverChartViewController : UIViewController, ChartViewDelegate, ChartDelegate{
    
    
    
    let font = UIFont(name: "Avenir-Heavy", size: 17)
    let fontLittle = UIFont(name: "Avenir-Medium", size: 17)
    let grayColor = UIColor.init(hexString: "555555")
    let grayLightColor = UIColor.init(hexString: "7F8484")
    
    @IBOutlet weak var labelLeadingMargin: NSLayoutConstraint!
    fileprivate var labelLeadingMarginInitialConstant: CGFloat!
    
    @IBOutlet weak var labelNumber: UILabel!
    
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var lineChart: Chart!
 
    let greenDarkColor = UIColor.init(hexString: "33BE8F")
    let greenLightColor = UIColor.init(hexString: "14E19C")
    
    var days = Array<Double>()
    
    var feverValues = [Double]()
    var realm = try! Realm()
    var registeredBabies : Results<Baby>?
    var babyApp : Baby?
    
    var selectedMonth = Date().month
    var selectedDate = Date()

    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lineChart.delegate = self
        labelLeadingMarginInitialConstant = labelLeadingMargin.constant
        
        
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

            if self.babyApp!.name.isEmpty && self.registeredBabies!.count > 0{
                
                let controller = UIAlertController(title: nil, message: "There are no babys in Babydoc", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Ok", style: .default)
                
                controller.setTitle(font: self.font!, color: self.grayColor!)
                controller.setMessage(font: self.fontLittle!, color: self.grayLightColor!)
                controller.addAction(action)
                controller.show(animated: true, vibrate: false, style: .light, completion: nil)
                
                
            }
        else if self.babyApp!.name.isEmpty && self.registeredBabies!.count == 0{
            
            let controller = UIAlertController(title: nil, message: "There are no active babys in Babydoc", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ok", style: .default)
            
            controller.setTitle(font: self.font!, color: self.grayColor!)
            controller.setMessage(font: self.fontLittle!, color: self.grayLightColor!)
            controller.addAction(action)
            controller.show(animated: true, vibrate: false, style: .light, completion: nil)
            
            
        }
                
            else if !self.babyApp!.name.isEmpty && self.babyApp!.fever.count == 0{
                
                let controller = UIAlertController(title: nil, message: "Graph is empty because no data has been introduced, pleaser enter data.", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Ok", style: .default)
                
                controller.setTitle(font: self.font!, color: self.grayColor!)
                controller.setMessage(font: self.fontLittle!, color: self.grayLightColor!)
                controller.addAction(action)
                controller.show(animated: true, vibrate: false, style: .light, completion: nil)
                
                
            }
            
            
        
       
    }
    func appearanceView(){
        
        nextButton.layer.cornerRadius = 4
        backButton.layer.cornerRadius = 4
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        todayButton.setTitle("Go to current month", for: .normal)
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

    }
    
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        
        if !self.babyApp!.name.isEmpty && self.babyApp!.fever.count != 0{
            
           
            if let value = lineChart.valueForSeries(0, atIndex: indexes[0]) {
                
                let numberFormatter = NumberFormatter()
                numberFormatter.minimumFractionDigits = 0
                numberFormatter.maximumFractionDigits = 1
                labelNumber.text = numberFormatter.string(from: NSNumber(value: value))
                
                var constant = labelLeadingMarginInitialConstant + left - (labelNumber.frame.width / 2)
                
                
                if constant < labelLeadingMarginInitialConstant {
                    constant = labelLeadingMarginInitialConstant
                }
                
                
                let rightMargin = chart.frame.width - labelNumber.frame.width
                if constant > rightMargin {
                    constant = rightMargin
                }
                
                labelLeadingMargin.constant = constant
                
            }
            
        }
        
        
       
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        labelNumber.text = ""
        labelLeadingMargin.constant = labelLeadingMarginInitialConstant
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        
        lineChart.setNeedsDisplay()
        
    }
    
    
    
    func appearancelineChart(){
        
        days = []
        let range = Calendar.current.range(of: .day, in: .month, for: selectedDate)!
        let numDays = range.count
        
        for i in 1..<(numDays+1){
       
            days.append(Double(i))
        }

        let formatter2 = DateFormatter()
        formatter2.dateFormat = "MMMM YYYY"
        yearLabel.text = formatter2.string(from: selectedDate)
        
        lineChart.showXLabelsAndGrid = false
        lineChart.showYLabelsAndGrid = true
        lineChart.xLabelsOrientation = .horizontal
        lineChart.xLabels = days
        lineChart.xLabelsTextAlignment = .center
        lineChart.xLabelsFormatter = { String(Int($1)) }

        if feverValues.count != 0 {
            
            
            lineChart.yLabelsFormatter = { String(Int($1)) +  "ºC" }
            
            
            let series = ChartSeries(feverValues)

            series.colors = (
                above: UIColor.red,
                below: greenLightColor!,
                zeroLevel: 37.8
            )
            
            lineChart.minY = 34
            lineChart.maxY = 42
            lineChart.maxX = 15
            lineChart.minX = 1
            series.area = false
            lineChart.add(series)

        }

    }
    
    func setFeverForChart(month : Int){
        
        feverValues = []
        var comp = DateComponents()
        comp.year = Date().year
        comp.day = 1
        comp.month = selectedMonth

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
                feverValues.append(Double(35.0))
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
        if !(babyApp?.name.isEmpty)! && babyApp?.fever.count != 0{
            
            setFeverForChart(month: selectedMonth)
            lineChart.setNeedsDisplay()
            lineChart.reloadInputViews()
            lineChart.removeAllSeries()
            appearancelineChart()
            
            
            
            
        }
        
    }
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        selectedMonth = selectedMonth - 1
        selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate)!

        
        if selectedMonth < Date().month{
            nextButton.isEnabled = true
        }
            
        else if selectedMonth == Date().month{
            
            nextButton.isEnabled = false
        }
        else if selectedMonth <= 1 {
            nextButton.isEnabled = false
        }
        self.loadBabies()
        
        
    }
    
    @IBAction func todayButtonPressed(_ sender: UIButton) {
        
        selectedMonth = Date().month
        selectedDate = Date()
        nextButton.isEnabled = false
        self.loadBabies()
        
        
    }
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        selectedMonth = selectedMonth + 1
        selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate)!
        
        if selectedMonth < Date().month{
            sender.isEnabled = true
        }
            
        else if selectedMonth == Date().month{
            
            sender.isEnabled = false
        }
        self.loadBabies()
        
    }
    
}

