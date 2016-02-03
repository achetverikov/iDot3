//
//  TrialData.swift
//  iDot3x
//
//  Created by Andrey Chetverikov on 02/02/16.
//  Copyright © 2016 Andrey Chetverikov. All rights reserved.
////
//
//import Foundation
//import SpriteKit
//
//class TouchData{
//    var stim: Stimulus
//    var touch: UITouch
//    var timeTS: CFTimeInterval
//    var trialResult: Int
//    var touchX, touchY, touchX1, touchY2: CGPoint
//    var trialN, touchN, runN, runLength: Int
//    init(touch:UITouch, timeTS: CFTimeInterval, trialN: Int){
//        self.touch=touch
//        self.timeTS=timeTS
//        self.trialN=trialN
//        
//    }
//    func describe(){
//    ///    data_string = "\(participantN), \(trialN), \(condition), \(setsize), \(proportion), \(timelimit), \(stimulus.stType), "
//    }
//    ///behData[trialN].append(["participantN":"", "trialN":trialN, "condition":condition, "setSize":setsize, "proportion":proportion, "timelimit":0, "stType":stimulus.stType, "imgName":stimulus.imgName, "timeTS": ts_cac, "timeRel": timeRel,"runLength":0,"touchTS":touch.timestamp, "runN":runN, "stPosX":stimulus.posX, "stPosY": stimulus.posY, "col":stimulus.col, "row": stimulus.row, "touchX": localtionInView.x, "touchY": localtionInView.y, "touchX1": location.x, "touchY2": location.y, "touchDist":0,"targDist":0,"trialResult":0, "touchN": touchN, "error": error])
//
//}