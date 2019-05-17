//
//  MedicationCalculatorViewController.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 15/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import APESuperHUD
//import AUPickerCell
import SwiftyPickerPopover

class MedicationCalculatorViewController : UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    let font = UIFont(name: "Avenir-Heavy", size: 17)
    let fontLittle = UIFont(name: "Avenir-Heavy", size: 16)
    let fontLight = UIFont(name: "Avenir-Medium", size: 17)
    let pinkcolor = UIColor.init(hexString: "F97DBE")
    let darkPinkColor = UIColor.init(hexString: "FB569F")
    let lightPinkColor = UIColor.init(hexString: "FFA0D2")
    let grayColor = UIColor.init(hexString: "7F8484")
    let grayLightColor = UIColor.init(hexString: "7F8484")

    
    @IBOutlet weak var admRoute: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var suggestions: UILabel!
    
    @IBOutlet weak var resultCalculator: UILabel!
    @IBOutlet weak var maxDose: UILabel!
 
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var hyperLink: UITextView!
    
    var realm = try! Realm()
    
    var selectedTypeParentName:String? {
        didSet{
            
        }
    }
    var selectedTypeName :String? {
        didSet{
            loadSpecificTypeOfDrug()
        }
    }
    
    
    
    
    var drugTypes : Results<MedicationType>?
    var concentrations = Array<Int>()
    var concentrationsPopOver = Array<StringPickerPopover.ItemType>()
    var weightsPopOver = Array<StringPickerPopover.ItemType>()
    
    var link = ""
    var suggestion = ""
    var routeOfAdm = ""
    var concentrationUnit : String = ""
    var minimumWeight = 0
    var maximumWeight = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        admRoute.text = routeOfAdm
        type.text = "\(selectedTypeParentName ?? "" ) \(selectedTypeName ?? "")"
        
    }
    override func viewDidLayoutSubviews(){
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.contentSize.height)
        tableView.reloadData()
    }
    override func willMove(toParent parent: UIViewController?) {
        self.navigationController?.navigationBar.barTintColor = lightPinkColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70.0
        self.navigationController?.navigationBar.barTintColor = pinkcolor
        self.navigationController?.navigationBar.backgroundColor = pinkcolor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.contentSize.height)
        
    }
    
    //MARK: Data manipulation
    
    
    func loadSpecificTypeOfDrug(){

        
        drugTypes = realm.objects(MedicationType.self).filter( "parentMedicationName == %@ AND name == %@",selectedTypeParentName as Any, selectedTypeName as Any)
        
        for type in drugTypes!{
            concentrations.append(type.concentration)
            
        }
        
        
        for concentration in concentrations{
            
            var valuePopOver = StringPickerPopover.ItemType()
            valuePopOver.append("\(concentration)")
            concentrationsPopOver.append(valuePopOver)
            
        }
        
        
        configureCommonProperties()
        
        
    }
    func configureProperties(selectedConcentration : String){
        
        let specificType = drugTypes?.filter("concentration == %@", Int(selectedConcentration) as Any)
       
        for type in specificType!{
            
            minimumWeight = type.minWeight
            maximumWeight = type.maxWeight
            link = type.hyperlink
            suggestion = type.suggestion + type.tricksForQuickUse

            break
        }
        hyperLink.text = link
        suggestions.text = suggestion
        
        

        
        for weight in minimumWeight...maximumWeight{
            
            var weightPopOver = StringPickerPopover.ItemType()
            weightPopOver.append("\(weight)")
            weightsPopOver.append(weightPopOver)
            
        }
        
        
    }
    func configureCommonProperties(){
        
        for drug in drugTypes!{

            concentrationUnit = drug.concentrationUnit
            routeOfAdm = drug.routeOfAdministration
            
            break
            
        }
        
        
        
    }
    
    
    
    @IBAction func textFieldTouchedDown(_ sender: UITextField) {
        
        
        sender.textColor = grayColor
        sender.font = font
        if sender.tag == 0{
            
            let picker =  StringPickerPopover(title: concentrationUnit, choices: concentrationsPopOver)
            picker.setArrowColor(pinkcolor!)
            picker.setFontColor(grayColor!).setFont(font!).setSize(width: 220, height: 150).setFontSize(17).setDoneButton(title: "Done", font: fontLittle, color: .white) {
                popover, selectedRow, selectedString in
                sender.text = selectedString
                self.configureProperties(selectedConcentration:selectedString)
                
                }.appear(originView: sender, baseViewController: self)
            
            
        }
        else{
            
            
            if weightsPopOver.count == 0{
                
                let alert = UIAlertController(title: nil, message: "Select concentration before choosing child´s weight", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(action)
                alert.setMessage(font: fontLight!, color: grayLightColor!)
                alert.show(animated: true, vibrate: true, style: .light, completion: nil)
            }
            else{
                let picker =  StringPickerPopover(title: "kg", choices: weightsPopOver)
                picker.setArrowColor(pinkcolor!)
                picker.setFontColor(grayColor!).setFont(font!).setSize(width: 180, height: 220).setFontSize(17).setDoneButton(title: "Done", font: fontLittle, color: .white) {
                    popover, selectedRow, selectedString in
                    sender.text = selectedString
                    
                    }.appear(originView: sender, baseViewController: self)
                
            }
            
        }
        
        
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "calculatorCell") as! CalculatorCell
        
        if indexPath.row == 0{
            cell.field.text = "Concentration" //+conc unit dependiendo de type
            cell.textField.tag = 0
            
            
            
            
            
            return cell
        }
        else{
            cell.field.text = "Weight"
            cell.textField.tag = 1
            
            
            return cell
        }
        
        
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
}



