//
//  TwystPhoneScene.swift
//  Twyst
//
//  Created by Andrew Clissold on 10/16/15.
//  Copyright © 2015 Andrew Clissold. All rights reserved.
//

import CoreMotion

class TwystPhoneScene: TwystScene {

    var pendingUpdate = false
    var pendingNoteCode: Int?
    let oneButton = ButtonNode(type: .One)
    let twoButton = ButtonNode(type: .Two)
    let threeButton = ButtonNode(type: .Three)
    let flatButton = ButtonNode(type: .Flat)
    let sharpButton = ButtonNode(type: .Sharp)

    var vibrato: CGFloat = 0 {
        didSet {
            if !pendingUpdate {
                updateSynthNodeFrequency()
            }
        }
    }

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

    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)

        updateDelay = 0.03

        addButtons()

        noteLabelNode.fontSize = 52
        noteLabelNode.position = CGPoint(x: (1/2)*screenWidth, y: oneButton.frame.midY)

        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue()) { (deviceMotion, error) in
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
                self.vibrato = CGFloat(a.x + a.y + a.z)
            }
        }
    }

    func addButtons() {
        let buttonSize = CGSize(width: (2/5)*screenWidth, height: (1/3)*screenHeight)

        oneButton.position = CGPoint(
            x: screenWidth - buttonSize.width,
            y: (1/3)*screenHeight)
        twoButton.position = CGPoint(
            x: screenWidth - buttonSize.width,
            y: (2/3)*screenHeight)
        threeButton.position = CGPoint(
            x: screenWidth - buttonSize.width,
            y: (3/3)*screenHeight)
        sharpButton.position = CGPoint(
            x: 0,
            y: (1/3)*screenHeight)
        flatButton.position = CGPoint(
            x: 0,
            y: (3/3)*screenHeight)

        for buttonNode in [oneButton, twoButton, threeButton, sharpButton, flatButton] {
            buttonNode.size = buttonSize
            buttonNode.anchorPoint = CGPoint(x: 0, y: 1)
            addChild(buttonNode)
        }

    }

    func getCurrentNoteCode() -> Int? {
        var noteCode: Int

        switch (oneButton.active, twoButton.active, threeButton.active) {
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

        if sharpButton.active { ++noteCode }
        if flatButton.active { --noteCode }
        if upAnOctave { noteCode += 12 }

        return noteCode
    }

    override func update(currentTime: NSTimeInterval) {
        if pendingUpdate && abs(eventDate.timeIntervalSinceNow) > updateDelay {
            completePendingUpdate()
        }
    }

    override func completePendingUpdate() {
        updateSynthNodeFrequency()
        pendingUpdate = false
    }

    func triggerUpdate() {
        pendingNoteCode = getCurrentNoteCode()
        pendingUpdate = true
        eventDate = NSDate()
    }

    func updateSynthNodeFrequency() {
        if let noteCode = pendingNoteCode {
            guard let note = noteCodeMappings[noteCode] else {
                fatalError("unexpected note code: \(noteCode)")
            }
            synthNode.frequency = note.rawValue + vibratoMultiplier*vibrato
            noteLabelNode.text = currentNoteName
            if !synthNode.playing {
                synthNode.startPlaying()
            }
        } else if synthNode.playing {
            synthNode.stopPlaying()
            noteLabelNode.text = ""
        }
    }

    func buttonTapped(node: ButtonNode) {
        triggerUpdate()
    }

    // MARK: Ugly

    var currentNoteName: String {
        switch (oneButton.active, twoButton.active, threeButton.active, sharpButton.active, flatButton.active) {

        // Natural
        case (false, false, false, false, false), (false, false, false, true, true): return ""
        case (true, false, false, false, false), (true, false, false, true, true): return "C"
        case (false, true, false, false, false), (false, true, false, true, true): return "D"
        case (false, false, true, false, false), (false, false, true, true, true): return "E"
        case (true, true, false, false, false), (true, true, false, true, true): return "F"
        case (true, false, true, false, false), (true, false, true, true, true): return "G"
        case (false, true, true, false, false), (false, true, true, true, true): return "A"
        case (true, true, true, false, false), (true, true, true, true, true): return "B"

        // Sharp
        case (false, false, false, true, false): return ""
        case (true, false, false, true, false): return "C♯"
        case (false, true, false, true, false): return "D♯"
        case (false, false, true, true, false): return "F"
        case (true, true, false, true, false): return "F♯"
        case (true, false, true, true, false): return "G♯"
        case (false, true, true, true, false): return "A♯"
        case (true, true, true, true, false): return "C"

        // Flat
        case (false, false, false, false, true): return ""
        case (true, false, false, false, true): return "B"
        case (false, true, false, false, true): return "D♭"
        case (false, false, true, false, true): return "E♭"
        case (true, true, false, false, true): return "E"
        case (true, false, true, false, true): return "G♭"
        case (false, true, true, false, true): return "A♭"
        case (true, true, true, false, true): return "B♭"
        }
    }

}
