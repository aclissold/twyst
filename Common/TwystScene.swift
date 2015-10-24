//
//  TwystScene.swift
//  Twyst
//
//  Created by Andrew Clissold on 9/12/15.
//  Copyright (c) 2015 Andrew Clissold. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import AudioToolbox

class TwystScene: SKScene {

    let vibratoMultiplier: CGFloat = 6
    let octaveMultiplier = CGFloat(pow(pow(2.0, 1.0/12.0), 12.0))

    var eventDate = NSDate()
    var updateDelay = 0.0

    var screenWidth: CGFloat = 0,
        screenHeight: CGFloat = 0

    var upAnOctave = false

    let noteLabelNode = SKLabelNode(fontNamed: "Avenir-Light")
    let wordmarkNode = SKSpriteNode(imageNamed: "Wordmark")
    var synthNode = SynthNode.sharedSynthNode()

    override func didMoveToView(view: SKView) {
        screenWidth = view.frame.width
        screenHeight = view.frame.height

        addWordmarkNode()
        addNoteLabelNode()
        addChild(synthNode)
    }


    func addWordmarkNode() {
        wordmarkNode.position = CGPoint(x: screenWidth/2, y: screenHeight/2)

        self.addChild(wordmarkNode)
    }

    func updateShownNote() {
        // abstract
    }

    func completePendingUpdate() {
        // abstract
    }

    func addNoteLabelNode() {
        noteLabelNode.horizontalAlignmentMode = .Center
        noteLabelNode.verticalAlignmentMode = .Center
        noteLabelNode.fontColor = SKColor(rgba: "#6e8499")

        addChild(noteLabelNode)
    }

}
