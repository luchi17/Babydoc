//
//  MedicationDoseCalculated.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 18/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import Foundation
import RealmSwift

class MedicationDoseCalculated : Object {
    

    @objc dynamic var parentMedicationName : String = ""
    @objc dynamic var nameType : String = ""
    @objc dynamic var concentrationUnit : String = ""
    @objc dynamic var concentration : Int = 0
    @objc dynamic var weight : Float = 0
    @objc dynamic var date : String = ""
    @objc dynamic var dose : String = ""
    @objc dynamic var doseUnit : String = ""
    
    
    
    var parentBaby = LinkingObjects(fromType : Baby.self , property : "medicationDoses" )
    
    
    
    
    
}

