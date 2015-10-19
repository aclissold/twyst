//
//  TwystTVScene.swift
//  Twyst
//
//  Created by Andrew Clissold on 10/16/15.
//  Copyright © 2015 Andrew Clissold. All rights reserved.
//

class TwystTVScene: TwystScene, PlayPauseActivatable, UIGestureRecognizerDelegate {

    var playPauseActive = false

    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)

        synthNode.synthType = .SineTink
        addGestureRecognizers()
    }

    func addGestureRecognizers() {
        let upPressGestureRecognizer = UITapGestureRecognizer(target: self, action: "up")
        let downPressGestureRecognizer = UITapGestureRecognizer(target: self, action: "down")
        let leftPressGestureRecognizer = UITapGestureRecognizer(target: self, action: "left")
        let rightPressGestureRecognizer = UITapGestureRecognizer(target: self, action: "right")

        let upSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "up")
        let downSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "down")
        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "left")
        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "right")

        upPressGestureRecognizer.allowedPressTypes = [UIPressType.UpArrow.rawValue]
        downPressGestureRecognizer.allowedPressTypes = [UIPressType.DownArrow.rawValue]
        leftPressGestureRecognizer.allowedPressTypes = [UIPressType.LeftArrow.rawValue]
        rightPressGestureRecognizer.allowedPressTypes = [UIPressType.RightArrow.rawValue]

        upSwipeGestureRecognizer.direction = [.Up]
        downSwipeGestureRecognizer.direction = [.Down]
        leftSwipeGestureRecognizer.direction = [.Left]
        rightSwipeGestureRecognizer.direction = [.Right]

        view?.addGestureRecognizer(upPressGestureRecognizer)
        view?.addGestureRecognizer(downPressGestureRecognizer)
        view?.addGestureRecognizer(leftPressGestureRecognizer)
        view?.addGestureRecognizer(rightPressGestureRecognizer)

        view?.addGestureRecognizer(upSwipeGestureRecognizer)
        view?.addGestureRecognizer(downSwipeGestureRecognizer)
        view?.addGestureRecognizer(leftSwipeGestureRecognizer)
        view?.addGestureRecognizer(rightSwipeGestureRecognizer)
    }

    func up() {
        synthNode.frequency = playPauseActive ? Note.A4.rawValue : Note.D4.rawValue
        synthNode.startPlaying()
    }

    func down() {
        synthNode.frequency = playPauseActive ? Note.C5.rawValue : Note.F4.rawValue
        synthNode.startPlaying()
    }

    func left() {
        synthNode.frequency = playPauseActive ? Note.G4.rawValue : Note.C4.rawValue
        synthNode.startPlaying()
    }

    func right() {
        synthNode.frequency = playPauseActive ? Note.B4.rawValue : Note.E4.rawValue
        synthNode.startPlaying()
    }

}
