//
//  TextFieldTableViewCell.swift
//  InlineDatePicker
//
//  Created by Ignacio Nieto Carvajal on 11/1/17.
//  Copyright © 2017 Ignacio Nieto Carvajal. All rights reserved.
//

import UIKit
import SwipeCellKit



class TextFieldTableViewCell: SwipeTableViewCell  {
    // outlets
    @IBOutlet weak var fieldNameLabel: UILabel!
    @IBOutlet weak var fieldValue: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        fieldNameLabel.textColor = UIColor.init(hexString: "7F8484")
        fieldValue.textColor = UIColor.init(hexString: "7F8484")
    }
}
