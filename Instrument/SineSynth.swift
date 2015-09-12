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

        let adsr = AKADSREnvelope(
            attackDuration: 0.1.ak,
            decayDuration: 0.5.ak,
            sustainLevel: 0.2.ak,
            releaseDuration: 0.1.ak,
            delay: 0.ak
        )

        let oscillator = AKFMOscillator()
        oscillator.waveform = AKTable.standardSineWave()
        oscillator.baseFrequency = frequency
        oscillator.amplitude = adsr

        setAudioOutput(oscillator)
    }
}
