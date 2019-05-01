//
//  BabyInfoViewController.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 29/04/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import UIKit
import RealmSwift
import AUPickerCell


class BabyInfoViewController : UITableViewController, AUPickerCellDelegate{
    
    func auPickerCell(_ cell: AUPickerCell, didPick row: Int, value: Any) {
        print(value)
    }
    
  

//
    var properties : Results<Baby>?
    var realm = try! Realm()
    var propertyDictionary : [String:String] = [:]
    var selectedBaby : Baby? {
        didSet{
            //loaditems()
        }
    }
   var schema : ObjectSchema?
//    var count = 0

    
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

        tableView.register(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "babyInfoCell")
        propertyDictionary = ["userId":"User ID","password":"Password","name":"Name","dateOfBirth" : "Date of Birth","age": "Age", "height":"Height","weight":"Weight","bloodType":"Blood Type","allergies" : "Allergies","illnesses":"Illnesses","calendar" : "Calendar"]
    
    }
//
//
//    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
//
//       //tableView.isUserInteractionEnabled = true
////        if editingMode == true {
////            // save the data
////            saveBabyInfo(baby : selectedBaby!)
////            editingEnd()
////        } else {
////            editingBegin()
////        }
//
//
//    }
    @objc func saveButtonPressed(){
        if self.selectedBaby != nil{
            saveBabyInfo(baby : selectedBaby!)
            //tableView.isUserInteractionEnabled = false
        }
        else{
            print("unable to save baby")
        }


    }
//
//
//
//
//    // MARK: UITextViewDelegate
////    private func textViewDidChange(textView: UITextView) {
////        self.tableView.beginUpdates()
////        textView.frame = CGRect(x: textView.frame.minX, y: textView.frame.minY, width: textView.frame.width, height: textView.contentSize.height + 40)
////        self.tableView.endUpdates()
////    }
//    //MARK - Table View Datasource method
//

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
            //schema?.properties.count ?? 1
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellBabyInfo = tableView.dequeueReusableCell(withIdentifier: "babyInfoCell", for: indexPath) as! TextFieldTableViewCell
        let cellDate = AUPickerCell(type: .date, reuseIdentifier: "PickerDateCell")
        switch indexPath.row {
        case 0:
                   //User
            cellBabyInfo.separatorInset = UIEdgeInsets.zero
            cellBabyInfo.fieldNameLabel.text! = (propertyDictionary[schema!.properties[indexPath.row].name]! as String)
            cellBabyInfo.fieldValueTextfield.text = selectedBaby?.value(forKeyPath: Array(propertyDictionary)[indexPath.row].key) as? String
            return cellBabyInfo
            
        case 1:
                //Password
            cellBabyInfo.separatorInset = UIEdgeInsets.zero
            cellBabyInfo.fieldNameLabel.text! = (propertyDictionary[schema!.properties[indexPath.row].name]! as String)
            cellBabyInfo.fieldValueTextfield.text = selectedBaby?.value(forKeyPath: Array(propertyDictionary)[indexPath.row].key) as? String
            cellBabyInfo.fieldValueTextfield.isSecureTextEntry = true
            return cellBabyInfo
            
        case 3:
            
            cellDate.delegate = self
            cellDate.separatorInset = UIEdgeInsets.zero
            cellDate.datePickerMode = .time
            cellDate.timeZone = TimeZone(abbreviation: "UTC")
            cellDate.dateStyle = .none
            cellDate.timeStyle = .short
            cellDate.leftLabel.text = (propertyDictionary[schema!.properties[indexPath.row].name]! as String)
            cellDate.leftLabel.textColor = UIColor.lightText
            cellDate.rightLabel.textColor = UIColor.darkText
            cellDate.tintColor = #colorLiteral(red: 0.9382581115, green: 0.8733785748, blue: 0.684623003, alpha: 1)
            cellDate.backgroundColor = #colorLiteral(red: 0.6344745755, green: 0.5274511576, blue: 0.4317585826, alpha: 1)
            cellDate.separatorHeight = 1
            cellDate.unexpandedHeight = 80
            return cellDate
            
        default:
            cellBabyInfo.separatorInset = UIEdgeInsets.zero
            cellBabyInfo.fieldNameLabel.text! = (propertyDictionary[schema!.properties[indexPath.row].name]! as String)
            cellBabyInfo.fieldValueTextfield.text = selectedBaby?.value(forKeyPath: Array(propertyDictionary)[indexPath.row].key) as? String
            return cellBabyInfo
        }
  
    }



////    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
////        let newcell = cell
////        newcell.tag = count
////        //newcell.textView.tag = count
////        count = count + 1
////        //print("tag \(newcell.tag)")
////
////    }
//
    override func viewWillAppear(_ animated: Bool) {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60.0

    }
////    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
////        print(textView.text) //the textView parameter is the textView where text was changed
////    }
//    func textViewDidEndEditing(_ textView: UITextView) {
//        //print("text \(textView.text!)")
//        // let cell = tableView.dequeueReusableCell(withIdentifier: "babyInfoCell") as! BabyInfoCell
//
//        //print("tag \(textView.tag)")
//
//        do{
//
//            switch textView.tag {
//            case 0:
//                try self.realm.write {
//                    self.selectedBaby?.name = textView.text
//                    }
//            case 1:
////                let age = calcAge(birthday: textView.text)
////                print(age)
//                try self.realm.write {
//                    self.selectedBaby?.age = textView.text
//                }
//            case 2:
//                try self.realm.write {
//                    self.selectedBaby?.dateOfBirth = textView.text
//                }
//            case 3:
//                try self.realm.write {
//                    self.selectedBaby?.height = (textView.text as NSString).floatValue
//                }
//            case 4:
//                try self.realm.write {
//                    self.selectedBaby?.weight = (textView.text as NSString).floatValue
//                }
//            case 5:
//                try self.realm.write {
//                    self.selectedBaby?.bloodType = textView.text
//                }
//            case 6:
//                try self.realm.write {
//                    self.selectedBaby?.allergies = textView.text
//                }
//            case 7:
//                try self.realm.write {
//                    self.selectedBaby?.illnesses = textView.text
//                }
//            default:
//                ""
//            }}
//
//        catch{
//            print("mala suerte")
//        }
//
//        //tableView.reloadData()
//    }
//
//
//
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
//
    
        
//        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return 2
//        }
    

        
        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if let cell = tableView.cellForRow(at: indexPath) as? AUPickerCell {
                return cell.height
            }
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            if let cell = tableView.cellForRow(at: indexPath) as? AUPickerCell {
                cell.selectedInTableView(tableView)
            }
        }
}
