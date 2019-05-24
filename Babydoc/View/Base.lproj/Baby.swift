//
//  Baby.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 29/04/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import Foundation
import RealmSwift

class Baby : Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var dateOfBirth : String = ""
    @objc dynamic var age : String = ""
    @objc dynamic var weight : Float = 0.0
    @objc dynamic var height : Float = 0.0
    @objc dynamic var headDiameter : Float = 0.0
    @objc dynamic var bloodType : String = ""
    @objc dynamic var allergies : String = ""
    @objc dynamic var illnesses : String = ""
    @objc dynamic var current : Bool = false
    
   
    let vaccines = List<Vaccine>()
    let medicationDoses = List<MedicationDoseCalculated>()
    let fever = List<Fever>()
    let sleeps = List<Sleep>()
    
    var parentRegisteredBabies = LinkingObjects(fromType : RegisteredBabies.self , property : "babies" )

   


    
}



