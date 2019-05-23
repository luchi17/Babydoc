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
    
    
     @objc dynamic var quality : String = ""
     @objc dynamic var dateDay : DateFever?
     @objc dynamic var generalDateBegin = Date()
     @objc dynamic var generalDateEnd = Date()
     @objc dynamic var timeSleep : String = ""
    
     var parentDay = LinkingObjects(fromType : DayOfYear.self , property : "sleepTimes" )
    
    
}
