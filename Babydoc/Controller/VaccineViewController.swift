//
//  VaccineViewController.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 09/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import UIKit
import RealmSwift

class VaccineViewController : UIViewController{
    
    @IBOutlet weak var selectedVaccineCategory: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    var vaccines : Results<Vaccine>?
    var registeredBabies : Results<Baby>?
    var babyApp = Baby()
    
    let sectionAge = ["2 months", "4 months", "11 months"]// "12 months", "15 months", "3-4 years", "6 years", "12-14 years", "19 years" ]
    var items = [[String]]()
    var dictAge = [String : [String]]()
    var dictDate = [String : String]()
    var dictNumOfDose = [String : String]()
 
    
    let font = UIFont(name: "Avenir-Heavy", size: 17)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        

        
        loadBabies()
        loadVaccines()
        configureDictionariesOfVaccine()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "babyInfoCell")
        
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "F588F9")

        let font: [AnyHashable : Any] = [NSAttributedString.Key.font : UIFont(name: "System", size: 15)!]
        selectedVaccineCategory.setTitleTextAttributes(font as? [NSAttributedString.Key : Any], for: .normal)
       

    }
    override func willMove(toParent parent: UIViewController?) {
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "64C5CF")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100.0

    }

  
    //MARK: Data Manipulation

    
    func loadVaccines(){
        
        babyApp = getCurrentBaby()

        vaccines = babyApp.vaccines.filter(NSPredicate(value: true))

        tableView.reloadData()
        
    }
    func loadBabies(){
        
        registeredBabies = realm.objects(Baby.self)

        
    }
    
    
    func getCurrentBaby() -> Baby{
        
        
        for baby in registeredBabies!{
            if baby.current == true{
                babyApp = baby
            }
        }
        return babyApp
    }
    
    func configureDictionariesOfVaccine(){

        var arrayOfDoses = [String]()
        for string  in sectionAge{
            
            arrayOfDoses = []
            let vaccinesForAge = vaccines?.filter("ANY doses.ageOfVaccination == %@", string)
           let vaccinesForDate = realm.objects(VaccineDoses.self).filter("ageOfVaccination == %@", string)
          //let vaccinesForNumOfDose = realm.objects(VaccineDoses.self).filter("numberOfDoses == %@", string)
            
            for i in vaccinesForAge!{
                arrayOfDoses.append(i.name)

            }
            for i in vaccinesForDate{
                print("dose: \(i.correspondingDateOfVaccination)")
                dictDate[string] = i.correspondingDateOfVaccination
            }
           
            items.append(arrayOfDoses)
            dictAge[string] = arrayOfDoses
            
        }

        print(dictDate)

     
     
        
        
    }


    
}


extension VaccineViewController : UITableViewDataSource, UITableViewDelegate{
    
    
    //MARK: Table View Data Source and Delegate Methods
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        let keyForSection = sectionAge[section]
//        let arrayOfStringsForKey = dictAge[keyForSection]
//        let numberOfRows = arrayOfStringsForKey.count
        return dictAge[sectionAge[section]]?.count ?? 0
    }

//    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return Array(dictAge.keys)
//    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return dictAge.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ("\(sectionAge[section]) - \(dictDate[sectionAge[section]]!) (approx)")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "vaccineCell", for: indexPath) as! CustomCellVaccine
 
        cell.nameVaccine.text = dictAge[sectionAge[indexPath.section]]![indexPath.row]
        
        let vaccinesDoses = realm.objects(VaccineDoses.self).filter(<#T##predicate: NSPredicate##NSPredicate#>)
        //vaccines?.filter("name == %@",dictAge[sectionAge[indexPath.section]]![indexPath.row])
     
        //let vaccinesForDate = realm.objects(VaccineDoses.self).filter("ageOfVaccination == %@", string)
        
        //cell.detailTextLabel!.text = //num doses of each dose
        
        return cell

        
        
 

        
        
        
    }

    
    
    
    
    
}
