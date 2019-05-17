//
//  MedicationViewController.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 15/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import UIKit
import RealmSwift
import RLBAlertsPickers
import APESuperHUD
import AUPickerCell


class MedicationViewController : UITableViewController{


    let realm = try! Realm()
    var registeredDrugs : Results<Medication>?
    
    let font = UIFont(name: "Avenir-Heavy", size: 17)
    let fontLight = UIFont(name: "Avenir-Medium", size: 17)
    let grayColor = UIColor.init(hexString: "555555")
    let grayLightColor = UIColor.init(hexString: "7F8484")
    let pinkcolor = UIColor.init(hexString: "F97DBE")
    
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        loadDrugs()
       
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60.0
        self.navigationController?.navigationBar.barTintColor = pinkcolor //FFA0D2
        self.navigationController?.navigationBar.backgroundColor = pinkcolor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        
    }
    override func willMove(toParent parent: UIViewController?) {
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "64C5CF")
    }
    
    
    //MARK: - Table View Data Source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return registeredDrugs?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableView.dequeueReusableCell(withIdentifier: "drugCell", for: indexPath)
        
        cell.textLabel?.text = registeredDrugs?[indexPath.row].name
        tableView.backgroundColor = UIColor.init(hexString: "F8F9F9")?.withAlphaComponent(CGFloat(0.995))
        cell.backgroundColor = UIColor.init(hexString: "F8F9F9")?.withAlphaComponent(CGFloat(0.995))
        
        return cell
    }
    
    
    //MARK: - Table View Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDrugTypes", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! MedicationTypesInfoViewController
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationVC.selectedDrug  = registeredDrugs?[indexpath.row]
            destinationVC.navigationItem.title = destinationVC.selectedDrug?.name
    
        }
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
 
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: Data manipulation
    func loadDrugs(){
        
        registeredDrugs = realm.objects(Medication.self)
        
        tableView.reloadData()
    }

}



