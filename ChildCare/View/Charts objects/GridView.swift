//
//  GridView.swift
//  ChildCare
//
//  Created by Luchi Parejo alcazar on 03/07/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import Foundation
import UIKit

class GridView: UIView
    
{
    private var path = UIBezierPath()
    
    fileprivate var gridWidthMultiple: CGFloat
    {
        return 4
    }
    fileprivate var gridHeightMultiple : CGFloat
    {
        return 20
    }
    
    fileprivate var gridWidth: CGFloat
    {
        return bounds.width/CGFloat(gridWidthMultiple)
    }
    
    fileprivate var gridHeight: CGFloat
    {
        return bounds.height/CGFloat(gridHeightMultiple)
    }
    
    fileprivate var gridCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    fileprivate func drawGrid()
    {
        path = UIBezierPath()
        path.lineWidth = 0.15
        
        for index in 0...Int(gridWidthMultiple)
        {
            let start = CGPoint(x: CGFloat(index) * gridWidth, y: 0)
            let end = CGPoint(x: CGFloat(index) * gridWidth, y:bounds.height)
            path.move(to: start)
            path.addLine(to: end)
        }
        path.close()
        
    }
    
    override func draw(_ rect: CGRect)
    {
        drawGrid()
        UIColor.black.setStroke()
        path.stroke()
        
}
}


