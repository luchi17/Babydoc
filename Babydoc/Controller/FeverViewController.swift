//
//  FeverViewController.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 21/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import UIKit
import RealmSwift
import RLBAlertsPickers


class FeverViewController : UIViewController{
    

    
    var realm = try! Realm()
    var listOfFever : Results<Fever>?
    var registeredBabies : Results<Baby>?
    var babyApp = Baby()
    let greenDarkColor = UIColor.init(hexString: "33BE8F")
    let greenLightColor = UIColor.init(hexString: "14E19C")
    let font = UIFont(name: "Avenir-Heavy", size: 17)
    let fontLight = UIFont(name: "Avenir-Medium", size: 17)
    let fontLittle = UIFont(name: "Avenir-Heavy", size: 16)
    let grayColor = UIColor.init(hexString: "555555")
    let grayLightColor = UIColor.init(hexString: "7F8484")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func willMove(toParent parent: UIViewController?) {
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "64C5CF")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {

        self.navigationController?.navigationBar.barTintColor = greenLightColor
        self.navigationController?.navigationBar.backgroundColor = greenLightColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        loadBabiesAndFever()
        
        
    }

     func loadBabiesAndFever(){
        
      registeredBabies = realm.objects(Baby.self)
        
        if registeredBabies?.count != 0 {
            for baby in registeredBabies!{
                if baby.current{
                    babyApp = baby
                }
            }
            //listOfFever = babyApp.fever.filter(NSPredicate(value: true))
            
        }

    }
 
}
