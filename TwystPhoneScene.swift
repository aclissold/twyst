//
//  TwystPhoneScene.swift
//  Twyst
//
//  Created by Andrew Clissold on 10/16/15.
//  Copyright © 2015 Andrew Clissold. All rights reserved.
//

import CoreMotion

class TwystPhoneScene: TwystScene {

    let motionManager = CMMotionManager()

    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)

        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue()) { (deviceMotion, error) in
            if let error = error {
                print("error retrieving device motion: \(error.localizedDescription)")
                return
            }

            if let g = deviceMotion?.gravity {
                let wasUpAnOctave = self.upAnOctave
                self.upAnOctave = g.x > 0.666
                if (wasUpAnOctave && !self.upAnOctave)
                    || (!wasUpAnOctave && self.upAnOctave) {
                        self.triggerUpdate()
                }
            }

            if let a = deviceMotion?.userAcceleration {
                self.vibrato = CGFloat(a.x + a.y + a.z)
            }
        }
    }

}
