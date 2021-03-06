//
//  TwystPhoneScene.swift
//  Twyst
//
//  Created by Andrew Clissold on 10/16/15.
//  Copyright © 2015 Andrew Clissold. All rights reserved.
//

import CoreMotion

class TwystPhoneScene: TwystScene, Jinglable {

    var pendingUpdate = false
    var pendingNote: Note?
    let oneButton = ButtonNode(type: .One)
    let twoButton = ButtonNode(type: .Two)
    let threeButton = ButtonNode(type: .Three)
    let flatButton = ButtonNode(type: .Flat)
    let sharpButton = ButtonNode(type: .Sharp)
    let quarterNoteDuration = (1.0/3.0)

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
        let oneButtonPosition = convertPoint(self.position, fromNode: oneButton.spriteNode)
        noteLabelNode.position = CGPoint(x: (1/2)*screenWidth, y: oneButtonPosition.y)
        noteLabelNode.verticalAlignmentMode = .Center

        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue()) { (deviceMotion, error) in
            if let error = error {
                print("error retrieving device motion: \(error.localizedDescription)")
                return
            }

            if let g = deviceMotion?.gravity
                where self.upAnOctave != (g.x > 0.666) && self.demoFinished {
                    self.upAnOctave = !self.upAnOctave
                    self.triggerUpdate()
            }

            if let a = deviceMotion?.userAcceleration {
                self.vibrato = CGFloat(a.x + a.y + a.z)
            }
        }

        runDemoIfNecessary()
    }

    func runDemoIfNecessary() {
        if NSUserDefaults.standardUserDefaults().boolForKey(ranDemoKey) {
            demoFinished = true
            return
        }

        let buttons = [oneButton, twoButton, threeButton, sharpButton, flatButton]
        buttons.forEach { $0.userInteractionEnabled = false }
        playJingle(.Phone) {
            buttons.forEach { $0.userInteractionEnabled = true }
            self.demoFinished = true
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: self.ranDemoKey)
        }
    }

    func addButtons() {
        let largeScreenOffset = (1/4)*(screenHeight - 320)
        let accidentalOffset: CGFloat = 8
        let padding: CGFloat = 24
        let width: CGFloat = 75
        let paddedWidth = padding + width + padding
        let overlap: CGFloat = 2.5

        oneButton.size = CGSize(width: 2*paddedWidth, height: screenHeight/2)
        twoButton.size = CGSize(width: 2*paddedWidth, height: width+padding)
        threeButton.size = oneButton.size
        sharpButton.size = CGSize(width: 2*paddedWidth, height: screenHeight/2)
        flatButton.size = sharpButton.size

        oneButton.position = CGPoint(
            x: screenWidth - (1/2)*(padding+width+padding),
            y: (1/4)*screenHeight - padding)
        twoButton.position = CGPoint(
            x: screenWidth - (1/2)*paddedWidth,
            y: screenHeight/2)
        threeButton.position = CGPoint(
            x: screenWidth - (1/2)*paddedWidth,
            y: (3/4)*screenHeight + padding)
        sharpButton.position = CGPoint(
            x: (1/2)*paddedWidth,
            y: (3/4)*screenHeight)
        flatButton.position = CGPoint(
            x: (1/2)*paddedWidth,
            y: (1/4)*screenHeight)

        oneButton.spriteNode.position.y += largeScreenOffset + overlap
        threeButton.spriteNode.position.y -= largeScreenOffset + overlap
        sharpButton.spriteNode.position.y -= largeScreenOffset + accidentalOffset + overlap
        flatButton.spriteNode.position.y += largeScreenOffset + accidentalOffset + overlap

        for buttonNode in [oneButton, twoButton, threeButton, sharpButton, flatButton] {
            addChild(buttonNode)
        }
        twoButton.zPosition = 1
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
        pendingNote = note // for demo
        let frequency = note.rawValue + vibratoMultiplier*vibrato
        synthNode.frequency = upAnOctave ? frequency*octaveMultiplier : frequency
        if !demoFinished {
            updateButtonActiveStates(note)
        }
        noteLabelNode.text = note.description
        if !synthNode.playing {
            synthNode.startPlaying()
        }
    }

    func stopPlaying() {
        if demoFinished {
            [oneButton, twoButton, threeButton].forEach { $0.active = false }
        } else {
            [oneButton, twoButton, threeButton, sharpButton, flatButton].forEach { $0.active = false }
        }
        synthNode.stopPlaying()
        noteLabelNode.text = ""
    }

    func buttonTapped(node: ButtonNode) {
        triggerUpdate()
    }

    // MARK: Ugly

    func updateButtonActiveStates(note: Note) {
        oneButton.active = false
        twoButton.active = false
        threeButton.active = false
        sharpButton.active = false
        flatButton.active = false

        switch note {
        case .B3, .C, .Cs, .F, .Fs, .Gf, .G, .Gs, .Bf, .B, .C5:
            oneButton.active = true
        default:
            break
        }

        switch note {
        case .B3, .Df, .D, .Ds, .F, .Fs, .Af, .A, .As, .B:
            twoButton.active = true
        default:
            break
        }

        switch note {
        case .B3, .Ef, .E, .Gf, .G, .Gs, .Af, .A, .As, .Bf, .B:
            threeButton.active = true
        default:
            break
        }

        switch note {
        case .Cs, .Ds, .Fs, .Gs, .As:
            sharpButton.active = true
        default:
            break
        }

        switch note {
        case .Df, .Ef, .Gf, .Af, .Bf:
            flatButton.active = true
        default:
            break
        }
    }

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
