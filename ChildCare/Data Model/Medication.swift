//
//  Medication.swift
//  ChildCare
//
//  Created by Luchi Parejo alcazar on 14/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import Foundation
import RealmSwift

class Medication : Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var maxDose : String = ""
    

    let medicationDoseTypes = List<MedicationDoseType>()
    
    let parentChild = LinkingObjects(fromType : Child.self , property : "medications" )
    
    
    
    
    
    
}