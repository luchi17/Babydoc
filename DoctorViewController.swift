//
//  File.swift
//  Babydoc
//
//  Created by Luchi Parejo alcazar on 09/04/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//


import UIKit

class DoctorViewController : UIViewController {
    
    
    @IBOutlet weak var sleep: ActionView!
    
    @IBOutlet weak var feed: ActionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(sleep.bounds.height) //30
       // print(sleep.bounds.width)  //240
        sleep.layer.cornerRadius = 10
        sleep.layer.masksToBounds = true
        feed.layer.cornerRadius = 10
        feed.layer.masksToBounds = true
        
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func didSwipetoHome(_ sender:UISwipeGestureRecognizer ) {
        
        if sender.direction == UISwipeGestureRecognizer.Direction.right && sender.state == .ended{
            performSegue(withIdentifier: "goToHome", sender: nil)
        }
    }

    

}

class ActionView:UIView
    
{
 
    
    override func draw(_ rect: CGRect)
    {
        let width = self.bounds.width
        let day : CGFloat = 24
       //
        if self.tag == 0{
            
            //imagine sleep times of : 0-12  and 12:30 to 13:30 and 15-17
            fillColor(start : (0*width)/day ,with: .cyan, width: (12*width)/day)
            fillColor(start : ((12+0.5)*width)/day ,with: .cyan, width: (1*width)/day)
            fillColor(start : (15*width)/day ,with: .cyan, width: (2*width)/day)
            
        }

        else if self.tag == 1{

            //imagine feed times of 12-4 and 22-24
            self.fillColor(start : (12*width)/day, with: .blue, width: 4*width/day)
            self.fillColor(start : (22*width)/day, with: .blue, width: 2*width/day)
        }
        
        
    }
    
    func fillColor(start : CGFloat,with color:UIColor,width:CGFloat)
    {
        let topRect = CGRect(x : start, y:0, width : width, height: self.bounds.height)
        color.setFill()
        UIRectFill(topRect)
    }
    
}
