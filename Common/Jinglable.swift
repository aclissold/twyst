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

    func playNote(note: Note)
    func stopPlaying()

    func playJingle(type: Jingle, done: (() -> ())?)
}

extension Jinglable {
    func playJingle(type: Jingle, done: (() -> ())?) {
        switch type {
        case .Phone:
            playPhoneJingle(done)
        case .TV:
            playTVJingle(done)
        }
    }

    private func playPhoneJingle(done: (() -> ())?) {
        // Arbitrarily divided into multiple expressions to work around the compiler giving up.
        let chromatic1: [SKAction] = [
            SKAction.waitForDuration(4*quarterNoteDuration),
            SKAction.runBlock { self.playNote(.C) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.Cs) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.D) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.Ds) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.E) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.F) },
            SKAction.waitForDuration(quarterNoteDuration),
        ]
        let chromatic2: [SKAction] = [
            SKAction.runBlock { self.playNote(.Fs) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.G) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.Gs) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.A) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.As) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.B) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.upAnOctave = true },
            SKAction.runBlock { self.playNote(.C) },
            SKAction.waitForDuration(2*quarterNoteDuration),
            SKAction.runBlock { self.stopPlaying() },
            SKAction.waitForDuration(2*quarterNoteDuration),
        ]
        let scale: [SKAction] = [
            SKAction.runBlock { self.playNote(.C) },
            SKAction.waitForDuration(2*quarterNoteDuration),
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
            SKAction.runBlock { self.playNote(.C5) },
            SKAction.waitForDuration(2*quarterNoteDuration),
            SKAction.runBlock { self.playNote(.C) },
            SKAction.waitForDuration(2*quarterNoteDuration),
            SKAction.runBlock { self.stopPlaying() },
            SKAction.waitForDuration(3*quarterNoteDuration),
        ]
        let jingle1: [SKAction] = [
            SKAction.runBlock { self.playNote(.G) },
            SKAction.waitForDuration(4*quarterNoteDuration),
            SKAction.runBlock { self.playNote(.F) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.E) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.stopPlaying() },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.E) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.F) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.Af) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.stopPlaying() },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.G) },
        ]
        let jingle2: [SKAction] = [
            SKAction.waitForDuration(3*quarterNoteDuration),
            SKAction.runBlock { self.playNote(.Af) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.G) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.F) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.E) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.stopPlaying() },
            SKAction.waitForDuration(1/2*quarterNoteDuration),
            SKAction.runBlock { self.playNote(.F) },
            SKAction.waitForDuration(1/2*quarterNoteDuration),
            SKAction.runBlock { self.playNote(.E) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.Df) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.E) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.Df) },
        ]
        let jingle3: [SKAction] = [
            SKAction.waitForDuration(5/2*quarterNoteDuration),
            SKAction.runBlock { self.stopPlaying() },
            SKAction.waitForDuration(1/2*quarterNoteDuration),
            SKAction.runBlock { self.playNote(.C) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.stopPlaying() },
            SKAction.waitForDuration(1/2*quarterNoteDuration),
            SKAction.runBlock { self.playNote(.Df) },
            SKAction.waitForDuration(1/2*quarterNoteDuration),
            SKAction.runBlock { self.playNote(.C) },
            SKAction.waitForDuration(1/2*quarterNoteDuration),
            SKAction.runBlock { self.stopPlaying() },
            SKAction.waitForDuration(1/2*quarterNoteDuration),
            SKAction.runBlock { self.upAnOctave = false },
            SKAction.runBlock { self.playNote(.G) },
            SKAction.waitForDuration(1/2*quarterNoteDuration),
            SKAction.runBlock { self.upAnOctave = true },
            SKAction.runBlock { self.stopPlaying() },
            SKAction.waitForDuration(1/2*quarterNoteDuration),
            SKAction.runBlock { self.playNote(.C) },
            SKAction.waitForDuration(3*quarterNoteDuration),
            SKAction.runBlock { self.stopPlaying() },
            SKAction.runBlock { done?() }
        ]

        var sequence = chromatic1
        sequence += chromatic2
        sequence += scale
        sequence += jingle1
        sequence += jingle2
        sequence += jingle3
        synthNode.runAction(SKAction.sequence(sequence))
    }

    private func playTVJingle(done: (() -> ())?) {
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
            SKAction.waitForDuration(1/2*quarterNoteDuration),
            SKAction.runBlock { self.playNote(.E) },
            SKAction.waitForDuration(1/2*quarterNoteDuration),
            SKAction.runBlock { self.playNote(.F) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.D) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.C) },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.upAnOctave = false },
            SKAction.waitForDuration(quarterNoteDuration),
            SKAction.runBlock { self.playNote(.C) },
            SKAction.waitForDuration(quarterNoteDuration),

            // Reset
            SKAction.runBlock { done?() }
        ]))
    }
}
