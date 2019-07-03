//
//  File.swift
//  ChilCare
//
//  Created by Luchi Parejo alcazar on 30/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import Foundation
import UIKit

class ActionViewPercentil : UIView{
    
    let napColor : UIColor = UIColor.init(hexString: "66ACF8")!
    var sleepcolor : UIColor = UIColor.init(hexString: "2772db")!
    var lowPercentilNight = Float(0.0)
    var highPercentilNight = Float(0.0)
    var lowPercentilNap = Float(0.0)
    var highPercentilNap = Float(0.0)
    var avgNight = Float(0.0)
    var avgNap = Float(0.0)
    
    
    func fillColor(start : CGFloat,with color:UIColor,width:CGFloat)
    {
        let topRect = CGRect(x : start, y:0, width : width, height: self.bounds.height)
        color.setFill()
        UIRectFill(topRect)
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func draw(_ rect: CGRect)
    {
        let width = self.bounds.width
        let nightHours : CGFloat = 14
        let napHours : CGFloat = 10
        
        switch self.tag {
        
        //Sleep-time rectangle
        case 0:
           
                self.fillColor(start : (CGFloat(lowPercentilNight)*width)/nightHours, with: .gray, width: (0.2*width)/nightHours)
                self.fillColor(start : (CGFloat(highPercentilNight)*width)/nightHours, with: .gray, width: (0.2*width)/nightHours)
                
                if avgNight != 0{
                if (avgNight > lowPercentilNight) && (avgNight < highPercentilNight){
                    
                    self.fillColor(start : (CGFloat(avgNight)*width)/nightHours, with: sleepcolor, width: (0.25*width)/nightHours)
                }
                else if (avgNight <= lowPercentilNight) || (avgNight >= highPercentilNight){
                    self.fillColor(start : (CGFloat(avgNight)*width)/nightHours, with: .red, width: (0.25*width)/nightHours)
                }
            }
            
        //Nap-time rectangle
        case 1:

           
                self.fillColor(start : (CGFloat(lowPercentilNap)*width)/napHours, with: .gray, width: (0.15*width)/napHours)
                self.fillColor(start : (CGFloat(highPercentilNap)*width)/napHours, with: .gray, width: (0.15*width)/napHours)
                
                if avgNap != Float(0.0){
                if (avgNap > lowPercentilNap) && (avgNap < highPercentilNap){
                    
                    self.fillColor(start : (CGFloat(avgNap)*width)/napHours, with: napColor, width: (0.2*width)/napHours)
                }
                else if (avgNap <= lowPercentilNap) || (avgNap >= highPercentilNap){
                    self.fillColor(start : (CGFloat(avgNap)*width)/napHours, with: .red, width: (0.2*width)/napHours)
                }
            }
            
            
            
            
        default:
            break
        }
    }
    
    
    
    
}
