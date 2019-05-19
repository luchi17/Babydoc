//
//  HistoryDosesViewController.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 18/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class HistoryDosesViewController : UITableViewController{
    
    
     let pinkcolor = UIColor.init(hexString: "F97DBE")
     let darkPinkColor = UIColor.init(hexString: "FB569F")
    
    let realm = try! Realm()
    var doses : Results<MedicationDoseCalculated>?
    var registeredBabies : Results<Baby>?
    var babyApp = Baby()
    var arrayDoses = Array<MedicationDoseCalculated>()
    
    
   override func viewDidLoad() {
     super.viewDidLoad()
     loadBabyAndDoses()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90.0
        self.navigationController?.navigationBar.barTintColor = darkPinkColor
        self.navigationController?.navigationBar.backgroundColor = darkPinkColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        
    }
    func loadBabyAndDoses(){
        
        registeredBabies = realm.objects(Baby.self)
       
        if registeredBabies?.count != 0{
            
            getCurrentBaby()
            doses = babyApp.medicationDoses.filter(NSPredicate(value: true))
            for dose in doses!{
                arrayDoses.append(dose)
            }
            print(arrayDoses)
            tableView.reloadData()
            
        }
        
        
    }
   
    func getCurrentBaby(){
        
        
        for baby in registeredBabies!{
            if baby.current == true{
                babyApp = baby
            }
        }

    }
    
    //Table View methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "doseCell", for: indexPath) as! CustomCellHistoryDose
        if arrayDoses.count == 0{
            cell.nameDose.text = "No records added yet"
            cell.descriptionDose.text = ""
            cell.descriptionDose2.text = ""
        }
        else{
            cell.nameDose.text = arrayDoses[indexPath.row].parentMedicationName + " " + arrayDoses[indexPath.row].nameType
            cell.descriptionDose.text = "Date: " + arrayDoses[indexPath.row].date + "\nConcentration: " + "\(arrayDoses[indexPath.row].concentration)"
            cell.descriptionDose2.text = "Weight: " + "\(arrayDoses[indexPath.row].weight)" + "\nApplied dose: " + arrayDoses[indexPath.row].dose
        }
        
        
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayDoses.count == 0{
            return 1
        }
        else{
            return arrayDoses.count
        }
        
    }
    
    
 
    
    
}
