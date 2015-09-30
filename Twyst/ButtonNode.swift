//
//  ButtonNode.swift
//  Twyst
//
//  Created by Andrew Clissold on 9/13/15.
//  Copyright © 2015 Andrew Clissold. All rights reserved.
//

import SpriteKit

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

    private var currentTouches = Set<UITouch>()

    var currentForce: Float {
        guard #available(iOS 9.0, *) else { return 1 }
        if currentTouches.isEmpty { return 0 }

        var totalForce: CGFloat = 0
        var totalMaximumPossibleForce: CGFloat = 0
        for touch in currentTouches {
            totalForce += touch.force
            totalMaximumPossibleForce += touch.maximumPossibleForce
        }

        if totalForce == 0 && totalMaximumPossibleForce == 0 {
            return 1
        } else {
            return Float(totalForce / totalMaximumPossibleForce)
        }
    }

    init(type: ButtonNodeType, size: CGSize) {
        self.type = type
        let texture = restingTexture(type)
        super.init(texture: texture, color: SKColor.clearColor(), size: size)
        userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        self.type = ButtonNodeType.One
        let texture = restingTexture(type)
        super.init(texture: texture, color: SKColor.clearColor(), size: CGSize(width: 10, height: 10))
        userInteractionEnabled = true
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        active = true

        currentTouches.unionInPlace(touches)

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

        (parent as? TwystScene)?.buttonTapped(self)
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        active = false

        currentTouches.subtractInPlace(touches)

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

        (parent as? TwystScene)?.buttonTapped(self)
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let parent = parent as? TwystScene else {
            return
        }

        for touch in touches {
            let touchIsInside = containsPoint(touch.locationInNode(parent))
            let touchWasInside = containsPoint(touch.previousLocationInNode(parent))

            let touchMovedInside = touchIsInside && !touchWasInside
            let touchMovedOutside = !touchIsInside && touchWasInside

            if touchMovedInside {
                active = true
                parent.buttonTapped(self)
            } else if touchMovedOutside {
                active = false
                parent.buttonTapped(self)
            }
        }
    }

}
