//
//  TwystTVScene.swift
//  Twyst
//
//  Created by Andrew Clissold on 10/16/15.
//  Copyright © 2015 Andrew Clissold. All rights reserved.
//

class TwystTVScene: TwystScene {

    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)

        synthNode.synthType = .SineTink
        addGestureRecognizers()
    }

    func addGestureRecognizers() {
        let playPauseRecognizer = UITapGestureRecognizer(target: self, action: "playPausePressed:")
        playPauseRecognizer.allowedPressTypes = [UIPressType.PlayPause.rawValue]
        view?.addGestureRecognizer(playPauseRecognizer)
    }

    func playPausePressed(sender: UITapGestureRecognizer) {
        synthNode.startPlaying()
    }

}
