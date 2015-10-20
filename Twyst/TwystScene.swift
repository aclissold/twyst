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

    func getNoteString(var noteCode: Int) -> String {
        if noteCode < 0 {
            noteCode += 12
        }

        if noteCode > 11 {
            noteCode -= 12
        }

        var noteString = ""

        switch (noteCode) {
        case 0: noteString = "C"
        case 1: noteString = "C#"
        case 2: noteString = "D"
        case 3: noteString = "D#"
        case 4: noteString = "E"
        case 5: noteString = "F"
        case 6: noteString = "F#"
        case 7: noteString = "G"
        case 8: noteString = "G#"
        case 9: noteString = "A"
        case 10: noteString = "A#"
        case 11: noteString = "B"
        default: noteString = ""
        }

        return noteString
    }

}
