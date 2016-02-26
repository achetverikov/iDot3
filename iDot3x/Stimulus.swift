//
//  Stimulus.swift
//  iDot3x
//
//  Created by Andrey Chetverikov on 26/01/16.
//  Copyright © 2016 Andrey Chetverikov. All rights reserved.
//

import SpriteKit

// This is a class for stimulus based on SKSpriteNode
// parameters: col, row - column, row in grid
// posX, posY - position, pixels
// stType - target or distractor (can be different types, like target1 or target2)
// imgName - filename
class Stimulus: SKSpriteNode {
    var col: Double
    var row: Double
    var posX, posY: CGFloat
    var stType: String
    var imgName: String
    
    //the function that intitializes the stimulus by creating a texture for it and computing the position
    init(col: Double, row: Double, imgName:String, stType: String, xOffset:Double, yOffset: Double, colWidth: Double, rowHeight: Double, randXFactor: Double, randYFactor: Double ) {
        let texture = SKTexture(imageNamed: imgName)
        self.col = col
        self.row = row

        // Here we do the jittering so that stimuli do not appear in straight lines
        // the jitter is calculated as "x/2 - drand48()*x" where x is the jitter maximal amount and drand48 return random value from 0 to 1
        
        self.posX = CGFloat(xOffset+((col+0.5)*colWidth)+(randXFactor/2)-(drand48() * randXFactor))
        self.posY = CGFloat(yOffset+((row+0.5)*rowHeight)+(randYFactor/2)-(drand48() * randYFactor))
        self.stType = stType
        self.imgName = imgName
        
        //Here we put in the size of the stimulus and pass everything to SKSpriteNode class initializer
        super.init(texture: texture, color: UIColor.clearColor(), size: CGSizeMake(30, 30))
        
//        print("pos: \(CGFloat(posX), \(CGFloat(posY))")
        
        self.position = CGPointMake(posX, posY)
        self.anchorPoint = CGPointMake(0.5, 0.5)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // this is only for printing to console
    override var description: String {
        return "type:\(stType) square:(\(col),\(row)), pos:(\(posX),\(posY))"
    }


}

