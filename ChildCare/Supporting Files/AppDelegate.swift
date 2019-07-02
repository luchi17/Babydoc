//
//  AppDelegate.swift
//  ChilCare
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
       
        print(Realm.Configuration.defaultConfiguration.fileURL as Any)
        
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.barTintColor = UIColor.init(hexString: "64C5CF")
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
        paracetamol.maxDose = "60 mg/kg/day"
        let typeDrops = MedicationType()
        typeDrops.name = "Drops"
        typeDrops.concentration = 100
        typeDrops.maxWeight = 32
        typeDrops.concentrationUnit = "mg/ml"
        typeDrops.routeOfAdministration = "Oral route"
        typeDrops.hyperlink = "https://cima.aemps.es/cima/dochtml/p/49302/Prospecto_49302.html"
        typeDrops.suggestion = "No minimum recommended age.\nIt is advisable to consult a doctor before administering it to children under 3 years of age.\nTrick for quick use: 0.15*weight(kg)*25 = drops per dose every 6 hours."
        typeDrops.medication = paracetamol
        
        let typeSyrup = MedicationType()
        typeSyrup.name = "Syrup"
        typeSyrup.concentration = 30
        typeSyrup.concentrationUnit = "mg/ml"
        typeSyrup.minWeight = 4
        typeSyrup.maxWeight = 32
        typeSyrup.routeOfAdministration = "Oral route"
        typeSyrup.suggestion = "No minimum recommended age.\nChildren younger than 2 years old can only take this medicine if their doctor has prescribed it for them."
        typeSyrup.hyperlink = "https://www.vademecum.es/medicamento-efferalgan+pediatrico_prospecto_58157"
        typeSyrup.medication = paracetamol
        
        let typeSyrup1 = MedicationType()
        typeSyrup1.name = "Syrup"
        typeSyrup1.concentration = 100
        typeSyrup1.concentrationUnit = "mg/ml"
        typeSyrup1.routeOfAdministration = "Oral route"
        typeSyrup1.maxWeight = 32
        typeSyrup1.suggestion = "No minimum recommended age.\nIt is advisable to consult a doctor before administering it to children under 3 years of age.\nTrick for quick use: 0.15*weight(kg) = ml per dose every 6 hours."
        typeSyrup1.hyperlink = "https://cima.aemps.es/cima/dochtml/p/49302/Prospecto_49302.html"
        typeSyrup1.medication = paracetamol
        
        
        let typeSup = MedicationType()
        typeSup.name = "Suppository"
        typeSup.concentration = 150
        typeSup.concentrationUnit = "mg"
        typeSup.minWeight = 10
        typeSup.maxWeight = 20
        typeSup.routeOfAdministration = "Rectal route"
        typeSup.hyperlink = "https://www.vademecum.es/medicamento-febrectal_prospecto_45930"
        typeSup.suggestion = "Minimum recommended age: 1 year old (about 10 kg).\nFor children under 2 years old the dose should be established individually by the doctor."
        typeSup.medication = paracetamol
        
        
        let typeSup1 = MedicationType()
        typeSup1.name = "Suppository"
        typeSup1.concentration = 250
        typeSup1.concentrationUnit = "mg"
        typeSup1.minWeight = 17
        typeSup1.maxWeight = 33
        typeSup1.routeOfAdministration = "Rectal route"
        typeSup1.hyperlink = "https://www.vademecum.es/medicamento-apiretal_prospecto_56301"
        typeSup1.suggestion = "Minimum recommended age: 4 years old (about 17 kg)."
        typeSup1.medication = paracetamol
        
        
        let typeSup2 = MedicationType()
        typeSup2.name = "Suppository"
        typeSup2.concentration = 300
        typeSup2.concentrationUnit = "mg"
        typeSup2.minWeight = 20
        typeSup2.routeOfAdministration = "Rectal route"
        typeSup2.hyperlink = "https://www.vademecum.es/medicamento-febrectal+sup.+inf.+300+mg_prospecto_45929"
        typeSup2.suggestion = "It is recommended not to administer more than 5 doses every 24 hours to children under the age of 12, unless indicated by your doctor."
        typeSup2.medication = paracetamol
        
        
        let typeChewTablet = MedicationType()
        typeChewTablet.name = "Orodispersible Tablet"
        typeChewTablet.concentration = 250
        typeChewTablet.concentrationUnit = "mg"
        typeChewTablet.minWeight = 14
        typeChewTablet.routeOfAdministration = "Oral route"
        typeChewTablet.hyperlink = "https://www.vademecum.es/medicamento-apiretal_prospecto_70569"
        typeChewTablet.suggestion = "Minimum recommended age: 3 years old (about 14 kg)."
        typeChewTablet.medication = paracetamol
        
        
        let typeChewTablet1 = MedicationType()
        typeChewTablet1.name = "Orodispersible Tablet"
        typeChewTablet1.concentration = 325
        typeChewTablet1.concentrationUnit = "mg"
        typeChewTablet1.minWeight = 19
        typeChewTablet1.routeOfAdministration = "Oral route"
        typeChewTablet1.hyperlink = "https://www.vademecum.es/medicamento-apiretal+comp.+bucodispersable+325+mg_prospecto_70571"
        typeChewTablet1.suggestion = "Minimum recommended age: 5 years old (about 19 kg)."
        typeChewTablet1.medication = paracetamol
        
        let typeChewTablet2 = MedicationType()
        
        typeChewTablet2.name = "Orodispersible Tablet"
        typeChewTablet2.concentration = 500
        typeChewTablet2.concentrationUnit = "mg"
        typeChewTablet2.minWeight = 27
        typeChewTablet2.routeOfAdministration = "Oral route"
        typeChewTablet2.hyperlink = "https://cima.aemps.es/cima/dochtml/p/70572/Prospecto_70572.html"
        typeChewTablet2.suggestion = "Minimum recommended age: 8 years old (about 27 kg)."
        typeChewTablet2.medication = paracetamol
        
        let typeTablet = MedicationType()
        
        typeTablet.name = "Tablet"
        typeTablet.concentration = 500
        typeTablet.concentrationUnit = "mg"
        typeTablet.minWeight = 40
        typeTablet.routeOfAdministration = "Oral route"
        typeTablet.hyperlink = "https://www.vademecum.es/medicamento-termalgin_prospecto_23203"
        typeTablet.suggestion = "Minimum recommended age: 12 years old (about 40 kg)"
        typeTablet.medication = paracetamol
        
        
