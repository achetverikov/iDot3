//
//  GameScene.swift
//  test
//
//  Created by Andrey Chetverikov on 26/01/16.
//  Copyright (c) 2016 Andrey Chetverikov. All rights reserved.
//

import SpriteKit

//extension which enables us to randomize where each stimuli ends up in the grid

extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

//another extension for randomizing the grid - we need them both!
extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

//Global variables that we need outside the classes
var runTest = 0 // measures runLength on the last touch
var behData: [[[String:String]]] = [] // array for behavioural data
var stimData: [[[String:String]]] = [] // array for stimuli data
var trialN = 0 // trial Number
var trialCompleted = 0 // number of trials succsessfully completed
var currentTime2: CFTimeInterval = 0.0 // first timer
var score = 0 // score for feedback
var trialStartTime = 0.0 // time when trial started
var date_identifier = "" // string used for file names
var currentDate = NSDate() // current date used to create date_identifier
var prevTouch: UITouch? // previousTouch used for calculating distances, etc.
var prevStim: Stimulus? // previous Stimulus info, again for distances etc.
var prevTime: Double? // previous touch time
var dateFormatter = NSDateFormatter() // for formatting the dates
var dist_threshold  = 20.0 // threshold for touch counting
var write_headers=true // should we add headers to file? we do that on the first trial
var new_game_starting = 0 // if new game is starting we reset stuff

class GameScene: SKScene
{
    //Variables only needed withing the game scene
    var objects = [SKSpriteNode]()
    var scoreLabel = SKLabelNode(text: "Score: 0")
    var trialLabel = SKLabelNode(text: "Trial: 5")
    var numRows = 8
    var numCols = 10
    var gridIndex = 0
    var propTarg = Double(proportion)/100
    var nStim = setsize
    
    var runN = 1
    var runLength = 1
    var touchN = 0
    
    
    //Here we define what is presented on the screen
    override func didMoveToView(view: SKView)
    {
        // reset the parameters when the game is started anew
        if new_game_starting == 1 {
            behData = []
            stimData = []
            trialN = 0
            trialCompleted = 0
            score = 0
            new_game_starting = 0
        }
        //when the gamescene starts, it checks the time, we do this when we start a new game, if it is the first round, then it uses this time and date for the name on the datafile
        dateFormatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        if date_identifier=="" {
            date_identifier = dateFormatter.stringFromDate(currentDate)
        }
        //Color of the backgroud
        backgroundColor = SKColor.blackColor()
        
        //label in the top right corner that we used while programming (with score and time), add child is commented out so that it doesn´t appear on the screen anymore
        scoreLabel.position = CGPointMake(size.width*0.9, size.height*0.9)
        scoreLabel.fontColor = UIColor.blueColor()
        scoreLabel.fontSize = 24
        //addChild(scoreLabel)
        
        //Label in the bottom left that shows participants how many trials they have completed
        trialLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        trialLabel.position = CGPointMake(size.width*0.055, size.height*0.035)
        trialLabel.fontColor = UIColor(red: 0.6, green: 0.0, blue: 1, alpha: 1)
        trialLabel.fontSize = 22
        addChild(trialLabel)
        
        //
        let colWidth = Double(size.width)/Double(numCols+2)
        let rowHeight = Double(size.height)/Double(numRows+2)
        let xOffset = colWidth
        let yOffset = rowHeight
        
        let randXFactor = ceil(colWidth*0.6)
        let randYFactor = ceil(rowHeight*0.6)
        
        // to randomize the positions, we randomize values within the range of zero to numRows*numCols-1 (number of cells within grid) and then shuffle them
        var cells = [Int](0...(numRows*numCols-1))
        cells.shuffleInPlace()
        
        //we add new arrays to beh and stimData so that we could use them to save the data
        behData.append([])
        stimData.append([])
        
        // translating condition to stimuli types
        var targets = [String]()
        var distractors = [String]()
        switch condition {
        case "r/g":
            targets = ["redDot","greenDot"]
            distractors = ["blueDot", "yellowDot"]
        case "b/y":
            distractors = ["redDot","greenDot"]
            targets = ["blueDot", "yellowDot"]
        case "rs/gd":
            distractors = ["redDot","greenSquare"]
            targets = ["redSquare", "greenDot"]
        case "rd/gs":
            targets = ["redDot","greenSquare"]
            distractors = ["redSquare", "greenDot"]
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
            
            //actually creating the stimulus and adding it to the scene
            let object = Stimulus(col: col, row: row, imgName: imgName, stType: stType, xOffset: xOffset, yOffset: yOffset, colWidth: colWidth, rowHeight: rowHeight, randXFactor: randXFactor, randYFactor: randYFactor)
            // this name is later used to filter touches on stimuli
            object.name = "stimulus"
            addChild(object)
            
            //save all info to stimData
            stimData[trialN].append(["participantN":participant, "age":"\(age)", "gender":"\(gender)", "trialN":"\(trialN)", "condition":condition,"FeatConj":"\(FeatConj)", "setSize":"\(setsize)", "proportion":"\(proportion)", "timelimit":"\(timer)", "col": "\(col)", "row":"\(row)", "imgName": imgName, "stType": stType, "posX":"\(object.posX)", "posY":"\(object.posY)"])
            
            
        }
        //record trial start time
        trialStartTime = CACurrentMediaTime()
    }
    
