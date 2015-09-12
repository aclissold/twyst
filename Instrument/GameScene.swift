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

    // regular colors!
    let blue = SKColor.blueColor(),
        red = SKColor.redColor(),
        green = SKColor.greenColor(),
        purple = SKColor.purpleColor()


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
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {

    }


    // ~~~~~~~
    // specialized funcs

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


    func makeBottomButton(buttonColor: SKColor, buttonSize: CGSize) {
        var node = SKSpriteNode(color: buttonColor, size: buttonSize)

        node.anchorPoint = CGPoint(x: 0, y: 0)
            // positions it with respect to bottom left

        node.position = CGPoint(x: x, y: 0)
        x += WidthOfScreen / 3

        self.addChild(node)
    }

    func makeTopButton(buttonColor: SKColor, buttonSize: CGSize) {
        var node = SKSpriteNode(color: buttonColor, size: buttonSize)

        node.anchorPoint = CGPoint(x: 0, y: 0)
        // positions it with respect to top left

        node.position = CGPoint(x: x, y: HeightOfScreen - (WidthOfScreen/2) )
        x += WidthOfScreen / 3

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
            let index   = advance(rgba.startIndex, 1)
            let hex     = rgba.substringFromIndex(index)
            let scanner = NSScanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexLongLong(&hexValue) {
                if countElements(hex) == 6 {
                    red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)  / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF) / 255.0
                } else if countElements(hex) == 8 {
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                } else {
                    print("invalid rgb string, length should be 7 or 9")
                }
            } else {
                println("scan hex error")
            }
        } else {
            print("invalid rgb string, missing '#' as prefix")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}