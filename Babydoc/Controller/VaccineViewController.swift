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
import APESuperHUD

class VaccineViewController : UIViewController{
    
    @IBOutlet weak var selectedVaccineCategory: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func selectedVaccineCategoryChanged(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    let realm = try! Realm()
    var vaccines : Results<Vaccine>?
    var registeredBabies : Results<Baby>?
    var vaccinesDoses : Results<VaccineDoses>?
    var babyApp = Baby()
    
    let sectionAgeFunded = ["2 months", "4 months", "11 months", "12 months","3-4 years", "6 years", "11-12 years","12-14 years", "Up to 19 years"]
    let sectionAgeNonFunded = ["2 months", "3 months", "4 months", "5 months", "12 months"]
    var dictAgeFunded = [String : [String]]()
    var dictDateFunded = [String : String]()
    var dictAgeNonFunded = [String : [String]]()
    var dictDateNonFunded = [String : String]()

    
    var defaultOptions = SwipeOptions()
    let font = UIFont(name: "Avenir-Heavy", size: 17)
    let fontLight = UIFont(name: "Avenir-Medium", size: 17)
    let grayColor = UIColor.init(hexString: "555555")
    let grayLightColor = UIColor.init(hexString: "7F8484")
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
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
        
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "F588F9")
        self.navigationController?.navigationBar.backgroundColor = UIColor(hexString: "F588F9")
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 110.0
        loadBabiesAndVaccines()
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
            if self.registeredBabies!.count > 0 && self.babyApp.dateOfBirth.isEmpty{
                
                let controller = UIAlertController(title: "Warning", message: "The recommended dates for the vaccines' administration could not be calculated, please enter the date of birth of \(self.babyApp.name)", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Remind me later", style: .default) { (alertAction) in
                    alertAction.isEnabled = false
                }
                let changeDob = UIAlertAction(title: "Change date of birth", style: .cancel) { (alertAction) in
                    self.performSegue(withIdentifier: "goToChangeDob", sender: self)
                }
                
                controller.setTitle(font: self.font!, color: self.grayColor!)
                controller.setMessage(font: self.fontLight!, color: self.grayLightColor!)
                controller.addAction(action)
                controller.addAction(changeDob)
                controller.show(animated: true, vibrate: true, style: .light, completion: nil)
                
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! BabyInfoViewController
        
        destinationVC.selectedBaby  = babyApp
        destinationVC.navigationItem.title = destinationVC.selectedBaby?.name
        if #available(iOS 11.0, *) {
            // We choose not to have a large title for the destination view controller.
            segue.destination.navigationItem.largeTitleDisplayMode = .always
            segue.destination.navigationController?.navigationBar.prefersLargeTitles = true
            
        }
        segue.destination.navigationController?.navigationBar.tintColor = UIColor(hexString: "64C5CF")
        
        
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
        
        var arrayOfDosesFunded = [String]()
        var arrayOfDosesNonFunded = [String]()
        
        for string  in sectionAgeFunded{
            
            arrayOfDosesFunded = []
            
            let vaccinesForAgeFunded = vaccines?.filter("ANY doses.ageOfVaccination == %@ AND funded == %@", string, true)
            let vaccinesForDateFunded = vaccinesDoses!.filter("ageOfVaccination == %@", string)
            
            
            
            for vaccineFunded in vaccinesForAgeFunded!{
                arrayOfDosesFunded.append(vaccineFunded.name)
                
                
            }
            
            
            for dose in vaccinesForDateFunded{
                
                dictDateFunded[string] = dose.dateOfVaccination
                
            }
            
            dictAgeFunded[string] = arrayOfDosesFunded
            
            
        }
        
        for string  in sectionAgeNonFunded{
            
            arrayOfDosesNonFunded = []
            
            let vaccinesForAgeNonFunded = vaccines?.filter("ANY doses.ageOfVaccination == %@ AND funded == %@", string, false)
            
            let vaccinesForDateNonFunded = vaccinesDoses!.filter("ageOfVaccination == %@", string)
            
            
            for dose in vaccinesForDateNonFunded{
                dictDateNonFunded[string] = dose.dateOfVaccination
            }
            
            for vaccineNonFunded in vaccinesForAgeNonFunded!{
                arrayOfDosesNonFunded.append(vaccineNonFunded.name)
                
            }
            dictAgeNonFunded[string] = arrayOfDosesNonFunded
            
        }
        
        
    }
    
}
    


//MARK: Table View Data Source and Delegate Methods


extension VaccineViewController : UITableViewDataSource, UITableViewDelegate{
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if registeredBabies?.count == 0{
            return 1
        }
            
