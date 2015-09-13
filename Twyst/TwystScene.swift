//
//  TwystScene.swift
//  Twyst
//
//  Created by Andrew Clissold on 9/12/15.
//  Copyright (c) 2015 Andrew Clissold. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion
import SpriteKit
import AudioToolbox

class TwystScene: SKScene {

    let updateDelay = 0.05

    let synth = SineSynth()
    let noteCodeMappings = [
        -1: Note.B3,
        0: .C4,
        1: .Cs4,
        2: .D4,
        3: .Ds4,
        4: .E4,
        5: .F4,
        6: .Fs4,
        7: .G4,
        8: .Gs4,
        9: .A4,
        10: .As4,
        11: .B4,
        12: .C5,
        13: .Cs5,
        14: .D5,
        15: .Ds5,
        16: .E5,
        17: .F5,
        18: .Fs5,
        19: .G5,
        20: .Gs5,
        21: .A5,
        22: .As5,
        23: .B5,
        24: .C6,
    ]

    let motionManager = CMMotionManager()

    var buttonOneActive = 0,
        buttonTwoActive = 0,
        buttonThreeActive = 0,
        sharpButtonActive = 0,
        flatButtonActive = 0

    // minimalist colors!
    let minimalLightBlue = SKColor(rgba: "#3498db"),
        minimalBlue = SKColor(rgba: "#2980b9"),
        minimalPurple = SKColor(rgba: "#8e44ad"),
        minimalLightPurple = SKColor(rgba: "#9b59b6")

    var y = 0,
        x = 0,
        screenWidth = 0,
        screenHeight = 0

    var upAnOctave = false

    override func didMoveToView(view: SKView) {
        screenWidth = Int(view.frame.width)
        screenHeight = Int(view.frame.height)

        // ~~~~
        // add elements
        makeButtons()
        addMiddleLogo()
        addMiddleImage()

        // addKey()
            // disabled for now

        AKOrchestra.addInstrument(synth)
        synth.play()

        motionManager.startDeviceMotionUpdatesToQueue(
            NSOperationQueue.mainQueue()) { (deviceMotion, error) in
                if let error = error {
                    print("error retrieving device motion: \(error.localizedDescription)")
                    return
                }

                if let g = deviceMotion?.gravity {
                    self.upAnOctave = g.x > 0.666
                }

                if let a = deviceMotion?.userAcceleration {
                    self.synth.vibrato = Float(a.x + a.y + a.z)
                }
        }
    }

