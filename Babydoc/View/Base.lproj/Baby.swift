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
    @objc dynamic var weight : String = ""
    @objc dynamic var height : String = ""
    @objc dynamic var headDiameter : String = ""
    @objc dynamic var bloodType : String = ""
    @objc dynamic var allergies : String = ""
    @objc dynamic var illnesses : String = ""
   
    let calendar = List<DayOfYear>()
    var parentRegisteredBabies = LinkingObjects(fromType : RegisteredBabies.self , property : "babies" )
    

   


    
}



