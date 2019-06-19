//
//  DateCustom.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 23/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import Foundation
import RealmSwift


//porque propiedades de Date no son accesibles
class DateCustom : Object{
    
    
    @objc dynamic var day : Int = 0
    @objc dynamic var month : Int = 0
    @objc dynamic var year : Int = 0
    
    
    var parentFever = LinkingObjects(fromType : Fever.self , property : "date" )
    var parentDose = LinkingObjects(fromType : MedicationDoseCalculated.self , property : "date" )
    var parentGrowth = LinkingObjects(fromType : Growth.self , property : "date" )
    var parentSleepBegin = LinkingObjects(fromType : Sleep.self , property : "dateBegin" )
    var parentSleepEnd = LinkingObjects(fromType : Sleep.self , property : "dateEnd" )
    
    
    
    
}
