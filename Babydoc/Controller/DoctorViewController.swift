//
//  File.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 09/04/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//


import UIKit
//import RealmSwift
import ChameleonFramework
import AUPickerCell


class DoctorViewController : UIViewController {
    
    @IBOutlet weak var feverButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var vaccineButton: UIButton!
    @IBOutlet weak var medicationButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       medicationButton.layer.masksToBounds = false
        medicationButton.layer.shadowColor = UIColor.flatGray.cgColor
        medicationButton.layer.shadowOpacity = 0.7
        medicationButton.layer.shadowRadius = 1
        medicationButton.layer.shadowOffset = CGSize(width: 1.2, height: 1.2)
        
        //self.view.addSubview(feverButton)
        
    }
    
    
    
    
    
    

}

