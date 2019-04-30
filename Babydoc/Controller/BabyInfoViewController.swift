//
//  BabyInfoViewController.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 29/04/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import UIKit
import RealmSwift


class BabyInfoViewController : UITableViewController, UITextViewDelegate {
   
    @IBOutlet weak var illnessestxt: UITextView!
    
    @IBOutlet weak var allergiestxt: UITextView!
    
    @IBOutlet weak var bloodTypetxt: UITextView!
    
    @IBOutlet weak var heighttxt: UITextView!
    
    @IBOutlet weak var weighttxt: UITextView!
    
    @IBOutlet weak var agetxt: UITextView!
    @IBOutlet weak var dateOfBirthtxt: UITextView!
    
    @IBOutlet weak var nametxt: UITextView!
    
   
    
    func textViewDidChange(_ textView: UITextView) {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    
    //var properties : Results<Baby>?
    var realm = try! Realm()
    //var propertyDictionary = Dictionary<String,String>()
    var selectedBaby : Baby? {
        didSet{
            //the things inside this are going to be done once the category is created
            //loadItems()
            //we are going to load the items when we are certain that the selectedCat has been
            //created
            //loadItems()
        }
    }
    var schema : ObjectSchema?
    
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //propertyDictionary
//        schema = realm.schema["Baby"]
//        let properties = schema?.properties
       // print(properties)
        
        
    }
    // MARK: UITextViewDelegate
    func textViewDidChange(textView: UITextView) {
        self.tableView.beginUpdates()
        textView.frame = CGRect(x: textView.frame.minX, y: textView.frame.minY, width: textView.frame.width, height: textView.contentSize.height + 40)
        self.tableView.endUpdates()
    }
    //MARK - Table View Datasource method
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 8
//            //schema?.properties.count ?? 1
//    }
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//
//
//
//        return cell
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60.0
       
        
        //        let height: CGFloat = 50 //whatever height you want to add to the existing height
        //        let bounds = self.navigationController!.navigationBar.bounds
        //        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)
        
    }
    //MARK - Table View Delegate method
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        //if the item is not nil, select it and change its property
//        if let item = properties?[indexPath.row] {
//            do {
//
//                try realm.write {
//                    //TO DELETE : realm.delete(item) whenever you click on it
//                    item.done = !item.done
//                }
//            } catch {
//                print("Error saving done status, \(error)")
//            }
//        }
//
//
//        tableView.reloadData() //calls cell for row at index path to udpate cell's looking
//
//        //tableView.deselectRow(at: indexPath, animated: true)
//
//    }
    //MARK - ADD NEW ITEMS, we could do that to add new properties
    
    
//    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
//
//        var textfield = UITextField()
//        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
//        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
//            //wht will happen when the user clicks the add item button in alert
//
//            if let currentCategory = self.selectedCategory{
//                do{
//                    try self.realm.write {
//                        let newitem  = Item()
//                        newitem.title = textfield.text!
//                        newitem.dateOfCreation = Date()
//                        currentCategory.items.append(newitem)
//                        //instead of creating a save items function, we can just append the item to the specific list
//                        //and as it is of type Results with append is enough, no REALM.ADD is needed
//                        //SO: 1 (CATEGORY) --> save directly with save method (write and add)
//                        // N (ITEM) --> write to realm, append to 1, no add
//                    }
//
//                }
//                catch{
//                    print("error saving new items, \(error)")
//                }
//
//            }
//            self.tableView.reloadData()
//
//
//
//        }
//        alert.addTextField { (alertTextField) in
//            alertTextField.placeholder = "create new item"
//            textfield = alertTextField
//
//        }
//        alert.addAction(action)
//        present(alert,animated: true, completion: nil)
//    }
    
    
//    func loadItems(){
//
//        properties = selectedBaby?.name.sorted(
//        tableView.reloadData()
//    }
    


}
