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
import RLBAlertsPickers
import APESuperHUD


class BabiesViewController : UITableViewController, NotifyChangeInNameDelegate, CurrentBabyOftheAppDelegate{
   
    func getCurrentBaby() -> Baby {
        let baby = getCurrentBabyApp()
        return baby
    }
    
    
    
    func loadNewName() {
        loadBabies()
    }
    
    let realm = try! Realm()
    var registeredBabies : Results<Baby>?
    var vaccines : Results<Vaccine>?
    var babyApp = Baby()

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
        
        loadBabies()
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .always
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        tableView.reloadData()

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        
    }
    
    
    @IBAction func addBabyPressed(_ sender: UIBarButtonItem) {
        
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
            textField.placeholder = "new baby name..."
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
                alert.show(animated: true, vibrate: true, style: .extraLight, completion: nil)
            }
            
            let newBaby = Baby()
            newBaby.name = textFieldStore.text!
            self.save(baby : newBaby)
        })
        
        alert.addAction(title: "Cancel" , style : .cancel)
        alert.addAction(okAction)
        alert.show()
        
        
    }
    
    
    //MARK: - Table View Data Source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //this is called nil coalescing operator
        return registeredBabies?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let baby = getCurrentBabyApp()
        let cell = tableView.dequeueReusableCell(withIdentifier: "babiesCell", for: indexPath) as! SwipeTableViewCell
        
        cell.textLabel?.text = registeredBabies?[indexPath.row].name
        
        if cell.textLabel?.text != baby.name{
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
       performSegue(withIdentifier: "goToBabyInfo", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let destinationVC = segue.destination as! BabyInfoViewController
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationVC.selectedBaby  = registeredBabies?[indexpath.row]
            destinationVC.delegate = self
            destinationVC.delegateCurrentBaby = self
            destinationVC.navigationItem.title = destinationVC.selectedBaby?.name
            if #available(iOS 11.0, *) {
                // We choose not to have a large title for the destination view controller.
                segue.destination.navigationItem.largeTitleDisplayMode = .automatic
            }
        }
    
    }
    
    //MARK: Data Manipulation
    func save(baby : Baby){
        
        
        do{
            
             vaccines = realm.objects(Vaccine.self)
            
            try realm.write {
                
                if realm.objects(Baby.self).count == 0{
                    baby.current = true
                }
                realm.add(baby)

                
            }
            addVaccinesDatabaseToNewBaby(babytoAdd : baby)
        }
        catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadBabies(){
        
        registeredBabies = realm.objects(Baby.self)
        
        tableView.reloadData()
        
    }

    

    func deleteBaby(baby : Baby){
        
        do{
            try realm.write {
               
                realm.delete(baby)
            }
        }
        catch{
            print(error)
        }
        loadBabies()
    }
    func getCurrentBabyApp() -> Baby{
        
        
        for baby in registeredBabies!{
            if baby.current == true{
                babyApp = baby
            }
        }
        return babyApp
    }
    
    func addVaccinesDatabaseToNewBaby(babytoAdd : Baby){
        
        
        do{
                let vaccine1 = Vaccine()
                vaccine1.name = "HB (Hepatitis B)"
                let vaccine2 = Vaccine()
                vaccine2.name = "DTaP (Diphtheria, Tetanus, Pertussis)"
                let vaccine3 = Vaccine()
                vaccine3.name = "DTaP/Tdap (Diphtheria, Tetanus, Pertussis)"
                let vaccine4 = Vaccine()
                vaccine4.name = "Tdap (Diphtheria, Tetanus, Pertussis)"
                let vaccine5 = Vaccine()
                vaccine5.name = "IPV (Polio)"
                let vaccine6 = Vaccine()
                vaccine6.name = "MenB (Meningitis B) "
                vaccine6.funded = false
                let vaccine7 = Vaccine()
                vaccine7.name = "RV (Rotavirus) Rotarix/RotaTeq "
                vaccine7.funded = false
                let vaccine8 = Vaccine()
                vaccine8.name = "RV (Rotavirus) RotaTeq "
                vaccine8.funded = false
            
            
                
                //Doses
                let dose1 = VaccineDoses()
                dose1.ageOfVaccination = "2 months"
                let dose2 = VaccineDoses()
                dose2.ageOfVaccination = "4 months"
                let dose3 = VaccineDoses()
                dose3.ageOfVaccination = "11 months"
                
                let dose4 = VaccineDoses()
                dose4.ageOfVaccination = "2 months"
                let dose5 = VaccineDoses()
                dose5.ageOfVaccination = "4 months"
                let dose6 = VaccineDoses()
                dose6.ageOfVaccination = "11 months"
                let dose7 = VaccineDoses()
                dose7.ageOfVaccination = "6 years"
                let dose8 = VaccineDoses()
                dose8.ageOfVaccination = "12-14 years"
            
                let dose9 = VaccineDoses()
                dose9.ageOfVaccination = "2 months"
                let dose10 = VaccineDoses()
                dose10.ageOfVaccination = "4 months"
                let dose11 = VaccineDoses()
                dose11.ageOfVaccination = "11 months"
                let dose12 = VaccineDoses()
                dose12.ageOfVaccination = "6 years"
            
                let dose13 = VaccineDoses()
                dose13.ageOfVaccination = "3 months"
                let dose14 = VaccineDoses()
                dose14.ageOfVaccination = "5 months"
                let dose15 = VaccineDoses()
                dose15.ageOfVaccination = "12 months"
            
                let dose16 = VaccineDoses()
                dose16.ageOfVaccination = "2 months"
                let dose17 = VaccineDoses()
                dose17.ageOfVaccination = "3 months"

            
                let dose18 = VaccineDoses()
                dose18.ageOfVaccination = "4 months"
            
            
            
            
            
                
            
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
                    
                    
                    babytoAdd.vaccines.append(vaccine1)
                    babytoAdd.vaccines.append(vaccine2)
                    babytoAdd.vaccines.append(vaccine3)
                    babytoAdd.vaccines.append(vaccine4)
                    babytoAdd.vaccines.append(vaccine5)
                    babytoAdd.vaccines.append(vaccine6)
                    babytoAdd.vaccines.append(vaccine7)
                    babytoAdd.vaccines.append(vaccine8)
                    
                }
            
            
        }
        catch{
            
            print(error)
        }
        
        
        
        
 
    }
    
}
extension BabiesViewController : SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
         defaultOptions.transitionStyle = .drag
        
        if orientation == .right{
            
            let removeSwipe = SwipeAction(style: .default, title: nil){ action , indexPath in
                
                let alert = UIAlertController(title: "Remove Child", message: "Are you sure you want to remove child \(self.registeredBabies![indexPath.row].name) permanently?", preferredStyle: .alert)
                
                let removeAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (alertAction) in
                    
                    self.deleteBaby(baby: self.registeredBabies![indexPath.row])
                    
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) in
                
                })
                
                alert.setTitle(font: self.font!, color: self.grayColor!)
                alert.setMessage(font: self.fontLight!, color: self.grayLightColor!)
                alert.addAction(removeAction)
                alert.addAction(cancelAction)
                alert.show(animated: true, vibrate: true, style: .prominent, completion: nil)
                
             }
            removeSwipe.backgroundColor = .red
            removeSwipe.hidesWhenSelected = true
            if let delegate = self.delegate {
                removeSwipe.image = delegate.resizeImageIsCalled(image: UIImage(named: "delete-icon")!, size: CGSize(width: 30, height: 30))
            }
            
            return [removeSwipe]
            
            
        }
        else{
            
            let currentBabySwipeAction = SwipeAction(style: .default, title: nil) { action, indexPath in
                
                
                do{
                    
                    try self.realm.write {
                        for baby in self.registeredBabies!{
                            baby.current = false
                        }
                        self.registeredBabies![indexPath.row].current = true

                    }

                    let image = UIImage(named: "doubletick")!
                    let hudViewController = APESuperHUD(style: .icon(image: image, duration: 2), title: nil, message: "\(self.registeredBabies![indexPath.row].name) has been established as the current baby of the app")
                    HUDAppearance.cancelableOnTouch = true
                    HUDAppearance.messageFont = self.fontLight!
                    HUDAppearance.messageTextColor = self.grayColor!
                    
                    self.present(hudViewController, animated: true)
                  
                    tableView.reloadData()
                    if let delegate = self.delegateNameBarHome{
                       delegate.changeName(name: self.registeredBabies![indexPath.row].name)
                     
                    }
                   

                }
                catch{
                    print("Unable to set the current baby \(error)")
                }
            }
            
            currentBabySwipeAction.backgroundColor = UIColor.flatMint
            currentBabySwipeAction.hidesWhenSelected = true
            if let delegate = self.delegate {
                currentBabySwipeAction.image = delegate.resizeImageIsCalled(image: UIImage(named: "doubletick")!, size: CGSize(width: 30, height: 30))
            }
           return [currentBabySwipeAction]
            
        }
        
    }
    


}

protocol resizeImageDelegate : class {
    func resizeImageIsCalled(image : UIImage , size : CGSize)->UIImage
}

protocol changeNameBarHome : class {
    func changeName(name : String)
}
