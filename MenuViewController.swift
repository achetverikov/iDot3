//
//  MenuViewController.swift
//  iDot3x
//
//  Created by Tomas Kristjansson on 28/01/16.
//  Copyright © 2016 Andrey Chetverikov. All rights reserved.
//

import UIKit

//Setting the default values of the parameters and variables that we use
var setsize = 40
var condition = "r/g"
var proportion = 50
var timer = 0.0
var participant = ""
var age = 0
var gender = ""
var FeatConj = 0
var startcondition = 0
var starttask = 0
var settrial = 20
var task = 0

class MenuViewController: UIViewController {

    //connecting the buttons and textboxes and naming them
    @IBOutlet var newgamelabel: UIButton!
    @IBOutlet var Triallabel: UILabel!
    @IBOutlet weak var agelabel: UITextField!
    @IBOutlet weak var genderlabel: UITextField!
    @IBOutlet weak var Participantlabel: UITextField!
    @IBOutlet weak var sizelabel: UILabel!
    @IBOutlet weak var sizestepper: UIStepper!
    @IBOutlet weak var porplabel: UILabel!
    @IBOutlet weak var porpstepper: UIStepper!
    @IBOutlet weak var timelabel: UILabel!
    @IBOutlet weak var timestepper: UIStepper!
    @IBOutlet weak var conditionselect: UISegmentedControl!
    @IBOutlet weak var TrialStepper: UIStepper!
    @IBOutlet weak var taskselect: UISegmentedControl!
    
    //calling the settings screen to the screen
    override func viewDidLoad() {
        super.viewDidLoad()
        //Here we put values into the text boxes, first they are the default values but they should then become the values that we give them by tapping the steppers. The .value lines we are chaning the starting value of the steppers so that their value starts as we last set them (they do not reset to default values between rounds)
        sizelabel.text = String (setsize)
        Triallabel.text = String (settrial)
        porplabel.text = String (proportion)
        timelabel.text = String (timer)
        Participantlabel.text = participant
        agelabel.text = String (age)
        genderlabel.text = gender
        sizestepper.value = Double (setsize)
        porpstepper.value = Double (proportion)
        timestepper.value = Double (timer)
        conditionselect.selectedSegmentIndex = startcondition
        taskselect.selectedSegmentIndex = starttask
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // function that updates the labels
    func updateLabels() {
        sizelabel.text = String(sizestepper.value)
        porplabel.text = String(porpstepper.value)
        timelabel.text = String(timestepper.value)
        Triallabel.text = String(TrialStepper.value)
        
        Participantlabel.text = participant
        
        agelabel.text = String (age)
        genderlabel.text = gender
    }
    //function that clears the data between rounds
    func clearbetween() {
        behData = []
        stimData = []
        trialN = 0
        trialCompleted = 0
        score = 0
        new_game_starting = 0
    }

  //here we change the values of the global variables as we push the steppers
    @IBAction func saveage(_ sender: AnyObject) {
        age = Int (agelabel.text!)!
        new_game_starting = 1
    }
    @IBAction func savetrial(_ sender: AnyObject) {
        settrial = Int (TrialStepper.value)
        updateLabels()
    }
    @IBAction func savegender(_ sender: AnyObject) {
        gender = String (genderlabel.text!)
        new_game_starting = 1
    }
    @IBAction func changedsize(_ sender: AnyObject) {
        updateLabels()
    }
    @IBAction func changedporp(_ sender: AnyObject) {
        updateLabels()
    }
    @IBAction func changedtime(_ sender: AnyObject) {
        updateLabels()
        new_game_starting = 1
    }
    @IBAction func savesettings(_ sender: AnyObject) {
        setsize = Int (sizestepper.value)
        new_game_starting = 1
    }
    @IBAction func saveprop(_ sender: AnyObject) {
        proportion = Int (porpstepper.value)
        new_game_starting = 1
    }
    @IBAction func savetimer(_ sender: AnyObject) {
        timer = Double (timestepper.value)
        new_game_starting = 1
    }
    @IBAction func saveparticipant(_ sender: AnyObject) {
        participant = String (Participantlabel.text!)
        new_game_starting = 1
    }
    //here we let the new game button clear all variables for a new participant
    @IBAction func cleardata(_ sender: AnyObject) {
        clearbetween()
        participant = ""
        age = 0
        gender = ""
        updateLabels()
        currentDate = Date()
        dateFormatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        date_identifier = dateFormatter.string(from: currentDate)
        write_headers = true
        
    }
    //This changes the value of the global condition variable in addition to defining if it is a feature or conjunction search
    @IBAction func savetask(_ sender: AnyObject) {
    switch sender.selectedSegmentIndex {
        case 0:
            starttask = 0
            task = 0
        case 1:
            starttask = 1
            task = 1
        case 2:
            starttask = 2
            task = 2
        case 3:
            starttask = 3
            task = 3
        default:
            break;
        }
        new_game_starting = 1
        
    }
    @IBAction func savecondition(_ sender: AnyObject) {
        switch sender.selectedSegmentIndex {
        case 0:
            condition = "r/g"
            FeatConj = 0
            startcondition = 0
        case 1:
            condition = "b/y"
            FeatConj = 0
            startcondition = 1
        case 2:
            condition = "rs/gd"
            FeatConj = 1
            startcondition = 2
        case 3:
            condition = "rd/gs"
            FeatConj = 1
            startcondition = 3
        case 4:
            condition = "R/G-n"
            FeatConj = 0
            startcondition = 4
        case 5:
            condition = "R/G-w"
            FeatConj = 0
            startcondition = 5
        case 6:
            condition = "B/Y-n"
            FeatConj = 0
            startcondition = 6
        case 7:
            condition = "B/Y-w"
            FeatConj = 0
            startcondition = 7
        case 8:
            condition = "RS/GD-n"
            FeatConj = 1
            startcondition = 8
        case 9:
            condition = "RS/GD-w"
            FeatConj = 1
            startcondition = 9
        case 10:
            condition = "BS/YD-n"
            FeatConj = 1
            startcondition = 10
        case 11:
            condition = "BS/YD-w"
            FeatConj = 1
            startcondition = 11
        default:
            break;
        }
        new_game_starting = 1
        //Switch
    }

    
}
