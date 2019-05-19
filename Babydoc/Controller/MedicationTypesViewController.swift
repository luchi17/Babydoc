//
//  MedicationTypesViewController.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 15/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import RLBAlertsPickers

class MedicationTypesInfoViewController : UITableViewController{
    
    var realm = try! Realm()
    var selectedDrug : Medication? {
        didSet{
            loadTypesOfDrug()
            
        }
    }
    var drugTypes : Results<MedicationType>?
    var arrayNameOfTypes = Array<String>()
    let pinkcolor = UIColor.init(hexString: "F97DBE")
    let darkPinkColor = UIColor.init(hexString: "FB569F")
    let lightPinkColor = UIColor.init(hexString: "FFA0D2")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureArrayOfNameTypes()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60.0
        self.navigationController?.navigationBar.barTintColor = pinkcolor
        self.navigationController?.navigationBar.backgroundColor = pinkcolor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        

    }
    
    func loadTypesOfDrug(){
        
        drugTypes = realm.objects(MedicationType.self).filter( "parentMedicationName == %@",selectedDrug?.name as Any)

        tableView.reloadData()
    }
    
    func configureArrayOfNameTypes(){
        
        for type in drugTypes!{
            
            //para no repetir syrup syrups dos veces.
            if !arrayNameOfTypes.contains(type.name){
                arrayNameOfTypes.append(type.name)
            }
        }
 
        
    }
    
    
    //MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayNameOfTypes.count 
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "typesCell", for: indexPath)
        
        tableView.backgroundColor = UIColor.init(hexString: "F8F9F9")?.withAlphaComponent(CGFloat(0.995))
        cell.backgroundColor = UIColor.init(hexString: "F8F9F9")
        cell.textLabel?.text = arrayNameOfTypes[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToCalculator", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let destinationVC = segue.destination as? MedicationCalculatorViewController {
            if let indexpath = tableView.indexPathForSelectedRow {
                
                destinationVC.selectedTypeParentName = selectedDrug!.name
                destinationVC.selectedTypeName = arrayNameOfTypes[indexpath.row]
                
                
            }
           
        }

    }
   
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    
    
    
}
