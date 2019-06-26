//
//  Sleep.swift
//  ChildCare
//
//  Created by Luchi Parejo alcazar on 21/06/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import Foundation
import RealmSwift

class Sleep : Object {
    
    @objc dynamic var dateBegin : DateCustom?
    @objc dynamic var dateEnd : DateCustom?
    @objc dynamic var generalDateBegin = Date()
    @objc dynamic var generalDateEnd = Date()
    @objc dynamic var timeSleep : String = ""
    @objc dynamic var timeSleepFloat : Float = 0.0
    @objc dynamic var nightSleep : Bool = true
    
    //let parentChild = LinkingObjects(fromType : Child.self , property : "sleeps" )
    
    
    
}

