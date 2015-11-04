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
    var spriteNode: SKSpriteNode!

    var active = false {
        didSet {
            guard active else {
                spriteNode.texture = restingTexture
                return
            }

            let imageName: String
            switch type {
            case .Flat:
                imageName = "Flat Active"
            case .Sharp:
                imageName = "Sharp Active"
            case .One:
                imageName = "One Active"
            case .Two:
                imageName = "Two Active"
            case .Three:
                imageName = "Three Active"
            }
            spriteNode.texture = SKTexture(imageNamed: imageName)
        }
    }

    var restingTexture: SKTexture {
        let imageName: String
        switch type {
        case .Flat:
            imageName = "Flat"
        case .Sharp:
            imageName = "Sharp"
        case .One, .Two, .Three:
            imageName = "Note"
        }
        return SKTexture(imageNamed: imageName)
    }

    init(type: ButtonNodeType) {
        self.type = type

        super.init(texture: nil, color: UIColor.clearColor(), size: CGSizeZero)

        self.spriteNode = SKSpriteNode(texture: restingTexture)
        addChild(spriteNode)
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
