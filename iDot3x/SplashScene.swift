//
//  SplashScene.swift
//  test
//
//  Created by Andrey Chetverikov on 26/01/16.
//  Copyright © 2016 Andrey Chetverikov. All rights reserved.
//


import SpriteKit

// búum til þessa breytu til þess að geta tekið tímann fyrir töfina á því að endurræsa leikinn eftir hverja umferð
var timerforlabel = 0.0

class SplashScene: SKScene
{
    //Skilgreinum breyturnar sem í þessu tilviki eru textaboxin og feedback myndirnar
    var splashStartTime = 0.0
    var label = SKLabelNode(text: "Tap to Play")
    var label2 = SKLabelNode (text: "")
    var label3 = SKLabelNode (text: "")
    var label4 = SKLabelNode (text: "Score")
    var label5 = SKLabelNode (text: "Time")
    var win = SKSpriteNode (imageNamed:"HappyFace")
    var lose = SKSpriteNode (imageNamed:"SadFace")
    
    //Hérna köllum við splashscreeninn fram
    override func didMoveToView(view: SKView)
    {
        //litur á bakgrunni
        backgroundColor = SKColor.whiteColor()
        //staðsetning á myndunum
        win.position = CGPointMake(size.width*0.5, size.height*0.8)
        lose.position = CGPointMake(size.width*0.5, size.height*0.8)
        //staðsetning, litur, stærð og köllum fram textaboxin, hvert fyrir sig
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
        //Hér skráum við niður hvað "klukkan" er þegar splashscreenið byrjar, skráum það í breytuna sem við bjuggum til efst
        splashStartTime = CACurrentMediaTime()
    }
    //Hér skilgreinum við þrjú mismunandi viðbrögð eftir því hvernig leikurinn endaði (kláraði, villa, tíminn kláraðist).
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
                print (trialCompleted.value)
            }
               }
    }
    //Hér látum við leikinn byrja eftur ef ýtt er á skjáinn
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: UITouch in touches {
            print(touch.timestamp)
            
        if let view = view
        {
            //það að ýta á skjáinn virkar bara eftir að minnsta kosti einni sekúndu eftir að skjárinn kom fram 
            if CACurrentMediaTime() >= splashStartTime + 1 {
            let gameScene = GameScene(size: view.bounds.size)
                view.presentScene(gameScene)
            }
        }
        }
    }
}