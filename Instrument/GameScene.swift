//
//  GameScene.swift
//  Instrument
//
//  Created by Andrew Clissold on 9/12/15.
//  Copyright (c) 2015 Andrew Clissold. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class GameScene: SKScene {

    let synth = SineSynth()

    // regular colors!
    let blue = SKColor.blueColor(),
        red = SKColor.redColor(),
        green = SKColor.greenColor(),
        purple = SKColor.purpleColor()

    var ButtonOne = 0,
        ButtonTwo = 0,
        ButtonThree = 0

    // minimalist colors!
    let minimalLightBlue = SKColor(rgba: "#3498db"),
        minimalBlue = SKColor(rgba: "#2980b9")

    var y = 0,
        x = 0,
        WidthOfScreen = 0,
        HeightOfScreen = 0

    override func didMoveToView(view: SKView) {
        WidthOfScreen = Int(view.frame.width)
        HeightOfScreen = Int(view.frame.height)
        makeButtons()

        AKOrchestra.addInstrument(synth)
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

        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)

            let nodes = self.nodesAtPoint(location) as [SKNode]

            for node in nodes {
                if (node.name?.containsString("noteButton") != nil) {
                    // if it's a noteButton....

                    handleNoteStart(node.name!)
                    let spriteNode = node as! SKSpriteNode

                    let changeColorAction = SKAction.colorizeWithColor(minimalLightBlue, colorBlendFactor: 1.0, duration: 0)
                    spriteNode.runAction(changeColorAction) {
                        spriteNode.color = self.minimalLightBlue
                    }

                    let noteCode = getCurrentNoteCode()
                    synth.play(noteCode)
                }
            }
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
            // when user leaves hand from button, turn it back to dark blue

        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)

            let nodes = self.nodesAtPoint(location) as [SKNode]

            for node in nodes {
                if (node.name?.containsString("noteButton") != nil) {
                    // if it's a noteButton....

                    handleNoteEnd(node.name!)

                    let spriteNode = node as! SKSpriteNode

                    let changeColorAction = SKAction.colorizeWithColor(minimalBlue, colorBlendFactor: 1.0, duration: 0)
                    spriteNode.runAction(changeColorAction) {
                        spriteNode.color = self.minimalBlue
                    }

                    synth.stop()
                }
            }
        }
    }


    // ~~~~~~~
    // specialized funcs
    func handleNoteStart(noteName: String) {
        let lastChar = noteName.characters.last!
        if lastChar == "1" {
            ButtonOne = 1
        } else if lastChar == "2" {
            ButtonTwo = 1
        } else if lastChar == "3" {
            ButtonThree = 1
        }
    }

    func handleNoteEnd(noteName: String) {
        let lastChar = noteName.characters.last!
        if lastChar == "1" {
            ButtonOne = 0
        } else if lastChar == "2" {
            ButtonTwo = 0
        } else if lastChar == "3" {
            ButtonThree = 0
        }
    }

    func getCurrentNoteCode() -> Int {
        let NoteCode = ButtonOne * 1 + ButtonTwo * 2 + ButtonThree * 4
        return NoteCode
    }


    func makeButtons() {

        let thinButtonSize = CGSize(width: WidthOfScreen / 3, height: WidthOfScreen / 2),
            wideButtonSize = CGSize(width: WidthOfScreen / 3, height: WidthOfScreen / 2)

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
        x += WidthOfScreen / 3

        node.name = "noteButton"

        if x == WidthOfScreen / 3 {
            // set button to 1 value
            node.name = node.name! + " 1"

        } else if (x > (WidthOfScreen / 2) && x < (3 * WidthOfScreen / 4)) {
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
        let node = SKSpriteNode(color: buttonColor, size: buttonSize)

        node.anchorPoint = CGPoint(x: 0, y: 0)
        // positions it with respect to top left

        node.position = CGPoint(x: x, y: HeightOfScreen - (WidthOfScreen/2) )
        x += WidthOfScreen / 3

        node.name = "noteButton"

        self.addChild(node)
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