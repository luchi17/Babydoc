//
//  DateDrugDose.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 22/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import Foundation
import RealmSwift


//porque propiedades de Date no son accesibles
class DateDrugDose : Object{
    
    
    @objc dynamic var day : Int = 0
    @objc dynamic var month : Int = 0
    @objc dynamic var year : Int = 0
    
    
    var parentMedication = LinkingObjects(fromType : Fever.self , property : "date" )
    
    
    
    
}
