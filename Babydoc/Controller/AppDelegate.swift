//
//  AppDelegate.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 05/04/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print(Realm.Configuration.defaultConfiguration.fileURL as Any)
        
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.barTintColor = UIColor.init(hexString: "64C5CF")
        //navigationBarAppearace.tintColor = UIColor.init(hexString: "FFFFFF")  //backgroundcolor
        // change navigation item title color
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBarAppearance.backgroundColor = UIColor.init(hexString: "64C5CF")
        
        do {
            let realm = try Realm()
            var registeredDrugs : Results<Medication>?
            registeredDrugs = realm.objects(Medication.self)
            
            if registeredDrugs?.count == 0{
                addDrugsToDatabase(realm: realm)
            }
            
            
            
        }
        catch {
            print("Error initialising new realm, \(error)")
        }
        
        return true
    }
    
    
    
    
    func addDrugsToDatabase(realm : Realm){
        
        let paracetamol = Medication()
        paracetamol.name = "Paracetamol"
        paracetamol.dosagePerDay = "40-60 mg/kg/day"
        paracetamol.dosagePerDose = "10-15 mg/kg/dose"
        paracetamol.timeForDose = "every 4-6 hours"
        paracetamol.maxDose = "60 mg/kg/day"
        let typeDrops = MedicationType()
        typeDrops.parentMedicationName = "Paracetamol"
        typeDrops.name = "Drops"
        typeDrops.concentration = 100
        typeDrops.maxWeight = 32
        typeDrops.concentrationUnit = "mg/ml"
        typeDrops.routeOfAdministration = "Oral route"
        typeDrops.hyperlink = "https://cima.aemps.es/cima/dochtml/p/49302/Prospecto_49302.html"
        typeDrops.suggestion = "It is advisable to consult a doctor before administering it to children under 3 years of age.\nTrick for quick use: 0.15*weight(kg)*25 = drops per dose every 6 hours."
        
        let typeSyrup = MedicationType()
        typeSyrup.parentMedicationName = "Paracetamol"
        typeSyrup.name = "Syrup"
        typeSyrup.concentration = 30
        typeSyrup.concentrationUnit = "mg/ml"
        typeSyrup.minWeight = 4
        typeSyrup.maxWeight = 32
        typeSyrup.routeOfAdministration = "Oral route"
        typeSyrup.suggestion = "Children younger than 2 years old can only take this medicine if their doctor has prescribed it for them."
        typeSyrup.hyperlink = "https://www.vademecum.es/medicamento-efferalgan+pediatrico_prospecto_58157"
        
        let typeSyrup1 = MedicationType()
        typeSyrup1.parentMedicationName = "Paracetamol"
        typeSyrup1.name = "Syrup"
        typeSyrup1.concentration = 100
        typeSyrup1.concentrationUnit = "mg/ml"
        typeSyrup1.routeOfAdministration = "Oral route"
        typeSyrup1.maxWeight = 32
        typeSyrup1.suggestion = "It is advisable to consult a doctor before administering it to children under 3 years of age.\nTrick for quick use: 0.15*weight(kg) = ml per dose every 6 hours."
        typeSyrup1.hyperlink = "https://cima.aemps.es/cima/dochtml/p/49302/Prospecto_49302.html"
        
        let typeSup = MedicationType()
        typeSup.parentMedicationName = "Paracetamol"
        typeSup.name = "Suppository"
        typeSup.concentration = 150
        typeSup.concentrationUnit = "mg"
        typeSup.minWeight = 10
        typeSup.maxWeight = 20
        typeSup.routeOfAdministration = "Rectal route"
        typeSup.hyperlink = "https://www.vademecum.es/medicamento-febrectal_prospecto_45930"
        typeSup.suggestion = "For children under two years the dose should be established individually by the doctor, according to age and weight.\nDue to the dosage this medicine is not suitable for infants and children weighing less than 10 kg."
        
        let typeSup1 = MedicationType()
        typeSup1.parentMedicationName = "Paracetamol"
        typeSup1.name = "Suppository"
        typeSup1.concentration = 250
        typeSup1.concentrationUnit = "mg"
        typeSup1.minWeight = 17
        typeSup1.maxWeight = 33
        typeSup1.routeOfAdministration = "Rectal route"
        typeSup1.hyperlink = "https://www.vademecum.es/medicamento-apiretal_prospecto_56301"
        typeSup1.suggestion = "It is not recommended for use in children weighing less than 17 kg (under 4 years approximately)."
        
        let typeSup2 = MedicationType()
        typeSup2.parentMedicationName = "Paracetamol"
        typeSup2.name = "Suppository"
        typeSup2.concentration = 300
        typeSup2.concentrationUnit = "mg"
        typeSup2.minWeight = 20
        typeSup2.routeOfAdministration = "Rectal route"
        typeSup2.hyperlink = "https://www.vademecum.es/medicamento-febrectal+sup.+inf.+300+mg_prospecto_45929"
        typeSup2.suggestion = "It is recommended not to administer more than 5 doses every 24 hours to children under the age of 12, unless indicated by your doctor."
        
        let typeChewTablet = MedicationType()
        typeChewTablet.parentMedicationName = "Paracetamol"
        typeChewTablet.name = "Orodispersible tablet"
        typeChewTablet.concentration = 250
        typeChewTablet.concentrationUnit = "mg"
        typeChewTablet.minWeight = 14
        typeChewTablet.routeOfAdministration = "Oral route"
        typeChewTablet.hyperlink = "https://www.vademecum.es/medicamento-apiretal_prospecto_70569"
        typeChewTablet.suggestion = "It is indicated for children over 14 kg."
        
        let typeChewTablet1 = MedicationType()
        typeChewTablet1.parentMedicationName = "Paracetamol"
        typeChewTablet1.name = "Orodispersible tablet"
        typeChewTablet1.concentration = 325
        typeChewTablet1.concentrationUnit = "mg"
        typeChewTablet1.minWeight = 19
        typeChewTablet1.routeOfAdministration = "Oral route"
        typeChewTablet1.hyperlink = "https://www.vademecum.es/medicamento-apiretal+comp.+bucodispersable+325+mg_prospecto_70571"
        typeChewTablet1.suggestion = "It is not suitable for children under 19 kg. For children weighing between 14 and 19 kg, the use of 250 mg orodispersible tablets is recommended."
        
        let typeChewTablet2 = MedicationType()
        typeChewTablet2.parentMedicationName = "Paracetamol"
        typeChewTablet2.name = "Orodispersible tablet"
        typeChewTablet2.concentration = 500
        typeChewTablet2.concentrationUnit = "mg"
        typeChewTablet2.minWeight = 27
        typeChewTablet2.routeOfAdministration = "Oral route"
        typeChewTablet2.hyperlink = "https://cima.aemps.es/cima/dochtml/p/70572/Prospecto_70572.html"
        typeChewTablet2.suggestion = "This medicine is not indicated for children under 27 kg. For children weighing less, have a look at other presentations"
        
        let typeTablet = MedicationType()
        typeTablet.parentMedicationName = "Paracetamol"
        typeTablet.name = "Tablet"
        typeTablet.concentration = 500
        typeTablet.concentrationUnit = "mg"
        typeTablet.minWeight = 40
        typeTablet.routeOfAdministration = "Oral route"
        typeTablet.hyperlink = "https://www.vademecum.es/medicamento-termalgin_prospecto_23203"
        typeTablet.suggestion = "Because of the amount of paracetamol it contains, children (younger than 12 years old) cannot take this medicine."
        
        
        paracetamol.medicationTypes.append(typeDrops)
        paracetamol.medicationTypes.append(typeSyrup)
        paracetamol.medicationTypes.append(typeSyrup1)
        paracetamol.medicationTypes.append(typeSup)
        paracetamol.medicationTypes.append(typeSup1)
        paracetamol.medicationTypes.append(typeSup2)
        paracetamol.medicationTypes.append(typeChewTablet)
        paracetamol.medicationTypes.append(typeChewTablet1)
        paracetamol.medicationTypes.append(typeChewTablet2)
        paracetamol.medicationTypes.append(typeTablet)
        
        
        
        do{
            try realm.write {
                realm.add(paracetamol)
            }
        }
        catch{
            print("unable to add medication to the database")
        }
        
        
        
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    
}
