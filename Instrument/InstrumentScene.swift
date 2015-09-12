//
//  InstrumentScene.swift
//  Instrument
//
//  Created by Andrew Clissold on 9/12/15.
//  Copyright (c) 2015 Andrew Clissold. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class InstrumentScene: SKScene {

    let synth = SineSynth()
    let noteCodeMappings = [
        1: Note.C4, 2: .D4, 3: .F4, 4: .E4, 5: .G4, 6: .A4, 7: .B4
    ]

    // regular colors!
    let blue = SKColor.blueColor(),
        red = SKColor.redColor(),
        green = SKColor.greenColor(),
        purple = SKColor.purpleColor()

    var buttonOneActive = 0,
        buttonTwoActive = 0,
        buttonThreeActive = 0

    // minimalist colors!
    let minimalLightBlue = SKColor(rgba: "#3498db"),
        minimalBlue = SKColor(rgba: "#2980b9"),
        minimalPurple = SKColor(rgba: "#8e44ad"),
        minimalLightPurple = SKColor(rgba: "#9b59b6")

    var y = 0,
        x = 0,
        screenWidth = 0,
        screenHeight = 0

    override func didMoveToView(view: SKView) {
        screenWidth = Int(view.frame.width)
        screenHeight = Int(view.frame.height)
        makeButtons()

        AKOrchestra.addInstrument(synth)
        synth.play()
    }

    func isEqualColor(color: SKColor, toColor: SKColor) -> Bool {
        let color1Components = CGColorGetComponents(color.CGColor)
        let color2Components = CGColorGetComponents(toColor.CGColor)

        if ((color1Components[0] != color2Components[0]) || //red
            (color1Components[1] != color2Components[1]) || //green
            (color1Components[2] != color2Components[2]) || //blue
            (color1Components[3] != color2Components[3])) { //alpha
                return false
        }

        return true
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // when user touches a button, turn it light blue

        for touch in touches {
            let location = touch.locationInNode(self)

            let nodes = nodesAtPoint(location) as [SKNode]

            for node in nodes {
                if let name = node.name {
                    if name.containsString("noteButton") {
                        // if it's a noteButton....

                        handleNoteStart(name)
                        let spriteNode = node as! SKSpriteNode

                        let changeColorAction = SKAction.colorizeWithColor(minimalLightBlue, colorBlendFactor: 1.0, duration: 0)
                        spriteNode.runAction(changeColorAction) {
                            spriteNode.color = self.minimalLightBlue
                        }

                        if let noteCode = getCurrentNoteCode() {
                            guard let note = noteCodeMappings[noteCode] else {
                                fatalError("unexpected note code: \(noteCode)")
                            }
                            synth.note = note
                            synth.mute(false)
                        }
                    } else if (node.name?.containsString("topButton") != nil) {
                        let spriteNode = node as! SKSpriteNode
                        let changeColorAction = SKAction.colorizeWithColor(minimalLightPurple, colorBlendFactor: 1.0, duration: 0)

                        spriteNode.runAction(changeColorAction) {
                            spriteNode.color = self.minimalLightPurple
                        }
                    }
                    updateSynthNote()
                }
            }
        }
    }

    func updateSynthNote() {
        if let noteCode = getCurrentNoteCode() {
            guard let note = noteCodeMappings[noteCode] else {
                fatalError("unexpected note code: \(noteCode)")
            }
            synth.note = note
            synth.mute(false)
        } else {
            synth.mute(true)
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // when user leaves hand from button, turn it back to dark blue

        for touch in touches {
            let location = touch.locationInNode(self)

            let nodes = nodesAtPoint(location) as [SKNode]

            for node in nodes {
                if let name = node.name {
                    if name.containsString("noteButton") {
                        // if it's a noteButton....

                        handleNoteEnd(name)

                        let spriteNode = node as! SKSpriteNode

                        let changeColorAction = SKAction.colorizeWithColor(minimalBlue, colorBlendFactor: 1.0, duration: 0)
                        spriteNode.runAction(changeColorAction) {
                            spriteNode.color = self.minimalBlue
                        }

                    } else if name.containsString("topButton") {
                        let spriteNode = node as! SKSpriteNode
                        let changeColorAction = SKAction.colorizeWithColor(minimalPurple, colorBlendFactor: 1.0, duration: 0)

                        spriteNode.runAction(changeColorAction) {
                            spriteNode.color = self.minimalPurple
                        }
                    }
                    updateSynthNote()
                }
            }
        }
    }


    // ~~~~~~~
    // specialized funcs
    func handleNoteStart(noteName: String) {
        switch noteName.characters.last! {
        case "1":
            buttonOneActive = 1
        case "2":
            buttonTwoActive = 1
        case "3":
            buttonThreeActive = 1
        default:
            fatalError("unexpected noteName: \(noteName)")
        }
    }

    func handleNoteEnd(noteName: String) {
        switch noteName.characters.last! {
        case "1":
            buttonOneActive = 0
        case "2":
            buttonTwoActive = 0
        case "3":
            buttonThreeActive = 0
        default:
            fatalError("unexpected noteName: \(noteName)")
        }
    }

    func getCurrentNoteCode() -> Int? {
        let noteCode = buttonOneActive * 1 + buttonTwoActive * 2 + buttonThreeActive * 4
        if noteCode == 0 {
            return nil
        }
        return noteCode
    }

    func makeButtons() {
        let thinButtonSize = CGSize(width: screenWidth / 3, height: screenWidth / 2),
            wideButtonSize = CGSize(width: screenWidth / 3, height: screenWidth / 2)

        // ~~~~~
        // bottom buttons
        makeBottomButton(minimalBlue, buttonSize: thinButtonSize)
        makeBottomButton(minimalBlue, buttonSize: thinButtonSize)
        makeBottomButton(minimalBlue, buttonSize: thinButtonSize)

        // ~~~~~
        // top buttons

        x = 0
        // start back at left of screen

        makeTopButton(minimalBlue, buttonSize: wideButtonSize)
        makeTopButton(minimalBlue, buttonSize: wideButtonSize)
    }


    func makeBottomButton(buttonColor: SKColor, buttonSize: CGSize) -> SKSpriteNode {
        let node = SKSpriteNode(color: buttonColor, size: buttonSize)

        node.anchorPoint = CGPoint(x: 0, y: 0)
        // positions it with respect to bottom left

        node.position = CGPoint(x: x, y: 0)
        x += screenWidth / 3

        node.name = "noteButton"

        if x == screenWidth / 3 {
            // set button to 1 value
            node.name = node.name! + " 1"
        } else if (x > (screenWidth / 2) && x < (3 * screenWidth / 4)) {
            // set button to 2 value
            node.name = node.name! + " 2"
        } else {
            // set button to 3 value
            node.name = node.name! + " 3"
        }

        self.addChild(node)
        return node
    }

    func makeTopButton(buttonColor: SKColor, buttonSize: CGSize) {
        let anchorPoint = CGPoint(x: 0, y: 0)
        let position = CGPoint(x: x, y: screenHeight - (screenWidth/2))

        // ~~~~
        // color node
        let colorNode = SKSpriteNode(color: minimalPurple, size: buttonSize)
        colorNode.anchorPoint = anchorPoint
        // positions it with respect to top left

        colorNode.position = position
        x += screenWidth / 3

        colorNode.name = "topButton"

        // ~~~~
        // image node
        let imageName: String
        if x == screenWidth / 3 {
            imageName = "flat"
        } else {
            imageName = "sharp"
        }

        let imageNode = SKSpriteNode(texture: SKTexture(imageNamed: imageName), size: buttonSize)
        imageNode.anchorPoint = anchorPoint
        imageNode.position = position

        self.addChild(colorNode)
        self.addChild(imageNode)
    }

}

// functions to grab minimalist colors!!
extension SKColor {
    convenience init(rgba: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0

        if rgba.hasPrefix("#") {
            let index   = rgba.startIndex.advancedBy(1)
            let hex     = rgba.substringFromIndex(index)
            let scanner = NSScanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexLongLong(&hexValue) {
                if hex.characters.count == 6 {
                    red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)  / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF) / 255.0
                } else if hex.characters.count == 8 {
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                } else {
                    print("invalid rgb string, length should be 7 or 9", terminator: "")
                }
            } else {
                print("scan hex error")
            }
        } else {
            print("invalid rgb string, missing '#' as prefix", terminator: "")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}
