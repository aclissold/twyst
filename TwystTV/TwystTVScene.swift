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
    let animationDuration = 0.4

    var controller: GCController?
    var dpadActive = false
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

    let wordmarkActiveNode = SKSpriteNode(imageNamed: "Wordmark Active")
    let upButtonNode = SKSpriteNode(imageNamed: "Up")
    let downButtonNode = SKSpriteNode(imageNamed: "Down")
    let leftButtonNode = SKSpriteNode(imageNamed: "Left")
    let rightButtonNode = SKSpriteNode(imageNamed: "Right")
    let centerButtonNode = SKSpriteNode(imageNamed: "Center")
    let playPauseButtonNode = SKSpriteNode(imageNamed: "PlayPause")
    let bothLeftNode = SKSpriteNode(imageNamed: "Both Left")
    let bothRightNode = SKSpriteNode(imageNamed: "Both Right")

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

        addButtonNodes()
    }

    override func addWordmarkNode() {
        super.addWordmarkNode()

        wordmarkActiveNode.position = wordmarkNode.position
        wordmarkActiveNode.alpha = 0
        wordmarkActiveNode.zPosition = 1

        addChild(wordmarkActiveNode)
    }

    func addButtonNodes() {
        let touchpadPosition = CGPoint(
            x: (screenWidth/2 - wordmarkNode.frame.size.width/2)/2,
            y: wordmarkNode.position.y)
        let playPausePosition = CGPoint(
            x: screenWidth - (screenWidth/2 - wordmarkNode.frame.size.width/2)/2,
            y: wordmarkNode.position.y)

        let touchpadOutlineNode = SKSpriteNode(imageNamed: "Touchpad Outline")
        touchpadOutlineNode.position = touchpadPosition
        addChild(touchpadOutlineNode)

        let playPauseOutlineNode = SKSpriteNode(imageNamed: "PlayPause Outline")
        playPauseOutlineNode.position = playPausePosition
        addChild(playPauseOutlineNode)

        for buttonNode in [upButtonNode, downButtonNode, leftButtonNode, rightButtonNode, centerButtonNode, bothLeftNode] {
            buttonNode.position = touchpadPosition
            buttonNode.alpha = 0
            addChild(buttonNode)
        }

        for buttonNode in [playPauseButtonNode, bothRightNode] {
            buttonNode.position = playPausePosition
            buttonNode.alpha = 0
            addChild(buttonNode)
        }
    }

    override func update(currentTime: NSTimeInterval) {
        if let gravity = self.controller?.motion?.gravity
            where upAnOctave != (gravity.z > -2.0/3.0) {
                upAnOctave = !upAnOctave

                if upAnOctave {
                    wordmarkActiveNode.runAction(
                        SKAction.fadeInWithDuration(0.4*animationDuration),
                        withKey: "Wordmark Active")
                } else {
                    wordmarkActiveNode.runAction(
                        SKAction.fadeOutWithDuration(0.4*animationDuration),
                        withKey: "Wordmark Active")
                }
        }

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
        self.controller = notification.object as? GCController
        self.controller?.microGamepad?.reportsAbsoluteDpadValues = true
        self.controller?.microGamepad?.valueChangedHandler = { (gamepad, element) in
            if element == gamepad.dpad {
                self.handleDpad(element as! GCControllerDirectionPad)
            } else if element == gamepad.buttonA {
                self.handleButtonA(element as! GCControllerButtonInput)
            } else if element == gamepad.buttonX {
                self.handleButtonX(element as! GCControllerButtonInput)
            }
        }
    }

    func handleDpad(dpad: GCControllerDirectionPad) {
        if !dpad.up.pressed
            && !dpad.down.pressed
            && !dpad.left.pressed
            && !dpad.right.pressed {
                self.dpadActive = false
                return
        }
        if self.dpadActive {
            return
        }
        self.dpadActive = true

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
        }
    }

    func handleButtonA(button: GCControllerButtonInput) {
        if button.pressed && buttonXPending {
            buttonXPending = false
            buttonPressed(.Menu)
        } else if button.pressed {
            buttonAPending = true
            eventDate = NSDate()
        }
    }

    func handleButtonX(button: GCControllerButtonInput) {
        if button.pressed && buttonAPending {
            buttonAPending = false
            buttonPressed(.Menu)
        } else if button.pressed {
            buttonXPending = true
            eventDate = NSDate()
        }
    }

    func buttonPressed(pressType: UIPressType) {
        if let frequency = frequencies[pressType] {
            synthNode.frequency = upAnOctave ? frequency * octaveMultiplier : frequency
            synthNode.startPlaying()
        }

        animateButtonNode(pressType)
    }

    func animateButtonNode(pressType: UIPressType) {
        let buttonNode: SKSpriteNode
        switch pressType {
        case .UpArrow: buttonNode = leftButtonNode
        case .DownArrow: buttonNode = rightButtonNode
        case .LeftArrow: buttonNode = downButtonNode
        case .RightArrow: buttonNode = upButtonNode
        case .PlayPause: buttonNode = playPauseButtonNode
        case .Select: buttonNode = centerButtonNode
        case .Menu:
            bothLeftNode.alpha = 1
            bothLeftNode.runAction(
                SKAction.fadeOutWithDuration(animationDuration),
                withKey: "\(UIPressType.Select.hashValue)")
            bothRightNode.alpha = 1
            bothRightNode.runAction(
                SKAction.fadeOutWithDuration(animationDuration),
                withKey: "\(UIPressType.PlayPause.hashValue)")
            return
        }
        buttonNode.alpha = 1
        buttonNode.runAction(
            SKAction.fadeOutWithDuration(animationDuration),
            withKey: "\(pressType.hashValue)")
    }

}
