//
//  SplashScene.swift
//  test
//
//  Created by Andrey Chetverikov on 26/01/16.
//  Copyright © 2016 Andrey Chetverikov. All rights reserved.
//


import SpriteKit

// we create this variable so that we can measure the time that we then use for the delay on the activation of the next trial
var timerforlabel = 0.0

class SplashScene: SKScene
{
    //defining variables which are the textboxes and the feedback images
    var splashStartTime = 0.0
    var label = SKLabelNode(text: "Tap to Play")
    var label2 = SKLabelNode (text: "")
    var label3 = SKLabelNode (text: "")
    var label4 = SKLabelNode (text: "Score")
    var label5 = SKLabelNode (text: "Time")
    var win = SKSpriteNode (imageNamed:"HappyFace")
    var lose = SKSpriteNode (imageNamed:"SadFace")
    
    //calling the splash screen
    override func didMoveToView(view: SKView)
    {
        //color of the background
        backgroundColor = SKColor.whiteColor()
        //location of the images
        win.position = CGPointMake(size.width*0.5, size.height*0.8)
        lose.position = CGPointMake(size.width*0.5, size.height*0.8)
        //location, color, size and presenting each text box
        label.position = CGPointMake(size.width*0.5, size.height*0.5)
        label.fontColor = UIColor.blackColor()
        label.fontSize = 42
        addChild(label)
        
        label2.position = CGPointMake(size.width*0.5, size.height*0.4)
        label2.fontColor = UIColor.blackColor()
        label2.fontSize = 42
        addChild(label2)
        
        label3.position = CGPointMake(size.width*0.5, size.height*0.3)
        label3.fontColor = UIColor.blackColor()
        label3.fontSize = 42
        addChild(label3)
        
        label4.position = CGPointMake(size.width*0.4, size.height*0.4)
        label4.fontColor = UIColor.blueColor()
        label4.fontSize = 42
        addChild(label4)
        
        label5.position = CGPointMake(size.width*0.4, size.height*0.3)
        label5.fontColor = UIColor.blueColor()
        label5.fontSize = 42
        addChild(label5)
        //Here we record the current time when the splash screen appears into the variable we created at the top
        splashStartTime = CACurrentMediaTime()
    }
    //Here we define the three different game ending condition (won (found all targets), lost (tapped an distractor), comppleted (time ran out))
    var gameWon : Int = 0 {
        didSet {
            if gameWon==0{
                label.text = "Game Over!"
                label2.text = String (score)
                label3.text = NSString (format: "%.1f", currentTime2) as String
                addChild(lose)
                score = 0
            }
            else if gameWon==1{
                label.text = "Game Won!"
                label2.text = String(score)
                label3.text = NSString (format: "%.1f", timerforlabel) as String
                addChild(win)
                score = 0
                trialCompleted += 1
            }
            else if gameWon==2{
                label.text = "Game Completed!"
                label2.text = String(score)
                label3.text = NSString (format: "%.1f", timerforlabel) as String
                addChild(win)
                score = 0
                trialCompleted += 1
            }
               }
    }
    //Restarting the game/start the next trial by clicking the screen
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: UITouch in touches {
            print(touch.timestamp)
            
        if let view = view
        {
        if trialCompleted < settrial {
            //delay on the screen tapping, so that you cannot tap the screen for one second after the splash screen appears, this is to reduce the likelyhood of accidentally starting a new trial
            if CACurrentMediaTime() >= splashStartTime + 1 {
              
                let gameScene = GameScene(size: view.bounds.size)
                view.presentScene(gameScene)
            }
        }
        }
        }
    }
}