//
//  GameScene.swift
//  test
//
//  Created by Andrey Chetverikov on 26/01/16.
//  Copyright (c) 2016 Andrey Chetverikov. All rights reserved.
//

import SpriteKit

//extension which enables us to randomize where each stimuli ends up in the grid

extension Collection {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Iterator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

//another extension for randomizing the grid - we need them both!
extension MutableCollection where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in startIndex ..< endIndex - 1 {
            let j = Int(arc4random_uniform(UInt32(endIndex - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

//Global variables that we need outside the classes
var highscore = 0
var changescene = 0
var runTest = 0 // measures runLength on the last touch
var behData: [[[String:String]]] = [] // array for behavioural data
var stimData: [[[String:String]]] = [] // array for stimuli data
var trialN = 0 // trial Number
var trialCompleted = 1 // number of trials succsessfully completed
var currentTime2: CFTimeInterval = 0.0 // first timer
var currentTime3: CFTimeInterval = 0.0
var score = 0 // score for feedback
var trialStartTime = 0.0 // time when trial started
var date_identifier = "" // string used for file names
var currentDate = Date() // current date used to create date_identifier
var prevTouch: UITouch? // previousTouch used for calculating distances, etc.
var prevStim: Stimulus? // previous Stimulus info, again for distances etc.
var prevTime: Double? // previous touch time
var dateFormatter = DateFormatter() // for formatting the dates
var dist_threshold  = 22.0 // threshold for touch counting
var write_headers=true // should we add headers to file? we do that on the first trial
var new_game_starting = 0 // if new game is starting we reset stuff
var switches = 2
var repl_distractors = [String]() // for replacement of target with distractors
var repl_target = [String]()
var targets = [String]() // for target types
var distractors = [String]() // for distractor types
var neutral = [String]()
var cells = [Int]() // for positions
var colWidth = 0.0
var rowHeight = 0.0
var xOffset = 0.0
var yOffset = 0.0
var randXFactor = 0.0
var randYFactor = 0.0
var stType = [String]()



class GameScene: SKScene
{
    //Variables only needed withing the game scene
    var objects = [SKSpriteNode]()
    var scoreLabel = SKLabelNode(text: "Stig: 0")
    var trialLabel = SKLabelNode(text: "Umferð: 5")
    var numRows = 8
    var numCols = 10
    var gridIndex = 0
    var propTarg = Double(proportion)/100
    var nStim = setsize
    
    var runN = 1
    var runLength = 1
    var touchN = 0
    
    
    
    //Here we define what is presented on the screen
    override func didMove(to view: SKView)
    {
        // reset the parameters when the game is started anew
        if new_game_starting == 1 {
            behData = []
            stimData = []
            trialN = 0
            trialCompleted = 1
            score = 0
            new_game_starting = 0
        }
        //when the gamescene starts, it checks the time, we do this when we start a new game, if it is the first round, then it uses this time and date for the name on the datafile
        dateFormatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        if date_identifier=="" {
            date_identifier = dateFormatter.string(from: currentDate)
        }
        //Color of the backgroud
        backgroundColor = SKColor.black
        
        //label in the top right corner that we used while programming (with score and time), add child is commented out so that it doesn´t appear on the screen anymore
        scoreLabel.position = CGPoint(x: size.width*0.9, y: size.height*0.9)
        scoreLabel.fontColor = UIColor.blue
        scoreLabel.fontSize = 22
        scoreLabel.fontName = "Helvetica-Bold"
        //addChild(scoreLabel)
        
        //Label in the bottom left that shows participants how many trials they have completed
        trialLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        trialLabel.position = CGPoint(x: size.width*0.055, y: size.height*0.035)
        trialLabel.fontColor = UIColor(red: 0.6, green: 0.0, blue: 1, alpha: 1)
        trialLabel.fontSize = 22
        addChild(trialLabel)
        
        // column width is computed as screen / numCols with one column offset to the left and to the right. same for column height
        colWidth = Double(size.width)/Double(numCols+2)
        rowHeight = Double(size.height)/Double(numRows+2)
        xOffset = colWidth
        yOffset = rowHeight
        
        randXFactor = ceil(colWidth*0.6)
        randYFactor = ceil(rowHeight*0.6)
        
        // to randomize the positions, we randomize values within the range of zero to numRows*numCols-1 (number of cells within grid) and then shuffle them
        cells = [Int](0...(numRows*numCols-1))
        cells.shuffleInPlace()
        
        //we add new arrays to beh and stimData so that we could use them to save the data
        behData.append([])
        stimData.append([])
        
        // translating condition to stimuli types

        switch condition {
        case "r/g":
            targets = ["redDot100S","greenDot100S"]
            distractors = ["blueDot100S", "yellowDot100S"]
            neutral = ["redDot100S","greenDot100S"]
        case "b/y":
            distractors = ["redDot100S","greenDot100S"]
            targets = ["blueDot100S", "yellowDot100S"]
            neutral = ["blueDot100S", "yellowDot100S"]
        case "rs/gd":
            distractors = ["redDot100S","greenSquare100S"]
            targets = ["redSquare100S", "greenDot100S"]
            neutral = ["redSquare100S", "greenDot100S"]
        case "rd/gs":
            targets = ["redDot100S","greenSquare100S"]
            distractors = ["redSquare100S", "greenDot100S"]
            neutral = ["redDot100S","greenSquare100S"]
        case "R/G-n":
            targets = ["redDot100S", "redDot90S", "redDot80S", "redDot70S", "redDot60S", "greenDot100S", "greenDot90S", "greenDot80S", "greenDot70S", "greenDot60S"]
            distractors = ["blueDot100S", "yellowDot100S"]
            neutral = ["redDot100S", "redDot90S", "redDot80S", "redDot70S", "redDot60S", "greenDot100S", "greenDot90S", "greenDot80S", "greenDot70S", "greenDot60S"]
        case "R/G-w":
            targets = ["redDot100S", "redDot80S", "redDot60S", "redDot40S", "redDot20S", "greenDot100S", "greenDot80S", "greenDot60S", "greenDot40S", "greenDot20S"]
            distractors = ["blueDot100S", "yellowDot100S"]
            neutral = ["redDot100S", "redDot80S", "redDot60S", "redDot40S", "redDot20S", "greenDot100S", "greenDot80S", "greenDot60S", "greenDot40S", "greenDot20S"]
        case "B/Y-n":
            targets = ["blueDot100S", "blueDot90S", "blueDot80S", "blueDot70S", "blueDot60S", "yellowDot100S", "yellowDot90S", "yellowDot80S", "yellowDot70S", "yellowDot60S"]
            distractors = ["redDot100S", "greenDot100S"]
            neutral = ["blueDot100S", "blueDot90S", "blueDot80S", "blueDot70S", "blueDot60S", "yellowDot100S", "yellowDot90S", "yellowDot80S", "yellowDot70S", "yellowDot60S"]
        case "B/Y-w":
            targets = ["blueDot100S", "blueDot80S", "blueDot60S", "blueDot40S", "blueDot20S", "yellowDot100S", "yellowDot80S", "yellowDot60S", "yellowDot40S", "yellowDot20S"]
            distractors = ["redDot100S", "greenDot100S"]
            neutral = ["blueDot100S", "blueDot80S", "blueDot60S", "blueDot40S", "blueDot20S", "yellowDot100S", "yellowDot80S", "yellowDot60S", "yellowDot40S", "yellowDot20S"]
        case "RS/GD-n":
            targets = ["redSquare100S", "redSquare90S", "redSquare80S", "redSquare70S", "redSquare60S", "greenDot100S", "greenDot90S", "greenDot80S", "greenDot70S", "greenDot60S"]
            distractors = ["redDot100S", "greenSquare100S"]
            neutral = ["redSquare100S", "redSquare90S", "redSquare80S", "redSquare70S", "redSquare60S", "greenDot100S", "greenDot90S", "greenDot80S", "greenDot70S", "greenDot60S"]
        case "RS/GD-w":
            targets = ["redSquare100S", "redSquare80S", "redSquare60S", "redSquare40S", "redSquare20S", "greenDot100S", "greenDot80S", "greenDot60S", "greenDot40S", "greenDot20S"]
            distractors = ["redDot100S", "greenSquare100S"]
            neutral = ["redSquare100S", "redSquare80S", "redSquare60S", "redSquare40S", "redSquare20S", "greenDot100S", "greenDot80S", "greenDot60S", "greenDot40S", "greenDot20S"]
        case "BS/YD-n":
            targets = ["blueSquare100S", "blueSquare90S", "blueSquare80S", "blueSquare70S", "blueSquare60S", "yellowDot100S", "yellowDot90S", "yellowDot80S", "yellowDot70S", "yellowDot60S"]
            distractors = ["blueDot100S", "yellowSquare100S"]
            neutral = ["blueSquare100S", "blueSquare90S", "blueSquare80S", "blueSquare70S", "blueSquare60S", "yellowDot100S", "yellowDot90S", "yellowDot80S", "yellowDot70S", "yellowDot60S"]
        case "BS/YD-w":
            targets = ["blueSquare100S", "blueSquare80S", "blueSquare60S", "blueSquare40S", "blueSquare20S", "yellowDot100S", "yellowDot80S", "yellowDot60S", "yellowDot40S", "yellowDot20S"]
            distractors = ["blueDot100S", "yellowSquare100S"]
            neutral = ["blueSquare100S", "blueSquare80S", "blueSquare60S", "blueSquare40S", "blueSquare20S", "yellowDot100S", "yellowDot80S", "yellowDot60S", "yellowDot40S", "yellowDot20S"]
        default:
            break
        }
        
        //starting creating stimuli
        for i in 0..<nStim{
            let col = Double(cells[i]%numCols)
            let row = floor(Double(cells[i])/Double(numCols))
            
            //by default the stimuli is a first type target
            var imgName = targets[0]
            var stType = "target1"
           
            if startcondition == 0 || startcondition == 1 || startcondition == 2 || startcondition == 3 {
            
            //if current stimuli index is more than propTarget*nStim, it is a distractor, else it is a target
            if Double(i) >= propTarg*Double(nStim){
                imgName = distractors[0]
                stType = "distractor1"
                
                //half of the distractors have another type
                if Double(i) >= (propTarg+(1-propTarg)/2)*Double(nStim){
                    imgName = distractors[1]
                    stType = "distractor2"
                }
            
            }
            else if Double(i) >= propTarg/2*Double(nStim){
                imgName = targets[1]
                stType = "target2"
             }
              }
            else if startcondition == 4 || startcondition == 5 || startcondition == 6 || startcondition == 7 || startcondition == 8 || startcondition == 9 || startcondition == 10 || startcondition == 11 {
                    if Double(i) >= 4 && Double(i) <= 7 {
                        imgName = targets[1]
                        stType = "target2"
                    }
                    if Double(i) >= 8 && Double(i) <= 11 {
                        imgName = targets[2]
                        stType = "target3"
                    }
                    if Double(i) >= 12 && Double(i) <= 15 {
                        imgName = targets[3]
                        stType = "target4"
                    }
                    if Double(i) >= 16 && Double(i) <= 19 {
                        imgName = targets[4]
                        stType = "target5"
                    }
                    if Double(i) >= 20 && Double(i) <= 23 {
                        imgName = targets[5]
                        stType = "target6"
                    }
                    if Double(i) >= 24 && Double(i) <= 27 {
                        imgName = targets[6]
                        stType = "target7"
                    }
                    if Double(i) >= 28 && Double(i) <= 31 {
                        imgName = targets[7]
                        stType = "target8"
                    }
                    if Double(i) >= 32 && Double(i) <= 35 {
                        imgName = targets[8]
                        stType = "target9"
                    }
                    if Double(i) >= 36 && Double(i) <= 39 {
                        imgName = targets[9]
                        stType = "target10"
                    }
                    if Double(i) >= 40 && Double(i) <= 59 {
                        imgName = distractors[0]
                        stType = "distractor1"
                    }
                    if Double(i) >= 60 && Double(i) <= 79 {
                        imgName = distractors[1]
                        stType = "distractor2"
                    }
            }
            // else if startcondition == 7 {
            //    if Double(i) >= 10 && Double(i) <= 19{
            //        imgName = targets[1]
            //        stType = "target2"
            //         }
            //        //half of the distractors have another type
            //       if Double(i) >= 20 && Double(i) <= 29 {
            //            imgName = targets[2]
            //            stType = "target3"
            //        }
            //        if Double(i) >= 30 && Double(i) <= 39 {
            //            imgName = targets[3]
            //            stType = "target4"
            //        }
            //        if Double(i) >= 40 && Double(i) <= 53 {
            //            imgName = distractors[0]
            //            stType = "distractor1"
            //        }
            //        if Double(i) >= 54 && Double(i) <= 66{
            //            imgName = distractors[1]
            //            stType = "distractor2"
            //        }
            //        if Double(i) >= 67 && Double(i) <= 80 {
            //            imgName = distractors[2]
            //            stType = "distractor3"
            //        }
            //    }
           

            
            //actually creating the stimulus and adding it to the scene
            let object = Stimulus(col: col, row: row, imgName: imgName, stType: stType, xOffset: xOffset, yOffset: yOffset, colWidth: colWidth, rowHeight: rowHeight, randXFactor: randXFactor, randYFactor: randYFactor)
            // this name is later used to filter touches on stimuli
            object.name = "stimulus"
            addChild(object)
            
            //save all info to stimData
            stimData[trialN].append(["participantN":participant, "age":"\(age)", "gender":"\(gender)", "trialN":"\(trialN)", "task":"\(task)", "condition":condition,"FeatConj":"\(FeatConj)", "setSize":"\(setsize)", "proportion":"\(proportion)", "timelimit":"\(timer)", "col": "\(col)", "row":"\(row)", "imgName": imgName, "stType": stType, "posX":"\(object.posX)", "posY":"\(object.posY)"])
            
            
        }
        //for replacement task type we need as many distractors, as there are targets
        let repl_distractors1 = [String](repeating: String("distractor1"), count: Int(Double(nStim)*propTarg/2.0))
        let repl_distractors2 = [String](repeating: String("distractor2"), count: Int(Double(nStim)*propTarg/2.0))
        
        repl_distractors = repl_distractors1 + repl_distractors2
        repl_distractors.shuffleInPlace()
        
        let repl_target1 = [String](repeating: String("neutral1"), count: Int(Double(nStim)*propTarg/2.0))
        let repl_target2 = [String](repeating: String("neutral2"), count: Int(Double(nStim)*propTarg/2.0))
        
        repl_target = repl_target1 + repl_target2
        
        
        //record trial start time
         if task == 0 || task == 1 || task == 2 {
        trialStartTime = CACurrentMediaTime()
         }
        else if task == 3 && currentTime2 == 0
         {
        trialStartTime = CACurrentMediaTime()
        }
    }
    
    //this function runs on each update of the screen
    override func update(_ currentTime: TimeInterval)
    {
        // time since trial start
        currentTime2=round(currentTime - trialStartTime)
        trialLabel.text = "Umferð: \(trialCompleted)"
        scoreLabel.text = "Stig: \(score) Tími: \(currentTime2)"
       
        // if this is a top controller, check timer and if the timelimit is over, end the game
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            if timer>0 && currentTime2 >= timer && topController.isKind(of: GameViewController.self){
                timerforlabel = currentTime2
                gameOver(gameComplete: 2)
                currentTime2 = 0
                
            }
        }
    }
    
    // runs on each touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // time since trial start
        let ts_cac = (CACurrentMediaTime()-trialStartTime)*1000
        var timeRel = 0.0
        var touchDist = 0.0
        var targDist = 0.0
        
        // go through each touches
        for touch: UITouch in touches {
            let location = touch.location(in: self)
            
            // if it is not the first touch, calculate rel. time & distance
            if behData[trialN].count>0{
                timeRel = -(Double(prevTime!)-ts_cac)
                touchDist = sqrt(pow(Double(prevTouch!.location(in: self).x-location.x), 2)+pow(Double(prevTouch!.location(in: self).y-location.y), 2))
            }
            // touch timestamp
            let touchTS = String(format: "%.2f", (touch.timestamp - trialStartTime)*1000)
            
            touchN = touchN+1
            runTest = 0
            var node: SKNode?
            
            // previous distance by default is some nonsense value
            
            var prevDist = 9900000.0
            
            //going through the nodes to find the one we clicked at - trying to find the closest one (but also check the threshold)
            for curNode in self.children{
                if let node_name = curNode.name {
                    if node_name=="stimulus"{
                        let dist = Double(hypotf(Float(location.x-curNode.position.x), Float(location.y-curNode.position.y)))
                        if  dist<dist_threshold{
                            node = curNode
                            
                        }
                        if dist<prevDist{
                            prevDist = dist
                        }
                    }
                }
            }
            
            // if we found a node that is clicked at
            if let node = node {
                let stimulus = node as! Stimulus
                var error = 0
                
                //if stimulus name begins with 'distractor', count an error
                if (stimulus.stType.range(of: "distractor", options: .regularExpression) != nil){
                    error=1
                }
                // if it's not the first stimulus we clicked upon in this trial
                if let ps = prevStim{
                    targDist = sqrt(pow(Double(ps.posX-stimulus.posX), 2)+pow(Double(ps.posY-stimulus.posY), 2))
                    //increase runlength if the stimulus is the same as one before or add runTest var
                    if ps.imgName==stimulus.imgName{
                        runLength+=1
                        switches = 0
                    }
                    else {
                        runN+=1
                        behData[trialN][behData[trialN].count-1]["runTest"] = "\(runLength)"
                        runLength = 1
                        switches = 1
                    }
                }
                
                //save everything
                behData[trialN].append(["participantN":participant, "age":"\(age)", "gender":"\(gender)", "trialN":"\(trialN)", "task":"\(task)", "condition":condition,"FeatConj":"\(FeatConj)", "setSize":"\(setsize)", "proportion":"\(proportion)", "timelimit":"\(timer)", "stType":stimulus.stType, "imgName":stimulus.imgName, "timeTS":"\(ts_cac)", "timeRel":"\(timeRel)","runLength":"\(runLength)", "runTest": "\(runTest)", "touchTS":"\(touchTS)", "runN": "\(runN)", "runNH": "0", "stPosX":"\(stimulus.posX)", "stPosY":"\(stimulus.posY)", "col":"\(stimulus.col)", "row":"\(stimulus.row)","touchX":"\(location.x)", "touchY":"\(location.y)", "touchDist":"\(touchDist)", "targDist": "\(targDist)", "touchN":"\(touchN)", "error":"\(error)", "switches":"\(switches)", "changeScreen":"\(changescene)"])
                
                
                prevTouch=touch
                prevStim=stimulus
                prevTime=ts_cac
                
                // if an error is made, stop the game
                if (stimulus.stType.range(of: "distractor", options: .regularExpression) != nil) {
                    timerforlabel = Double (currentTime2)
                    gameOver(gameComplete: 0)
                }
                else {
                    score += 1
                    if score >= highscore {
                        highscore = score
                        }
                    timerforlabel = Double (currentTime2)
                    
                    
                    if task == 0 || task == 2{
                        // remove the stimulus we clicked at
                        self.removeChildren(in: [node])
                        
                        if task == 2 {
                            var all_distractors = self.children.filter({
                                $0.name=="stimulus" && ($0 as! Stimulus).stType.range(of: "distractor", options: .regularExpression) != nil
                            })
                            let randomIndex = Int(arc4random_uniform(UInt32(all_distractors.count)))
                            let node_to_remove = all_distractors[randomIndex]
                            self.removeChildren(in: [node_to_remove])

                            
                        }
                    }
                    else if task == 1 {
                        
                        // replace target with distractor
                        stimulus.stType = repl_distractors[score-1]
                        var imgName = distractors[0]
                        if repl_distractors[score-1] == "distractor2"{
                            imgName = distractors[1]
                        }
                        
                        stimulus.imgName = imgName
                        stimulus.texture =  SKTexture(imageNamed: imgName)
                    }
                        
                    else if task == 3 {
                        var imgName = neutral[1]
                        
                        if stimulus.stType == "target1" {
                        stimulus.stType = "neutral1"
                        imgName = neutral[0]
                            }
                        else if stimulus.stType == "neutral1"{
                            stimulus.stType = "neutral1"
                            imgName = neutral[0]
                            score = score-1
                        }
                        else if stimulus.stType == "target2"{
                            stimulus.stType = "neutral2"
                            imgName = neutral[1]
                        }
                        else if stimulus.stType == "neutral2"{
                            stimulus.stType = "neutral2"
                            imgName = neutral[1]
                            score = score-1
                        }

                        
                        stimulus.imgName = imgName
                        stimulus.texture =  SKTexture(imageNamed: imgName)
                    }
                    // if there are no more targets, stop the game
                    if task == 0 || task == 1 || task == 2 {
                        if Double(score)==propTarg*Double(nStim){
                        gameOver(gameComplete: 1)
                            }
                    }
                }
                
                
            }
            else {
                // behData saved even when the touch is not on a stimuli
               // behData[trialN].append(["participantN": participant, "age":"\(age)", "gender":"\(gender)", "trialN":"\(trialN)", "task":"\(task)","condition":condition, "FeatConj":"\(FeatConj)", "setSize":"\(setsize)", "proportion":"\(proportion)", "timelimit":"\(timer)", "stType":"", "imgName":"", "timeTS": "\(ts_cac)", "timeRel":"\(timeRel)", "runLength":"", "runTest":"\(runTest)", "touchTS":"\(touchTS)", "runN":"", "runNH": "0", "stPosX":"", "stPosY":"", "col":"", "row":"", "touchX":"\(location.x)", "touchY":"\(location.y)", "touchDist":"\(touchDist)", "targDist":"", "touchN":"\(touchN)", "error":"0", "switches":"\(switches)", "changeScreen":"\(changescene)"])
                
                prevTouch = touch
                prevTime = ts_cac
            }
        }
    }
    
    // saving data functions
    func saveData(){
        
        var contents = ""
        
        // headers - every field we use should be here
        var headers = ["participantN","age","gender", "trialN", "task", "condition", "FeatConj", "setSize", "proportion", "timelimit", "stType", "imgName", "timeTS", "timeRel","runLength", "runTest", "touchTS", "runN", "runNH", "stPosX", "stPosY", "col", "row", "touchX", "touchY", "touchDist","targDist", "touchN", "error", "switches", "changeScreen"]
        
        //write headers on the first trial if it's a new game
        if trialN == 0 && write_headers{
            contents += headers.joined(separator: ",")+",\n"
        }
        
        for i in behData[trialN]{
            for k in headers{
                if let val = i[k]{
                    contents+="\""+String(val)+"\""+","
                } else {
                    contents+="\"\""+","
                }
            }
            contents += "\n"
        }
        
        // save everything
        let documents = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        var path = documents.appendingPathComponent("\(date_identifier).csv").path
        print("\(path)")
        
        if !FileManager.default.fileExists(atPath: documents.appendingPathComponent("iDot3").path) {
            
            do {
                try FileManager.default.createDirectory(atPath: documents.appendingPathComponent("iDot3").path, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription);
            }
        }
        
        if let outputStream = OutputStream(toFileAtPath: path, append: true) {
            outputStream.open()
            outputStream.write(contents)
            
            outputStream.close()
        } else {
            print("Unable to open file")
        }
        
        // save stimuli data
        contents = ""
        headers = ["participantN","age","gender", "trialN", "task", "condition", "FeatConj", "setSize", "proportion", "timelimit", "col", "row", "imgName", "stType", "posX", "posY"]
        
        if trialN == 0 && write_headers{
            contents += headers.joined(separator: ",")+"\n"
            write_headers = false
        }
        for i in stimData[trialN]{
            for k in headers{
                if let val = i[k]{
                    contents+="\""+String(val)+"\""+","
                } else {
                    contents+="\"\""+","
                }
            }
            contents += "\n"
        }
        
        path = documents.appendingPathComponent("\(date_identifier)_stim.csv").path
        print("\(path)")
        
        if !FileManager.default.fileExists(atPath: documents.appendingPathComponent("iDot3").path) {
            
            do {
                try FileManager.default.createDirectory(atPath: documents.appendingPathComponent("iDot3").path, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription);
            }
        }
        
        if let outputStream = OutputStream(toFileAtPath: path, append: true) {
            outputStream.open()
            outputStream.write(contents)
            
            outputStream.close()
        } else {
            print("Unable to open file")
        }
    }
    
    // game is over
    func gameOver(gameComplete: Int)
    {
        //print(behData)
        // add the data on last touch - runLength and total number of runs
        if behData[trialN].count>=1 {
            behData[trialN][behData[trialN].count-1]["runTest"] = "\(runLength)"
            behData[trialN][behData[trialN].count-1]["runNH"] = "\(runN)"
        }
        saveData()
        
        trialN+=1
        runN = 1
        runLength = 1
        touchN = 0
        prevStim = nil
        prevTime = nil
        prevTouch = nil
        switches = 2
        
        if let view = view
        {
            let splashScene = SplashScene(size: view.bounds.size)
            splashScene.gameWon = gameComplete
            view.presentScene(splashScene)
        }
    }
}
