//
//  Medication.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 14/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import Foundation
import RealmSwift

class Medication : Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var maxDose : String = ""
    

    let medicationTypes = List<MedicationType>()
    //let medicationDoses = List<MedicationDoseCalculated>()
    
    let parentBaby = LinkingObjects(fromType : Baby.self , property : "medications" )
    
    
    
    
    
    
}