    //this function runs on each update of the screen
    override func update(currentTime: CFTimeInterval)
    {
        // time since trial start
        currentTime2=currentTime - trialStartTime
        trialLabel.text = "Trial: \(trialCompleted)"
        scoreLabel.text = "Score: \(score) Time: \(currentTime2)"
        
        // if this is a top controller, check timer and if the timelimit is over, end the game
        if var topController = UIApplication.sharedApplication().keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            if timer>0 && currentTime2 >= timer && topController.isKindOfClass(GameViewController){
                timerforlabel = currentTime2
                gameOver(gameComplete: 2)
                
            }
        }
    }
    
    // runs on each touch
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // time since trial start
        let ts_cac = (CACurrentMediaTime()-trialStartTime)*1000
        var timeRel = 0.0
        var touchDist = 0.0
        var targDist = 0.0
        
        // go through each touches
        for touch: UITouch in touches {
            let location = touch.locationInNode(self)
            
            // if it is not the first touch, calculate rel. time & distance
            if behData[trialN].count>0{
                timeRel = -(Double(prevTime!)-ts_cac)
                touchDist = sqrt(pow(Double(prevTouch!.locationInNode(self).x-location.x), 2)+pow(Double(prevTouch!.locationInNode(self).y-location.y), 2))
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
                if (stimulus.stType.rangeOfString("distractor", options: .RegularExpressionSearch) != nil){
                    error=1
                }
                // if it's not the first stimulus we clicked upon in this trial
                if let ps = prevStim{
                    targDist = sqrt(pow(Double(ps.posX-stimulus.posX), 2)+pow(Double(ps.posY-stimulus.posY), 2))
                    //increase runlength if the stimulus is the same as one before or add runTest var
                    if ps.imgName==stimulus.imgName{
                        runLength+=1
                    }
                    else {
                        runN+=1
                        behData[trialN][behData[trialN].count-1]["runTest"] = "\(runLength)"
                        runLength = 1
                    }
                }
                
                //save everything
                behData[trialN].append(["participantN":participant, "age":"\(age)", "gender":"\(gender)", "trialN":"\(trialN)", "condition":condition,"FeatConj":"\(FeatConj)", "setSize":"\(setsize)", "proportion":"\(proportion)", "timelimit":"\(timer)", "stType":stimulus.stType, "imgName":stimulus.imgName, "timeTS":"\(ts_cac)", "timeRel":"\(timeRel)","runLength":"\(runLength)", "runTest": "\(runTest)", "touchTS":"\(touchTS)", "runN": "\(runN)", "runNH": "0", "stPosX":"\(stimulus.posX)", "stPosY":"\(stimulus.posY)", "col":"\(stimulus.col)", "row":"\(stimulus.row)","touchX":"\(location.x)", "touchY":"\(location.y)", "touchDist":"\(touchDist)", "targDist": "\(targDist)", "touchN":"\(touchN)", "error":"\(error)"])
                
                
                prevTouch=touch
                prevStim=stimulus
                prevTime=ts_cac
                
                // if an error is made, stop the game
                if (stimulus.stType.rangeOfString("distractor", options: .RegularExpressionSearch) != nil) {
                    timerforlabel = Double (currentTime2)
                    gameOver(gameComplete: 0)
                }
                else {
                    score += 1
                    timerforlabel = Double (currentTime2)
                    
                    // remove the stimulus we clicked at
                    self.removeChildrenInArray([node])
                    
                    // if there are no more targets, stop the game
                    if Double(score)==propTarg*Double(nStim){
                        gameOver(gameComplete: 1)
                    }
                }
                
                
            }
            else {
                // behData saved even when the touch is not on a stimuli
                behData[trialN].append(["participantN": participant, "age":"\(age)", "gender":"\(gender)", "trialN":"\(trialN)", "condition":condition, "FeatConj":"\(FeatConj)", "setSize":"\(setsize)", "proportion":"\(proportion)", "timelimit":"\(timer)", "stType":"", "imgName":"", "timeTS": "\(ts_cac)", "timeRel":"\(timeRel)", "runLength":"", "runTest":"\(runTest)", "touchTS":"\(touchTS)", "runN":"", "runNH": "0", "stPosX":"", "stPosY":"", "col":"", "row":"", "touchX":"\(location.x)", "touchY":"\(location.y)", "touchDist":"\(touchDist)", "targDist":"", "touchN":"\(touchN)", "error":"0"])
                
                prevTouch = touch
                prevTime = ts_cac
            }
        }
    }
    
    // saving data functions
    func saveData(){
        
        var contents = ""
        
        // headers - every field we use should be here
        var headers = ["participantN","age","gender", "trialN", "condition", "FeatConj", "setSize", "proportion", "timelimit", "stType", "imgName", "timeTS", "timeRel","runLength", "runTest", "touchTS", "runN", "runNH", "stPosX", "stPosY", "col", "row", "touchX", "touchY", "touchDist","targDist", "touchN", "error"]
        
        //write headers on the first trial if it's a new game
        if trialN == 0 && write_headers{
            contents += headers.joinWithSeparator(",")+",\n"
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
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        var path = documents.URLByAppendingPathComponent("\(date_identifier).csv").path!
        print("\(path)")
        
        if !NSFileManager.defaultManager().fileExistsAtPath(documents.URLByAppendingPathComponent("iDot3").path!) {
            
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(documents.URLByAppendingPathComponent("iDot3").path!, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription);
            }
        }
        
        if let outputStream = NSOutputStream(toFileAtPath: path, append: true) {
            outputStream.open()
            outputStream.write(contents)
            
            outputStream.close()
        } else {
            print("Unable to open file")
        }
        
        // save stimuli data
        contents = ""
        headers = ["participantN","age","gender", "trialN", "condition", "FeatConj", "setSize", "proportion", "timelimit", "col", "row", "imgName", "stType", "posX", "posY"]
        
        if trialN == 0 && write_headers{
            contents += headers.joinWithSeparator(",")+"\n"
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
        
        path = documents.URLByAppendingPathComponent("\(date_identifier)_stim.csv").path!
        print("\(path)")
        
        if !NSFileManager.defaultManager().fileExistsAtPath(documents.URLByAppendingPathComponent("iDot3").path!) {
            
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(documents.URLByAppendingPathComponent("iDot3").path!, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription);
            }
        }
        
        if let outputStream = NSOutputStream(toFileAtPath: path, append: true) {
            outputStream.open()
            outputStream.write(contents)
            
            outputStream.close()
        } else {
            print("Unable to open file")
        }
    }
    
    // game is over
    func gameOver(gameComplete gameComplete: Int)
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
        
        if let view = view
        {
            let splashScene = SplashScene(size: view.bounds.size)
            splashScene.gameWon = gameComplete
            view.presentScene(splashScene)
        }
    }
}