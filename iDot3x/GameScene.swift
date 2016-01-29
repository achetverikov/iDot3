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

class GameScene: SKScene
{
    var objects = [SKSpriteNode]()
    var score = 0
    var scoreLabel = SKLabelNode(text: "Score: 0")
    var numRows = 8
    var numCols = 10
    var gridIndex = 0
    var propTarg = 0.1
    var nStim = 80
    
    
    let losingNumberOfSquares = 5
    let winningNumberOfSquares = 5
    
    
    
    override func didMoveToView(view: SKView)
    {
        
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
        for i in 0..<nStim{
            let col = Double(cells[i]%10)
            let row = floor(Double(cells[i])/10)
            let condition = "b/y"
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
            
            
            //addChild(object)
            print(object)
            //objects.append(object)
        }
        
        runAction(SKAction.repeatActionForever( SKAction.sequence([
            SKAction.runBlock(createObject), SKAction.waitForDuration(2.0)]) ))
    }
    
    func createObject()
    {
        //let object = SKSpriteNode( color: UIColor.redColor(), size: CGSizeMake(50, 50) )
        
        
        
        
        
        
    }
    
    override func update(currentTime: CFTimeInterval)
    {
        
        
        scoreLabel.text = "Score: \(score)"
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let localtionInView:CGPoint =  touch.locationInView(view)
            
            print(localtionInView)
            
            if let node_name = self.nodeAtPoint(location).name {
                if node_name == "stimulus" {
                    let stimulus = self.nodeAtPoint(location) as! Stimulus
                    if (stimulus.stType.rangeOfString("distractor", options: .RegularExpressionSearch) != nil) {
                    
                        gameOver(gameComplete: false)
                    }
                    else {
                        self.removeChildrenInArray([self.nodeAtPoint(location)])
                    }
                }
            }
        }
    }
    
    
    func gameOver(gameComplete gameComplete: Bool)
    {
        if let view = view
        {
            let splashScene = SplashScene(size: view.bounds.size)
            splashScene.gameWon = gameComplete
            view.presentScene(splashScene)
        }
    }
}