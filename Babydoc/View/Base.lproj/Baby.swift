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
    @objc dynamic var height : Float = 0
    @objc dynamic var weight : Float = 0
    @objc dynamic var bloodType : String = ""
    @objc dynamic var alergies : String = ""
    @objc dynamic var illnesses : String = ""
    
    let calendar = List<DayOfYear>()
    
//    func calcAge(birthday: String) -> Int {
//        let dateFormater = DateFormatter()
//        dateFormater.dateFormat = "MM/dd/yyyy"
//        let birthdayDate = dateFormater.date(from: birthday)
//        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
//        let now = Date()
//        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
//        let age = calcAge.year
//        return age!
//    }
    

    
    
}
