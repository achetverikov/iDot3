//
//  MenuViewController.swift
//  iDot3x
//
//  Created by Tomas Kristjansson on 28/01/16.
//  Copyright © 2016 Andrey Chetverikov. All rights reserved.
//

import UIKit

//Stillum upphafsgildi parametra og breyta sem við notum
var setsize = 40
var condition = "r/g"
var proportion = 50
var timer = 0.0
var participant = ""
var age = 0
var gender = ""
var FeatConj = 0
var startcondition = 0

class MenuViewController: UIViewController {

    //tengjum takkana og textaboxin og gefum þeim nöfn
    @IBOutlet var newgamelabel: UIButton!
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
    
    //hérna köllum við þetta fram á skjáinn
    override func viewDidLoad() {
        super.viewDidLoad()
        //Hér setjum við gildi inn í textaboxin, fyrst eru það default gildin hér að ofan en síðan eru það stillingarnar sem við gerum og þau haldast á milli umferða. Í seinni hlutanum (.value) þá erum við að breyta gildunum sem takkarnir hafa þannig að þeir byrji með sömu gildi og voru í síðustu umferð
        sizelabel.text = String (setsize)
        porplabel.text = String (proportion)
        timelabel.text = String (timer)
        Participantlabel.text = participant
        agelabel.text = String (age)
        genderlabel.text = gender
        sizestepper.value = Double (setsize)
        porpstepper.value = Double (proportion)
        timestepper.value = Double (timer)
        conditionselect.selectedSegmentIndex = startcondition
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // function sem uppfærir öll textabox þegar við ýtum á takkana
    func updateLabels() {
        sizelabel.text = String(sizestepper.value)
        porplabel.text = String(porpstepper.value)
        timelabel.text = String(timestepper.value)
        
        Participantlabel.text = participant
        
        agelabel.text = String (age)
        genderlabel.text = gender
    }
    func clearbetween() {
        behData = []
        stimData = []
        trialN = 0
        trialCompleted = 0
        score = 0
    }

  //hér breytum við gildunum á breytunum sem við skilgreindum efst þegar ýtt er á takka
    @IBAction func saveage(sender: AnyObject) {
        age = Int (agelabel.text!)!
        clearbetween()
    }
    @IBAction func savegender(sender: AnyObject) {
        gender = String (genderlabel.text!)
        clearbetween()
    }
    @IBAction func changedsize(sender: AnyObject) {
        updateLabels()
        clearbetween()
    }
    @IBAction func changedporp(sender: AnyObject) {
        updateLabels()
        clearbetween()
    }
    @IBAction func changedtime(sender: AnyObject) {
        updateLabels()
        clearbetween()
    }
    @IBAction func savesettings(sender: AnyObject) {
        setsize = Int (sizestepper.value)
        clearbetween()
    }
    @IBAction func saveprop(sender: AnyObject) {
        proportion = Int (porpstepper.value)
        clearbetween()
    }
    @IBAction func savetimer(sender: AnyObject) {
        timer = Double (timestepper.value)
        clearbetween()
    }
    @IBAction func saveparticipant(sender: AnyObject) {
        participant = String (Participantlabel.text!)
        clearbetween()
    }
    //látum cleardata takkann hreinsa allar breytur þegar nýr þátttakandi kemur
    @IBAction func cleardata(sender: AnyObject) {
        behData = []
        stimData = []
        trialN = 0
        trialCompleted = 0
        score = 0
        currentDate = NSDate()
        dateFormatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        date_identifier = dateFormatter.stringFromDate(currentDate)
        write_headers = true
        
    }
    //þetta á heima ofar, erum bara að vista conditionið sem er valið
    @IBAction func savecondition(sender: AnyObject) {
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
        default:
            break;
        }  //Switch
    }

    
}
