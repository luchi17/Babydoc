//
//  CustomCellHistoryDose.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 18/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import UIKit
import SwipeCellKit

class CustomCellHistoryDose: SwipeTableViewCell{
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var nameDose: UILabel!
    @IBOutlet weak var descriptionDose: UILabel!
    @IBOutlet weak var descriptionDose2: UILabel!
    @IBOutlet weak var descriptionDose3: UILabel!
    
}
