//
//  SineSynth.swift
//  Instrument
//
//  Created by Andrew Clissold on 9/12/15.
//  Copyright © 2015 Andrew Clissold. All rights reserved.
//

class SineSynth: AKInstrument {

    override init() {
        super.init()

        let oscillator = AKFMOscillator(
            waveform: AKTable.standardSineWave(),
            baseFrequency: akp(440),
            carrierMultiplier: akp(1),
            modulatingMultiplier: akp(1),
            modulationIndex: akp(1),
            amplitude: akp(0.2))

        setAudioOutput(oscillator)
    }
}
