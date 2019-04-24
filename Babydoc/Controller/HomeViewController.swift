//
//  SecondViewController.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 05/04/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import UIKit
import ChameleonFramework
import ScrollableDatepicker

// MARK: - Home View Controller

class HomeViewController: UIViewController{
    
    @IBOutlet weak var sleep: ActionView!
  
    @IBOutlet weak var feed: ActionView!
    
    @IBOutlet weak var diaper: ActionView!

    @IBOutlet weak var medication: ActionView!
   
    @IBOutlet weak var grid: GridView!
    
    @IBOutlet weak var upcomingTasks: UILabel!
    
    @IBOutlet weak var todaysRecord: UILabel!
    
    @IBOutlet weak var dateToday: UIButton!
    
    @IBOutlet weak var taskTableView: UITableView!
    
    
    @IBOutlet weak var datePicker: ScrollableDatepicker!{
        didSet {
            var dates = [Date]()
            for day in -15...15 {
                dates.append(Date(timeIntervalSinceNow: Double(day * 86400)))
            }
            
            datePicker.dates = dates
            datePicker.selectedDate = Date()
            datePicker.delegate = self
            
            var configuration = Configuration()
            
            // weekend customization

            configuration.weekendDayStyle.dateTextColor = UIColor.black
            configuration.weekendDayStyle.weekDayTextColor = UIColor.black
            configuration.weekendDayStyle.weekDayTextFont = UIFont.boldSystemFont(ofSize: 8)
            

            configuration.selectedDayStyle.selectorColor = UIColor.init(hexString: "3BB4C1")
            configuration.selectedDayStyle.dateTextColor = UIColor.init(hexString: "3BB4C1")
            //configuration.selectedDayStyle.weekDayTextColor = UIColor.init(hexString: "3BB4C1")
            configuration.selectedDayStyle.dateTextFont = UIFont.boldSystemFont(ofSize: 20)
            
            configuration.selectedDayStyle.backgroundColor = UIColor(white: 0.9, alpha: 0.25)
            configuration.daySizeCalculation = .numberOfVisibleItems(5)
            
            datePicker.configuration = configuration
        }
    }
    

    
    @objc func buttonClicked() {
        datePicker.selectedDate = Date()
        datePicker.scrollToSelectedDate(animated: true)
        showSelectedDate()
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM YYYY"
        dateToday.setTitle("Today, "+formatter.string(from: datePicker.selectedDate!), for: .normal)
        dateToday.setTitleColor(UIColor.init(hexString: "3BB4C1"), for: .normal)
        dateToday.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        dateToday.backgroundColor = UIColor.white
        let spacing : CGFloat = 8.0
        dateToday.contentEdgeInsets = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)

        dateToday.layer.cornerRadius = 2
        dateToday.layer.masksToBounds = false
        //dateToday.layer.shadowColor = UIColor.init(hexString: "3BB4C1")?.cgColor
        dateToday.layer.shadowColor = UIColor.flatGray.cgColor
        dateToday.layer.shadowOpacity = 0.7
        dateToday.layer.shadowRadius = 1
        dateToday.layer.shadowOffset = CGSize(width: 2, height: 2)
        
        
        dateToday.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
       

        
        initialAppearance()

        DispatchQueue.main.async {
            self.showSelectedDate()
            self.datePicker.scrollToSelectedDate(animated: false)
        }
        
        
        
        let button = UIButton(type: .custom)
        let image = UIImage(named : "add-color")
        button.setImage(image, for: .normal)
        button.frame.size = CGSize(width: 55, height: 55)
        //button.frame = CGRect(origin: CGPoint(x: UIScreen.main.bounds.width-65, y: UIScreen.main.bounds.height - (tabBarController?.tabBar.bounds.height)! - button.frame.size.height - 15), size: button.frame.size)
        button.frame = CGRect(origin: CGPoint(x: UIScreen.main.bounds.width-70, y: dateToday.frame.origin.y + dateToday.bounds.height/2 - 8   ), size: button.frame.size)
        //upcomingTasks.frame.origin.y + 10
   
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.flatGray.cgColor
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 1
        button.layer.shadowOffset = CGSize(width: 1.2, height: 1.2)
       
        
    
        
        self.tabBarController?.view.addSubview(button)
        
        //DATABASE RELATED
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.separatorStyle = .none
        
        taskTableView.register(UINib(nibName: "CustomCellHome", bundle: nil), forCellReuseIdentifier: "customCellHome")


     
    }
    func initialAppearance (){
        self.view.backgroundColor = UIColor.init(hexString: "F8F9F9")?.withAlphaComponent(CGFloat(0.995))
        grid.backgroundColor = UIColor.init(hexString: "F8F9F9")?.withAlphaComponent(CGFloat(0.8))
        taskTableView.backgroundColor = UIColor.init(hexString: "F8F9F9")?.withAlphaComponent(CGFloat(0.8))
        
        upcomingTasks.textColor = UIColor.init(hexString: "7F8484")!
        todaysRecord.textColor = UIColor.init(hexString: "7F8484")!
        sleep.layer.cornerRadius = 4
        sleep.layer.masksToBounds = true
        feed.layer.cornerRadius = 4
        feed.layer.masksToBounds = true
        diaper.layer.cornerRadius = 4
        diaper.layer.masksToBounds = true
        medication.layer.cornerRadius = 4
        medication.layer.masksToBounds = true
        
        sleep.backgroundColor = sleep.sleepcolor.withAlphaComponent(CGFloat(0.2))
        feed.backgroundColor = feed.feedcolor.withAlphaComponent(CGFloat(0.2))
        diaper.backgroundColor = diaper.diapercolor.withAlphaComponent(CGFloat(0.2))
        medication.backgroundColor = medication.medicationcolor.withAlphaComponent(CGFloat(0.2))
    }

    
    
   


}

