//
//  VaccineViewController.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 09/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ProgressHUD

class VaccineViewController : UIViewController{
    
    @IBOutlet weak var selectedVaccineCategory: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    var vaccines : Results<Vaccine>?
    var registeredBabies : Results<Baby>?
    var vaccinesDoses : Results<VaccineDoses>?
    var babyApp = Baby()
    
    let sectionAge = ["2 months", "4 months", "11 months"]// "12 months", "15 months", "3-4 years", "6 years", "12-14 years", "19 years" ]
    var items = [[String]]()
    var dictAge = [String : [String]]()
    var dictDate = [String : String]()
    
    var defaultOptions = SwipeOptions()
    
    
    
    
    let font = UIFont(name: "Avenir-Heavy", size: 17)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.reloadData()
        
        loadBabiesAndVaccines()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "babyInfoCell")
        
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "F588F9")
        
        //        let font: [AnyHashable : Any] = [NSAttributedString.Key.font : UIFont(name: "Avenir-Medium", size: 15)]
        //        selectedVaccineCategory.setTitleTextAttributes(font as? [NSAttributedString.Key : Any], for: .normal)
        
        
    }
    override func willMove(toParent parent: UIViewController?) {
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "64C5CF")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100.0
        
    }
    
    //MARK: Data Manipulation
    

    func loadBabiesAndVaccines(){
        
        registeredBabies = realm.objects(Baby.self)
        
        if registeredBabies?.count != 0{
            
            babyApp = getCurrentBaby()
            vaccines = babyApp.vaccines.filter(NSPredicate(value: true))
            vaccinesDoses = realm.objects(VaccineDoses.self)
            
            tableView.reloadData()
            
            configureDictionariesOfVaccine()
        }
//        else {
//            vaccines = realm.objects(Vaccine.self)
//
//        }
        
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
            
            
            for i in vaccinesForAge!{
                arrayOfDoses.append(i.name)
                
            }
            for dose in vaccinesForDate{
                
                dictDate[string] = dose.correspondingDateOfVaccination
            }
            
            items.append(arrayOfDoses)
            dictAge[string] = arrayOfDoses
            
        }
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if registeredBabies == nil{
            return 0
        }
        else{
         return dictAge.count
        }
        

    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if babyApp.dateOfBirth.isEmpty{
            
            let controller = UIAlertController(title: "Warning", message: "The recommended dates for administering the vaccines could not be calculated, please enter the date of birth of \(babyApp.name)", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            controller.addAction(action)
            controller.show(animated: true, vibrate: true, style: .light, completion: nil)
            
            return "\(sectionAge[section])"
        }
        else{
             return ("\(sectionAge[section]) - \(dictDate[sectionAge[section]]!) (approx)")
        }

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "vaccineCell", for: indexPath) as! CustomCellVaccine
        
        cell.delegate = self
        
        if registeredBabies?.count == 0{
          cell.nameVaccine.text = "No babies added yet"
        }
        else{
          cell.nameVaccine.text = dictAge[sectionAge[indexPath.section]]![indexPath.row]
        }
       
        
        
        return cell
        
        
    }
    
    
    
    
    //MARK: Swipe Table View Cell Method
    
    
    
}

extension VaccineViewController : SwipeTableViewCellDelegate{
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        defaultOptions.transitionStyle = .drag
        
        if orientation == .left{
            
            let currentBabySwipeAction = SwipeAction(style: .default, title: nil) { action, indexPath in
                
                
                do{
                    
                    try self.realm.write {
                        
                        for vaccine in self.vaccines!{
                            
                            if vaccine.name == self.dictAge[self.sectionAge[indexPath.section]]![indexPath.row]{
                                
                                var dose = self.vaccinesDoses?.filter("ageOfVaccination == %@", self.sectionAge[indexPath.section])
                                dose = dose?.filter(" %@ IN parentVaccine", vaccine)
                                for i in dose!{
                                    i.applied = !i.applied
                                   print(i)
                                }
                            }

                        }
                        
                    }
                    
                    ProgressHUD.showSuccess("Vaccine \(self.dictAge[self.sectionAge[indexPath.section]]![indexPath.row]) has been administered" , interaction: true)
                    
                }
                catch{
                    print("Unable to set the current baby \(error)")
                }
            }
            
            currentBabySwipeAction.backgroundColor = UIColor.flatMint
            currentBabySwipeAction.hidesWhenSelected = true
            currentBabySwipeAction.image = UIImage(named: "doubletick")!
            //            if let delegate = self.delegate {
            //                currentBabySwipeAction.image = delegate.resizeImageIsCalled(image: UIImage(named: "doubletick")!, size: CGSize(width: 30, height: 30))
            //            }
            return [currentBabySwipeAction]
        }
        else{
            return nil
        }
        
        
        
    }
}
