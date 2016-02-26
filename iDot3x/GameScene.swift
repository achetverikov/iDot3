//
//  GameScene.swift
//  test
//
//  Created by Andrey Chetverikov on 26/01/16.
//  Copyright (c) 2016 Andrey Chetverikov. All rights reserved.
//

import SpriteKit

//extension sem gerir okkur mögulegt að randomiza hvar hver litur lendir í gridinu

extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

//Annað extension sem
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
//Global breytur sem við þurfum að halda fyrir utan class
var runTest = 0
var behData: [[[String:String]]] = []
var stimData: [[[String:String]]] = []
var trialN = 0
var trialCompleted = 0
var currentTime2: CFTimeInterval = 0.0
var score = 0
var trialStartTime = 0.0
var date_identifier = ""
var currentDate = NSDate()
var prevTouch: UITouch?
var prevStim: Stimulus?
var prevTime: Double?
var dateFormatter = NSDateFormatter()
var dist_threshold  = 20.0
var write_headers=true
var new_game_starting = 0

class GameScene: SKScene
{
    //Breytur sem við notum bara inn í gamescene-inu
    var objects = [SKSpriteNode]()
    var scoreLabel = SKLabelNode(text: "Score: 0")
    var trialLabel = SKLabelNode(text: "Trial: 5")
    var numRows = 8
    var numCols = 10
    var gridIndex = 0
    var propTarg = Double(proportion)/100
    var nStim = setsize
    let losingNumberOfSquares = 5
    let winningNumberOfSquares = 5
    
    var runN = 1
    var runLength = 1
    var touchN = 0
    
    override func didMoveToView(view: SKView)
    {
        if new_game_starting == 1 {
        behData = []
        stimData = []
        trialN = 0
        trialCompleted = 0
        score = 0
        new_game_starting = 0
        }
        //þegar leikskjárinn kemur fram tékkar hún á klukkunni, við gerum þetta þegar við hefjum nýjan leik, en ef þetta er fyrsti leikurinn þá notar hún dagsetninguna og klukkuna til að búa til nýtt gagnaskjal
        dateFormatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        if date_identifier=="" {
            date_identifier = dateFormatter.stringFromDate(currentDate)
        }
        //Litur á bakgrunninum
        backgroundColor = SKColor.blackColor()
        
        //label upp í hægra horni sem við notuðum á meðan á forritun stóð, add child er commentað út og þessvegna kemur hann ekki á skjáinn
        scoreLabel.position = CGPointMake(size.width*0.9, size.height*0.9)
        scoreLabel.fontColor = UIColor.blueColor()
        scoreLabel.fontSize = 24
        //addChild(scoreLabel)
        
        //Label í vinstra horni sem sýnir þátttakenda hvað hann er búinn með mörg trials
        trialLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
        trialLabel.position = CGPointMake(size.width*0.055, size.height*0.035)
        trialLabel.fontColor = UIColor(red: 0.6, green: 0.0, blue: 1, alpha: 1)
        trialLabel.fontSize = 22
        addChild(trialLabel)
        
        let colWidth = Double(size.width)/Double(numCols+2)
        let rowHeight = Double(size.height)/Double(numRows+2)
        let xOffset = colWidth
        let yOffset = rowHeight
        
        let randXFactor = ceil(colWidth*0.6)
        let randYFactor = ceil(rowHeight*0.6)
        
        var cells = [Int](0...(numRows*numCols-1))
        cells.shuffleInPlace()
        behData.append([])
        stimData.append([])
        for i in 0..<nStim{
            let col = Double(cells[i]%10)
            let row = floor(Double(cells[i])/10)
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
            //print(condition)
            
            var imgName = targets[0]
            var stType = "target1"
            
            if Double(i) >= propTarg*Double(nStim){
                imgName = distractors[0]
                stType = "distractor1"
                if Double(i) >= (propTarg+(1-propTarg)/2)*Double(nStim){
                    imgName = distractors[1]
                    stType = "distractor2"
                }
            }
            else if Double(i) >= propTarg/2*Double(nStim){
                imgName = targets[1]
                stType = "target2"
            }
            let object = Stimulus(col: col, row: row, imgName: imgName, stType: stType, xOffset: xOffset, yOffset: yOffset, colWidth: colWidth, rowHeight: rowHeight, randXFactor: randXFactor, randYFactor: randYFactor)
            object.name = "stimulus"
            addChild(object)
            stimData[trialN].append(["participantN":participant, "age":"\(age)", "gender":"\(gender)", "trialN":"\(trialN)", "condition":condition,"FeatConj":"\(FeatConj)", "setSize":"\(setsize)", "proportion":"\(proportion)", "timelimit":"\(timer)", "col": "\(col)", "row":"\(row)", "imgName": imgName, "stType": stType, "posX":"\(object.posX)", "posY":"\(object.posY)"])
            
            //addChild(object)
            //print(object)
            //objects.append(object)
        }
        //runAction(SKAction.repeatActionForever( SKAction.sequence([
        //    SKAction.runBlock(createObject), SKAction.waitForDuration(2.0)]) ))
        trialStartTime = CACurrentMediaTime()
    }
    
