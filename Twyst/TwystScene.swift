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

    let updateDelay = 0.03

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

    var showNote = UILabel(frame: CGRect(x: 230, y: 200, width: 140.00, height: 140.00))

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

    // ~~~~~~~~~~
    // MAIN VIEW FUNCTION
    override func didMoveToView(view: SKView) {
        screenWidth = Int(view.frame.width)
        screenHeight = Int(view.frame.height)

        // ~~~~
        // add elements
        makeButtons()
        addMiddleLogo()
        // addMiddleImage()
        addNoteTextBox(view)

        // addHelp()
            // disabled for now

        AKOrchestra.addInstrument(synth)
        synth.play()

        motionManager.startDeviceMotionUpdatesToQueue(
            NSOperationQueue()) { (deviceMotion, error) in
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
        for touch in touches {
            let location = touch.locationInNode(self)
            for node in nodesAtPoint(location) as [SKNode] {
                toggle(node, on: true)
            }
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            for node in nodesAtPoint(location) as [SKNode] {
                toggle(node, on: false)
            }
        }
    }

    func toggle(node: SKNode, on: Bool) {
        if let name = node.name {
            if  name == "buttonOneImage" ||
                name == "buttonTwoImage" ||
                name == "buttonThreeImage" {
                    if on {
                        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                        handleNoteStart(name)
                    } else {
                        handleNoteEnd(name)
                    }
                    let spriteNode = node as! SKSpriteNode
                    let newImageName: String
                    if on {
                        newImageName = name + "_active"
                    } else {
                        newImageName = name.stringByReplacingOccurrencesOfString("_active", withString: "")
                    }
                    spriteNode.texture = SKTexture(imageNamed: newImageName)
            } else if name.containsString("flatImage") {
                flatButtonActive = on ? 1 : 0
                let spriteNode = node as! SKSpriteNode
                spriteNode.texture = SKTexture(imageNamed: on ? "flatImage_active" : "flatImage")
            } else if name.containsString("sharpImage") {
                sharpButtonActive = on ? 1 : 0
                let spriteNode = node as! SKSpriteNode
                spriteNode.texture = SKTexture(imageNamed: on ? "sharpImage_active" : "sharpImage")
            }

            pendingNoteCode = getCurrentNoteCode()
            pendingUpdate = true
            eventDate = NSDate()
        }
    }

    var pendingUpdate = false
    var eventDate = NSDate()
    override func update(currentTime: NSTimeInterval) {
        if pendingUpdate && abs(eventDate.timeIntervalSinceNow) > updateDelay {
            completePendingUpdate()
        }
    }gi

    var pendingNoteCode: Int? = 0
    func completePendingUpdate() {
        if let noteCode = pendingNoteCode {
            guard let note = noteCodeMappings[noteCode] else {
                fatalError("unexpected note code: \(noteCode)")
            }
            synth.note = note
            updateShownNote()
            synth.mute(false)
        } else {
            synth.mute(true)
        }
        pendingUpdate = false
    }

    // ~~~~~~~
    // specialized funcs
    func handleNoteStart(noteName: String) {
        switch noteName {
        case "buttonOneImage":
            buttonOneActive = 1
        case "buttonTwoImage":
            buttonTwoActive = 1
        case "buttonThreeImage":
            buttonThreeActive = 1
        default:
            fatalError("unexpected note name: \(noteName)")
        }

        updateShownNote()
    }

    func handleNoteEnd(noteName: String) {
        switch noteName {
        case "buttonOneImage":
            buttonOneActive = 0
        case "buttonTwoImage":
            buttonTwoActive = 0
        case "buttonThreeImage":
            buttonThreeActive = 0
        default:
            fatalError("unexpected note name: \(noteName)")
        }

        hideShownNote()
    }

    func updateShownNote() {
        if let noteCode = getCurrentNoteCode() {
            let noteString = getNoteString(noteCode)
            showNote.text = noteString
        }
        else {
            hideShownNote()
        }
    }

    func hideShownNote() {
        showNote.text = ""
    }

    func addNoteTextBox(view: SKView) {
        showNote.text = ""
        showNote.textColor = UIColor.whiteColor()
        showNote.font = UIFont(name: "Avenir-Light", size: 95)

        view.addSubview(showNote)

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

    func getNoteString(var noteCode: Int) -> String {
        //noteCode += sharpButtonActive
        //noteCode -= flatButtonActive

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

    func addHelp() {
        let keySize = CGSize(width: 20, height: 30)
        let keyPic = SKSpriteNode(texture: SKTexture(imageNamed: "help"), size: keySize)
        keyPic.anchorPoint = CGPoint(x: 0, y: 1)
        keyPic.position = CGPoint(x: 40, y: screenHeight - 25)

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
            noteButtonSize = CGSize(width: 2 * screenWidth / 5, height: screenHeight / 3)

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
        var imageName = ""
        if y == 0 {
            // set button to 1 value
            imageName = "buttonOneImage"
        } else if y == screenHeight / 3 {
            imageName = "buttonTwoImage"
        } else {
            imageName = "buttonThreeImage"
        }

        y += screenHeight / 3

        let imageNode = SKSpriteNode(texture: SKTexture(imageNamed: imageName), size: buttonSize)
        imageNode.name = imageName
        imageNode.anchorPoint = CGPoint(x: 0, y: 1)
        imageNode.position = CGPoint(x: screenWidth - Int(buttonSize.width) + 6, y: y - 6)

        self.addChild(imageNode)
        return imageNode
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
