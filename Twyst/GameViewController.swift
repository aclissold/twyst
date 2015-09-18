//
//  GameViewController.swift
//  Twyst
//
//  Created by Andrew Clissold on 9/12/15.
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

        let scene = TwystScene(size: view.frame.size)
//        view.showsFPS = true
//        view.showsNodeCount = true
        view.ignoresSiblingOrder = true
        view.multipleTouchEnabled = true

        scene.scaleMode = .AspectFill
        scene.backgroundColor = SKColor(rgba: "#2c3e50")

        view.presentScene(scene)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
