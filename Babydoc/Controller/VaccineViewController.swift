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
    var dictFundedDateAdm = [String : [String]]()
    var dictNonFundedDateAdm = [String : [String]]()
    
    
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
        tableView.estimatedRowHeight = 100.0
        loadBabiesAndVaccines()
        
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
            if self.registeredBabies!.count > 0 && !self.babyApp.name.isEmpty && self.babyApp.dateOfBirth.isEmpty{
                
                let controller = UIAlertController(title: "Warning", message: "The recommended dates for the vaccines' administration could not be calculated, please enter the date of birth of \(self.babyApp.name)", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Remind me later", style: .default) { (alertAction) in
                    alertAction.isEnabled = false
                }
                let changeDob = UIAlertAction(title: "Edit date of birth", style: .cancel) { (alertAction) in
                    self.performSegue(withIdentifier: "goToChangeDob", sender: self)
                }
                
                controller.setTitle(font: self.font!, color: self.grayColor!)
                controller.setMessage(font: self.fontLight!, color: self.grayLightColor!)
                controller.addAction(action)
                controller.addAction(changeDob)
                controller.show(animated: true, vibrate: false, style: .light, completion: nil)
                
            }
            else if self.babyApp.name.isEmpty{
                
                let controller = UIAlertController(title: "Warning", message: "There are no active babys in Babydoc", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Ok", style: .default)
               
                controller.setTitle(font: self.font!, color: self.grayColor!)
                controller.setMessage(font: self.fontLight!, color: self.grayLightColor!)
                controller.addAction(action)
                controller.show(animated: true, vibrate: false, style: .light, completion: nil)
            
            
        }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationVC = segue.destination as? BabyInfoViewController {
            
            
            destinationVC.selectedBaby  = babyApp
            destinationVC.navigationItem.title = destinationVC.selectedBaby?.name
            if #available(iOS 11.0, *) {
                // We choose not to have a large title for the destination view controller.
                destinationVC.navigationItem.largeTitleDisplayMode = .always
                destinationVC.navigationController?.navigationBar.prefersLargeTitles = true
                
            }
            segue.destination.navigationController?.navigationBar.tintColor = UIColor(hexString: "64C5CF")
        }
        if let destinationVC2 = segue.destination as? InfoVaccinesViewController {

            if #available(iOS 11.0, *) {
                // We choose not to have a large title for the destination view controller.
                destinationVC2.navigationItem.largeTitleDisplayMode = .never
                destinationVC2.navigationController?.navigationBar.prefersLargeTitles = false
                
            }
        
        }
        

        
        
    }
    
    //MARK: Data Manipulation
    
    
    func loadBabiesAndVaccines(){
        
        babyApp = Baby()
        registeredBabies = realm.objects(Baby.self)
        
        if registeredBabies?.count != 0{
            
           
            for baby in registeredBabies!{
                if baby.current == true{
                    babyApp = baby
                }
            }
           
        }
        if !babyApp.name.isEmpty{
            vaccines = babyApp.vaccines.filter(NSPredicate(value: true))
            vaccinesDoses = realm.objects(VaccineDoses.self)
            
            tableView.reloadData()
            
            configureDictionariesOfVaccine()
        }
        
        
    }

    
    func saveDateAdministration(dateString : String, indexPath : IndexPath){
        switch selectedVaccineCategory.selectedSegmentIndex{
            
        case 0:
            
            do{
                try realm.write {
                    
                    let vaccinesApplied = vaccines?.filter("name == %@", dictAgeFunded[sectionAgeFunded[indexPath.section]]![indexPath.row])
                    
                    for vaccine in vaccinesApplied!{
                        var dose = self.vaccinesDoses?.filter("ageOfVaccination == %@", sectionAgeFunded[indexPath.section])
                        dose = dose?.filter(" %@ IN parentVaccine", vaccine)
                        for i in dose!{
                            i.dateOfAdministration = dateString
                        }
                    }
                }
            }
                
            catch{
                print(error)
                
            }
        case 1:
            do{
                try realm.write {
                    
                    let vaccinesApplied = vaccines?.filter("name == %@", dictAgeNonFunded[sectionAgeNonFunded[indexPath.section]]![indexPath.row])
                    
                    for vaccine in vaccinesApplied!{
                        var dose = self.vaccinesDoses?.filter("ageOfVaccination == %@", sectionAgeNonFunded[indexPath.section])
                        dose = dose?.filter(" %@ IN parentVaccine", vaccine)
                        for i in dose!{
                            i.dateOfAdministration = dateString
                        }
                    }
                }
            }
                
            catch{
                print(error)
                
            }
            
        default:
            break
        
        }
        
        
    }
    
    func configureDictionariesOfVaccine(){
        
        var arrayOfDosesFunded = [String]()
        var arrayOfDosesNonFunded = [String]()
        var arrayOfFundedDateAdm = [String]()
        var arrayOfNonFundedDateAdm = [String]()
        
        for string  in sectionAgeFunded{
            
            arrayOfDosesFunded = []
            arrayOfFundedDateAdm = []
            let vaccinesForAgeFunded = vaccines?.filter("ANY doses.ageOfVaccination == %@ AND funded == %@", string, true)
            let vaccinesForDateFunded = vaccinesDoses!.filter("ageOfVaccination == %@", string)
            
            
            
            for vaccineFunded in vaccinesForAgeFunded!{
                arrayOfDosesFunded.append(vaccineFunded.name)
                
                
            }
            for vaccine in vaccinesForAgeFunded!{
                let doses = vaccinesForDateFunded.filter("%@ IN parentVaccine", vaccine)
                
                for dose in doses{
                   arrayOfFundedDateAdm.append(dose.dateOfAdministration)
                    
                }
                
            }
            
            
            for dose in vaccinesForDateFunded{
                
                dictDateFunded[string] = dose.dateOfVaccination
                
                
            }
            
            dictAgeFunded[string] = arrayOfDosesFunded
            dictFundedDateAdm[string] = arrayOfFundedDateAdm
            
            
        }

        for string  in sectionAgeNonFunded{
            
            arrayOfDosesNonFunded = []
            arrayOfNonFundedDateAdm = []
            
            let vaccinesForAgeNonFunded = vaccines?.filter("ANY doses.ageOfVaccination == %@ AND funded == %@", string, false)
            
            let vaccinesForDateNonFunded = vaccinesDoses!.filter("ageOfVaccination == %@", string)
            
            for vaccineNonFunded in vaccinesForAgeNonFunded!{
                arrayOfDosesNonFunded.append(vaccineNonFunded.name)
                
            }
            for vaccine in vaccinesForAgeNonFunded!{
                let doses = vaccinesForDateNonFunded.filter("%@ IN parentVaccine", vaccine)
                
                for dose in doses{
                    arrayOfNonFundedDateAdm.append(dose.dateOfAdministration)
                    
                }
                
            }
            
            for dose in vaccinesForDateNonFunded{
                dictDateNonFunded[string] = dose.dateOfVaccination
            }
            
            dictAgeNonFunded[string] = arrayOfDosesNonFunded
            dictNonFundedDateAdm[string] = arrayOfNonFundedDateAdm
            
        }

        
        
    }

    
    
    var _dateFormatter: DateFormatter?
    var dateFormatter: DateFormatter {
        if (_dateFormatter == nil) {
            _dateFormatter = DateFormatter()
            _dateFormatter!.locale = Locale(identifier: "en_US_POSIX")
            _dateFormatter!.dateFormat = "MM/dd/yyyy"
        }
        return _dateFormatter!
    }
    
    func dateStringFromDate(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
}