//        paracetamol.medicationTypes.append(typeDrops)
//        paracetamol.medicationTypes.append(typeSyrup)
//        paracetamol.medicationTypes.append(typeSyrup1)
//        paracetamol.medicationTypes.append(typeSup)
//        paracetamol.medicationTypes.append(typeSup1)
//        paracetamol.medicationTypes.append(typeSup2)
//        paracetamol.medicationTypes.append(typeChewTablet)
//        paracetamol.medicationTypes.append(typeChewTablet1)
//        paracetamol.medicationTypes.append(typeChewTablet2)
//        paracetamol.medicationTypes.append(typeTablet)
        
        let ibuprofen = Medication()
        ibuprofen.name = "Ibuprofen"
        ibuprofen.maxDose = "30 mg/kg/day"
        let typeSyrup20 = MedicationType()
        typeSyrup20.name = "Syrup"
        typeSyrup20.concentration = 20
        typeSyrup20.minWeight = 5
        typeSyrup20.maxWeight = 42
        typeSyrup20.concentrationUnit = "mg/ml"
        typeSyrup20.routeOfAdministration = "Oral route"
        typeSyrup20.hyperlink = "https://www.vademecum.es/medicamento-dalsy_prospecto_59166"
        typeSyrup20.suggestion = "Minimum recommended age: 3 months (about 5-6 kg).\nThe use of this medicine in children under 2 years old will always be done by prescription.\nIt is recommended to take it with food or immediately after eating to reduce the possibility of stomach discomfort."
        typeSyrup20.medication = ibuprofen
        
        let typeSyrup40 = MedicationType()
        typeSyrup40.name = "Syrup"
        typeSyrup40.concentration = 40
        typeSyrup40.minWeight = 5
        typeSyrup40.concentrationUnit = "mg/ml"
        typeSyrup40.routeOfAdministration = "Oral route"
        typeSyrup40.hyperlink = "https://www.vademecum.es/medicamento-dalsy_prospecto_69726"
        typeSyrup40.suggestion = "Minimum recommended age: 3 months (about 5-6 kg).\nThe use of this medicine in children under 2 years old will always be done by prescription.\nIt is recommended to take it with food or immediately after eating to reduce the possibility of stomach discomfort."
        typeSyrup40.medication = ibuprofen
        
        let typesachet = MedicationType()
        typesachet.name = "Sachet"
        typesachet.concentration = 200
        typesachet.minWeight = 20
        typesachet.concentrationUnit = "mg"
        typesachet.routeOfAdministration = "Oral route"
        typesachet.hyperlink = "https://www.vademecum.es/medicamento-dalsy_prospecto_63990"
        typesachet.suggestion = "Minimum recommended age: 6-7 years old (about 20 kg).\nIt is recommended to take it with food or immediately after eating to reduce the possibility of stomach discomfort."
        typesachet.medication = ibuprofen
        
        let typesachet1 = MedicationType()
        typesachet1.name = "Sachet"
        typesachet1.concentration = 400
        typesachet1.minWeight = 40
        typesachet1.concentrationUnit = "mg"
        typesachet1.routeOfAdministration = "Oral route"
        typesachet1.hyperlink = "https://cima.aemps.es/cima/dochtml/p/68194/P_68194.html"
        typesachet1.suggestion = "Minimum recommended age: 12 years old (about 40 kg).\nIt is recommended to take it with food or immediately after eating to reduce the possibility of stomach discomfort."
        typesachet1.medication = ibuprofen
        
        let typeoro = MedicationType()
        typeoro.name = "Orodispersible Tablet"
        typeoro.concentration = 200
        typeoro.minWeight = 20
        typeoro.concentrationUnit = "mg"
        typeoro.routeOfAdministration = "Oral route"
        typeoro.hyperlink = "https://www.vademecum.es/medicamento-junifen_prospecto_64966"
        typeoro.suggestion = "Minimum recommended age: 6 years old (about 20 kg).\nIt is recommended to take it with food if you have a sensitive stomach."
        typeoro.medication = ibuprofen
        
        let typetab = MedicationType()
        typetab.name = "Tablet"
        typetab.concentration = 400
        typetab.minWeight = 40
        typetab.concentrationUnit = "mg"
        typetab.routeOfAdministration = "Oral route"
        typetab.hyperlink = "https://www.vademecum.es/medicamento-neobrufen_prospecto_70030"
        typetab.suggestion = "Minimum recommended age: 12 years old (about 40 kg).\nIt is recommended to take it with food or immediately after eating to reduce the possibility of stomach discomfort."
        typetab.medication = ibuprofen
        
//        ibuprofen.medicationTypes.append(typeSyrup20)
//        ibuprofen.medicationTypes.append(typeSyrup40)
//        ibuprofen.medicationTypes.append(typesachet)
//        ibuprofen.medicationTypes.append(typesachet1)
//        ibuprofen.medicationTypes.append(typeoro)
//        ibuprofen.medicationTypes.append(typetab)
        
    
        
        do{
            try realm.write {
                realm.add(paracetamol)
                realm.add(ibuprofen)
                
                realm.add(typeDrops)
                realm.add(typeSyrup)
                realm.add(typeChewTablet)
                realm.add(typeChewTablet1)
                realm.add(typeChewTablet2)
                realm.add(typeSup)
                realm.add(typeSup1)
                realm.add(typeSup2)
                realm.add(typeTablet)
                
               
                realm.add(typeSyrup1)
                realm.add(typeSyrup20)
                realm.add(typeSyrup40)
                realm.add(typesachet)
                realm.add(typesachet1)
                realm.add(typeoro)
                realm.add(typetab)
                
                
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
