//
//  TwystTVScene.swift
//  Twyst
//
//  Created by Andrew Clissold on 10/16/15.
//  Copyright © 2015 Andrew Clissold. All rights reserved.
//

class TwystTVScene: TwystScene, ArrowPressable, PlayPauseActivatable, UIGestureRecognizerDelegate {

    var playPauseActive = false

    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)

        synthNode.synthType = .SineTink
    }

    func arrowPressed(direction: ArrowDirection) {
        switch direction {
        case .Up:
            synthNode.frequency = playPauseActive ? Note.A4.rawValue : Note.D4.rawValue
        case .Down:
            synthNode.frequency = playPauseActive ? Note.C5.rawValue : Note.F4.rawValue
        case .Left:
            synthNode.frequency = playPauseActive ? Note.G4.rawValue : Note.C4.rawValue
        case .Right:
            synthNode.frequency = playPauseActive ? Note.B4.rawValue : Note.E4.rawValue
        }

        synthNode.startPlaying()
    }

}
