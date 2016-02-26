//
//  GameViewController.swift
//  test
//
//  Created by Andrey Chetverikov on 26/01/16.
//  Copyright (c) 2016 Andrey Chetverikov. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController
{
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //let scene = GameScene(size: view.bounds.size)
        let scene = GameScene(size: view.bounds.size)

        let skView = view as! SKView
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill
        scene.size = skView.bounds.size
        skView.presentScene(scene)
    }

    @IBOutlet weak var settingsButton: UIButton!
    
    @IBAction func done(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool
    {
        return true
    }
}