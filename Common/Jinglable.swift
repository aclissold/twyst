//
//  Jinglable.swift
//  Twyst
//
//  Created by Andrew Clissold on 10/24/15.
//  Copyright © 2015 Andrew Clissold. All rights reserved.
//

enum Jingle {
    case Phone, TV
}

protocol Jinglable: class {
    var synthNode: SynthNode { get }
    var quarterNoteDuration: Double { get }
    var upAnOctave: Bool { get set }

    func playNote(name: Note)
    func playJingle(type: Jingle, done: () -> ())
}

extension Jinglable {
    func playJingle(type: Jingle, done: () -> ()) {
        switch type {
        case .Phone:
            playPhoneJingle(done)
        case .TV:
            playTVJingle(done)
        }
    }

    private func playPhoneJingle(done: () -> ()) {

    }

    private func playTVJingle(done: () -> ()) {
        synthNode.runAction(SKAction.sequence([
            // First octave
            SKAction.waitForDuration(4*quarterNoteDuration),
            SKAction.runBlock { self.playNote(.C) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.D) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.E) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.F) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.G) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.A) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.B) },
            SKAction.waitForDuration(quarterNoteDuration),

            // Second octave
            SKAction.runBlock { self.upAnOctave = true },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.C) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.D) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.E) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.F) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.G) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.A) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.B) },
            SKAction.waitForDuration(2*quarterNoteDuration),

            // Jingle
            SKAction.runBlock { self.playNote(.B) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.G) },
            SKAction.waitForDuration((1/2)*quarterNoteDuration),
            SKAction.runBlock { self.playNote(.E) },
            SKAction.waitForDuration((1/2)*quarterNoteDuration),
            SKAction.runBlock { self.playNote(.F) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.D) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.C) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.upAnOctave = false },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.C) },
            SKAction.waitForDuration(2*quarterNoteDuration),

            // Reset
            SKAction.runBlock { done() }
        ]))
    }
}
