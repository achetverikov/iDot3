//
//  MenuViewController.swift
//  iDot3x
//
//  Created by Tomas Kristjansson on 28/01/16.
//  Copyright © 2016 Andrey Chetverikov. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    var condition = 1
    var setsize = 40
    
    @IBOutlet weak var sizelabel: UILabel!
    @IBOutlet weak var sizestepper: UIStepper!
    @IBOutlet weak var porplabel: UILabel!
    @IBOutlet weak var porpstepper: UIStepper!
    @IBOutlet weak var timelabel: UILabel!
    @IBOutlet weak var timestepper: UIStepper!
    @IBOutlet weak var conditionselect: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLabels() {
        sizelabel.text = String(sizestepper.value)
        porplabel.text = String(porpstepper.value)
        timelabel.text = String(timestepper.value)
    }
    
    @IBAction func ChangeLabel(sender: UISegmentedControl) {
        if conditionselect == 0 {
            condition = 1
        }
        if conditionselect == 1 {
            condition = 2
        }
        if conditionselect == 2 {
            condition = 3
        }
        if conditionselect == 3 {
            condition = 4
        }
    }
    @IBAction func changedsize(sender: AnyObject) {
        updateLabels()
    }
    @IBAction func changedporp(sender: AnyObject) {
        updateLabels()
    }
    @IBAction func changedtime(sender: AnyObject) {
        updateLabels()
    }
    @IBAction func savesettings(sender: AnyObject) {
        setsize = Int (sizestepper.value)
    }
}
