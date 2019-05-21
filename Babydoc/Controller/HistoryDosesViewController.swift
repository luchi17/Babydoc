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
    let font = UIFont(name: "Avenir-Heavy", size: 17)
    let fontLight = UIFont(name: "Avenir-Medium", size: 17)
    let fontLittle = UIFont(name: "Avenir-Heavy", size: 16)
    let grayColor = UIColor.init(hexString: "555555")
    let grayLightColor = UIColor.init(hexString: "7F8484")
    
    let realm = try! Realm()
    var doses : Results<MedicationDoseCalculated>?
    var registeredBabies : Results<Baby>?
    var babyApp = Baby()
    var defaultOptions = SwipeOptions()
    var doseToEdit = MedicationDoseCalculated()
    
   override func viewDidLoad() {
     super.viewDidLoad()
    
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.barTintColor = pinkcolor
        self.navigationController?.navigationBar.backgroundColor = pinkcolor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        loadBabyAndDoses()
        
    }

    func loadBabyAndDoses(){
        
        registeredBabies = realm.objects(Baby.self)
       
        if registeredBabies?.count != 0{
            
            getCurrentBaby()
            doses = babyApp.medicationDoses.filter(NSPredicate(value: true)).sorted(byKeyPath: "date", ascending: false)
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
    
    func deleteDose(dose : MedicationDoseCalculated){
        
        do{
            
            try realm.write {
                realm.delete(dose)
                
            }
        }
        catch{
            print(error)
        }
        loadBabyAndDoses()
    }
    
    
    
    //Table View methods
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 129
    }
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "doseCell", for: indexPath) as! CustomCellHistoryDose
        
        if doses?.count == 0 || registeredBabies?.count == 0{
            cell.nameDose.text = "No records added yet"
            cell.descriptionDose.text = ""
            cell.descriptionDose2.text = ""
            cell.descriptionDose3.text = ""
        }
        else{
            cell.nameDose.text = (doses?[indexPath.row].parentMedicationName)! + " " + (doses?[indexPath.row].nameType)!
            cell.descriptionDose.text = "Date of administration: " + (doses?[indexPath.row].date)! + "\nConcentration: " + "\(doses?[indexPath.row].concentration ?? 0) \(doses?[indexPath.row].concentrationUnit ?? "")"
            cell.descriptionDose2.text = "Weight: " + "\(doses?[indexPath.row].weight ?? Float(0.0)) kg"
            cell.descriptionDose3.text = "Applied dose: " + (doses?[indexPath.row].dose)! + " " + (doses?[indexPath.row].doseUnit)!
        }
        cell.delegate = self
        
        
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if doses?.count == 0{
            return 1
        }
        else{
            return doses?.count ?? 1
        }
        
    }
  
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? EditDosesViewController{
            destinationVC.doseToEdit = self.doseToEdit
        }
    }
    
}
extension HistoryDosesViewController : SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        doseToEdit = doses![indexPath.row]
        defaultOptions.transitionStyle = .drag
        
        if orientation == .right{
            
            let removeSwipe = SwipeAction(style: .default, title: nil){ action , indexPath in
                
                let alert = UIAlertController(title: "Remove Dose", message: "Are you sure you want to remove this dose permanently?", preferredStyle: .alert)
                
                let removeAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (alertAction) in
                    
                    self.deleteDose(dose: self.doses![indexPath.row])
                    
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) in
                    
                })
                
                alert.setTitle(font: self.font!, color: self.grayColor!)
                alert.setMessage(font: self.fontLight!, color: self.grayLightColor!)
                alert.addAction(removeAction)
                alert.addAction(cancelAction)
                alert.show(animated: true, vibrate: true, style: .prominent, completion: nil)
                
            }
            removeSwipe.image = UIImage(named: "delete-icon")
            removeSwipe.backgroundColor = .red
            removeSwipe.hidesWhenSelected = true
           
            
            return [removeSwipe]
            
            
        }
        else{

            
            let editSwipeAction = SwipeAction(style: .default, title: nil) { action, indexPath in
                
                
                self.performSegue(withIdentifier: "goToEdit", sender: self.self)
            }
            editSwipeAction.image = UIImage(named: "editt")
            editSwipeAction.hidesWhenSelected = true

            
            return [editSwipeAction]
            
        }
        
    }
    
    
    
}

