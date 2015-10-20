//
//  TwystTVScene.swift
//  Twyst
//
//  Created by Andrew Clissold on 10/16/15.
//  Copyright © 2015 Andrew Clissold. All rights reserved.
//

import GameController

class TwystTVScene: TwystScene {

    let octaveMultiplier = CGFloat(pow(pow(2.0, 1.0/12.0), 12.0))
    var microGamepad: GCMicroGamepad?
    var gamepadActive = false
    var buttonAPending = false
    var buttonXPending = false

    let frequencies: [UIPressType: CGFloat] = [
        .UpArrow: Note.D4.rawValue,
        .DownArrow: Note.F4.rawValue,
        .LeftArrow: Note.C4.rawValue,
        .RightArrow: Note.E4.rawValue,
        .PlayPause: Note.G4.rawValue,
        .Select: Note.A4.rawValue,
        .Menu: Note.B4.rawValue // really .PlayPause + .Select
    ]

    override init(size: CGSize) {
        super.init(size: size)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "controllerDidConnect:",
            name: GCControllerDidConnectNotification,
            object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)

        updateDelay = 0.02

        synthNode.synthType = .SineTink
    }

    override func update(currentTime: NSTimeInterval) {
        if (buttonAPending || buttonXPending) && abs(eventDate.timeIntervalSinceNow) > updateDelay {
            completePendingUpdate()
        }
    }

    override func completePendingUpdate() {
        if buttonAPending && buttonXPending {
            buttonPressed(.Menu)
            buttonAPending = false
            buttonXPending = false
        } else if buttonAPending {
            buttonPressed(.Select)
            buttonAPending = false
        } else if buttonXPending {
            buttonPressed(.PlayPause)
            buttonXPending = false
        }
    }

    func controllerDidConnect(notification: NSNotification) {
        if let microGamepad = (notification.object as? GCController)?.microGamepad {
            self.microGamepad = microGamepad
            microGamepad.reportsAbsoluteDpadValues = true
            microGamepad.valueChangedHandler = { (gamepad, element) in
                if element == microGamepad.dpad {
                    self.handleDpad(element as! GCControllerDirectionPad)
                } else if element == microGamepad.buttonA {
                    let button = element as! GCControllerButtonInput
                    self.handleButtonA(pressed: button.pressed)
                } else if element == microGamepad.buttonX {
                    let button = element as! GCControllerButtonInput
                    self.handleButtonX(pressed: button.pressed)
                }
            }
        }
    }

    func handleDpad(dpad: GCControllerDirectionPad) {
        if !dpad.up.pressed
            && !dpad.down.pressed
            && !dpad.left.pressed
            && !dpad.right.pressed {
                self.gamepadActive = false
                return
        }
        if self.gamepadActive {
            return
        }
        self.gamepadActive = true

        let threshold: Float = 0.4
        var max: Float = 0
        var type = UIPressType.Select

        let up = dpad.up.value
        let down = dpad.down.value
        let left = dpad.left.value
        let right = dpad.right.value

        if up > max {
            max = up
            type = .UpArrow
        }
        if down > max {
            max = down
            type = .DownArrow
        }
        if left > max {
            max = left
            type = .LeftArrow
        }
        if right > max {
            max = right
            type = .RightArrow
        }

        if max > threshold {
            self.buttonPressed(type)
        } else {
            handleButtonA(pressed: true)
        }
    }

    func handleButtonA(pressed pressed: Bool) {
        if pressed && buttonXPending {
            buttonXPending = false
            buttonPressed(.Menu)
        } else if pressed {
            buttonAPending = true
            eventDate = NSDate()
        }
    }

    func handleButtonX(pressed pressed: Bool) {
        if pressed && buttonAPending {
            buttonAPending = false
            buttonPressed(.Menu)
        } else if pressed {
            buttonXPending = true
            eventDate = NSDate()
        }
    }

    func buttonPressed(pressType: UIPressType) {
        for controller in GCController.controllers() {
            if let gravity = controller.motion?.gravity {
                upAnOctave = gravity.z > -2.0/3.0
                break
            }
        }

        if let frequency = frequencies[pressType] {
            synthNode.frequency = upAnOctave ? frequency * octaveMultiplier : frequency
            synthNode.startPlaying()
        }
    }

}
