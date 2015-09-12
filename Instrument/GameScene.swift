//
//  GameScene.swift
//  Instrument
//
//  Created by Andrew Clissold on 9/12/15.
//  Copyright (c) 2015 Andrew Clissold. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    let blue = SKColor.blueColor(),
        red = SKColor.redColor(),
        green = SKColor.greenColor(),
        purple = SKColor.purpleColor()

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

        let thinButtonSize = CGSize(width: WidthOfScreen / 4, height: WidthOfScreen / 2),
            wideButtonSize = CGSize(width: WidthOfScreen / 2, height: WidthOfScreen / 2)

        // ~~~~~
        // bottom buttons
        makeBottomButton(blue, buttonSize: thinButtonSize)
        makeBottomButton(red, buttonSize: thinButtonSize)
        makeBottomButton(green, buttonSize: thinButtonSize)
        makeBottomButton(purple, buttonSize: thinButtonSize)

        // ~~~~~
        // top buttons

        x = 0
            // start back at left of screen

        makeTopButton(blue, buttonSize: wideButtonSize)
        makeTopButton(red, buttonSize: wideButtonSize)
    }


    func makeBottomButton(buttonColor: SKColor, buttonSize: CGSize) {
        var node = SKSpriteNode(color: buttonColor, size: buttonSize)

        node.anchorPoint = CGPoint(x: 0, y: 0)
            // positions it with respect to bottom left

        node.position = CGPoint(x: x, y: 0)
        x += WidthOfScreen / 4

        self.addChild(node)
    }

    func makeTopButton(buttonColor: SKColor, buttonSize: CGSize) {
        var node = SKSpriteNode(color: buttonColor, size: buttonSize)

        node.anchorPoint = CGPoint(x: 0, y: 0)
        // positions it with respect to top left

        node.position = CGPoint(x: x, y: HeightOfScreen - (WidthOfScreen/2) )
        x += WidthOfScreen / 2

        self.addChild(node)
    }
}
