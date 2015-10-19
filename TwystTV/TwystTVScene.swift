//
//  TwystTVScene.swift
//  Twyst
//
//  Created by Andrew Clissold on 10/16/15.
//  Copyright © 2015 Andrew Clissold. All rights reserved.
//

import GameController

class TwystTVScene: TwystScene, ArrowPressable, PlayPauseActivatable, UIGestureRecognizerDelegate {

    var playPauseActive = false

    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)

        synthNode.synthType = .SineTink
    }

    func arrowPressed(direction: ArrowDirection) {
        for controller in GCController.controllers() {
            if let gravity = controller.motion?.gravity {
                upAnOctave = gravity.z > -2.0/3.0
                break
            }
        }

        synthNode.frequency = frequency(direction, playPauseActive, upAnOctave)
        synthNode.startPlaying()
    }

    /// Converts the Siri Remote's state into a note frequency.
    func frequency(direction: ArrowDirection, _ upAFifth: Bool, _ upAnOctave: Bool) -> CGFloat {
        switch (direction, upAFifth, upAnOctave) {
        case (.Up, false, false):
            return Note.D4.rawValue
        case (.Up, true, false):
            return Note.A4.rawValue
        case (.Up, false, true):
            return Note.D5.rawValue
        case (.Up, true, true):
            return Note.A5.rawValue
        case (.Down, false, false):
            return Note.F4.rawValue
        case (.Down, true, false):
            return Note.C5.rawValue
        case (.Down, false, true):
            return Note.F5.rawValue
        case (.Down, true, true):
            return Note.C6.rawValue
        case (.Left, false, false):
            return Note.C4.rawValue
        case (.Left, true, false):
            return Note.G4.rawValue
        case (.Left, false, true):
            return Note.C5.rawValue
        case (.Left, true, true):
            return Note.G5.rawValue
        case (.Right, false, false):
            return Note.E4.rawValue
        case (.Right, true, false):
            return Note.B4.rawValue
        case (.Right, false, true):
            return Note.E5.rawValue
        case (.Right, true, true):
            return Note.B5.rawValue
        }
    }

}
