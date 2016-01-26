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
    var propTarg = 1.0/3.0
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
            var imgName = "SadFace"
            if Double(i) < propTarg*Double(nStim){
                imgName = "HappyFace"
            }
            let object = Stimulus(col: col, row: row, imgName: imgName, type: "target", xOffset: xOffset, yOffset: yOffset, colWidth: colWidth, rowHeight: rowHeight, randXFactor: randXFactor, randYFactor: randYFactor)
            object.name = "square"
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

            if let theName = self.nodeAtPoint(location).name {
                print(self.nodeAtPoint(location))
                if theName == "square" {
                    self.removeChildrenInArray([self.nodeAtPoint(location)])
                    //currentNumberOfShips?-=1
                    //score+=1
                    if ++score >= winningNumberOfSquares
                    {
                    //    gameOver(gameComplete: true)
                    }
                }
            }
//            if (gameOver?==true){
//                initializeValues()
//            }
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