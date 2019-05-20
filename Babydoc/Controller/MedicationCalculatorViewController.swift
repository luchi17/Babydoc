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
import RLBAlertsPickers
import SwiftyPickerPopover

class MedicationCalculatorViewController : UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    let font = UIFont(name: "Avenir-Heavy", size: 17)
    let fontLittle = UIFont(name: "Avenir-Heavy", size: 16)
    let fontLight = UIFont(name: "Avenir-Medium", size: 17)
    let pinkcolor = UIColor.init(hexString: "F97DBE")
    let darkPinkColor = UIColor.init(hexString: "FB569F")
    let lightPinkColor = UIColor.init(hexString: "FFA0D2")
    let grayColor = UIColor.init(hexString: "555555")
    let grayLightColor = UIColor.init(hexString: "7F8484")
    @IBOutlet weak var saveButton: UIButton!
    
    
    @IBOutlet weak var admRoute: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var suggestions: UILabel!
    
    @IBOutlet weak var resultCalculator: UILabel!
    @IBOutlet weak var maxDose: UILabel!
    
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var hyperLink: UITextView!
    var registeredBabies : Results<Baby>?
    var babyApp = Baby()
    var medicationToSave = MedicationDoseCalculated()
    
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
    var drugs : Results<Medication>?
    var parentMedication : Medication?
    var concentrations = Array<Int>()
    var concentrationsPopOver = Array<StringPickerPopover.ItemType>()
    var weightsPopOver = Array<StringPickerPopover.ItemType>()
    
    
    var link = ""
    var suggestion = ""
    var routeOfAdm = ""
    var concentrationUnit : String = ""
    var minimumWeight = 0
    var maximumWeight = 60
    var concentrationSelected = 0
    var weightUnit = ""
    var weightSelected = Float(0.0)
    var maxDoseParent = ""
    
    //MARK: View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        saveButton.layer.cornerRadius = 2
        saveButton.layer.masksToBounds = false
        saveButton.layer.shadowColor = UIColor.flatGray.cgColor
        saveButton.layer.shadowOpacity = 0.7
        saveButton.layer.shadowRadius = 1
        saveButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        admRoute.text = routeOfAdm
        type.text = "\(selectedTypeParentName ?? "" ) \(selectedTypeName ?? "")"
        loadBabies()
        getCurrentBabyApp()
        
        
    }
    override func viewDidLayoutSubviews(){
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.contentSize.height)
        tableView.reloadData()
    }
    override func willMove(toParent parent: UIViewController?) {
        self.navigationController?.navigationBar.barTintColor = pinkcolor
    }
    
    override func viewWillAppear(_ animated: Bool) {

        self.navigationController?.navigationBar.barTintColor = lightPinkColor
        self.navigationController?.navigationBar.backgroundColor = lightPinkColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

    }
    
    //MARK: Data manipulation
    
    
    func loadSpecificTypeOfDrug(){
        
        drugs = realm.objects(Medication.self).filter("name == %@",selectedTypeParentName as Any)
        for drug in drugs!{
            maxDoseParent = drug.maxDose
            parentMedication = drug
            break
        }
        drugTypes = realm.objects(MedicationType.self).filter( "parentMedicationName == %@ AND name == %@",selectedTypeParentName as Any, selectedTypeName as Any)
        
        for type in drugTypes!{
            concentrations.append(Int(type.concentration))
            
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
            suggestion = type.suggestion

            break
        }
        hyperLink.text = link
        suggestions.text = suggestion
        
        weightsPopOver = []
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
  
    
    //MARK: Calculate doses methods
    
    func extractPosologyValues(posology: String)->Float{
        
        var value = Float(0.0)
        let stringArray = posology.components(separatedBy: CharacterSet.decimalDigits.inverted)
        for item in stringArray {
            if let number = Float(item){
                value = number
                break
            }
            
        }
        return value
        
    }
    
    
    func calcLiquid(concentration : Int, weight : Float)->String{
        
        var finalString = ""
        var multValue = Float(0.0)
        var value6h = Float(0.0)
        var value8h = Float(0.0)
        let posologyString = parentMedication?.maxDose
        let posologyFloat = extractPosologyValues(posology: posologyString!)
        
        multValue = ((weight*posologyFloat)/Float(concentration))
        value6h = multValue/4
        value6h = round(value6h * 10) / 10
        value8h = multValue/3
        value8h = round(value8h * 10) / 10
        
        
        finalString = "\(value6h) ml every 6 hours \nor\n\(value8h) ml every 8 hours"
        
        if selectedTypeName == "Drops"{
            
            finalString = "\(Int(value6h * 25)) drops every 6 hours\nor\n\(Int(value8h * 25)) drops every 8 hours"
            
        }
       
        return finalString
    }
    
    
    
    
    func calcSolid(concentration : Int, weight : Float)->String{
        
        var finalString = ""
        var multValue = Float(0.0)
        var numberOfDoses = 0
        let posologyString = parentMedication?.maxDose
        let posologyFloat = extractPosologyValues(posology: posologyString!)
        multValue = weight*posologyFloat
        multValue = multValue/Float(concentration)
        numberOfDoses = Int(multValue)
        
        if selectedTypeName == "Suppository"{
            finalString = "\(numberOfDoses) suppositories in 24 hours"
        }
        else if selectedTypeName == "Chewable Tablets"{
            finalString = "\(numberOfDoses) chewable tablets in 24 hours"
        }
        else if selectedTypeName == "Tablets"{
            finalString = "\(numberOfDoses) tablets in 24 hours"
        }
        else if selectedTypeName == "Tablets"{
            finalString = "\(numberOfDoses) tablets in 24 hours"
        }

        return finalString
    }
    
    func calcMaxDoseDay(concentration : Int, weight : Float)->String{
        
        var stringMaxDose = ""
        var doseValue = Float(0.0)
        let maxdose = extractPosologyValues(posology: parentMedication!.maxDose)
        
        doseValue = maxdose*weight
        
        if concentrationUnit == "mg/ml"{
            let value = doseValue/Float(concentration)
            stringMaxDose = "Maximum dose per day: \(value) ml"
        }
        else if concentrationUnit == "mg"{

            stringMaxDose = "Maximum dose per day: \(Int(doseValue)) \(concentrationUnit)"

            
        }
       
        
        return stringMaxDose
        
        
    }
    
    //MARK: ToSave methods
    func loadBabies(){
        
        registeredBabies = realm.objects(Baby.self)
        
        tableView.reloadData()
        
    }
    
    func getCurrentBabyApp(){
        
        
        for baby in registeredBabies!{
            if baby.current == true{
                babyApp = baby
            }
        }
    }
    
    
   
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        loadBabies()
        if babyApp.name.isEmpty || self.weightSelected == 0 || self.concentrationSelected == 0{
            
            let alert = UIAlertController(title: "Error", message: "In order to save the dose all the fields must be filled in and at least one baby has to be registered in Babydoc.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.setMessage(font: fontLight!, color: grayLightColor!)
            alert.setTitle(font: font!, color: grayColor!)
            alert.show(animated: true, vibrate: true, style: .light, completion: nil)
        }


        else{
            
            medicationToSave = MedicationDoseCalculated()
            medicationToSave.concentration = self.concentrationSelected
            medicationToSave.concentrationUnit = self.concentrationUnit
            medicationToSave.weight = self.weightSelected
            medicationToSave.nameType = self.selectedTypeName!
            medicationToSave.parentMedicationName = self.selectedTypeParentName!
            
             performSegue(withIdentifier: "goToSave", sender: self)
        }
        

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? SaveDoseViewController{
            destinationVC.medication = self.medicationToSave
            destinationVC.baby = self.babyApp
            
        }
        
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if babyApp.name.isEmpty || self.weightSelected == 0 || self.concentrationSelected == 0{
            return false
        }
        return true
    }
       //MARK: Textfield method
    
    @IBAction func textFieldTouchedDown(_ sender: UITextField) {
        
        
        sender.textColor = grayLightColor
        sender.font = font
        
        if sender.tag == 0{
            
            var result = ""
            let picker =  StringPickerPopover(title: concentrationUnit, choices: concentrationsPopOver)
            picker.setArrowColor(pinkcolor!)
            picker.setFontColor(grayLightColor!).setFont(font!).setSize(width: 220, height: 150).setFontSize(17).setDoneButton(title: "Done", font: fontLittle, color: .white) {
                popover, selectedRow, selectedString in
                sender.text = selectedString + " " + self.concentrationUnit
                self.concentrationSelected = Int(selectedString)!
                self.configureProperties(selectedConcentration:selectedString)
                
                if self.weightSelected != 0.0{
                    
                    if self.concentrationUnit == "mg/ml"{
                        result = self.calcLiquid(concentration: self.concentrationSelected , weight: Float(self.weightSelected))
                    }
                    else if self.concentrationUnit == "mg"{
                        result = self.calcSolid(concentration: self.concentrationSelected, weight: Float(self.weightSelected))
                    }
                    
                    self.resultCalculator.text = result
                    
                    self.maxDose.text = self.calcMaxDoseDay(concentration: self.concentrationSelected, weight: Float(self.weightSelected))
                    
                }
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
                var result = ""
                let picker = StringPickerPopover(title: "kg", choices: weightsPopOver)
                picker.setArrowColor(pinkcolor!)
                picker.setFontColor(grayLightColor!).setFont(font!).setSize(width: 180, height: 220).setFontSize(17).setDoneButton(title: "Done", font: fontLittle, color: .white) {
                    popover, selectedRow, selectedString in
                    sender.text = selectedString + " kg"
                    self.weightSelected = Float(selectedString)!

                    if self.concentrationUnit == "mg/ml"{
                        result = self.calcLiquid(concentration: self.concentrationSelected , weight: Float(self.weightSelected))
                    }
                    else if self.concentrationUnit == "mg"{
                        result = self.calcSolid(concentration: self.concentrationSelected, weight: Float(self.weightSelected))
                    }

                    self.resultCalculator.text = result

                    self.maxDose.text = self.calcMaxDoseDay(concentration: self.concentrationSelected, weight: Float(self.weightSelected))

                    }.appear(originView: sender, baseViewController: self)
                
            }
            
        }
        
    }
    
    
    //MARK: TableView Delegate and Datasource methods
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "calculatorCell") as! CalculatorCell
        
        if indexPath.row == 0{
            cell.field.text = "Concentration"
            cell.textField.tag = 0
            cell.textField.delegate = self
            return cell
        }
        else{
            cell.field.text = "Weight"
            cell.textField.tag = 1
             cell.textField.delegate = self
            
            return cell
        }
        
        
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
}

extension MedicationCalculatorViewController: UITextFieldDelegate{
    
    
   func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}



