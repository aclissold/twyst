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
    var pendingNote: Note?
    let oneButton = ButtonNode(type: .One)
    let twoButton = ButtonNode(type: .Two)
    let threeButton = ButtonNode(type: .Three)
    let flatButton = ButtonNode(type: .Flat)
    let sharpButton = ButtonNode(type: .Sharp)
    let quarterNoteDuration = 0.4

    var vibrato: CGFloat = 0 {
        didSet {
            if let note = pendingNote where !pendingUpdate {
                let frequency = note.rawValue + vibratoMultiplier*vibrato
                synthNode.frequency = upAnOctave ? frequency*octaveMultiplier : frequency
            }
        }
    }

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

    override func update(currentTime: NSTimeInterval) {
        if pendingUpdate && abs(eventDate.timeIntervalSinceNow) > updateDelay {
            completePendingUpdate()
        }
    }

    override func completePendingUpdate() {
        playNoteOrStopPlaying()
        pendingUpdate = false
    }

    func playNoteOrStopPlaying() {
        if let note = pendingNote {
            playNote(note)
        } else {
            stopPlaying()
        }
    }

    func triggerUpdate() {
        pendingNote = currentNote
        pendingUpdate = true
        eventDate = NSDate()
    }

    func playNote(note: Note) {
        let frequency = note.rawValue + vibratoMultiplier*vibrato
        synthNode.frequency = upAnOctave ? frequency*octaveMultiplier : frequency
        noteLabelNode.text = note.description
        if !synthNode.playing {
            synthNode.startPlaying()
        }
    }

    func stopPlaying() {
        synthNode.stopPlaying()
        noteLabelNode.text = ""
    }

    func buttonTapped(node: ButtonNode) {
        triggerUpdate()
    }

    // MARK: Ugly

    var currentNote: Note? {
        switch (oneButton.active, twoButton.active, threeButton.active, sharpButton.active, flatButton.active) {

        // Natural
        case (false, false, false, false, false), (false, false, false, true, true): return nil
        case (true, false, false, false, false), (true, false, false, true, true): return .C
        case (false, true, false, false, false), (false, true, false, true, true): return .D
        case (false, false, true, false, false), (false, false, true, true, true): return .E
        case (true, true, false, false, false), (true, true, false, true, true): return .F
        case (true, false, true, false, false), (true, false, true, true, true): return .G
        case (false, true, true, false, false), (false, true, true, true, true): return .A
        case (true, true, true, false, false), (true, true, true, true, true): return .B

        // Sharp
        case (false, false, false, true, false): return nil
        case (true, false, false, true, false): return .Cs
        case (false, true, false, true, false): return .Ds
        case (false, false, true, true, false): return .F
        case (true, true, false, true, false): return .Fs
        case (true, false, true, true, false): return .Gs
        case (false, true, true, true, false): return .As
        case (true, true, true, true, false): return .C5

        // Flat
        case (false, false, false, false, true): return nil
        case (true, false, false, false, true): return .B3
        case (false, true, false, false, true): return .Df
        case (false, false, true, false, true): return .Ef
        case (true, true, false, false, true): return .E
        case (true, false, true, false, true): return .Gf
        case (false, true, true, false, true): return .Af
        case (true, true, true, false, true): return .Bf
        }
    }

}
