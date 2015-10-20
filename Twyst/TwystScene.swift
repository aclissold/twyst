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
    var eventDate = NSDate()
    var updateDelay = 0.0

    var screenWidth: CGFloat = 0,
        screenHeight: CGFloat = 0

    var upAnOctave = false

    let noteLabelNode = SKLabelNode(fontNamed: "Avenir-Light")
    let synthNode = SynthNode.sharedSynthNode()

    override func didMoveToView(view: SKView) {
        screenWidth = view.frame.width
        screenHeight = view.frame.height

        addLogo()
        addNoteLabelNode()
        addChild(synthNode)
    }


    func addLogo() {
        let logoNode = SKSpriteNode(texture: SKTexture(imageNamed: "Wordmark"))
        logoNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        logoNode.position = CGPoint(x: screenWidth/2, y: screenHeight/2)

        self.addChild(logoNode)
    }

    func updateShownNote() {
        // abstract
    }

    func completePendingUpdate() {
        // abstract
    }

    func addNoteLabelNode() {
        noteLabelNode.fontSize = 52
        noteLabelNode.horizontalAlignmentMode = .Center
        noteLabelNode.verticalAlignmentMode = .Center
        noteLabelNode.fontColor = SKColor(rgba: "#6e8499")

        addChild(noteLabelNode)
    }

}
