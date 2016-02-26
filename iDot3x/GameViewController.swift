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
    // This function creates the scene and presents it
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
    //connects the settings button
    @IBOutlet weak var settingsButton: UIButton!
    
    // When setting button is clicked, dismiss the view controller (the scene will be dismissed as well)
    @IBAction func done(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    //hides the statusbar of the ipad
    override func prefersStatusBarHidden() -> Bool
    {
        return true
    }
}