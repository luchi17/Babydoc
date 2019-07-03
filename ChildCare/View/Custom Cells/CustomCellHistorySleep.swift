//
//  CustomCellHistorySleep.swift
//  ChilCare
//
//  Created by Luchi Parejo alcazar on 29/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import UIKit
import SwipeCellKit

class CustomCellHistorySleep: SwipeTableViewCell {

    
    @IBOutlet weak var typeSleep: UILabel!
    @IBOutlet weak var starttime: UILabel!
    @IBOutlet weak var endtime: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
   

}