    func isEqualColor(color: SKColor, toColor: SKColor) -> Bool {
        let color1Components = CGColorGetComponents(color.CGColor)
        let color2Components = CGColorGetComponents(toColor.CGColor)

        if ((color1Components[0] != color2Components[0]) || //red
            (color1Components[1] != color2Components[1]) || //green
            (color1Components[2] != color2Components[2]) || //blue
            (color1Components[3] != color2Components[3])) { //alpha
                return false
        }

        return true
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // when user touches a button, turn it light blue

        for touch in touches {
            let location = touch.locationInNode(self)

            let nodes = nodesAtPoint(location) as [SKNode]

            for node in nodes {
                if let name = node.name {
                    if name.containsString("noteButton") {
                        // if it's a noteButton....

                        // vibrate
                        //   ipod touch doesn't support, so leaving this out for now
                        //
                        // AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))

                        handleNoteStart(name)
                        let spriteNode = node as! SKSpriteNode

                        let changeColorAction = SKAction.colorizeWithColor(minimalLightBlue, colorBlendFactor: 1.0, duration: 0)
                        spriteNode.runAction(changeColorAction) {
                            spriteNode.color = self.minimalLightBlue
                        }

                    } else if (name.containsString("topButton")) {
                        let spriteNode = node as! SKSpriteNode
                        let changeColorAction = SKAction.colorizeWithColor(minimalLightPurple, colorBlendFactor: 1.0, duration: 0)

                        spriteNode.runAction(changeColorAction) {
                            spriteNode.color = self.minimalLightPurple
                        }

                        if name == "topButtonSharp" {
                            sharpButtonActive = 1
                        } else if name == "topButtonFlat" {
                            flatButtonActive = 1
                        }
                    } else if name.containsString("flatImage") {
                        let spriteNode = node as! SKSpriteNode
                        spriteNode.texture = SKTexture(imageNamed: "flatImage_active")
                    } else if name.containsString("sharpImage") {
                        let spriteNode = node as! SKSpriteNode
                        spriteNode.texture = SKTexture(imageNamed: "sharpImage_active")
                    }

                    pendingNoteCode = getCurrentNoteCode()
                    pendingUpdate = true
                    eventDate = NSDate()
                }
            }
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // when user leaves hand from button, turn it back to dark blue

        for touch in touches {
            let location = touch.locationInNode(self)

            let nodes = nodesAtPoint(location) as [SKNode]

            for node in nodes {
                if let name = node.name {
                    if name.containsString("noteButton") {
                        // if it's a noteButton....

                        handleNoteEnd(name)
                        let spriteNode = node as! SKSpriteNode

                        let changeColorAction = SKAction.colorizeWithColor(minimalBlue, colorBlendFactor: 1.0, duration: 0)
                        spriteNode.runAction(changeColorAction) {
                            spriteNode.color = self.minimalBlue
                        }

                    } else if name.containsString("topButton") {
                        let spriteNode = node as! SKSpriteNode
                        let changeColorAction = SKAction.colorizeWithColor(minimalPurple, colorBlendFactor: 1.0, duration: 0)

                        spriteNode.runAction(changeColorAction) {
                            spriteNode.color = self.minimalPurple
                        }

                        if name == "topButtonSharp" {
                            sharpButtonActive = 0
                        } else if name == "topButtonFlat" {
                            flatButtonActive = 0
                        }
                    } else if name.containsString("flatImage") {
                        let spriteNode = node as! SKSpriteNode
                        spriteNode.texture = SKTexture(imageNamed: "flatImage")
                    } else if name.containsString("sharpImage") {
                        let spriteNode = node as! SKSpriteNode
                        spriteNode.texture = SKTexture(imageNamed: "sharpImage")
                    }

                    /*if name.containsString("_active") {
                        let spriteNode = node as! SKSpriteNode
                        let newName = name.stringByReplacingOccurrencesOfString("_active", withString: "")
                        spriteNode.texture = SKTexture(imageNamed: newName)
                        node.name = newName
                    }*/

                    pendingNoteCode = getCurrentNoteCode()
                    pendingUpdate = true
                    eventDate = NSDate()
                }
            }
        }
    }

    var pendingUpdate = false
    var eventDate = NSDate()
    override func update(currentTime: NSTimeInterval) {
        if pendingUpdate && abs(eventDate.timeIntervalSinceNow) > updateDelay {
            completePendingUpdate()
        }
    }

    var pendingNoteCode: Int? = 0
    func completePendingUpdate() {
        if let noteCode = pendingNoteCode {
            guard let note = noteCodeMappings[noteCode] else {
                fatalError("unexpected note code: \(noteCode)")
            }
            synth.note = note
            synth.mute(false)
        } else {
            synth.mute(true)
        }
        pendingUpdate = false
    }

    // ~~~~~~~
    // specialized funcs
    func handleNoteStart(noteName: String) {
        switch noteName.characters.last! {
        case "1":
            buttonOneActive = 1
        case "2":
            buttonTwoActive = 1
        case "3":
            buttonThreeActive = 1
        default:
            fatalError("unexpected noteName: \(noteName)")
        }
    }

    func handleNoteEnd(noteName: String) {
        switch noteName.characters.last! {
        case "1":
            buttonOneActive = 0
        case "2":
            buttonTwoActive = 0
        case "3":
            buttonThreeActive = 0
        default:
            fatalError("unexpected noteName: \(noteName)")
        }
    }

    func getCurrentNoteCode() -> Int? {
        var noteCode: Int
        switch (buttonOneActive, buttonTwoActive, buttonThreeActive) {
        case (0, 0, 0):
            return nil
        case (1, 0, 0):
            noteCode = 0
        case (0, 1, 0):
            noteCode = 2
        case (0, 0, 1):
            noteCode = 4
        case (1, 1, 0):
            noteCode = 5
        case (1, 0, 1):
            noteCode = 7
        case (0, 1, 1):
            noteCode = 9
        case (1, 1, 1):
            noteCode = 11
        default:
            fatalError("unexpected button combination: (\(buttonOneActive), \(buttonTwoActive), \(buttonThreeActive))")
        }

        noteCode += sharpButtonActive
        noteCode -= flatButtonActive

        if upAnOctave {
            noteCode += 12
        }

        return noteCode
    }

    func addKey() {
        let keySize = CGSize(width: 50, height: 50)
        let keyPic = SKSpriteNode(texture: SKTexture(imageNamed: "key"), size: keySize)
        keyPic.anchorPoint = CGPoint(x: 0, y: 1)
        keyPic.position = CGPoint(x: 35, y: screenHeight - 25)

        self.addChild(keyPic)
    }

    func addMiddleLogo() {
        let logoSize = CGSize(width: 260, height: 55)
        let logoNode = SKSpriteNode(texture: SKTexture(imageNamed: "blue_logo"), size: logoSize)
        logoNode.anchorPoint = CGPoint(x: 0, y: 0)
        logoNode.position = CGPoint(x: 160, y: (2 * screenHeight / 3) + 15)

        self.addChild(logoNode)
    }

    func addMiddleImage() {
        let imageSize = CGSize(width: 180, height: 180)
        let imageNode = SKSpriteNode(texture: SKTexture(imageNamed: "vinyl_icon"), size: imageSize)
        imageNode.anchorPoint = CGPoint(x: 0, y: 0)
        imageNode.position = CGPoint(x: 190, y: 10)

        self.addChild(imageNode)
    }

    func makeButtons() {
        let accidentalButtonSize = CGSize(width: 212, height: 106),
            noteButtonSize = CGSize(width: screenWidth / 4, height: screenHeight / 3)

        // ~~~~~
        // bottom buttons
        makeNoteButton(minimalBlue, buttonSize: noteButtonSize)
        makeNoteButton(minimalBlue, buttonSize: noteButtonSize)
        makeNoteButton(minimalBlue, buttonSize: noteButtonSize)

        // ~~~~~
        // top buttons

        y = 0
        // start back at left of screen

        makeAccidentalButton(minimalBlue, buttonSize: accidentalButtonSize)
        makeAccidentalButton(minimalBlue, buttonSize: accidentalButtonSize)
    }


    func makeNoteButton(buttonColor: SKColor, buttonSize: CGSize) -> SKSpriteNode {
        let node = SKSpriteNode(color: buttonColor, size: buttonSize)

        node.anchorPoint = CGPoint(x: 0, y: 0)
        // positions it with respect to bottom left

        node.position = CGPoint(x: screenWidth - Int(buttonSize.width), y: y)

        node.name = "noteButton"
        var imageUrl = ""

        if y == 0 {
            // set button to 1 value
            node.name = node.name! + " 1"
            imageUrl = "one_no_background"
        } else if y == screenHeight / 3 {
            // set button to 2 value
            node.name = node.name! + " 2"
            imageUrl = "two_no_background"
        } else {
            // set button to 3 value
            node.name = node.name! + " 3"
            imageUrl = "three_no_background"
        }

        y += screenHeight / 3

        let imageNode = SKSpriteNode(texture: SKTexture(imageNamed: imageUrl), size: CGSize(width: 15, height: 30))
        imageNode.anchorPoint = CGPoint(x: 0, y: 1)
        imageNode.position = CGPoint(x: screenWidth - Int(buttonSize.width) + 6, y: y - 6)

        self.addChild(imageNode)
        self.addChild(node)
        return node
    }

    func makeAccidentalButton(buttonColor: SKColor, buttonSize: CGSize) {
        let anchorPoint = CGPoint(x: 0, y: 0)
        let position = CGPoint(x: 0, y: y)

        // ~~~~
        // color node
        let colorNode = SKSpriteNode(color: minimalPurple, size: buttonSize)
        colorNode.anchorPoint = anchorPoint
        colorNode.alpha = 0.0
        // positions it with respect to top left

        colorNode.position = position
        y += screenHeight / 3

        // ~~~~
        // image node
        let imageName: String
        if y == screenHeight / 3 {
            imageName = "flatImage"
            colorNode.name = "topButtonFlat"
        } else {
            imageName = "sharpImage"
            colorNode.name = "topButtonSharp"
        }

        let imageNode = SKSpriteNode(texture: SKTexture(imageNamed: imageName), size: buttonSize)
        imageNode.anchorPoint = anchorPoint
        imageNode.name = imageName
        imageNode.position = position

        self.addChild(colorNode)
        self.addChild(imageNode)
    }

}
