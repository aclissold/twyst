//
//  Note.swift
//  Twyst
//
//  Created by Andrew Clissold on 9/12/15.
//  Copyright © 2015 Andrew Clissold. All rights reserved.
//

import Foundation

enum Note: CGFloat, RawRepresentable, CustomStringConvertible {
    /*case C0 = 16.35
    case Cs0 = 17.32
    case D0 = 18.35
    case Ds0 = 19.45
    case E0 = 20.60
    case F0 = 21.83
    case Fs0 = 23.12
    case G0 = 24.50
    case Gs0 = 25.96
    case A0 = 27.50
    case As0 = 29.14
    case B0 = 30.87
    case C1 = 32.70
    case Cs1 = 34.65
    case D1 = 36.71
    case Ds1 = 38.89
    case E1 = 41.20
    case F1 = 43.65
    case Fs1 = 46.25
    case G1 = 49.00
    case Gs1 = 51.91
    case A1 = 55.00
    case As1 = 58.27
    case B1 = 61.74
    case C2 = 65.41,
    case Cs2 = 69.30
    case D2 = 73.42
    case Ds2 = 77.78
    case E2 = 82.41
    case F2 = 87.31
    case Fs2 = 92.50
    case G2 = 98.00
    case Gs2 = 103.83
    case A2 = 110.00
    case As2 = 116.54
    case B2 = 123.47
    case C3 = 130.81
    case Cs3 = 138.59
    case D3 = 146.83
    case Ds3 = 155.56
    case E3 = 164.81
    case F3 = 174.61
    case Fs3 = 185.00
    case G3 = 196.00
    case Gs3 = 207.65
    case A3 = 220.00
    case As3 = 233.08*/
    case B3 = 246.94
    case C = 261.63
    case Cs = 277.18
    case Df = 277.180001
    case D = 293.66
    case Ds = 311.13
    case Ef = 311.130001
    case E = 329.63
    case F = 349.23
    case Fs = 369.99
    case Gf = 369.990001
    case G = 392.00
    case Gs = 415.30
    case Af = 415.300001
    case A = 440.00
    case As = 466.16
    case Bf = 466.160001
    case B = 493.88
    case C5 = 523.25
    /*case Cs5 = 554.37
    case D5 = 587.33
    case Ds5 = 622.25
    case E5 = 659.25
    case F5 = 698.46
    case Fs5 = 739.99
    case G5 = 783.99
    case Gs5 = 830.61
    case A5 = 880.00
    case As5 = 932.33
    case B5 = 987.77
    case C6 = 1046.50
    case Cs6 = 1108.73
    case D6 = 1174.66
    case Ds6 = 1244.51
    case E6 = 1318.51
    case F6 = 1396.91
    case Fs6 = 1479.98
    case G6 = 1567.98
    case Gs6 = 1661.22
    case A6 = 1760.00
    case As6 = 1864.66
    case B6 = 1975.53
    case C7 = 2093.00
    case Cs7 = 2217.46
    case D7 = 2349.32
    case Ds7 = 2489.02
    case E7 = 2637.02
    case F7 = 2793.83
    case Fs7 = 2959.96
    case G7 = 3135.96
    case Gs7 = 3322.44
    case A7 = 3520.00
    case As7 = 3729.31
    case B7 = 3951.07
    case C8 = 4186.01
    case Cs8 = 4434.92
    case D8 = 4698.63
    case Ds8 = 4978.03
    case E8 = 5274.04
    case F8 = 5587.65
    case Fs8 = 5919.91
    case G8 = 6271.93
    case Gs8 = 6644.88
    case A8 = 7040.00
    case As8 = 7458.62
    case B8 = 7902.13*/

    var description: String {
        switch self {
        case B3: return "B"
        case C: return "C"
        case Cs: return "C♯"
        case Df: return "D♭"
        case D: return "D"
        case Ds: return "D♯"
        case Ef: return "E♭"
        case E: return "E"
        case F: return "F"
        case Fs: return "F♯"
        case Gf: return "G♭"
        case G: return "G"
        case Gs: return "G♯"
        case Af: return "A♭"
        case A: return "A"
        case As: return "A♯"
        case Bf: return "B♭"
        case B: return "B"
        case C5: return "C"
        }
    }

}
