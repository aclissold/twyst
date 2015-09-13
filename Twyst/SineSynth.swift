//
//  SineSynth.swift
//  Twyst
//
//  Created by Andrew Clissold on 9/12/15.
//  Copyright © 2015 Andrew Clissold. All rights reserved.
//

class SineSynth: AKInstrument {

    var note = Note.C4 {
        didSet {
            frequency.value = note.rawValue
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
        amplitude.value = shouldMute ? 0 : 0.7
    }
}
