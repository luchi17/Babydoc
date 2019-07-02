//
//  Dose.swift
//  ChildCare
//
//  Created by Luchi Parejo alcazar on 09/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import Foundation
import RealmSwift

class VaccineDose : Object{
    
    @objc dynamic var ageOfVaccination : String = ""
    @objc dynamic var dateOfVaccination : String = ""
    @objc dynamic var dateOfAdministration : String = ""
    @objc dynamic var applied : Bool = false

    let parentVaccine = LinkingObjects(fromType : Vaccine.self , property : "doses" )

}
