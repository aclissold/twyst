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

    var buttonOne, buttonTwo, buttonThree, flatButton, sharpButton: ButtonNode!

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
                    let wasUpAnOctave = self.upAnOctave
                    self.upAnOctave = g.x > 0.666
                    if (wasUpAnOctave && !self.upAnOctave)
                        || (!wasUpAnOctave && self.upAnOctave) {
                            self.triggerUpdate()
                    }
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

    func buttonTapped(node: ButtonNode) {
        if node.active {
            updateShownNote()
        } else {
            showNote.text = ""
        }

        triggerUpdate()
    }

    func triggerUpdate() {
        pendingNoteCode = getCurrentNoteCode()
        pendingUpdate = true
        eventDate = NSDate()
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
            updateShownNote()
            synth.mute(false)
        } else {
            synth.mute(true)
        }
        pendingUpdate = false
    }

    func updateShownNote() {
        if let noteCode = getCurrentNoteCode() {
            let noteString = getNoteString(noteCode)
            showNote.text = noteString
        } else {
            showNote.text = ""
        }
    }

    func addNoteTextBox(view: SKView) {
        showNote.text = ""
        showNote.textColor = UIColor.whiteColor()
        showNote.font = UIFont(name: "Avenir-Light", size: 95)

        view.addSubview(showNote)
    }

    func getCurrentNoteCode() -> Int? {
        var noteCode: Int
        switch (buttonOne.active, buttonTwo.active, buttonThree.active) {
        case (false, false, false):
            return nil
        case (true, false, false):
            noteCode = 0
        case (false, true, false):
            noteCode = 2
        case (false, false, true):
            noteCode = 4
        case (true, true, false):
            noteCode = 5
        case (true, false, true):
            noteCode = 7
        case (false, true, true):
            noteCode = 9
        case (true, true, true):
            noteCode = 11
        }

        if sharpButton.active {
            ++noteCode
        }
        if flatButton.active {
            --noteCode
        }
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

        makeNoteButton(noteButtonSize)
        makeNoteButton(noteButtonSize)
        makeNoteButton(noteButtonSize)

        y = 0

        makeAccidentalButton(minimalBlue, buttonSize: accidentalButtonSize)
        makeAccidentalButton(minimalBlue, buttonSize: accidentalButtonSize)
    }

    func makeNoteButton(buttonSize: CGSize) {
        let noteButton: ButtonNode
        if y == 0 {
            noteButton = ButtonNode(type: .One, size: buttonSize)
            buttonOne = noteButton
        } else if y == screenHeight / 3 {
            noteButton = ButtonNode(type: .Two, size: buttonSize)
            buttonTwo = noteButton
        } else {
            noteButton = ButtonNode(type: .Three, size: buttonSize)
            buttonThree = noteButton
        }

        y += screenHeight / 3

        noteButton.anchorPoint = CGPoint(x: 0, y: 1)
        noteButton.position = CGPoint(x: screenWidth - Int(buttonSize.width) + 6, y: y - 6)

        self.addChild(noteButton)
    }

    func makeAccidentalButton(buttonColor: SKColor, buttonSize: CGSize) {
        let anchorPoint = CGPoint(x: 0, y: 0)
        let position = CGPoint(x: 0, y: y)

        y += screenHeight / 3

        let accidentalButton: ButtonNode
        if y == screenHeight / 3 {
            accidentalButton = ButtonNode(type: .Flat, size: buttonSize)
            flatButton = accidentalButton
        } else {
            accidentalButton = ButtonNode(type: .Sharp, size: buttonSize)
            sharpButton = accidentalButton
        }

        accidentalButton.anchorPoint = anchorPoint
        accidentalButton.position = position

        self.addChild(accidentalButton)
    }

}