        else{
            
            var returnValue = 1
            
            switch selectedVaccineCategory.selectedSegmentIndex {
                
            case 0:
                
                returnValue = dictAgeFunded[sectionAgeFunded[section]]!.count
                break
                
            case 1:
                returnValue = dictAgeNonFunded[sectionAgeNonFunded[section]]!.count
                break

            default:
                break
            }
            
            return returnValue
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var returnValue = 1
        if registeredBabies?.count == 0{
            return 1
        }
        
        switch selectedVaccineCategory.selectedSegmentIndex {
            
        case 0:
            
            returnValue = dictAgeFunded.count
            
            break
            
        case 1:
            returnValue = dictAgeNonFunded.count
            
            break

        default:
            break
        }
        
        return returnValue
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if registeredBabies?.count == 0 {
            return " "
        }
            
        else if registeredBabies!.count > 0 && babyApp.dateOfBirth.isEmpty{
            
            switch selectedVaccineCategory.selectedSegmentIndex{
            case 0:
                return "\(sectionAgeFunded[section])"
            case 1:
                return "\(sectionAgeNonFunded[section])"
            default:
                return "error"
                
            }
            
        }
            
        else if registeredBabies!.count > 0 && !babyApp.dateOfBirth.isEmpty{
            
            
            switch selectedVaccineCategory.selectedSegmentIndex{
            case 0:
                return ("\(sectionAgeFunded[section]) - \(dictDateFunded[sectionAgeFunded[section]]!) (approx)")
            case 1:
                return ("\(sectionAgeNonFunded[section])- \(dictDateNonFunded[sectionAgeNonFunded[section]]!) (approx)")
            default:
                return "error"
                
            }
            
        }
        else{
            return "error"
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "vaccineCell") as! CustomCellVaccine
        
        cell.delegate = self
        
        switch selectedVaccineCategory.selectedSegmentIndex{
            
        case 0:
            
            if registeredBabies?.count == 0{
                cell.nameVaccine.text = "No babies added yet"
                cell.accessoryType = .none
            }
            else{
                cell.nameVaccine.text = dictAgeFunded[sectionAgeFunded[indexPath.section]]![indexPath.row]
                let vaccinesApplied = vaccines?.filter("name == %@", dictAgeFunded[sectionAgeFunded[indexPath.section]]![indexPath.row])
                
                for vaccine in vaccinesApplied!{
                    var dose = self.vaccinesDoses?.filter("ageOfVaccination == %@ AND applied == %@", sectionAgeFunded[indexPath.section], true)
                    dose = dose?.filter(" %@ IN parentVaccine", vaccine)
                    if dose?.count != 0{
                        cell.nameVaccine.textColor = grayColor
                    }
                    else {
                        cell.nameVaccine.textColor = UIColor.init(hexString: "CC16CF")
                    }
                    
                }
            }
            
            break
            
        case 1:
            if registeredBabies?.count == 0{
                cell.nameVaccine.text = "No babies added yet"
                cell.accessoryType = .none
            }
            else{
                cell.nameVaccine.text = dictAgeNonFunded[sectionAgeNonFunded[indexPath.section]]![indexPath.row]
                let vaccinesApplied = vaccines?.filter("name == %@", dictAgeNonFunded[sectionAgeNonFunded[indexPath.section]]![indexPath.row])
                
                for vaccine in vaccinesApplied!{
                    var dose = self.vaccinesDoses?.filter("ageOfVaccination == %@ AND applied == %@", sectionAgeNonFunded[indexPath.section], true)
                    dose = dose?.filter(" %@ IN parentVaccine", vaccine)
                    if dose?.count != 0{
                        cell.nameVaccine.textColor = grayColor
                    }
                    else {
                        cell.nameVaccine.textColor = UIColor.init(hexString: "CC16CF")
                    }
                    
                }
            }
            
            break

        default:
            break
            
        }
        
        
        return cell
        
        
    }
    

    
}
 //MARK: Swipe Table View Cell Method

extension VaccineViewController : SwipeTableViewCellDelegate{
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        defaultOptions.transitionStyle = .drag
        
        if orientation == .left{
            
            switch selectedVaccineCategory.selectedSegmentIndex{
                
            case 0 :
                let currentBabySwipeAction = SwipeAction(style: .default, title: nil) { action, indexPath in
                    do{
                        
                        try self.realm.write {
                            
                            for vaccine in self.vaccines!{
                                
                                if vaccine.name == self.dictAgeFunded[self.sectionAgeFunded[indexPath.section]]![indexPath.row]{
                                    
                                    var dose = self.vaccinesDoses?.filter("ageOfVaccination == %@", self.sectionAgeFunded[indexPath.section])
                                    dose = dose?.filter("%@ IN parentVaccine", vaccine)
                                    for i in dose!{
                                        i.applied = !i.applied
                                        
                                    }
                                }
                                
                            }
                            
                        }
                        tableView.reloadData()
                        
                        let image = UIImage(named: "doubletick")!
                        let hudViewController = APESuperHUD(style: .icon(image: image, duration: 2), title: nil, message: "This vaccine dose has been administered")
                        HUDAppearance.cancelableOnTouch = true
                        HUDAppearance.messageFont = self.fontLight!
                        HUDAppearance.messageTextColor = self.grayColor!
                        
                        self.present(hudViewController, animated: true)
                        
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
                
            case 1 :
                let currentBabySwipeAction = SwipeAction(style: .default, title: nil) { action, indexPath in
                    
                    do{
                        
                        try self.realm.write {
                            
                            for vaccine in self.vaccines!{
                                
                                if vaccine.name == self.dictAgeNonFunded[self.sectionAgeNonFunded[indexPath.section]]![indexPath.row]{
                                    
                                    var dose = self.vaccinesDoses?.filter("ageOfVaccination == %@", self.sectionAgeNonFunded[indexPath.section])
                                    dose = dose?.filter("%@ IN parentVaccine", vaccine)
                                    for i in dose!{
                                        i.applied = !i.applied
                                        
                                    }
                                }
                                
                            }
                            
                        }
                        tableView.reloadData()
                        
                        let image = UIImage(named: "doubletick")!
                        let hudViewController = APESuperHUD(style: .icon(image: image, duration: 2), title: nil, message: "This vaccine dose has been administered")
                        HUDAppearance.cancelableOnTouch = true
                        HUDAppearance.messageFont = self.fontLight!
                        HUDAppearance.messageTextColor = self.grayColor!
                        
                        self.present(hudViewController, animated: true)
                        
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
                
            default:
                return nil

            }
            
            
        }
        else{
            return nil
        }
        
    }
        
    
}