//MARK - ScrollableDatePicker and TableView methods
extension HomeViewController: ScrollableDatepickerDelegate {
    
    func datepicker(_ datepicker: ScrollableDatepicker, didSelectDate date: Date) {
        showSelectedDate()
    }
    fileprivate func showSelectedDate() {
        guard datePicker.selectedDate != nil else {
            return
        }

        
    }
    
    
    
}
extension HomeViewController :  UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCellHome") as! CustomCellHome
        
        cell.backgroundColor = UIColor.init(hexString: "F8F9F9")?.withAlphaComponent(CGFloat(0.995))
        
        cell.actionName.text = "Medication"
        cell.actionName.textColor = medication.medicationcolor
        
        cell.nameTitle.text = "Name :"
        cell.nameTitle.textColor = UIColor.lightGray
        
        
        cell.nameField.text = "Apiretal"
        cell.nameField.textColor = UIColor.black
        
        
        cell.dateTitle.text = "Date :"
        cell.dateTitle.textColor = UIColor.lightGray
        
        cell.dateField.text = "24/12/2012 12:00"
        cell.dateField.textColor = UIColor.black
        
        cell.quantityTitle.text = "Quantity :"
        cell.quantityTitle.textColor = UIColor.lightGray
        
        cell.quantityField.text = "30 mg"
        cell.quantityField.textColor = UIColor.black
        
        
        
        //        if  cell.quantityTitle.text!.isEqual("Quantity"){
        //            cell.stackViewTitles.removeArrangedSubview(cell.quantityTitle)
        //            cell.quantityTitle.removeFromSuperview()
        //            cell.stackViewFields.removeArrangedSubview(cell.quantityField)
        //            cell.quantityField.removeFromSuperview()
        //
        //        }
        
        
        cell.noteTitle.text = "Note :"
        cell.noteTitle.textColor = UIColor.lightGray
        
        cell.noteField.text = "Remember to give her that drug twice"
        
        cell.noteField.textColor = UIColor.black
        cell.actionImage.image = UIImage(named: "icons8-pill-filled-48")
        
        
        
        return cell
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        taskTableView.rowHeight = UITableView.automaticDimension
        taskTableView.estimatedRowHeight = 180.0
        
        let height: CGFloat = 50 //whatever height you want to add to the existing height
        let bounds = self.navigationController!.navigationBar.bounds
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let height: CGFloat = 20 //whatever height you want to add to the existing height
        let bounds = self.navigationController!.navigationBar.bounds
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - height)
        
    }
    
}



// MARK: - Action View


class ActionView: UIView
    
{
    
    var sleepcolor :UIColor = UIColor.init(hexString: "2772db")!
    var feedcolor :UIColor = UIColor.init(hexString: "85ef47")!
    var diapercolor :UIColor = UIColor.init(hexString: "37D4C0")!
    var medicationcolor :UIColor = UIColor.init(hexString: "F81B9A")!
   
    
    
    func fillColor(start : CGFloat,with color:UIColor,width:CGFloat)
    {
        let topRect = CGRect(x : start, y:0, width : width, height: self.bounds.height)
        color.setFill()
        UIRectFill(topRect)
        
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
            
            //FEED
        case 1:
            
            self.fillColor(start : (12*width)/day, with: feedcolor, width: 4*width/day)
            self.fillColor(start : (22*width)/day, with: feedcolor, width: 2*width/day)
        
            //DIAPER
        case 2:
            
            self.fillColor(start : (10*width)/day, with: diapercolor , width: 0.2*width/day)
            self.fillColor(start : (20*width)/day, with: diapercolor, width: 0.3*width/day)
        
            //MEDICATION
        case 3:
    
            self.fillColor(start : (8*width)/day, with: medicationcolor, width: 0.2*width/day)
            self.fillColor(start : (16*width)/day, with: medicationcolor, width: 0.2*width/day)
        
        
        default:
            print("TAG NOT FOUND")
        }

}
}

// MARK: - Grid View

class GridView: UIView
    
{
    private var path = UIBezierPath()

    fileprivate var gridWidthMultiple: CGFloat
    {
        return 4
    }
    fileprivate var gridHeightMultiple : CGFloat
    {
        return 20
    }
    
    fileprivate var gridWidth: CGFloat
    {
        return bounds.width/CGFloat(gridWidthMultiple)
    }
    
    fileprivate var gridHeight: CGFloat
    {
        return bounds.height/CGFloat(gridHeightMultiple)
    }
    
    fileprivate var gridCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    fileprivate func drawGrid()
    {
        path = UIBezierPath()
        path.lineWidth = 0.15
        
        for index in 0...Int(gridWidthMultiple) 
        {
            let start = CGPoint(x: CGFloat(index) * gridWidth, y: 0)
            let end = CGPoint(x: CGFloat(index) * gridWidth, y:bounds.height)
            path.move(to: start)
            path.addLine(to: end)
        }
        path.close()
        
    }
    
    override func draw(_ rect: CGRect)
    {
        drawGrid()
        
        // Specify a border (stroke) color.
        UIColor.black.setStroke()
        path.stroke()
       
    }

  
}
// MARK: - Grid View

class RoundShadowView: UIView{
    
    private var shadowLayer: CAShapeLayer!
    private var cornerRadius: CGFloat = 2.0
    private var fillcolor : UIColor = UIColor.white
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.masksToBounds = false
        self.layer.backgroundColor = UIColor.clear.cgColor
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = fillcolor.cgColor
            
            shadowLayer.shadowColor = UIColor.flatGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            shadowLayer.shadowOpacity = 0.7
            shadowLayer.shadowRadius = 2
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}


