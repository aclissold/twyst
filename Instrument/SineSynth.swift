//
//  SineSynth.swift
//  Instrument
//
//  Created by Andrew Clissold on 9/12/15.
//  Copyright © 2015 Andrew Clissold. All rights reserved.
//

class SineSynth: AKInstrument {

    var frequency = AKInstrumentProperty(value: 440, minimum: 220, maximum: 880)

    override init() {
        super.init()

        addProperty(frequency)

        let oscillator = AKFMOscillator()
        oscillator.waveform = AKTable.standardSineWave()
        oscillator.baseFrequency = frequency
        oscillator.amplitude = 0.2.ak

        setAudioOutput(oscillator)
    }
}
