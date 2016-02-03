//
//  SplashScene.swift
//  test
//
//  Created by Andrey Chetverikov on 26/01/16.
//  Copyright © 2016 Andrey Chetverikov. All rights reserved.
//


import SpriteKit

class SplashScene: SKScene
{
    var label = SKLabelNode(text: "Tap to Play")
    
    override func didMoveToView(view: SKView)
    {
        backgroundColor = SKColor.whiteColor()
        
        label.position = CGPointMake(size.width*0.5, size.height*0.5)
        label.fontColor = UIColor.blackColor()
        label.fontSize = 42
        addChild(label)
    }
    
    var gameWon : Int = 0 {
        didSet {
            if gameWon==0{
                label.text = "Game Over!"
            }
            else if gameWon==1{
                label.text = "Game Won!"
            }
            else if gameWon==2{
                label.text = "Game Completed!"
            }
               }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let view = view
        {
            let gameScene = GameScene(size: view.bounds.size)
            view.presentScene(gameScene)
        }
    }
}