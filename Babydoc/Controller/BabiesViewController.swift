//
//  BabysViewController.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 29/04/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import UIKit
import RealmSwift
import PMAlertController
import SwipeCellKit


class BabiesViewController : UITableViewController{
    
    let realm = try! Realm()
    
    var registeredBabies : Results<Baby>?
    
    
    
    let normalColor = UIColor.flatGrayDark
    let font = UIFont(name: "Avenir-Heavy", size: 17)
    //init(hexString: "3BB4C1")
    let remainderColor = UIColor.flatYellowDark
    let deleteColor = UIColor.red
    let cancelColor = UIColor.flatSkyBlue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        
        //        let height: CGFloat = 50 //whatever height you want to add to the existing height
        //        let bounds = self.navigationController!.navigationBar.bounds
        //        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)
        
    }
    
    
    @IBAction func addBabyPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = PMAlertController(title: "Add New Baby", description: "", image: nil, style: .alert)
        
        alert.addTextField { (field) in
            
            textfield = field!
            textfield.placeholder = "New Baby..."
        }
        let add_action = PMAlertAction(title: "Add", style: .cancel) {
            let newBaby = Baby()
            newBaby.name = textfield.text!
            self.save(baby : newBaby)
        }
        add_action.setTitleColor(cancelColor, for: .normal)
        alert.addAction(add_action)
        
        
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    //MARK: - Table View Data Source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //this is called nil coalescing operator
        return registeredBabies?.count ?? 1 //1 is default when categories.count is nil
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "babiesCell", for: indexPath)
        cell.textLabel?.text = registeredBabies?[indexPath.row].name      ??   "No registeredBabies added yet" //default
    
        return cell
    }
    
    
    //MARK: - Table View Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToBabyInfo", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        //this is done before segue occurs
//        //each category has its own items so depending on which one you select,
//        //a table of items is going to appear or another
        let destinationVC = segue.destination as! BabyInfoViewController
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationVC.selectedBaby  = registeredBabies?[indexpath.row]
        }
    
    }
    
    //MARK: Data Manipulation
    func save(baby : Baby){
        
        
        do{
            try realm.write {
                //categories.append cannot be done because is of type Results and does not have a list
                realm.add(baby) //PERSIST DATA
            }
        }
        catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
        
        registeredBabies = realm.objects(Baby.self)
        
        tableView.reloadData()
        
    }
    
}
