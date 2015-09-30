//
//  SineSynth.swift
//  Twyst
//
//  Created by Andrew Clissold on 9/12/15.
//  Copyright © 2015 Andrew Clissold. All rights reserved.
//

class SineSynth: AKInstrument {

    private let vibratoMultiplier: Float = 6
    private var muted = true

    var note = Note.C4 {
        didSet {
            frequency.value = note.rawValue
        }
    }
    var vibrato: Float = 0 {
        didSet {
            frequency.value = note.rawValue + vibratoMultiplier*vibrato
        }
    }
    var force: Float = 1 {
        didSet {
            amplitude.value = muted ? 0 : force * 0.7
        }
    }

    private var frequency = AKInstrumentProperty(value: 440, minimum: 220, maximum: 880)
    private var amplitude = AKInstrumentProperty(value: 0, minimum: 0, maximum: 1)

    override init() {
        super.init()

        addProperty(frequency)
        addProperty(amplitude)

        let oscillator = AKFMOscillator()
        oscillator.waveform = AKTable.standardSineWave()
        oscillator.baseFrequency = frequency
        oscillator.amplitude = amplitude

        setAudioOutput(oscillator)
    }

    func mute(shouldMute: Bool) {
        muted = shouldMute
        amplitude.value = shouldMute ? 0 : force * 0.7
    }
}
