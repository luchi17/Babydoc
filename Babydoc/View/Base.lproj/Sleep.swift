//
//  Sleep.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 29/04/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import Foundation
import RealmSwift

class Sleep: Object {
    
     var parentDay = LinkingObjects(fromType : DayOfYear.self , property : "sleepTimes" )
     @objc dynamic var quality : String = ""
}
