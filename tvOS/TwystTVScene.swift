//
//  TwystTVScene.swift
//  Twyst
//
//  Created by Andrew Clissold on 10/16/15.
//  Copyright © 2015 Andrew Clissold. All rights reserved.
//

import GameController

class TwystTVScene: TwystScene, Jinglable {

    var quarterNoteDuration: Double { return 0.4 }

    var controller: GCController?
    var dpadActive = false
    var buttonAPending = false
    var buttonXPending = false

    override var upAnOctave: Bool {
        didSet {
            if upAnOctave && !oldValue {
                wordmarkActiveNode.runAction(
                    SKAction.fadeInWithDuration(0.4*quarterNoteDuration),
                    withKey: "Wordmark Active")
            } else if !upAnOctave && oldValue {
                wordmarkActiveNode.runAction(
                    SKAction.fadeOutWithDuration(0.4*quarterNoteDuration),
                    withKey: "Wordmark Active")
            }
        }
    }

    let notes: [UIPressType: Note] = [
        .UpArrow: .D,
        .DownArrow: .F,
        .LeftArrow: .C,
        .RightArrow: .E,
        .PlayPause: .G,
        .Select: .A,
        .Menu: .B // really .PlayPause + .Select
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

        updateDelay = 0.03
        synthNode.synthType = .SineTink

        noteLabelNode.fontSize = 156
        noteLabelNode.position = CGPoint(
            x: (1/2)*screenWidth,
            y: (1/8)*screenHeight)

        addButtonNodes()

        runDemoIfNecessary()
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
            where upAnOctave != (gravity.z > -2.0/3.0) && demoFinished {
                upAnOctave = !upAnOctave
        }

        if (buttonAPending || buttonXPending) && abs(eventDate.timeIntervalSinceNow) > updateDelay {
            completePendingUpdate()
        }
    }

    override func completePendingUpdate() {
        if buttonAPending && buttonXPending {
            playNote(.B)
            buttonAPending = false
            buttonXPending = false
        } else if buttonAPending {
            playNote(.A)
            buttonAPending = false
        } else if buttonXPending {
            playNote(.G)
            buttonXPending = false
        }
    }

    func controllerDidConnect(notification: NSNotification) {
        self.controller = notification.object as? GCController
        self.controller?.microGamepad?.reportsAbsoluteDpadValues = true
        self.controller?.microGamepad?.valueChangedHandler = { (gamepad, element) in
            if !self.demoFinished {
                return
            }

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
        var note = Note.C

        let up = dpad.up.value
        let down = dpad.down.value
        let left = dpad.left.value
        let right = dpad.right.value

        if left > max {
            max = left
            note = .C
        }
        if up > max {
            max = up
            note = .D
        }
        if right > max {
            max = right
            note = .E
        }
        if down > max {
            max = down
            note = .F
        }

        if max > threshold {
            self.playNote(note)
        }
    }

    func handleButtonA(button: GCControllerButtonInput) {
        if button.pressed && buttonXPending {
            buttonXPending = false
            playNote(.B)
        } else if button.pressed {
            buttonAPending = true
            eventDate = NSDate()
        }
    }

    func handleButtonX(button: GCControllerButtonInput) {
        if button.pressed && buttonAPending {
            buttonAPending = false
            playNote(.B)
        } else if button.pressed {
            buttonXPending = true
            eventDate = NSDate()
        }
    }

    func playNote(note: Note) {
        let frequency = note.rawValue
        synthNode.frequency = upAnOctave ? frequency*octaveMultiplier : frequency
        synthNode.startPlaying()

        animateButtonNode(note)
        animateNoteLabelNode(note)
    }

    func stopPlaying() {
        synthNode.stopPlaying()
        noteLabelNode.text = ""
    }

    func animateButtonNode(note: Note) {
        let buttonNode: SKSpriteNode
        switch note {
        case .C: buttonNode = downButtonNode
        case .D: buttonNode = leftButtonNode
        case .E: buttonNode = upButtonNode
        case .F: buttonNode = rightButtonNode
        case .G: buttonNode = playPauseButtonNode
        case .A: buttonNode = centerButtonNode
        case .B:
            bothLeftNode.alpha = 1
            bothLeftNode.runAction(
                SKAction.fadeOutWithDuration(quarterNoteDuration),
                withKey: "\(UIPressType.Select.hashValue)")
            bothRightNode.alpha = 1
            bothRightNode.runAction(
                SKAction.fadeOutWithDuration(quarterNoteDuration),
                withKey: "\(UIPressType.PlayPause.hashValue)")
            return
        default:
            return
        }
        buttonNode.alpha = 1
        buttonNode.runAction(
            SKAction.fadeOutWithDuration(quarterNoteDuration),
            withKey: "\(note.rawValue)")
    }

    func animateNoteLabelNode(note: Note) {
        noteLabelNode.text = note.description
        noteLabelNode.alpha = 1
        noteLabelNode.runAction(SKAction.sequence([
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.fadeOutWithDuration(quarterNoteDuration)
        ]), withKey: "Animate Note Label Node")
    }

    func runDemoIfNecessary() {
        if NSUserDefaults.standardUserDefaults().boolForKey(ranDemoKey) {
            demoFinished = true
            return
        }

        playJingle(.TV) {
            self.demoFinished = true
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: self.ranDemoKey)
        }
    }

}
