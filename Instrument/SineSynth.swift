//
//  SineSynth.swift
//  Instrument
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

    override init() {
        super.init()

        addProperty(frequency)

        let adsr = AKADSREnvelope(
            attackDuration: 0.1.ak,
            decayDuration: 0.5.ak,
            sustainLevel: 0.7.ak,
            releaseDuration: 0.1.ak,
            delay: 0.ak
        )

        let oscillator = AKFMOscillator()
        oscillator.waveform = AKTable.standardSineWave()
        oscillator.baseFrequency = frequency
        oscillator.amplitude = adsr

        setAudioOutput(oscillator)
    }

    func play(noteCode: Int) {
        if noteCode == 1 {
            note = Note.C4
        } else if noteCode == 2 {
            note = Note.D4
        } else if noteCode == 4 {
            note = Note.E4
        } else if noteCode == 3 {
            note = Note.F4
        } else if noteCode == 5 {
            note = Note.G4
        } else if noteCode == 6 {
            note = Note.A4
        } else if noteCode == 7 {
            note = Note.B4
        }

        frequency.value = note.rawValue
        self.play()
    }
}
