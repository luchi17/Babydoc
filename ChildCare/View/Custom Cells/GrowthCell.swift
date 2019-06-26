//
//  GrowthCell.swift
//  ChilCare
//
//  Created by Luchi Parejo alcazar on 12/06/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import UIKit
import SwipeCellKit

class GrowthCell: SwipeTableViewCell {
    
    
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var head: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
 
    
}