    override func update(currentTime: CFTimeInterval)
    {
        currentTime2=currentTime - trialStartTime
        trialLabel.text = "Trial: \(trialCompleted)"
        scoreLabel.text = "Score: \(score) Time: \(currentTime2)"
        if var topController = UIApplication.sharedApplication().keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            //print(topController.isKindOfClass(GameViewController))
            if timer>0 && currentTime2 >= timer && topController.isKindOfClass(GameViewController){
                timerforlabel = currentTime2
                gameOver(gameComplete: 2)
                
            }
            // topController should now be your topmost view controller
        }
        
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let ts_cac = (CACurrentMediaTime()-trialStartTime)*1000
        var timeRel = 0.0
        var touchDist = 0.0
        var targDist = 0.0
        for touch: UITouch in touches {
            let location = touch.locationInNode(self)
            
            if behData[trialN].count>0{
                timeRel = -(Double(prevTime!)-ts_cac)
                touchDist = sqrt(pow(Double(prevTouch!.locationInNode(self).x-location.x), 2)+pow(Double(prevTouch!.locationInNode(self).y-location.y), 2))
            }
            let touchTS = String(format: "%.2f", (touch.timestamp - trialStartTime)*1000)
            //print(localtionInView)
            touchN = touchN+1
            runTest = 0
            var node: SKNode?
            var prevDist = 9900000.0
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
            if let node = node {
                let stimulus = node as! Stimulus
                var error = 0
                if (stimulus.stType.rangeOfString("distractor", options: .RegularExpressionSearch) != nil){
                    error=1
                }
                if let ps = prevStim{
                    targDist = sqrt(pow(Double(ps.posX-stimulus.posX), 2)+pow(Double(ps.posY-stimulus.posY), 2))
                    if ps.imgName==stimulus.imgName{
                        runLength+=1
                    }
                    else {
                        runN+=1
                        behData[trialN][behData[trialN].count-1]["runTest"] = "\(runLength)"
                        runLength = 1
                    }
                }
                behData[trialN].append(["participantN":participant, "age":"\(age)", "gender":"\(gender)", "trialN":"\(trialN)", "condition":condition,"FeatConj":"\(FeatConj)", "setSize":"\(setsize)", "proportion":"\(proportion)", "timelimit":"\(timer)", "stType":stimulus.stType, "imgName":stimulus.imgName, "timeTS":"\(ts_cac)", "timeRel":"\(timeRel)","runLength":"\(runLength)", "runTest": "\(runTest)", "touchTS":"\(touchTS)", "runN": "\(runN)", "runNH": "0", "stPosX":"\(stimulus.posX)", "stPosY":"\(stimulus.posY)", "col":"\(stimulus.col)", "row":"\(stimulus.row)","touchX":"\(location.x)", "touchY":"\(location.y)", "touchDist":"\(touchDist)", "targDist": "\(targDist)", "touchN":"\(touchN)", "error":"\(error)"])
                
                
                prevTouch=touch
                prevStim=stimulus
                prevTime=ts_cac
                
                if (stimulus.stType.rangeOfString("distractor", options: .RegularExpressionSearch) != nil) {
                    timerforlabel = Double (currentTime2)
                    gameOver(gameComplete: 0)
                }
                    
                else {
                    score += 1
                    timerforlabel = Double (currentTime2)
                    self.removeChildrenInArray([node])
                    if Double(score)==propTarg*Double(nStim){
                        gameOver(gameComplete: 1)
                    }
                }
                
                
            }
                
            else {
                behData[trialN].append(["participantN": participant, "age":"\(age)", "gender":"\(gender)", "trialN":"\(trialN)", "condition":condition, "FeatConj":"\(FeatConj)", "setSize":"\(setsize)", "proportion":"\(proportion)", "timelimit":"\(timer)", "stType":"", "imgName":"", "timeTS": "\(ts_cac)", "timeRel":"\(timeRel)", "runLength":"", "runTest":"\(runTest)", "touchTS":"\(touchTS)", "runN":"", "runNH": "0", "stPosX":"", "stPosY":"", "col":"", "row":"", "touchX":"\(location.x)", "touchY":"\(location.y)", "touchDist":"\(touchDist)", "targDist":"", "touchN":"\(touchN)", "error":"0"])
                
                prevTouch = touch
                prevTime = ts_cac
            }
        }
    }
    
    func saveData(){
        
        var contents = ""
        var headers = ["participantN","age","gender", "trialN", "condition", "FeatConj", "setSize", "proportion", "timelimit", "stType", "imgName", "timeTS", "timeRel","runLength", "runTest", "touchTS", "runN", "runNH", "stPosX", "stPosY", "col", "row", "touchX", "touchY", "touchDist","targDist", "touchN", "error"]
        
        if trialN == 0 && write_headers{
            contents += headers.joinWithSeparator(",")+"\n"
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
    
    func gameOver(gameComplete gameComplete: Int)
    {
        //print(behData)
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