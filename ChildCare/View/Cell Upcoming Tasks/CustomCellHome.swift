//
//  CustomCellHome.swift
//  ChildCare
//
//  Created by Luchi Parejo alcazar on 15/04/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import UIKit
import SwipeCellKit

class CustomCellHome: SwipeTableViewCell{

    
    @IBOutlet var actionImage: UIImageView!
    
    @IBOutlet var actionName: UILabel!

    
    @IBOutlet var nameTitle: UILabel!
    @IBOutlet var nameField: UILabel!
    
    
    @IBOutlet var quantityTitle: UILabel!
    @IBOutlet var quantityField: UILabel!
    
    
    @IBOutlet var dateTitle: UILabel!
    @IBOutlet var dateField: UILabel!
    
    @IBOutlet var noteTitle: UILabel!
   
    @IBOutlet var noteField: UILabel!
    
    @IBOutlet var stackViewTitles: UIStackView!
    @IBOutlet var stackViewFields: UIStackView!
    
    
    @IBOutlet var inforDisplay: RoundShadowView!
    override func awakeFromNib() {
        super.awakeFromNib()

    }
 

}


