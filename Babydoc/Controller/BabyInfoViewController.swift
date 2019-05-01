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
   
    
    //var properties : Results<Baby>?
    var realm = try! Realm()//var propertyDictionary = Dictionary<String,String>()
    var selectedBaby : Baby? {
        didSet{
            //loaditems()
        }
    }
    var schema : ObjectSchema?
    var count = 0
    var editingMode = false
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        schema = realm.schema["Baby"]
        
        let saveButton = UIButton(type: .custom)
        let image = UIImage(named : "add-color")
        saveButton.setImage(image, for: .normal)
        saveButton.frame.size = CGSize(width: 45, height: 45)
        saveButton.frame = CGRect(origin: CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.width/2  ), size: saveButton.frame.size)
        
        saveButton.layer.masksToBounds = false
        saveButton.layer.shadowColor = UIColor.flatGray.cgColor
        saveButton.layer.shadowOpacity = 0.7
        saveButton.layer.shadowRadius = 1
        saveButton.layer.shadowOffset = CGSize(width: 1.2, height: 1.2)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        self.view.addSubview(saveButton)
        
    }
    
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {

       //tableView.isUserInteractionEnabled = true
//        if editingMode == true {
//            // save the data
//            saveBabyInfo(baby : selectedBaby!)
//            editingEnd()
//        } else {
//            editingBegin()
//        }
        
        
    }
    @objc func saveButtonPressed(){
        if self.selectedBaby != nil{
            saveBabyInfo(baby : selectedBaby!)
            tableView.isUserInteractionEnabled = false
        }
        else{
            print("unable to save baby")
        }
        
        
    }
    
    

    
    // MARK: UITextViewDelegate
//    private func textViewDidChange(textView: UITextView) {
//        self.tableView.beginUpdates()
//        textView.frame = CGRect(x: textView.frame.minX, y: textView.frame.minY, width: textView.frame.width, height: textView.contentSize.height + 40)
//        self.tableView.endUpdates()
//    }
    //MARK - Table View Datasource method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schema?.properties.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "babyInfoCell", for: indexPath) as! BabyInfoCell
        cell.textView.delegate = self
        
        cell.property.text = schema?.properties[indexPath.row].name
        let propertyValue = selectedBaby?.value(forKeyPath: cell.property.text!)
        cell.textView.text = propertyValue as? String
        
        
        
//      
//        { //not nil
//            cell.textView.text = propertyValue as? String
//            print("not nil")
//
//        }
//        else if cell.textView.text.isEmpty{
//            let propertyValue = selectedBaby?.setValue(cell.textView.text, forKey: cell.property.text!)
//            cell.textView.text = propertyValue as? String
//            //cell.textView.text = selectedBaby?.value(forKeyPath: cell.property.text!) as? String
//            print("nil, no property")
//
//
//        }
        //tableView.reloadData()
        
        
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let newcell = cell as! BabyInfoCell
        newcell.tag = count
        newcell.textView.tag = count
        count = count + 1 
        //print("tag \(newcell.tag)")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60.0
       
    }
//    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
//        print(textView.text) //the textView parameter is the textView where text was changed
//    }
    func textViewDidEndEditing(_ textView: UITextView) {
        //print("text \(textView.text!)")
        // let cell = tableView.dequeueReusableCell(withIdentifier: "babyInfoCell") as! BabyInfoCell
        
        //print("tag \(textView.tag)")
        
        do{
            
            switch textView.tag {
            case 0:
                try self.realm.write {
                    self.selectedBaby?.name = textView.text
                    }
            case 1:
                let age = calcAge(birthday: textView.text)
                print(age)
                try self.realm.write {
                    self.selectedBaby?.age = String(age as NSInteger)
                }
            case 2:
                try self.realm.write {
                    self.selectedBaby?.dateOfBirth = textView.text
                }
            case 3:
                try self.realm.write {
                    self.selectedBaby?.height = (textView.text as NSString).floatValue
                }
            case 4:
                try self.realm.write {
                    self.selectedBaby?.weight = (textView.text as NSString).floatValue
                }
            case 5:
                try self.realm.write {
                    self.selectedBaby?.bloodType = textView.text
                }
            case 6:
                try self.realm.write {
                    self.selectedBaby?.alergies = textView.text
                }
            case 7:
                try self.realm.write {
                    self.selectedBaby?.illnesses = textView.text
                }
            default:
                ""
            }}
        
        catch{
            print("mala suerte")
        }
        
        //tableView.reloadData()
    }
    
    
    
    func saveBabyInfo(baby : Baby){
    
        do {

            try realm.write {
                //realm.add(baby.self, update: true)
                
            }
        } catch {
            print("Error saving done status, \(error)")
        }
       // tableView.reloadData()

        
    }
        func calcAge(birthday: String) -> Int {
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "MM/dd/yyyy"
            let birthdayDate = dateFormater.date(from: birthday)
            let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
            let now = Date()
            let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
            let age = calcAge.year
            return age!
        }






}
