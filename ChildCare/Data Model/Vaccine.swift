//
//  Vaccine.swift
//  ChildCare
//
//  Created by Luchi Parejo alcazar on 09/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import Foundation
import RealmSwift

class Vaccine : Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var funded : Bool = true
    
    let doses = List<VaccineDose>()
    //let parentChild = LinkingObjects(fromType : Child.self , property : "vaccines" )
    
    
    
    
    
    
}
