//
//  PlayPauseView.swift
//  Twyst
//
//  Created by Andrew Clissold on 10/18/15.
//  Copyright © 2015 Andrew Clissold. All rights reserved.
//

/// An `SKView` subclass that transfers playpause button down and up events to its PlayPauseActivatable scene.
class PlayPauseView: SKView {

    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        for press in presses {
            if press.type == .PlayPause {
                if var activatable = scene as? PlayPauseActivatable {
                    activatable.playPauseActive = true
                }
            }
        }

        nextResponder()?.pressesBegan(presses, withEvent: event)
    }

    override func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        for press in presses {
            if press.type == .PlayPause {
                if var activatable = scene as? PlayPauseActivatable {
                    activatable.playPauseActive = false
                }
                return
            }
        }

        nextResponder()?.pressesEnded(presses, withEvent: event)
    }
}
