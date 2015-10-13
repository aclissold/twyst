//
//  SineSynth.swift
//  Twyst
//
//  Created by Andrew Clissold on 9/12/15.
//  Copyright © 2015 Andrew Clissold. All rights reserved.
//

class SineSynth {

    private let vibratoMultiplier: Float = 6

    var note = Note.C4 {
        didSet {
            frequency = note.rawValue
        }
    }
    var vibrato: Float = 0 {
        didSet {
            frequency = note.rawValue + vibratoMultiplier*vibrato
        }
    }

    private var frequency: Float = 440.0
    private var amplitude: Float = 0.0

    init() {
//        TODO
//        let oscillator = AKFMOscillator()
//        oscillator.waveform = AKTable.standardSineWave()
//        oscillator.baseFrequency = frequency
//        oscillator.amplitude = amplitude
//
//        setAudioOutput(oscillator)
    }

    func mute(shouldMute: Bool) {
        amplitude = shouldMute ? 0 : 0.7
    }
}
