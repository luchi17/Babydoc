//
//  ActionView.swift
//  ChildCare
//
//  Created by Luchi Parejo alcazar on 03/07/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import Foundation
import UIKit

class RoundShadowView: UIView{
    
    private var shadowLayer: CAShapeLayer!
    private var cornerRadius: CGFloat = 2.0
    private var fillcolor : UIColor = UIColor.white
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.masksToBounds = false
        self.layer.backgroundColor = UIColor.clear.cgColor
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = fillcolor.cgColor
            
            shadowLayer.shadowColor = UIColor.flatGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            shadowLayer.shadowOpacity = 0.7
            shadowLayer.shadowRadius = 2
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}



