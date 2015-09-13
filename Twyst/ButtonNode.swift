//
//  ButtonNode.swift
//  Twyst
//
//  Created by Andrew Clissold on 9/13/15.
//  Copyright © 2015 Andrew Clissold. All rights reserved.
//

import SpriteKit

enum ButtonNodeType {
    case Flat, Sharp, One, Two, Three
}

private func restingTexture(type: ButtonNodeType) -> SKTexture {
    let imageName: String
    switch type {
    case .Flat:
        imageName = "flatImage"
    case .Sharp:
        imageName = "sharpImage"
    case .One, .Two, .Three:
        imageName = "buttonOneImage"
    }
    return SKTexture(imageNamed: imageName)
}

class ButtonNode: SKSpriteNode {

    var active = false
    let type: ButtonNodeType

    init(type: ButtonNodeType, size: CGSize) {
        self.type = type
        let texture = restingTexture(type)
        super.init(texture: texture, color: SKColor.clearColor(), size: size)
        userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        active = true

        let imageName: String
        switch type {
        case .Flat:
            imageName = "flatImage_active"
        case .Sharp:
            imageName = "sharpImage_active"
        case .One:
            imageName = "buttonOneImage_active"
        case .Two:
            imageName = "buttonTwoImage_active"
        case .Three:
            imageName = "buttonThreeImage_active"
        }
        texture = SKTexture(imageNamed: imageName)
        name = imageName

        (parent as! TwystScene).buttonTapped(self)
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        active = false

        let imageName: String
        switch type {
        case .Flat:
            imageName = "flatImage"
        case .Sharp:
            imageName = "sharpImage"
        case .One, .Two, .Three:
            imageName = "buttonOneImage"
        }
        texture = SKTexture(imageNamed: imageName)
        name = imageName

        (parent as! TwystScene).buttonTapped(self)
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let touchIsInside = containsPoint(touch.locationInNode(parent!))
            let touchWasInside = containsPoint(touch.previousLocationInNode(parent!))

            let touchMovedInside = touchIsInside && !touchWasInside
            let touchMovedOutside = !touchIsInside && touchWasInside

            if touchMovedInside {
                active = true
                (parent as! TwystScene).buttonTapped(self)
            } else if touchMovedOutside {
                active = false
                (parent as! TwystScene).buttonTapped(self)
            }
        }
    }

}