//MARK: Table View Data Source and Delegate Methods


extension VaccineViewController : UITableViewDataSource, UITableViewDelegate{
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if registeredBabies?.count == 0 || babyApp.name.isEmpty{
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
        if registeredBabies?.count == 0 || babyApp.name.isEmpty{
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
        
        if registeredBabies?.count == 0 || babyApp.name.isEmpty  {
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
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "vaccineCell") as! CustomCellVaccine
        
        cell.delegate = self
        cell.backgroundColor = UIColor.init(hexString: "F8F9F9")?.withAlphaComponent(CGFloat(0.995))
        tableView.backgroundColor = UIColor.init(hexString: "F8F9F9")?.withAlphaComponent(CGFloat(0.995))
        
        switch selectedVaccineCategory.selectedSegmentIndex{
            
        case 0:
            
            if registeredBabies?.count == 0{
                cell.name.text = "No babys added yet"
                cell.dateAdministration.text = ""
                cell.accessoryType = .none
            }
            else if babyApp.name.isEmpty{
                cell.name.text = "There are no active babys"
                cell.dateAdministration.text = ""
                cell.accessoryType = .none
            }
            else{
                cell.name.text = dictAgeFunded[sectionAgeFunded[indexPath.section]]![indexPath.row]
                cell.dateAdministration.text = dictFundedDateAdm[sectionAgeFunded[indexPath.section]]![indexPath.row]
                let vaccinesApplied = vaccines?.filter("name == %@", dictAgeFunded[sectionAgeFunded[indexPath.section]]![indexPath.row])
                
                for vaccine in vaccinesApplied!{
                    var dose = self.vaccinesDoses?.filter("ageOfVaccination == %@ AND applied == %@", sectionAgeFunded[indexPath.section], true)
                    dose = dose?.filter(" %@ IN parentVaccine", vaccine)
                    if dose?.count != 0{
                        cell.name.textColor = UIColor.init(hexString: "7F8484")
                    }
                    else {
                        cell.name.textColor = UIColor.init(hexString: "CC16CF")
                    }
                    
                }
            }
            
            break
            
        case 1:
            if registeredBabies?.count == 0{
                cell.name.text = "No babys added yet"
                cell.dateAdministration.text = ""
                cell.accessoryType = .none
            }
            else if babyApp.name.isEmpty{
                cell.name.text = "There are no active babys"
                cell.dateAdministration.text = ""
                cell.accessoryType = .none
            }
            else{
                cell.name.text = dictAgeNonFunded[sectionAgeNonFunded[indexPath.section]]![indexPath.row]
                cell.dateAdministration.text = dictNonFundedDateAdm[sectionAgeNonFunded[indexPath.section]]![indexPath.row]
                let vaccinesApplied = vaccines?.filter("name == %@", dictAgeNonFunded[sectionAgeNonFunded[indexPath.section]]![indexPath.row])
                
                for vaccine in vaccinesApplied!{
                    var dose = self.vaccinesDoses?.filter("ageOfVaccination == %@ AND applied == %@", sectionAgeNonFunded[indexPath.section], true)
                    dose = dose?.filter(" %@ IN parentVaccine", vaccine)
                    if dose?.count != 0{
                        cell.name.textColor = grayColor
                    }
                    else {
                        cell.name.textColor = UIColor.init(hexString: "CC16CF")
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
                    
                    for vaccine in self.vaccines!{
                        
                        if vaccine.name == self.dictAgeFunded[self.sectionAgeFunded[indexPath.section]]![indexPath.row]{
                            
                            var dose = self.vaccinesDoses?.filter("ageOfVaccination == %@", self.sectionAgeFunded[indexPath.section])
                            dose = dose?.filter("%@ IN parentVaccine", vaccine)
                            for i in dose!{
                                
                                if !i.applied{
                                    
                                    var dateToday = Date()
                                    
                                    let alert = UIAlertController(style: .alert, title: "Select date of administration")
                                    let maxDate = Date()
                                    let minDate = Calendar.current.date(byAdding: .year, value: -10, to: maxDate)!
                                    
                                    alert.setTitle(font: self.font!, color: UIColor.init(hexString: "CC16CF")!)
                                    alert.addDatePicker(mode: .date, date: maxDate, minimumDate: minDate, maximumDate: maxDate) { date in
                                        dateToday = date
                                    }
                                    let ok_action = UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                                        
                                        let dateString = self.dateStringFromDate(date: dateToday)
                                        
                                        self.saveDateAdministration(dateString: dateString,indexPath: indexPath)
                                        
                                        alert.dismiss(animated: true, completion: nil)
                                        
                                        do {
                                            try self.realm.write {
                                                i.applied = true
                                            }
                                            self.loadBabiesAndVaccines()
                                            tableView.reloadData()
                                        }
                                        catch{
                                            print(error)
                                        }

                                       
                                    })
                                    
                                    alert.addAction(title : "Cancel" , style: .cancel)
                                    alert.addAction(ok_action)
                                    alert.show(animated: true, vibrate: false, style: .prominent, completion: nil)
                                }
                                   
                                else{
                                    let alert = UIAlertController(title: nil, message: "Do you want to mark this vaccine dose as unadministered?", preferredStyle: .alert)
                                    let actionOk = UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                                        
                                        
                                        do {
                                            try self.realm.write {
                                                
                                                i.applied = false
                                                i.dateOfAdministration = ""
                                            }
                                            self.loadBabiesAndVaccines()
                                            tableView.reloadData()
                                        }
                                        catch{
                                            print(error)
                                        }
                                        
                                        
                                        
                                    })
                                    let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) in
                                        alert.dismiss(animated: true, completion: nil)
                                    })
                                    alert.setTitle(font: self.font!, color: self.grayColor!)
                                    alert.setMessage(font: self.fontLight!, color: self.grayLightColor!)
                                    alert.addAction(actionOk)
                                    alert.addAction(actionCancel)
                                    alert.show(animated: true, vibrate: false, style: .light, completion: nil)
                                }
                            
                                
                                
                            }
                        }
                    }
                    
                }
                currentBabySwipeAction.backgroundColor = UIColor.init(hexString: "F78BF9")
                currentBabySwipeAction.hidesWhenSelected = true
                currentBabySwipeAction.image = UIImage(named: "checkmark2")!

                return [currentBabySwipeAction]
                
                
                
            case 1 :
                let currentBabySwipeAction = SwipeAction(style: .default, title: nil) { action, indexPath in
                    
                    for vaccine in self.vaccines!{
                        
                        if vaccine.name == self.dictAgeNonFunded[self.sectionAgeNonFunded[indexPath.section]]![indexPath.row]{
                            
                            var dose = self.vaccinesDoses?.filter("ageOfVaccination == %@", self.sectionAgeNonFunded[indexPath.section])
                            dose = dose?.filter("%@ IN parentVaccine", vaccine)
                            for i in dose!{
                                
                                if !i.applied{
                                    
                                    var dateToday = Date()
                                    
                                    let alert = UIAlertController(style: .alert, title: "Select date of administration")
                                    let maxDate = Date()
                                    let minDate = Calendar.current.date(byAdding: .year, value: -10, to: maxDate)!
                                    
                                    alert.setTitle(font: self.font!, color: UIColor.init(hexString: "CC16CF")!)
                                    alert.addDatePicker(mode: .date, date: maxDate, minimumDate: minDate, maximumDate: maxDate) { date in
                                        dateToday = date
                                    }
                                    let ok_action = UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                                        
                                        let dateString = self.dateStringFromDate(date: dateToday)
                                        
                                        self.saveDateAdministration(dateString: dateString,indexPath: indexPath)
                                        
                                        alert.dismiss(animated: true, completion: nil)
                                        
                                        do {
                                            try self.realm.write {
                                                i.applied = true
                                            }
                                            
                                            self.loadBabiesAndVaccines()
                                            tableView.reloadData()
                                        }
                                        catch{
                                            print(error)
                                        }
                                        
                                        
                                    })
                                    
                                    alert.addAction(title : "Cancel" , style: .cancel)
                                    alert.addAction(ok_action)
                                    alert.show(animated: true, vibrate: false, style: .prominent, completion: nil)
                                }
                                    
                                else{
                                    let alert = UIAlertController(title: nil, message: "Do you want to mark this vaccine dose as unadministered?", preferredStyle: .alert)
                                    let actionOk = UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
                                        
                                        
                                        do {
                                            try self.realm.write {
                                                
                                                i.applied = false
                                                i.dateOfAdministration = ""
                                            }
                                            self.loadBabiesAndVaccines()
                                            tableView.reloadData()
                                        }
                                        catch{
                                            print(error)
                                        }
                                        
                                        
                                    })
                                    let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) in
                                        alert.dismiss(animated: true, completion: nil)
                                    })
                                    alert.setTitle(font: self.font!, color: self.grayColor!)
                                    alert.setMessage(font: self.fontLight!, color: self.grayLightColor!)
                                    alert.addAction(actionOk)
                                    alert.addAction(actionCancel)
                                    alert.show(animated: true, vibrate: false, style: .light, completion: nil)
                                }

                                
                                
                            }
                        }
                    }
                    
                }
                currentBabySwipeAction.backgroundColor = UIColor.init(hexString: "F78BF9")
                currentBabySwipeAction.hidesWhenSelected = true
                currentBabySwipeAction.image = UIImage(named: "checkmark2")!

              
                
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

