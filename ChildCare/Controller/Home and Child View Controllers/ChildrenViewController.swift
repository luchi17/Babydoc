//
//  ChildrenViewController.swift
//  ChilCare
//
//  Created by Luchi Parejo alcazar on 29/04/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import UIKit
import RealmSwift
import PMAlertController
import SwipeCellKit
import APESuperHUD
import RLBAlertsPickers


class ChildrenViewController : UITableViewController, NotifyChangeInNameDelegate, CurrentChildOftheAppDelegate{
   
    func getCurrentChild() -> Child {
        let child = getCurrentChildApp()
        return child
    }
    
    
    
    func loadNewName() {
        loadChildren()
    }
    
    let realm = try! Realm()
    var registeredChildren : Results<Child>?
    var vaccines : Results<Vaccine>?
    var childApp = Child()

    let font = UIFont(name: "Avenir-Heavy", size: 17)
    let fontLight = UIFont(name: "Avenir-Medium", size: 17)
    let greenColor = UIColor.init(hexString: "32828A")
    let grayColor = UIColor.init(hexString: "555555")
    let grayLightColor = UIColor.init(hexString: "7F8484")
    var defaultOptions = SwipeOptions()
    weak var delegate : resizeImageDelegate?
    weak var delegateNameBarHome : changeNameBarHome?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadChildren()
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .always
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        
    }
    
    @IBAction func addChildPressed(_ sender: UIBarButtonItem) {
        var textFieldStore = UITextField()
        let alert = UIAlertController(style: .alert, title: "Add New Child" )
        
        let config: TextField.Config = { textField in
            
            
            textField.becomeFirstResponder()
            textField.textColor = self.grayLightColor
            textField.font = self.fontLight
            textField.leftViewPadding = 6
            textField.borderStyle = .roundedRect
            textField.backgroundColor = nil
            textField.keyboardAppearance = .default
            textField.keyboardType = .default
            textField.returnKeyType = .done
            textField.placeholder = "new child name..."
            textFieldStore = textField
        }
        
        alert.setTitle(font: font!, color: self.grayColor!)
        alert.addOneTextField(configuration: config)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
            
            if textFieldStore.text!.isEmpty{
                let alert = UIAlertController(title: "Error", message: "The name field cannot be empty, please add the child again and enter a valid name", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: { (alertaction) in
                    alert.dismiss(animated: true, completion: nil)
                })
                alert.addAction(action)
                alert.show(animated: true, vibrate: false, style: .extraLight, completion: nil)
            }
            
            let newChild = Child()
            newChild.name = textFieldStore.text!
            self.save(child : newChild)
        })
        
        alert.addAction(title: "Cancel" , style : .cancel)
        alert.addAction(okAction)
        alert.show()
        
        
    }
    
    //MARK: - Table View Data Source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //this is called nil coalescing operator
        return registeredChildren?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "babiesCell", for: indexPath) as! SwipeTableViewCell
        
        cell.textLabel?.text = registeredChildren?[indexPath.row].name
        tableView.backgroundColor = UIColor.init(hexString: "F8F9F9")?.withAlphaComponent(CGFloat(0.995))
        cell.backgroundColor = UIColor.init(hexString: "F8F9F9")?.withAlphaComponent(CGFloat(0.995))
        
        if !(registeredChildren?[indexPath.row].current)!{
            cell.accessoryType = .none
        }
        else{
            cell.accessoryType = .checkmark
        }
        
        cell.delegate = self
        
        return cell
    }
    
    
    
    
    
    //MARK: - Table View Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       performSegue(withIdentifier: "goToChildInfo", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let destinationVC = segue.destination as! ChildInfoViewController
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationVC.selectedChild  = registeredChildren?[indexpath.row]
            destinationVC.delegate = self
            destinationVC.delegateCurrentChild = self
            destinationVC.navigationItem.title = destinationVC.selectedChild?.name
            if #available(iOS 11.0, *) {
               
                segue.destination.navigationItem.largeTitleDisplayMode = .automatic
            }
        }
    
    }
    
    //MARK: Data Manipulation
    func save(child : Child){
        
        let medicines = realm.objects(Medication.self)
        
        do{
            var checker = false
            vaccines = realm.objects(Vaccine.self)
            for childStored in realm.objects(Child.self){
             
                if childStored.name == child.name{
                    let controller = UIAlertController(title: "Error", message: "There is already a child registered as \(child.name).", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    controller.setTitle(font: self.font!, color: self.grayColor!)
                    controller.setMessage(font: self.fontLight!, color: self.grayLightColor!)
                    controller.addAction(action)
                    controller.show(animated: true, vibrate: false, style: .light, completion: nil)
                    checker = true
                    break
                }
                    
                
            }
            if checker == false{
                try realm.write {
                    
                    if realm.objects(Child.self).count == 0{
                        child.current = true
                    }
                    realm.add(child)

                }
                addVaccinesDatabaseToNewChild(childtoAdd : child)
            }

        }
        catch{
            print(error)
        }
        tableView.reloadData()
       
        
    }
    
    func loadChildren(){
        
        registeredChildren = realm.objects(Child.self)

        tableView.reloadData()
        
        
        
    }

    

    func deleteChild(child : Child){
        
        do{
            
            try realm.write {
               for vaccine in child.vaccines{
                    let dose = realm.objects(VaccineDose.self).filter("%@ IN parentVaccine", vaccine)
                
                    realm.delete(dose)

                }
                for drug in child.medicationDoses{
                    
                    realm.delete(drug.date!)
                    
                    
                }

                
                for sleep in child.sleeps{
                    realm.delete(sleep.dateBegin!)
                    realm.delete(sleep.dateEnd!)
                }
                for fever in child.fever{
                    realm.delete(fever.date!)
                }
               
                
              
                realm.delete(child.sleeps)
                realm.delete(child.medicationDoses)
                realm.delete(child.fever)
                realm.delete(child.vaccines)
                realm.delete(child)
                
            }
            loadChildren()
        }
        catch{
            print(error)
        }
        
    }
    func getCurrentChildApp() -> Child{
        
        if registeredChildren?.count != 0{
            for child in registeredChildren!{
                if child.current == true{
                    childApp = child
                }
            }
        }
        
        return childApp
    }
    
    func addVaccinesDatabaseToNewChild(childtoAdd : Child){
        
        
        do{
                let vaccine1 = Vaccine()
                vaccine1.name = "HB (Hepatitis B Vaccine)"
                let vaccine2 = Vaccine()
                vaccine2.name = "DTaP (Diphtheria, Tetanus, Pertussis Vaccine)"
                let vaccine3 = Vaccine()
                vaccine3.name = "DTaP/Tdap (Diphtheria, Tetanus, Pertussis Vaccine)"
                let vaccine4 = Vaccine()
                vaccine4.name = "Tdap (Diphtheria, Tetanus, Pertussis Vaccine)"
                let vaccine5 = Vaccine()
                vaccine5.name = "IPV (Inactivated Polio Vaccine)"
                let vaccine6 = Vaccine()
                vaccine6.name = "Men B (Meningitis B Vaccine)"
                vaccine6.funded = false
                let vaccine7 = Vaccine()
                vaccine7.name = "RV (Rotavirus-Rotarix/RotaTeq Vaccine)"
                vaccine7.funded = false
                let vaccine8 = Vaccine()
                vaccine8.name = "RV (Rotavirus-RotaTeq Vaccine)"
                vaccine8.funded = false
                let vaccine9  = Vaccine()
                vaccine9.name = "Hib (Haemophilus Influenzae Type B Vaccine)"
                let vaccine10  = Vaccine()
                vaccine10.name = "PCV (Pneumococcal Conjugate Vaccine)"
                let vaccine11  = Vaccine()
                vaccine11.name = "Men C (Meningococcal C Vaccine)"
                let vaccine12  = Vaccine()
                vaccine12.name = "Men ACWY/Men C (Meningococcal ACWY Vaccine)"
                let vaccine13  = Vaccine()
                vaccine13.name = "MMR (Measles, Mumps, and Rubella Vaccine)"
                let vaccine14  = Vaccine()
                vaccine14.name = "VAR (Varicella Vaccine)"
                let vaccine15  = Vaccine()
                vaccine15.name = "MMR-VAR/MMRV (Measles, Mumps, Rubella and Varicella Vaccine)"
                let vaccine16  = Vaccine()
                vaccine16.name = "HPV (Human Papillomavirus Vaccine)"
            
            
                
                //Doses
                let dose1 = VaccineDose()
                dose1.ageOfVaccination = "2 months"
                let dose2 = VaccineDose()
                dose2.ageOfVaccination = "4 months"
                let dose3 = VaccineDose()
                dose3.ageOfVaccination = "11 months"
                
                let dose4 = VaccineDose()
                dose4.ageOfVaccination = "2 months"
                let dose5 = VaccineDose()
                dose5.ageOfVaccination = "4 months"
                let dose6 = VaccineDose()
                dose6.ageOfVaccination = "11 months"
                let dose7 = VaccineDose()
                dose7.ageOfVaccination = "6 years"
                let dose8 = VaccineDose()
                dose8.ageOfVaccination = "12-14 years"
            
                let dose9 = VaccineDose()
                dose9.ageOfVaccination = "2 months"
                let dose10 = VaccineDose()
                dose10.ageOfVaccination = "4 months"
                let dose11 = VaccineDose()
                dose11.ageOfVaccination = "11 months"
                let dose12 = VaccineDose()
                dose12.ageOfVaccination = "6 years"
            
                let dose13 = VaccineDose()
                dose13.ageOfVaccination = "3 months"
                let dose14 = VaccineDose()
                dose14.ageOfVaccination = "5 months"
                let dose15 = VaccineDose()
                dose15.ageOfVaccination = "12 months"
            
                let dose16 = VaccineDose()
                dose16.ageOfVaccination = "2 months"
                let dose17 = VaccineDose()
                dose17.ageOfVaccination = "3 months"

            
                let dose18 = VaccineDose()
                dose18.ageOfVaccination = "4 months"
            
                let dose19 = VaccineDose()
                dose19.ageOfVaccination = "2 months"
                let dose20 = VaccineDose()
                dose20.ageOfVaccination = "4 months"
                let dose21 = VaccineDose()
                dose21.ageOfVaccination = "11 months"
            
                let dose22 = VaccineDose()
                dose22.ageOfVaccination = "2 months"
                let dose23 = VaccineDose()
                dose23.ageOfVaccination = "4 months"
                let dose24 = VaccineDose()
                dose24.ageOfVaccination = "11 months"
            
                let dose25 = VaccineDose()
                dose25.ageOfVaccination = "4 months"
            
                let dose26 = VaccineDose()
                dose26.ageOfVaccination = "12 months"
                let dose27 = VaccineDose()
                dose27.ageOfVaccination = "12-14 years"
                let dose28 = VaccineDose()
                dose28.ageOfVaccination = "Up to 19 years"
            
                let dose29 = VaccineDose()
                dose29.ageOfVaccination = "12 months"
            
                let dose30 = VaccineDose()
                dose30.ageOfVaccination = "12 months"
            
                let dose31 = VaccineDose()
                dose31.ageOfVaccination = "3-4 years"
                let dose32 = VaccineDose()
                dose32.ageOfVaccination = "11-12 years"
            
            
                try realm.write {
                    vaccine1.doses.append(dose1)
                    vaccine1.doses.append(dose2)
                    vaccine1.doses.append(dose3)
                    realm.add(vaccine1)
                    vaccine2.doses.append(dose4)
                    vaccine2.doses.append(dose5)
                    vaccine2.doses.append(dose6)
                    realm.add(vaccine2)
                    vaccine3.doses.append(dose7)
                    realm.add(vaccine3)
                    vaccine4.doses.append(dose8)
                    realm.add(vaccine4)
                    vaccine5.doses.append(dose9)
                    vaccine5.doses.append(dose10)
                    vaccine5.doses.append(dose11)
                    vaccine5.doses.append(dose12)
                    realm.add(vaccine5)
                    vaccine6.doses.append(dose13)
                    vaccine6.doses.append(dose14)
                    vaccine6.doses.append(dose15)
                    realm.add(vaccine6)
                    vaccine7.doses.append(dose16)
                    vaccine7.doses.append(dose17)
                    realm.add(vaccine7)
                    vaccine8.doses.append(dose18)
                    realm.add(vaccine8)
                    vaccine9.doses.append(dose19)
                    vaccine9.doses.append(dose20)
                    vaccine9.doses.append(dose21)
                    realm.add(vaccine9)
                    vaccine10.doses.append(dose22)
                    vaccine10.doses.append(dose23)
                    vaccine10.doses.append(dose24)
                    realm.add(vaccine10)
                    vaccine11.doses.append(dose25)
                    realm.add(vaccine11)
                    vaccine12.doses.append(dose26)
                    vaccine12.doses.append(dose27)
                    vaccine12.doses.append(dose28)
                    realm.add(vaccine12)
                    vaccine13.doses.append(dose29)
                    realm.add(vaccine13)
                    vaccine14.doses.append(dose30)
                    realm.add(vaccine14)
                    vaccine15.doses.append(dose31)
                    realm.add(vaccine15)
                    vaccine16.doses.append(dose32)
                    realm.add(vaccine16)

                    
                    
                    childtoAdd.vaccines.append(vaccine1)
                    childtoAdd.vaccines.append(vaccine2)
                    childtoAdd.vaccines.append(vaccine3)
                    childtoAdd.vaccines.append(vaccine4)
                    childtoAdd.vaccines.append(vaccine5)
                    childtoAdd.vaccines.append(vaccine6)
                    childtoAdd.vaccines.append(vaccine7)
                    childtoAdd.vaccines.append(vaccine8)
                    childtoAdd.vaccines.append(vaccine9)
                    childtoAdd.vaccines.append(vaccine10)
                    childtoAdd.vaccines.append(vaccine11)
                    childtoAdd.vaccines.append(vaccine12)
                    childtoAdd.vaccines.append(vaccine13)
                    childtoAdd.vaccines.append(vaccine14)
                    childtoAdd.vaccines.append(vaccine15)
                    childtoAdd.vaccines.append(vaccine16)
                    

                    
                }
            
            
        }
        catch{
            
            print(error)
        }
        
        
 
    }
 
    
}
extension ChildrenViewController : SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
         defaultOptions.transitionStyle = .drag
        
        if orientation == .right{
            
            let removeSwipe = SwipeAction(style: .default, title: nil){ action , indexPath in
                
                let alert = UIAlertController(title: "Remove Child", message: "Are you sure you want to remove child \(self.registeredChildren![indexPath.row].name) permanently?", preferredStyle: .alert)
                
                let removeAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (alertAction) in
                    
                    self.deleteChild(child: self.registeredChildren![indexPath.row])
                    
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) in
                
                })
                
                alert.setTitle(font: self.font!, color: self.grayColor!)
                alert.setMessage(font: self.fontLight!, color: self.grayLightColor!)
                alert.addAction(removeAction)
                alert.addAction(cancelAction)
                alert.show(animated: true, vibrate: false, style: .prominent, completion: nil)
                
             }
            removeSwipe.backgroundColor = .red
            removeSwipe.hidesWhenSelected = true
            if let delegate = self.delegate {
                removeSwipe.image = delegate.resizeImageIsCalled(image: UIImage(named: "delete-icon")!, size: CGSize(width: 30, height: 30))
            }
            
            return [removeSwipe]
            
            
        }
        else{
            
            let currentChildSwipeAction = SwipeAction(style: .default, title: nil) { action, indexPath in
                
                
                do{
                    
                    try self.realm.write {
                        for child in self.registeredChildren!{
                            child.current = false
                        }
                        self.registeredChildren![indexPath.row].current = true

                    }

                    let image = UIImage(named: "doubletick")!
                    let hudViewController = APESuperHUD(style: .icon(image: image, duration: 1), title: nil, message: "\(self.registeredChildren![indexPath.row].name) is now the current child of the app")
                    HUDAppearance.cancelableOnTouch = true
                    HUDAppearance.messageFont = self.fontLight!
                    HUDAppearance.messageTextColor = self.grayColor!
                    
                    self.present(hudViewController, animated: true)
                  
                    tableView.reloadData()
                    if let delegate = self.delegateNameBarHome{
                       delegate.changeName(name: self.registeredChildren![indexPath.row].name)
                     
                    }
                   

                }
                catch{
                    print("Unable to set the current child \(error)")
                }
            }
            
            currentChildSwipeAction.backgroundColor = UIColor.init(hexString: "78D7E1")
            currentChildSwipeAction.hidesWhenSelected = true
            if let delegate = self.delegate {
                currentChildSwipeAction.image = delegate.resizeImageIsCalled(image: UIImage(named: "checkmark")!, size: CGSize(width: 30, height: 30))
            }
           return [currentChildSwipeAction]
            
        }
        
    }
    


}

protocol resizeImageDelegate : class {
    func resizeImageIsCalled(image : UIImage , size : CGSize)->UIImage
}

protocol changeNameBarHome : class {
    func changeName(name : String)
}
