//
//  GameScene.swift
//  test
//
//  Created by Andrey Chetverikov on 26/01/16.
//  Copyright (c) 2016 Andrey Chetverikov. All rights reserved.
//

import SpriteKit

class GameScene: SKScene
{
    var objects = [SKSpriteNode]()
    var score = 0
    var scoreLabel = SKLabelNode(text: "Score: 0")
    let losingNumberOfSquares = 5
    let winningNumberOfSquares = 5
    
    override func didMoveToView(view: SKView)
    {
        backgroundColor = SKColor.whiteColor()
        
        scoreLabel.position = CGPointMake(size.width*0.9, size.height*0.9)
        scoreLabel.fontColor = UIColor.blackColor()
        scoreLabel.fontSize = 24
        addChild(scoreLabel)
        
        runAction(SKAction.repeatActionForever( SKAction.sequence([
            SKAction.runBlock(createObject), SKAction.waitForDuration(2.0)]) ))
    }
    
    func createObject()
    {
        //let object = SKSpriteNode( color: UIColor.redColor(), size: CGSizeMake(50, 50) )
        let object = SKSpriteNode(imageNamed: "HappyFace")
        object.name = "square"
        let randomXPosition = CGFloat(drand48()) * size.width
        let randomYPosition = CGFloat(drand48()) * size.height
        object.position = CGPointMake(randomXPosition, randomYPosition)
        object.anchorPoint = CGPointMake(0, 0)
        
        addChild(object)
        objects.append(object)
        
        if objects.count > losingNumberOfSquares
        {
            gameOver(gameComplete: false)
        }
    }
    
    override func update(currentTime: CFTimeInterval)
    {
        if objects.count > 20
        {
            print( "Game Over" )
        }
        
        scoreLabel.text = "Score: \(score)"
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if let theName = self.nodeAtPoint(location).name {
                if theName == "square" {
                    self.removeChildrenInArray([self.nodeAtPoint(location)])
                    //currentNumberOfShips?-=1
                    //score+=1
                    if ++score >= winningNumberOfSquares
                    {
                        gameOver(gameComplete: true)
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