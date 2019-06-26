//
//  Fever.swift
//  ChildCare
//
//  Created by Luchi Parejo alcazar on 21/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import Foundation
import RealmSwift

class Fever : Object {
    
    @objc dynamic var date : DateCustom?
    @objc dynamic var generalDate = Date()
    @objc dynamic var temperature : Float = 0.0
    @objc dynamic var placeOfMeasurement : String = ""
    
   // let parentChild = LinkingObjects(fromType : Child.self, property : "fever" )

}



