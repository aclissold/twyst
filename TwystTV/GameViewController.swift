//
//  GameViewController.swift
//  TwystTV
//
//  Created by Andrew Clissold on 10/16/15.
//  Copyright (c) 2015 Andrew Clissold. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let view = view as? SKView else {
            return
        }

        let scene = TwystTVScene(size: view.frame.size)

        view.ignoresSiblingOrder = true

        let showDebugOverlay = false
        view.showsFPS = showDebugOverlay
        view.showsNodeCount = showDebugOverlay

        scene.scaleMode = .AspectFill
        scene.backgroundColor = SKColor(rgba: "#2c3e50")

        view.presentScene(scene)
    }

    override func viewDidLayoutSubviews() {
    }

}
