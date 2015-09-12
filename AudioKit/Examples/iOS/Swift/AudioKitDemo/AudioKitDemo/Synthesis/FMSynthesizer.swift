//
//  FMSynthesizer.swift
//  AudioKitDemo
//
//  Created by Nicholas Arner on 3/1/15.
//  Copyright (c) 2015 AudioKit. All rights reserved.
//

class FMSynthesizer: AKInstrument{
    
    override init() {
        super.init()
        
        // Note Properties
        var note = FMSynthesizerNote()
        
        let envelope = AKADSREnvelope(
            attackDuration:  0.1.ak,
            decayDuration:   0.1.ak,
            sustainLevel:    0.5.ak,
            releaseDuration: 0.3.ak,
            delay: 0.ak
        )
        
        var oscillator = AKFMOscillator()
        oscillator.baseFrequency        = note.frequency
        oscillator.carrierMultiplier    = note.color.scaledBy(2.ak)
        oscillator.modulatingMultiplier = note.color.scaledBy(3.ak)
        oscillator.modulationIndex      = note.color.scaledBy(10.ak)
        oscillator.amplitude            = envelope.scaledBy(0.25.ak)
        
        AKManager.sharedManager().isLogging = true
        let square = AKTable.standardSquareWave()
        let point = AKTableValue(table: square, atFractionOfTotalWidth: akp(0.25))
        enableParameterLog("Square wave value at 0.25 expect 1 = ", parameter: point, timeInterval: 100)

        setAudioOutput(oscillator)
    }
}



class FMSynthesizerNote: AKNote {
    
    // Note Properties
    var frequency = AKNoteProperty(value: 440, minimum: 100, maximum: 20000)
    var color = AKNoteProperty(value: 0, minimum: 0, maximum: 1)
    
    override init() {
        super.init()
        addProperty(frequency)
        addProperty(color)
        
        // Optionally set a default note duration
        duration.value = 1.0
    }
    
    convenience init(frequency:Float, color:Float){
        self.init()
        
        self.frequency.value = frequency
        self.color.value = color
    }
}