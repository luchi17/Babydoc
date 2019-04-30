//
//  DayOfYear.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 29/04/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import UIKit
import RealmSwift

class DayOfYear : Object {
    
    @objc dynamic var date = Date()
    var sleepTimes =  List<Sleep>()
    var parentBaby = LinkingObjects(fromType : Baby.self , property : "calendar" )
}
