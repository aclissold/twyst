//
//  ButtonNode.swift
//  Twyst
//
//  Created by Andrew Clissold on 9/13/15.
//  Copyright © 2015 Andrew Clissold. All rights reserved.
//

import SpriteKit

class ButtonNode: SKSpriteNode {

    let type: ButtonNodeType

    var active = false {
        didSet {
            guard active else {
                texture = restingTexture
                return
            }

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
        }
    }

    var restingTexture: SKTexture {
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

    init(type: ButtonNodeType) {
        self.type = type
        super.init(texture: nil, color: SKColor.clearColor(), size: CGSizeZero)
        texture = restingTexture
        userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        active = true
        (parent as? TwystPhoneScene)?.buttonTapped(self)
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        active = false
        (parent as? TwystPhoneScene)?.buttonTapped(self)
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let parent = parent as? TwystPhoneScene else {
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
