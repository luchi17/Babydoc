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
    
    
     @objc dynamic var dateBegin : DateCustom?
     @objc dynamic var dateEnd : DateCustom?
     @objc dynamic var generalDateBegin = Date()
     @objc dynamic var generalDateEnd = Date()
     @objc dynamic var timeSleep : String = ""
     @objc dynamic var timeSleepFloat : Float = 0.0
     @objc dynamic var nightSleep : Bool = true
    
    
     var parentBaby = LinkingObjects(fromType : Baby.self , property : "sleeps" )
    
    
}
