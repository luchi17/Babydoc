//
//  MedicationType.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 15/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import Foundation
import RealmSwift

class MedicationType : Object {
    
    @objc dynamic var parentMedicationName : String = ""
    @objc dynamic var name : String = ""
    @objc dynamic var minWeight : Int = 3
    @objc dynamic var maxWeight : Int = 60
    @objc dynamic var concentration : Int = 0
    @objc dynamic var concentrationUnit : String = ""
    @objc dynamic var routeOfAdministration : String = ""
    @objc dynamic var suggestion : String = ""
    @objc dynamic var hyperlink : String = ""
    @objc dynamic var applied : Bool = false
    
    let parentMedication = LinkingObjects(fromType : Medication.self , property : "medicationTypes" )
    
    
    
    
    
}
