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
    
    @objc dynamic var userId : String = ""
    @objc dynamic var password : String = ""
    @objc dynamic var name : String = ""
    @objc dynamic var dateOfBirth : String = ""
    @objc dynamic var age : String = ""
    @objc dynamic var height : Float = 0
    @objc dynamic var weight : Float = 0
    @objc dynamic var bloodType : String = ""
    @objc dynamic var allergies : String = ""
    @objc dynamic var illnesses : String = ""
   
    let calendar = List<DayOfYear>()
    var parentRegisteredBabies = LinkingObjects(fromType : RegisteredBabies.self , property : "babies" )
    
//
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
   
//    func valueForField(field: FieldType) -> Any {
//        switch field {
//        case .name: return name
//        case .dateOfBirth: return dateOfBirth
//        case .age: return age
//        case .height: return height
//        case .weight: return weight
//        case .bloodType: return bloodType
//        case .allergies: return allergies
//        case .illnesses: return illnesses
//        case .userId: return userId
//        case .password: return password
//        }
//    }
//
//    static var _dateFormatter: DateFormatter?
//    fileprivate static var dateFormatter: DateFormatter {
//        if (_dateFormatter == nil) {
//            _dateFormatter = DateFormatter()
//            _dateFormatter!.locale = Locale(identifier: "en_US_POSIX")
//            _dateFormatter!.dateFormat = "MM/dd/yyyy"
//        }
//        return _dateFormatter!
//    }
//    static func dateFromString(dateString: String) -> Date? {
//        return dateFormatter.date(from: dateString)
//    }
//    static func dateStringFromDate(date: Date) -> String {
//        return dateFormatter.string(from: date)
//    }

    
}
//enum FieldType: String {
//    case name = "Name"
//    case dateOfBirth = "Date of Birth"
//    case age = "Age"
//    case height = "Height"
//    case weight = "Weight"
//    case bloodType = "Blood Type"
//    case allergies = "Allergies"
//    case illnesses = "Illnesses"
//    case userId = "User Id"
//    case password = "Password"
//}


