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

    let noteCodeMappings = [
        1: Note.C4, 2: .D4, 3: .F4, 4: .E4, 5: .G4, 6: .A4, 7: .B4
    ]
    func play(noteCode: Int) {
        guard let note = noteCodeMappings[noteCode] else {
            fatalError("unexpected noteCode: \(noteCode)")
        }

        frequency.value = note.rawValue
        self.play()
    }
}
