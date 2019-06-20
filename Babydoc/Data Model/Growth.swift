//
//  Growth.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 14/06/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import Foundation
import RealmSwift

class Growth : Object {

    @objc dynamic var date : DateCustom?
    @objc dynamic var generalDate = Date()
    @objc dynamic var weight : Float = 0.0
    @objc dynamic var height : Float = 0.0
    @objc dynamic var headDiameter : Float = 0.0
    
    let parentBaby = LinkingObjects(fromType : Baby.self , property : "growth" )
    
    
    
}


