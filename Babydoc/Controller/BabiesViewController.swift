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


class BabiesViewController : UITableViewController, notifyChangeInNameDelegate{
    
    func loadNewName() {
        loadBabies()
    }
    
    let realm = try! Realm()
    var registeredBabies : Results<Baby>?
    let font = UIFont(name: "Avenir-Heavy", size: 17)
    let fontLight = UIFont(name: "Avenir-Medium", size: 17)
    let greenColor = UIColor.init(hexString: "32828A")
    let grayColor = UIColor.init(hexString: "555555")
    let grayLightColor = UIColor.init(hexString: "7F8484")
    var defaultOptions = SwipeOptions()
    weak var delegate : resizeImageDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadBabies()
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .always
            navigationController?.navigationBar.prefersLargeTitles = true
        }
//        let babyface = UIImage(named: "baby-face")
//        let imageView = UIImageView(image:babyface)
//        imageView.contentMode = .scaleAspectFit
//        self.navigationItem.titleView = imageView
        
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "babiesCell", for: indexPath) as! SwipeTableViewCell
        
        cell.textLabel?.text = registeredBabies?[indexPath.row].name
        cell.textLabel?.textColor = UIColor.init(hexString: "7F8484")
        cell.textLabel?.font = fontLight
        
        cell.delegate = self
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
            destinationVC.delegate = self
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
    
    func loadBabies(){
        
        registeredBabies = realm.objects(Baby.self)
        
        tableView.reloadData()
        
    }
    func deleteBaby(baby : Baby){
        
        do{
            try realm.write {
                //categories.append cannot be done because is of type Results and does not have a list
                realm.delete(baby) //PERSIST DATA
            }
        }
        catch{
            print(error)
        }
        loadBabies()
    }
    
}
extension BabiesViewController : SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
         defaultOptions.transitionStyle = .drag
        
        //_ = tableView.dequeueReusableCell(withIdentifier: "babiesCell", for: indexPath) as! SwipeTableViewCell
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
            return nil
        }
        
    }


}

protocol resizeImageDelegate : class {
    func resizeImageIsCalled(image : UIImage , size : CGSize)->UIImage
}
