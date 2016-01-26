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
    
    var gameWon : Bool = false {
        didSet {
            label.text = ( gameWon ? "Game Won!" : "Game Over!" )
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