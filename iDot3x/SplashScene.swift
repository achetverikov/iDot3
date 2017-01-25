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
    var label4 = SKLabelNode (text: "Stig")
    var label8 = SKLabelNode (text: "Hæstu stig")
    var label5 = SKLabelNode (text: "Tími")
    var label6 = SKLabelNode (text: "Umferð")
    var label7 = SKLabelNode (text: "")
    var label9 = SKLabelNode (text: "")
    var win = SKSpriteNode (imageNamed:"HappyFace")
    var lose = SKSpriteNode (imageNamed:"SadFace")
    
    //calling the splash screen
    override func didMove(to view: SKView)
    {
        //color of the background
        backgroundColor = SKColor.white
        //location of the images
        win.position = CGPoint(x: size.width*0.5, y: size.height*0.8)
        lose.position = CGPoint(x: size.width*0.5, y: size.height*0.8)
        //location, color, size and presenting each text box
        label.position = CGPoint(x: size.width*0.5, y: size.height*0.51)
        label.fontColor = UIColor.black
        label.fontSize = 42
        addChild(label)
        
        label2.position = CGPoint(x: size.width*0.5, y: size.height*0.43)
        label2.fontColor = UIColor.black
        label2.fontSize = 42
        addChild(label2)
        
        label3.position = CGPoint(x: size.width*0.5, y: size.height*0.27)
        label3.fontColor = UIColor.black
        label3.fontSize = 42
        addChild(label3)
        
        label4.position = CGPoint(x: size.width*0.4, y: size.height*0.43)
        label4.fontColor = UIColor.blue
        label4.fontSize = 42
        addChild(label4)
        
        label8.position = CGPoint(x: size.width*0.345, y: size.height*0.35)
        label8.fontColor = UIColor.blue
        label8.fontSize = 42
        addChild(label8)
        
        label5.position = CGPoint(x: size.width*0.4, y: size.height*0.27)
        label5.fontColor = UIColor.blue
        label5.fontSize = 42
        addChild(label5)
        
        label6.position = CGPoint(x: size.width*0.377, y: size.height*0.19)
        label6.fontColor = UIColor.blue
        label6.fontSize = 42
        addChild(label6)
        
        label7.position = CGPoint(x: size.width*0.5, y: size.height*0.19)
        label7.fontColor = UIColor.black
        label7.fontSize = 42
        addChild(label7)
        
        label9.position = CGPoint(x: size.width*0.5, y: size.height*0.35)
        label9.fontColor = UIColor.black
        label9.fontSize = 42
        addChild(label9)
        
        //Here we record the current time when the splash screen appears into the variable we created at the top
        splashStartTime = CACurrentMediaTime()
    }
    //Here we define the three different game ending condition (won (found all targets), lost (tapped an distractor), comppleted (time ran out))
    var gameWon : Int = 0 {
        didSet {
            if gameWon==0{
                label.text = "Umferð lokið!"
                label2.text = String (score)
                label3.text = NSString (format: "%.1f", currentTime2) as String
                label7.text = String (String(trialCompleted) + "/" + String(settrial))
                label9.text = String (highscore) 
                addChild(lose)
                score = 0
                currentTime2 = 0
                changescene = 0
            }
            else if gameWon==1{
                label.text = "Game Won!"
                label2.text = String(score)
                label3.text = NSString (format: "%.1f", timerforlabel) as String
                label7.text = String (String(trialCompleted) + "/" + String(settrial))
                label9.text = String (highscore) 
                addChild(win)
                score = 0
                trialCompleted += 1
                changescene = 0
            }
            else if gameWon==2{
                label.text = "Umferð lokið!"
                label2.text = String(score)
                label3.text = NSString (format: "%.1f", timerforlabel) as String
                label7.text = String (String(trialCompleted) + "/" + String(settrial))
                label9.text = String (highscore)
                addChild(win)
                score = 0
                trialCompleted += 1
                changescene = 0 
            }
               }
    }
    //Restarting the game/start the next trial by clicking the screen
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: UITouch in touches {
            print(touch.timestamp)
            
        if let view = view
        {
        if trialCompleted <= settrial {
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
