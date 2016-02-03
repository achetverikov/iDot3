//
//  GameScene.swift
//  test
//
//  Created by Andrey Chetverikov on 26/01/16.
//  Copyright (c) 2016 Andrey Chetverikov. All rights reserved.
//

import SpriteKit

extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

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

var behData: [[[String:Any]]] = []
var stimData: [[[String:Any]]] = []
var trialN = 0


var trialStartTime = 0.0
var date_identifier = ""
let currentDate = NSDate()
var prevTouch: UITouch?
var prevStim: Stimulus?
var prevTime: Double?

class GameScene: SKScene
{
    var objects = [SKSpriteNode]()
    var score = 0
    var scoreLabel = SKLabelNode(text: "Score: 0")
    var numRows = 8
    var numCols = 10
    var gridIndex = 0
    var propTarg = Double(proportion)/100
    var nStim = setsize
    var dateFormatter = NSDateFormatter()
    let losingNumberOfSquares = 5
    let winningNumberOfSquares = 5
    
    var runN = 1
    var runLength = 1
    var touchN = 0
    
    override func didMoveToView(view: SKView)
    {

        
        dateFormatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        date_identifier = dateFormatter.stringFromDate(currentDate)
        
        backgroundColor = SKColor.whiteColor()
        
        scoreLabel.position = CGPointMake(size.width*0.9, size.height*0.9)
        scoreLabel.fontColor = UIColor.blackColor()
        scoreLabel.fontSize = 24
        addChild(scoreLabel)
        
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
            case "rs/gt":
                distractors = ["redTriangle","greenSquare"]
                targets = ["redSquare", "greenTriangle"]
            case "rt/gs":
                targets = ["redTriangle","greenSquare"]
                distractors = ["redSquare", "greenTriangle"]
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
            stimData[trialN].append(["col": col, "row": row, "imgName": imgName, "stType": stType, "posX":object.posX, "posY":object.posY])
            
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
        
        scoreLabel.text = "Score: \(score)"
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
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
            
            if let node_name = self.nodeAtPoint(location).name {
                if node_name == "stimulus" {
                    let stimulus = self.nodeAtPoint(location) as! Stimulus
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
                            runLength = 1
                        }
                    }
                    behData[trialN].append(["participantN":"", "trialN":trialN, "condition":condition, "setSize":setsize, "proportion":proportion, "timelimit":0, "stType":stimulus.stType, "imgName":stimulus.imgName, "timeTS": ts_cac, "timeRel": timeRel,"runLength": runLength, "touchTS":touchTS,  "runN":runN, "stPosX":stimulus.posX, "stPosY": stimulus.posY, "col":stimulus.col, "row": stimulus.row,"touchX": location.x, "touchY": location.y, "touchDist": touchDist, "targDist": targDist, "touchN": touchN, "error": error])
                    
                    if (stimulus.stType.rangeOfString("distractor", options: .RegularExpressionSearch) != nil) {
                        
                        gameOver(gameComplete: false)
                    }
                    else {
                        score += 1
                        self.removeChildrenInArray([self.nodeAtPoint(location)])
                        if Double(score)==propTarg*Double(nStim){
                            gameOver(gameComplete: true)
                        }
                        
                    }
                    
                    prevTouch=touch
                    prevStim=stimulus
                    prevTime=ts_cac
                    
                }
            }
            else {
                behData[trialN].append(["participantN":"", "trialN":trialN, "condition":condition, "setSize":setsize, "proportion":proportion, "timelimit":0, "stType":"", "imgName":"", "timeTS": ts_cac, "timeRel": timeRel, "runLength":"", "touchTS": touchTS, "runN":"", "stPosX":"", "stPosY":"", "col":"", "row":"", "touchX": location.x, "touchY": location.y, "touchDist":touchDist , "targDist":"", "touchN": touchN, "error": 0])
                
                prevTouch = touch
                prevTime = ts_cac
            }
        }
    }
    
    func saveData(){
        
        var contents = ""
        let headers = ["participantN", "trialN", "condition", "setSize", "proportion", "timelimit", "stType", "imgName", "timeTS", "timeRel","runLength","touchTS", "runN", "stPosX", "stPosY", "col", "row", "touchX", "touchY", "touchDist","targDist", "touchN", "error"]
        
        if trialN == 0{
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
        let path = documents.URLByAppendingPathComponent("iDot3/\(date_identifier).csv").path!
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
    
    func gameOver(gameComplete gameComplete: Bool)
    {
        //print(behData)
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