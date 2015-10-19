//
//  SKView+PressEventTransfer.swift
//  Twyst
//
//  Created by Andrew Clissold on 10/18/15.
//  Copyright © 2015 Andrew Clissold. All rights reserved.
//

import SpriteKit

/*
    Extend `SKView` to transfer up, down, left, right, and playpause events to
    the presented scene (if it cares to know). Scenes conform to
    `ArrowPressable` and `PlayPauseActivatable` to receive either or both types
    of events.
*/
extension SKView {

    override public func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        for press in presses {
            switch press.type {
            case .UpArrow:
                (scene as? ArrowPressable)?.arrowPressed(.Up)
                return
            case .DownArrow:
                (scene as? ArrowPressable)?.arrowPressed(.Down)
                return
            case .LeftArrow:
                (scene as? ArrowPressable)?.arrowPressed(.Left)
                return
            case .RightArrow:
                (scene as? ArrowPressable)?.arrowPressed(.Right)
                return
            case .PlayPause:
                if var scene = scene as? PlayPauseActivatable {
                    scene.playPauseActive = true
                }
                return
            default:
                break
            }
        }

        nextResponder()?.pressesBegan(presses, withEvent: event)
    }

    public override func pressesChanged(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        // ignored
    }

    override public func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
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

    public override func pressesCancelled(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        for press in presses {
            if press.type == .PlayPause {
                if var activatable = scene as? PlayPauseActivatable {
                    activatable.playPauseActive = false
                }
                return
            }
        }

        nextResponder()?.pressesCancelled(presses, withEvent: event)
    }
}
