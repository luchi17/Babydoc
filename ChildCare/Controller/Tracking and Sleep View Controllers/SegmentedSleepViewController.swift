//
//  SegmentedSleepViewController.swift
//  ChilCare
//
//  Created by Luchi Parejo alcazar on 28/05/2019.
//  Copyright © 2019 Luchi Parejo alcazar. All rights reserved.
//

import Foundation
import UIKit
class SegmentedSleepViewController : UIViewController{
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    lazy var firstViewController: SleepViewController = {

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        var viewController = storyboard.instantiateViewController(withIdentifier: "FirstViewController") as! SleepViewController

        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
   lazy var secondViewController: ChartsViewController = {

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        var viewController = storyboard.instantiateViewController(withIdentifier: "SecondViewController") as! ChartsViewController
 
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    lazy var thirdViewController: PercentilViewController = {

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        var viewController = storyboard.instantiateViewController(withIdentifier: "PercentilViewController") as! PercentilViewController

        self.add(asChildViewController: viewController)
        
        return viewController
    }()

    func viewController() -> SegmentedSleepViewController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SegmentedView") as! SegmentedSleepViewController
    }


    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        updateView()
    }

    
    func add(asChildViewController viewController: UIViewController) {
        
        addChild(viewController)

        containerView.addSubview(viewController.view)

        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        viewController.didMove(toParent: self)
    }

    
    private func remove(asChildViewController viewController: UIViewController) {
      
        viewController.willMove(toParent: nil)

        viewController.view.removeFromSuperview()

        viewController.removeFromParent()
    }
    

    
     func updateView() {
        if segmentedControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: secondViewController)
            remove(asChildViewController: thirdViewController)
            add(asChildViewController: firstViewController)
        } else if segmentedControl.selectedSegmentIndex == 1{
            remove(asChildViewController: firstViewController)
            remove(asChildViewController: thirdViewController)
            add(asChildViewController: secondViewController)
        }
        else{
           remove(asChildViewController: firstViewController)
            remove(asChildViewController: secondViewController)
            add(asChildViewController: thirdViewController)
        }
    }

    
    func setupView() {
        
        
        updateView()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
 
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

